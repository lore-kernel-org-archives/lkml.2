Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483Ab2BOBOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 20:14:48 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:43568 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761449Ab2BOBOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 20:14:07 -0500
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: vm-crosstalk@vmware.com, dtor@vmware.com, cschamp@vmware.com,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [PATCH 01/14] Add vmciContext.*
Date: Tue, 14 Feb 2012 17:05:42 -0800
Message-Id: <1329267955-32367-2-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
References: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/misc/vmw_vmci/vmciContext.c | 1763 +++++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmciContext.h |   77 ++
 2 files changed, 1840 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmciContext.c
 create mode 100644 drivers/misc/vmw_vmci/vmciContext.h

diff --git a/drivers/misc/vmw_vmci/vmciContext.c b/drivers/misc/vmw_vmci/vmciContext.c
new file mode 100644
index 0000000..f252927
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciContext.c
@@ -0,0 +1,1763 @@
+/*
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+
+#include "vmci_defs.h"
+#include "vmci_kernel_if.h"
+#include "vmci_infrastructure.h"
+#include "vmciCommonInt.h"
+#include "vmciContext.h"
+#include "vmciDatagram.h"
+#include "vmciDoorbell.h"
+#include "vmciDriver.h"
+#include "vmciEvent.h"
+#include "vmciKernelAPI.h"
+#include "vmciQueuePair.h"
+
+#define LGPFX "VMCIContext: "
+
+/* List of current VMCI contexts. */
+static struct {
+	struct list_head head;
+	spinlock_t lock;
+	spinlock_t firingLock;
+} contextList;
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContextSignalNotify --
+ *
+ *      Sets the notify flag to true.  Assumes that the context lock is
+ *      held.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static inline void VMCIContextSignalNotify(struct vmci_context *context)
+{
+	if (context->notify)
+		*context->notify = true;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContextClearNotify --
+ *
+ *      Sets the notify flag to false.  Assumes that the context lock is
+ *      held.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static inline void VMCIContextClearNotify(struct vmci_context *context)
+{
+	if (context->notify)
+		*context->notify = false;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContextClearNotifyAndCall --
+ *
+ *      If nothing requires the attention of the guest, clears both
+ *      notify flag and call.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static inline void VMCIContextClearNotifyAndCall(struct vmci_context *context)
+{
+	if (context->pendingDatagrams == 0 &&
+	    VMCIHandleArray_GetSize(context->pendingDoorbellArray) == 0)
+		VMCIContextClearNotify(context);
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_CheckAndSignalNotify --
+ *
+ *      Sets the context's notify flag iff datagrams are pending for this
+ *      context.  Called from VMCISetupNotify().
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+void VMCIContext_CheckAndSignalNotify(struct vmci_context *context)
+{
+	ASSERT(context);
+
+	spin_lock(&contextList.lock);
+	if (context->pendingDatagrams)
+		VMCIContextSignalNotify(context);
+	spin_unlock(&contextList.lock);
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_Init --
+ *
+ *      Initializes the VMCI context module.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int VMCIContext_Init(void)
+{
+	INIT_LIST_HEAD(&contextList.head);
+
+	spin_lock_init(&contextList.lock);
+	spin_lock_init(&contextList.firingLock);
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContextExists --
+ *
+ *      Internal helper to check if a context with the specified context
+ *      ID exists. Assumes the contextList.lock is held.
+ *
+ * Results:
+ *      true if a context exists with the given cid.
+ *      false otherwise
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static bool VMCIContextExists(uint32_t cid)	// IN
+{
+	struct vmci_context *context;
+
+	list_for_each_entry(context, &contextList.head, listItem) {
+		if (context->cid == cid)
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_InitContext --
+ *
+ *      Allocates and initializes a VMCI context.
+ *
+ * Results:
+ *      Returns 0 on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int
+VMCIContext_InitContext(uint32_t cid,
+			uint32_t privFlags,
+			uintptr_t eventHnd,
+			int userVersion,
+			uid_t * user, struct vmci_context **outContext)
+{
+	struct vmci_context *context;
+	int result;
+
+	if (privFlags & ~VMCI_PRIVILEGE_ALL_FLAGS) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Invalid flag (flags=0x%x) for VMCI context.\n",
+				privFlags));
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	if (userVersion == 0)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	context = kmalloc(sizeof *context, GFP_KERNEL);
+	if (context == NULL) {
+		VMCI_WARNING((LGPFX
+			      "Failed to allocate memory for VMCI context.\n"));
+		return VMCI_ERROR_NO_MEM;
+	}
+	memset(context, 0, sizeof *context);
+
+	INIT_LIST_HEAD(&context->listItem);
+	INIT_LIST_HEAD(&context->datagramQueue);
+
+	context->userVersion = userVersion;
+
+	context->queuePairArray = VMCIHandleArray_Create(0);
+	if (!context->queuePairArray) {
+		result = VMCI_ERROR_NO_MEM;
+		goto error;
+	}
+
+	context->doorbellArray = VMCIHandleArray_Create(0);
+	if (!context->doorbellArray) {
+		result = VMCI_ERROR_NO_MEM;
+		goto error;
+	}
+
+	context->pendingDoorbellArray = VMCIHandleArray_Create(0);
+	if (!context->pendingDoorbellArray) {
+		result = VMCI_ERROR_NO_MEM;
+		goto error;
+	}
+
+	context->notifierArray = VMCIHandleArray_Create(0);
+	if (context->notifierArray == NULL) {
+		result = VMCI_ERROR_NO_MEM;
+		goto error;
+	}
+
+	spin_lock_init(&context->lock);
+
+	atomic_set(&context->refCount, 1);
+
+	/* Inititialize host-specific VMCI context. */
+	init_waitqueue_head(&context->hostContext.waitQueue);
+
+	context->privFlags = privFlags;
+
+	/*
+	 * If we collide with an existing context we generate a new and use it
+	 * instead. The VMX will determine if regeneration is okay. Since there
+	 * isn't 4B - 16 VMs running on a given host, the below loop will terminate.
+	 */
+	spin_lock(&contextList.lock);
+	ASSERT(cid != VMCI_INVALID_ID);
+	while (VMCIContextExists(cid)) {
+
+		/*
+		 * If the cid is below our limit and we collide we are creating duplicate
+		 * contexts internally so we want to assert fail in that case.
+		 */
+		ASSERT(cid >= VMCI_RESERVED_CID_LIMIT);
+
+		/* We reserve the lowest 16 ids for fixed contexts. */
+		cid = max(cid, VMCI_RESERVED_CID_LIMIT - 1) + 1;
+		if (cid == VMCI_INVALID_ID) {
+			cid = VMCI_RESERVED_CID_LIMIT;
+		}
+	}
+	ASSERT(!VMCIContextExists(cid));
+	context->cid = cid;
+	context->validUser = user != NULL;
+	if (context->validUser) {
+		context->user = *user;
+	}
+	list_add(&context->listItem, &contextList.head);
+	spin_unlock(&contextList.lock);
+
+	context->notify = NULL;
+	context->notifyPage = NULL;
+
+	*outContext = context;
+	return VMCI_SUCCESS;
+
+ error:
+	if (context->notifierArray) {
+		VMCIHandleArray_Destroy(context->notifierArray);
+	}
+	if (context->queuePairArray) {
+		VMCIHandleArray_Destroy(context->queuePairArray);
+	}
+	if (context->doorbellArray) {
+		VMCIHandleArray_Destroy(context->doorbellArray);
+	}
+	if (context->pendingDoorbellArray) {
+		VMCIHandleArray_Destroy(context->pendingDoorbellArray);
+	}
+	kfree(context);
+	return result;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_ReleaseContext --
+ *
+ *      Cleans up a VMCI context.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+void VMCIContext_ReleaseContext(struct vmci_context *context)	// IN
+{
+	/* Dequeue VMCI context. */
+
+	spin_lock(&contextList.lock);
+	list_del(&context->listItem);
+	spin_unlock(&contextList.lock);
+
+	VMCIContext_Release(context);
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContextFireNotification --
+ *
+ *      Fire notification for all contexts interested in given cid.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static int VMCIContextFireNotification(uint32_t contextID,	// IN
+				       uint32_t privFlags)	// IN
+{
+	uint32_t i, arraySize;
+	struct vmci_context *subCtx;
+	struct vmci_handle_arr *subscriberArray;
+	struct vmci_handle contextHandle =
+	    VMCI_MAKE_HANDLE(contextID, VMCI_EVENT_HANDLER);
+
+	/*
+	 * We create an array to hold the subscribers we find when scanning through
+	 * all contexts.
+	 */
+	subscriberArray = VMCIHandleArray_Create(0);
+	if (subscriberArray == NULL) {
+		return VMCI_ERROR_NO_MEM;
+	}
+
+	/*
+	 * Scan all contexts to find who is interested in being notified about
+	 * given contextID. We have a special firingLock that we use to synchronize
+	 * across all notification operations. This avoids us having to take the
+	 * context lock for each HasEntry call and it solves a lock ranking issue.
+	 */
+	spin_lock(&contextList.firingLock);
+	spin_lock(&contextList.lock);
+	list_for_each_entry(subCtx, &contextList.head, listItem) {
+		/*
+		 * We only deliver notifications of the removal of contexts, if
+		 * the two contexts are allowed to interact.
+		 */
+		if (VMCIHandleArray_HasEntry
+		    (subCtx->notifierArray, contextHandle)
+		    && !VMCIDenyInteraction(privFlags, subCtx->privFlags)) {
+			VMCIHandleArray_AppendEntry(&subscriberArray,
+						    VMCI_MAKE_HANDLE
+						    (subCtx->cid,
+						     VMCI_EVENT_HANDLER));
+		}
+	}
+	spin_unlock(&contextList.lock);
+	spin_unlock(&contextList.firingLock);
+
+	/* Fire event to all subscribers. */
+	arraySize = VMCIHandleArray_GetSize(subscriberArray);
+	for (i = 0; i < arraySize; i++) {
+		int result;
+		struct vmci_event_msg *eMsg;
+		struct vmci_event_payld_ctx *evPayload;
+		char buf[sizeof *eMsg + sizeof *evPayload];
+
+		eMsg = (struct vmci_event_msg *)buf;
+
+		/* Clear out any garbage. */
+		memset(eMsg, 0, sizeof *eMsg + sizeof *evPayload);
+		eMsg->hdr.dst = VMCIHandleArray_GetEntry(subscriberArray, i);
+		eMsg->hdr.src =
+		    VMCI_MAKE_HANDLE(VMCI_HYPERVISOR_CONTEXT_ID,
+				     VMCI_CONTEXT_RESOURCE_ID);
+		eMsg->hdr.payloadSize =
+		    sizeof *eMsg + sizeof *evPayload - sizeof eMsg->hdr;
+		eMsg->eventData.event = VMCI_EVENT_CTX_REMOVED;
+		evPayload = VMCIEventMsgPayload(eMsg);
+		evPayload->contextID = contextID;
+
+		result = VMCIDatagram_Dispatch(VMCI_HYPERVISOR_CONTEXT_ID,
+					       (struct vmci_datagram *)
+					       eMsg, false);
+		if (result < VMCI_SUCCESS) {
+			VMCI_DEBUG_LOG(4,
+				       (LGPFX
+					"Failed to enqueue event datagram "
+					"(type=%d) for context (ID=0x%x).\n",
+					eMsg->eventData.event,
+					eMsg->hdr.dst.context));
+			/* We continue to enqueue on next subscriber. */
+		}
+	}
+	VMCIHandleArray_Destroy(subscriberArray);
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIContextFreeContext --
+ *
+ *      Deallocates all parts of a context datastructure. This
+ *      functions doesn't lock the context, because it assumes that
+ *      the caller is holding the last reference to context.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      Paged memory is freed.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void VMCIContextFreeContext(struct vmci_context *context)	// IN
+{
+	struct list_head *curr;
+	struct list_head *next;
+	struct datagram_queue_entry *dqEntry;
+	struct vmci_handle tempHandle;
+
+	/* Fire event to all contexts interested in knowing this context is dying. */
+	VMCIContextFireNotification(context->cid, context->privFlags);
+
+	/*
+	 * Cleanup all queue pair resources attached to context.  If the VM dies
+	 * without cleaning up, this code will make sure that no resources are
+	 * leaked.
+	 */
+
+	tempHandle = VMCIHandleArray_GetEntry(context->queuePairArray, 0);
+	while (!VMCI_HANDLE_EQUAL(tempHandle, VMCI_INVALID_HANDLE)) {
+		if (VMCIQPBroker_Detach(tempHandle, context) < VMCI_SUCCESS) {
+			/*
+			 * When VMCIQPBroker_Detach() succeeds it removes the handle from the
+			 * array.  If detach fails, we must remove the handle ourselves.
+			 */
+			VMCIHandleArray_RemoveEntry(context->queuePairArray,
+						    tempHandle);
+		}
+		tempHandle =
+		    VMCIHandleArray_GetEntry(context->queuePairArray, 0);
+	}
+
+	/*
+	 * It is fine to destroy this without locking the callQueue, as
+	 * this is the only thread having a reference to the context.
+	 */
+
+	list_for_each_safe(curr, next, &context->datagramQueue) {
+		dqEntry =
+		    list_entry(curr, struct datagram_queue_entry, listItem);
+		list_del(curr);
+		ASSERT(dqEntry && dqEntry->dg);
+		ASSERT(dqEntry->dgSize == VMCI_DG_SIZE(dqEntry->dg));
+		kfree(dqEntry->dg);
+		kfree(dqEntry);
+	}
+
+	VMCIHandleArray_Destroy(context->notifierArray);
+	VMCIHandleArray_Destroy(context->queuePairArray);
+	VMCIHandleArray_Destroy(context->doorbellArray);
+	VMCIHandleArray_Destroy(context->pendingDoorbellArray);
+	VMCIUnsetNotify(context);
+	kfree(context);
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_PendingDatagrams --
+ *
+ *      Returns the current number of pending datagrams. The call may
+ *      also serve as a synchronization point for the datagram queue,
+ *      as no enqueue operations can occur concurrently.
+ *
+ * Results:
+ *      Length of datagram queue for the given context.
+ *
+ * Side effects:
+ *      Locks datagram queue.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int VMCIContext_PendingDatagrams(uint32_t cid,	// IN
+				 uint32_t * pending)	// OUT
+{
+	struct vmci_context *context;
+
+	context = VMCIContext_Get(cid);
+	if (context == NULL) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	spin_lock(&context->lock);
+	if (pending) {
+		*pending = context->pendingDatagrams;
+	}
+	spin_unlock(&context->lock);
+	VMCIContext_Release(context);
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_EnqueueDatagram --
+ *
+ *      Queues a VMCI datagram for the appropriate target VM
+ *      context.
+ *
+ * Results:
+ *      Size of enqueued data on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int VMCIContext_EnqueueDatagram(uint32_t cid,	// IN: Target VM
+				struct vmci_datagram *dg)	// IN:
+{
+	struct datagram_queue_entry *dqEntry;
+	struct vmci_context *context;
+	struct vmci_handle dgSrc;
+	size_t vmciDgSize;
+
+	ASSERT(dg);
+	vmciDgSize = VMCI_DG_SIZE(dg);
+	ASSERT(vmciDgSize <= VMCI_MAX_DG_SIZE);
+
+	/* Get the target VM's VMCI context. */
+	context = VMCIContext_Get(cid);
+	if (context == NULL) {
+		VMCI_DEBUG_LOG(4, (LGPFX "Invalid context (ID=0x%x).\n", cid));
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	/* Allocate guest call entry and add it to the target VM's queue. */
+	dqEntry = kmalloc(sizeof *dqEntry, GFP_KERNEL);
+	if (dqEntry == NULL) {
+		VMCI_WARNING((LGPFX
+			      "Failed to allocate memory for datagram.\n"));
+		VMCIContext_Release(context);
+		return VMCI_ERROR_NO_MEM;
+	}
+	dqEntry->dg = dg;
+	dqEntry->dgSize = vmciDgSize;
+	dgSrc = dg->src;
+	INIT_LIST_HEAD(&dqEntry->listItem);
+
+	spin_lock(&context->lock);
+	/*
+	 * We put a higher limit on datagrams from the hypervisor.  If the pending
+	 * datagram is not from hypervisor, then we check if enqueueing it would
+	 * exceed the VMCI_MAX_DATAGRAM_QUEUE_SIZE limit on the destination.  If the
+	 * pending datagram is from hypervisor, we allow it to be queued at the
+	 * destination side provided we don't reach the
+	 * VMCI_MAX_DATAGRAM_AND_EVENT_QUEUE_SIZE limit.
+	 */
+	if (context->datagramQueueSize + vmciDgSize >=
+	    VMCI_MAX_DATAGRAM_QUEUE_SIZE &&
+	    (!VMCI_HANDLE_EQUAL(dgSrc,
+				VMCI_MAKE_HANDLE
+				(VMCI_HYPERVISOR_CONTEXT_ID,
+				 VMCI_CONTEXT_RESOURCE_ID))
+	     || context->datagramQueueSize + vmciDgSize >=
+	     VMCI_MAX_DATAGRAM_AND_EVENT_QUEUE_SIZE)) {
+		spin_unlock(&context->lock);
+		VMCIContext_Release(context);
+		kfree(dqEntry);
+		VMCI_DEBUG_LOG(10,
+			       (LGPFX
+				"Context (ID=0x%x) receive queue is full.\n",
+				cid));
+		return VMCI_ERROR_NO_RESOURCES;
+	}
+
+	list_add(&dqEntry->listItem, &context->datagramQueue);
+	context->pendingDatagrams++;
+	context->datagramQueueSize += vmciDgSize;
+	VMCIContextSignalNotify(context);
+	wake_up(&context->hostContext.waitQueue);
+	spin_unlock(&context->lock);
+	VMCIContext_Release(context);
+
+	return vmciDgSize;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_Exists --
+ *
+ *      Verifies whether a context with the specified context ID exists.
+ *
+ * Results:
+ *      true if a context exists with the given cid.
+ *      false otherwise
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+bool VMCIContext_Exists(uint32_t cid)	// IN
+{
+	bool rv;
+
+	spin_lock(&contextList.lock);
+	rv = VMCIContextExists(cid);
+	spin_unlock(&contextList.lock);
+	return rv;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_Get --
+ *
+ *      Retrieves VMCI context corresponding to the given cid.
+ *
+ * Results:
+ *      VMCI context on success, NULL otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+struct vmci_context *VMCIContext_Get(uint32_t cid)	// IN
+{
+	struct vmci_context *context = NULL;
+
+	if (cid == VMCI_INVALID_ID)
+		return NULL;
+
+	spin_lock(&contextList.lock);
+	list_for_each_entry(context, &contextList.head, listItem) {
+		if (context->cid == cid) {
+			/*
+			 * At this point, we are sure that the reference count is
+			 * larger already than zero. When starting the destruction of
+			 * a context, we always remove it from the context list
+			 * before decreasing the reference count. As we found the
+			 * context here, it hasn't been destroyed yet. This means
+			 * that we are not about to increase the reference count of
+			 * something that is in the process of being destroyed.
+			 */
+
+			atomic_inc(&context->refCount);
+			break;
+		}
+	}
+	spin_unlock(&contextList.lock);
+
+	return (context && context->cid == cid) ? context : NULL;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_Release --
+ *
+ *      Releases the VMCI context. If this is the last reference to
+ *      the context it will be deallocated. A context is created with
+ *      a reference count of one, and on destroy, it is removed from
+ *      the context list before its reference count is
+ *      decremented. Thus, if we reach zero, we are sure that nobody
+ *      else are about to increment it (they need the entry in the
+ *      context list for that). This function musn't be called with a
+ *      lock held.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      Paged memory may be deallocated.
+ *
+ *----------------------------------------------------------------------
+ */
+
+void VMCIContext_Release(struct vmci_context *context)	// IN
+{
+	ASSERT(context);
+	if (atomic_dec_and_test(&context->refCount))
+		VMCIContextFreeContext(context);
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_DequeueDatagram --
+ *
+ *      Dequeues the next datagram and returns it to caller.
+ *      The caller passes in a pointer to the max size datagram
+ *      it can handle and the datagram is only unqueued if the
+ *      size is less than maxSize. If larger maxSize is set to
+ *      the size of the datagram to give the caller a chance to
+ *      set up a larger buffer for the guestcall.
+ *
+ * Results:
+ *      On success:  0 if no more pending datagrams, otherwise the size of
+ *                   the next pending datagram.
+ *      On failure:  appropriate error code.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int VMCIContext_DequeueDatagram(struct vmci_context *context,	// IN
+				size_t * maxSize,	// IN/OUT: max size of 
+				//         datagram caller can handle.
+				struct vmci_datagram **dg)	// OUT:
+{
+	struct datagram_queue_entry *dqEntry;
+	struct list_head *listItem;
+	int rv;
+
+	ASSERT(context && dg);
+
+	/* Dequeue the next datagram entry. */
+	spin_lock(&context->lock);
+	if (context->pendingDatagrams == 0) {
+		VMCIContextClearNotifyAndCall(context);
+		spin_unlock(&context->lock);
+		VMCI_DEBUG_LOG(4, (LGPFX "No datagrams pending.\n"));
+		return VMCI_ERROR_NO_MORE_DATAGRAMS;
+	}
+
+	listItem = context->datagramQueue.next;
+	ASSERT(!list_empty(&context->datagramQueue));
+
+	dqEntry = list_entry(listItem, struct datagram_queue_entry, listItem);
+	ASSERT(dqEntry->dg);
+
+	/* Check size of caller's buffer. */
+	if (*maxSize < dqEntry->dgSize) {
+		*maxSize = dqEntry->dgSize;
+		spin_unlock(&context->lock);
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX "Caller's buffer should be at least "
+				"(size=%u bytes).\n", (uint32_t) * maxSize));
+		return VMCI_ERROR_NO_MEM;
+	}
+
+	list_del(listItem);
+	context->pendingDatagrams--;
+	context->datagramQueueSize -= dqEntry->dgSize;
+	if (context->pendingDatagrams == 0) {
+		VMCIContextClearNotifyAndCall(context);
+		rv = VMCI_SUCCESS;
+	} else {
+		/*
+		 * Return the size of the next datagram.
+		 */
+		struct datagram_queue_entry *nextEntry;
+
+		listItem = context->datagramQueue.next;
+		ASSERT(!list_empty(&context->datagramQueue));
+		nextEntry =
+		    list_entry(listItem, struct datagram_queue_entry, listItem);
+		ASSERT(nextEntry && nextEntry->dg);
+		/*
+		 * The following size_t -> int truncation is fine as the maximum size of
+		 * a (routable) datagram is 68KB.
+		 */
+		rv = (int)nextEntry->dgSize;
+	}
+	spin_unlock(&context->lock);
+
+	/* Caller must free datagram. */
+	ASSERT(dqEntry->dgSize == VMCI_DG_SIZE(dqEntry->dg));
+	*dg = dqEntry->dg;
+	dqEntry->dg = NULL;
+	kfree(dqEntry);
+
+	return rv;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_GetId --
+ *
+ *      Retrieves cid of given VMCI context.
+ *
+ * Results:
+ *      uint32_t of context on success, VMCI_INVALID_ID otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+uint32_t VMCIContext_GetId(struct vmci_context * context)	// IN:
+{
+	if (!context) {
+		return VMCI_INVALID_ID;
+	}
+	ASSERT(context->cid != VMCI_INVALID_ID);
+	return context->cid;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_GetPrivFlags --
+ *
+ *      Retrieves the privilege flags of the given VMCI context ID.
+ *
+ * Results:
+ *     Context's privilege flags.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+uint32_t VMCIContext_GetPrivFlags(uint32_t contextID)	// IN
+{
+	if (VMCI_HostPersonalityActive()) {
+		uint32_t flags;
+		struct vmci_context *context;
+
+		context = VMCIContext_Get(contextID);
+		if (!context) {
+			return VMCI_LEAST_PRIVILEGE_FLAGS;
+		}
+		flags = context->privFlags;
+		VMCIContext_Release(context);
+		return flags;
+	}
+	return VMCI_NO_PRIVILEGE_FLAGS;
+}
+
+EXPORT_SYMBOL(VMCIContext_GetPrivFlags);
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_AddNotification --
+ *
+ *      Add remoteCID to list of contexts current contexts wants
+ *      notifications from/about.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, error code otherwise.
+ *
+ * Side effects:
+ *      As in VMCIHandleArray_AppendEntry().
+ *
+ *----------------------------------------------------------------------
+ */
+
+int VMCIContext_AddNotification(uint32_t contextID,	// IN:
+				uint32_t remoteCID)	// IN:
+{
+	int result = VMCI_ERROR_ALREADY_EXISTS;
+	struct vmci_handle notifierHandle;
+	struct vmci_context *context = VMCIContext_Get(contextID);
+	if (context == NULL) {
+		return VMCI_ERROR_NOT_FOUND;
+	}
+
+	if (VMCI_CONTEXT_IS_VM(contextID) && VMCI_CONTEXT_IS_VM(remoteCID)) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Context removed notifications for other VMs not "
+				"supported (src=0x%x, remote=0x%x).\n",
+				contextID, remoteCID));
+		result = VMCI_ERROR_DST_UNREACHABLE;
+		goto out;
+	}
+
+	if (context->privFlags & VMCI_PRIVILEGE_FLAG_RESTRICTED) {
+		result = VMCI_ERROR_NO_ACCESS;
+		goto out;
+	}
+
+	notifierHandle = VMCI_MAKE_HANDLE(remoteCID, VMCI_EVENT_HANDLER);
+	spin_lock(&contextList.firingLock);
+	spin_lock(&context->lock);
+	if (!VMCIHandleArray_HasEntry(context->notifierArray, notifierHandle)) {
+		VMCIHandleArray_AppendEntry(&context->notifierArray,
+					    notifierHandle);
+		result = VMCI_SUCCESS;
+	}
+	spin_unlock(&context->lock);
+	spin_unlock(&contextList.firingLock);
+ out:
+	VMCIContext_Release(context);
+	return result;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_RemoveNotification --
+ *
+ *      Remove remoteCID from current context's list of contexts it is
+ *      interested in getting notifications from/about.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int VMCIContext_RemoveNotification(uint32_t contextID,	// IN:
+				   uint32_t remoteCID)	// IN:
+{
+	struct vmci_context *context = VMCIContext_Get(contextID);
+	struct vmci_handle tmpHandle;
+	if (context == NULL) {
+		return VMCI_ERROR_NOT_FOUND;
+	}
+	spin_lock(&contextList.firingLock);
+	spin_lock(&context->lock);
+	tmpHandle =
+	    VMCIHandleArray_RemoveEntry(context->notifierArray,
+					VMCI_MAKE_HANDLE(remoteCID,
+							 VMCI_EVENT_HANDLER));
+	spin_unlock(&context->lock);
+	spin_unlock(&contextList.firingLock);
+	VMCIContext_Release(context);
+
+	if (VMCI_HANDLE_EQUAL(tmpHandle, VMCI_INVALID_HANDLE)) {
+		return VMCI_ERROR_NOT_FOUND;
+	}
+	return VMCI_SUCCESS;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_GetCheckpointState --
+ *
+ *      Get current context's checkpoint state of given type.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int VMCIContext_GetCheckpointState(uint32_t contextID,	// IN:
+				   uint32_t cptType,	// IN:
+				   uint32_t * bufSize,	// IN/OUT:
+				   char **cptBufPtr)	// OUT:
+{
+	int i, result;
+	uint32_t arraySize, cptDataSize;
+	struct vmci_handle_arr *array;
+	struct vmci_context *context;
+	char *cptBuf;
+	bool getContextID;
+
+	ASSERT(bufSize && cptBufPtr);
+
+	context = VMCIContext_Get(contextID);
+	if (context == NULL) {
+		return VMCI_ERROR_NOT_FOUND;
+	}
+
+	spin_lock(&context->lock);
+	if (cptType == VMCI_NOTIFICATION_CPT_STATE) {
+		ASSERT(context->notifierArray);
+		array = context->notifierArray;
+		getContextID = true;
+	} else if (cptType == VMCI_WELLKNOWN_CPT_STATE) {
+		/*
+		 * For compatibility with VMX'en with VM to VM communication, we
+		 * always return zero wellknown handles.
+		 */
+
+		*bufSize = 0;
+		*cptBufPtr = NULL;
+		result = VMCI_SUCCESS;
+		goto release;
+	} else if (cptType == VMCI_DOORBELL_CPT_STATE) {
+		ASSERT(context->doorbellArray);
+		array = context->doorbellArray;
+		getContextID = false;
+	} else {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX "Invalid cpt state (type=%d).\n",
+				cptType));
+		result = VMCI_ERROR_INVALID_ARGS;
+		goto release;
+	}
+
+	arraySize = VMCIHandleArray_GetSize(array);
+	if (arraySize > 0) {
+		if (cptType == VMCI_DOORBELL_CPT_STATE) {
+			cptDataSize =
+			    arraySize * sizeof(struct dbell_cpt_state);
+		} else {
+			cptDataSize = arraySize * sizeof(uint32_t);
+		}
+		if (*bufSize < cptDataSize) {
+			*bufSize = cptDataSize;
+			result = VMCI_ERROR_MORE_DATA;
+			goto release;
+		}
+
+		cptBuf = kmalloc(cptDataSize, GFP_ATOMIC);
+
+		if (cptBuf == NULL) {
+			result = VMCI_ERROR_NO_MEM;
+			goto release;
+		}
+
+		for (i = 0; i < arraySize; i++) {
+			struct vmci_handle tmpHandle =
+			    VMCIHandleArray_GetEntry(array, i);
+			if (cptType == VMCI_DOORBELL_CPT_STATE) {
+				((struct dbell_cpt_state *)cptBuf)[i].handle =
+				    tmpHandle;
+			} else {
+				((uint32_t *) cptBuf)[i] =
+				    getContextID ? tmpHandle.context :
+				    tmpHandle.resource;
+			}
+		}
+		*bufSize = cptDataSize;
+		*cptBufPtr = cptBuf;
+	} else {
+		*bufSize = 0;
+		*cptBufPtr = NULL;
+	}
+	result = VMCI_SUCCESS;
+
+ release:
+	spin_unlock(&context->lock);
+	VMCIContext_Release(context);
+
+	return result;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_SetCheckpointState --
+ *
+ *      Set current context's checkpoint state of given type.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int VMCIContext_SetCheckpointState(uint32_t contextID,	// IN:
+				   uint32_t cptType,	// IN:
+				   uint32_t bufSize,	// IN:
+				   char *cptBuf)	// IN:
+{
+	uint32_t i;
+	uint32_t currentID;
+	int result = VMCI_SUCCESS;
+	uint32_t numIDs = bufSize / sizeof(uint32_t);
+	ASSERT(cptBuf);
+
+	if (cptType == VMCI_WELLKNOWN_CPT_STATE && numIDs > 0) {
+		/*
+		 * We would end up here if VMX with VM to VM communication
+		 * attempts to restore a checkpoint with wellknown handles.
+		 */
+
+		VMCI_WARNING((LGPFX
+			      "Attempt to restore checkpoint with obsolete "
+			      "wellknown handles.\n"));
+		return VMCI_ERROR_OBSOLETE;
+	}
+
+	if (cptType != VMCI_NOTIFICATION_CPT_STATE) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX "Invalid cpt state (type=%d).\n",
+				cptType));
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	for (i = 0; i < numIDs && result == VMCI_SUCCESS; i++) {
+		currentID = ((uint32_t *) cptBuf)[i];
+		result = VMCIContext_AddNotification(contextID, currentID);
+		if (result != VMCI_SUCCESS) {
+			break;
+		}
+	}
+	if (result != VMCI_SUCCESS) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Failed to set cpt state (type=%d) (error=%d).\n",
+				cptType, result));
+	}
+	return result;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_ReceiveNotificationsGet --
+ *
+ *      Retrieves the specified context's pending notifications in the
+ *      form of a handle array. The handle arrays returned are the
+ *      actual data - not a copy and should not be modified by the
+ *      caller. They must be released using
+ *      VMCIContext_ReceiveNotificationsRelease.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int VMCIContext_ReceiveNotificationsGet(uint32_t contextID,	// IN
+					struct vmci_handle_arr **dbHandleArray,	// OUT
+					struct vmci_handle_arr **qpHandleArray)	// OUT
+{
+	struct vmci_context *context;
+	int result = VMCI_SUCCESS;
+
+	ASSERT(dbHandleArray && qpHandleArray);
+
+	context = VMCIContext_Get(contextID);
+	if (context == NULL) {
+		return VMCI_ERROR_NOT_FOUND;
+	}
+	spin_lock(&context->lock);
+
+	*dbHandleArray = context->pendingDoorbellArray;
+	context->pendingDoorbellArray = VMCIHandleArray_Create(0);
+	if (!context->pendingDoorbellArray) {
+		context->pendingDoorbellArray = *dbHandleArray;
+		*dbHandleArray = NULL;
+		result = VMCI_ERROR_NO_MEM;
+	}
+	*qpHandleArray = NULL;
+
+	spin_unlock(&context->lock);
+	VMCIContext_Release(context);
+
+	return result;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_ReceiveNotificationsRelease --
+ *
+ *      Releases handle arrays with pending notifications previously
+ *      retrieved using VMCIContext_ReceiveNotificationsGet. If the
+ *      notifications were not successfully handed over to the guest,
+ *      success must be false.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+void VMCIContext_ReceiveNotificationsRelease(uint32_t contextID,	// IN
+					     struct vmci_handle_arr *dbHandleArray,	// IN
+					     struct vmci_handle_arr *qpHandleArray,	// IN
+					     bool success)	// IN
+{
+	struct vmci_context *context = VMCIContext_Get(contextID);
+
+	if (context) {
+		spin_lock(&context->lock);
+		if (!success) {
+			struct vmci_handle handle;
+
+			/*
+			 * New notifications may have been added while we were not
+			 * holding the context lock, so we transfer any new pending
+			 * doorbell notifications to the old array, and reinstate the
+			 * old array.
+			 */
+
+			handle =
+			    VMCIHandleArray_RemoveTail
+			    (context->pendingDoorbellArray);
+			while (!VMCI_HANDLE_INVALID(handle)) {
+				ASSERT(VMCIHandleArray_HasEntry
+				       (context->doorbellArray, handle));
+				if (!VMCIHandleArray_HasEntry
+				    (dbHandleArray, handle)) {
+					VMCIHandleArray_AppendEntry
+					    (&dbHandleArray, handle);
+				}
+				handle =
+				    VMCIHandleArray_RemoveTail
+				    (context->pendingDoorbellArray);
+			}
+			VMCIHandleArray_Destroy(context->pendingDoorbellArray);
+			context->pendingDoorbellArray = dbHandleArray;
+			dbHandleArray = NULL;
+		} else {
+			VMCIContextClearNotifyAndCall(context);
+		}
+		spin_unlock(&context->lock);
+		VMCIContext_Release(context);
+	} else {
+		/*
+		 * The OS driver part is holding on to the context for the
+		 * duration of the receive notification ioctl, so it should
+		 * still be here.
+		 */
+
+		ASSERT(false);
+	}
+
+	if (dbHandleArray) {
+		VMCIHandleArray_Destroy(dbHandleArray);
+	}
+	if (qpHandleArray) {
+		VMCIHandleArray_Destroy(qpHandleArray);
+	}
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_DoorbellCreate --
+ *
+ *      Registers that a new doorbell handle has been allocated by the
+ *      context. Only doorbell handles registered can be notified.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherewise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int VMCIContext_DoorbellCreate(uint32_t contextID,	// IN
+			       struct vmci_handle handle)	// IN
+{
+	struct vmci_context *context;
+	int result;
+
+	if (contextID == VMCI_INVALID_ID || VMCI_HANDLE_INVALID(handle)) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	context = VMCIContext_Get(contextID);
+	if (context == NULL) {
+		return VMCI_ERROR_NOT_FOUND;
+	}
+
+	spin_lock(&context->lock);
+	if (!VMCIHandleArray_HasEntry(context->doorbellArray, handle)) {
+		VMCIHandleArray_AppendEntry(&context->doorbellArray, handle);
+		result = VMCI_SUCCESS;
+	} else {
+		result = VMCI_ERROR_DUPLICATE_ENTRY;
+	}
+	spin_unlock(&context->lock);
+
+	VMCIContext_Release(context);
+
+	return result;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_DoorbellDestroy --
+ *
+ *      Unregisters a doorbell handle that was previously registered
+ *      with VMCIContext_DoorbellCreate.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherewise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int VMCIContext_DoorbellDestroy(uint32_t contextID,	// IN
+				struct vmci_handle handle)	// IN
+{
+	struct vmci_context *context;
+	struct vmci_handle removedHandle;
+
+	if (contextID == VMCI_INVALID_ID || VMCI_HANDLE_INVALID(handle)) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	context = VMCIContext_Get(contextID);
+	if (context == NULL) {
+		return VMCI_ERROR_NOT_FOUND;
+	}
+
+	spin_lock(&context->lock);
+	removedHandle =
+	    VMCIHandleArray_RemoveEntry(context->doorbellArray, handle);
+	VMCIHandleArray_RemoveEntry(context->pendingDoorbellArray, handle);
+	spin_unlock(&context->lock);
+
+	VMCIContext_Release(context);
+
+	if (VMCI_HANDLE_INVALID(removedHandle)) {
+		return VMCI_ERROR_NOT_FOUND;
+	} else {
+		return VMCI_SUCCESS;
+	}
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_DoorbellDestroyAll --
+ *
+ *      Unregisters all doorbell handles that were previously
+ *      registered with VMCIContext_DoorbellCreate.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherewise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int VMCIContext_DoorbellDestroyAll(uint32_t contextID)	// IN
+{
+	struct vmci_context *context;
+	struct vmci_handle removedHandle;
+
+	if (contextID == VMCI_INVALID_ID) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	context = VMCIContext_Get(contextID);
+	if (context == NULL) {
+		return VMCI_ERROR_NOT_FOUND;
+	}
+
+	spin_lock(&context->lock);
+	do {
+		removedHandle =
+		    VMCIHandleArray_RemoveTail(context->doorbellArray);
+	} while (!VMCI_HANDLE_INVALID(removedHandle));
+	do {
+		removedHandle =
+		    VMCIHandleArray_RemoveTail(context->pendingDoorbellArray);
+	} while (!VMCI_HANDLE_INVALID(removedHandle));
+	spin_unlock(&context->lock);
+
+	VMCIContext_Release(context);
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_NotifyDoorbell --
+ *
+ *      Registers a notification of a doorbell handle initiated by the
+ *      specified source context. The notification of doorbells are
+ *      subject to the same isolation rules as datagram delivery. To
+ *      allow host side senders of notifications a finer granularity
+ *      of sender rights than those assigned to the sending context
+ *      itself, the host context is required to specify a different
+ *      set of privilege flags that will override the privileges of
+ *      the source context.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherewise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int VMCIContext_NotifyDoorbell(uint32_t srcCID,	// IN
+			       struct vmci_handle handle,	// IN
+			       uint32_t srcPrivFlags)	// IN
+{
+	struct vmci_context *dstContext;
+	int result;
+
+	if (VMCI_HANDLE_INVALID(handle)) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	/* Get the target VM's VMCI context. */
+	dstContext = VMCIContext_Get(handle.context);
+	if (dstContext == NULL) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX "Invalid context (ID=0x%x).\n",
+				handle.context));
+		return VMCI_ERROR_NOT_FOUND;
+	}
+
+	if (srcCID != handle.context) {
+		uint32_t dstPrivFlags;
+
+		if (VMCI_CONTEXT_IS_VM(srcCID)
+		    && VMCI_CONTEXT_IS_VM(handle.context)) {
+			VMCI_DEBUG_LOG(4,
+				       (LGPFX
+					"Doorbell notification from VM to VM not "
+					"supported (src=0x%x, dst=0x%x).\n",
+					srcCID, handle.context));
+			result = VMCI_ERROR_DST_UNREACHABLE;
+			goto out;
+		}
+
+		result = VMCIDoorbellGetPrivFlags(handle, &dstPrivFlags);
+		if (result < VMCI_SUCCESS) {
+			VMCI_WARNING((LGPFX
+				      "Failed to get privilege flags for destination "
+				      "(handle=0x%x:0x%x).\n",
+				      handle.context, handle.resource));
+			goto out;
+		}
+
+		if (srcCID != VMCI_HOST_CONTEXT_ID ||
+		    srcPrivFlags == VMCI_NO_PRIVILEGE_FLAGS) {
+			srcPrivFlags = VMCIContext_GetPrivFlags(srcCID);
+		}
+
+		if (VMCIDenyInteraction(srcPrivFlags, dstPrivFlags)) {
+			result = VMCI_ERROR_NO_ACCESS;
+			goto out;
+		}
+	}
+
+	if (handle.context == VMCI_HOST_CONTEXT_ID) {
+		result = VMCIDoorbellHostContextNotify(srcCID, handle);
+	} else {
+		spin_lock(&dstContext->lock);
+
+		if (!VMCIHandleArray_HasEntry
+		    (dstContext->doorbellArray, handle)) {
+			result = VMCI_ERROR_NOT_FOUND;
+		} else {
+			if (!VMCIHandleArray_HasEntry
+			    (dstContext->pendingDoorbellArray, handle)) {
+				VMCIHandleArray_AppendEntry
+				    (&dstContext->pendingDoorbellArray, handle);
+
+				VMCIContextSignalNotify(dstContext);
+				wake_up(&dstContext->hostContext.waitQueue);
+
+			}
+			result = VMCI_SUCCESS;
+		}
+		spin_unlock(&dstContext->lock);
+	}
+
+ out:
+	VMCIContext_Release(dstContext);
+
+	return result;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCI_ContextID2HostVmID --
+ *
+ *      Maps a context ID to the host specific (process/world) ID
+ *      of the VM/VMX.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int VMCI_ContextID2HostVmID(uint32_t contextID,	// IN
+			    void *hostVmID,	// OUT
+			    size_t hostVmIDLen)	// IN
+{
+	return VMCI_ERROR_UNAVAILABLE;
+}
+
+EXPORT_SYMBOL(VMCI_ContextID2HostVmID);
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCI_IsContextOwner --
+ *
+ *      Determines whether a given host OS specific representation of
+ *      user is the owner of the VM/VMX.
+ *
+ * Results:
+ *      VMCI_SUCCESS if the hostUser is owner, error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int VMCI_IsContextOwner(uint32_t contextID,	// IN
+			void *hostUser)	// IN
+{
+	if (VMCI_HostPersonalityActive()) {
+		struct vmci_context *context;
+		uid_t *user = (uid_t *) hostUser;
+		int retval;
+
+		if (!hostUser) {
+			return VMCI_ERROR_INVALID_ARGS;
+		}
+
+		context = VMCIContext_Get(contextID);
+		if (!context) {
+			return VMCI_ERROR_NOT_FOUND;
+		}
+
+		if (context->validUser) {
+			retval = VMCIHost_CompareUser(user, &context->user);
+		} else {
+			retval = VMCI_ERROR_UNAVAILABLE;
+		}
+		VMCIContext_Release(context);
+
+		return retval;
+	}
+	return VMCI_ERROR_UNAVAILABLE;
+}
+
+EXPORT_SYMBOL(VMCI_IsContextOwner);
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_SupportsHostQP --
+ *
+ *      Can host QPs be connected to this user process.  The answer is
+ *      false unless a sufficient version number has previously been set
+ *      by this caller.
+ *
+ * Results:
+ *      true if context supports host queue pairs, false otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+bool VMCIContext_SupportsHostQP(struct vmci_context * context)	// IN: Context structure
+{
+	if (!context || context->userVersion < VMCI_VERSION_HOSTQP) {
+		return false;
+	}
+	return true;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_QueuePairCreate --
+ *
+ *      Registers that a new queue pair handle has been allocated by
+ *      the context.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherewise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int VMCIContext_QueuePairCreate(struct vmci_context *context,	// IN: Context structure
+				struct vmci_handle handle)	// IN
+{
+	int result;
+
+	if (context == NULL || VMCI_HANDLE_INVALID(handle)) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	spin_lock(&context->lock);
+	if (!VMCIHandleArray_HasEntry(context->queuePairArray, handle)) {
+		VMCIHandleArray_AppendEntry(&context->queuePairArray, handle);
+		result = VMCI_SUCCESS;
+	} else {
+		result = VMCI_ERROR_DUPLICATE_ENTRY;
+	}
+	spin_unlock(&context->lock);
+
+	return result;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_QueuePairDestroy --
+ *
+ *      Unregisters a queue pair handle that was previously registered
+ *      with VMCIContext_QueuePairCreate.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherewise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+int VMCIContext_QueuePairDestroy(struct vmci_context *context,	// IN: Context structure
+				 struct vmci_handle handle)	// IN
+{
+	struct vmci_handle removedHandle;
+
+	if (context == NULL || VMCI_HANDLE_INVALID(handle)) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	spin_lock(&context->lock);
+	removedHandle =
+	    VMCIHandleArray_RemoveEntry(context->queuePairArray, handle);
+	spin_unlock(&context->lock);
+
+	if (VMCI_HANDLE_INVALID(removedHandle)) {
+		return VMCI_ERROR_NOT_FOUND;
+	} else {
+		return VMCI_SUCCESS;
+	}
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIContext_QueuePairExists --
+ *
+ *      Determines whether a given queue pair handle is registered
+ *      with the given context.
+ *
+ * Results:
+ *      true, if queue pair is registered with context. false, otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+bool VMCIContext_QueuePairExists(struct vmci_context *context,	// IN: Context structure
+				 struct vmci_handle handle)	// IN
+{
+	bool result;
+
+	if (context == NULL || VMCI_HANDLE_INVALID(handle)) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	spin_lock(&context->lock);
+	result = VMCIHandleArray_HasEntry(context->queuePairArray, handle);
+	spin_unlock(&context->lock);
+
+	return result;
+}
diff --git a/drivers/misc/vmw_vmci/vmciContext.h b/drivers/misc/vmw_vmci/vmciContext.h
new file mode 100644
index 0000000..d6f7388
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciContext.h
@@ -0,0 +1,77 @@
+/*
+ *
+ * VMware VMCI driver (vmciContext.h)
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
+#ifndef _VMCI_CONTEXT_H_
+#define _VMCI_CONTEXT_H_
+
+#include "vmci_defs.h"
+#include "vmci_handle_array.h"
+#include "vmci_infrastructure.h"
+#include "vmci_kernel_if.h"
+#include "vmciCommonInt.h"
+
+#define MAX_QUEUED_GUESTCALLS_PER_VM  100
+
+int VMCIContext_Init(void);
+int VMCIContext_InitContext(uint32_t cid, uint32_t flags,
+			    uintptr_t eventHnd, int version,
+			    uid_t * user, struct vmci_context **context);
+
+bool VMCIContext_SupportsHostQP(struct vmci_context *context);
+void VMCIContext_ReleaseContext(struct vmci_context *context);
+int VMCIContext_EnqueueDatagram(uint32_t cid, struct vmci_datagram *dg);
+int VMCIContext_DequeueDatagram(struct vmci_context *context,
+				size_t * maxSize, struct vmci_datagram **dg);
+int VMCIContext_PendingDatagrams(uint32_t cid, uint32_t * pending);
+struct vmci_context *VMCIContext_Get(uint32_t cid);
+void VMCIContext_Release(struct vmci_context *context);
+bool VMCIContext_Exists(uint32_t cid);
+
+uint32_t VMCIContext_GetId(struct vmci_context *context);
+int VMCIContext_AddNotification(uint32_t contextID, uint32_t remoteCID);
+int VMCIContext_RemoveNotification(uint32_t contextID, uint32_t remoteCID);
+int VMCIContext_GetCheckpointState(uint32_t contextID, uint32_t cptType,
+				   uint32_t * numCIDs, char **cptBufPtr);
+int VMCIContext_SetCheckpointState(uint32_t contextID, uint32_t cptType,
+				   uint32_t numCIDs, char *cptBuf);
+
+int VMCIContext_QueuePairCreate(struct vmci_context *context,
+				struct vmci_handle handle);
+int VMCIContext_QueuePairDestroy(struct vmci_context *context,
+				 struct vmci_handle handle);
+bool VMCIContext_QueuePairExists(struct vmci_context *context,
+				 struct vmci_handle handle);
+
+void VMCIContext_CheckAndSignalNotify(struct vmci_context *context);
+void VMCIUnsetNotify(struct vmci_context *context);
+
+int VMCIContext_DoorbellCreate(uint32_t contextID, struct vmci_handle handle);
+int VMCIContext_DoorbellDestroy(uint32_t contextID, struct vmci_handle handle);
+int VMCIContext_DoorbellDestroyAll(uint32_t contextID);
+int VMCIContext_NotifyDoorbell(uint32_t cid, struct vmci_handle handle,
+			       uint32_t srcPrivFlags);
+
+int VMCIContext_ReceiveNotificationsGet(uint32_t contextID, struct vmci_handle_arr
+					**dbHandleArray, struct vmci_handle_arr
+					**qpHandleArray);
+void VMCIContext_ReceiveNotificationsRelease(uint32_t contextID, struct vmci_handle_arr
+					     *dbHandleArray, struct vmci_handle_arr
+					     *qpHandleArray, bool success);
+#endif				// _VMCI_CONTEXT_H_
-- 
1.7.0.4

