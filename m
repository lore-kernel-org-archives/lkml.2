Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab2JPA2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:28:16 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:39264 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558Ab2JPA2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:28:14 -0400
Subject: [PATCH 02/10] VMCI: datagram implementation.
To: linux-kernel@vger.kernel.org, georgezhang@vmware.com,
        virtualization@lists.linux-foundation.org
From: George Zhang <georgezhang@vmware.com>
Cc: pv-drivers@vmware.com, vm-crosstalk@vmware.com, gregkh@linuxfoundation.org
Date: Mon, 15 Oct 2012 17:28:14 -0700
Message-ID: <20121016002806.26205.76718.stgit@promb-2n-dhcp175.eng.vmware.com>
In-Reply-To: <20121016002550.26205.67037.stgit@promb-2n-dhcp175.eng.vmware.com>
References: <20121016002550.26205.67037.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMCI datagram Implements datagrams to allow data to be sent between host and guest.


Signed-off-by: George Zhang <georgezhang@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_datagram.c |  522 +++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_datagram.h |   55 +++
 2 files changed, 577 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmci_datagram.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_datagram.h

diff --git a/drivers/misc/vmw_vmci/vmci_datagram.c b/drivers/misc/vmw_vmci/vmci_datagram.c
new file mode 100644
index 0000000..ea9bb04
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_datagram.c
@@ -0,0 +1,522 @@
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
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/bug.h>
+
+#include "vmci_common_int.h"
+#include "vmci_datagram.h"
+#include "vmci_resource.h"
+#include "vmci_context.h"
+#include "vmci_driver.h"
+#include "vmci_event.h"
+#include "vmci_route.h"
+
+/*
+ * struct datagram_entry describes the datagram entity. It is used for datagram
+ * entities created only on the host.
+ */
+struct datagram_entry {
+	struct vmci_resource resource;
+	u32 flags;
+	bool run_delayed;
+	vmci_datagram_recv_cb recv_cb;
+	void *client_data;
+	u32 priv_flags;
+};
+
+struct delayed_datagram_info {
+	struct datagram_entry *entry;
+	struct vmci_datagram msg;
+	struct work_struct work;
+	bool in_dg_host_queue;
+};
+
+static atomic_t delayed_dg_host_queue_size;
+
+
+/*
+ * Create a datagram entry given a handle pointer.
+ */
+static int dg_create_handle(u32 resource_id,
+			    u32 flags,
+			    u32 priv_flags,
+			    vmci_datagram_recv_cb recv_cb,
+			    void *client_data, struct vmci_handle *out_handle)
+{
+	int result;
+	u32 context_id;
+	struct vmci_handle handle;
+	struct datagram_entry *entry;
+
+	ASSERT(recv_cb != NULL);
+	ASSERT(out_handle != NULL);
+	ASSERT(!(priv_flags & ~VMCI_PRIVILEGE_ALL_FLAGS));
+
+	if ((flags & VMCI_FLAG_WELLKNOWN_DG_HND) != 0)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	if ((flags & VMCI_FLAG_ANYCID_DG_HND) != 0) {
+		context_id = VMCI_INVALID_ID;
+	} else {
+		context_id = vmci_get_context_id();
+		if (context_id == VMCI_INVALID_ID)
+			return VMCI_ERROR_NO_RESOURCES;
+	}
+
+	handle = vmci_make_handle(context_id, resource_id);
+
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (entry == NULL) {
+		pr_warn("Failed allocating memory for datagram entry.");
+		return VMCI_ERROR_NO_MEM;
+	}
+
+	entry->run_delayed = (flags & VMCI_FLAG_DG_DELAYED_CB) ? true : false;
+	entry->flags = flags;
+	entry->recv_cb = recv_cb;
+	entry->client_data = client_data;
+	entry->priv_flags = priv_flags;
+
+	/* Make datagram resource live. */
+	result = vmci_resource_add(&entry->resource,
+				   VMCI_RESOURCE_TYPE_DATAGRAM,
+				   handle);
+	if (result != VMCI_SUCCESS) {
+		pr_warn("Failed to add new resource (handle=0x%x:0x%x), error: %d",
+			handle.context, handle.resource, result);
+		kfree(entry);
+		return result;
+	}
+
+	*out_handle = vmci_resource_handle(&entry->resource);
+	return VMCI_SUCCESS;
+}
+
+int __init vmci_datagram_init(void)
+{
+	atomic_set(&delayed_dg_host_queue_size, 0);
+	return VMCI_SUCCESS;
+}
+
+/*
+ * Internal utilility function with the same purpose as
+ * vmci_datagram_get_priv_flags that also takes a context_id.
+ */
+static int vmci_datagram_get_priv_flags(u32 context_id,
+					struct vmci_handle handle,
+					u32 *priv_flags)
+{
+	ASSERT(priv_flags);
+	ASSERT(context_id != VMCI_INVALID_ID);
+
+	if (context_id == VMCI_HOST_CONTEXT_ID) {
+		struct datagram_entry *src_entry;
+		struct vmci_resource *resource;
+
+		resource = vmci_resource_by_handle(handle,
+						   VMCI_RESOURCE_TYPE_DATAGRAM);
+		if (!resource)
+			return VMCI_ERROR_INVALID_ARGS;
+
+		src_entry = container_of(resource, struct datagram_entry,
+					 resource);
+		*priv_flags = src_entry->priv_flags;
+		vmci_resource_put(resource);
+	} else if (context_id == VMCI_HYPERVISOR_CONTEXT_ID)
+		*priv_flags = VMCI_MAX_PRIVILEGE_FLAGS;
+	else
+		*priv_flags = vmci_context_get_priv_flags(context_id);
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ * Calls the specified callback in a delayed context.
+ */
+static void dg_delayed_dispatch(struct work_struct *work)
+{
+	struct delayed_datagram_info *dg_info =
+			container_of(work, struct delayed_datagram_info, work);
+
+	dg_info->entry->recv_cb(dg_info->entry->client_data, &dg_info->msg);
+
+	vmci_resource_put(&dg_info->entry->resource);
+
+	if (dg_info->in_dg_host_queue)
+		atomic_dec(&delayed_dg_host_queue_size);
+
+	kfree(dg_info);
+}
+
+/*
+ * Dispatch datagram as a host, to the host, or other vm context. This
+ * function cannot dispatch to hypervisor context handlers. This should
+ * have been handled before we get here by VMCIDatagramDispatch.
+ * Returns number of bytes sent on success, error code otherwise.
+ */
+static int dg_dispatch_as_host(u32 context_id, struct vmci_datagram *dg)
+{
+	int retval;
+	size_t dg_size;
+	u32 src_priv_flags;
+
+	ASSERT(dg);
+	ASSERT(vmci_host_code_active());
+
+	dg_size = VMCI_DG_SIZE(dg);
+
+	if (context_id == VMCI_HOST_CONTEXT_ID &&
+	    dg->dst.context == VMCI_HYPERVISOR_CONTEXT_ID)
+		return VMCI_ERROR_DST_UNREACHABLE;
+
+	ASSERT(dg->dst.context != VMCI_HYPERVISOR_CONTEXT_ID);
+
+	/* Check that source handle matches sending context. */
+	if (dg->src.context != context_id) {
+		pr_devel("Sender context (ID=0x%x) is not owner of src "
+			 "datagram entry (handle=0x%x:0x%x).",
+			 context_id, dg->src.context, dg->src.resource);
+		return VMCI_ERROR_NO_ACCESS;
+	}
+
+	/* Get hold of privileges of sending endpoint. */
+	retval =
+	    vmci_datagram_get_priv_flags(context_id, dg->src, &src_priv_flags);
+	if (retval != VMCI_SUCCESS) {
+		pr_warn("Couldn't get privileges (handle=0x%x:0x%x).",
+			dg->src.context, dg->src.resource);
+		return retval;
+	}
+
+	/* Determine if we should route to host or guest destination. */
+	if (dg->dst.context == VMCI_HOST_CONTEXT_ID) {
+		/* Route to host datagram entry. */
+		struct datagram_entry *dst_entry;
+		struct vmci_resource *resource;
+
+		if (dg->src.context == VMCI_HYPERVISOR_CONTEXT_ID &&
+		    dg->dst.resource == VMCI_EVENT_HANDLER) {
+			return vmci_event_dispatch(dg);
+		}
+
+		resource = vmci_resource_by_handle(dg->dst,
+						   VMCI_RESOURCE_TYPE_DATAGRAM);
+		if (!resource) {
+			pr_devel("Sending to invalid destination (handle=0x%x:0x%x).",
+				 dg->dst.context, dg->dst.resource);
+			return VMCI_ERROR_INVALID_RESOURCE;
+		}
+		dst_entry =
+		    container_of(resource, struct datagram_entry, resource);
+		if (vmci_deny_interaction(src_priv_flags,
+					  dst_entry->priv_flags)) {
+			vmci_resource_put(resource);
+			return VMCI_ERROR_NO_ACCESS;
+		}
+		ASSERT(dst_entry->recv_cb);
+
+		/*
+		 * If a VMCI datagram destined for the host is also sent by the
+		 * host, we always run it delayed. This ensures that no locks
+		 * are held when the datagram callback runs.
+		 */
+		if (dst_entry->run_delayed ||
+		    dg->src.context == VMCI_HOST_CONTEXT_ID) {
+			struct delayed_datagram_info *dg_info;
+
+			if (atomic_add_return(1, &delayed_dg_host_queue_size)
+			    == VMCI_MAX_DELAYED_DG_HOST_QUEUE_SIZE) {
+				atomic_dec(&delayed_dg_host_queue_size);
+				vmci_resource_put(resource);
+				return VMCI_ERROR_NO_MEM;
+			}
+
+			dg_info = kmalloc(sizeof(*dg_info) +
+				    (size_t) dg->payload_size, GFP_ATOMIC);
+			if (!dg_info) {
+				atomic_dec(&delayed_dg_host_queue_size);
+				vmci_resource_put(resource);
+				return VMCI_ERROR_NO_MEM;
+			}
+
+			dg_info->in_dg_host_queue = true;
+			dg_info->entry = dst_entry;
+			memcpy(&dg_info->msg, dg, dg_size);
+
+			INIT_WORK(&dg_info->work, dg_delayed_dispatch);
+			schedule_work(&dg_info->work);
+			retval = VMCI_SUCCESS;
+
+		} else {
+			retval = dst_entry->recv_cb(dst_entry->client_data, dg);
+			vmci_resource_put(resource);
+			if (retval < VMCI_SUCCESS)
+				return retval;
+		}
+	} else {
+		/* Route to destination VM context. */
+		struct vmci_datagram *new_dg;
+
+		if (context_id != dg->dst.context) {
+			if (vmci_deny_interaction(src_priv_flags,
+						  vmci_context_get_priv_flags
+						  (dg->dst.context))) {
+				return VMCI_ERROR_NO_ACCESS;
+			} else if (VMCI_CONTEXT_IS_VM(context_id)) {
+				/*
+				 * If the sending context is a VM, it
+				 * cannot reach another VM.
+				 */
+
+				pr_devel("Datagram communication between VMs "
+					 "not supported (src=0x%x, dst=0x%x).",
+					 context_id, dg->dst.context);
+				return VMCI_ERROR_DST_UNREACHABLE;
+			}
+		}
+
+		/* We make a copy to enqueue. */
+		new_dg = kmalloc(dg_size, GFP_KERNEL);
+		if (new_dg == NULL)
+			return VMCI_ERROR_NO_MEM;
+
+		memcpy(new_dg, dg, dg_size);
+		retval = vmci_ctx_enqueue_datagram(dg->dst.context, new_dg);
+		if (retval < VMCI_SUCCESS) {
+			kfree(new_dg);
+			return retval;
+		}
+	}
+
+	/*
+	 * We currently truncate the size to signed 32 bits. This doesn't
+	 * matter for this handler as it only support 4Kb messages.
+	 */
+	return (int)dg_size;
+}
+
+/*
+ * Dispatch datagram as a guest, down through the VMX and potentially to
+ * the host.
+ * Returns number of bytes sent on success, error code otherwise.
+ */
+static int dg_dispatch_as_guest(struct vmci_datagram *dg)
+{
+	int retval;
+	struct vmci_resource *resource;
+
+	resource = vmci_resource_by_handle(dg->src,
+					   VMCI_RESOURCE_TYPE_DATAGRAM);
+	if (!resource)
+		return VMCI_ERROR_NO_HANDLE;
+
+	retval = vmci_send_datagram(dg);
+	vmci_resource_put(resource);
+	return retval;
+}
+
+/*
+ * Dispatch datagram.  This will determine the routing for the datagram
+ * and dispatch it accordingly.
+ * Returns number of bytes sent on success, error code otherwise.
+ */
+int vmci_datagram_dispatch(u32 context_id,
+			   struct vmci_datagram *dg, bool from_guest)
+{
+	int retval;
+	enum vmci_route route;
+
+	ASSERT(dg);
+	BUILD_BUG_ON(sizeof(struct vmci_datagram) != 24);
+
+	if (VMCI_DG_SIZE(dg) > VMCI_MAX_DG_SIZE) {
+		pr_devel("Payload (size=%llu bytes) too big to "
+			 "send.", (unsigned long long)dg->payload_size);
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	retval = vmci_route(&dg->src, &dg->dst, from_guest, &route);
+	if (retval < VMCI_SUCCESS) {
+		pr_devel("Failed to route datagram (src=0x%x, dst=0x%x, "
+			 "err=%d).", dg->src.context, dg->dst.context, retval);
+		return retval;
+	}
+
+	if (VMCI_ROUTE_AS_HOST == route) {
+		if (VMCI_INVALID_ID == context_id)
+			context_id = VMCI_HOST_CONTEXT_ID;
+		return dg_dispatch_as_host(context_id, dg);
+	}
+
+	if (VMCI_ROUTE_AS_GUEST == route)
+		return dg_dispatch_as_guest(dg);
+
+	pr_warn("Unknown route (%d) for datagram.", route);
+	return VMCI_ERROR_DST_UNREACHABLE;
+}
+
+/*
+ * Invoke the handler for the given datagram.  This is intended to be
+ * called only when acting as a guest and receiving a datagram from the
+ * virtual device.
+ */
+int vmci_datagram_invoke_guest_handler(struct vmci_datagram *dg)
+{
+	struct vmci_resource *resource;
+	struct datagram_entry *dst_entry;
+
+	ASSERT(dg);
+
+	resource = vmci_resource_by_handle(dg->dst,
+					   VMCI_RESOURCE_TYPE_DATAGRAM);
+	if (!resource) {
+		pr_devel("destination (handle=0x%x:0x%x) doesn't exist.",
+			 dg->dst.context, dg->dst.resource);
+		return VMCI_ERROR_NO_HANDLE;
+	}
+
+	dst_entry = container_of(resource, struct datagram_entry, resource);
+	if (dst_entry->run_delayed) {
+		struct delayed_datagram_info *dg_info;
+
+		dg_info = kmalloc(sizeof(*dg_info) + (size_t)dg->payload_size,
+				  GFP_ATOMIC);
+		if (!dg_info) {
+			vmci_resource_put(resource);
+			return VMCI_ERROR_NO_MEM;
+		}
+
+		dg_info->in_dg_host_queue = false;
+		dg_info->entry = dst_entry;
+		memcpy(&dg_info->msg, dg, VMCI_DG_SIZE(dg));
+
+		INIT_WORK(&dg_info->work, dg_delayed_dispatch);
+		schedule_work(&dg_info->work);
+	} else {
+		dst_entry->recv_cb(dst_entry->client_data, dg);
+		vmci_resource_put(resource);
+	}
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ * vmci_datagram_create_handle_priv() - Create host context datagram endpoint
+ * @resource_id:        The resource ID.
+ * @flags:      Datagram Flags.
+ * @priv_flags: Privilege Flags.
+ * @recv_cb:    Callback when receiving datagrams.
+ * @client_data:        Pointer for a datagram_entry struct
+ * @out_handle: vmci_handle that is populated as a result of this function.
+ *
+ * Creates a host context datagram endpoint and returns a handle to it.
+ */
+int vmci_datagram_create_handle_priv(u32 resource_id,
+				     u32 flags,
+				     u32 priv_flags,
+				     vmci_datagram_recv_cb recv_cb,
+				     void *client_data,
+				     struct vmci_handle *out_handle)
+{
+	if (out_handle == NULL)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	if (recv_cb == NULL) {
+		pr_devel("Client callback needed when creating " "datagram.");
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	if (priv_flags & ~VMCI_PRIVILEGE_ALL_FLAGS)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	return dg_create_handle(resource_id, flags, priv_flags, recv_cb,
+				client_data, out_handle);
+}
+EXPORT_SYMBOL(vmci_datagram_create_handle_priv);
+
+/*
+ * vmci_datagram_create_handle() - Create host context datagram endpoint
+ * @resource_id:        Resource ID.
+ * @flags:      Datagram Flags.
+ * @recv_cb:    Callback when receiving datagrams.
+ * @client_ata: Pointer for a datagram_entry struct
+ * @out_handle: vmci_handle that is populated as a result of this function.
+ *
+ * Creates a host context datagram endpoint and returns a handle to
+ * it.  Same as vmci_datagram_create_handle_priv without the priviledge
+ * flags argument.
+ */
+int vmci_datagram_create_handle(u32 resource_id,
+				u32 flags,
+				vmci_datagram_recv_cb recv_cb,
+				void *client_data,
+				struct vmci_handle *out_handle)
+{
+	return vmci_datagram_create_handle_priv(
+		resource_id, flags,
+		VMCI_DEFAULT_PROC_PRIVILEGE_FLAGS,
+		recv_cb, client_data,
+		out_handle);
+}
+EXPORT_SYMBOL(vmci_datagram_create_handle);
+
+/*
+ * vmci_datagram_destroy_handle() - Destroys datagram handle
+ * @handle:     vmci_handle to be destroyed and reaped.
+ *
+ * Use this function to destroy any datagram handles created by
+ * vmci_datagram_create_handle{,Priv} functions.
+ */
+int vmci_datagram_destroy_handle(struct vmci_handle handle)
+{
+	struct datagram_entry *entry;
+	struct vmci_resource *resource;
+
+	resource = vmci_resource_by_handle(handle, VMCI_RESOURCE_TYPE_DATAGRAM);
+	if (!resource) {
+		pr_devel("Failed to destroy datagram (handle=0x%x:0x%x).",
+			 handle.context, handle.resource);
+		return VMCI_ERROR_NOT_FOUND;
+	}
+
+	entry = container_of(resource, struct datagram_entry, resource);
+
+	vmci_resource_put(&entry->resource);
+	vmci_resource_remove(&entry->resource);
+	kfree(entry);
+
+	return VMCI_SUCCESS;
+}
+EXPORT_SYMBOL(vmci_datagram_destroy_handle);
+
+/*
+ * vmci_datagram_send() - Send a datagram
+ * @msg:        The datagram to send.
+ *
+ * Sends the provided datagram on its merry way.
+ */
+int vmci_datagram_send(struct vmci_datagram *msg)
+{
+	if (msg == NULL)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	return vmci_datagram_dispatch(VMCI_INVALID_ID, msg, false);
+}
+EXPORT_SYMBOL(vmci_datagram_send);
diff --git a/drivers/misc/vmw_vmci/vmci_datagram.h b/drivers/misc/vmw_vmci/vmci_datagram.h
new file mode 100644
index 0000000..28a2c11
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_datagram.h
@@ -0,0 +1,55 @@
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
+#ifndef _VMCI_DATAGRAM_H_
+#define _VMCI_DATAGRAM_H_
+
+#include <linux/types.h>
+#include <linux/list.h>
+
+#include "vmci_context.h"
+
+#define VMCI_MAX_DELAYED_DG_HOST_QUEUE_SIZE 256
+
+/*
+ * The struct vmci_datagram_queue_entry is a queue header for the in-kernel VMCI
+ * datagram queues. It is allocated in non-paged memory, as the
+ * content is accessed while holding a spinlock. The pending datagram
+ * itself may be allocated from paged memory. We shadow the size of
+ * the datagram in the non-paged queue entry as this size is used
+ * while holding the same spinlock as above.
+ */
+struct vmci_datagram_queue_entry {
+	struct list_head list_item;	/* For queuing. */
+	size_t dg_size;		/* Size of datagram. */
+	struct vmci_datagram *dg;	/* Pending datagram. */
+};
+
+/* VMCIDatagramSendRecvInfo */
+struct vmci_datagram_snd_rcv_info {
+	u64 addr;
+	u32 len;
+	s32 result;
+};
+
+/* Init functions. */
+int vmci_datagram_init(void);
+
+/* Datagram API for non-public use. */
+int vmci_datagram_dispatch(u32 context_id, struct vmci_datagram *dg,
+			   bool from_guest);
+int vmci_datagram_invoke_guest_handler(struct vmci_datagram *dg);
+
+#endif /* _VMCI_DATAGRAM_H_ */

