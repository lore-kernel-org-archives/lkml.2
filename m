Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136Ab2EOPJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:09:56 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:55147 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933044Ab2EOPHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:07:25 -0400
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: acking@vmware.com, dtor@vmware.com, dsouders@vmware.com,
        cschamp@vmware.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, virtualization@lists.linux-foundation.org,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [vmw_vmci RFC 03/11] Apply VMCI doorbell code
Date: Tue, 15 May 2012 08:07:00 -0700
Message-Id: <1337094428-20453-4-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337094428-20453-1-git-send-email-astiegmann@vmware.com>
References: <1337094428-20453-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doorbell code allows for notifcations between host and guest.

Signed-off-by: Andrew Stiegmann (stieg) <astiegmann@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_doorbell.c |  989 +++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_doorbell.h |   57 ++
 2 files changed, 1046 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmci_doorbell.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_doorbell.h

diff --git a/drivers/misc/vmw_vmci/vmci_doorbell.c b/drivers/misc/vmw_vmci/vmci_doorbell.c
new file mode 100644
index 0000000..f46a87f
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_doorbell.c
@@ -0,0 +1,989 @@
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
+#include <linux/vmw_vmci_api.h>
+#include <linux/vmw_vmci_defs.h>
+
+#include "vmci_common_int.h"
+#include "vmci_datagram.h"
+#include "vmci_doorbell.h"
+#include "vmci_driver.h"
+#include "vmci_resource.h"
+#include "vmci_route.h"
+
+#define VMCI_DOORBELL_INDEX_TABLE_SIZE (1 << 6)
+#define VMCI_DOORBELL_HASH(_idx)				\
+	vmci_hash_calc((_idx), VMCI_DOORBELL_INDEX_TABLE_SIZE)
+
+/*
+ * DoorbellEntry describes the a doorbell notification handle allocated by the
+ * host.
+ */
+struct dbell_entry {
+	struct vmci_resource resource;
+	uint32_t idx;
+	struct list_head idxListItem;
+	uint32_t privFlags;
+	bool runDelayed;
+	VMCICallback notifyCB;
+	void *clientData;
+	wait_queue_head_t destroyEvent;
+	atomic_t active;	/* Only used by guest personality */
+};
+
+/* The VMCI index table keeps track of currently registered doorbells. */
+static struct dbell_index_table {
+	spinlock_t lock;
+	struct list_head entries[VMCI_DOORBELL_INDEX_TABLE_SIZE];
+} vmciDoorbellIT;
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
+ * vmci_dbell_init --
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
+int __init vmci_dbell_init(void)
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
+ * dbell_free_cb --
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
+static void dbell_free_cb(void *clientData)	// IN
+{
+	struct dbell_entry *entry = (struct dbell_entry *)clientData;
+	ASSERT(entry);
+	wake_up(&entry->destroyEvent);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * dbell_release_cb --
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
+static int dbell_release_cb(void *clientData)	// IN: doorbell entry
+{
+	struct dbell_entry *entry = (struct dbell_entry *)clientData;
+	ASSERT(entry);
+	vmci_resource_release(&entry->resource);
+	return 0;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * vmci_dbell_get_priv_flags --
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
+int vmci_dbell_get_priv_flags(struct vmci_handle handle,	// IN
+			      uint32_t * privFlags)	// OUT
+{
+	if (privFlags == NULL || handle.context == VMCI_INVALID_ID)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	if (handle.context == VMCI_HOST_CONTEXT_ID) {
+		struct dbell_entry *entry;
+		struct vmci_resource *resource;
+
+		resource =
+			vmci_resource_get(handle, VMCI_RESOURCE_TYPE_DOORBELL);
+		if (resource == NULL)
+			return VMCI_ERROR_NOT_FOUND;
+
+		entry =
+			container_of(resource, struct dbell_entry,
+				     resource);
+		*privFlags = entry->privFlags;
+		vmci_resource_release(resource);
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
+ * dbell_index_table_find --
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
+static struct dbell_entry *dbell_index_table_find(uint32_t idx)	// IN
+{
+	uint32_t bucket = VMCI_DOORBELL_HASH(idx);
+	struct dbell_entry *cur;
+
+	ASSERT(vmci_guest_code_active());
+
+	list_for_each_entry(cur, &vmciDoorbellIT.entries[bucket], idxListItem) {
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
+ * dbell_index_table_add --
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
+static void dbell_index_table_add(struct dbell_entry *entry)	// IN/OUT
+{
+	uint32_t bucket;
+	uint32_t newNotifyIdx;
+
+	ASSERT(entry);
+	ASSERT(vmci_guest_code_active());
+
+	vmci_resource_hold(&entry->resource);
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
+		    !dbell_index_table_find(lastNotifyIdxReleased)) {
+			newNotifyIdx = lastNotifyIdxReleased;
+			lastNotifyIdxReleased = PAGE_SIZE;
+		} else {
+			bool reused = false;
+			newNotifyIdx = lastNotifyIdxReserved;
+			if (notifyIdxCount + 1 < maxNotifyIdx) {
+				do {
+					if (!dbell_index_table_find
+					    (newNotifyIdx)) {
+						reused = true;
+						break;
+					}
+					newNotifyIdx =
+						(newNotifyIdx + 1) % maxNotifyIdx;
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
+ * dbell_index_table_remove --
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
+static void dbell_index_table_remove(struct dbell_entry *entry)	// IN/OUT
+{
+	ASSERT(entry);
+	ASSERT(vmci_guest_code_active());
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
+		       !dbell_index_table_find(maxNotifyIdx - 1)) {
+			maxNotifyIdx--;
+		}
+	}
+
+	lastNotifyIdxReleased = entry->idx;
+
+	spin_unlock_bh(&vmciDoorbellIT.lock);
+
+	vmci_resource_release(&entry->resource);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * dbell_link --
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
+static int dbell_link(struct vmci_handle handle,	// IN
+		      uint32_t notifyIdx)	// IN
+{
+	struct vmci_doorbell_link_msg linkMsg;
+
+	ASSERT(!VMCI_HANDLE_INVALID(handle));
+	ASSERT(vmci_guest_code_active());
+
+	linkMsg.hdr.dst =
+		vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID, VMCI_DOORBELL_LINK);
+	linkMsg.hdr.src = VMCI_ANON_SRC_HANDLE;
+	linkMsg.hdr.payloadSize = sizeof linkMsg - VMCI_DG_HEADERSIZE;
+	linkMsg.handle = handle;
+	linkMsg.notifyIdx = notifyIdx;
+
+	return vmci_send_dg((struct vmci_dg *)&linkMsg);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * dbell_unlink --
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
+static int dbell_unlink(struct vmci_handle handle)
+{
+	struct vmci_doorbell_unlink_msg unlinkMsg;
+
+	ASSERT(!VMCI_HANDLE_INVALID(handle));
+	ASSERT(vmci_guest_code_active());
+
+	unlinkMsg.hdr.dst =
+		vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID, VMCI_DOORBELL_UNLINK);
+	unlinkMsg.hdr.src = VMCI_ANON_SRC_HANDLE;
+	unlinkMsg.hdr.payloadSize = sizeof unlinkMsg - VMCI_DG_HEADERSIZE;
+	unlinkMsg.handle = handle;
+
+	return vmci_send_dg((struct vmci_dg *)&unlinkMsg);
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
+	struct dbell_entry *entry;
+	struct vmci_handle newHandle;
+	int result;
+
+	if (!handle || !notifyCB || flags & ~VMCI_FLAG_DELAYED_CB ||
+	    privFlags & ~VMCI_PRIVILEGE_ALL_FLAGS)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	entry = kmalloc(sizeof *entry, GFP_KERNEL);
+	if (entry == NULL) {
+		pr_warn("Failed allocating memory for datagram entry.");
+		return VMCI_ERROR_NO_MEM;
+	}
+
+	if (VMCI_HANDLE_INVALID(*handle)) {
+		uint32_t contextID = VMCI_GetContextID();
+		uint32_t resourceID = vmci_resource_get_id(contextID);
+		if (resourceID == VMCI_INVALID_ID) {
+			result = VMCI_ERROR_NO_HANDLE;
+			goto freeMem;
+		}
+		newHandle = vmci_make_handle(contextID, resourceID);
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
+		    (vmci_guest_code_active() &&
+		     VMCI_GetContextID() == handle->context))
+			validContext = true;
+
+		if (!validContext || VMCI_INVALID_ID == handle->resource) {
+			pr_devel("Invalid argument (handle=0x%x:0x%x).",
+				 handle->context, handle->resource);
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
+	entry->runDelayed = (flags & VMCI_FLAG_DELAYED_CB) ? true : false;
+	entry->notifyCB = notifyCB;
+	entry->clientData = clientData;
+	atomic_set(&entry->active, 0);
+	init_waitqueue_head(&entry->destroyEvent);
+
+	result =
+		vmci_resource_add(&entry->resource, VMCI_RESOURCE_TYPE_DOORBELL,
+				  newHandle, dbell_free_cb, entry);
+	if (result != VMCI_SUCCESS) {
+		pr_warn("Failed to add new resource (handle=0x%x:0x%x).",
+			newHandle.context, newHandle.resource);
+		if (result == VMCI_ERROR_DUPLICATE_ENTRY)
+			result = VMCI_ERROR_ALREADY_EXISTS;
+
+		goto freeMem;
+	}
+
+	if (vmci_guest_code_active()) {
+		dbell_index_table_add(entry);
+		result = dbell_link(newHandle, entry->idx);
+		if (VMCI_SUCCESS != result)
+			goto destroyResource;
+
+		atomic_set(&entry->active, 1);
+	}
+
+	if (VMCI_HANDLE_INVALID(*handle))
+		*handle = newHandle;
+
+	return result;
+
+destroyResource:
+	dbell_index_table_remove(entry);
+	vmci_resource_remove(newHandle, VMCI_RESOURCE_TYPE_DOORBELL);
+freeMem:
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
+	struct dbell_entry *entry;
+	struct vmci_resource *resource;
+
+	if (VMCI_HANDLE_INVALID(handle))
+		return VMCI_ERROR_INVALID_ARGS;
+
+	resource = vmci_resource_get(handle, VMCI_RESOURCE_TYPE_DOORBELL);
+	if (resource == NULL) {
+		pr_devel("Failed to destroy doorbell "
+			 "(handle=0x%x:0x%x).", handle.context,
+			 handle.resource);
+		return VMCI_ERROR_NOT_FOUND;
+	}
+
+	entry = container_of(resource, struct dbell_entry, resource);
+
+	if (vmci_guest_code_active()) {
+		int result;
+
+		dbell_index_table_remove(entry);
+
+		result = dbell_unlink(handle);
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
+			pr_devel("Unlink of doorbell (handle=0x%x:0x%x) "
+				 "unknown by hypervisor (error=%d).",
+				 handle.context, handle.resource,
+				 result);
+		}
+	}
+
+	/*
+	 * Now remove the resource from the table.  It might still be in use
+	 * after this, in a callback or still on the delayed work queue.
+	 */
+	vmci_resource_remove(handle, VMCI_RESOURCE_TYPE_DOORBELL);
+
+	/*
+	 * We now wait on the destroyEvent and release the reference we got
+	 * above.
+	 */
+	vmci_drv_wait_on_event_intr(&entry->destroyEvent,
+				    dbell_release_cb, entry);
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
+ * dbell_notify_as_guest --
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
+static int dbell_notify_as_guest(struct vmci_handle handle,	// IN
+				 uint32_t privFlags)	// IN
+{
+	struct vmci_doorbell_ntfy_msg notifyMsg;
+
+	ASSERT(vmci_guest_code_active());
+
+	notifyMsg.hdr.dst = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
+					     VMCI_DOORBELL_NOTIFY);
+	notifyMsg.hdr.src = VMCI_ANON_SRC_HANDLE;
+	notifyMsg.hdr.payloadSize = sizeof notifyMsg - VMCI_DG_HEADERSIZE;
+	notifyMsg.handle = handle;
+
+	return vmci_send_dg((struct vmci_dg *)&notifyMsg);
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
+	retval = vmci_route(&src, &dst, false, &route);
+	if (retval < VMCI_SUCCESS)
+		return retval;
+
+	if (VMCI_ROUTE_AS_HOST == route)
+		return vmci_ctx_notify_dbell(VMCI_HOST_CONTEXT_ID,
+					     dst, privFlags);
+
+	if (VMCI_ROUTE_AS_GUEST == route)
+		return dbell_notify_as_guest(dst, privFlags);
+
+	pr_warn("Unknown route (%d) for doorbell.", route);
+	return VMCI_ERROR_DST_UNREACHABLE;
+}
+
+EXPORT_SYMBOL(VMCIDoorbell_Notify);
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * dbell_delayed_dispatch_cb --
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
+static void dbell_delayed_dispatch_cb(void *data)	// IN
+{
+	struct dbell_entry *entry = (struct dbell_entry *)data;
+
+	ASSERT(data);
+
+	entry->notifyCB(entry->clientData);
+
+	vmci_resource_release(&entry->resource);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * vmci_dbell_host_context_notify --
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
+int vmci_dbell_host_context_notify(uint32_t srcCID,	// IN
+				   struct vmci_handle handle)	// IN
+{
+	struct dbell_entry *entry;
+	struct vmci_resource *resource;
+	int result;
+
+	ASSERT(vmci_host_code_active());
+
+	if (VMCI_HANDLE_INVALID(handle)) {
+		pr_devel("Notifying an invalid doorbell "
+			 "(handle=0x%x:0x%x).", handle.context,
+			 handle.resource);
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	resource = vmci_resource_get(handle, VMCI_RESOURCE_TYPE_DOORBELL);
+	if (resource == NULL) {
+		pr_devel("Notifying an unknown doorbell "
+			 "(handle=0x%x:0x%x).", handle.context,
+			 handle.resource);
+		return VMCI_ERROR_NOT_FOUND;
+	}
+	entry = container_of(resource, struct dbell_entry, resource);
+
+	if (entry->runDelayed) {
+		result =
+			vmci_drv_schedule_delayed_work(dbell_delayed_dispatch_cb,
+						       entry);
+		if (result < VMCI_SUCCESS) {
+			/*
+			 * If we failed to schedule the delayed work, we need to
+			 * release the resource immediately. Otherwise, the resource
+			 * will be released once the delayed callback has been
+			 * completed.
+			 */
+
+			pr_devel("Failed to schedule delayed doorbell "
+				 "notification (result=%d).", result);
+			vmci_resource_release(resource);
+		}
+	} else {
+		entry->notifyCB(entry->clientData);
+		vmci_resource_release(resource);
+		result = VMCI_SUCCESS;
+	}
+	return result;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * vmci_dbell_hibernate --
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
+void vmci_dbell_hibernate(bool enterHibernate)
+{
+	uint32_t bucket;
+	struct dbell_entry *cur;
+
+	if (!vmci_guest_code_active() || enterHibernate)
+		return;
+
+	spin_lock_bh(&vmciDoorbellIT.lock);
+
+	for (bucket = 0; bucket < ARRAY_SIZE(vmciDoorbellIT.entries); bucket++) {
+		list_for_each_entry(cur, &vmciDoorbellIT.entries[bucket],
+				    idxListItem) {
+			int result;
+			struct vmci_handle h;
+
+			h = vmci_resource_handle(&cur->resource);
+			result = dbell_link(h, cur->idx);
+			if (result != VMCI_SUCCESS
+			    && result != VMCI_ERROR_DUPLICATE_ENTRY) {
+				pr_warn("Failed to reregister doorbell "
+					"(handle=0x%x:0x%x) to index (error=%d).",
+					h.context, h.resource, result);
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
+ * vmci_dbell_register_notification_bitmap --
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
+bool vmci_dbell_register_notification_bitmap(uint32_t bitmapPPN)
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
+	bitmapSetMsg.hdr.dst = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
+						VMCI_SET_NOTIFY_BITMAP);
+	bitmapSetMsg.hdr.src = VMCI_ANON_SRC_HANDLE;
+	bitmapSetMsg.hdr.payloadSize = sizeof bitmapSetMsg - VMCI_DG_HEADERSIZE;
+	bitmapSetMsg.bitmapPPN = bitmapPPN;
+
+	result = vmci_send_dg((struct vmci_dg *)&bitmapSetMsg);
+	if (result != VMCI_SUCCESS) {
+		pr_devel("Failed to register (PPN=%u) as "
+			 "notification bitmap (error=%d).",
+			 bitmapPPN, result);
+		return false;
+	}
+	return true;
+}
+
+/*
+ *-------------------------------------------------------------------------
+ *
+ * dbell_fire_entries --
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
+static void dbell_fire_entries(uint32_t notifyIdx)	// IN
+{
+	uint32_t bucket = VMCI_DOORBELL_HASH(notifyIdx);
+	struct dbell_entry *cur;
+
+	ASSERT(vmci_guest_code_active());
+
+	spin_lock_bh(&vmciDoorbellIT.lock);
+
+	list_for_each_entry(cur, &vmciDoorbellIT.entries[bucket], idxListItem) {
+		if (cur->idx == notifyIdx && atomic_read(&cur->active) == 1) {
+			ASSERT(cur->notifyCB);
+			if (cur->runDelayed) {
+				int err;
+
+				vmci_resource_hold(&cur->resource);
+				err =
+					vmci_drv_schedule_delayed_work
+					(dbell_delayed_dispatch_cb, cur);
+				if (err != VMCI_SUCCESS) {
+					vmci_resource_release(&cur->resource);
+					goto out;
+				}
+			} else {
+				cur->notifyCB(cur->clientData);
+			}
+		}
+	}
+
+out:
+	spin_unlock_bh(&vmciDoorbellIT.lock);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * vmci_dbell_scan_notification_entries --
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
+void vmci_dbell_scan_notification_entries(uint8_t * bitmap)
+{
+	uint32_t idx;
+
+	ASSERT(bitmap);
+	ASSERT(vmci_guest_code_active());
+
+	for (idx = 0; idx < maxNotifyIdx; idx++) {
+		if (bitmap[idx] & 0x1) {
+			bitmap[idx] &= ~1;
+			dbell_fire_entries(idx);
+		}
+	}
+}
diff --git a/drivers/misc/vmw_vmci/vmci_doorbell.h b/drivers/misc/vmw_vmci/vmci_doorbell.h
new file mode 100644
index 0000000..ef37caa
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_doorbell.h
@@ -0,0 +1,57 @@
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
+#ifndef VMCI_DOORBELL_H
+#define VMCI_DOORBELL_H
+
+#include <linux/vmw_vmci_defs.h>
+
+#include "vmci_driver.h"
+
+/*
+ * VMCINotifyResourceInfo: Used to create and destroy doorbells, and
+ * generate a notification for a doorbell or queue pair.
+ */
+struct vmci_dbell_notify_resource_info {
+	struct vmci_handle handle;
+	uint16_t resource;
+	uint16_t action;
+	int32_t result;
+};
+
+/*
+ * Structure used for checkpointing the doorbell mappings. It is
+ * written to the checkpoint as is, so changing this structure will
+ * break checkpoint compatibility.
+ */
+struct dbell_cpt_state {
+	struct vmci_handle handle;
+	uint64_t bitmapIdx;
+};
+
+int vmci_dbell_init(void);
+void vmci_dbell_hibernate(bool enterHibernation);
+
+int vmci_dbell_host_context_notify(uint32_t srcCID, struct vmci_handle handle);
+int vmci_dbell_get_priv_flags(struct vmci_handle handle, uint32_t * privFlags);
+
+bool vmci_dbell_register_notification_bitmap(uint32_t bitmapPPN);
+void vmci_dbell_scan_notification_entries(uint8_t * bitmap);
+
+#endif				// VMCI_DOORBELL_H
-- 
1.7.0.4

