Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab2FLUpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 16:45:05 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:53745 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754202Ab2FLUpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 16:45:01 -0400
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        vm-crosstalk@vmware.com
Cc: gregkh@linuxfoundation.org, cschamp@vmware.com, dtor@vmware.com,
        acking@vmware.com, dsouders@vmware.com,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [vmw_vmci RFCv2 02/11] Apply VMCI datagram code
Date: Tue, 12 Jun 2012 13:44:21 -0700
Message-Id: <1339533870-24187-3-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1339533870-24187-1-git-send-email-astiegmann@vmware.com>
References: <1339533870-24187-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implements datagrams to allow data to be sent between host
and guest.

Signed-off-by: Andrew Stiegmann (stieg) <astiegmann@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_datagram.c |  586 +++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_datagram.h |   56 ++++
 2 files changed, 642 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmci_datagram.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_datagram.h

diff --git a/drivers/misc/vmw_vmci/vmci_datagram.c b/drivers/misc/vmw_vmci/vmci_datagram.c
new file mode 100644
index 0000000..a804f99
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_datagram.c
@@ -0,0 +1,586 @@
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
+#include <linux/bug.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/vmw_vmci_api.h>
+#include <linux/vmw_vmci_defs.h>
+
+#include "vmci_common_int.h"
+#include "vmci_context.h"
+#include "vmci_datagram.h"
+#include "vmci_driver.h"
+#include "vmci_event.h"
+#include "vmci_hash_table.h"
+#include "vmci_resource.h"
+#include "vmci_route.h"
+
+/*
+ * struct datagram_entry describes the datagram entity. It is used for datagram
+ * entities created only on the host.
+ */
+struct datagram_entry {
+	struct vmci_resource resource;
+	uint32_t flags;
+	bool runDelayed;
+	VMCIDatagramRecvCB recvCB;
+	void *clientData;
+	wait_queue_head_t destroyEvent;
+	uint32_t privFlags;
+};
+
+struct delayed_datagram_info {
+	bool inDGHostQueue;
+	struct datagram_entry *entry;
+	struct vmci_dg msg;
+};
+
+static atomic_t delayedDGHostQueueSize;
+
+static void dg_free_cb(void *clientData)
+{
+	struct datagram_entry *entry = (struct datagram_entry *)clientData;
+	ASSERT(entry);
+
+	/*
+	 * Entry is freed in VMCIDatagram_DestroyHnd, who waits for
+	 * the signal.
+	 */
+	wake_up(&entry->destroyEvent);
+}
+
+static int dg_release_cb(void *clientData)
+{
+	struct datagram_entry *entry = (struct datagram_entry *)clientData;
+	ASSERT(entry);
+	vmci_resource_release(&entry->resource);
+	return 0;
+}
+
+/*
+ * Create a datagram entry given a handle pointer.
+ */
+static int dg_create_handle(uint32_t resourceID,
+			    uint32_t flags,
+			    uint32_t privFlags,
+			    VMCIDatagramRecvCB recvCB,
+			    void *clientData,
+			    struct vmci_handle *outHandle)
+{
+	int result;
+	uint32_t contextID;
+	struct vmci_handle handle;
+	struct datagram_entry *entry;
+
+	ASSERT(recvCB != NULL);
+	ASSERT(outHandle != NULL);
+	ASSERT(!(privFlags & ~VMCI_PRIVILEGE_ALL_FLAGS));
+
+	if ((flags & VMCI_FLAG_WELLKNOWN_DG_HND) != 0) {
+		return VMCI_ERROR_INVALID_ARGS;
+	} else {
+		if ((flags & VMCI_FLAG_ANYCID_DG_HND) != 0) {
+			contextID = VMCI_INVALID_ID;
+		} else {
+			contextID = VMCI_GetContextID();
+			if (contextID == VMCI_INVALID_ID)
+				return VMCI_ERROR_NO_RESOURCES;
+		}
+
+		if (resourceID == VMCI_INVALID_ID) {
+			resourceID = vmci_resource_get_id(contextID);
+			if (resourceID == VMCI_INVALID_ID)
+				return VMCI_ERROR_NO_HANDLE;
+		}
+
+		handle = vmci_make_handle(contextID, resourceID);
+	}
+
+	entry = kmalloc(sizeof *entry, GFP_KERNEL);
+	if (entry == NULL) {
+		pr_warn("Failed allocating memory for datagram entry.");
+		return VMCI_ERROR_NO_MEM;
+	}
+
+	entry->runDelayed = (flags & VMCI_FLAG_DG_DELAYED_CB) ? true : false;
+	entry->flags = flags;
+	entry->recvCB = recvCB;
+	entry->clientData = clientData;
+	init_waitqueue_head(&entry->destroyEvent);
+	entry->privFlags = privFlags;
+
+	/* Make datagram resource live. */
+	result = vmci_resource_add(&entry->resource,
+				   VMCI_RESOURCE_TYPE_DATAGRAM,
+				   handle, dg_free_cb, entry);
+	if (result != VMCI_SUCCESS) {
+		pr_warn("Failed to add new resource (handle=0x%x:0x%x).",
+			handle.context, handle.resource);
+		kfree(entry);
+		return result;
+	}
+	*outHandle = handle;
+
+	return VMCI_SUCCESS;
+}
+
+int __init vmci_dg_init(void)
+{
+	atomic_set(&delayedDGHostQueueSize, 0);
+	return VMCI_SUCCESS;
+}
+
+/*
+ * Internal utilility function with the same purpose as
+ * vmci_dg_get_priv_flags that also takes a contextID.
+ */
+static int vmci_dg_get_priv_flags(uint32_t contextID,
+				  struct vmci_handle handle,
+				  uint32_t *privFlags)
+{
+	ASSERT(privFlags);
+	ASSERT(contextID != VMCI_INVALID_ID);
+
+	if (contextID == VMCI_HOST_CONTEXT_ID) {
+		struct datagram_entry *srcEntry;
+		struct vmci_resource *resource;
+
+		resource =
+			vmci_resource_get(handle, VMCI_RESOURCE_TYPE_DATAGRAM);
+		if (resource == NULL)
+			return VMCI_ERROR_INVALID_ARGS;
+
+		srcEntry = container_of(resource, struct datagram_entry,
+					resource);
+		*privFlags = srcEntry->privFlags;
+		vmci_resource_release(resource);
+	} else if (contextID == VMCI_HYPERVISOR_CONTEXT_ID) {
+		*privFlags = VMCI_MAX_PRIVILEGE_FLAGS;
+	} else {
+		*privFlags = VMCIContext_GetPrivFlags(contextID);
+	}
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ * Calls the specified callback in a delayed context.
+ */
+static void dg_delayed_dispatch_cb(void *data)
+{
+	bool inDGHostQueue;
+	struct delayed_datagram_info *dgInfo =
+		(struct delayed_datagram_info *)data;
+
+	ASSERT(data);
+
+	dgInfo->entry->recvCB(dgInfo->entry->clientData, &dgInfo->msg);
+
+	vmci_resource_release(&dgInfo->entry->resource);
+
+	inDGHostQueue = dgInfo->inDGHostQueue;
+	kfree(dgInfo);
+
+	if (inDGHostQueue)
+		atomic_dec(&delayedDGHostQueueSize);
+}
+
+/*
+ * Dispatch datagram as a host, to the host, or other vm context. This
+ * function cannot dispatch to hypervisor context handlers. This should
+ * have been handled before we get here by VMCIDatagramDispatch.
+ * Returns number of bytes sent on success, error code otherwise.
+ */
+static int dg_dispatch_as_host(uint32_t contextID,
+			       struct vmci_dg *dg)
+{
+	int retval;
+	size_t dgSize;
+	uint32_t srcPrivFlags;
+
+	ASSERT(dg);
+	ASSERT(vmci_host_code_active());
+
+	dgSize = VMCI_DG_SIZE(dg);
+
+	if (contextID == VMCI_HOST_CONTEXT_ID &&
+	    dg->dst.context == VMCI_HYPERVISOR_CONTEXT_ID)
+		return VMCI_ERROR_DST_UNREACHABLE;
+
+	ASSERT(dg->dst.context != VMCI_HYPERVISOR_CONTEXT_ID);
+
+	/* Check that source handle matches sending context. */
+	if (dg->src.context != contextID) {
+		pr_devel("Sender context (ID=0x%x) is not owner of src " \
+			 "datagram entry (handle=0x%x:0x%x).",
+			 contextID, dg->src.context, dg->src.resource);
+		return VMCI_ERROR_NO_ACCESS;
+	}
+
+	/* Get hold of privileges of sending endpoint. */
+	retval = vmci_dg_get_priv_flags(contextID, dg->src, &srcPrivFlags);
+	if (retval != VMCI_SUCCESS) {
+		pr_warn("Couldn't get privileges (handle=0x%x:0x%x).",
+			dg->src.context, dg->src.resource);
+		return retval;
+	}
+
+	/* Determine if we should route to host or guest destination. */
+	if (dg->dst.context == VMCI_HOST_CONTEXT_ID) {
+		/* Route to host datagram entry. */
+		struct datagram_entry *dstEntry;
+		struct vmci_resource *resource;
+
+		if (dg->src.context == VMCI_HYPERVISOR_CONTEXT_ID &&
+		    dg->dst.resource == VMCI_EVENT_HANDLER) {
+			return vmci_event_dispatch(dg);
+		}
+
+		resource = vmci_resource_get(dg->dst,
+					     VMCI_RESOURCE_TYPE_DATAGRAM);
+		if (resource == NULL) {
+			pr_devel("Sending to invalid destination " \
+				 "(handle=0x%x:0x%x).", dg->dst.context,
+				 dg->dst.resource);
+			return VMCI_ERROR_INVALID_RESOURCE;
+		}
+		dstEntry =
+			container_of(resource, struct datagram_entry,
+				     resource);
+		if (vmci_deny_interaction(srcPrivFlags, dstEntry->privFlags)) {
+			vmci_resource_release(resource);
+			return VMCI_ERROR_NO_ACCESS;
+		}
+		ASSERT(dstEntry->recvCB);
+
+		/*
+		 * If a VMCI datagram destined for the host is also sent by the
+		 * host, we always run it delayed. This ensures that no locks
+		 * are held when the datagram callback runs.
+		 */
+		if (dstEntry->runDelayed
+		    || dg->src.context == VMCI_HOST_CONTEXT_ID) {
+			struct delayed_datagram_info *dgInfo;
+
+			if (atomic_add_return(1, &delayedDGHostQueueSize)
+			    == VMCI_MAX_DELAYED_DG_HOST_QUEUE_SIZE) {
+				atomic_dec(&delayedDGHostQueueSize);
+				vmci_resource_release(resource);
+				return VMCI_ERROR_NO_MEM;
+			}
+
+			dgInfo =
+				kmalloc(sizeof *dgInfo +
+					(size_t) dg->payloadSize, GFP_ATOMIC);
+			if (NULL == dgInfo) {
+				atomic_dec(&delayedDGHostQueueSize);
+				vmci_resource_release(resource);
+				return VMCI_ERROR_NO_MEM;
+			}
+
+			dgInfo->inDGHostQueue = true;
+			dgInfo->entry = dstEntry;
+			memcpy(&dgInfo->msg, dg, dgSize);
+			retval =
+			  vmci_drv_schedule_delayed_work(dg_delayed_dispatch_cb,
+							 dgInfo);
+			if (retval < VMCI_SUCCESS) {
+				pr_warn("Failed to schedule delayed " \
+					"work for datagram (result=%d).",
+					retval);
+				kfree(dgInfo);
+				vmci_resource_release(resource);
+				atomic_dec(&delayedDGHostQueueSize);
+				return retval;
+			}
+		} else {
+			retval = dstEntry->recvCB(dstEntry->clientData, dg);
+			vmci_resource_release(resource);
+			if (retval < VMCI_SUCCESS)
+				return retval;
+		}
+	} else {
+		/* Route to destination VM context. */
+		struct vmci_dg *newDG;
+
+		if (contextID != dg->dst.context) {
+			if (vmci_deny_interaction(srcPrivFlags,
+						  VMCIContext_GetPrivFlags
+						  (dg->dst.context))) {
+				return VMCI_ERROR_NO_ACCESS;
+			} else if (VMCI_CONTEXT_IS_VM(contextID)) {
+				/*
+				 * If the sending context is a VM, it
+				 * cannot reach another VM.
+				 */
+
+				pr_devel("Datagram communication between VMs " \
+					 "not supported (src=0x%x, dst=0x%x).",
+					 contextID, dg->dst.context);
+				return VMCI_ERROR_DST_UNREACHABLE;
+			}
+		}
+
+		/* We make a copy to enqueue. */
+		newDG = kmalloc(dgSize, GFP_KERNEL);
+		if (newDG == NULL)
+			return VMCI_ERROR_NO_MEM;
+
+		memcpy(newDG, dg, dgSize);
+		retval = vmci_ctx_enqueue_dg(dg->dst.context, newDG);
+		if (retval < VMCI_SUCCESS) {
+			kfree(newDG);
+			return retval;
+		}
+	}
+
+	/*
+	 * We currently truncate the size to signed 32 bits. This doesn't
+	 * matter for this handler as it only support 4Kb messages.
+	 */
+	return (int)dgSize;
+}
+
+/*
+ * Dispatch datagram as a guest, down through the VMX and potentially to
+ * the host.
+ * Returns number of bytes sent on success, error code otherwise.
+ */
+static int dg_dispatch_as_guest(struct vmci_dg *dg)
+{
+	int retval;
+	struct vmci_resource *resource;
+
+	resource = vmci_resource_get(dg->src, VMCI_RESOURCE_TYPE_DATAGRAM);
+	if (NULL == resource)
+		return VMCI_ERROR_NO_HANDLE;
+
+	retval = vmci_send_dg(dg);
+	vmci_resource_release(resource);
+	return retval;
+}
+
+/*
+ * Dispatch datagram.  This will determine the routing for the datagram
+ * and dispatch it accordingly.
+ * Returns number of bytes sent on success, error code otherwise.
+ */
+int vmci_dg_dispatch(uint32_t contextID,
+		     struct vmci_dg *dg, bool fromGuest)
+{
+	int retval;
+	enum vmci_route route;
+
+	ASSERT(dg);
+	BUILD_BUG_ON(sizeof(struct vmci_dg) != 24);
+
+	if (VMCI_DG_SIZE(dg) > VMCI_MAX_DG_SIZE) {
+		pr_devel("Payload (size=%llu bytes) too big to " \
+			 "send.", (unsigned long long) dg->payloadSize);
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	retval = vmci_route(&dg->src, &dg->dst, fromGuest, &route);
+	if (retval < VMCI_SUCCESS) {
+		pr_devel("Failed to route datagram (src=0x%x, dst=0x%x, " \
+			 "err=%d).", dg->src.context, dg->dst.context,
+			 retval);
+		return retval;
+	}
+
+	if (VMCI_ROUTE_AS_HOST == route) {
+		if (VMCI_INVALID_ID == contextID)
+			contextID = VMCI_HOST_CONTEXT_ID;
+		return dg_dispatch_as_host(contextID, dg);
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
+int vmci_dg_invoke_guest_handler(struct vmci_dg *dg)
+{
+	int retval;
+	struct vmci_resource *resource;
+	struct datagram_entry *dstEntry;
+
+	ASSERT(dg);
+
+	resource = vmci_resource_get(dg->dst, VMCI_RESOURCE_TYPE_DATAGRAM);
+	if (NULL == resource) {
+		pr_devel("destination (handle=0x%x:0x%x) doesn't exist.",
+			 dg->dst.context, dg->dst.resource);
+		return VMCI_ERROR_NO_HANDLE;
+	}
+
+	dstEntry =
+		container_of(resource, struct datagram_entry, resource);
+	if (dstEntry->runDelayed) {
+		struct delayed_datagram_info *dgInfo;
+
+		dgInfo =
+			kmalloc(sizeof *dgInfo + (size_t) dg->payloadSize,
+				GFP_ATOMIC);
+		if (NULL == dgInfo) {
+			vmci_resource_release(resource);
+			retval = VMCI_ERROR_NO_MEM;
+			goto exit;
+		}
+
+		dgInfo->inDGHostQueue = false;
+		dgInfo->entry = dstEntry;
+		memcpy(&dgInfo->msg, dg, VMCI_DG_SIZE(dg));
+
+		retval =
+			vmci_drv_schedule_delayed_work(dg_delayed_dispatch_cb,
+						       dgInfo);
+		if (retval < VMCI_SUCCESS) {
+			pr_warn("Failed to schedule delayed work for " \
+				"datagram (result=%d).", retval);
+			kfree(dgInfo);
+			vmci_resource_release(resource);
+			dgInfo = NULL;
+			goto exit;
+		}
+	} else {
+		dstEntry->recvCB(dstEntry->clientData, dg);
+		vmci_resource_release(resource);
+		retval = VMCI_SUCCESS;
+	}
+
+exit:
+	return retval;
+}
+
+/**
+ * VMCIDatagram_CreateHndPriv() - Create host context datagram endpoint
+ * @resourceID:	The resource ID.
+ * @flags:	Datagram Flags.
+ * @privFlags:	Privilege Flags.
+ * @recvCB:	Callback when receiving datagrams.
+ * @clientData:	Pointer for a datagram_entry struct
+ * @outHandle:	vmci_handle that is populated as a result of this function.
+ *
+ * Creates a host context datagram endpoint and returns a handle to it.
+ */
+int VMCIDatagram_CreateHndPriv(uint32_t resourceID,
+			       uint32_t flags,
+			       uint32_t privFlags,
+			       VMCIDatagramRecvCB recvCB,
+			       void *clientData,
+			       struct vmci_handle *outHandle)
+{
+	if (outHandle == NULL)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	if (recvCB == NULL) {
+		pr_devel("Client callback needed when creating " \
+			 "datagram.");
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	if (privFlags & ~VMCI_PRIVILEGE_ALL_FLAGS)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	return dg_create_handle(resourceID, flags, privFlags, recvCB,
+				clientData, outHandle);
+}
+EXPORT_SYMBOL(VMCIDatagram_CreateHndPriv);
+
+/**
+ * VMCIDatagram_CreateHnd() - Create host context datagram endpoint
+ * @resourceID:	Resource ID.
+ * @flags:	Datagram Flags.
+ * @recvCB:	Callback when receiving datagrams.
+ * @clientData:	Pointer for a datagram_entry struct
+ * @outHandle:	vmci_handle that is populated as a result of this function.
+ *
+ * Creates a host context datagram endpoint and returns a handle to
+ * it.  Same as VMCIDatagram_CreateHndPriv without the priviledge
+ * flags argument.
+ */
+int VMCIDatagram_CreateHnd(uint32_t resourceID,
+			   uint32_t flags,
+			   VMCIDatagramRecvCB recvCB,
+			   void *clientData,
+			   struct vmci_handle *outHandle)
+{
+	return VMCIDatagram_CreateHndPriv(resourceID, flags,
+					  VMCI_DEFAULT_PROC_PRIVILEGE_FLAGS,
+					  recvCB, clientData, outHandle);
+}
+EXPORT_SYMBOL(VMCIDatagram_CreateHnd);
+
+/**
+ * VMCIDatagram_DestroyHnd() - Destroys datagram handle
+ * @handle:	vmci_handle to be destroyed and reaped.
+ *
+ * Use this function to destroy any datagram handles created by
+ * VMCIDatagram_CreateHnd{,Priv} functions.
+ */
+int VMCIDatagram_DestroyHnd(struct vmci_handle handle)
+{
+	struct datagram_entry *entry;
+	struct vmci_resource *resource;
+
+	resource = vmci_resource_get(handle, VMCI_RESOURCE_TYPE_DATAGRAM);
+	if (resource == NULL) {
+		pr_devel("Failed to destroy datagram (handle=0x%x:0x%x)" \
+			 ".", handle.context, handle.resource);
+		return VMCI_ERROR_NOT_FOUND;
+	}
+
+	entry = container_of(resource, struct datagram_entry, resource);
+	vmci_resource_remove(handle, VMCI_RESOURCE_TYPE_DATAGRAM);
+
+	/*
+	 * We now wait on the destroyEvent and release the reference we got
+	 * above.
+	 */
+	vmci_drv_wait_on_event_intr(&entry->destroyEvent, dg_release_cb,
+				    entry);
+	kfree(entry);
+
+	return VMCI_SUCCESS;
+}
+EXPORT_SYMBOL(VMCIDatagram_DestroyHnd);
+
+/**
+ * VMCIDatagram_Send() - Send a datagram
+ * @msg:	The datagram to send.
+ *
+ * Sends the provided datagram on its merry way.
+ */
+int VMCIDatagram_Send(struct vmci_dg *msg)
+{
+	if (msg == NULL)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	return vmci_dg_dispatch(VMCI_INVALID_ID, msg, false);
+}
+EXPORT_SYMBOL(VMCIDatagram_Send);
diff --git a/drivers/misc/vmw_vmci/vmci_datagram.h b/drivers/misc/vmw_vmci/vmci_datagram.h
new file mode 100644
index 0000000..e5e54c2
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_datagram.h
@@ -0,0 +1,56 @@
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
+#ifndef _VMCI_DATAGRAM_H_
+#define _VMCI_DATAGRAM_H_
+
+#include "vmci_context.h"
+
+#define VMCI_MAX_DELAYED_DG_HOST_QUEUE_SIZE 256
+
+/*
+ * The struct vmci_dg_queue_entry is a queue header for the in-kernel VMCI
+ * datagram queues. It is allocated in non-paged memory, as the
+ * content is accessed while holding a spinlock. The pending datagram
+ * itself may be allocated from paged memory. We shadow the size of
+ * the datagram in the non-paged queue entry as this size is used
+ * while holding the same spinlock as above.
+ */
+struct vmci_dg_queue_entry {
+	struct list_head listItem;	/* For queuing. */
+	size_t dgSize;		/* Size of datagram. */
+	struct vmci_dg *dg;	/* Pending datagram. */
+};
+
+/* VMCIDatagramSendRecvInfo */
+struct vmci_dg_snd_rcv_info {
+	uint64_t addr;
+	uint32_t len;
+	int32_t result;
+};
+
+/* Init functions. */
+int vmci_dg_init(void);
+
+/* Datagram API for non-public use. */
+int vmci_dg_dispatch(uint32_t contextID, struct vmci_dg *dg,
+		     bool fromGuest);
+int vmci_dg_invoke_guest_handler(struct vmci_dg *dg);
+
+#endif /* _VMCI_DATAGRAM_H_ */
-- 
1.7.0.4

