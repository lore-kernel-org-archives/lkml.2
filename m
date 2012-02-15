Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761471Ab2BOBRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 20:17:14 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:43546 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761447Ab2BOBOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 20:14:06 -0500
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: vm-crosstalk@vmware.com, dtor@vmware.com, cschamp@vmware.com,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [PATCH 10/14] Add accessor methods for Queue Pairs in VMCI
Date: Tue, 14 Feb 2012 17:05:51 -0800
Message-Id: <1329267955-32367-11-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
References: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/misc/vmw_vmci/vmciQPair.c | 1164 +++++++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmciQueue.h |  108 ++++
 2 files changed, 1272 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmciQPair.c
 create mode 100644 drivers/misc/vmw_vmci/vmciQueue.h

diff --git a/drivers/misc/vmw_vmci/vmciQPair.c b/drivers/misc/vmw_vmci/vmciQPair.c
new file mode 100644
index 0000000..3cb5dbd
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciQPair.c
@@ -0,0 +1,1164 @@
+/*
+ *
+ * VMware VMCI Driver
+ *
+ * Copyright (C) 2012 VMware, Inc. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation version 2 and no later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
+ *
+ *
+ *      This file implements Queue accessor methods.
+ *
+ *      VMCIQPair is a new interface that hides the queue pair internals.
+ *      Rather than access each queue in a pair directly, operations are now
+ *      performed on the queue as a whole.  This is simpler and less
+ *      error-prone, and allows for future queue pair features to be added
+ *      under the hood with no change to the client code.
+ *
+ *      This also helps in a particular case on Windows hosts, where the memory
+ *      allocated by the client (e.g., VMX) will disappear when the client does
+ *      (e.g., abnormal termination).  The kernel can't lock user memory into
+ *      its address space indefinitely.  By guarding access to the queue
+ *      contents we can correctly handle the case where the client disappears.
+ *
+ *      On code style:
+ *
+ *      + This entire file started its life as a cut-and-paste of the
+ *        static inline functions in bora/public/vmci_queue_pair.h.
+ *        From there, new copies of the routines were made named
+ *        without the prefix VMCI, without the underscore (the one
+ *        that followed struct vmci_queue_).  The no-underscore versions of
+ *        the routines require that the mutexes are held.
+ *
+ *      + The code -always- uses the xyzLocked() version of any given
+ *        routine even when the wrapped function is a one-liner.  The
+ *        reason for this decision was to ensure that we didn't have
+ *        copies of logic lying around that needed to be maintained.
+ *
+ *      + Note that we still pass around 'const struct vmci_queue *'s.
+ *
+ *      + Note that mutex is a field within struct vmci_queue.  We skirt the
+ *        issue of passing around a const struct vmci_queue, even though the
+ *        mutex field (__mutex, specifically) will get modified by not
+ *        ever referring to the mutex -itself- except during
+ *        initialization.  Beyond that, the code only passes the
+ *        pointer to the mutex, which is also a member of struct vmci_queue,
+ *        obviously, and which doesn't change after initialization.
+ *        This eliminates having to redefine all the functions that
+ *        are currently taking const struct vmci_queue's so that these
+ *        functions are compatible with those definitions.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+
+#include "vmci_defs.h"
+#include "vmci_kernel_if.h"
+#include "vmci_handle_array.h"
+#include "vmciKernelAPI.h"
+#include "vmciQueuePair.h"
+#include "vmciRoute.h"
+
+/*
+ * VMCIQPair
+ *
+ *      This structure is opaque to the clients.
+ */
+
+struct VMCIQPair {
+	struct vmci_handle handle;
+	struct vmci_queue *produceQ;
+	struct vmci_queue *consumeQ;
+	uint64_t produceQSize;
+	uint64_t consumeQSize;
+	uint32_t peer;
+	uint32_t flags;
+	uint32_t privFlags;
+	bool guestEndpoint;
+	uint32_t blocked;
+	wait_queue_head_t event;
+};
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPairMapQueueHeaders --
+ *
+ *      The queue headers may not be mapped at all times. If a queue is
+ *      currently not mapped, it will be attempted to do so.
+ *
+ * Results:
+ *      VMCI_SUCCESS if queues were validated, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      May attempt to map in guest memory.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int VMCIQPairMapQueueHeaders(struct vmci_queue *produceQ,	// IN
+				    struct vmci_queue *consumeQ)	// IN
+{
+	int result;
+
+	if (NULL == produceQ->qHeader || NULL == consumeQ->qHeader) {
+		result = VMCIHost_MapQueueHeaders(produceQ, consumeQ);
+		if (result < VMCI_SUCCESS) {
+			if (produceQ->savedHeader && consumeQ->savedHeader) {
+				return VMCI_ERROR_QUEUEPAIR_NOT_READY;
+			} else {
+				return VMCI_ERROR_QUEUEPAIR_NOTATTACHED;
+			}
+		}
+	}
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPairGetQueueHeaders --
+ *
+ *      Helper routine that will retrieve the produce and consume
+ *      headers of a given queue pair. If the guest memory of the
+ *      queue pair is currently not available, the saved queue headers
+ *      will be returned, if these are available.
+ *
+ * Results:
+ *      VMCI_SUCCESS if either current or saved queue headers are found.
+ *      Appropriate error code otherwise.
+ *
+ * Side effects:
+ *      May block.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int VMCIQPairGetQueueHeaders(const VMCIQPair * qpair,	// IN
+				    struct vmci_queue_header **produceQHeader,	// OUT
+				    struct vmci_queue_header **consumeQHeader)	// OUT
+{
+	int result;
+
+	result = VMCIQPairMapQueueHeaders(qpair->produceQ, qpair->consumeQ);
+	if (result == VMCI_SUCCESS) {
+		*produceQHeader = qpair->produceQ->qHeader;
+		*consumeQHeader = qpair->consumeQ->qHeader;
+	} else if (qpair->produceQ->savedHeader && qpair->consumeQ->savedHeader) {
+		ASSERT(!qpair->guestEndpoint);
+		*produceQHeader = qpair->produceQ->savedHeader;
+		*consumeQHeader = qpair->consumeQ->savedHeader;
+		result = VMCI_SUCCESS;
+	}
+
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPairWakeupCB --
+ *
+ *      Callback from VMCI queue pair broker indicating that a queue
+ *      pair that was previously not ready, now either is ready or
+ *      gone forever.
+ *
+ * Results:
+ *      VMCI_SUCCESS always.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int VMCIQPairWakeupCB(void *clientData)
+{
+	VMCIQPair *qpair = (VMCIQPair *) clientData;
+	ASSERT(qpair);
+
+	VMCI_AcquireQueueMutex(qpair->produceQ);
+	while (qpair->blocked > 0) {
+		qpair->blocked--;
+		wake_up(&qpair->event);
+	}
+	VMCI_ReleaseQueueMutex(qpair->produceQ);
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPairReleaseMutexCB --
+ *
+ *      Callback from VMCI_WaitOnEvent releasing the queue pair mutex
+ *      protecting the queue pair header state.
+ *
+ * Results:
+ *      0 always.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int VMCIQPairReleaseMutexCB(void *clientData)
+{
+	VMCIQPair *qpair = (VMCIQPair *) clientData;
+	ASSERT(qpair);
+	VMCI_ReleaseQueueMutex(qpair->produceQ);
+	return 0;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPairWaitForReadyQueue --
+ *
+ *      Makes the calling thread wait for the queue pair to become
+ *      ready for host side access.
+ *
+ * Results:
+ *     true when thread is woken up after queue pair state change.
+ *     false otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static bool VMCIQPairWaitForReadyQueue(VMCIQPair * qpair)
+{
+	if (unlikely(qpair->guestEndpoint))
+		ASSERT(false);
+
+	if (qpair->flags & VMCI_QPFLAG_NONBLOCK)
+		return false;
+
+	qpair->blocked++;
+	VMCI_WaitOnEvent(&qpair->event, VMCIQPairReleaseMutexCB, qpair);
+	VMCI_AcquireQueueMutex(qpair->produceQ);
+	return true;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_Alloc --
+ *
+ *      This is the client interface for allocating the memory for a
+ *      VMCIQPair structure and then attaching to the underlying
+ *      queue.  If an error occurs allocating the memory for the
+ *      VMCIQPair structure, no attempt is made to attach.  If an
+ *      error occurs attaching, then there's the VMCIQPair structure
+ *      is freed.
+ *
+ * Results:
+ *      An err, if < 0.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIQPair_Alloc(VMCIQPair ** qpair,	// OUT
+		    struct vmci_handle *handle,	// OUT
+		    uint64_t produceQSize,	// IN
+		    uint64_t consumeQSize,	// IN
+		    uint32_t peer,	// IN
+		    uint32_t flags,	// IN
+		    uint32_t privFlags)	// IN
+{
+	VMCIQPair *myQPair;
+	int retval;
+	struct vmci_handle src = VMCI_INVALID_HANDLE;
+	struct vmci_handle dst = VMCI_MAKE_HANDLE(peer, VMCI_INVALID_ID);
+	enum vmci_route route;
+	VMCIEventReleaseCB wakeupCB;
+	void *clientData;
+
+	/*
+	 * Restrict the size of a queuepair.  The device already enforces a limit
+	 * on the total amount of memory that can be allocated to queuepairs for a
+	 * guest.  However, we try to allocate this memory before we make the
+	 * queuepair allocation hypercall.  On Windows and Mac OS, we request a
+	 * single, continguous block, and it will fail if the OS cannot satisfy the
+	 * request. On Linux, we allocate each page separately, which means rather
+	 * than fail, the guest will thrash while it tries to allocate, and will
+	 * become increasingly unresponsive to the point where it appears to be hung.
+	 * So we place a limit on the size of an individual queuepair here, and
+	 * leave the device to enforce the restriction on total queuepair memory.
+	 * (Note that this doesn't prevent all cases; a user with only this much
+	 * physical memory could still get into trouble.)  The error used by the
+	 * device is NO_RESOURCES, so use that here too.
+	 */
+
+	if (produceQSize + consumeQSize < max(produceQSize, consumeQSize)
+	    || produceQSize + consumeQSize > VMCI_MAX_GUEST_QP_MEMORY)
+		return VMCI_ERROR_NO_RESOURCES;
+
+	myQPair = kmalloc(sizeof *myQPair, GFP_KERNEL);
+	if (!myQPair)
+		return VMCI_ERROR_NO_MEM;
+
+	memset(myQPair, 0, sizeof *myQPair);
+	myQPair->produceQSize = produceQSize;
+	myQPair->consumeQSize = consumeQSize;
+	myQPair->peer = peer;
+	myQPair->flags = flags;
+	myQPair->privFlags = privFlags;
+	retval = VMCI_Route(&src, &dst, false, &route);
+	if (retval < VMCI_SUCCESS) {
+		if (VMCI_GuestPersonalityActive()) {
+			route = VMCI_ROUTE_AS_GUEST;
+		} else {
+			route = VMCI_ROUTE_AS_HOST;
+		}
+	}
+
+	wakeupCB = clientData = NULL;
+	if (VMCI_ROUTE_AS_HOST == route) {
+		myQPair->guestEndpoint = false;
+		if (!(flags & VMCI_QPFLAG_LOCAL)) {
+			myQPair->blocked = 0;
+			init_waitqueue_head(&myQPair->event);
+			wakeupCB = VMCIQPairWakeupCB;
+			clientData = (void *)myQPair;
+		}
+	} else {
+		myQPair->guestEndpoint = true;
+	}
+
+	retval = VMCIQueuePair_Alloc(handle,
+				     &myQPair->produceQ,
+				     myQPair->produceQSize,
+				     &myQPair->consumeQ,
+				     myQPair->consumeQSize,
+				     myQPair->peer,
+				     myQPair->flags,
+				     myQPair->privFlags,
+				     myQPair->guestEndpoint,
+				     wakeupCB, clientData);
+
+	if (retval < VMCI_SUCCESS) {
+		kfree(myQPair);
+		return retval;
+	}
+
+	*qpair = myQPair;
+	myQPair->handle = *handle;
+
+	return retval;
+}
+
+EXPORT_SYMBOL(VMCIQPair_Alloc);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_Detach --
+ *
+ *      This is the client interface for detaching from a VMCIQPair.
+ *      Note that this routine will free the memory allocated for the
+ *      VMCIQPair structure, too.
+ *
+ * Results:
+ *      An error, if < 0.
+ *
+ * Side effects:
+ *      Will clear the caller's pointer to the VMCIQPair structure.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIQPair_Detach(VMCIQPair ** qpair)	// IN/OUT
+{
+	int result;
+	VMCIQPair *oldQPair;
+
+	if (!qpair || !(*qpair)) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	oldQPair = *qpair;
+	result =
+	    VMCIQueuePair_Detach(oldQPair->handle, oldQPair->guestEndpoint);
+
+	/*
+	 * The guest can fail to detach for a number of reasons, and if it does so,
+	 * it will cleanup the entry (if there is one).  The host can fail too, but
+	 * it won't cleanup the entry immediately, it will do that later when the
+	 * context is freed.  Either way, we need to release the qpair struct here;
+	 * there isn't much the caller can do, and we don't want to leak.
+	 */
+
+	memset(oldQPair, 0, sizeof *oldQPair);
+	oldQPair->handle = VMCI_INVALID_HANDLE;
+	oldQPair->peer = VMCI_INVALID_ID;
+	kfree(oldQPair);
+	*qpair = NULL;
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_Detach);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_GetProduceIndexes --
+ *
+ *      This is the client interface for getting the current indexes of the
+ *      QPair from the point of the view of the caller as the producer.
+ *
+ * Results:
+ *      err, if < 0
+ *      Success otherwise.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIQPair_GetProduceIndexes(const VMCIQPair * qpair,	// IN
+				uint64_t * producerTail,	// OUT
+				uint64_t * consumerHead)	// OUT
+{
+	struct vmci_queue_header *produceQHeader;
+	struct vmci_queue_header *consumeQHeader;
+	int result;
+
+	if (!qpair)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	VMCI_AcquireQueueMutex(qpair->produceQ);
+	result =
+	    VMCIQPairGetQueueHeaders(qpair, &produceQHeader, &consumeQHeader);
+	if (result == VMCI_SUCCESS)
+		VMCIQueueHeader_GetPointers(produceQHeader, consumeQHeader,
+					    producerTail, consumerHead);
+
+	VMCI_ReleaseQueueMutex(qpair->produceQ);
+
+	if (result == VMCI_SUCCESS &&
+	    ((producerTail && *producerTail >= qpair->produceQSize) ||
+	     (consumerHead && *consumerHead >= qpair->produceQSize)))
+		return VMCI_ERROR_INVALID_SIZE;
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_GetProduceIndexes);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_GetConsumeIndexes --
+ *
+ *      This is the client interface for getting the current indexes of the
+ *      QPair from the point of the view of the caller as the consumer.
+ *
+ * Results:
+ *      err, if < 0
+ *      Success otherwise.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIQPair_GetConsumeIndexes(const VMCIQPair * qpair,	// IN
+				uint64_t * consumerTail,	// OUT
+				uint64_t * producerHead)	// OUT
+{
+	struct vmci_queue_header *produceQHeader;
+	struct vmci_queue_header *consumeQHeader;
+	int result;
+
+	if (!qpair)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	VMCI_AcquireQueueMutex(qpair->produceQ);
+	result =
+	    VMCIQPairGetQueueHeaders(qpair, &produceQHeader, &consumeQHeader);
+	if (result == VMCI_SUCCESS)
+		VMCIQueueHeader_GetPointers(consumeQHeader, produceQHeader,
+					    consumerTail, producerHead);
+
+	VMCI_ReleaseQueueMutex(qpair->produceQ);
+
+	if (result == VMCI_SUCCESS &&
+	    ((consumerTail && *consumerTail >= qpair->consumeQSize) ||
+	     (producerHead && *producerHead >= qpair->consumeQSize)))
+		return VMCI_ERROR_INVALID_SIZE;
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_GetConsumeIndexes);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_ProduceFreeSpace --
+ *
+ *      This is the client interface for getting the amount of free
+ *      space in the QPair from the point of the view of the caller as
+ *      the producer which is the common case.
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Full queue if = 0.
+ *      Number of available bytes into which data can be enqueued if > 0.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int64_t VMCIQPair_ProduceFreeSpace(const VMCIQPair * qpair)	// IN
+{
+	struct vmci_queue_header *produceQHeader;
+	struct vmci_queue_header *consumeQHeader;
+	int64_t result;
+
+	if (!qpair)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	VMCI_AcquireQueueMutex(qpair->produceQ);
+	result =
+	    VMCIQPairGetQueueHeaders(qpair, &produceQHeader, &consumeQHeader);
+	if (result == VMCI_SUCCESS) {
+		result =
+		    VMCIQueueHeader_FreeSpace(produceQHeader,
+					      consumeQHeader,
+					      qpair->produceQSize);
+	} else {
+		result = 0;
+	}
+	VMCI_ReleaseQueueMutex(qpair->produceQ);
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_ProduceFreeSpace);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_ConsumeFreeSpace --
+ *
+ *      This is the client interface for getting the amount of free
+ *      space in the QPair from the point of the view of the caller as
+ *      the consumer which is not the common case (see
+ *      VMCIQPair_ProduceFreeSpace(), above).
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Full queue if = 0.
+ *      Number of available bytes into which data can be enqueued if > 0.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int64_t VMCIQPair_ConsumeFreeSpace(const VMCIQPair * qpair)	// IN
+{
+	struct vmci_queue_header *produceQHeader;
+	struct vmci_queue_header *consumeQHeader;
+	int64_t result;
+
+	if (!qpair)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	VMCI_AcquireQueueMutex(qpair->produceQ);
+	result =
+	    VMCIQPairGetQueueHeaders(qpair, &produceQHeader, &consumeQHeader);
+	if (result == VMCI_SUCCESS) {
+		result =
+		    VMCIQueueHeader_FreeSpace(consumeQHeader,
+					      produceQHeader,
+					      qpair->consumeQSize);
+	} else {
+		result = 0;
+	}
+	VMCI_ReleaseQueueMutex(qpair->produceQ);
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_ConsumeFreeSpace);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_ProduceBufReady --
+ *
+ *      This is the client interface for getting the amount of
+ *      enqueued data in the QPair from the point of the view of the
+ *      caller as the producer which is not the common case (see
+ *      VMCIQPair_ConsumeBufReady(), above).
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Empty queue if = 0.
+ *      Number of bytes ready to be dequeued if > 0.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int64_t VMCIQPair_ProduceBufReady(const VMCIQPair * qpair)	// IN
+{
+	struct vmci_queue_header *produceQHeader;
+	struct vmci_queue_header *consumeQHeader;
+	int64_t result;
+
+	if (!qpair)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	VMCI_AcquireQueueMutex(qpair->produceQ);
+	result =
+	    VMCIQPairGetQueueHeaders(qpair, &produceQHeader, &consumeQHeader);
+	if (result == VMCI_SUCCESS) {
+		result =
+		    VMCIQueueHeader_BufReady(produceQHeader,
+					     consumeQHeader,
+					     qpair->produceQSize);
+	} else {
+		result = 0;
+	}
+	VMCI_ReleaseQueueMutex(qpair->produceQ);
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_ProduceBufReady);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_ConsumeBufReady --
+ *
+ *      This is the client interface for getting the amount of
+ *      enqueued data in the QPair from the point of the view of the
+ *      caller as the consumer which is the normal case.
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Empty queue if = 0.
+ *      Number of bytes ready to be dequeued if > 0.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int64_t VMCIQPair_ConsumeBufReady(const VMCIQPair * qpair)	// IN
+{
+	struct vmci_queue_header *produceQHeader;
+	struct vmci_queue_header *consumeQHeader;
+	int64_t result;
+
+	if (!qpair)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	VMCI_AcquireQueueMutex(qpair->produceQ);
+	result =
+	    VMCIQPairGetQueueHeaders(qpair, &produceQHeader, &consumeQHeader);
+	if (result == VMCI_SUCCESS) {
+		result =
+		    VMCIQueueHeader_BufReady(consumeQHeader,
+					     produceQHeader,
+					     qpair->consumeQSize);
+	} else {
+		result = 0;
+	}
+	VMCI_ReleaseQueueMutex(qpair->produceQ);
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_ConsumeBufReady);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * EnqueueLocked --
+ *
+ *      Enqueues a given buffer to the produce queue using the provided
+ *      function. As many bytes as possible (space available in the queue)
+ *      are enqueued.
+ *
+ *      Assumes the queue->mutex has been acquired.
+ *
+ * Results:
+ *      VMCI_ERROR_QUEUEPAIR_NOSPACE if no space was available to enqueue data.
+ *      VMCI_ERROR_INVALID_SIZE, if any queue pointer is outside the queue
+ *      (as defined by the queue size).
+ *      VMCI_ERROR_INVALID_ARGS, if an error occured when accessing the buffer.
+ *      VMCI_ERROR_QUEUEPAIR_NOTATTACHED, if the queue pair pages aren't
+ *      available.
+ *      Otherwise, the number of bytes written to the queue is returned.
+ *
+ * Side effects:
+ *      Updates the tail pointer of the produce queue.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static inline ssize_t EnqueueLocked(struct vmci_queue *produceQ,	// IN
+				    struct vmci_queue *consumeQ,	// IN
+				    const uint64_t produceQSize,	// IN
+				    const void *buf,	// IN
+				    size_t bufSize,	// IN
+				    int bufType,	// IN
+				    VMCIMemcpyToQueueFunc memcpyToQueue)	// IN
+{
+	int64_t freeSpace;
+	uint64_t tail;
+	size_t written;
+	ssize_t result;
+
+	result = VMCIQPairMapQueueHeaders(produceQ, consumeQ);
+	if (unlikely(result != VMCI_SUCCESS))
+		return result;
+
+	freeSpace = VMCIQueueHeader_FreeSpace(produceQ->qHeader,
+					      consumeQ->qHeader, produceQSize);
+	if (freeSpace == 0)
+		return VMCI_ERROR_QUEUEPAIR_NOSPACE;
+
+	if (freeSpace < VMCI_SUCCESS)
+		return (ssize_t) freeSpace;
+
+	written = (size_t) (freeSpace > bufSize ? bufSize : freeSpace);
+	tail = VMCIQueueHeader_ProducerTail(produceQ->qHeader);
+	if (likely(tail + written < produceQSize)) {
+		result =
+		    memcpyToQueue(produceQ, tail, buf, 0, written, bufType);
+	} else {
+		/* Tail pointer wraps around. */
+
+		const size_t tmp = (size_t) (produceQSize - tail);
+
+		result = memcpyToQueue(produceQ, tail, buf, 0, tmp, bufType);
+		if (result >= VMCI_SUCCESS) {
+			result =
+			    memcpyToQueue(produceQ, 0, buf, tmp,
+					  written - tmp, bufType);
+		}
+	}
+
+	if (result < VMCI_SUCCESS) {
+		return result;
+	}
+
+	VMCIQueueHeader_AddProducerTail(produceQ->qHeader, written,
+					produceQSize);
+	return written;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * DequeueLocked --
+ *
+ *      Dequeues data (if available) from the given consume queue. Writes data
+ *      to the user provided buffer using the provided function.
+ *
+ *      Assumes the queue->mutex has been acquired.
+ *
+ * Results:
+ *      VMCI_ERROR_QUEUEPAIR_NODATA if no data was available to dequeue.
+ *      VMCI_ERROR_INVALID_SIZE, if any queue pointer is outside the queue
+ *      (as defined by the queue size).
+ *      VMCI_ERROR_INVALID_ARGS, if an error occured when accessing the buffer.
+ *      Otherwise the number of bytes dequeued is returned.
+ *
+ * Side effects:
+ *      Updates the head pointer of the consume queue.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static inline ssize_t DequeueLocked(struct vmci_queue *produceQ,	// IN
+				    struct vmci_queue *consumeQ,	// IN
+				    const uint64_t consumeQSize,	// IN
+				    void *buf,	// IN
+				    size_t bufSize,	// IN
+				    int bufType,	// IN
+				    VMCIMemcpyFromQueueFunc memcpyFromQueue,	// IN
+				    bool updateConsumer)	// IN
+{
+	int64_t bufReady;
+	uint64_t head;
+	size_t read;
+	ssize_t result;
+
+	result = VMCIQPairMapQueueHeaders(produceQ, consumeQ);
+	if (unlikely(result != VMCI_SUCCESS))
+		return result;
+
+	bufReady = VMCIQueueHeader_BufReady(consumeQ->qHeader,
+					    produceQ->qHeader, consumeQSize);
+	if (bufReady == 0)
+		return VMCI_ERROR_QUEUEPAIR_NODATA;
+
+	if (bufReady < VMCI_SUCCESS)
+		return (ssize_t) bufReady;
+
+	read = (size_t) (bufReady > bufSize ? bufSize : bufReady);
+	head = VMCIQueueHeader_ConsumerHead(produceQ->qHeader);
+	if (likely(head + read < consumeQSize)) {
+		result = memcpyFromQueue(buf, 0, consumeQ, head, read, bufType);
+	} else {
+		/* Head pointer wraps around. */
+
+		const size_t tmp = (size_t) (consumeQSize - head);
+
+		result = memcpyFromQueue(buf, 0, consumeQ, head, tmp, bufType);
+		if (result >= VMCI_SUCCESS) {
+			result =
+			    memcpyFromQueue(buf, tmp, consumeQ, 0,
+					    read - tmp, bufType);
+		}
+	}
+
+	if (result < VMCI_SUCCESS)
+		return result;
+
+	if (updateConsumer) {
+		VMCIQueueHeader_AddConsumerHead(produceQ->qHeader,
+						read, consumeQSize);
+	}
+
+	return read;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_Enqueue --
+ *
+ *      This is the client interface for enqueueing data into the queue.
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Number of bytes enqueued if >= 0.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+ssize_t VMCIQPair_Enqueue(VMCIQPair * qpair,	// IN
+			  const void *buf,	// IN
+			  size_t bufSize,	// IN
+			  int bufType)	// IN
+{
+	ssize_t result;
+
+	if (!qpair || !buf)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	VMCI_AcquireQueueMutex(qpair->produceQ);
+
+	do {
+		result = EnqueueLocked(qpair->produceQ,
+				       qpair->consumeQ,
+				       qpair->produceQSize,
+				       buf, bufSize, bufType,
+				       qpair->flags & VMCI_QPFLAG_LOCAL ?
+				       VMCIMemcpyToQueueLocal :
+				       VMCIMemcpyToQueue);
+		if (result == VMCI_ERROR_QUEUEPAIR_NOT_READY) {
+			if (!VMCIQPairWaitForReadyQueue(qpair)) {
+				result = VMCI_ERROR_WOULD_BLOCK;
+			}
+		}
+	} while (result == VMCI_ERROR_QUEUEPAIR_NOT_READY);
+
+	VMCI_ReleaseQueueMutex(qpair->produceQ);
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_Enqueue);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_Dequeue --
+ *
+ *      This is the client interface for dequeueing data from the queue.
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Number of bytes dequeued if >= 0.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+ssize_t VMCIQPair_Dequeue(VMCIQPair * qpair,	// IN
+			  void *buf,	// IN
+			  size_t bufSize,	// IN
+			  int bufType)	// IN
+{
+	ssize_t result;
+
+	if (!qpair || !buf)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	VMCI_AcquireQueueMutex(qpair->produceQ);
+
+	do {
+		result = DequeueLocked(qpair->produceQ,
+				       qpair->consumeQ,
+				       qpair->consumeQSize,
+				       buf, bufSize, bufType,
+				       qpair->flags & VMCI_QPFLAG_LOCAL ?
+				       VMCIMemcpyFromQueueLocal :
+				       VMCIMemcpyFromQueue, true);
+		if (result == VMCI_ERROR_QUEUEPAIR_NOT_READY) {
+			if (!VMCIQPairWaitForReadyQueue(qpair)) {
+				result = VMCI_ERROR_WOULD_BLOCK;
+			}
+		}
+	} while (result == VMCI_ERROR_QUEUEPAIR_NOT_READY);
+
+	VMCI_ReleaseQueueMutex(qpair->produceQ);
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_Dequeue);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_Peek --
+ *
+ *      This is the client interface for peeking into a queue.  (I.e.,
+ *      copy data from the queue without updating the head pointer.)
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Number of bytes peeked, if >= 0.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+ssize_t VMCIQPair_Peek(VMCIQPair * qpair,	// IN
+		       void *buf,	// IN
+		       size_t bufSize,	// IN
+		       int bufType)	// IN
+{
+	ssize_t result;
+
+	if (!qpair || !buf)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	VMCI_AcquireQueueMutex(qpair->produceQ);
+
+	do {
+		result = DequeueLocked(qpair->produceQ,
+				       qpair->consumeQ,
+				       qpair->consumeQSize,
+				       buf, bufSize, bufType,
+				       qpair->flags & VMCI_QPFLAG_LOCAL ?
+				       VMCIMemcpyFromQueueLocal :
+				       VMCIMemcpyFromQueue, false);
+		if (result == VMCI_ERROR_QUEUEPAIR_NOT_READY) {
+			if (!VMCIQPairWaitForReadyQueue(qpair)) {
+				result = VMCI_ERROR_WOULD_BLOCK;
+			}
+		}
+	} while (result == VMCI_ERROR_QUEUEPAIR_NOT_READY);
+
+	VMCI_ReleaseQueueMutex(qpair->produceQ);
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_Peek);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_EnqueueV --
+ *
+ *      This is the client interface for enqueueing data into the queue.
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Number of bytes enqueued if >= 0.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+ssize_t VMCIQPair_EnqueueV(VMCIQPair * qpair,	// IN
+			   void *iov,	// IN
+			   size_t iovSize,	// IN
+			   int bufType)	// IN
+{
+	ssize_t result;
+
+	if (!qpair || !iov)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	VMCI_AcquireQueueMutex(qpair->produceQ);
+
+	do {
+		result = EnqueueLocked(qpair->produceQ,
+				       qpair->consumeQ,
+				       qpair->produceQSize,
+				       iov, iovSize, bufType,
+				       VMCIMemcpyToQueueV);
+		if (result == VMCI_ERROR_QUEUEPAIR_NOT_READY) {
+			if (!VMCIQPairWaitForReadyQueue(qpair)) {
+				result = VMCI_ERROR_WOULD_BLOCK;
+			}
+		}
+	} while (result == VMCI_ERROR_QUEUEPAIR_NOT_READY);
+
+	VMCI_ReleaseQueueMutex(qpair->produceQ);
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_EnqueueV);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_DequeueV --
+ *
+ *      This is the client interface for dequeueing data from the queue.
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Number of bytes dequeued if >= 0.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+ssize_t VMCIQPair_DequeueV(VMCIQPair * qpair,	// IN
+			   void *iov,	// IN
+			   size_t iovSize,	// IN
+			   int bufType)	// IN
+{
+	ssize_t result;
+
+	VMCI_AcquireQueueMutex(qpair->produceQ);
+
+	if (!qpair || !iov)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	do {
+		result = DequeueLocked(qpair->produceQ,
+				       qpair->consumeQ,
+				       qpair->consumeQSize,
+				       iov, iovSize, bufType,
+				       VMCIMemcpyFromQueueV, true);
+		if (result == VMCI_ERROR_QUEUEPAIR_NOT_READY) {
+			if (!VMCIQPairWaitForReadyQueue(qpair)) {
+				result = VMCI_ERROR_WOULD_BLOCK;
+			}
+		}
+	} while (result == VMCI_ERROR_QUEUEPAIR_NOT_READY);
+
+	VMCI_ReleaseQueueMutex(qpair->produceQ);
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_DequeueV);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_PeekV --
+ *
+ *      This is the client interface for peeking into a queue.  (I.e.,
+ *      copy data from the queue without updating the head pointer.)
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Number of bytes peeked, if >= 0.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+ssize_t VMCIQPair_PeekV(VMCIQPair * qpair,	// IN
+			void *iov,	// IN
+			size_t iovSize,	// IN
+			int bufType)	// IN
+{
+	ssize_t result;
+
+	if (!qpair || !iov)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	VMCI_AcquireQueueMutex(qpair->produceQ);
+
+	do {
+		result = DequeueLocked(qpair->produceQ,
+				       qpair->consumeQ,
+				       qpair->consumeQSize,
+				       iov, iovSize, bufType,
+				       VMCIMemcpyFromQueueV, false);
+		if (result == VMCI_ERROR_QUEUEPAIR_NOT_READY) {
+			if (!VMCIQPairWaitForReadyQueue(qpair)) {
+				result = VMCI_ERROR_WOULD_BLOCK;
+			}
+		}
+	} while (result == VMCI_ERROR_QUEUEPAIR_NOT_READY);
+
+	VMCI_ReleaseQueueMutex(qpair->produceQ);
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_PeekV);
diff --git a/drivers/misc/vmw_vmci/vmciQueue.h b/drivers/misc/vmw_vmci/vmciQueue.h
new file mode 100644
index 0000000..1d7c17c
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciQueue.h
@@ -0,0 +1,108 @@
+/*
+ *
+ * VMware VMCI Driver
+ *
+ * Copyright (C) 2012 VMware, Inc. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation version 2 and no later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
+ */
+
+#ifndef _VMCI_QUEUE_H_
+#define _VMCI_QUEUE_H_
+
+/*
+ * struct vmci_queue
+ *
+ * This data type contains the information about a queue.
+ *
+ * There are two queues (hence, queue pairs) per transaction model between a
+ * pair of end points, A & B.  One queue is used by end point A to transmit
+ * commands and responses to B.  The other queue is used by B to transmit
+ * commands and responses.
+ *
+ * struct vmci_queue_kern_if is a per-OS defined Queue structure.  It contains either a
+ * direct pointer to the linear address of the buffer contents or a pointer to
+ * structures which help the OS locate those data pages.  See vmciKernelIf.c
+ * for each platform for its definition.
+ */
+
+struct vmci_queue {
+	struct vmci_queue_header *qHeader;
+	struct vmci_queue_header *savedHeader;
+	struct vmci_queue_kern_if *kernelIf;
+};
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIMemcpy{To,From}QueueFunc() prototypes.  Functions of these
+ * types are passed around to enqueue and dequeue routines.  Note that
+ * often the functions passed are simply wrappers around memcpy
+ * itself.
+ *
+ * Note: In order for the memcpy typedefs to be compatible with the VMKernel,
+ * there's an unused last parameter for the hosted side.  In
+ * ESX, that parameter holds a buffer type.
+ *
+ *-----------------------------------------------------------------------------
+ */
+typedef int VMCIMemcpyToQueueFunc(struct vmci_queue *queue,
+				  uint64_t queueOffset, const void *src,
+				  size_t srcOffset, size_t size, int bufType);
+typedef int VMCIMemcpyFromQueueFunc(void *dest, size_t destOffset,
+				    const struct vmci_queue *queue,
+				    uint64_t queueOffset, size_t size,
+				    int bufType);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIMemcpy{To,From}Queue[v]() prototypes
+ *
+ * Note that these routines are NOT SAFE to call on a host end-point
+ * until the guest end of the queue pair has attached -AND-
+ * SetPageStore().  The VMX crosstalk device will issue the
+ * SetPageStore() on behalf of the guest when the guest creates a
+ * QueuePair or attaches to one created by the host.  So, if the guest
+ * notifies the host that it's attached then the queue is safe to use.
+ * Also, if the host registers notification of the connection of the
+ * guest, then it will only receive that notification when the guest
+ * has issued the SetPageStore() call and not before (when the guest
+ * had attached).
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIMemcpyToQueue(struct vmci_queue *queue, uint64_t queueOffset,
+		      const void *src, size_t srcOffset, size_t size,
+		      int bufType);
+int VMCIMemcpyFromQueue(void *dest, size_t destOffset,
+			const struct vmci_queue *queue,
+			uint64_t queueOffset, size_t size, int bufType);
+
+int VMCIMemcpyToQueueLocal(struct vmci_queue *queue, uint64_t queueOffset,
+			   const void *src, size_t srcOffset, size_t size,
+			   int bufType);
+int VMCIMemcpyFromQueueLocal(void *dest, size_t destOffset,
+			     const struct vmci_queue *queue,
+			     uint64_t queueOffset, size_t size, int bufType);
+
+int VMCIMemcpyToQueueV(struct vmci_queue *queue, uint64_t queueOffset,
+		       const void *src, size_t srcOffset, size_t size,
+		       int bufType);
+int VMCIMemcpyFromQueueV(void *dest, size_t destOffset,
+			 const struct vmci_queue *queue,
+			 uint64_t queueOffset, size_t size, int bufType);
+
+#endif				/* !_VMCI_QUEUE_H_ */
-- 
1.7.0.4

