Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab2JPAiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:38:54 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:43223 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755322Ab2JPAhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:37:55 -0400
Subject: [PATCH 01/10] VMCI: context implementation.
To: linux-kernel@vger.kernel.org, georgezhang@vmware.com,
        virtualization@lists.linux-foundation.org
From: George Zhang <georgezhang@vmware.com>
Cc: pv-drivers@vmware.com, vm-crosstalk@vmware.com, gregkh@linuxfoundation.org
Date: Mon, 15 Oct 2012 17:28:01 -0700
Message-ID: <20121016002739.26205.77328.stgit@promb-2n-dhcp175.eng.vmware.com>
In-Reply-To: <20121016002550.26205.67037.stgit@promb-2n-dhcp175.eng.vmware.com>
References: <20121016002550.26205.67037.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMCI Context code maintains state for vmci and allows the driver to
communicate with multiple VMs.


Signed-off-by: George Zhang <georgezhang@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_context.c | 1291 ++++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_context.h |  177 +++++
 2 files changed, 1468 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmci_context.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_context.h

diff --git a/drivers/misc/vmw_vmci/vmci_context.c b/drivers/misc/vmw_vmci/vmci_context.c
new file mode 100644
index 0000000..c552dd3
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_context.c
@@ -0,0 +1,1291 @@
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
+ */
+
+#include <linux/vmw_vmci_defs.h>
+#include <linux/vmw_vmci_api.h>
+#include <linux/highmem.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+#include "vmci_common_int.h"
+#include "vmci_queue_pair.h"
+#include "vmci_datagram.h"
+#include "vmci_doorbell.h"
+#include "vmci_context.h"
+#include "vmci_driver.h"
+#include "vmci_event.h"
+
+/*
+ * List of current VMCI contexts.
+ */
+static struct {
+	struct list_head head;
+	spinlock_t lock; /* Spinlock for context list operations */
+} ctx_list;
+
+static void ctx_signal_notify(struct vmci_ctx *context)
+{
+	if (context->notify)
+		*context->notify = true;
+}
+
+static void ctx_clear_notify(struct vmci_ctx *context)
+{
+	if (context->notify)
+		*context->notify = false;
+}
+
+/*
+ * If nothing requires the attention of the guest, clears both
+ * notify flag and call.
+ */
+static void ctx_clear_notify_call(struct vmci_ctx *context)
+{
+	if (context->pending_datagrams == 0 &&
+	    vmci_handle_arr_get_size(context->pending_doorbell_array) == 0)
+		ctx_clear_notify(context);
+}
+
+/*
+ * Sets the context's notify flag iff datagrams are pending for this
+ * context.  Called from vmci_setup_notify().
+ */
+void vmci_ctx_check_signal_notify(struct vmci_ctx *context)
+{
+	ASSERT(context);
+
+	spin_lock(&context->lock);
+	if (context->pending_datagrams)
+		ctx_signal_notify(context);
+	spin_unlock(&context->lock);
+}
+
+int __init vmci_ctx_init(void)
+{
+	INIT_LIST_HEAD(&ctx_list.head);
+	spin_lock_init(&ctx_list.lock);
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ * Allocates and initializes a VMCI context.
+ */
+int vmci_ctx_init_ctx(u32 cid,
+		      u32 priv_flags,
+		      uintptr_t event_hnd,
+		      int user_version,
+		      const struct cred *cred,
+		      struct vmci_ctx **out_context)
+{
+	struct vmci_ctx *context;
+	int result;
+
+	if (priv_flags & ~VMCI_PRIVILEGE_ALL_FLAGS) {
+		pr_devel("Invalid flag (flags=0x%x) for VMCI context.",
+			 priv_flags);
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	if (user_version == 0)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	context = kzalloc(sizeof(*context), GFP_KERNEL);
+	if (context == NULL) {
+		pr_warn("Failed to allocate memory for VMCI context.");
+		return VMCI_ERROR_NO_MEM;
+	}
+
+	INIT_LIST_HEAD(&context->list_item);
+	INIT_LIST_HEAD(&context->datagram_queue);
+
+	context->user_version = user_version;
+
+	context->queue_pair_array = vmci_handle_arr_create(0);
+	if (!context->queue_pair_array) {
+		result = VMCI_ERROR_NO_MEM;
+		goto error;
+	}
+
+	context->doorbell_array = vmci_handle_arr_create(0);
+	if (!context->doorbell_array) {
+		result = VMCI_ERROR_NO_MEM;
+		goto error;
+	}
+
+	context->pending_doorbell_array = vmci_handle_arr_create(0);
+	if (!context->pending_doorbell_array) {
+		result = VMCI_ERROR_NO_MEM;
+		goto error;
+	}
+
+	INIT_LIST_HEAD(&context->notifier_list);
+
+	spin_lock_init(&context->lock);
+
+	kref_init(&context->kref);
+
+	/* Inititialize host-specific VMCI context. */
+	init_waitqueue_head(&context->host_context.wait_queue);
+
+	context->priv_flags = priv_flags;
+
+	if (cred)
+		context->cred = get_cred(cred);
+
+	context->notify = NULL;
+	context->notify_page = NULL;
+
+	/*
+	 * If we collide with an existing context we generate a new
+	 * and use it instead. The VMX will determine if regeneration
+	 * is okay. Since there isn't 4B - 16 VMs running on a given
+	 * host, the below loop will terminate.
+	 */
+	spin_lock(&ctx_list.lock);
+
+	ASSERT(cid != VMCI_INVALID_ID);
+	while (vmci_ctx_exists(cid)) {
+
+		/*
+		 * If the cid is below our limit and we collide we are
+		 * creating duplicate contexts internally so we want
+		 * to assert fail in that case.
+		 */
+		ASSERT(cid >= VMCI_RESERVED_CID_LIMIT);
+
+		/* We reserve the lowest 16 ids for fixed contexts. */
+		cid = max(cid, VMCI_RESERVED_CID_LIMIT - 1) + 1;
+		if (cid == VMCI_INVALID_ID)
+			cid = VMCI_RESERVED_CID_LIMIT;
+	}
+	ASSERT(!vmci_ctx_exists(cid));
+	context->cid = cid;
+
+	list_add_tail_rcu(&context->list_item, &ctx_list.head);
+	spin_unlock(&ctx_list.lock);
+
+	*out_context = context;
+	return VMCI_SUCCESS;
+
+ error:
+	if (context->queue_pair_array)
+		vmci_handle_arr_destroy(context->queue_pair_array);
+	if (context->doorbell_array)
+		vmci_handle_arr_destroy(context->doorbell_array);
+	if (context->pending_doorbell_array)
+		vmci_handle_arr_destroy(context->pending_doorbell_array);
+	kfree(context);
+	return result;
+}
+
+/*
+ * Dequeue VMCI context.
+ */
+void vmci_ctx_release_ctx(struct vmci_ctx *context)
+{
+	spin_lock(&ctx_list.lock);
+	list_del_rcu(&context->list_item);
+	spin_unlock(&ctx_list.lock);
+	synchronize_rcu();
+
+	vmci_ctx_release(context);
+}
+
+/*
+ * Fire notification for all contexts interested in given cid.
+ */
+static int ctx_fire_notification(u32 context_id, u32 priv_flags)
+{
+	u32 i, array_size;
+	struct vmci_ctx *sub_ctx;
+	struct vmci_handle_arr *subscriber_array;
+	struct vmci_handle context_handle =
+	    vmci_make_handle(context_id, VMCI_EVENT_HANDLER);
+
+	/*
+	 * We create an array to hold the subscribers we find when
+	 * scanning through all contexts.
+	 */
+	subscriber_array = vmci_handle_arr_create(0);
+	if (subscriber_array == NULL)
+		return VMCI_ERROR_NO_MEM;
+
+	/*
+	 * Scan all contexts to find who is interested in being
+	 * notified about given contextID.
+	 */
+	rcu_read_lock();
+	list_for_each_entry_rcu(sub_ctx, &ctx_list.head, list_item) {
+		struct vmci_handle_list *node;
+
+		/*
+		 * We only deliver notifications of the removal of
+		 * contexts, if the two contexts are allowed to
+		 * interact.
+		 */
+		if (vmci_deny_interaction(priv_flags, sub_ctx->priv_flags))
+			continue;
+
+		list_for_each_entry_rcu(node, &sub_ctx->notifier_list, node) {
+			if (!VMCI_HANDLE_EQUAL(node->handle, context_handle))
+				continue;
+
+			vmci_handle_arr_append_entry(&subscriber_array,
+					vmci_make_handle(sub_ctx->cid,
+							 VMCI_EVENT_HANDLER));
+		}
+	}
+	rcu_read_unlock();
+
+	/* Fire event to all subscribers. */
+	array_size = vmci_handle_arr_get_size(subscriber_array);
+	for (i = 0; i < array_size; i++) {
+		int result;
+		struct vmci_event_msg *e_msg;
+		struct vmci_event_payld_ctx *ev_payload;
+		char buf[sizeof(*e_msg) + sizeof(*ev_payload)];
+
+		e_msg = (struct vmci_event_msg *)buf;
+
+		/* Clear out any garbage. */
+		memset(e_msg, 0, sizeof(*e_msg) + sizeof(*ev_payload));
+		e_msg->hdr.dst = vmci_handle_arr_get_entry(subscriber_array, i);
+		e_msg->hdr.src =
+		    vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
+				     VMCI_CONTEXT_RESOURCE_ID);
+		e_msg->hdr.payload_size =
+		    sizeof(*e_msg) + sizeof(*ev_payload) - sizeof(e_msg->hdr);
+		e_msg->event_data.event = VMCI_EVENT_CTX_REMOVED;
+		ev_payload = vmci_event_data_payload(&e_msg->event_data);
+		ev_payload->context_id = context_id;
+
+		result = vmci_datagram_dispatch(VMCI_HYPERVISOR_CONTEXT_ID,
+						(struct vmci_datagram *)
+						e_msg, false);
+		if (result < VMCI_SUCCESS) {
+			pr_devel("Failed to enqueue event datagram "
+				 "(type=%d) for context (ID=0x%x).",
+				 e_msg->event_data.event,
+				 e_msg->hdr.dst.context);
+			/* We continue to enqueue on next subscriber. */
+		}
+	}
+	vmci_handle_arr_destroy(subscriber_array);
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ * Returns the current number of pending datagrams. The call may
+ * also serve as a synchronization point for the datagram queue,
+ * as no enqueue operations can occur concurrently.
+ */
+int vmci_ctx_pending_datagrams(u32 cid, u32 *pending)
+{
+	struct vmci_ctx *context;
+
+	context = vmci_ctx_get(cid);
+	if (context == NULL)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	spin_lock(&context->lock);
+	if (pending)
+		*pending = context->pending_datagrams;
+	spin_unlock(&context->lock);
+	vmci_ctx_release(context);
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ * Queues a VMCI datagram for the appropriate target VM context.
+ */
+int vmci_ctx_enqueue_datagram(u32 cid, struct vmci_datagram *dg)
+{
+	struct vmci_datagram_queue_entry *dq_entry;
+	struct vmci_ctx *context;
+	struct vmci_handle dg_src;
+	size_t vmci_dg_size;
+
+	ASSERT(dg);
+	vmci_dg_size = VMCI_DG_SIZE(dg);
+	ASSERT(vmci_dg_size <= VMCI_MAX_DG_SIZE);
+
+	/* Get the target VM's VMCI context. */
+	context = vmci_ctx_get(cid);
+	if (context == NULL) {
+		pr_devel("Invalid context (ID=0x%x).", cid);
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	/* Allocate guest call entry and add it to the target VM's queue. */
+	dq_entry = kmalloc(sizeof(*dq_entry), GFP_KERNEL);
+	if (dq_entry == NULL) {
+		pr_warn("Failed to allocate memory for datagram.");
+		vmci_ctx_release(context);
+		return VMCI_ERROR_NO_MEM;
+	}
+	dq_entry->dg = dg;
+	dq_entry->dg_size = vmci_dg_size;
+	dg_src = dg->src;
+	INIT_LIST_HEAD(&dq_entry->list_item);
+
+	spin_lock(&context->lock);
+
+	/*
+	 * We put a higher limit on datagrams from the hypervisor.  If
+	 * the pending datagram is not from hypervisor, then we check
+	 * if enqueueing it would exceed the
+	 * VMCI_MAX_DATAGRAM_QUEUE_SIZE limit on the destination.  If
+	 * the pending datagram is from hypervisor, we allow it to be
+	 * queued at the destination side provided we don't reach the
+	 * VMCI_MAX_DATAGRAM_AND_EVENT_QUEUE_SIZE limit.
+	 */
+	if (context->datagram_queue_size + vmci_dg_size >=
+	    VMCI_MAX_DATAGRAM_QUEUE_SIZE &&
+	    (!VMCI_HANDLE_EQUAL(dg_src,
+				vmci_make_handle
+				(VMCI_HYPERVISOR_CONTEXT_ID,
+				 VMCI_CONTEXT_RESOURCE_ID)) ||
+	     context->datagram_queue_size + vmci_dg_size >=
+	     VMCI_MAX_DATAGRAM_AND_EVENT_QUEUE_SIZE)) {
+		spin_unlock(&context->lock);
+		vmci_ctx_release(context);
+		kfree(dq_entry);
+		pr_devel("Context (ID=0x%x) receive queue is full.", cid);
+		return VMCI_ERROR_NO_RESOURCES;
+	}
+
+	list_add(&dq_entry->list_item, &context->datagram_queue);
+	context->pending_datagrams++;
+	context->datagram_queue_size += vmci_dg_size;
+	ctx_signal_notify(context);
+	wake_up(&context->host_context.wait_queue);
+	spin_unlock(&context->lock);
+	vmci_ctx_release(context);
+
+	return vmci_dg_size;
+}
+
+/*
+ * Verifies whether a context with the specified context ID exists.
+ * FIXME: utility is dubious as no decisions can be reliably made
+ * using this data as context can appear and disappear at any time.
+ */
+bool vmci_ctx_exists(u32 cid)
+{
+	struct vmci_ctx *context;
+	bool exists = false;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(context, &ctx_list.head, list_item) {
+		if (context->cid == cid) {
+			exists = true;
+			break;
+		}
+	}
+
+	rcu_read_unlock();
+	return exists;
+}
+
+/*
+ * Retrieves VMCI context corresponding to the given cid.
+ */
+struct vmci_ctx *vmci_ctx_get(u32 cid)
+{
+	struct vmci_ctx *context = NULL;
+
+	if (cid == VMCI_INVALID_ID)
+		return NULL;
+
+	spin_lock(&ctx_list.lock);
+	list_for_each_entry(context, &ctx_list.head, list_item) {
+		if (context->cid == cid) {
+			/*
+			 * At this point, we are sure that the
+			 * reference count is larger already than
+			 * zero. When starting the destruction of a
+			 * context, we always remove it from the
+			 * context list before decreasing the
+			 * reference count. As we found the context
+			 * here, it hasn't been destroyed yet. This
+			 * means that we are not about to increase the
+			 * reference count of something that is in the
+			 * process of being destroyed.
+			 */
+
+			kref_get(&context->kref);
+			break;
+		}
+	}
+	spin_unlock(&ctx_list.lock);
+
+	return (context && context->cid == cid) ? context : NULL;
+}
+
+/*
+ * Deallocates all parts of a context datastructure. This
+ * functions doesn't lock the context, because it assumes that
+ * the caller is holding the last reference to context.
+ */
+static void ctx_free_ctx(struct kref *kref)
+{
+	struct vmci_ctx *context = container_of(kref, struct vmci_ctx, kref);
+	struct vmci_datagram_queue_entry *dq_entry, *dq_entry_tmp;
+	struct vmci_handle temp_handle;
+	struct vmci_handle_list *notifier, *tmp;
+
+	/*
+	 * Fire event to all contexts interested in knowing this
+	 * context is dying.
+	 */
+	ctx_fire_notification(context->cid, context->priv_flags);
+
+	/*
+	 * Cleanup all queue pair resources attached to context.  If
+	 * the VM dies without cleaning up, this code will make sure
+	 * that no resources are leaked.
+	 */
+	temp_handle = vmci_handle_arr_get_entry(context->queue_pair_array, 0);
+	while (!VMCI_HANDLE_EQUAL(temp_handle, VMCI_INVALID_HANDLE)) {
+		if (vmci_qp_broker_detach(temp_handle,
+					  context) < VMCI_SUCCESS) {
+			/*
+			 * When vmci_qp_broker_detach() succeeds it
+			 * removes the handle from the array.  If
+			 * detach fails, we must remove the handle
+			 * ourselves.
+			 */
+			vmci_handle_arr_remove_entry(context->queue_pair_array,
+						     temp_handle);
+		}
+		temp_handle =
+		    vmci_handle_arr_get_entry(context->queue_pair_array, 0);
+	}
+
+	/*
+	 * It is fine to destroy this without locking the callQueue, as
+	 * this is the only thread having a reference to the context.
+	 */
+	list_for_each_entry_safe(dq_entry, dq_entry_tmp,
+				 &context->datagram_queue, list_item) {
+		ASSERT(dq_entry->dg);
+		ASSERT(dq_entry->dg_size == VMCI_DG_SIZE(dq_entry->dg));
+		list_del(&dq_entry->list_item);
+		kfree(dq_entry->dg);
+		kfree(dq_entry);
+	}
+
+	list_for_each_entry_safe(notifier, tmp,
+				 &context->notifier_list, node) {
+		list_del(&notifier->node);
+		kfree(notifier);
+	}
+
+	vmci_handle_arr_destroy(context->queue_pair_array);
+	vmci_handle_arr_destroy(context->doorbell_array);
+	vmci_handle_arr_destroy(context->pending_doorbell_array);
+	vmci_ctx_unset_notify(context);
+	if (context->cred)
+		put_cred(context->cred);
+	kfree(context);
+}
+
+/*
+ * Releases the VMCI context. If this is the last reference to
+ * the context it will be deallocated. A context is created with
+ * a reference count of one, and on destroy, it is removed from
+ * the context list before its reference count is
+ * decremented. Thus, if we reach zero, we are sure that nobody
+ * else are about to increment it (they need the entry in the
+ * context list for that). This function musn't be called with a
+ * lock held.
+ */
+void vmci_ctx_release(struct vmci_ctx *context)
+{
+	ASSERT(context);
+	kref_put(&context->kref, ctx_free_ctx);
+}
+
+/*
+ * Dequeues the next datagram and returns it to caller.
+ * The caller passes in a pointer to the max size datagram
+ * it can handle and the datagram is only unqueued if the
+ * size is less than max_size. If larger max_size is set to
+ * the size of the datagram to give the caller a chance to
+ * set up a larger buffer for the guestcall.
+ */
+int vmci_ctx_dequeue_datagram(struct vmci_ctx *context,
+			      size_t *max_size,
+			      struct vmci_datagram **dg)
+{
+	struct vmci_datagram_queue_entry *dq_entry;
+	struct list_head *list_item;
+	int rv;
+
+	ASSERT(context && dg);
+
+	/* Dequeue the next datagram entry. */
+	spin_lock(&context->lock);
+	if (context->pending_datagrams == 0) {
+		ctx_clear_notify_call(context);
+		spin_unlock(&context->lock);
+		pr_devel("No datagrams pending.");
+		return VMCI_ERROR_NO_MORE_DATAGRAMS;
+	}
+
+	list_item = context->datagram_queue.next;
+	ASSERT(!list_empty(&context->datagram_queue));
+
+	dq_entry =
+	    list_entry(list_item, struct vmci_datagram_queue_entry, list_item);
+	ASSERT(dq_entry->dg);
+
+	/* Check size of caller's buffer. */
+	if (*max_size < dq_entry->dg_size) {
+		*max_size = dq_entry->dg_size;
+		spin_unlock(&context->lock);
+		pr_devel("Caller's buffer should be at least "
+			 "(size=%u bytes).", (u32) *max_size);
+		return VMCI_ERROR_NO_MEM;
+	}
+
+	list_del(list_item);
+	context->pending_datagrams--;
+	context->datagram_queue_size -= dq_entry->dg_size;
+	if (context->pending_datagrams == 0) {
+		ctx_clear_notify_call(context);
+		rv = VMCI_SUCCESS;
+	} else {
+		/*
+		 * Return the size of the next datagram.
+		 */
+		struct vmci_datagram_queue_entry *next_entry;
+
+		list_item = context->datagram_queue.next;
+		ASSERT(!list_empty(&context->datagram_queue));
+		next_entry =
+		    list_entry(list_item, struct vmci_datagram_queue_entry,
+			       list_item);
+		ASSERT(next_entry && next_entry->dg);
+
+		/*
+		 * The following size_t -> int truncation is fine as
+		 * the maximum size of a (routable) datagram is 68KB.
+		 */
+		rv = (int)next_entry->dg_size;
+	}
+	spin_unlock(&context->lock);
+
+	/* Caller must free datagram. */
+	ASSERT(dq_entry->dg_size == VMCI_DG_SIZE(dq_entry->dg));
+	*dg = dq_entry->dg;
+	dq_entry->dg = NULL;
+	kfree(dq_entry);
+
+	return rv;
+}
+
+/*
+ * Reverts actions set up by vmci_setup_notify().  Unmaps and unlocks the
+ * page mapped/locked by vmci_setup_notify().
+ */
+void vmci_ctx_unset_notify(struct vmci_ctx *context)
+{
+	struct page *notify_page = context->notify_page;
+
+	if (!notify_page)
+		return;
+
+	context->notify = NULL;
+	context->notify_page = NULL;
+	kunmap(notify_page);
+	put_page(notify_page);
+
+}
+
+u32 vmci_ctx_get_id(struct vmci_ctx *context)
+{
+	if (!context)
+		return VMCI_INVALID_ID;
+
+	ASSERT(context->cid != VMCI_INVALID_ID);
+	return context->cid;
+}
+
+/*
+ * Add remote_cid to list of contexts current contexts wants
+ * notifications from/about.
+ */
+int vmci_ctx_add_notification(u32 context_id, u32 remote_cid)
+{
+	struct vmci_ctx *context;
+	struct vmci_handle_list *notifier, *n;
+	int result;
+	bool exists = false;
+
+	context = vmci_ctx_get(context_id);
+	if (!context)
+		return VMCI_ERROR_NOT_FOUND;
+
+	if (VMCI_CONTEXT_IS_VM(context_id) && VMCI_CONTEXT_IS_VM(remote_cid)) {
+		pr_devel("Context removed notifications for other VMs not "
+			 "supported (src=0x%x, remote=0x%x).",
+			 context_id, remote_cid);
+		result = VMCI_ERROR_DST_UNREACHABLE;
+		goto out;
+	}
+
+	if (context->priv_flags & VMCI_PRIVILEGE_FLAG_RESTRICTED) {
+		result = VMCI_ERROR_NO_ACCESS;
+		goto out;
+	}
+
+	notifier = kmalloc(sizeof(struct vmci_handle_list), GFP_KERNEL);
+	if (!notifier) {
+		result = VMCI_ERROR_NO_MEM;
+		goto out;
+	}
+
+	INIT_LIST_HEAD(&notifier->node);
+	notifier->handle = vmci_make_handle(remote_cid, VMCI_EVENT_HANDLER);
+
+	spin_lock(&context->lock);
+
+	list_for_each_entry(n, &context->notifier_list, node) {
+		if (VMCI_HANDLE_EQUAL(n->handle, notifier->handle)) {
+			exists = true;
+			break;
+		}
+	}
+
+	if (exists) {
+		kfree(notifier);
+		result = VMCI_ERROR_ALREADY_EXISTS;
+	} else {
+		list_add_tail_rcu(&notifier->node, &context->notifier_list);
+		context->n_notifiers++;
+		result = VMCI_SUCCESS;
+	}
+
+	spin_unlock(&context->lock);
+
+ out:
+	vmci_ctx_release(context);
+	return result;
+}
+
+/*
+ * Remove remote_cid from current context's list of contexts it is
+ * interested in getting notifications from/about.
+ */
+int vmci_ctx_remove_notification(u32 context_id, u32 remote_cid)
+{
+	struct vmci_ctx *context;
+	struct vmci_handle_list *notifier, *tmp;
+	struct vmci_handle handle;
+	bool found = false;
+
+	context = vmci_ctx_get(context_id);
+	if (!context)
+		return VMCI_ERROR_NOT_FOUND;
+
+	handle = vmci_make_handle(remote_cid, VMCI_EVENT_HANDLER);
+
+	spin_lock(&context->lock);
+	list_for_each_entry_safe(notifier, tmp,
+				 &context->notifier_list, node) {
+		if (VMCI_HANDLE_EQUAL(notifier->handle, handle)) {
+			list_del_rcu(&notifier->node);
+			context->n_notifiers--;
+			found = true;
+			break;
+		}
+	}
+	spin_unlock(&context->lock);
+
+	if (found) {
+		synchronize_rcu();
+		kfree(notifier);
+	}
+
+	vmci_ctx_release(context);
+
+	return found ? VMCI_SUCCESS : VMCI_ERROR_NOT_FOUND;
+}
+
+static int vmci_ctx_get_chkpt_notifiers(struct vmci_ctx *context,
+					u32 *buf_size, void **pbuf)
+{
+	u32 *notifiers;
+	size_t data_size;
+	struct vmci_handle_list *entry;
+	int i = 0;
+
+	if (context->n_notifiers == 0) {
+		*buf_size = 0;
+		*pbuf = NULL;
+		return VMCI_SUCCESS;
+	}
+
+	data_size = context->n_notifiers * sizeof(*notifiers);
+	if (*buf_size < data_size) {
+		*buf_size = data_size;
+		return VMCI_ERROR_MORE_DATA;
+	}
+
+	notifiers = kmalloc(data_size, GFP_ATOMIC); /* FIXME: want GFP_KERNEL */
+	if (!notifiers)
+		return VMCI_ERROR_NO_MEM;
+
+	list_for_each_entry(entry, &context->notifier_list, node)
+		notifiers[i++] = entry->handle.context;
+
+	*buf_size = data_size;
+	*pbuf = notifiers;
+	return VMCI_SUCCESS;
+}
+
+static int vmci_ctx_get_chkpt_doorbells(struct vmci_ctx *context,
+					u32 *buf_size, void **pbuf)
+{
+	struct dbell_cpt_state *dbells;
+	size_t n_doorbells;
+	int i;
+
+	ASSERT(context->doorbell_array);
+
+	n_doorbells = vmci_handle_arr_get_size(context->doorbell_array);
+	if (n_doorbells > 0) {
+		size_t data_size = n_doorbells * sizeof(*dbells);
+		if (*buf_size < data_size) {
+			*buf_size = data_size;
+			return VMCI_ERROR_MORE_DATA;
+		}
+
+		dbells = kmalloc(data_size, GFP_ATOMIC);
+		if (!dbells)
+			return VMCI_ERROR_NO_MEM;
+
+		for (i = 0; i < n_doorbells; i++)
+			dbells[i].handle = vmci_handle_arr_get_entry(
+						context->doorbell_array, i);
+
+		*buf_size = data_size;
+		*pbuf = dbells;
+	} else {
+		*buf_size = 0;
+		*pbuf = NULL;
+	}
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ * Get current context's checkpoint state of given type.
+ */
+int vmci_ctx_get_chkpt_state(u32 context_id,
+			     u32 cpt_type,
+			     u32 *buf_size,
+			     void **pbuf)
+{
+	struct vmci_ctx *context;
+	int result;
+
+	ASSERT(buf_size && pbuf);
+
+	context = vmci_ctx_get(context_id);
+	if (!context)
+		return VMCI_ERROR_NOT_FOUND;
+
+	spin_lock(&context->lock);
+
+	switch (cpt_type) {
+	case VMCI_NOTIFICATION_CPT_STATE:
+		result = vmci_ctx_get_chkpt_notifiers(context, buf_size, pbuf);
+		break;
+
+	case VMCI_WELLKNOWN_CPT_STATE:
+		/*
+		 * For compatibility with VMX'en with VM to VM communication, we
+		 * always return zero wellknown handles.
+		 */
+
+		*buf_size = 0;
+		*pbuf = NULL;
+		result = VMCI_SUCCESS;
+		break;
+
+	case VMCI_DOORBELL_CPT_STATE:
+		result = vmci_ctx_get_chkpt_doorbells(context, buf_size, pbuf);
+		break;
+
+	default:
+		pr_devel("Invalid cpt state (type=%d).", cpt_type);
+		result = VMCI_ERROR_INVALID_ARGS;
+		break;
+	}
+
+	spin_unlock(&context->lock);
+	vmci_ctx_release(context);
+
+	return result;
+}
+
+/*
+ * Set current context's checkpoint state of given type.
+ */
+int vmci_ctx_set_chkpt_state(u32 context_id,
+			     u32 cpt_type,
+			     u32 buf_size,
+			     void *cpt_buf)
+{
+	u32 i;
+	u32 current_id;
+	int result = VMCI_SUCCESS;
+	u32 num_ids = buf_size / sizeof(u32);
+	ASSERT(cpt_buf);
+
+	if (cpt_type == VMCI_WELLKNOWN_CPT_STATE && num_ids > 0) {
+		/*
+		 * We would end up here if VMX with VM to VM communication
+		 * attempts to restore a checkpoint with wellknown handles.
+		 */
+		pr_warn("Attempt to restore checkpoint with obsolete "
+			"wellknown handles.");
+		return VMCI_ERROR_OBSOLETE;
+	}
+
+	if (cpt_type != VMCI_NOTIFICATION_CPT_STATE) {
+		pr_devel("Invalid cpt state (type=%d).", cpt_type);
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	for (i = 0; i < num_ids && result == VMCI_SUCCESS; i++) {
+		current_id = ((u32 *) cpt_buf)[i];
+		result = vmci_ctx_add_notification(context_id, current_id);
+		if (result != VMCI_SUCCESS)
+			break;
+	}
+	if (result != VMCI_SUCCESS)
+		pr_devel("Failed to set cpt state (type=%d) "
+			 "(error=%d).", cpt_type, result);
+
+	return result;
+}
+
+/*
+ * Retrieves the specified context's pending notifications in the
+ * form of a handle array. The handle arrays returned are the
+ * actual data - not a copy and should not be modified by the
+ * caller. They must be released using
+ * vmci_ctx_rcv_notifications_release.
+ */
+int vmci_ctx_rcv_notifications_get(u32 context_id,
+				   struct vmci_handle_arr **db_handle_array,
+				   struct vmci_handle_arr **qp_handle_array)
+{
+	struct vmci_ctx *context;
+	int result = VMCI_SUCCESS;
+
+	ASSERT(db_handle_array && qp_handle_array);
+
+	context = vmci_ctx_get(context_id);
+	if (context == NULL)
+		return VMCI_ERROR_NOT_FOUND;
+
+	spin_lock(&context->lock);
+
+	*db_handle_array = context->pending_doorbell_array;
+	context->pending_doorbell_array = vmci_handle_arr_create(0);
+	if (!context->pending_doorbell_array) {
+		context->pending_doorbell_array = *db_handle_array;
+		*db_handle_array = NULL;
+		result = VMCI_ERROR_NO_MEM;
+	}
+	*qp_handle_array = NULL;
+
+	spin_unlock(&context->lock);
+	vmci_ctx_release(context);
+
+	return result;
+}
+
+/*
+ * Releases handle arrays with pending notifications previously
+ * retrieved using vmci_ctx_rcv_notifications_get. If the
+ * notifications were not successfully handed over to the guest,
+ * success must be false.
+ */
+void vmci_ctx_rcv_notifications_release(u32 context_id,
+					struct vmci_handle_arr *db_handle_array,
+					struct vmci_handle_arr *qp_handle_array,
+					bool success)
+{
+	struct vmci_ctx *context = vmci_ctx_get(context_id);
+
+	if (!context) {
+		/*
+		 * The OS driver part is holding on to the context for the
+		 * duration of the receive notification ioctl, so it should
+		 * still be here.
+		 */
+		ASSERT(false);
+	}
+
+	spin_lock(&context->lock);
+	if (!success) {
+		struct vmci_handle handle;
+
+		/*
+		 * New notifications may have been added while we were not
+		 * holding the context lock, so we transfer any new pending
+		 * doorbell notifications to the old array, and reinstate the
+		 * old array.
+		 */
+
+		handle =
+		    vmci_handle_arr_remove_tail(context->
+						pending_doorbell_array);
+		while (!VMCI_HANDLE_INVALID(handle)) {
+			ASSERT(vmci_handle_arr_has_entry
+			       (context->doorbell_array, handle));
+			if (!vmci_handle_arr_has_entry(db_handle_array,
+						       handle)) {
+				vmci_handle_arr_append_entry
+				    (&db_handle_array, handle);
+			}
+			handle =
+			    vmci_handle_arr_remove_tail(context->
+							pending_doorbell_array);
+		}
+		vmci_handle_arr_destroy(context->pending_doorbell_array);
+		context->pending_doorbell_array = db_handle_array;
+		db_handle_array = NULL;
+	} else {
+		ctx_clear_notify_call(context);
+	}
+	spin_unlock(&context->lock);
+	vmci_ctx_release(context);
+
+	if (db_handle_array)
+		vmci_handle_arr_destroy(db_handle_array);
+
+	if (qp_handle_array)
+		vmci_handle_arr_destroy(qp_handle_array);
+}
+
+/*
+ * Registers that a new doorbell handle has been allocated by the
+ * context. Only doorbell handles registered can be notified.
+ */
+int vmci_ctx_dbell_create(u32 context_id, struct vmci_handle handle)
+{
+	struct vmci_ctx *context;
+	int result;
+
+	if (context_id == VMCI_INVALID_ID || VMCI_HANDLE_INVALID(handle))
+		return VMCI_ERROR_INVALID_ARGS;
+
+	context = vmci_ctx_get(context_id);
+	if (context == NULL)
+		return VMCI_ERROR_NOT_FOUND;
+
+	spin_lock(&context->lock);
+	if (!vmci_handle_arr_has_entry(context->doorbell_array, handle)) {
+		vmci_handle_arr_append_entry(&context->doorbell_array, handle);
+		result = VMCI_SUCCESS;
+	} else {
+		result = VMCI_ERROR_DUPLICATE_ENTRY;
+	}
+
+	spin_unlock(&context->lock);
+	vmci_ctx_release(context);
+
+	return result;
+}
+
+/*
+ * Unregisters a doorbell handle that was previously registered
+ * with vmci_ctx_dbell_create.
+ */
+int vmci_ctx_dbell_destroy(u32 context_id, struct vmci_handle handle)
+{
+	struct vmci_ctx *context;
+	struct vmci_handle removed_handle;
+
+	if (context_id == VMCI_INVALID_ID || VMCI_HANDLE_INVALID(handle))
+		return VMCI_ERROR_INVALID_ARGS;
+
+	context = vmci_ctx_get(context_id);
+	if (context == NULL)
+		return VMCI_ERROR_NOT_FOUND;
+
+	spin_lock(&context->lock);
+	removed_handle =
+	    vmci_handle_arr_remove_entry(context->doorbell_array, handle);
+	vmci_handle_arr_remove_entry(context->pending_doorbell_array, handle);
+	spin_unlock(&context->lock);
+
+	vmci_ctx_release(context);
+
+	return VMCI_HANDLE_INVALID(removed_handle) ?
+	    VMCI_ERROR_NOT_FOUND : VMCI_SUCCESS;
+}
+
+/*
+ * Unregisters all doorbell handles that were previously
+ * registered with vmci_ctx_dbell_create.
+ */
+int vmci_ctx_dbell_destroy_all(u32 context_id)
+{
+	struct vmci_ctx *context;
+	struct vmci_handle handle;
+
+	if (context_id == VMCI_INVALID_ID)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	context = vmci_ctx_get(context_id);
+	if (context == NULL)
+		return VMCI_ERROR_NOT_FOUND;
+
+	spin_lock(&context->lock);
+	do {
+		struct vmci_handle_arr *arr = context->doorbell_array;
+		handle = vmci_handle_arr_remove_tail(arr);
+	} while (!VMCI_HANDLE_INVALID(handle));
+	do {
+		struct vmci_handle_arr *arr = context->pending_doorbell_array;
+		handle = vmci_handle_arr_remove_tail(arr);
+	} while (!VMCI_HANDLE_INVALID(handle));
+	spin_unlock(&context->lock);
+
+	vmci_ctx_release(context);
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ * Registers a notification of a doorbell handle initiated by the
+ * specified source context. The notification of doorbells are
+ * subject to the same isolation rules as datagram delivery. To
+ * allow host side senders of notifications a finer granularity
+ * of sender rights than those assigned to the sending context
+ * itself, the host context is required to specify a different
+ * set of privilege flags that will override the privileges of
+ * the source context.
+ */
+int vmci_ctx_notify_dbell(u32 src_cid,
+			  struct vmci_handle handle,
+			  u32 src_priv_flags)
+{
+	struct vmci_ctx *dst_context;
+	int result;
+
+	if (VMCI_HANDLE_INVALID(handle))
+		return VMCI_ERROR_INVALID_ARGS;
+
+	/* Get the target VM's VMCI context. */
+	dst_context = vmci_ctx_get(handle.context);
+	if (dst_context == NULL) {
+		pr_devel("Invalid context (ID=0x%x).", handle.context);
+		return VMCI_ERROR_NOT_FOUND;
+	}
+
+	if (src_cid != handle.context) {
+		u32 dst_priv_flags;
+
+		if (VMCI_CONTEXT_IS_VM(src_cid) &&
+		    VMCI_CONTEXT_IS_VM(handle.context)) {
+			pr_devel("Doorbell notification from VM to VM not "
+				 "supported (src=0x%x, dst=0x%x).", src_cid,
+				 handle.context);
+			result = VMCI_ERROR_DST_UNREACHABLE;
+			goto out;
+		}
+
+		result = vmci_dbell_get_priv_flags(handle, &dst_priv_flags);
+		if (result < VMCI_SUCCESS) {
+			pr_warn("Failed to get privilege flags for "
+				"destination (handle=0x%x:0x%x).",
+				handle.context, handle.resource);
+			goto out;
+		}
+
+		if (src_cid != VMCI_HOST_CONTEXT_ID ||
+		    src_priv_flags == VMCI_NO_PRIVILEGE_FLAGS) {
+			src_priv_flags = vmci_context_get_priv_flags(src_cid);
+		}
+
+		if (vmci_deny_interaction(src_priv_flags, dst_priv_flags)) {
+			result = VMCI_ERROR_NO_ACCESS;
+			goto out;
+		}
+	}
+
+	if (handle.context == VMCI_HOST_CONTEXT_ID) {
+		result = vmci_dbell_host_context_notify(src_cid, handle);
+	} else {
+		spin_lock(&dst_context->lock);
+
+		if (!vmci_handle_arr_has_entry
+		    (dst_context->doorbell_array, handle)) {
+			result = VMCI_ERROR_NOT_FOUND;
+		} else {
+			if (!vmci_handle_arr_has_entry
+			    (dst_context->pending_doorbell_array, handle)) {
+				vmci_handle_arr_append_entry
+				    (&dst_context->pending_doorbell_array,
+				     handle);
+
+				ctx_signal_notify(dst_context);
+				wake_up(&dst_context->host_context.wait_queue);
+
+			}
+			result = VMCI_SUCCESS;
+		}
+		spin_unlock(&dst_context->lock);
+	}
+
+ out:
+	vmci_ctx_release(dst_context);
+
+	return result;
+}
+
+bool vmci_ctx_supports_host_qp(struct vmci_ctx *context)
+{
+	return context && context->user_version >= VMCI_VERSION_HOSTQP;
+}
+
+/*
+ * Registers that a new queue pair handle has been allocated by
+ * the context.
+ */
+int vmci_ctx_qp_create(struct vmci_ctx *context, struct vmci_handle handle)
+{
+	int result;
+
+	if (context == NULL || VMCI_HANDLE_INVALID(handle))
+		return VMCI_ERROR_INVALID_ARGS;
+
+	if (!vmci_handle_arr_has_entry(context->queue_pair_array, handle)) {
+		vmci_handle_arr_append_entry(&context->queue_pair_array,
+					     handle);
+		result = VMCI_SUCCESS;
+	} else {
+		result = VMCI_ERROR_DUPLICATE_ENTRY;
+	}
+
+	return result;
+}
+
+/*
+ * Unregisters a queue pair handle that was previously registered
+ * with vmci_ctx_qp_create.
+ */
+int vmci_ctx_qp_destroy(struct vmci_ctx *context, struct vmci_handle handle)
+{
+	struct vmci_handle hndl;
+
+	if (context == NULL || VMCI_HANDLE_INVALID(handle))
+		return VMCI_ERROR_INVALID_ARGS;
+
+	hndl = vmci_handle_arr_remove_entry(context->queue_pair_array, handle);
+
+	return VMCI_HANDLE_INVALID(hndl) ? VMCI_ERROR_NOT_FOUND : VMCI_SUCCESS;
+}
+
+/*
+ * Determines whether a given queue pair handle is registered
+ * with the given context.
+ */
+bool vmci_ctx_qp_exists(struct vmci_ctx *context, struct vmci_handle handle)
+{
+	if (context == NULL || VMCI_HANDLE_INVALID(handle))
+		return false;
+
+	return vmci_handle_arr_has_entry(context->queue_pair_array, handle);
+}
+
+/*
+ * vmci_context_get_priv_flags() - Retrieve privilege flags.
+ * @context_id: The context ID of the VMCI context.
+ *
+ * Retrieves privilege flags of the given VMCI context ID.
+ */
+u32 vmci_context_get_priv_flags(u32 context_id)
+{
+	if (vmci_host_code_active()) {
+		u32 flags;
+		struct vmci_ctx *context;
+
+		context = vmci_ctx_get(context_id);
+		if (!context)
+			return VMCI_LEAST_PRIVILEGE_FLAGS;
+
+		flags = context->priv_flags;
+		vmci_ctx_release(context);
+		return flags;
+	}
+	return VMCI_NO_PRIVILEGE_FLAGS;
+}
+EXPORT_SYMBOL(vmci_context_get_priv_flags);
+
+/*
+ * vmci_context_id_to_host_vmid() - Map CID to HostID
+ * @context_id: Context ID of VMCI context.
+ * @host_vmid:  Host VM ID data
+ * @host_vmid_len:      Length of Host VM ID Data.
+ *
+ * Maps a context ID to the host specific (process/world) ID
+ * of the VM/VMX.  This function is not used on Linux systems
+ * and should be ignored.
+ */
+int vmci_context_id_to_host_vmid(u32 context_id,
+				 void *host_vmid, size_t host_vmid_len)
+{
+	return VMCI_ERROR_UNAVAILABLE;
+}
+EXPORT_SYMBOL(vmci_context_id_to_host_vmid);
+
+/*
+ * vmci_is_context_owner() - Determimnes if user is the context owner
+ * @context_id: The context ID of the VMCI context.
+ * @uid:        The host user id (real kernel value).
+ *
+ * Determines whether a given UID is the owner of given VMCI context.
+ */
+bool vmci_is_context_owner(u32 context_id, kuid_t uid)
+{
+	bool is_owner = false;
+
+	if (vmci_host_code_active()) {
+		struct vmci_ctx *context = vmci_ctx_get(context_id);
+		if (context) {
+			if (context->cred)
+				is_owner = uid_eq(context->cred->uid, uid);
+			vmci_ctx_release(context);
+		}
+	}
+
+	return is_owner;
+}
+EXPORT_SYMBOL(vmci_is_context_owner);
diff --git a/drivers/misc/vmw_vmci/vmci_context.h b/drivers/misc/vmw_vmci/vmci_context.h
new file mode 100644
index 0000000..b997b7d
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_context.h
@@ -0,0 +1,177 @@
+/*
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
+ */
+
+#ifndef _VMCI_CONTEXT_H_
+#define _VMCI_CONTEXT_H_
+
+#include <linux/vmw_vmci_defs.h>
+#include <linux/atomic.h>
+#include <linux/kref.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+
+#include "vmci_handle_array.h"
+#include "vmci_common_int.h"
+#include "vmci_datagram.h"
+
+/* Used to determine what checkpoint state to get and set. */
+enum {
+	VMCI_NOTIFICATION_CPT_STATE = 1,
+	VMCI_WELLKNOWN_CPT_STATE    = 2,
+	VMCI_DG_OUT_STATE           = 3,
+	VMCI_DG_IN_STATE            = 4,
+	VMCI_DG_IN_SIZE_STATE       = 5,
+	VMCI_DOORBELL_CPT_STATE     = 6,
+};
+
+/* Host specific struct used for signalling */
+struct vmci_host {
+	wait_queue_head_t wait_queue;
+};
+
+struct vmci_handle_list {
+	struct list_head node;
+	struct vmci_handle handle;
+};
+
+struct vmci_ctx {
+	struct list_head list_item;       /* For global VMCI list. */
+	u32 cid;
+	struct kref kref;
+	struct list_head datagram_queue;  /* Head of per VM queue. */
+	u32 pending_datagrams;
+	size_t datagram_queue_size;	  /* Size of datagram queue in bytes. */
+
+	/*
+	 * Version of the code that created
+	 * this context; e.g., VMX.
+	 */
+	int user_version;
+	spinlock_t lock;  /* Locks callQueue and handle_arrays. */
+
+	/*
+	 * queue_pairs attached to.  The array of
+	 * handles for queue pairs is accessed
+	 * from the code for QP API, and there
+	 * it is protected by the QP lock.  It
+	 * is also accessed from the context
+	 * clean up path, which does not
+	 * require a lock.  VMCILock is not
+	 * used to protect the QP array field.
+	 */
+	struct vmci_handle_arr *queue_pair_array;
+
+	/* Doorbells created by context. */
+	struct vmci_handle_arr *doorbell_array;
+
+	/* Doorbells pending for context. */
+	struct vmci_handle_arr *pending_doorbell_array;
+
+	/* Contexts current context is subscribing to. */
+	struct list_head notifier_list;
+	unsigned int n_notifiers;
+
+	struct vmci_host host_context;
+	u32 priv_flags;
+
+	const struct cred *cred;
+	bool *notify;		/* Notify flag pointer - hosted only. */
+	struct page *notify_page;	/* Page backing the notify UVA. */
+};
+
+/* VMCINotifyAddRemoveInfo: Used to add/remove remote context notifications. */
+struct vmci_ctx_info {
+	u32 remote_cid;
+	int result;
+};
+
+/* VMCICptBufInfo: Used to set/get current context's checkpoint state. */
+struct vmci_ctx_chkpt_buf_info {
+	u64 cpt_buf;
+	u32 cpt_type;
+	u32 buf_size;
+	s32 result;
+	u32 _pad;
+};
+
+/*
+ * VMCINotificationReceiveInfo: Used to recieve pending notifications
+ * for doorbells and queue pairs.
+ */
+struct vmci_ctx_notify_recv_info {
+	u64 db_handle_buf_uva;
+	u64 db_handle_buf_size;
+	u64 qp_handle_buf_uva;
+	u64 qp_handle_buf_size;
+	s32 result;
+	u32 _pad;
+};
+
+/*
+ * Utilility function that checks whether two entities are allowed
+ * to interact. If one of them is restricted, the other one must
+ * be trusted.
+ */
+static inline bool vmci_deny_interaction(u32 part_one, u32 part_two)
+{
+	return ((part_one & VMCI_PRIVILEGE_FLAG_RESTRICTED) &&
+		!(part_two & VMCI_PRIVILEGE_FLAG_TRUSTED)) ||
+	       ((part_two & VMCI_PRIVILEGE_FLAG_RESTRICTED) &&
+		!(part_one & VMCI_PRIVILEGE_FLAG_TRUSTED));
+}
+
+int vmci_ctx_init(void);
+int vmci_ctx_init_ctx(u32 cid, u32 flags,
+		      uintptr_t event_hnd, int version,
+		      const struct cred *cred, struct vmci_ctx **context);
+
+bool vmci_ctx_supports_host_qp(struct vmci_ctx *context);
+void vmci_ctx_release_ctx(struct vmci_ctx *context);
+int vmci_ctx_enqueue_datagram(u32 cid, struct vmci_datagram *dg);
+int vmci_ctx_dequeue_datagram(struct vmci_ctx *context,
+			      size_t *max_size, struct vmci_datagram **dg);
+int vmci_ctx_pending_datagrams(u32 cid, u32 *pending);
+struct vmci_ctx *vmci_ctx_get(u32 cid);
+void vmci_ctx_release(struct vmci_ctx *context);
+bool vmci_ctx_exists(u32 cid);
+
+u32 vmci_ctx_get_id(struct vmci_ctx *context);
+int vmci_ctx_add_notification(u32 context_id, u32 remote_cid);
+int vmci_ctx_remove_notification(u32 context_id, u32 remote_cid);
+int vmci_ctx_get_chkpt_state(u32 context_id, u32 cpt_type,
+			     u32 *num_cids, void **cpt_buf_ptr);
+int vmci_ctx_set_chkpt_state(u32 context_id, u32 cpt_type,
+			     u32 num_cids, void *cpt_buf);
+
+int vmci_ctx_qp_create(struct vmci_ctx *context, struct vmci_handle handle);
+int vmci_ctx_qp_destroy(struct vmci_ctx *context, struct vmci_handle handle);
+bool vmci_ctx_qp_exists(struct vmci_ctx *context, struct vmci_handle handle);
+
+void vmci_ctx_check_signal_notify(struct vmci_ctx *context);
+void vmci_ctx_unset_notify(struct vmci_ctx *context);
+
+int vmci_ctx_dbell_create(u32 context_id, struct vmci_handle handle);
+int vmci_ctx_dbell_destroy(u32 context_id, struct vmci_handle handle);
+int vmci_ctx_dbell_destroy_all(u32 context_id);
+int vmci_ctx_notify_dbell(u32 cid, struct vmci_handle handle,
+			  u32 src_priv_flags);
+
+int vmci_ctx_rcv_notifications_get(u32 context_id, struct vmci_handle_arr
+				   **db_handle_array, struct vmci_handle_arr
+				   **qp_handle_array);
+void vmci_ctx_rcv_notifications_release(u32 context_id, struct vmci_handle_arr
+					*db_handle_array, struct vmci_handle_arr
+					*qp_handle_array, bool success);
+#endif /* _VMCI_CONTEXT_H_ */

