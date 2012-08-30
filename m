Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2H3QkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 12:40:00 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:43175 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753472Ab2H3Qj6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 12:39:58 -0400
From: George Zhang <georgezhang@vmware.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Thu, 30 Aug 2012 09:39:19 -0700
Subject: [PATCH 02/11] vmci_datagram.patch: VMCI datagram entity handling.
Thread-Topic: [PATCH 02/11] vmci_datagram.patch: VMCI datagram entity
 handling.
Thread-Index: Ac2CHCAP1yBEJ3aQSFaSfVIMQxyP7AEseDTg
Message-ID: <15333E71B3DDCB48A90165AD57993F285685DB43D8@exch-mbx-114.vmware.com>
References: <20120824171042.4775.36871.stgit@promb-2n-dhcp175.eng.vmware.com>,<20120824171556.4775.64978.stgit@promb-2n-dhcp175.eng.vmware.com>
In-Reply-To: <20120824171556.4775.64978.stgit@promb-2n-dhcp175.eng.vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: George Zhang <georgezhang@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_datagram.c |  583 +++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_datagram.h |   55 +++
 2 files changed, 638 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmci_datagram.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_datagram.h

diff --git a/drivers/misc/vmw_vmci/vmci_datagram.c b/drivers/misc/vmw_vmci/vmci_datagram.c
new file mode 100644
index 0000000..21ee66d
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_datagram.c
@@ -0,0 +1,583 @@
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
+#include "vmci_hash_table.h"
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
+       struct vmci_resource resource;
+       u32 flags;
+       bool runDelayed;
+       vmci_datagram_recv_cb recvCB;
+       void *clientData;
+       wait_queue_head_t destroyEvent;
+       u32 privFlags;
+};
+
+struct delayed_datagram_info {
+       bool inDGHostQueue;
+       struct datagram_entry *entry;
+       struct vmci_datagram msg;
+};
+
+static atomic_t delayedDGHostQueueSize;
+
+static void dg_free_cb(void *clientData)
+{
+       struct datagram_entry *entry = (struct datagram_entry *)clientData;
+       ASSERT(entry);
+
+       /*
+        * Entry is freed in VMCIDatagram_DestroyHnd, who waits for
+        * the signal.
+        */
+       wake_up(&entry->destroyEvent);
+}
+
+static int dg_release_cb(void *clientData)
+{
+       struct datagram_entry *entry = (struct datagram_entry *)clientData;
+       ASSERT(entry);
+       vmci_resource_release(&entry->resource);
+       return 0;
+}
+
+/*
+ * Create a datagram entry given a handle pointer.
+ */
+static int dg_create_handle(u32 resourceID,
+                           u32 flags,
+                           u32 privFlags,
+                           vmci_datagram_recv_cb recvCB,
+                           void *clientData,
+                           struct vmci_handle *outHandle)
+{
+       int result;
+       u32 contextID;
+       struct vmci_handle handle;
+       struct datagram_entry *entry;
+
+       ASSERT(recvCB != NULL);
+       ASSERT(outHandle != NULL);
+       ASSERT(!(privFlags & ~VMCI_PRIVILEGE_ALL_FLAGS));
+
+       if ((flags & VMCI_FLAG_WELLKNOWN_DG_HND) != 0) {
+               return VMCI_ERROR_INVALID_ARGS;
+       } else {
+               if ((flags & VMCI_FLAG_ANYCID_DG_HND) != 0) {
+                       contextID = VMCI_INVALID_ID;
+               } else {
+                       contextID = vmci_get_context_id();
+                       if (contextID == VMCI_INVALID_ID)
+                               return VMCI_ERROR_NO_RESOURCES;
+               }
+
+               if (resourceID == VMCI_INVALID_ID) {
+                       resourceID = vmci_resource_get_id(contextID);
+                       if (resourceID == VMCI_INVALID_ID)
+                               return VMCI_ERROR_NO_HANDLE;
+               }
+
+               handle = vmci_make_handle(contextID, resourceID);
+       }
+
+       entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+       if (entry == NULL) {
+               pr_warn("Failed allocating memory for datagram entry.");
+               return VMCI_ERROR_NO_MEM;
+       }
+
+       entry->runDelayed = (flags & VMCI_FLAG_DG_DELAYED_CB) ? true : false;
+       entry->flags = flags;
+       entry->recvCB = recvCB;
+       entry->clientData = clientData;
+       init_waitqueue_head(&entry->destroyEvent);
+       entry->privFlags = privFlags;
+
+       /* Make datagram resource live. */
+       result = vmci_resource_add(&entry->resource,
+                                  VMCI_RESOURCE_TYPE_DATAGRAM,
+                                  handle, dg_free_cb, entry);
+       if (result != VMCI_SUCCESS) {
+               pr_warn("Failed to add new resource (handle=0x%x:0x%x).",
+                       handle.context, handle.resource);
+               kfree(entry);
+               return result;
+       }
+       *outHandle = handle;
+
+       return VMCI_SUCCESS;
+}
+
+int __init vmci_datagram_init(void)
+{
+       atomic_set(&delayedDGHostQueueSize, 0);
+       return VMCI_SUCCESS;
+}
+
+/*
+ * Internal utilility function with the same purpose as
+ * vmci_datagram_get_priv_flags that also takes a contextID.
+ */
+static int vmci_datagram_get_priv_flags(u32 contextID,
+                                 struct vmci_handle handle,
+                                 u32 *privFlags)
+{
+       ASSERT(privFlags);
+       ASSERT(contextID != VMCI_INVALID_ID);
+
+       if (contextID == VMCI_HOST_CONTEXT_ID) {
+               struct datagram_entry *srcEntry;
+               struct vmci_resource *resource;
+
+               resource =
+                       vmci_resource_get(handle, VMCI_RESOURCE_TYPE_DATAGRAM);
+               if (resource == NULL)
+                       return VMCI_ERROR_INVALID_ARGS;
+
+               srcEntry = container_of(resource, struct datagram_entry,
+                                       resource);
+               *privFlags = srcEntry->privFlags;
+               vmci_resource_release(resource);
+       } else if (contextID == VMCI_HYPERVISOR_CONTEXT_ID) {
+               *privFlags = VMCI_MAX_PRIVILEGE_FLAGS;
+       } else {
+               *privFlags = vmci_context_get_priv_flags(contextID);
+       }
+
+       return VMCI_SUCCESS;
+}
+
+/*
+ * Calls the specified callback in a delayed context.
+ */
+static void dg_delayed_dispatch_cb(void *data)
+{
+       bool inDGHostQueue;
+       struct delayed_datagram_info *dgInfo =
+               (struct delayed_datagram_info *)data;
+
+       ASSERT(data);
+
+       dgInfo->entry->recvCB(dgInfo->entry->clientData, &dgInfo->msg);
+
+       vmci_resource_release(&dgInfo->entry->resource);
+
+       inDGHostQueue = dgInfo->inDGHostQueue;
+       kfree(dgInfo);
+
+       if (inDGHostQueue)
+               atomic_dec(&delayedDGHostQueueSize);
+}
+
+/*
+ * Dispatch datagram as a host, to the host, or other vm context. This
+ * function cannot dispatch to hypervisor context handlers. This should
+ * have been handled before we get here by VMCIDatagramDispatch.
+ * Returns number of bytes sent on success, error code otherwise.
+ */
+static int dg_dispatch_as_host(u32 contextID,
+                              struct vmci_datagram *dg)
+{
+       int retval;
+       size_t dgSize;
+       u32 srcPrivFlags;
+
+       ASSERT(dg);
+       ASSERT(vmci_host_code_active());
+
+       dgSize = VMCI_DG_SIZE(dg);
+
+       if (contextID == VMCI_HOST_CONTEXT_ID &&
+           dg->dst.context == VMCI_HYPERVISOR_CONTEXT_ID)
+               return VMCI_ERROR_DST_UNREACHABLE;
+
+       ASSERT(dg->dst.context != VMCI_HYPERVISOR_CONTEXT_ID);
+
+       /* Check that source handle matches sending context. */
+       if (dg->src.context != contextID) {
+               pr_devel("Sender context (ID=0x%x) is not owner of src " \
+                        "datagram entry (handle=0x%x:0x%x).",
+                        contextID, dg->src.context, dg->src.resource);
+               return VMCI_ERROR_NO_ACCESS;
+       }
+
+       /* Get hold of privileges of sending endpoint. */
+       retval = vmci_datagram_get_priv_flags(contextID, dg->src, &srcPrivFlags);
+       if (retval != VMCI_SUCCESS) {
+               pr_warn("Couldn't get privileges (handle=0x%x:0x%x).",
+                       dg->src.context, dg->src.resource);
+               return retval;
+       }
+
+       /* Determine if we should route to host or guest destination. */
+       if (dg->dst.context == VMCI_HOST_CONTEXT_ID) {
+               /* Route to host datagram entry. */
+               struct datagram_entry *dstEntry;
+               struct vmci_resource *resource;
+
+               if (dg->src.context == VMCI_HYPERVISOR_CONTEXT_ID &&
+                   dg->dst.resource == VMCI_EVENT_HANDLER) {
+                       return vmci_event_dispatch(dg);
+               }
+
+               resource = vmci_resource_get(dg->dst,
+                                            VMCI_RESOURCE_TYPE_DATAGRAM);
+               if (resource == NULL) {
+                       pr_devel("Sending to invalid destination " \
+                                "(handle=0x%x:0x%x).", dg->dst.context,
+                                dg->dst.resource);
+                       return VMCI_ERROR_INVALID_RESOURCE;
+               }
+               dstEntry =
+                       container_of(resource, struct datagram_entry,
+                                    resource);
+               if (vmci_deny_interaction(srcPrivFlags, dstEntry->privFlags)) {
+                       vmci_resource_release(resource);
+                       return VMCI_ERROR_NO_ACCESS;
+               }
+               ASSERT(dstEntry->recvCB);
+
+               /*
+                * If a VMCI datagram destined for the host is also sent by the
+                * host, we always run it delayed. This ensures that no locks
+                * are held when the datagram callback runs.
+                */
+               if (dstEntry->runDelayed ||
+                   dg->src.context == VMCI_HOST_CONTEXT_ID) {
+                       struct delayed_datagram_info *dgInfo;
+
+                       if (atomic_add_return(1, &delayedDGHostQueueSize)
+                           == VMCI_MAX_DELAYED_DG_HOST_QUEUE_SIZE) {
+                               atomic_dec(&delayedDGHostQueueSize);
+                               vmci_resource_release(resource);
+                               return VMCI_ERROR_NO_MEM;
+                       }
+
+                       dgInfo =
+                               kmalloc(sizeof(*dgInfo) +
+                                       (size_t) dg->payloadSize, GFP_ATOMIC);
+                       if (NULL == dgInfo) {
+                               atomic_dec(&delayedDGHostQueueSize);
+                               vmci_resource_release(resource);
+                               return VMCI_ERROR_NO_MEM;
+                       }
+
+                       dgInfo->inDGHostQueue = true;
+                       dgInfo->entry = dstEntry;
+                       memcpy(&dgInfo->msg, dg, dgSize);
+                       retval =
+                         vmci_drv_schedule_delayed_work(dg_delayed_dispatch_cb,
+                                                        dgInfo);
+                       if (retval < VMCI_SUCCESS) {
+                               pr_warn("Failed to schedule delayed " \
+                                       "work for datagram (result=%d).",
+                                       retval);
+                               kfree(dgInfo);
+                               vmci_resource_release(resource);
+                               atomic_dec(&delayedDGHostQueueSize);
+                               return retval;
+                       }
+               } else {
+                       retval = dstEntry->recvCB(dstEntry->clientData, dg);
+                       vmci_resource_release(resource);
+                       if (retval < VMCI_SUCCESS)
+                               return retval;
+               }
+       } else {
+               /* Route to destination VM context. */
+               struct vmci_datagram *newDG;
+
+               if (contextID != dg->dst.context) {
+                       if (vmci_deny_interaction(srcPrivFlags,
+                                                 vmci_context_get_priv_flags
+                                                 (dg->dst.context))) {
+                               return VMCI_ERROR_NO_ACCESS;
+                       } else if (VMCI_CONTEXT_IS_VM(contextID)) {
+                               /*
+                                * If the sending context is a VM, it
+                                * cannot reach another VM.
+                                */
+
+                               pr_devel("Datagram communication between VMs " \
+                                        "not supported (src=0x%x, dst=0x%x).",
+                                        contextID, dg->dst.context);
+                               return VMCI_ERROR_DST_UNREACHABLE;
+                       }
+               }
+
+               /* We make a copy to enqueue. */
+               newDG = kmalloc(dgSize, GFP_KERNEL);
+               if (newDG == NULL)
+                       return VMCI_ERROR_NO_MEM;
+
+               memcpy(newDG, dg, dgSize);
+               retval = vmci_ctx_enqueue_datagram(dg->dst.context, newDG);
+               if (retval < VMCI_SUCCESS) {
+                       kfree(newDG);
+                       return retval;
+               }
+       }
+
+       /*
+        * We currently truncate the size to signed 32 bits. This doesn't
+        * matter for this handler as it only support 4Kb messages.
+        */
+       return (int)dgSize;
+}
+
+/*
+ * Dispatch datagram as a guest, down through the VMX and potentially to
+ * the host.
+ * Returns number of bytes sent on success, error code otherwise.
+ */
+static int dg_dispatch_as_guest(struct vmci_datagram *dg)
+{
+       int retval;
+       struct vmci_resource *resource;
+
+       resource = vmci_resource_get(dg->src, VMCI_RESOURCE_TYPE_DATAGRAM);
+       if (NULL == resource)
+               return VMCI_ERROR_NO_HANDLE;
+
+       retval = vmci_send_datagram(dg);
+       vmci_resource_release(resource);
+       return retval;
+}
+
+/*
+ * Dispatch datagram.  This will determine the routing for the datagram
+ * and dispatch it accordingly.
+ * Returns number of bytes sent on success, error code otherwise.
+ */
+int vmci_datagram_dispatch(u32 contextID,
+                    struct vmci_datagram *dg, bool fromGuest)
+{
+       int retval;
+       enum vmci_route route;
+
+       ASSERT(dg);
+       BUILD_BUG_ON(sizeof(struct vmci_datagram) != 24);
+
+       if (VMCI_DG_SIZE(dg) > VMCI_MAX_DG_SIZE) {
+               pr_devel("Payload (size=%llu bytes) too big to " \
+                        "send.", (unsigned long long) dg->payloadSize);
+               return VMCI_ERROR_INVALID_ARGS;
+       }
+
+       retval = vmci_route(&dg->src, &dg->dst, fromGuest, &route);
+       if (retval < VMCI_SUCCESS) {
+               pr_devel("Failed to route datagram (src=0x%x, dst=0x%x, " \
+                        "err=%d).", dg->src.context, dg->dst.context,
+                        retval);
+               return retval;
+       }
+
+       if (VMCI_ROUTE_AS_HOST == route) {
+               if (VMCI_INVALID_ID == contextID)
+                       contextID = VMCI_HOST_CONTEXT_ID;
+               return dg_dispatch_as_host(contextID, dg);
+       }
+
+       if (VMCI_ROUTE_AS_GUEST == route)
+               return dg_dispatch_as_guest(dg);
+
+       pr_warn("Unknown route (%d) for datagram.", route);
+       return VMCI_ERROR_DST_UNREACHABLE;
+}
+
+/*
+ * Invoke the handler for the given datagram.  This is intended to be
+ * called only when acting as a guest and receiving a datagram from the
+ * virtual device.
+ */
+int vmci_datagram_invoke_guest_handler(struct vmci_datagram *dg)
+{
+       int retval;
+       struct vmci_resource *resource;
+       struct datagram_entry *dstEntry;
+
+       ASSERT(dg);
+
+       resource = vmci_resource_get(dg->dst, VMCI_RESOURCE_TYPE_DATAGRAM);
+       if (NULL == resource) {
+               pr_devel("destination (handle=0x%x:0x%x) doesn't exist.",
+                        dg->dst.context, dg->dst.resource);
+               return VMCI_ERROR_NO_HANDLE;
+       }
+
+       dstEntry =
+               container_of(resource, struct datagram_entry, resource);
+       if (dstEntry->runDelayed) {
+               struct delayed_datagram_info *dgInfo;
+
+               dgInfo =
+                       kmalloc(sizeof(*dgInfo) + (size_t) dg->payloadSize,
+                               GFP_ATOMIC);
+               if (NULL == dgInfo) {
+                       vmci_resource_release(resource);
+                       retval = VMCI_ERROR_NO_MEM;
+                       goto exit;
+               }
+
+               dgInfo->inDGHostQueue = false;
+               dgInfo->entry = dstEntry;
+               memcpy(&dgInfo->msg, dg, VMCI_DG_SIZE(dg));
+
+               retval =
+                       vmci_drv_schedule_delayed_work(dg_delayed_dispatch_cb,
+                                                      dgInfo);
+               if (retval < VMCI_SUCCESS) {
+                       pr_warn("Failed to schedule delayed work for " \
+                               "datagram (result=%d).", retval);
+                       kfree(dgInfo);
+                       vmci_resource_release(resource);
+                       dgInfo = NULL;
+                       goto exit;
+               }
+       } else {
+               dstEntry->recvCB(dstEntry->clientData, dg);
+               vmci_resource_release(resource);
+               retval = VMCI_SUCCESS;
+       }
+
+exit:
+       return retval;
+}
+
+/**
+ * vmci_datagram_create_handle_priv() - Create host context datagram endpoint
+ * @resource_id:       The resource ID.
+ * @flags:     Datagram Flags.
+ * @priv_flags:        Privilege Flags.
+ * @recv_cb:   Callback when receiving datagrams.
+ * @client_data:       Pointer for a datagram_entry struct
+ * @out_handle:        vmci_handle that is populated as a result of this function.
+ *
+ * Creates a host context datagram endpoint and returns a handle to it.
+ */
+int vmci_datagram_create_handle_priv(u32 resource_id,
+                                    u32 flags,
+                                    u32 priv_flags,
+                                    vmci_datagram_recv_cb recv_cb,
+                                    void *client_data,
+                                    struct vmci_handle *out_handle)
+{
+       if (out_handle == NULL)
+               return VMCI_ERROR_INVALID_ARGS;
+
+       if (recv_cb == NULL) {
+               pr_devel("Client callback needed when creating " \
+                        "datagram.");
+               return VMCI_ERROR_INVALID_ARGS;
+       }
+
+       if (priv_flags & ~VMCI_PRIVILEGE_ALL_FLAGS)
+               return VMCI_ERROR_INVALID_ARGS;
+
+       return dg_create_handle(resource_id, flags, priv_flags, recv_cb,
+                               client_data, out_handle);
+}
+EXPORT_SYMBOL(vmci_datagram_create_handle_priv);
+
+/**
+ * vmci_datagram_create_handle() - Create host context datagram endpoint
+ * @resource_id:       Resource ID.
+ * @flags:     Datagram Flags.
+ * @recv_cb:   Callback when receiving datagrams.
+ * @client_ata:        Pointer for a datagram_entry struct
+ * @out_handle:        vmci_handle that is populated as a result of this function.
+ *
+ * Creates a host context datagram endpoint and returns a handle to
+ * it.  Same as vmci_datagram_create_handle_priv without the priviledge
+ * flags argument.
+ */
+int vmci_datagram_create_handle(u32 resource_id,
+                               u32 flags,
+                               vmci_datagram_recv_cb recv_cb,
+                               void *client_data,
+                               struct vmci_handle *out_handle)
+{
+       return vmci_datagram_create_handle_priv(resource_id, flags,
+                              VMCI_DEFAULT_PROC_PRIVILEGE_FLAGS,
+                              recv_cb, client_data, out_handle);
+}
+EXPORT_SYMBOL(vmci_datagram_create_handle);
+
+/**
+ * vmci_datagram_destroy_handle() - Destroys datagram handle
+ * @handle:    vmci_handle to be destroyed and reaped.
+ *
+ * Use this function to destroy any datagram handles created by
+ * vmci_datagram_create_handle{,Priv} functions.
+ */
+int vmci_datagram_destroy_handle(struct vmci_handle handle)
+{
+       struct datagram_entry *entry;
+       struct vmci_resource *resource;
+
+       resource = vmci_resource_get(handle, VMCI_RESOURCE_TYPE_DATAGRAM);
+       if (resource == NULL) {
+               pr_devel("Failed to destroy datagram (handle=0x%x:0x%x)" \
+                        ".", handle.context, handle.resource);
+               return VMCI_ERROR_NOT_FOUND;
+       }
+
+       entry = container_of(resource, struct datagram_entry, resource);
+       vmci_resource_remove(handle, VMCI_RESOURCE_TYPE_DATAGRAM);
+
+       /*
+        * We now wait on the destroyEvent and release the reference we got
+        * above.
+        */
+       vmci_drv_wait_on_event_intr(&entry->destroyEvent, dg_release_cb,
+                                   entry);
+       kfree(entry);
+
+       return VMCI_SUCCESS;
+}
+EXPORT_SYMBOL(vmci_datagram_destroy_handle);
+
+/**
+ * vmci_datagram_send() - Send a datagram
+ * @msg:       The datagram to send.
+ *
+ * Sends the provided datagram on its merry way.
+ */
+int vmci_datagram_send(struct vmci_datagram *msg)
+{
+       if (msg == NULL)
+               return VMCI_ERROR_INVALID_ARGS;
+
+       return vmci_datagram_dispatch(VMCI_INVALID_ID, msg, false);
+}
+EXPORT_SYMBOL(vmci_datagram_send);
diff --git a/drivers/misc/vmw_vmci/vmci_datagram.h b/drivers/misc/vmw_vmci/vmci_datagram.h
new file mode 100644
index 0000000..d88fe7d
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
+       struct list_head listItem;      /* For queuing. */
+       size_t dgSize;          /* Size of datagram. */
+       struct vmci_datagram *dg;       /* Pending datagram. */
+};
+
+/* VMCIDatagramSendRecvInfo */
+struct vmci_datagram_snd_rcv_info {
+       uint64_t addr;
+       uint32_t len;
+       int32_t result;
+};
+
+/* Init functions. */
+int vmci_datagram_init(void);
+
+/* Datagram API for non-public use. */
+int vmci_datagram_dispatch(uint32_t contextID, struct vmci_datagram *dg,
+                          bool fromGuest);
+int vmci_datagram_invoke_guest_handler(struct vmci_datagram *dg);
+
+#endif /* _VMCI_DATAGRAM_H_ */

