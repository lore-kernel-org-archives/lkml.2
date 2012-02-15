Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761578Ab2BOBQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 20:16:05 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:52334 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761428Ab2BOBOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 20:14:45 -0500
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: vm-crosstalk@vmware.com, dtor@vmware.com, cschamp@vmware.com,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [PATCH 07/14] Add vmciQueuePair.*
Date: Tue, 14 Feb 2012 17:05:48 -0800
Message-Id: <1329267955-32367-8-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
References: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/misc/vmw_vmci/vmciQueuePair.c | 2696 +++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmciQueuePair.h |   95 ++
 2 files changed, 2791 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmciQueuePair.c
 create mode 100644 drivers/misc/vmw_vmci/vmciQueuePair.h

diff --git a/drivers/misc/vmw_vmci/vmciQueuePair.c b/drivers/misc/vmw_vmci/vmciQueuePair.c
new file mode 100644
index 0000000..0745e09
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciQueuePair.c
@@ -0,0 +1,2696 @@
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
+#include <linux/semaphore.h>
+
+#include "vmci_defs.h"
+#include "vmci_handle_array.h"
+#include "vmci_infrastructure.h"
+#include "vmci_kernel_if.h"
+#include "vmciCommonInt.h"
+#include "vmciContext.h"
+#include "vmciDatagram.h"
+#include "vmciDriver.h"
+#include "vmciEvent.h"
+#include "vmciHashtable.h"
+#include "vmciKernelAPI.h"
+#include "vmciQueuePair.h"
+#include "vmciResource.h"
+#include "vmciRoute.h"
+
+#define LGPFX "VMCIQueuePair: "
+
+/*
+ * In the following, we will distinguish between two kinds of VMX processes -
+ * the ones with versions lower than VMCI_VERSION_NOVMVM that use specialized
+ * VMCI page files in the VMX and supporting VM to VM communication and the
+ * newer ones that use the guest memory directly. We will in the following refer
+ * to the older VMX versions as old-style VMX'en, and the newer ones as new-style
+ * VMX'en.
+ *
+ * The state transition datagram is as follows (the VMCIQPB_ prefix has been
+ * removed for readability) - see below for more details on the transtions:
+ *
+ *            --------------  NEW  -------------
+ *            |                                |
+ *           \_/                              \_/
+ *     CREATED_NO_MEM <-----------------> CREATED_MEM
+ *            |    |                           |
+ *            |    o-----------------------o   |
+ *            |                            |   |
+ *           \_/                          \_/ \_/
+ *     ATTACHED_NO_MEM <----------------> ATTACHED_MEM
+ *            |                            |   |
+ *            |     o----------------------o   |
+ *            |     |                          |
+ *           \_/   \_/                        \_/
+ *     SHUTDOWN_NO_MEM <----------------> SHUTDOWN_MEM
+ *            |                                |
+ *            |                                |
+ *            -------------> gone <-------------
+ *
+ * In more detail. When a VMCI queue pair is first created, it will be in the
+ * VMCIQPB_NEW state. It will then move into one of the following states:
+ * - VMCIQPB_CREATED_NO_MEM: this state indicates that either:
+ *     - the created was performed by a host endpoint, in which case there is no
+ *       backing memory yet.
+ *     - the create was initiated by an old-style VMX, that uses
+ *       VMCIQPBroker_SetPageStore to specify the UVAs of the queue pair at a
+ *       later point in time. This state can be distinguished from the one above
+ *       by the context ID of the creator. A host side is not allowed to attach
+ *       until the page store has been set.
+ * - VMCIQPB_CREATED_MEM: this state is the result when the queue pair is created
+ *     by a VMX using the queue pair device backend that sets the UVAs of the
+ *     queue pair immediately and stores the information for later attachers. At
+ *     this point, it is ready for the host side to attach to it.
+ * Once the queue pair is in one of the created states (with the exception of the
+ * case mentioned for older VMX'en above), it is possible to attach to the queue
+ * pair. Again we have two new states possible:
+ * - VMCIQPB_ATTACHED_MEM: this state can be reached through the following paths:
+ *     - from VMCIQPB_CREATED_NO_MEM when a new-style VMX allocates a queue pair,
+ *       and attaches to a queue pair previously created by the host side.
+ *     - from VMCIQPB_CREATED_MEM when the host side attaches to a queue pair
+ *       already created by a guest.
+ *     - from VMCIQPB_ATTACHED_NO_MEM, when an old-style VMX calls
+ *       VMCIQPBroker_SetPageStore (see below).
+ * - VMCIQPB_ATTACHED_NO_MEM: If the queue pair already was in the
+ *     VMCIQPB_CREATED_NO_MEM due to a host side create, an old-style VMX will
+ *     bring the queue pair into this state. Once VMCIQPBroker_SetPageStore is
+ *     called to register the user memory, the VMCIQPB_ATTACH_MEM state will be
+ *     entered.
+ * From the attached queue pair, the queue pair can enter the shutdown states
+ * when either side of the queue pair detaches. If the guest side detaches first,
+ * the queue pair will enter the VMCIQPB_SHUTDOWN_NO_MEM state, where the content
+ * of the queue pair will no longer be available. If the host side detaches first,
+ * the queue pair will either enter the VMCIQPB_SHUTDOWN_MEM, if the guest memory
+ * is currently mapped, or VMCIQPB_SHUTDOWN_NO_MEM, if the guest memory is not
+ * mapped (e.g., the host detaches while a guest is stunned).
+ *
+ * New-style VMX'en will also unmap guest memory, if the guest is quiesced, e.g.,
+ * during a snapshot operation. In that case, the guest memory will no longer be
+ * available, and the queue pair will transition from *_MEM state to a *_NO_MEM
+ * state. The VMX may later map the memory once more, in which case the queue
+ * pair will transition from the *_NO_MEM state at that point back to the *_MEM
+ * state. Note that the *_NO_MEM state may have changed, since the peer may have
+ * either attached or detached in the meantime. The values are laid out such that
+ * ++ on a state will move from a *_NO_MEM to a *_MEM state, and vice versa.
+ */
+
+typedef enum {
+	VMCIQPB_NEW,
+	VMCIQPB_CREATED_NO_MEM,
+	VMCIQPB_CREATED_MEM,
+	VMCIQPB_ATTACHED_NO_MEM,
+	VMCIQPB_ATTACHED_MEM,
+	VMCIQPB_SHUTDOWN_NO_MEM,
+	VMCIQPB_SHUTDOWN_MEM,
+	VMCIQPB_GONE
+} QPBrokerState;
+
+#define QPBROKERSTATE_HAS_MEM(_qpb) (_qpb->state == VMCIQPB_CREATED_MEM || \
+                                     _qpb->state == VMCIQPB_ATTACHED_MEM || \
+                                     _qpb->state == VMCIQPB_SHUTDOWN_MEM)
+
+/*
+ * In the queue pair broker, we always use the guest point of view for
+ * the produce and consume queue values and references, e.g., the
+ * produce queue size stored is the guests produce queue size. The
+ * host endpoint will need to swap these around. The only exception is
+ * the local queue pairs on the host, in which case the host endpoint
+ * that creates the queue pair will have the right orientation, and
+ * the attaching host endpoint will need to swap.
+ */
+
+struct qp_entry {
+	struct list_head listItem;
+	struct vmci_handle handle;
+	uint32_t peer;
+	uint32_t flags;
+	uint64_t produceSize;
+	uint64_t consumeSize;
+	uint32_t refCount;
+};
+
+struct qp_broker_entry {
+	struct qp_entry qp;
+	uint32_t createId;
+	uint32_t attachId;
+	QPBrokerState state;
+	bool requireTrustedAttach;
+	bool createdByTrusted;
+	bool vmciPageFiles;	// Created by VMX using VMCI page files
+	struct vmci_queue *produceQ;
+	struct vmci_queue *consumeQ;
+	struct vmci_queue_header savedProduceQ;
+	struct vmci_queue_header savedConsumeQ;
+	VMCIEventReleaseCB wakeupCB;
+	void *clientData;
+	void *localMem;		// Kernel memory for local queue pair
+};
+
+struct qp_guest_endpoint {
+	struct qp_entry qp;
+	uint64_t numPPNs;
+	void *produceQ;
+	void *consumeQ;
+	bool hibernateFailure;
+	struct PPNSet ppnSet;
+};
+
+struct qp_list {
+	struct list_head head;
+	atomic_t hibernate;
+	struct semaphore mutex;
+};
+
+static struct qp_list qpBrokerList;
+
+#define QPE_NUM_PAGES(_QPE) ((uint32_t)(CEILING(_QPE.produceSize, PAGE_SIZE) + \
+					CEILING(_QPE.consumeSize, PAGE_SIZE) + 2))
+
+static struct qp_list qpGuestEndpoints;
+static struct vmci_handle_arr *hibernateFailedList;
+static spinlock_t hibernateFailedListLock;
+
+extern int VMCI_SendDatagram(struct vmci_datagram *);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * QueuePairList_FindEntry --
+ *
+ *      Finds the entry in the list corresponding to a given handle. Assumes
+ *      that the list is locked.
+ *
+ * Results:
+ *      Pointer to entry.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static struct qp_entry *QueuePairList_FindEntry(struct qp_list *qpList,	// IN
+						struct vmci_handle handle)	// IN
+{
+	struct list_head *next;
+
+	if (VMCI_HANDLE_INVALID(handle)) {
+		return NULL;
+	}
+
+	list_for_each(next, &qpList->head) {
+		struct qp_entry *entry =
+		    list_entry(next, struct qp_entry, listItem);
+
+		if (VMCI_HANDLE_EQUAL(entry->handle, handle)) {
+			return entry;
+		}
+	}
+
+	return NULL;
+}
+
+/*
+ *----------------------------------------------------------------------------
+ *
+ * QueuePairNotifyPeerLocal --
+ *
+ *      Dispatches a queue pair event message directly into the local event
+ *      queue.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, error code otherwise
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------------
+ */
+
+static int QueuePairNotifyPeerLocal(bool attach,	// IN: attach or detach?
+				    struct vmci_handle handle)	// IN: queue pair handle
+{
+	struct vmci_event_msg *eMsg;
+	struct vmci_event_payld_qp *ePayload;
+	/* buf is only 48 bytes. */
+	char buf[sizeof *eMsg + sizeof *ePayload];
+	uint32_t contextId;
+
+	contextId = VMCI_GetContextID();
+
+	eMsg = (struct vmci_event_msg *)buf;
+	ePayload = VMCIEventMsgPayload(eMsg);
+
+	eMsg->hdr.dst = VMCI_MAKE_HANDLE(contextId, VMCI_EVENT_HANDLER);
+	eMsg->hdr.src = VMCI_MAKE_HANDLE(VMCI_HYPERVISOR_CONTEXT_ID,
+					 VMCI_CONTEXT_RESOURCE_ID);
+	eMsg->hdr.payloadSize =
+	    sizeof *eMsg + sizeof *ePayload - sizeof eMsg->hdr;
+	eMsg->eventData.event =
+	    attach ? VMCI_EVENT_QP_PEER_ATTACH : VMCI_EVENT_QP_PEER_DETACH;
+	ePayload->peerId = contextId;
+	ePayload->handle = handle;
+
+	return VMCIEvent_Dispatch((struct vmci_datagram *)eMsg);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * QPGuestEndpointCreate --
+ *
+ *      Allocates and initializes a QPGuestEndpoint structure.
+ *      Allocates a QueuePair rid (and handle) iff the given entry has
+ *      an invalid handle.  0 through VMCI_RESERVED_RESOURCE_ID_MAX
+ *      are reserved handles.  Assumes that the QP list mutex is held
+ *      by the caller.
+ *
+ * Results:
+ *      Pointer to structure intialized.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+struct qp_guest_endpoint *QPGuestEndpointCreate(struct vmci_handle handle,	// IN
+						uint32_t peer,	// IN
+						uint32_t flags,	// IN
+						uint64_t produceSize,	// IN
+						uint64_t consumeSize,	// IN
+						void *produceQ,	// IN
+						void *consumeQ)	// IN
+{
+	static uint32_t queuePairRID = VMCI_RESERVED_RESOURCE_ID_MAX + 1;
+	struct qp_guest_endpoint *entry;
+	const uint64_t numPPNs = CEILING(produceSize, PAGE_SIZE) + CEILING(consumeSize, PAGE_SIZE) + 2;	/* One page each for the queue headers. */
+
+	ASSERT((produceSize || consumeSize) && produceQ && consumeQ);
+
+	if (VMCI_HANDLE_INVALID(handle)) {
+		uint32_t contextID = VMCI_GetContextID();
+		uint32_t oldRID = queuePairRID;
+
+		/*
+		 * Generate a unique QueuePair rid.  Keep on trying until we wrap around
+		 * in the RID space.
+		 */
+		ASSERT(oldRID > VMCI_RESERVED_RESOURCE_ID_MAX);
+		do {
+			handle = VMCI_MAKE_HANDLE(contextID, queuePairRID);
+			entry = (struct qp_guest_endpoint *)
+			    QueuePairList_FindEntry(&qpGuestEndpoints, handle);
+			queuePairRID++;
+			if (unlikely(!queuePairRID)) {
+				/*
+				 * Skip the reserved rids.
+				 */
+				queuePairRID =
+				    VMCI_RESERVED_RESOURCE_ID_MAX + 1;
+			}
+		} while (entry && queuePairRID != oldRID);
+
+		if (unlikely(entry != NULL)) {
+			ASSERT(queuePairRID == oldRID);
+			/*
+			 * We wrapped around --- no rids were free.
+			 */
+			return NULL;
+		}
+	}
+
+	ASSERT(!VMCI_HANDLE_INVALID(handle) &&
+	       QueuePairList_FindEntry(&qpGuestEndpoints, handle) == NULL);
+	entry = kmalloc(sizeof *entry, GFP_KERNEL);
+	if (entry) {
+		entry->qp.handle = handle;
+		entry->qp.peer = peer;
+		entry->qp.flags = flags;
+		entry->qp.produceSize = produceSize;
+		entry->qp.consumeSize = consumeSize;
+		entry->qp.refCount = 0;
+		entry->numPPNs = numPPNs;
+		memset(&entry->ppnSet, 0, sizeof entry->ppnSet);
+		entry->produceQ = produceQ;
+		entry->consumeQ = consumeQ;
+		INIT_LIST_HEAD(&entry->qp.listItem);
+	}
+	return entry;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * QPGuestEndpointDestroy --
+ *
+ *      Frees a QPGuestEndpoint structure.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+void QPGuestEndpointDestroy(struct qp_guest_endpoint *entry)	// IN
+{
+	ASSERT(entry);
+	ASSERT(entry->qp.refCount == 0);
+
+	VMCI_FreePPNSet(&entry->ppnSet);
+	VMCI_CleanupQueueMutex(entry->produceQ, entry->consumeQ);
+	VMCI_FreeQueue(entry->produceQ, entry->qp.produceSize);
+	VMCI_FreeQueue(entry->consumeQ, entry->qp.consumeSize);
+	kfree(entry);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQueuePairAllocHypercall --
+ *
+ *      Helper to make a QueuePairAlloc hypercall when the driver is
+ *      supporting a guest device.
+ *
+ * Results:
+ *      Result of the hypercall.
+ *
+ * Side effects:
+ *      Memory is allocated & freed.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int VMCIQueuePairAllocHypercall(const struct qp_guest_endpoint *entry)	// IN
+{
+	struct vmci_qp_alloc_msg *allocMsg;
+	size_t msgSize;
+	int result;
+
+	if (!entry || entry->numPPNs <= 2)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	ASSERT(!(entry->qp.flags & VMCI_QPFLAG_LOCAL));
+
+	msgSize = sizeof *allocMsg + (size_t) entry->numPPNs * sizeof(uint32_t);
+	allocMsg = kmalloc(msgSize, GFP_KERNEL);
+	if (!allocMsg)
+		return VMCI_ERROR_NO_MEM;
+
+	allocMsg->hdr.dst = VMCI_MAKE_HANDLE(VMCI_HYPERVISOR_CONTEXT_ID,
+					     VMCI_QUEUEPAIR_ALLOC);
+	allocMsg->hdr.src = VMCI_ANON_SRC_HANDLE;
+	allocMsg->hdr.payloadSize = msgSize - VMCI_DG_HEADERSIZE;
+	allocMsg->handle = entry->qp.handle;
+	allocMsg->peer = entry->qp.peer;
+	allocMsg->flags = entry->qp.flags;
+	allocMsg->produceSize = entry->qp.produceSize;
+	allocMsg->consumeSize = entry->qp.consumeSize;
+	allocMsg->numPPNs = entry->numPPNs;
+
+	result =
+	    VMCI_PopulatePPNList((uint8_t *) allocMsg + sizeof *allocMsg,
+				 &entry->ppnSet);
+	if (result == VMCI_SUCCESS)
+		result = VMCI_SendDatagram((struct vmci_datagram *)allocMsg);
+
+	kfree(allocMsg);
+
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQueuePairDetachHypercall --
+ *
+ *      Helper to make a QueuePairDetach hypercall when the driver is
+ *      supporting a guest device.
+ *
+ * Results:
+ *      Result of the hypercall.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIQueuePairDetachHypercall(struct vmci_handle handle)	// IN
+{
+	struct vmci_qp_detach_msg detachMsg;
+
+	detachMsg.hdr.dst = VMCI_MAKE_HANDLE(VMCI_HYPERVISOR_CONTEXT_ID,
+					     VMCI_QUEUEPAIR_DETACH);
+	detachMsg.hdr.src = VMCI_ANON_SRC_HANDLE;
+	detachMsg.hdr.payloadSize = sizeof handle;
+	detachMsg.handle = handle;
+
+	return VMCI_SendDatagram((struct vmci_datagram *)&detachMsg);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPUnmarkHibernateFailed --
+ *
+ *      Helper function that removes a queue pair entry from the group
+ *      of handles marked as having failed hibernation. Must be called
+ *      with the queue pair list lock held.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void VMCIQPUnmarkHibernateFailed(struct qp_guest_endpoint *entry)	// IN
+{
+	struct vmci_handle handle;
+
+	/*
+	 * entry->handle is located in paged memory, so it can't be
+	 * accessed while holding a spinlock.
+	 */
+
+	handle = entry->qp.handle;
+	entry->hibernateFailure = false;
+	spin_lock_bh(&hibernateFailedListLock);
+	VMCIHandleArray_RemoveEntry(hibernateFailedList, handle);
+	spin_unlock_bh(&hibernateFailedListLock);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * QueuePairList_RemoveEntry --
+ *
+ *      Removes the given entry from the list. Assumes that the list is locked.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void QueuePairList_RemoveEntry(struct qp_list *qpList,	// IN
+				      struct qp_entry *entry)	// IN
+{
+	if (entry)
+		list_del(&entry->listItem);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQueuePairDetachGuestWork --
+ *
+ *      Helper for VMCI QueuePair detach interface. Frees the physical
+ *      pages for the queue pair.
+ *
+ * Results:
+ *      Success or failure.
+ *
+ * Side effects:
+ *      Memory may be freed.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int VMCIQueuePairDetachGuestWork(struct vmci_handle handle)	// IN
+{
+	int result;
+	struct qp_guest_endpoint *entry;
+	uint32_t refCount = 0xffffffff;	/* To avoid compiler warning below */
+
+	ASSERT(!VMCI_HANDLE_INVALID(handle));
+
+	down(&qpGuestEndpoints.mutex);
+
+	entry = (struct qp_guest_endpoint *)
+	    QueuePairList_FindEntry(&qpGuestEndpoints, handle);
+	if (!entry) {
+		up(&qpGuestEndpoints.mutex);
+		return VMCI_ERROR_NOT_FOUND;
+	}
+
+	ASSERT(entry->qp.refCount >= 1);
+
+	if (entry->qp.flags & VMCI_QPFLAG_LOCAL) {
+		result = VMCI_SUCCESS;
+
+		if (entry->qp.refCount > 1) {
+			result = QueuePairNotifyPeerLocal(false, handle);
+			/*
+			 * We can fail to notify a local queuepair because we can't allocate.
+			 * We still want to release the entry if that happens, so don't bail
+			 * out yet.
+			 */
+		}
+	} else {
+		result = VMCIQueuePairDetachHypercall(handle);
+		if (entry->hibernateFailure) {
+			if (result == VMCI_ERROR_NOT_FOUND) {
+				/*
+				 * If a queue pair detach failed when entering
+				 * hibernation, the guest driver and the device may
+				 * disagree on its existence when coming out of
+				 * hibernation. The guest driver will regard it as a
+				 * non-local queue pair, but the device state is gone,
+				 * since the device has been powered off. In this case, we
+				 * treat the queue pair as a local queue pair with no
+				 * peer.
+				 */
+
+				ASSERT(entry->qp.refCount == 1);
+				result = VMCI_SUCCESS;
+			}
+
+			if (result == VMCI_SUCCESS)
+				VMCIQPUnmarkHibernateFailed(entry);
+		}
+		if (result < VMCI_SUCCESS) {
+			/*
+			 * We failed to notify a non-local queuepair.  That other queuepair
+			 * might still be accessing the shared memory, so don't release the
+			 * entry yet.  It will get cleaned up by VMCIQueuePair_Exit()
+			 * if necessary (assuming we are going away, otherwise why did this
+			 * fail?).
+			 */
+
+			up(&qpGuestEndpoints.mutex);
+			return result;
+		}
+	}
+
+	/*
+	 * If we get here then we either failed to notify a local queuepair, or
+	 * we succeeded in all cases.  Release the entry if required.
+	 */
+
+	entry->qp.refCount--;
+	if (entry->qp.refCount == 0) {
+		QueuePairList_RemoveEntry(&qpGuestEndpoints, &entry->qp);
+	}
+
+	/* If we didn't remove the entry, this could change once we unlock. */
+	if (entry)
+		refCount = entry->qp.refCount;
+
+	up(&qpGuestEndpoints.mutex);
+
+	if (refCount == 0) {
+		QPGuestEndpointDestroy(entry);
+	}
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * QueuePairList_AddEntry --
+ *
+ *      Adds the given entry to the list. Assumes that the list is locked.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void QueuePairList_AddEntry(struct qp_list *qpList,	// IN
+				   struct qp_entry *entry)	// IN
+{
+	if (entry)
+		list_add(&entry->listItem, &qpList->head);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQueuePairAllocGuestWork --
+ *
+ *      This functions handles the actual allocation of a VMCI queue
+ *      pair guest endpoint. Allocates physical pages for the queue
+ *      pair. It makes OS dependent calls through generic wrappers.
+ *
+ * Results:
+ *      Success or failure.
+ *
+ * Side effects:
+ *      Memory is allocated.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int VMCIQueuePairAllocGuestWork(struct vmci_handle *handle,	// IN/OUT
+				       struct vmci_queue **produceQ,	// OUT
+				       uint64_t produceSize,	// IN
+				       struct vmci_queue **consumeQ,	// OUT
+				       uint64_t consumeSize,	// IN
+				       uint32_t peer,	// IN
+				       uint32_t flags,	// IN
+				       uint32_t privFlags)	// IN
+{
+	const uint64_t numProducePages = CEILING(produceSize, PAGE_SIZE) + 1;
+	const uint64_t numConsumePages = CEILING(consumeSize, PAGE_SIZE) + 1;
+	void *myProduceQ = NULL;
+	void *myConsumeQ = NULL;
+	int result;
+	struct qp_guest_endpoint *queuePairEntry = NULL;
+
+	/*
+	 * XXX Check for possible overflow of 'size' arguments when passed to
+	 * compat_get_order (after some arithmetic ops).
+	 */
+
+	ASSERT(handle && produceQ && consumeQ && (produceSize || consumeSize));
+
+	if (privFlags != VMCI_NO_PRIVILEGE_FLAGS)
+		return VMCI_ERROR_NO_ACCESS;
+
+	down(&qpGuestEndpoints.mutex);
+
+	/* Creation/attachment of a queuepair is allowed. */
+	if ((atomic_read(&qpGuestEndpoints.hibernate) == 1) &&
+	    !(flags & VMCI_QPFLAG_LOCAL)) {
+		/*
+		 * While guest OS is in hibernate state, creating non-local
+		 * queue pairs is not allowed after the point where the VMCI
+		 * guest driver converted the existing queue pairs to local
+		 * ones.
+		 */
+
+		result = VMCI_ERROR_UNAVAILABLE;
+		goto error;
+	}
+
+	if ((queuePairEntry = (struct qp_guest_endpoint *)
+	     QueuePairList_FindEntry(&qpGuestEndpoints, *handle))) {
+		if (queuePairEntry->qp.flags & VMCI_QPFLAG_LOCAL) {
+			/* Local attach case. */
+			if (queuePairEntry->qp.refCount > 1) {
+				VMCI_DEBUG_LOG(4,
+					       (LGPFX
+						"Error attempting to attach more than "
+						"once.\n"));
+				result = VMCI_ERROR_UNAVAILABLE;
+				goto errorKeepEntry;
+			}
+
+			if (queuePairEntry->qp.produceSize != consumeSize
+			    || queuePairEntry->qp.consumeSize !=
+			    produceSize
+			    || queuePairEntry->qp.flags !=
+			    (flags & ~VMCI_QPFLAG_ATTACH_ONLY)) {
+				VMCI_DEBUG_LOG(4,
+					       (LGPFX
+						"Error mismatched queue pair in local "
+						"attach.\n"));
+				result = VMCI_ERROR_QUEUEPAIR_MISMATCH;
+				goto errorKeepEntry;
+			}
+
+			/*
+			 * Do a local attach.  We swap the consume and produce queues for the
+			 * attacher and deliver an attach event.
+			 */
+			result = QueuePairNotifyPeerLocal(true, *handle);
+			if (result < VMCI_SUCCESS)
+				goto errorKeepEntry;
+
+			myProduceQ = queuePairEntry->consumeQ;
+			myConsumeQ = queuePairEntry->produceQ;
+			goto out;
+		}
+		result = VMCI_ERROR_ALREADY_EXISTS;
+		goto errorKeepEntry;
+	}
+
+	myProduceQ = VMCI_AllocQueue(produceSize);
+	if (!myProduceQ) {
+		VMCI_WARNING((LGPFX
+			      "Error allocating pages for produce queue.\n"));
+		result = VMCI_ERROR_NO_MEM;
+		goto error;
+	}
+
+	myConsumeQ = VMCI_AllocQueue(consumeSize);
+	if (!myConsumeQ) {
+		VMCI_WARNING((LGPFX
+			      "Error allocating pages for consume queue.\n"));
+		result = VMCI_ERROR_NO_MEM;
+		goto error;
+	}
+
+	queuePairEntry = QPGuestEndpointCreate(*handle, peer, flags,
+					       produceSize, consumeSize,
+					       myProduceQ, myConsumeQ);
+	if (!queuePairEntry) {
+		VMCI_WARNING((LGPFX "Error allocating memory in %s.\n",
+			      __FUNCTION__));
+		result = VMCI_ERROR_NO_MEM;
+		goto error;
+	}
+
+	result = VMCI_AllocPPNSet(myProduceQ, numProducePages, myConsumeQ,
+				  numConsumePages, &queuePairEntry->ppnSet);
+	if (result < VMCI_SUCCESS) {
+		VMCI_WARNING((LGPFX "VMCI_AllocPPNSet failed.\n"));
+		goto error;
+	}
+
+	/*
+	 * It's only necessary to notify the host if this queue pair will be
+	 * attached to from another context.
+	 */
+	if (queuePairEntry->qp.flags & VMCI_QPFLAG_LOCAL) {
+		/* Local create case. */
+		uint32_t contextId = VMCI_GetContextID();
+
+		/*
+		 * Enforce similar checks on local queue pairs as we do for regular ones.
+		 * The handle's context must match the creator or attacher context id
+		 * (here they are both the current context id) and the attach-only flag
+		 * cannot exist during create.  We also ensure specified peer is this
+		 * context or an invalid one.
+		 */
+		if (queuePairEntry->qp.handle.context != contextId ||
+		    (queuePairEntry->qp.peer != VMCI_INVALID_ID &&
+		     queuePairEntry->qp.peer != contextId)) {
+			result = VMCI_ERROR_NO_ACCESS;
+			goto error;
+		}
+
+		if (queuePairEntry->qp.flags & VMCI_QPFLAG_ATTACH_ONLY) {
+			result = VMCI_ERROR_NOT_FOUND;
+			goto error;
+		}
+	} else {
+		result = VMCIQueuePairAllocHypercall(queuePairEntry);
+		if (result < VMCI_SUCCESS) {
+			VMCI_WARNING((LGPFX
+				      "VMCIQueuePairAllocHypercall result = %d.\n",
+				      result));
+			goto error;
+		}
+	}
+
+	VMCI_InitQueueMutex((struct vmci_queue *)myProduceQ,
+			    (struct vmci_queue *)myConsumeQ);
+
+	QueuePairList_AddEntry(&qpGuestEndpoints, &queuePairEntry->qp);
+
+ out:
+	queuePairEntry->qp.refCount++;
+	*handle = queuePairEntry->qp.handle;
+	*produceQ = (struct vmci_queue *)myProduceQ;
+	*consumeQ = (struct vmci_queue *)myConsumeQ;
+
+	/*
+	 * We should initialize the queue pair header pages on a local queue pair
+	 * create.  For non-local queue pairs, the hypervisor initializes the header
+	 * pages in the create step.
+	 */
+	if ((queuePairEntry->qp.flags & VMCI_QPFLAG_LOCAL) &&
+	    queuePairEntry->qp.refCount == 1) {
+		VMCIQueueHeader_Init((*produceQ)->qHeader, *handle);
+		VMCIQueueHeader_Init((*consumeQ)->qHeader, *handle);
+	}
+
+	up(&qpGuestEndpoints.mutex);
+
+	return VMCI_SUCCESS;
+
+ error:
+	up(&qpGuestEndpoints.mutex);
+	if (queuePairEntry) {
+		/* The queues will be freed inside the destroy routine. */
+		QPGuestEndpointDestroy(queuePairEntry);
+	} else {
+		if (myProduceQ) {
+			VMCI_FreeQueue(myProduceQ, produceSize);
+		}
+		if (myConsumeQ) {
+			VMCI_FreeQueue(myConsumeQ, consumeSize);
+		}
+	}
+	return result;
+
+ errorKeepEntry:
+	/* This path should only be used when an existing entry was found. */
+	ASSERT(queuePairEntry->qp.refCount > 0);
+	up(&qpGuestEndpoints.mutex);
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPBrokerCreate --
+ *
+ *      The first endpoint issuing a queue pair allocation will create the state
+ *      of the queue pair in the queue pair broker.
+ *
+ *      If the creator is a guest, it will associate a VMX virtual address range
+ *      with the queue pair as specified by the pageStore. For compatibility with
+ *      older VMX'en, that would use a separate step to set the VMX virtual
+ *      address range, the virtual address range can be registered later using
+ *      VMCIQPBroker_SetPageStore. In that case, a pageStore of NULL should be
+ *      used.
+ *
+ *      If the creator is the host, a pageStore of NULL should be used as well,
+ *      since the host is not able to supply a page store for the queue pair.
+ *
+ *      For older VMX and host callers, the queue pair will be created in the
+ *      VMCIQPB_CREATED_NO_MEM state, and for current VMX callers, it will be
+ *      created in VMCOQPB_CREATED_MEM state.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      Memory will be allocated, and pages may be pinned.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int VMCIQPBrokerCreate(struct vmci_handle handle,	// IN
+			      uint32_t peer,	// IN
+			      uint32_t flags,	// IN
+			      uint32_t privFlags,	// IN
+			      uint64_t produceSize,	// IN
+			      uint64_t consumeSize,	// IN
+			      QueuePairPageStore * pageStore,	// IN
+			      struct vmci_context *context,	// IN: Caller
+			      VMCIEventReleaseCB wakeupCB,	// IN
+			      void *clientData,	// IN
+			      struct qp_broker_entry **ent)	// OUT
+{
+	struct qp_broker_entry *entry = NULL;
+	const uint32_t contextId = VMCIContext_GetId(context);
+	bool isLocal = flags & VMCI_QPFLAG_LOCAL;
+	int result;
+	uint64_t guestProduceSize;
+	uint64_t guestConsumeSize;
+
+	/*
+	 * Do not create if the caller asked not to.
+	 */
+
+	if (flags & VMCI_QPFLAG_ATTACH_ONLY) {
+		return VMCI_ERROR_NOT_FOUND;
+	}
+
+	/*
+	 * Creator's context ID should match handle's context ID or the creator
+	 * must allow the context in handle's context ID as the "peer".
+	 */
+
+	if (handle.context != contextId && handle.context != peer) {
+		return VMCI_ERROR_NO_ACCESS;
+	}
+
+	if (VMCI_CONTEXT_IS_VM(contextId) && VMCI_CONTEXT_IS_VM(peer)) {
+		return VMCI_ERROR_DST_UNREACHABLE;
+	}
+
+	/*
+	 * Creator's context ID for local queue pairs should match the
+	 * peer, if a peer is specified.
+	 */
+
+	if (isLocal && peer != VMCI_INVALID_ID && contextId != peer) {
+		return VMCI_ERROR_NO_ACCESS;
+	}
+
+	entry = kmalloc(sizeof *entry, GFP_ATOMIC);
+	if (!entry) {
+		return VMCI_ERROR_NO_MEM;
+	}
+
+	if (VMCIContext_GetId(context) == VMCI_HOST_CONTEXT_ID && !isLocal) {
+		/*
+		 * The queue pair broker entry stores values from the guest
+		 * point of view, so a creating host side endpoint should swap
+		 * produce and consume values -- unless it is a local queue
+		 * pair, in which case no swapping is necessary, since the local
+		 * attacher will swap queues.
+		 */
+
+		guestProduceSize = consumeSize;
+		guestConsumeSize = produceSize;
+	} else {
+		guestProduceSize = produceSize;
+		guestConsumeSize = consumeSize;
+	}
+
+	memset(entry, 0, sizeof *entry);
+	entry->qp.handle = handle;
+	entry->qp.peer = peer;
+	entry->qp.flags = flags;
+	entry->qp.produceSize = guestProduceSize;
+	entry->qp.consumeSize = guestConsumeSize;
+	entry->qp.refCount = 1;
+	entry->createId = contextId;
+	entry->attachId = VMCI_INVALID_ID;
+	entry->state = VMCIQPB_NEW;
+	entry->requireTrustedAttach =
+	    (context->privFlags & VMCI_PRIVILEGE_FLAG_RESTRICTED) ? true :
+	    false;
+	entry->createdByTrusted =
+	    (privFlags & VMCI_PRIVILEGE_FLAG_TRUSTED) ? true : false;
+	entry->vmciPageFiles = false;
+	entry->wakeupCB = wakeupCB;
+	entry->clientData = clientData;
+	entry->produceQ = VMCIHost_AllocQueue(guestProduceSize);
+	if (entry->produceQ == NULL) {
+		result = VMCI_ERROR_NO_MEM;
+		goto error;
+	}
+	entry->consumeQ = VMCIHost_AllocQueue(guestConsumeSize);
+	if (entry->consumeQ == NULL) {
+		result = VMCI_ERROR_NO_MEM;
+		goto error;
+	}
+
+	VMCI_InitQueueMutex(entry->produceQ, entry->consumeQ);
+
+	INIT_LIST_HEAD(&entry->qp.listItem);
+
+	if (isLocal) {
+		ASSERT(pageStore == NULL);
+
+		entry->localMem =
+		    kmalloc(QPE_NUM_PAGES(entry->qp) * PAGE_SIZE, GFP_KERNEL);
+		if (entry->localMem == NULL) {
+			result = VMCI_ERROR_NO_MEM;
+			goto error;
+		}
+		entry->state = VMCIQPB_CREATED_MEM;
+		entry->produceQ->qHeader = entry->localMem;
+		entry->consumeQ->qHeader =
+		    (struct vmci_queue_header *)((uint8_t *) entry->localMem +
+						 (CEILING
+						  (entry->qp.produceSize,
+						   PAGE_SIZE) + 1) * PAGE_SIZE);
+		VMCIQueueHeader_Init(entry->produceQ->qHeader, handle);
+		VMCIQueueHeader_Init(entry->consumeQ->qHeader, handle);
+	} else if (pageStore) {
+		ASSERT(entry->createId != VMCI_HOST_CONTEXT_ID || isLocal);
+
+		/*
+		 * The VMX already initialized the queue pair headers, so no
+		 * need for the kernel side to do that.
+		 */
+
+		result = VMCIHost_RegisterUserMemory(pageStore,
+						     entry->produceQ,
+						     entry->consumeQ);
+		if (result < VMCI_SUCCESS) {
+			goto error;
+		}
+		entry->state = VMCIQPB_CREATED_MEM;
+	} else {
+		/*
+		 * A create without a pageStore may be either a host side create (in which
+		 * case we are waiting for the guest side to supply the memory) or an old
+		 * style queue pair create (in which case we will expect a set page store
+		 * call as the next step).
+		 */
+
+		entry->state = VMCIQPB_CREATED_NO_MEM;
+	}
+
+	QueuePairList_AddEntry(&qpBrokerList, &entry->qp);
+	if (ent != NULL) {
+		*ent = entry;
+	}
+
+	VMCIContext_QueuePairCreate(context, handle);
+
+	return VMCI_SUCCESS;
+
+ error:
+	if (entry != NULL) {
+		if (entry->produceQ != NULL) {
+			VMCIHost_FreeQueue(entry->produceQ, guestProduceSize);
+		}
+		if (entry->consumeQ != NULL) {
+			VMCIHost_FreeQueue(entry->consumeQ, guestConsumeSize);
+		}
+		kfree(entry);
+	}
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * QueuePairNotifyPeer --
+ *
+ *      Enqueues an event datagram to notify the peer VM attached to
+ *      the given queue pair handle about attach/detach event by the
+ *      given VM.
+ *
+ * Results:
+ *      Payload size of datagram enqueued on success, error code otherwise.
+ *
+ * Side effects:
+ *      Memory is allocated.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int QueuePairNotifyPeer(bool attach,	// IN: attach or detach?
+			struct vmci_handle handle,	// IN
+			uint32_t myId,	// IN
+			uint32_t peerId)	// IN: CID of VM to notify
+{
+	int rv;
+	struct vmci_event_msg *eMsg;
+	struct vmci_event_payld_qp *evPayload;
+	char buf[sizeof *eMsg + sizeof *evPayload];
+
+	if (VMCI_HANDLE_INVALID(handle) || myId == VMCI_INVALID_ID ||
+	    peerId == VMCI_INVALID_ID) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	/*
+	 * Notification message contains: queue pair handle and
+	 * attaching/detaching VM's context id.
+	 */
+
+	eMsg = (struct vmci_event_msg *)buf;
+
+	/*
+	 * In VMCIContext_EnqueueDatagram() we enforce the upper limit on number of
+	 * pending events from the hypervisor to a given VM otherwise a rogue VM
+	 * could do an arbitrary number of attach and detach operations causing memory
+	 * pressure in the host kernel.
+	 */
+
+	/* Clear out any garbage. */
+	memset(eMsg, 0, sizeof buf);
+
+	eMsg->hdr.dst = VMCI_MAKE_HANDLE(peerId, VMCI_EVENT_HANDLER);
+	eMsg->hdr.src = VMCI_MAKE_HANDLE(VMCI_HYPERVISOR_CONTEXT_ID,
+					 VMCI_CONTEXT_RESOURCE_ID);
+	eMsg->hdr.payloadSize =
+	    sizeof *eMsg + sizeof *evPayload - sizeof eMsg->hdr;
+	eMsg->eventData.event =
+	    attach ? VMCI_EVENT_QP_PEER_ATTACH : VMCI_EVENT_QP_PEER_DETACH;
+	evPayload = VMCIEventMsgPayload(eMsg);
+	evPayload->handle = handle;
+	evPayload->peerId = myId;
+
+	rv = VMCIDatagram_Dispatch(VMCI_HYPERVISOR_CONTEXT_ID,
+				   (struct vmci_datagram *)eMsg, false);
+	if (rv < VMCI_SUCCESS) {
+		VMCI_WARNING((LGPFX
+			      "Failed to enqueue QueuePair %s event datagram for "
+			      "context (ID=0x%x).\n",
+			      attach ? "ATTACH" : "DETACH", peerId));
+	}
+
+	return rv;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPBrokerAttach --
+ *
+ *      The second endpoint issuing a queue pair allocation will attach to the
+ *      queue pair registered with the queue pair broker.
+ *
+ *      If the attacher is a guest, it will associate a VMX virtual address range
+ *      with the queue pair as specified by the pageStore. At this point, the
+ *      already attach host endpoint may start using the queue pair, and an
+ *      attach event is sent to it. For compatibility with older VMX'en, that
+ *      used a separate step to set the VMX virtual address range, the virtual
+ *      address range can be registered later using VMCIQPBroker_SetPageStore. In
+ *      that case, a pageStore of NULL should be used, and the attach event will
+ *      be generated once the actual page store has been set.
+ *
+ *      If the attacher is the host, a pageStore of NULL should be used as well,
+ *      since the page store information is already set by the guest.
+ *
+ *      For new VMX and host callers, the queue pair will be moved to the
+ *      VMCIQPB_ATTACHED_MEM state, and for older VMX callers, it will be
+ *      moved to the VMCOQPB_ATTACHED_NO_MEM state.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      Memory will be allocated, and pages may be pinned.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int VMCIQPBrokerAttach(struct qp_broker_entry *entry,	// IN
+			      uint32_t peer,	// IN
+			      uint32_t flags,	// IN
+			      uint32_t privFlags,	// IN
+			      uint64_t produceSize,	// IN
+			      uint64_t consumeSize,	// IN
+			      QueuePairPageStore * pageStore,	// IN/OUT
+			      struct vmci_context *context,	// IN: Caller
+			      VMCIEventReleaseCB wakeupCB,	// IN
+			      void *clientData,	// IN
+			      struct qp_broker_entry **ent)	// OUT
+{
+	const uint32_t contextId = VMCIContext_GetId(context);
+	bool isLocal = flags & VMCI_QPFLAG_LOCAL;
+	int result;
+
+	if (entry->state != VMCIQPB_CREATED_NO_MEM &&
+	    entry->state != VMCIQPB_CREATED_MEM)
+		return VMCI_ERROR_UNAVAILABLE;
+
+	if (isLocal) {
+		if (!(entry->qp.flags & VMCI_QPFLAG_LOCAL) ||
+		    contextId != entry->createId) {
+			return VMCI_ERROR_INVALID_ARGS;
+		}
+	} else if (contextId == entry->createId || contextId == entry->attachId) {
+		return VMCI_ERROR_ALREADY_EXISTS;
+	}
+
+	ASSERT(entry->qp.refCount < 2);
+	ASSERT(entry->attachId == VMCI_INVALID_ID);
+
+	if (VMCI_CONTEXT_IS_VM(contextId)
+	    && VMCI_CONTEXT_IS_VM(entry->createId))
+		return VMCI_ERROR_DST_UNREACHABLE;
+
+	/*
+	 * If we are attaching from a restricted context then the queuepair
+	 * must have been created by a trusted endpoint.
+	 */
+
+	if ((context->privFlags & VMCI_PRIVILEGE_FLAG_RESTRICTED) &&
+	    !entry->createdByTrusted)
+		return VMCI_ERROR_NO_ACCESS;
+
+	/*
+	 * If we are attaching to a queuepair that was created by a restricted
+	 * context then we must be trusted.
+	 */
+
+	if (entry->requireTrustedAttach &&
+	    (!(privFlags & VMCI_PRIVILEGE_FLAG_TRUSTED)))
+		return VMCI_ERROR_NO_ACCESS;
+
+	/*
+	 * If the creator specifies VMCI_INVALID_ID in "peer" field, access
+	 * control check is not performed.
+	 */
+
+	if (entry->qp.peer != VMCI_INVALID_ID && entry->qp.peer != contextId)
+		return VMCI_ERROR_NO_ACCESS;
+
+	if (entry->createId == VMCI_HOST_CONTEXT_ID) {
+		/*
+		 * Do not attach if the caller doesn't support Host Queue Pairs
+		 * and a host created this queue pair.
+		 */
+
+		if (!VMCIContext_SupportsHostQP(context)) {
+			return VMCI_ERROR_INVALID_RESOURCE;
+		}
+	} else if (contextId == VMCI_HOST_CONTEXT_ID) {
+		struct vmci_context *createContext;
+		bool supportsHostQP;
+
+		/*
+		 * Do not attach a host to a user created queue pair if that
+		 * user doesn't support host queue pair end points.
+		 */
+
+		createContext = VMCIContext_Get(entry->createId);
+		supportsHostQP = VMCIContext_SupportsHostQP(createContext);
+		VMCIContext_Release(createContext);
+
+		if (!supportsHostQP) {
+			return VMCI_ERROR_INVALID_RESOURCE;
+		}
+	}
+
+	if (entry->qp.flags != (flags & ~VMCI_QPFLAG_ATTACH_ONLY))
+		return VMCI_ERROR_QUEUEPAIR_MISMATCH;
+
+	if (contextId != VMCI_HOST_CONTEXT_ID) {
+		/*
+		 * The queue pair broker entry stores values from the guest
+		 * point of view, so an attaching guest should match the values
+		 * stored in the entry.
+		 */
+
+		if (entry->qp.produceSize != produceSize ||
+		    entry->qp.consumeSize != consumeSize) {
+			return VMCI_ERROR_QUEUEPAIR_MISMATCH;
+		}
+	} else if (entry->qp.produceSize != consumeSize ||
+		   entry->qp.consumeSize != produceSize) {
+		return VMCI_ERROR_QUEUEPAIR_MISMATCH;
+	}
+
+	if (contextId != VMCI_HOST_CONTEXT_ID) {
+		/*
+		 * If a guest attached to a queue pair, it will supply the backing memory.
+		 * If this is a pre NOVMVM vmx, the backing memory will be supplied by
+		 * calling VMCIQPBroker_SetPageStore() following the return of the
+		 * VMCIQPBroker_Alloc() call. If it is a vmx of version NOVMVM or later,
+		 * the page store must be supplied as part of the VMCIQPBroker_Alloc call.
+		 * Under all circumstances must the initially created queue pair not have
+		 * any memory associated with it already.
+		 */
+
+		if (entry->state != VMCIQPB_CREATED_NO_MEM) {
+			return VMCI_ERROR_INVALID_ARGS;
+		}
+
+		if (pageStore != NULL) {
+			/*
+			 * Patch up host state to point to guest supplied memory. The VMX
+			 * already initialized the queue pair headers, so no need for the
+			 * kernel side to do that.
+			 */
+
+			result = VMCIHost_RegisterUserMemory(pageStore,
+							     entry->produceQ,
+							     entry->consumeQ);
+			if (result < VMCI_SUCCESS) {
+				return result;
+			}
+			entry->state = VMCIQPB_ATTACHED_MEM;
+		} else {
+			entry->state = VMCIQPB_ATTACHED_NO_MEM;
+		}
+	} else if (entry->state == VMCIQPB_CREATED_NO_MEM) {
+		/*
+		 * The host side is attempting to attach to a queue pair that doesn't have
+		 * any memory associated with it. This must be a pre NOVMVM vmx that hasn't
+		 * set the page store information yet, or a quiesced VM.
+		 */
+
+		return VMCI_ERROR_UNAVAILABLE;
+	} else {
+		/*
+		 * The host side has successfully attached to a queue pair.
+		 */
+		entry->state = VMCIQPB_ATTACHED_MEM;
+	}
+
+	if (entry->state == VMCIQPB_ATTACHED_MEM) {
+		result =
+		    QueuePairNotifyPeer(true, entry->qp.handle, contextId,
+					entry->createId);
+		if (result < VMCI_SUCCESS) {
+			VMCI_WARNING((LGPFX
+				      "Failed to notify peer (ID=0x%x) of attach to queue "
+				      "pair (handle=0x%x:0x%x).\n",
+				      entry->createId,
+				      entry->qp.handle.context,
+				      entry->qp.handle.resource));
+		}
+	}
+
+	entry->attachId = contextId;
+	entry->qp.refCount++;
+	if (wakeupCB) {
+		ASSERT(!entry->wakeupCB);
+		entry->wakeupCB = wakeupCB;
+		entry->clientData = clientData;
+	}
+
+	/*
+	 * When attaching to local queue pairs, the context already has
+	 * an entry tracking the queue pair, so don't add another one.
+	 */
+
+	if (!isLocal) {
+		VMCIContext_QueuePairCreate(context, entry->qp.handle);
+	} else {
+		ASSERT(VMCIContext_QueuePairExists(context, entry->qp.handle));
+	}
+
+	if (ent != NULL)
+		*ent = entry;
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPBrokerAllocInt --
+ *
+ *      QueuePair_Alloc for use when setting up queue pair endpoints
+ *      on the host. Like QueuePair_Alloc, but returns a pointer to
+ *      the struct qp_broker_entry on success.
+ *
+ * Results:
+ *      Success or failure.
+ *
+ * Side effects:
+ *      Memory may be allocated.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int VMCIQPBrokerAllocInt(struct vmci_handle handle,	// IN
+				uint32_t peer,	// IN
+				uint32_t flags,	// IN
+				uint32_t privFlags,	// IN
+				uint64_t produceSize,	// IN
+				uint64_t consumeSize,	// IN
+				QueuePairPageStore * pageStore,	// IN/OUT
+				struct vmci_context *context,	// IN: Caller
+				VMCIEventReleaseCB wakeupCB,	// IN
+				void *clientData,	// IN
+				struct qp_broker_entry **ent,	// OUT
+				bool * swap)	// OUT: swap queues?
+{
+	const uint32_t contextId = VMCIContext_GetId(context);
+	bool create;
+	struct qp_broker_entry *entry;
+	bool isLocal = flags & VMCI_QPFLAG_LOCAL;
+	int result;
+
+	if (VMCI_HANDLE_INVALID(handle) ||
+	    (flags & ~VMCI_QP_ALL_FLAGS) || isLocal ||
+	    !(produceSize || consumeSize) ||
+	    !context || contextId == VMCI_INVALID_ID ||
+	    handle.context == VMCI_INVALID_ID) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	if (pageStore && !VMCI_QP_PAGESTORE_IS_WELLFORMED(pageStore)) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	/*
+	 * In the initial argument check, we ensure that non-vmkernel hosts
+	 * are not allowed to create local queue pairs.
+	 */
+
+	ASSERT(!isLocal);
+
+	down(&qpBrokerList.mutex);
+
+	if (!isLocal && VMCIContext_QueuePairExists(context, handle)) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Context (ID=0x%x) already attached to queue pair "
+				"(handle=0x%x:0x%x).\n", contextId,
+				handle.context, handle.resource));
+		up(&qpBrokerList.mutex);
+		return VMCI_ERROR_ALREADY_EXISTS;
+	}
+
+	entry = (struct qp_broker_entry *)
+	    QueuePairList_FindEntry(&qpBrokerList, handle);
+	if (!entry) {
+		create = true;
+		result =
+		    VMCIQPBrokerCreate(handle, peer, flags, privFlags,
+				       produceSize, consumeSize, pageStore,
+				       context, wakeupCB, clientData, ent);
+	} else {
+		create = false;
+		result =
+		    VMCIQPBrokerAttach(entry, peer, flags, privFlags,
+				       produceSize, consumeSize, pageStore,
+				       context, wakeupCB, clientData, ent);
+	}
+
+	up(&qpBrokerList.mutex);
+
+	if (swap) {
+		*swap = (contextId == VMCI_HOST_CONTEXT_ID) && !(create
+								 && isLocal);
+	}
+
+	return result;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIQueuePairAllocHostWork --
+ *
+ *    This function implements the kernel API for allocating a queue
+ *    pair.
+ *
+ * Results:
+ *     VMCI_SUCCESS on succes and appropriate failure code otherwise.
+ *
+ * Side effects:
+ *     May allocate memory.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static int VMCIQueuePairAllocHostWork(struct vmci_handle *handle,	// IN/OUT
+				      struct vmci_queue **produceQ,	// OUT
+				      uint64_t produceSize,	// IN
+				      struct vmci_queue **consumeQ,	// OUT
+				      uint64_t consumeSize,	// IN
+				      uint32_t peer,	// IN
+				      uint32_t flags,	// IN
+				      uint32_t privFlags,	// IN
+				      VMCIEventReleaseCB wakeupCB,	// IN
+				      void *clientData)	// IN
+{
+	struct vmci_context *context;
+	struct qp_broker_entry *entry;
+	int result;
+	bool swap;
+
+	if (VMCI_HANDLE_INVALID(*handle)) {
+		uint32_t resourceID = VMCIResource_GetID(VMCI_HOST_CONTEXT_ID);
+		if (resourceID == VMCI_INVALID_ID) {
+			return VMCI_ERROR_NO_HANDLE;
+		}
+		*handle = VMCI_MAKE_HANDLE(VMCI_HOST_CONTEXT_ID, resourceID);
+	}
+
+	context = VMCIContext_Get(VMCI_HOST_CONTEXT_ID);
+	ASSERT(context);
+
+	entry = NULL;
+	result =
+	    VMCIQPBrokerAllocInt(*handle, peer, flags, privFlags,
+				 produceSize, consumeSize, NULL, context,
+				 wakeupCB, clientData, &entry, &swap);
+	if (result == VMCI_SUCCESS) {
+		if (swap) {
+			/*
+			 * If this is a local queue pair, the attacher will swap around produce
+			 * and consume queues.
+			 */
+
+			*produceQ = entry->consumeQ;
+			*consumeQ = entry->produceQ;
+		} else {
+			*produceQ = entry->produceQ;
+			*consumeQ = entry->consumeQ;
+		}
+	} else {
+		*handle = VMCI_INVALID_HANDLE;
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"queue pair broker failed to alloc (result=%d).\n",
+				result));
+	}
+	VMCIContext_Release(context);
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQueuePair_Alloc --
+ *
+ *      Allocates a VMCI QueuePair. Only checks validity of input
+ *      arguments. The real work is done in the host or guest
+ *      specific function.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIQueuePair_Alloc(struct vmci_handle *handle,	// IN/OUT
+			struct vmci_queue **produceQ,	// OUT
+			uint64_t produceSize,	// IN
+			struct vmci_queue **consumeQ,	// OUT
+			uint64_t consumeSize,	// IN
+			uint32_t peer,	// IN
+			uint32_t flags,	// IN
+			uint32_t privFlags,	// IN
+			bool guestEndpoint,	// IN
+			VMCIEventReleaseCB wakeupCB,	// IN
+			void *clientData)	// IN
+{
+	if (!handle || !produceQ || !consumeQ || (!produceSize && !consumeSize)
+	    || (flags & ~VMCI_QP_ALL_FLAGS)) {
+		VMCI_DBG("Bad args");
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	if (guestEndpoint) {
+		return VMCIQueuePairAllocGuestWork(handle, produceQ,
+						   produceSize, consumeQ,
+						   consumeSize, peer,
+						   flags, privFlags);
+	} else {
+		return VMCIQueuePairAllocHostWork(handle, produceQ,
+						  produceSize, consumeQ,
+						  consumeSize, peer, flags,
+						  privFlags, wakeupCB,
+						  clientData);
+	}
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIQueuePairDetachHostWork --
+ *
+ *    This function implements the host kernel API for detaching from
+ *    a queue pair.
+ *
+ * Results:
+ *     VMCI_SUCCESS on success and appropriate failure code otherwise.
+ *
+ * Side effects:
+ *     May deallocate memory.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static int VMCIQueuePairDetachHostWork(struct vmci_handle handle)	// IN
+{
+	int result;
+	struct vmci_context *context;
+
+	context = VMCIContext_Get(VMCI_HOST_CONTEXT_ID);
+
+	result = VMCIQPBroker_Detach(handle, context);
+
+	VMCIContext_Release(context);
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQueuePair_Detach --
+ *
+ *      Detaches from a VMCI QueuePair. Only checks validity of input argument.
+ *      Real work is done in the host or guest specific function.
+ *
+ * Results:
+ *      Success or failure.
+ *
+ * Side effects:
+ *      Memory is freed.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIQueuePair_Detach(struct vmci_handle handle,	// IN
+			 bool guestEndpoint)	// IN
+{
+	if (VMCI_HANDLE_INVALID(handle))
+		return VMCI_ERROR_INVALID_ARGS;
+
+	if (guestEndpoint) {
+		return VMCIQueuePairDetachGuestWork(handle);
+	} else {
+		return VMCIQueuePairDetachHostWork(handle);
+	}
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * QueuePairList_Init --
+ *
+ *      Initializes the list of QueuePairs.
+ *
+ * Results:
+ *      Success or failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static inline int QueuePairList_Init(struct qp_list *qpList)	// IN
+{
+	INIT_LIST_HEAD(&qpList->head);
+	atomic_set(&qpList->hibernate, 0);
+	sema_init(&qpList->mutex, 1);
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * QueuePairList_Destroy --
+ *
+ *      Destroy the list's mutex.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static inline void QueuePairList_Destroy(struct qp_list *qpList)
+{
+	/* VMCIMutex_Destroy(&qpList->mutex); NOOP.  XXX: CHECK THIS */
+	INIT_LIST_HEAD(&qpList->head);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * QueuePairList_GetHead --
+ *
+ *      Returns the entry from the head of the list. Assumes that the list is
+ *      locked.
+ *
+ * Results:
+ *      Pointer to entry.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static struct qp_entry *QueuePairList_GetHead(struct qp_list *qpList)
+{
+	if (!list_empty(&qpList->head)) {
+		struct qp_entry *entry =
+		    list_first_entry(&qpList->head, struct qp_entry,
+				     listItem);
+		return entry;
+	}
+
+	return NULL;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPBroker_Init --
+ *
+ *      Initalizes queue pair broker state.
+ *
+ * Results:
+ *      Success or failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIQPBroker_Init(void)
+{
+	return QueuePairList_Init(&qpBrokerList);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPBroker_Exit --
+ *
+ *      Destroys the queue pair broker state.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+void VMCIQPBroker_Exit(void)
+{
+	struct qp_broker_entry *entry;
+
+	down(&qpBrokerList.mutex);
+
+	while ((entry = (struct qp_broker_entry *)
+		QueuePairList_GetHead(&qpBrokerList))) {
+		QueuePairList_RemoveEntry(&qpBrokerList, &entry->qp);
+		kfree(entry);
+	}
+
+	up(&qpBrokerList.mutex);
+	QueuePairList_Destroy(&qpBrokerList);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPBroker_Alloc --
+ *
+ *      Requests that a queue pair be allocated with the VMCI queue
+ *      pair broker. Allocates a queue pair entry if one does not
+ *      exist. Attaches to one if it exists, and retrieves the page
+ *      files backing that QueuePair.  Assumes that the queue pair
+ *      broker lock is held.
+ *
+ * Results:
+ *      Success or failure.
+ *
+ * Side effects:
+ *      Memory may be allocated.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIQPBroker_Alloc(struct vmci_handle handle,	// IN
+		       uint32_t peer,	// IN
+		       uint32_t flags,	// IN
+		       uint32_t privFlags,	// IN
+		       uint64_t produceSize,	// IN
+		       uint64_t consumeSize,	// IN
+		       QueuePairPageStore * pageStore,	// IN/OUT
+		       struct vmci_context *context)	// IN: Caller
+{
+	return VMCIQPBrokerAllocInt(handle, peer, flags, privFlags,
+				    produceSize, consumeSize,
+				    pageStore, context, NULL, NULL, NULL, NULL);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPBroker_SetPageStore --
+ *
+ *      VMX'en with versions lower than VMCI_VERSION_NOVMVM use a separate
+ *      step to add the UVAs of the VMX mapping of the queue pair. This function
+ *      provides backwards compatibility with such VMX'en, and takes care of
+ *      registering the page store for a queue pair previously allocated by the
+ *      VMX during create or attach. This function will move the queue pair state
+ *      to either from VMCIQBP_CREATED_NO_MEM to VMCIQBP_CREATED_MEM or
+ *      VMCIQBP_ATTACHED_NO_MEM to VMCIQBP_ATTACHED_MEM. If moving to the
+ *      attached state with memory, the queue pair is ready to be used by the
+ *      host peer, and an attached event will be generated.
+ *
+ *      Assumes that the queue pair broker lock is held.
+ *
+ *      This function is only used by the hosted platform, since there is no
+ *      issue with backwards compatibility for vmkernel.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      Pages may get pinned.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIQPBroker_SetPageStore(struct vmci_handle handle,	// IN
+			      uint64_t produceUVA,	// IN
+			      uint64_t consumeUVA,	// IN
+			      struct vmci_context *context)	// IN: Caller
+{
+	struct qp_broker_entry *entry;
+	int result;
+	const uint32_t contextId = VMCIContext_GetId(context);
+
+	if (VMCI_HANDLE_INVALID(handle) || !context
+	    || contextId == VMCI_INVALID_ID)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	/*
+	 * We only support guest to host queue pairs, so the VMX must
+	 * supply UVAs for the mapped page files.
+	 */
+
+	if (produceUVA == 0 || consumeUVA == 0)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	down(&qpBrokerList.mutex);
+
+	if (!VMCIContext_QueuePairExists(context, handle)) {
+		VMCI_WARNING((LGPFX
+			      "Context (ID=0x%x) not attached to queue pair "
+			      "(handle=0x%x:0x%x).\n", contextId,
+			      handle.context, handle.resource));
+		result = VMCI_ERROR_NOT_FOUND;
+		goto out;
+	}
+
+	entry = (struct qp_broker_entry *)
+	    QueuePairList_FindEntry(&qpBrokerList, handle);
+	if (!entry) {
+		result = VMCI_ERROR_NOT_FOUND;
+		goto out;
+	}
+
+	/*
+	 * If I'm the owner then I can set the page store.
+	 *
+	 * Or, if a host created the QueuePair and I'm the attached peer
+	 * then I can set the page store.
+	 */
+
+	if (entry->createId != contextId &&
+	    (entry->createId != VMCI_HOST_CONTEXT_ID ||
+	     entry->attachId != contextId)) {
+		/* XXX: Log? */
+		result = VMCI_ERROR_QUEUEPAIR_NOTOWNER;
+		goto out;
+	}
+
+	if (entry->state != VMCIQPB_CREATED_NO_MEM &&
+	    entry->state != VMCIQPB_ATTACHED_NO_MEM) {
+		/* XXX: Log? */
+		result = VMCI_ERROR_UNAVAILABLE;
+		goto out;
+	}
+
+	result = VMCIHost_GetUserMemory(produceUVA, consumeUVA,
+					entry->produceQ, entry->consumeQ);
+	if (result < VMCI_SUCCESS)
+		goto out;
+
+	result = VMCIHost_MapQueueHeaders(entry->produceQ, entry->consumeQ);
+	if (result < VMCI_SUCCESS) {
+		VMCIHost_ReleaseUserMemory(entry->produceQ, entry->consumeQ);
+		goto out;
+	}
+
+	if (entry->state == VMCIQPB_CREATED_NO_MEM) {
+		entry->state = VMCIQPB_CREATED_MEM;
+	} else {
+		ASSERT(entry->state == VMCIQPB_ATTACHED_NO_MEM);
+		entry->state = VMCIQPB_ATTACHED_MEM;
+	}
+	entry->vmciPageFiles = true;
+
+	if (entry->state == VMCIQPB_ATTACHED_MEM) {
+		result =
+		    QueuePairNotifyPeer(true, handle, contextId,
+					entry->createId);
+		if (result < VMCI_SUCCESS) {
+			VMCI_WARNING((LGPFX
+				      "Failed to notify peer (ID=0x%x) of attach to queue "
+				      "pair (handle=0x%x:0x%x).\n",
+				      entry->createId,
+				      entry->qp.handle.context,
+				      entry->qp.handle.resource));
+		}
+	}
+
+	result = VMCI_SUCCESS;
+ out:
+	up(&qpBrokerList.mutex);
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * QueuePairResetSavedHeaders --
+ *
+ *      Resets saved queue headers for the given QP broker
+ *      entry. Should be used when guest memory becomes available
+ *      again, or the guest detaches.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void QueuePairResetSavedHeaders(struct qp_broker_entry *entry)	// IN
+{
+	entry->produceQ->savedHeader = NULL;
+	entry->consumeQ->savedHeader = NULL;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPBroker_Detach --
+ *
+ *      The main entry point for detaching from a queue pair registered with the
+ *      queue pair broker. If more than one endpoint is attached to the queue
+ *      pair, the first endpoint will mainly decrement a reference count and
+ *      generate a notification to its peer. The last endpoint will clean up
+ *      the queue pair state registered with the broker.
+ *
+ *      When a guest endpoint detaches, it will unmap and unregister the guest
+ *      memory backing the queue pair. If the host is still attached, it will
+ *      no longer be able to access the queue pair content.
+ *
+ *      If the queue pair is already in a state where there is no memory
+ *      registered for the queue pair (any *_NO_MEM state), it will transition to
+ *      the VMCIQPB_SHUTDOWN_NO_MEM state. This will also happen, if a guest 
+ *      endpoint is the first of two endpoints to detach. If the host endpoint is
+ *      the first out of two to detach, the queue pair will move to the
+ *      VMCIQPB_SHUTDOWN_MEM state.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      Memory may be freed, and pages may be unpinned.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIQPBroker_Detach(struct vmci_handle handle,	// IN
+			struct vmci_context *context)	// IN
+{
+	struct qp_broker_entry *entry;
+	const uint32_t contextId = VMCIContext_GetId(context);
+	uint32_t peerId;
+	bool isLocal = false;
+	int result;
+
+	if (VMCI_HANDLE_INVALID(handle) || !context
+	    || contextId == VMCI_INVALID_ID) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	down(&qpBrokerList.mutex);
+
+	if (!VMCIContext_QueuePairExists(context, handle)) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Context (ID=0x%x) not attached to queue pair "
+				"(handle=0x%x:0x%x).\n", contextId,
+				handle.context, handle.resource));
+		result = VMCI_ERROR_NOT_FOUND;
+		goto out;
+	}
+
+	entry = (struct qp_broker_entry *)
+	    QueuePairList_FindEntry(&qpBrokerList, handle);
+	if (!entry) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Context (ID=0x%x) reports being attached to queue pair "
+				"(handle=0x%x:0x%x) that isn't present in broker.\n",
+				contextId, handle.context, handle.resource));
+		result = VMCI_ERROR_NOT_FOUND;
+		goto out;
+	}
+
+	if (contextId != entry->createId && contextId != entry->attachId) {
+		result = VMCI_ERROR_QUEUEPAIR_NOTATTACHED;
+		goto out;
+	}
+
+	if (contextId == entry->createId) {
+		peerId = entry->attachId;
+		entry->createId = VMCI_INVALID_ID;
+	} else {
+		peerId = entry->createId;
+		entry->attachId = VMCI_INVALID_ID;
+	}
+	entry->qp.refCount--;
+
+	isLocal = entry->qp.flags & VMCI_QPFLAG_LOCAL;
+
+	if (contextId != VMCI_HOST_CONTEXT_ID) {
+		int result;
+		bool headersMapped;
+
+		ASSERT(!isLocal);
+
+		/*
+		 * Pre NOVMVM vmx'en may detach from a queue pair before setting the page
+		 * store, and in that case there is no user memory to detach from. Also,
+		 * more recent VMX'en may detach from a queue pair in the quiesced state.
+		 */
+
+		VMCI_AcquireQueueMutex(entry->produceQ);
+		headersMapped = entry->produceQ->qHeader
+		    || entry->consumeQ->qHeader;
+		if (QPBROKERSTATE_HAS_MEM(entry)) {
+			result =
+			    VMCIHost_UnmapQueueHeaders
+			    (INVALID_VMCI_GUEST_MEM_ID, entry->produceQ,
+			     entry->consumeQ);
+			if (result < VMCI_SUCCESS)
+				VMCI_WARNING((LGPFX
+					      "Failed to unmap queue headers for queue pair "
+					      "(handle=0x%x:0x%x,result=%d).\n",
+					      handle.context,
+					      handle.resource, result));
+
+			if (entry->vmciPageFiles) {
+				VMCIHost_ReleaseUserMemory(entry->produceQ,
+							   entry->consumeQ);
+			} else {
+				VMCIHost_UnregisterUserMemory(entry->produceQ,
+							      entry->consumeQ);
+			}
+		}
+
+		if (!headersMapped)
+			QueuePairResetSavedHeaders(entry);
+
+		VMCI_ReleaseQueueMutex(entry->produceQ);
+
+		if (!headersMapped && entry->wakeupCB)
+			entry->wakeupCB(entry->clientData);
+
+	} else {
+		if (entry->wakeupCB) {
+			entry->wakeupCB = NULL;
+			entry->clientData = NULL;
+		}
+	}
+
+	if (entry->qp.refCount == 0) {
+		QueuePairList_RemoveEntry(&qpBrokerList, &entry->qp);
+
+		if (isLocal) {
+			kfree(entry->localMem);
+		}
+		VMCI_CleanupQueueMutex(entry->produceQ, entry->consumeQ);
+		VMCIHost_FreeQueue(entry->produceQ, entry->qp.produceSize);
+		VMCIHost_FreeQueue(entry->consumeQ, entry->qp.consumeSize);
+		kfree(entry);
+
+		VMCIContext_QueuePairDestroy(context, handle);
+	} else {
+		ASSERT(peerId != VMCI_INVALID_ID);
+		QueuePairNotifyPeer(false, handle, contextId, peerId);
+		if (contextId == VMCI_HOST_CONTEXT_ID
+		    && QPBROKERSTATE_HAS_MEM(entry)) {
+			entry->state = VMCIQPB_SHUTDOWN_MEM;
+		} else {
+			entry->state = VMCIQPB_SHUTDOWN_NO_MEM;
+		}
+
+		if (!isLocal)
+			VMCIContext_QueuePairDestroy(context, handle);
+
+	}
+	result = VMCI_SUCCESS;
+ out:
+	up(&qpBrokerList.mutex);
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPBroker_Map --
+ *
+ *      Establishes the necessary mappings for a queue pair given a
+ *      reference to the queue pair guest memory. This is usually
+ *      called when a guest is unquiesced and the VMX is allowed to
+ *      map guest memory once again.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      Memory may be allocated, and pages may be pinned.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIQPBroker_Map(struct vmci_handle handle,	// IN
+		     struct vmci_context *context,	// IN
+		     uint64_t guestMem)	// IN
+{
+	struct qp_broker_entry *entry;
+	const uint32_t contextId = VMCIContext_GetId(context);
+	bool isLocal = false;
+	int result;
+
+	if (VMCI_HANDLE_INVALID(handle) || !context
+	    || contextId == VMCI_INVALID_ID)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	down(&qpBrokerList.mutex);
+
+	if (!VMCIContext_QueuePairExists(context, handle)) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Context (ID=0x%x) not attached to queue pair "
+				"(handle=0x%x:0x%x).\n", contextId,
+				handle.context, handle.resource));
+		result = VMCI_ERROR_NOT_FOUND;
+		goto out;
+	}
+
+	entry = (struct qp_broker_entry *)
+	    QueuePairList_FindEntry(&qpBrokerList, handle);
+	if (!entry) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Context (ID=0x%x) reports being attached to queue pair "
+				"(handle=0x%x:0x%x) that isn't present in broker.\n",
+				contextId, handle.context, handle.resource));
+		result = VMCI_ERROR_NOT_FOUND;
+		goto out;
+	}
+
+	if (contextId != entry->createId && contextId != entry->attachId) {
+		result = VMCI_ERROR_QUEUEPAIR_NOTATTACHED;
+		goto out;
+	}
+
+	isLocal = entry->qp.flags & VMCI_QPFLAG_LOCAL;
+	result = VMCI_SUCCESS;
+
+	if (contextId != VMCI_HOST_CONTEXT_ID) {
+		QueuePairPageStore pageStore;
+
+		ASSERT(entry->state == VMCIQPB_CREATED_NO_MEM ||
+		       entry->state == VMCIQPB_SHUTDOWN_NO_MEM ||
+		       entry->state == VMCIQPB_ATTACHED_NO_MEM);
+		ASSERT(!isLocal);
+
+		pageStore.pages = guestMem;
+		pageStore.len = QPE_NUM_PAGES(entry->qp);
+
+		VMCI_AcquireQueueMutex(entry->produceQ);
+		QueuePairResetSavedHeaders(entry);
+		result =
+		    VMCIHost_RegisterUserMemory(&pageStore,
+						entry->produceQ,
+						entry->consumeQ);
+		VMCI_ReleaseQueueMutex(entry->produceQ);
+		if (result == VMCI_SUCCESS) {
+			/* Move state from *_NO_MEM to *_MEM */
+
+			entry->state++;
+
+			ASSERT(entry->state == VMCIQPB_CREATED_MEM ||
+			       entry->state == VMCIQPB_SHUTDOWN_MEM ||
+			       entry->state == VMCIQPB_ATTACHED_MEM);
+
+			if (entry->wakeupCB)
+				entry->wakeupCB(entry->clientData);
+		}
+	}
+
+ out:
+	up(&qpBrokerList.mutex);
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * QueuePairSaveHeaders --
+ *
+ *      Saves a snapshot of the queue headers for the given QP broker
+ *      entry. Should be used when guest memory is unmapped.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code if guest memory
+ *      can't be accessed..
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int QueuePairSaveHeaders(struct qp_broker_entry *entry)	// IN
+{
+	int result;
+
+	if (NULL == entry->produceQ->qHeader
+	    || NULL == entry->consumeQ->qHeader) {
+		result =
+		    VMCIHost_MapQueueHeaders(entry->produceQ, entry->consumeQ);
+		if (result < VMCI_SUCCESS)
+			return result;
+	}
+
+	memcpy(&entry->savedProduceQ, entry->produceQ->qHeader,
+	       sizeof entry->savedProduceQ);
+	entry->produceQ->savedHeader = &entry->savedProduceQ;
+	memcpy(&entry->savedConsumeQ, entry->consumeQ->qHeader,
+	       sizeof entry->savedConsumeQ);
+	entry->consumeQ->savedHeader = &entry->savedConsumeQ;
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPBroker_Unmap --
+ *
+ *      Removes all references to the guest memory of a given queue pair, and
+ *      will move the queue pair from state *_MEM to *_NO_MEM. It is usually
+ *      called when a VM is being quiesced where access to guest memory should
+ *      avoided.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      Memory may be freed, and pages may be unpinned.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIQPBroker_Unmap(struct vmci_handle handle,	// IN
+		       struct vmci_context *context,	// IN
+		       uint32_t gid)	// IN
+{
+	struct qp_broker_entry *entry;
+	const uint32_t contextId = VMCIContext_GetId(context);
+	bool isLocal = false;
+	int result;
+
+	if (VMCI_HANDLE_INVALID(handle) || !context
+	    || contextId == VMCI_INVALID_ID)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	down(&qpBrokerList.mutex);
+
+	if (!VMCIContext_QueuePairExists(context, handle)) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Context (ID=0x%x) not attached to queue pair "
+				"(handle=0x%x:0x%x).\n", contextId,
+				handle.context, handle.resource));
+		result = VMCI_ERROR_NOT_FOUND;
+		goto out;
+	}
+
+	entry = (struct qp_broker_entry *)
+	    QueuePairList_FindEntry(&qpBrokerList, handle);
+	if (!entry) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Context (ID=0x%x) reports being attached to queue pair "
+				"(handle=0x%x:0x%x) that isn't present in broker.\n",
+				contextId, handle.context, handle.resource));
+		result = VMCI_ERROR_NOT_FOUND;
+		goto out;
+	}
+
+	if (contextId != entry->createId && contextId != entry->attachId) {
+		result = VMCI_ERROR_QUEUEPAIR_NOTATTACHED;
+		goto out;
+	}
+
+	isLocal = entry->qp.flags & VMCI_QPFLAG_LOCAL;
+
+	if (contextId != VMCI_HOST_CONTEXT_ID) {
+		ASSERT(entry->state != VMCIQPB_CREATED_NO_MEM &&
+		       entry->state != VMCIQPB_SHUTDOWN_NO_MEM &&
+		       entry->state != VMCIQPB_ATTACHED_NO_MEM);
+		ASSERT(!isLocal);
+
+		VMCI_AcquireQueueMutex(entry->produceQ);
+		result = QueuePairSaveHeaders(entry);
+		if (result < VMCI_SUCCESS)
+			VMCI_WARNING((LGPFX
+				      "Failed to save queue headers for queue pair "
+				      "(handle=0x%x:0x%x,result=%d).\n",
+				      handle.context, handle.resource, result));
+
+		VMCIHost_UnmapQueueHeaders(gid,
+					   entry->produceQ, entry->consumeQ);
+
+		/*
+		 * On hosted, when we unmap queue pairs, the VMX will also
+		 * unmap the guest memory, so we invalidate the previously
+		 * registered memory. If the queue pair is mapped again at a
+		 * later point in time, we will need to reregister the user
+		 * memory with a possibly new user VA.
+		 */
+
+		VMCIHost_UnregisterUserMemory(entry->produceQ, entry->consumeQ);
+
+		/*
+		 * Move state from *_MEM to *_NO_MEM.
+		 */
+
+		entry->state--;
+
+		VMCI_ReleaseQueueMutex(entry->produceQ);
+	}
+
+	result = VMCI_SUCCESS;
+ out:
+	up(&qpBrokerList.mutex);
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPGuestEndpoints_Init --
+ *
+ *      Initalizes data structure state keeping track of queue pair
+ *      guest endpoints.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success and appropriate failure code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIQPGuestEndpoints_Init(void)
+{
+	int err = QueuePairList_Init(&qpGuestEndpoints);
+
+	if (err < VMCI_SUCCESS)
+		return err;
+
+	hibernateFailedList = VMCIHandleArray_Create(0);
+	if (NULL == hibernateFailedList) {
+		QueuePairList_Destroy(&qpGuestEndpoints);
+		return VMCI_ERROR_NO_MEM;
+	}
+
+	/*
+	 * The lock rank must be lower than subscriberLock in vmciEvent,
+	 * since we hold the hibernateFailedListLock while generating
+	 * detach events.
+	 */
+
+	spin_lock_init(&hibernateFailedListLock);
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPGuestEndpoints_Exit --
+ *
+ *      Destroys all guest queue pair endpoints. If active guest queue
+ *      pairs still exist, hypercalls to attempt detach from these
+ *      queue pairs will be made. Any failure to detach is silently
+ *      ignored.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+void VMCIQPGuestEndpoints_Exit(void)
+{
+	struct qp_guest_endpoint *entry;
+
+	down(&qpGuestEndpoints.mutex);
+
+	while ((entry = (struct qp_guest_endpoint *)
+		QueuePairList_GetHead(&qpGuestEndpoints))) {
+
+		/* Don't make a hypercall for local QueuePairs. */
+		if (!(entry->qp.flags & VMCI_QPFLAG_LOCAL))
+			VMCIQueuePairDetachHypercall(entry->qp.handle);
+
+		/* We cannot fail the exit, so let's reset refCount. */
+		entry->qp.refCount = 0;
+		QueuePairList_RemoveEntry(&qpGuestEndpoints, &entry->qp);
+		QPGuestEndpointDestroy(entry);
+	}
+
+	atomic_set(&qpGuestEndpoints.hibernate, 0);
+	up(&qpGuestEndpoints.mutex);
+	QueuePairList_Destroy(&qpGuestEndpoints);
+	VMCIHandleArray_Destroy(hibernateFailedList);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPGuestEndpoints_Sync --
+ *
+ *      Use this as a synchronization point when setting globals, for example,
+ *      during device shutdown.
+ *
+ * Results:
+ *      true.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+void VMCIQPGuestEndpoints_Sync(void)
+{
+	down(&qpGuestEndpoints.mutex);
+	up(&qpGuestEndpoints.mutex);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPMarkHibernateFailed --
+ *
+ *      Helper function that marks a queue pair entry as not being
+ *      converted to a local version during hibernation. Must be
+ *      called with the queue pair list mutex held.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void VMCIQPMarkHibernateFailed(struct qp_guest_endpoint *entry)	// IN
+{
+	struct vmci_handle handle;
+
+	/*
+	 * entry->handle is located in paged memory, so it can't be
+	 * accessed while holding a spinlock.
+	 */
+
+	handle = entry->qp.handle;
+	entry->hibernateFailure = true;
+	spin_lock_bh(&hibernateFailedListLock);
+	VMCIHandleArray_AppendEntry(&hibernateFailedList, handle);
+	spin_unlock_bh(&hibernateFailedListLock);
+}
+
+/*
+ *----------------------------------------------------------------------------
+ *
+ * VMCIQPGuestEndpoints_Convert --
+ *
+ *      Guest queue pair endpoints may be converted to local ones in
+ *      two cases: when entering hibernation or when the device is
+ *      powered off before entering a sleep mode. Below we first
+ *      discuss the case of hibernation and then the case of entering
+ *      sleep state.
+ *
+ *      When the guest enters hibernation, any non-local queue pairs
+ *      will disconnect no later than at the time the VMCI device
+ *      powers off. To preserve the content of the non-local queue
+ *      pairs for this guest, we make a local copy of the content and
+ *      disconnect from the queue pairs. This will ensure that the
+ *      peer doesn't continue to update the queue pair state while the
+ *      guest OS is checkpointing the memory (otherwise we might end
+ *      up with a inconsistent snapshot where the pointers of the
+ *      consume queue are checkpointed later than the data pages they
+ *      point to, possibly indicating that non-valid data is
+ *      valid). While we are in hibernation mode, we block the
+ *      allocation of new non-local queue pairs. Note that while we
+ *      are doing the conversion to local queue pairs, we are holding
+ *      the queue pair list lock, which will prevent concurrent
+ *      creation of additional non-local queue pairs.
+ *
+ *      The hibernation cannot fail, so if we are unable to either
+ *      save the queue pair state or detach from a queue pair, we deal
+ *      with it by keeping the queue pair around, and converting it to
+ *      a local queue pair when going out of hibernation. Since
+ *      failing a detach is highly unlikely (it would require a queue
+ *      pair being actively used as part of a DMA operation), this is
+ *      an acceptable fall back. Once we come back from hibernation,
+ *      these queue pairs will no longer be external, so we simply
+ *      mark them as local at that point.
+ *
+ *      For the sleep state, the VMCI device will also be put into the
+ *      D3 power state, which may make the device inaccessible to the
+ *      guest driver (Windows unmaps the I/O space). When entering
+ *      sleep state, the hypervisor is likely to suspend the guest as
+ *      well, which will again convert all queue pairs to local ones.
+ *      However, VMCI device clients, e.g., VMCI Sockets, may attempt
+ *      to use queue pairs after the device has been put into the D3
+ *      power state, so we convert the queue pairs to local ones in
+ *      that case as well. When exiting the sleep states, the device
+ *      has not been reset, so all device state is still in sync with
+ *      the device driver, so no further processing is necessary at
+ *      that point.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      Queue pairs are detached.
+ *
+ *----------------------------------------------------------------------------
+ */
+
+void VMCIQPGuestEndpoints_Convert(bool toLocal,	// IN
+				  bool deviceReset)	// IN
+{
+	if (toLocal) {
+		struct list_head *next;
+
+		down(&qpGuestEndpoints.mutex);
+
+		list_for_each(next, &qpGuestEndpoints.head) {
+			struct qp_guest_endpoint *entry =
+			    (struct qp_guest_endpoint *)list_entry(next,
+								   struct
+								   qp_entry,
+								   listItem);
+
+			if (!(entry->qp.flags & VMCI_QPFLAG_LOCAL)) {
+				UNUSED_PARAM(struct vmci_queue *prodQ);	// Only used on Win32
+				UNUSED_PARAM(struct vmci_queue *consQ);	// Only used on Win32
+				void *oldProdQ;
+				UNUSED_PARAM(void *oldConsQ);	// Only used on Win32
+				int result;
+
+				prodQ = (struct vmci_queue *)entry->produceQ;
+				consQ = (struct vmci_queue *)entry->consumeQ;
+				oldConsQ = oldProdQ = NULL;
+
+				VMCI_AcquireQueueMutex(prodQ);
+
+				// XXX: CLEANUP!  USELESS CODE HERE
+				result = VMCI_ERROR_UNAVAILABLE;
+				if (result != VMCI_SUCCESS) {
+					VMCI_WARNING((LGPFX
+						      "Hibernate failed to create local consume "
+						      "queue from handle %x:%x (error: %d)\n",
+						      entry->qp.handle.context,
+						      entry->qp.handle.resource,
+						      result));
+					VMCI_ReleaseQueueMutex(prodQ);
+					VMCIQPMarkHibernateFailed(entry);
+					continue;
+				}
+				// XXX: CLEANUP.  DEFINED to this always.  Code to remove.
+				result = VMCI_ERROR_UNAVAILABLE;
+				if (result != VMCI_SUCCESS) {
+					VMCI_WARNING((LGPFX
+						      "Hibernate failed to create local produce "
+						      "queue from handle %x:%x (error: %d)\n",
+						      entry->qp.handle.context,
+						      entry->qp.handle.resource,
+						      result));
+					VMCI_ReleaseQueueMutex(prodQ);
+					VMCIQPMarkHibernateFailed(entry);
+					continue;
+				}
+
+				/*
+				 * Now that the contents of the queue pair has been saved,
+				 * we can detach from the non-local queue pair. This will
+				 * discard the content of the non-local queues.
+				 */
+
+				result =
+				    VMCIQueuePairDetachHypercall(entry->
+								 qp.handle);
+				if (result < VMCI_SUCCESS) {
+					VMCI_WARNING((LGPFX
+						      "Hibernate failed to detach from handle "
+						      "%x:%x\n",
+						      entry->qp.handle.context,
+						      entry->qp.
+						      handle.resource));
+					VMCI_ReleaseQueueMutex(prodQ);
+					VMCIQPMarkHibernateFailed(entry);
+					continue;
+				}
+
+				entry->qp.flags |= VMCI_QPFLAG_LOCAL;
+
+				VMCI_ReleaseQueueMutex(prodQ);
+
+				QueuePairNotifyPeerLocal(false,
+							 entry->qp.handle);
+			}
+		}
+		atomic_set(&qpGuestEndpoints.hibernate, 1);
+
+		up(&qpGuestEndpoints.mutex);
+	} else {
+		struct vmci_handle handle;
+
+		/*
+		 * When a guest enters hibernation, there may be queue pairs
+		 * around, that couldn't be converted to local queue
+		 * pairs. When coming out of hibernation, these queue pairs
+		 * will be restored as part of the guest main mem by the OS
+		 * hibernation code and they can now be regarded as local
+		 * versions. Since they are no longer connected, detach
+		 * notifications are sent to the local endpoint.
+		 */
+
+		spin_lock_bh(&hibernateFailedListLock);
+		while (VMCIHandleArray_GetSize(hibernateFailedList) > 0) {
+			handle =
+			    VMCIHandleArray_RemoveTail(hibernateFailedList);
+			if (deviceReset) {
+				QueuePairNotifyPeerLocal(false, handle);
+			}
+		}
+		spin_unlock_bh(&hibernateFailedListLock);
+
+		atomic_set(&qpGuestEndpoints.hibernate, 0);
+	}
+}
diff --git a/drivers/misc/vmw_vmci/vmciQueuePair.h b/drivers/misc/vmw_vmci/vmciQueuePair.h
new file mode 100644
index 0000000..d4fb0bf
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciQueuePair.h
@@ -0,0 +1,95 @@
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
+#ifndef _VMCI_QUEUE_PAIR_H_
+#define _VMCI_QUEUE_PAIR_H_
+
+#include "vmci_defs.h"
+#include "vmci_iocontrols.h"
+#include "vmci_kernel_if.h"
+#include "vmciContext.h"
+#include "vmciQueue.h"
+
+/*
+ * QueuePairPageStore describes how the memory of a given queue pair
+ * is backed. When the queue pair is between the host and a guest, the
+ * page store consists of references to the guest pages. On vmkernel,
+ * this is a list of PPNs, and on hosted, it is a user VA where the
+ * queue pair is mapped into the VMX address space.
+ */
+
+typedef struct QueuePairPageStore {
+	uint64_t pages;		// Reference to pages backing the queue pair.
+	uint32_t len;		// Length of pageList/virtual addres range (in pages).
+} QueuePairPageStore;
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  VMCI_QP_PAGESTORE_IS_WELLFORMED --
+ *
+ *     Utility function that checks whether the fields of the page
+ *     store contain valid values.
+ *
+ *  Result:
+ *     true if the page store is wellformed. false otherwise.
+ *
+ *  Side effects:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static inline bool VMCI_QP_PAGESTORE_IS_WELLFORMED(QueuePairPageStore * pageStore)	// IN
+{
+	return pageStore->len >= 2;
+}
+
+int VMCIQPBroker_Init(void);
+void VMCIQPBroker_Exit(void);
+int VMCIQPBroker_Alloc(struct vmci_handle handle, uint32_t peer,
+		       uint32_t flags, uint32_t privFlags,
+		       uint64_t produceSize, uint64_t consumeSize,
+		       QueuePairPageStore * pageStore,
+		       struct vmci_context *context);
+int VMCIQPBroker_SetPageStore(struct vmci_handle handle,
+			      uint64_t produceUVA, uint64_t consumeUVA,
+			      struct vmci_context *context);
+int VMCIQPBroker_Detach(struct vmci_handle handle,
+			struct vmci_context *context);
+
+int VMCIQPGuestEndpoints_Init(void);
+void VMCIQPGuestEndpoints_Exit(void);
+void VMCIQPGuestEndpoints_Sync(void);
+void VMCIQPGuestEndpoints_Convert(bool toLocal, bool deviceReset);
+
+int VMCIQueuePair_Alloc(struct vmci_handle *handle,
+			struct vmci_queue **produceQ, uint64_t produceSize,
+			struct vmci_queue **consumeQ, uint64_t consumeSize,
+			uint32_t peer, uint32_t flags, uint32_t privFlags,
+			bool guestEndpoint, VMCIEventReleaseCB wakeupCB,
+			void *clientData);
+int VMCIQueuePair_Detach(struct vmci_handle handle, bool guestEndpoint);
+int VMCIQPBroker_Map(struct vmci_handle handle,
+		     struct vmci_context *context, uint64_t guestMem);
+int VMCIQPBroker_Unmap(struct vmci_handle handle,
+		       struct vmci_context *context, uint32_t gid);
+
+#endif				/* !_VMCI_QUEUE_PAIR_H_ */
-- 
1.7.0.4

