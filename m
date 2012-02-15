Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520Ab2BOBPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 20:15:03 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:52332 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757539Ab2BOBOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 20:14:44 -0500
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: vm-crosstalk@vmware.com, dtor@vmware.com, cschamp@vmware.com,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [PATCH 03/14] Add vmciDoorbell.*
Date: Tue, 14 Feb 2012 17:05:44 -0800
Message-Id: <1329267955-32367-4-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
References: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/misc/vmw_vmci/vmciDoorbell.c | 1072 ++++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmciDoorbell.h |   37 ++
 2 files changed, 1109 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmciDoorbell.c
 create mode 100644 drivers/misc/vmw_vmci/vmciDoorbell.h

diff --git a/drivers/misc/vmw_vmci/vmciDoorbell.c b/drivers/misc/vmw_vmci/vmciDoorbell.c
new file mode 100644
index 0000000..e14e7f8
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciDoorbell.c
@@ -0,0 +1,1072 @@
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+
+#include "vmci_defs.h"
+#include "vmci_infrastructure.h"
+#include "vmci_kernel_if.h"
+#include "vmciCommonInt.h"
+#include "vmciDatagram.h"
+#include "vmciDoorbell.h"
+#include "vmciDriver.h"
+#include "vmciKernelAPI.h"
+#include "vmciResource.h"
+#include "vmciRoute.h"
+
+#define LGPFX "VMCIDoorbell: "
+
+#define VMCI_DOORBELL_INDEX_TABLE_SIZE 64
+#define VMCI_DOORBELL_HASH(_idx)				\
+	VMCI_HashId((_idx), VMCI_DOORBELL_INDEX_TABLE_SIZE)
+
+/*
+ * DoorbellEntry describes the a doorbell notification handle allocated by the
+ * host.
+ */
+
+struct doorbell_entry {
+	struct vmci_resource resource;
+	uint32_t idx;
+	struct list_head idxListItem;
+	uint32_t privFlags;
+	bool isDoorbell;
+	bool runDelayed;
+	VMCICallback notifyCB;
+	void *clientData;
+	wait_queue_head_t destroyEvent;
+	atomic_t active;	/* Only used by guest personality */
+};
+
+struct doorbell_index_table {
+	spinlock_t lock;
+	struct list_head entries[VMCI_DOORBELL_INDEX_TABLE_SIZE];
+};
+
+/* The VMCI index table keeps track of currently registered doorbells. */
+static struct doorbell_index_table vmciDoorbellIT;
+
+/*
+ * The maxNotifyIdx is one larger than the currently known bitmap index in
+ * use, and is used to determine how much of the bitmap needs to be scanned.
+ */
+static uint32_t maxNotifyIdx;
+
+/*
+ * The notifyIdxCount is used for determining whether there are free entries
+ * within the bitmap (if notifyIdxCount + 1 < maxNotifyIdx).
+ */
+static uint32_t notifyIdxCount;
+
+/*
+ * The lastNotifyIdxReserved is used to track the last index handed out - in
+ * the case where multiple handles share a notification index, we hand out
+ * indexes round robin based on lastNotifyIdxReserved.
+ */
+static uint32_t lastNotifyIdxReserved;
+
+/* This is a one entry cache used to by the index allocation. */
+static uint32_t lastNotifyIdxReleased = PAGE_SIZE;
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDoorbell_Init --
+ *
+ *    General init code.
+ *
+ * Result:
+ *    VMCI_SUCCESS on success, lock allocation error otherwise.
+ *
+ * Side effects:
+ *    None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int VMCIDoorbell_Init(void)
+{
+	uint32_t bucket;
+
+	for (bucket = 0; bucket < ARRAY_SIZE(vmciDoorbellIT.entries); ++bucket)
+		INIT_LIST_HEAD(&vmciDoorbellIT.entries[bucket]);
+
+	spin_lock_init(&vmciDoorbellIT.lock);
+	return VMCI_SUCCESS;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDoorbellFreeCB --
+ *
+ *    Callback to free doorbell entry structure when resource is no longer used,
+ *    ie. the reference count reached 0.  The entry is freed in
+ *    VMCIDoorbell_Destroy(), which is waiting on the signal that gets fired
+ *    here.
+ *
+ * Result:
+ *    None.
+ *
+ * Side effects:
+ *    Signals VMCI event.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static void VMCIDoorbellFreeCB(void *clientData)	// IN
+{
+	struct doorbell_entry *entry = (struct doorbell_entry *)clientData;
+	ASSERT(entry);
+	wake_up(&entry->destroyEvent);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDoorbellReleaseCB --
+ *
+ *     Callback to release the resource reference. It is called by the
+ *     VMCI_WaitOnEvent function before it blocks.
+ *
+ * Result:
+ *     Always 0.
+ *
+ * Side effects:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static int VMCIDoorbellReleaseCB(void *clientData)	// IN: doorbell entry
+{
+	struct doorbell_entry *entry = (struct doorbell_entry *)clientData;
+	ASSERT(entry);
+	VMCIResource_Release(&entry->resource);
+	return 0;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDoorbellGetPrivFlags --
+ *
+ *    Utility function that retrieves the privilege flags associated
+ *    with a given doorbell handle. For guest endpoints, the
+ *    privileges are determined by the context ID, but for host
+ *    endpoints privileges are associated with the complete
+ *    handle. Hypervisor endpoints are not yet supported.
+ *
+ * Result:
+ *    VMCI_SUCCESS on success,
+ *    VMCI_ERROR_NOT_FOUND if handle isn't found,
+ *    VMCI_ERROR_INVALID_ARGS if handle is invalid.
+ *
+ * Side effects:
+ *    None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int VMCIDoorbellGetPrivFlags(struct vmci_handle handle,	// IN
+			     uint32_t * privFlags)	// OUT
+{
+	if (privFlags == NULL || handle.context == VMCI_INVALID_ID) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	if (handle.context == VMCI_HOST_CONTEXT_ID) {
+		struct doorbell_entry *entry;
+		struct vmci_resource *resource;
+
+		resource =
+		    VMCIResource_Get(handle, VMCI_RESOURCE_TYPE_DOORBELL);
+		if (resource == NULL)
+			return VMCI_ERROR_NOT_FOUND;
+
+		entry =
+		    RESOURCE_CONTAINER(resource, struct doorbell_entry,
+				       resource);
+		*privFlags = entry->privFlags;
+		VMCIResource_Release(resource);
+	} else if (handle.context == VMCI_HYPERVISOR_CONTEXT_ID) {
+		/* Hypervisor endpoints for notifications are not supported (yet). */
+		return VMCI_ERROR_INVALID_ARGS;
+	} else {
+		*privFlags = VMCIContext_GetPrivFlags(handle.context);
+	}
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIDoorbellIndexTableFind --
+ *
+ *    Find doorbell entry by bitmap index.
+ *
+ * Results:
+ *    Entry if found, NULL if not.
+ *
+ * Side effects:
+ *    None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static struct doorbell_entry *VMCIDoorbellIndexTableFind(uint32_t idx)	// IN
+{
+	uint32_t bucket = VMCI_DOORBELL_HASH(idx);
+	struct list_head *iter;
+
+	ASSERT(VMCI_GuestPersonalityActive());
+
+	list_for_each(iter, &vmciDoorbellIT.entries[bucket]) {
+		struct doorbell_entry *cur =
+		    list_entry(iter, struct doorbell_entry, idxListItem);
+
+		ASSERT(cur);
+
+		if (idx == cur->idx)
+			return cur;
+	}
+
+	return NULL;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDoorbellIndexTableAdd --
+ *
+ *    Add the given entry to the index table.  This will hold() the entry's
+ *    resource so that the entry is not deleted before it is removed from the
+ *    table.
+ *
+ * Results:
+ *    None.
+ *
+ * Side effects:
+ *    None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static void VMCIDoorbellIndexTableAdd(struct doorbell_entry *entry)	// IN/OUT
+{
+	uint32_t bucket;
+	uint32_t newNotifyIdx;
+
+	ASSERT(entry);
+	ASSERT(VMCI_GuestPersonalityActive());
+
+	VMCIResource_Hold(&entry->resource);
+
+	spin_lock_bh(&vmciDoorbellIT.lock);
+
+	/*
+	 * Below we try to allocate an index in the notification bitmap with "not
+	 * too much" sharing between resources. If we use less that the full bitmap,
+	 * we either add to the end if there are no unused flags within the
+	 * currently used area, or we search for unused ones. If we use the full
+	 * bitmap, we allocate the index round robin.
+	 */
+
+	if (maxNotifyIdx < PAGE_SIZE || notifyIdxCount < PAGE_SIZE) {
+		if (lastNotifyIdxReleased < maxNotifyIdx &&
+		    !VMCIDoorbellIndexTableFind(lastNotifyIdxReleased)) {
+			newNotifyIdx = lastNotifyIdxReleased;
+			lastNotifyIdxReleased = PAGE_SIZE;
+		} else {
+			bool reused = false;
+			newNotifyIdx = lastNotifyIdxReserved;
+			if (notifyIdxCount + 1 < maxNotifyIdx) {
+				do {
+					if (!VMCIDoorbellIndexTableFind
+					    (newNotifyIdx)) {
+						reused = true;
+						break;
+					}
+					newNotifyIdx =
+					    (newNotifyIdx + 1) % maxNotifyIdx;
+				} while (newNotifyIdx != lastNotifyIdxReleased);
+			}
+			if (!reused) {
+				newNotifyIdx = maxNotifyIdx;
+				maxNotifyIdx++;
+			}
+		}
+	} else {
+		newNotifyIdx = (lastNotifyIdxReserved + 1) % PAGE_SIZE;
+	}
+
+	lastNotifyIdxReserved = newNotifyIdx;
+	notifyIdxCount++;
+
+	entry->idx = newNotifyIdx;
+	bucket = VMCI_DOORBELL_HASH(entry->idx);
+	list_add(&entry->idxListItem, &vmciDoorbellIT.entries[bucket]);
+
+	spin_unlock_bh(&vmciDoorbellIT.lock);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDoorbellIndexTableRemove --
+ *
+ *    Remove the given entry from the index table.  This will release() the
+ *    entry's resource.
+ *
+ * Results:
+ *    None.
+ *
+ * Side effects:
+ *    None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static void VMCIDoorbellIndexTableRemove(struct doorbell_entry *entry)	// IN/OUT
+{
+	ASSERT(entry);
+	ASSERT(VMCI_GuestPersonalityActive());
+
+	spin_lock_bh(&vmciDoorbellIT.lock);
+
+	list_del(&entry->idxListItem);
+
+	notifyIdxCount--;
+	if (entry->idx == maxNotifyIdx - 1) {
+		/*
+		 * If we delete an entry with the maximum known notification index, we
+		 * take the opportunity to prune the current max. As there might be other
+		 * unused indices immediately below, we lower the maximum until we hit an
+		 * index in use.
+		 */
+
+		while (maxNotifyIdx > 0 &&
+		       !VMCIDoorbellIndexTableFind(maxNotifyIdx - 1)) {
+			maxNotifyIdx--;
+		}
+	}
+
+	lastNotifyIdxReleased = entry->idx;
+
+	spin_unlock_bh(&vmciDoorbellIT.lock);
+
+	VMCIResource_Release(&entry->resource);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDoorbellLink --
+ *
+ *    Creates a link between the given doorbell handle and the given
+ *    index in the bitmap in the device backend.
+ *
+ * Results:
+ *    VMCI_SUCCESS if success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *    Notification state is created in hypervisor.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static int VMCIDoorbellLink(struct vmci_handle handle,	// IN
+			    bool isDoorbell,	// IN
+			    uint32_t notifyIdx)	// IN
+{
+	uint32_t resourceID;
+	struct vmci_doorbell_link_msg linkMsg;
+
+	ASSERT(!VMCI_HANDLE_INVALID(handle));
+	ASSERT(VMCI_GuestPersonalityActive());
+
+	if (isDoorbell) {
+		resourceID = VMCI_DOORBELL_LINK;
+	} else {
+		/* XXX: Why would isDoorbell be false? */
+		ASSERT(false);
+	}
+
+	linkMsg.hdr.dst =
+	    VMCI_MAKE_HANDLE(VMCI_HYPERVISOR_CONTEXT_ID, resourceID);
+	linkMsg.hdr.src = VMCI_ANON_SRC_HANDLE;
+	linkMsg.hdr.payloadSize = sizeof linkMsg - VMCI_DG_HEADERSIZE;
+	linkMsg.handle = handle;
+	linkMsg.notifyIdx = notifyIdx;
+
+	return VMCI_SendDatagram((struct vmci_datagram *)&linkMsg);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDoorbellUnlink --
+ *
+ *    Unlinks the given doorbell handle from an index in the bitmap in
+ *    the device backend.
+ *
+ * Results:
+ *      VMCI_SUCCESS if success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      Notification state is destroyed in hypervisor.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static int VMCIDoorbellUnlink(struct vmci_handle handle,	// IN
+			      bool isDoorbell)	// IN
+{
+	uint32_t resourceID;
+	struct vmci_doorbell_unlink_msg unlinkMsg;
+
+	ASSERT(!VMCI_HANDLE_INVALID(handle));
+	ASSERT(VMCI_GuestPersonalityActive());
+
+	if (isDoorbell) {
+		resourceID = VMCI_DOORBELL_UNLINK;
+	} else {
+		/* XXX: Why would isDoorbell be false? */
+		ASSERT(false);
+	}
+
+	unlinkMsg.hdr.dst =
+	    VMCI_MAKE_HANDLE(VMCI_HYPERVISOR_CONTEXT_ID, resourceID);
+	unlinkMsg.hdr.src = VMCI_ANON_SRC_HANDLE;
+	unlinkMsg.hdr.payloadSize = sizeof unlinkMsg - VMCI_DG_HEADERSIZE;
+	unlinkMsg.handle = handle;
+
+	return VMCI_SendDatagram((struct vmci_datagram *)&unlinkMsg);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDoorbell_Create --
+ *
+ *    Creates a doorbell with the given callback. If the handle is
+ *    VMCI_INVALID_HANDLE, a free handle will be assigned, if
+ *    possible. The callback can be run immediately (potentially with
+ *    locks held - the default) or delayed (in a kernel thread) by
+ *    specifying the flag VMCI_FLAG_DELAYED_CB. If delayed execution
+ *    is selected, a given callback may not be run if the kernel is
+ *    unable to allocate memory for the delayed execution (highly
+ *    unlikely).
+ *
+ * Results:
+ *    VMCI_SUCCESS on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *    None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int VMCIDoorbell_Create(struct vmci_handle *handle,	// IN/OUT
+			uint32_t flags,	// IN
+			uint32_t privFlags,	// IN
+			VMCICallback notifyCB,	// IN
+			void *clientData)	// IN
+{
+	struct doorbell_entry *entry;
+	struct vmci_handle newHandle;
+	int result;
+
+	if (!handle || !notifyCB || flags & ~VMCI_FLAG_DELAYED_CB ||
+	    privFlags & ~VMCI_PRIVILEGE_ALL_FLAGS)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	entry = kmalloc(sizeof *entry, GFP_KERNEL);
+	if (entry == NULL) {
+		VMCI_WARNING((LGPFX
+			      "Failed allocating memory for datagram entry.\n"));
+		return VMCI_ERROR_NO_MEM;
+	}
+
+	if (VMCI_HANDLE_INVALID(*handle)) {
+		uint32_t contextID = VMCI_GetContextID();
+		uint32_t resourceID = VMCIResource_GetID(contextID);
+		if (resourceID == VMCI_INVALID_ID) {
+			result = VMCI_ERROR_NO_HANDLE;
+			goto freeMem;
+		}
+		newHandle = VMCI_MAKE_HANDLE(contextID, resourceID);
+	} else {
+		bool validContext = false;
+
+		/*
+		 * Validate the handle.  We must do both of the checks below
+		 * because we can be acting as both a host and a guest at the
+		 * same time. We always allow the host context ID, since the
+		 * host functionality is in practice always there with the
+		 * unified driver.
+		 */
+
+		if (VMCI_HOST_CONTEXT_ID == handle->context ||
+		    (VMCI_GuestPersonalityActive() &&
+		     VMCI_GetContextID() == handle->context))
+			validContext = true;
+
+		if (!validContext || VMCI_INVALID_ID == handle->resource) {
+			VMCI_DEBUG_LOG(4,
+				       (LGPFX
+					"Invalid argument (handle=0x%x:0x%x).\n",
+					handle->context, handle->resource));
+			result = VMCI_ERROR_INVALID_ARGS;
+			goto freeMem;
+		}
+
+		newHandle = *handle;
+	}
+
+	entry->idx = 0;
+	INIT_LIST_HEAD(&entry->idxListItem);
+	entry->privFlags = privFlags;
+	entry->isDoorbell = true;
+	entry->runDelayed = (flags & VMCI_FLAG_DELAYED_CB) ? true : false;
+	entry->notifyCB = notifyCB;
+	entry->clientData = clientData;
+	atomic_set(&entry->active, 0);
+	init_waitqueue_head(&entry->destroyEvent);
+
+	result =
+	    VMCIResource_Add(&entry->resource, VMCI_RESOURCE_TYPE_DOORBELL,
+			     newHandle, VMCIDoorbellFreeCB, entry);
+	if (result != VMCI_SUCCESS) {
+		VMCI_WARNING((LGPFX
+			      "Failed to add new resource (handle=0x%x:0x%x).\n",
+			      newHandle.context, newHandle.resource));
+		if (result == VMCI_ERROR_DUPLICATE_ENTRY) {
+			result = VMCI_ERROR_ALREADY_EXISTS;
+		}
+		goto freeMem;
+	}
+
+	if (VMCI_GuestPersonalityActive()) {
+		VMCIDoorbellIndexTableAdd(entry);
+		result =
+		    VMCIDoorbellLink(newHandle, entry->isDoorbell, entry->idx);
+		if (VMCI_SUCCESS != result)
+			goto destroyResource;
+
+		atomic_set(&entry->active, 1);
+	}
+
+	if (VMCI_HANDLE_INVALID(*handle)) {
+		*handle = newHandle;
+	}
+
+	return result;
+
+ destroyResource:
+	VMCIDoorbellIndexTableRemove(entry);
+	VMCIResource_Remove(newHandle, VMCI_RESOURCE_TYPE_DOORBELL);
+ freeMem:
+	kfree(entry);
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIDoorbell_Create);
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDoorbell_Destroy --
+ *
+ *    Destroys a doorbell previously created with
+ *    VMCIDoorbell_Create. This operation may block waiting for a
+ *    callback to finish.
+ *
+ * Results:
+ *    VMCI_SUCCESS on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *    May block.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int VMCIDoorbell_Destroy(struct vmci_handle handle)	// IN
+{
+	struct doorbell_entry *entry;
+	struct vmci_resource *resource;
+
+	if (VMCI_HANDLE_INVALID(handle))
+		return VMCI_ERROR_INVALID_ARGS;
+
+	resource = VMCIResource_Get(handle, VMCI_RESOURCE_TYPE_DOORBELL);
+	if (resource == NULL) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Failed to destroy doorbell (handle=0x%x:0x%x).\n",
+				handle.context, handle.resource));
+		return VMCI_ERROR_NOT_FOUND;
+	}
+
+	entry = RESOURCE_CONTAINER(resource, struct doorbell_entry, resource);
+
+	if (VMCI_GuestPersonalityActive()) {
+		int result;
+
+		VMCIDoorbellIndexTableRemove(entry);
+
+		result = VMCIDoorbellUnlink(handle, entry->isDoorbell);
+		if (VMCI_SUCCESS != result) {
+
+			/*
+			 * The only reason this should fail would be an inconsistency between
+			 * guest and hypervisor state, where the guest believes it has an
+			 * active registration whereas the hypervisor doesn't. One case where
+			 * this may happen is if a doorbell is unregistered following a
+			 * hibernation at a time where the doorbell state hasn't been restored
+			 * on the hypervisor side yet. Since the handle has now been removed
+			 * in the guest, we just print a warning and return success.
+			 */
+
+			VMCI_DEBUG_LOG(4,
+				       (LGPFX
+					"Unlink of %s (handle=0x%x:0x%x) unknown by "
+					"hypervisor (error=%d).\n",
+					entry->isDoorbell ? "doorbell" :
+					"queuepair", handle.context,
+					handle.resource, result));
+		}
+	}
+
+	/*
+	 * Now remove the resource from the table.  It might still be in use
+	 * after this, in a callback or still on the delayed work queue.
+	 */
+	VMCIResource_Remove(handle, VMCI_RESOURCE_TYPE_DOORBELL);
+
+	/*
+	 * We now wait on the destroyEvent and release the reference we got
+	 * above.
+	 */
+	VMCI_WaitOnEvent(&entry->destroyEvent, VMCIDoorbellReleaseCB, entry);
+
+	/*
+	 * We know that we are now the only reference to the above entry so
+	 * can safely free it.
+	 */
+	kfree(entry);
+
+	return VMCI_SUCCESS;
+}
+
+EXPORT_SYMBOL(VMCIDoorbell_Destroy);
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDoorbellNotifyAsGuest --
+ *
+ *    Notify another guest or the host.  We send a datagram down to the
+ *    host via the hypervisor with the notification info.
+ *
+ * Results:
+ *    VMCI_SUCCESS on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *    May do a hypercall.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static int VMCIDoorbellNotifyAsGuest(struct vmci_handle handle,	// IN
+				     uint32_t privFlags)	// IN
+{
+	struct vmci_doorbell_ntfy_msg notifyMsg;
+
+	ASSERT(VMCI_GuestPersonalityActive());
+
+	notifyMsg.hdr.dst = VMCI_MAKE_HANDLE(VMCI_HYPERVISOR_CONTEXT_ID,
+					     VMCI_DOORBELL_NOTIFY);
+	notifyMsg.hdr.src = VMCI_ANON_SRC_HANDLE;
+	notifyMsg.hdr.payloadSize = sizeof notifyMsg - VMCI_DG_HEADERSIZE;
+	notifyMsg.handle = handle;
+
+	return VMCI_SendDatagram((struct vmci_datagram *)&notifyMsg);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDoorbell_Notify --
+ *
+ *    Generates a notification on the doorbell identified by the
+ *    handle. For host side generation of notifications, the caller
+ *    can specify what the privilege of the calling side is.
+ *
+ * Results:
+ *    VMCI_SUCCESS on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *    May do a hypercall.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int VMCIDoorbell_Notify(struct vmci_handle dst,	// IN
+			uint32_t privFlags)	// IN
+{
+	int retval;
+	enum vmci_route route;
+	struct vmci_handle src;
+
+	if (VMCI_HANDLE_INVALID(dst)
+	    || (privFlags & ~VMCI_PRIVILEGE_ALL_FLAGS))
+		return VMCI_ERROR_INVALID_ARGS;
+
+	src = VMCI_INVALID_HANDLE;
+	retval = VMCI_Route(&src, &dst, false, &route);
+	if (retval < VMCI_SUCCESS)
+		return retval;
+
+	if (VMCI_ROUTE_AS_HOST == route)
+		return VMCIContext_NotifyDoorbell(VMCI_HOST_CONTEXT_ID,
+						  dst, privFlags);
+
+	if (VMCI_ROUTE_AS_GUEST == route)
+		return VMCIDoorbellNotifyAsGuest(dst, privFlags);
+
+	VMCI_WARNING((LGPFX "Unknown route (%d) for doorbell.\n", route));
+	return VMCI_ERROR_DST_UNREACHABLE;
+}
+
+EXPORT_SYMBOL(VMCIDoorbell_Notify);
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDoorbellDelayedDispatchCB --
+ *
+ *    Calls the specified callback in a delayed context.
+ *
+ * Results:
+ *    None.
+ *
+ * Side effects:
+ *    None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static void VMCIDoorbellDelayedDispatchCB(void *data)	// IN
+{
+	struct doorbell_entry *entry = (struct doorbell_entry *)data;
+
+	ASSERT(data);
+
+	entry->notifyCB(entry->clientData);
+
+	VMCIResource_Release(&entry->resource);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDoorbellHostContextNotify --
+ *
+ *    Dispatches a doorbell notification to the host context.
+ *
+ * Results:
+ *    VMCI_SUCCESS on success. Appropriate error code otherwise.
+ *
+ * Side effects:
+ *    None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int VMCIDoorbellHostContextNotify(uint32_t srcCID,	// IN
+				  struct vmci_handle handle)	// IN
+{
+	struct doorbell_entry *entry;
+	struct vmci_resource *resource;
+	int result;
+
+	ASSERT(VMCI_HostPersonalityActive());
+
+	if (VMCI_HANDLE_INVALID(handle)) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Notifying an invalid doorbell (handle=0x%x:0x%x).\n",
+				handle.context, handle.resource));
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	resource = VMCIResource_Get(handle, VMCI_RESOURCE_TYPE_DOORBELL);
+	if (resource == NULL) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Notifying an unknown doorbell (handle=0x%x:0x%x).\n",
+				handle.context, handle.resource));
+		return VMCI_ERROR_NOT_FOUND;
+	}
+	entry = RESOURCE_CONTAINER(resource, struct doorbell_entry, resource);
+
+	if (entry->runDelayed) {
+		result =
+		    VMCI_ScheduleDelayedWork(VMCIDoorbellDelayedDispatchCB,
+					     entry);
+		if (result < VMCI_SUCCESS) {
+			/*
+			 * If we failed to schedule the delayed work, we need to
+			 * release the resource immediately. Otherwise, the resource
+			 * will be released once the delayed callback has been
+			 * completed.
+			 */
+
+			VMCI_DEBUG_LOG(10,
+				       (LGPFX
+					"Failed to schedule delayed doorbell "
+					"notification (result=%d).\n", result));
+			VMCIResource_Release(resource);
+		}
+	} else {
+		entry->notifyCB(entry->clientData);
+		VMCIResource_Release(resource);
+		result = VMCI_SUCCESS;
+	}
+	return result;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDoorbell_Hibernate --
+ *
+ *      When a guest leaves hibernation, the device driver state is out of sync
+ *      with the device state, since the driver state has doorbells registered
+ *      that aren't known to the device.  This function takes care of
+ *      reregistering any doorbells. In case an error occurs during
+ *      reregistration (this is highly unlikely since 1) it succeeded the first
+ *      time 2) the device driver is the only source of doorbell registrations),
+ *      we simply log the error.  The doorbell can still be destroyed using
+ *      VMCIDoorbell_Destroy.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+void VMCIDoorbell_Hibernate(bool enterHibernate)
+{
+	uint32_t bucket;
+	struct list_head *iter;
+
+	if (!VMCI_GuestPersonalityActive() || enterHibernate)
+		return;
+
+	spin_lock_bh(&vmciDoorbellIT.lock);
+
+	for (bucket = 0; bucket < ARRAY_SIZE(vmciDoorbellIT.entries); bucket++) {
+		list_for_each(iter, &vmciDoorbellIT.entries[bucket]) {
+			int result;
+			struct vmci_handle h;
+			struct doorbell_entry *cur;
+
+			cur =
+			    list_entry(iter, struct doorbell_entry,
+				       idxListItem);
+			h = VMCIResource_Handle(&cur->resource);
+			result = VMCIDoorbellLink(h, cur->isDoorbell, cur->idx);
+			if (result != VMCI_SUCCESS
+			    && result != VMCI_ERROR_DUPLICATE_ENTRY) {
+				VMCI_WARNING((LGPFX
+					      "Failed to reregister doorbell "
+					      "(handle=0x%x:0x%x) of resource %s to index "
+					      "(error=%d).\n", h.context,
+					      h.resource,
+					      cur->isDoorbell ? "doorbell" :
+					      "queue pair", result));
+			}
+		}
+	}
+
+	spin_unlock_bh(&vmciDoorbellIT.lock);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDoorbell_Sync --
+ *
+ *      Use this as a synchronization point when setting globals, for example,
+ *      during device shutdown.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+void VMCIDoorbell_Sync(void)
+{
+	spin_lock_bh(&vmciDoorbellIT.lock);
+	spin_unlock_bh(&vmciDoorbellIT.lock);
+	VMCIResource_Sync();
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCI_RegisterNotificationBitmap --
+ *
+ *      Register the notification bitmap with the host.
+ *
+ * Results:
+ *      true if the bitmap is registered successfully with the device, false
+ *      otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+bool VMCI_RegisterNotificationBitmap(uint32_t bitmapPPN)
+{
+	int result;
+	struct vmci_ntfy_bm_set_msg bitmapSetMsg;
+
+	/*
+	 * Do not ASSERT() on the guest device here.  This function can get called
+	 * during device initialization, so the ASSERT() will fail even though
+	 * the device is (almost) up.
+	 */
+
+	bitmapSetMsg.hdr.dst = VMCI_MAKE_HANDLE(VMCI_HYPERVISOR_CONTEXT_ID,
+						VMCI_SET_NOTIFY_BITMAP);
+	bitmapSetMsg.hdr.src = VMCI_ANON_SRC_HANDLE;
+	bitmapSetMsg.hdr.payloadSize = sizeof bitmapSetMsg - VMCI_DG_HEADERSIZE;
+	bitmapSetMsg.bitmapPPN = bitmapPPN;
+
+	result = VMCI_SendDatagram((struct vmci_datagram *)&bitmapSetMsg);
+	if (result != VMCI_SUCCESS) {
+		VMCI_DEBUG_LOG(4, (LGPFX "Failed to register (PPN=%u) as "
+				   "notification bitmap (error=%d).\n",
+				   bitmapPPN, result));
+		return false;
+	}
+	return true;
+}
+
+/*
+ *-------------------------------------------------------------------------
+ *
+ * VMCIDoorbellFireEntries --
+ *
+ *     Executes or schedules the handlers for a given notify index.
+ *
+ * Result:
+ *     Notification hash entry if found. NULL otherwise.
+ *
+ * Side effects:
+ *     Whatever the side effects of the handlers are.
+ *
+ *-------------------------------------------------------------------------
+ */
+
+static void VMCIDoorbellFireEntries(uint32_t notifyIdx)	// IN
+{
+	uint32_t bucket = VMCI_DOORBELL_HASH(notifyIdx);
+	struct list_head *iter;
+
+	ASSERT(VMCI_GuestPersonalityActive());
+
+	spin_lock_bh(&vmciDoorbellIT.lock);
+
+	list_for_each(iter, &vmciDoorbellIT.entries[bucket]) {
+		struct doorbell_entry *cur =
+		    list_entry(iter, struct doorbell_entry, idxListItem);
+
+		ASSERT(cur);
+
+		if (cur->idx == notifyIdx && atomic_read(&cur->active) == 1) {
+			ASSERT(cur->notifyCB);
+			if (cur->runDelayed) {
+				int err;
+
+				VMCIResource_Hold(&cur->resource);
+				err =
+				    VMCI_ScheduleDelayedWork
+				    (VMCIDoorbellDelayedDispatchCB, cur);
+				if (err != VMCI_SUCCESS) {
+					VMCIResource_Release(&cur->resource);
+					goto out;
+				}
+			} else {
+				cur->notifyCB(cur->clientData);
+			}
+		}
+	}
+
+ out:
+	spin_unlock_bh(&vmciDoorbellIT.lock);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCI_ScanNotificationBitmap --
+ *
+ *      Scans the notification bitmap, collects pending notifications,
+ *      resets the bitmap and invokes appropriate callbacks.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      May schedule tasks, allocate memory and run callbacks.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+void VMCI_ScanNotificationBitmap(uint8_t * bitmap)
+{
+	uint32_t idx;
+
+	ASSERT(bitmap);
+	ASSERT(VMCI_GuestPersonalityActive());
+
+	for (idx = 0; idx < maxNotifyIdx; idx++) {
+		if (bitmap[idx] & 0x1) {
+			bitmap[idx] &= ~1;
+			VMCIDoorbellFireEntries(idx);
+		}
+	}
+}
diff --git a/drivers/misc/vmw_vmci/vmciDoorbell.h b/drivers/misc/vmw_vmci/vmciDoorbell.h
new file mode 100644
index 0000000..a039261
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciDoorbell.h
@@ -0,0 +1,37 @@
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
+#ifndef VMCI_DOORBELL_H
+#define VMCI_DOORBELL_H
+
+#include "vmci_defs.h"
+#include "vmci_kernel_if.h"
+
+int VMCIDoorbell_Init(void);
+void VMCIDoorbell_Hibernate(bool enterHibernation);
+void VMCIDoorbell_Sync(void);
+
+int VMCIDoorbellHostContextNotify(uint32_t srcCID, struct vmci_handle handle);
+int VMCIDoorbellGetPrivFlags(struct vmci_handle handle, uint32_t * privFlags);
+
+bool VMCI_RegisterNotificationBitmap(uint32_t bitmapPPN);
+void VMCI_ScanNotificationBitmap(uint8_t * bitmap);
+
+#endif				// VMCI_DOORBELL_H
-- 
1.7.0.4

