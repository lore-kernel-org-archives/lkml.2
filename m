Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761499Ab2BOBRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 20:17:17 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:43548 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761446Ab2BOBOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 20:14:06 -0500
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: vm-crosstalk@vmware.com, dtor@vmware.com, cschamp@vmware.com,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [PATCH 02/14] Add vmciDatagram.*
Date: Tue, 14 Feb 2012 17:05:43 -0800
Message-Id: <1329267955-32367-3-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
References: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/misc/vmw_vmci/vmciDatagram.c |  842 ++++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmciDatagram.h |   42 ++
 2 files changed, 884 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmciDatagram.c
 create mode 100644 drivers/misc/vmw_vmci/vmciDatagram.h

diff --git a/drivers/misc/vmw_vmci/vmciDatagram.c b/drivers/misc/vmw_vmci/vmciDatagram.c
new file mode 100644
index 0000000..e8a95de
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciDatagram.c
@@ -0,0 +1,842 @@
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
+#include <linux/module.h>
+#include <linux/sched.h>
+
+#include "vmci_defs.h"
+#include "vmci_infrastructure.h"
+#include "vmci_kernel_if.h"
+#include "vmciCommonInt.h"
+#include "vmciContext.h"
+#include "vmciDatagram.h"
+#include "vmciDriver.h"
+#include "vmciEvent.h"
+#include "vmciHashtable.h"
+#include "vmciKernelAPI.h"
+#include "vmciResource.h"
+#include "vmciRoute.h"
+
+#define LGPFX "VMCIDatagram: "
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
+	struct vmci_datagram msg;
+};
+
+static atomic_t delayedDGHostQueueSize;
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  DatagramFreeCB --
+ *     Callback to free datagram structure when resource is no longer used,
+ *     ie. the reference count reached 0.
+ *
+ *  Result:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static void DatagramFreeCB(void *clientData)
+{
+	struct datagram_entry *entry = (struct datagram_entry *)clientData;
+	ASSERT(entry);
+	/* Entry is freed in VMCIDatagram_DestroyHnd, who waits for the signal */
+	wake_up(&entry->destroyEvent);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  DatagramReleaseCB --
+ *
+ *     Callback to release the resource reference. It is called by the
+ *     VMCI_WaitOnEvent function before it blocks.
+ *
+ *  Result:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static int DatagramReleaseCB(void *clientData)
+{
+	struct datagram_entry *entry = (struct datagram_entry *)clientData;
+	ASSERT(entry);
+	VMCIResource_Release(&entry->resource);
+	return 0;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * DatagramCreateHnd --
+ *
+ *      Internal function to create a datagram entry given a handle.
+ *
+ * Results:
+ *      VMCI_SUCCESS if created, negative errno value otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static int DatagramCreateHnd(uint32_t resourceID,	// IN:
+			     uint32_t flags,	// IN:
+			     uint32_t privFlags,	// IN:
+			     VMCIDatagramRecvCB recvCB,	// IN:
+			     void *clientData,	// IN:
+			     struct vmci_handle *outHandle)	// OUT:
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
+			if (contextID == VMCI_INVALID_ID) {
+				return VMCI_ERROR_NO_RESOURCES;
+			}
+		}
+
+		if (resourceID == VMCI_INVALID_ID) {
+			resourceID = VMCIResource_GetID(contextID);
+			if (resourceID == VMCI_INVALID_ID) {
+				return VMCI_ERROR_NO_HANDLE;
+			}
+		}
+
+		handle = VMCI_MAKE_HANDLE(contextID, resourceID);
+	}
+
+	entry = kmalloc(sizeof *entry, GFP_KERNEL);
+	if (entry == NULL) {
+		VMCI_WARNING((LGPFX
+			      "Failed allocating memory for datagram entry.\n"));
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
+	result =
+	    VMCIResource_Add(&entry->resource, VMCI_RESOURCE_TYPE_DATAGRAM,
+			     handle, DatagramFreeCB, entry);
+	if (result != VMCI_SUCCESS) {
+		VMCI_WARNING((LGPFX
+			      "Failed to add new resource (handle=0x%x:0x%x).\n",
+			      handle.context, handle.resource));
+		kfree(entry);
+		return result;
+	}
+	*outHandle = handle;
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  VMCIDatagram_Init --
+ *
+ *     Initialize Datagram API, ie. register the API functions with their
+ *     corresponding vectors.
+ *
+ *  Result:
+ *     None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int VMCIDatagram_Init(void)
+{
+	atomic_set(&delayedDGHostQueueSize, 0);
+	return VMCI_SUCCESS;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDatagram_CreateHnd --
+ *
+ *      Creates a host context datagram endpoint and returns a handle to it.
+ *
+ * Results:
+ *      VMCI_SUCCESS if created, negative errno value otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int VMCIDatagram_CreateHnd(uint32_t resourceID,	// IN: Optional, generated
+			   //     if VMCI_INVALID_ID
+			   uint32_t flags,	// IN:
+			   VMCIDatagramRecvCB recvCB,	// IN:
+			   void *clientData,	// IN:
+			   struct vmci_handle *outHandle)	// OUT: newly created handle
+{
+	if (outHandle == NULL)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	if (recvCB == NULL) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Client callback needed when creating datagram.\n"));
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	return DatagramCreateHnd(resourceID, flags,
+				 VMCI_DEFAULT_PROC_PRIVILEGE_FLAGS, recvCB,
+				 clientData, outHandle);
+}
+
+EXPORT_SYMBOL(VMCIDatagram_CreateHnd);
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDatagram_CreateHndPriv --
+ *
+ *      Creates a host context datagram endpoint and returns a handle to it.
+ *
+ * Results:
+ *      VMCI_SUCCESS if created, negative errno value otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int VMCIDatagram_CreateHndPriv(uint32_t resourceID,	// IN: Optional, generated
+			       //     if VMCI_INVALID_ID
+			       uint32_t flags,	// IN:
+			       uint32_t privFlags,	// IN:
+			       VMCIDatagramRecvCB recvCB,	// IN:
+			       void *clientData,	// IN:
+			       struct vmci_handle *outHandle)	// OUT: newly created handle
+{
+	if (outHandle == NULL) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	if (recvCB == NULL) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Client callback needed when creating datagram.\n"));
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	if (privFlags & ~VMCI_PRIVILEGE_ALL_FLAGS) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	return DatagramCreateHnd(resourceID, flags, privFlags, recvCB,
+				 clientData, outHandle);
+}
+
+EXPORT_SYMBOL(VMCIDatagram_CreateHndPriv);
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDatagram_DestroyHnd --
+ *
+ *      Destroys a handle.
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
+int VMCIDatagram_DestroyHnd(struct vmci_handle handle)	// IN
+{
+	struct datagram_entry *entry;
+	struct vmci_resource *resource = VMCIResource_Get(handle,
+							  VMCI_RESOURCE_TYPE_DATAGRAM);
+	if (resource == NULL) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Failed to destroy datagram (handle=0x%x:0x%x).\n",
+				handle.context, handle.resource));
+		return VMCI_ERROR_NOT_FOUND;
+	}
+	entry = RESOURCE_CONTAINER(resource, struct datagram_entry, resource);
+
+	VMCIResource_Remove(handle, VMCI_RESOURCE_TYPE_DATAGRAM);
+
+	/*
+	 * We now wait on the destroyEvent and release the reference we got
+	 * above.
+	 */
+	VMCI_WaitOnEvent(&entry->destroyEvent, DatagramReleaseCB, entry);
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
+EXPORT_SYMBOL(VMCIDatagram_DestroyHnd);
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  VMCIDatagramGetPrivFlagsInt --
+ *
+ *     Internal utilility function with the same purpose as
+ *     VMCIDatagram_GetPrivFlags that also takes a contextID.
+ *
+ *  Result:
+ *     VMCI_SUCCESS on success, VMCI_ERROR_INVALID_ARGS if handle is invalid.
+ *
+ *  Side effects:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static int VMCIDatagramGetPrivFlagsInt(uint32_t contextID,	// IN
+				       struct vmci_handle handle,	// IN
+				       uint32_t * privFlags)	// OUT
+{
+	ASSERT(privFlags);
+	ASSERT(contextID != VMCI_INVALID_ID);
+
+	if (contextID == VMCI_HOST_CONTEXT_ID) {
+		struct datagram_entry *srcEntry;
+		struct vmci_resource *resource;
+
+		resource =
+		    VMCIResource_Get(handle, VMCI_RESOURCE_TYPE_DATAGRAM);
+		if (resource == NULL) {
+			return VMCI_ERROR_INVALID_ARGS;
+		}
+		srcEntry =
+		    RESOURCE_CONTAINER(resource, struct datagram_entry,
+				       resource);
+		*privFlags = srcEntry->privFlags;
+		VMCIResource_Release(resource);
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
+ *------------------------------------------------------------------------------
+ *
+ *  VMCIDatagram_GetPrivFlags --
+ *
+ *     Utilility function that retrieves the privilege flags
+ *     associated with a given datagram handle. For hypervisor and
+ *     guest endpoints, the privileges are determined by the context
+ *     ID, but for host endpoints privileges are associated with the
+ *     complete handle.
+ *
+ *  Result:
+ *     VMCI_SUCCESS on success, VMCI_ERROR_INVALID_ARGS if handle is invalid.
+ *
+ *  Side effects:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int VMCIDatagram_GetPrivFlags(struct vmci_handle handle,	// IN
+			      uint32_t * privFlags)	// OUT
+{
+	if (privFlags == NULL || handle.context == VMCI_INVALID_ID)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	return VMCIDatagramGetPrivFlagsInt(handle.context, handle, privFlags);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIDatagramDelayedDispatchCB --
+ *
+ *      Calls the specified callback in a delayed context.
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
+static void VMCIDatagramDelayedDispatchCB(void *data)	// IN
+{
+	bool inDGHostQueue;
+	struct delayed_datagram_info *dgInfo =
+	    (struct delayed_datagram_info *)data;
+
+	ASSERT(data);
+
+	dgInfo->entry->recvCB(dgInfo->entry->clientData, &dgInfo->msg);
+
+	VMCIResource_Release(&dgInfo->entry->resource);
+
+	inDGHostQueue = dgInfo->inDGHostQueue;
+	kfree(dgInfo);
+
+	if (inDGHostQueue)
+		atomic_dec(&delayedDGHostQueueSize);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  VMCIDatagramDispatchAsHost --
+ *
+ *     Dispatch datagram as a host, to the host or other vm context. This
+ *     function cannot dispatch to hypervisor context handlers. This should
+ *     have been handled before we get here by VMCIDatagramDispatch.
+ *
+ *  Result:
+ *     Number of bytes sent on success, appropriate error code otherwise.
+ *
+ *  Side effects:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static int VMCIDatagramDispatchAsHost(uint32_t contextID,	// IN:
+				      struct vmci_datagram *dg)	// IN:
+{
+	int retval;
+	size_t dgSize;
+	uint32_t srcPrivFlags;
+
+	ASSERT(dg);
+	ASSERT(VMCI_HostPersonalityActive());
+
+	dgSize = VMCI_DG_SIZE(dg);
+
+	if (contextID == VMCI_HOST_CONTEXT_ID &&
+	    dg->dst.context == VMCI_HYPERVISOR_CONTEXT_ID) {
+		return VMCI_ERROR_DST_UNREACHABLE;
+	}
+
+	ASSERT(dg->dst.context != VMCI_HYPERVISOR_CONTEXT_ID);
+
+	/* Check that source handle matches sending context. */
+	if (dg->src.context != contextID) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Sender context (ID=0x%x) is not owner of src "
+				"datagram entry (handle=0x%x:0x%x).\n",
+				contextID, dg->src.context, dg->src.resource));
+		return VMCI_ERROR_NO_ACCESS;
+	}
+
+	/* Get hold of privileges of sending endpoint. */
+	retval = VMCIDatagramGetPrivFlagsInt(contextID, dg->src, &srcPrivFlags);
+	if (retval != VMCI_SUCCESS) {
+		VMCI_WARNING((LGPFX
+			      "Couldn't get privileges (handle=0x%x:0x%x).\n",
+			      dg->src.context, dg->src.resource));
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
+			return VMCIEvent_Dispatch(dg);
+		}
+
+		resource =
+		    VMCIResource_Get(dg->dst, VMCI_RESOURCE_TYPE_DATAGRAM);
+		if (resource == NULL) {
+			VMCI_DEBUG_LOG(4,
+				       (LGPFX
+					"Sending to invalid destination "
+					"(handle=0x%x:0x%x).\n",
+					dg->dst.context, dg->dst.resource));
+			return VMCI_ERROR_INVALID_RESOURCE;
+		}
+		dstEntry =
+		    RESOURCE_CONTAINER(resource, struct datagram_entry,
+				       resource);
+		if (VMCIDenyInteraction(srcPrivFlags, dstEntry->privFlags)) {
+			VMCIResource_Release(resource);
+			return VMCI_ERROR_NO_ACCESS;
+		}
+		ASSERT(dstEntry->recvCB);
+
+		/*
+		 * If a VMCI datagram destined for the host is also sent by the
+		 * host, we always run it delayed. This ensures that no locks
+		 * are held when the datagram callback runs.
+		 */
+
+		if (dstEntry->runDelayed
+		    || dg->src.context == VMCI_HOST_CONTEXT_ID) {
+			struct delayed_datagram_info *dgInfo;
+
+			if (atomic_add_return(1, &delayedDGHostQueueSize)
+			    == VMCI_MAX_DELAYED_DG_HOST_QUEUE_SIZE) {
+				atomic_dec(&delayedDGHostQueueSize);
+				VMCIResource_Release(resource);
+				return VMCI_ERROR_NO_MEM;
+			}
+
+			dgInfo =
+			    kmalloc(sizeof *dgInfo +
+				    (size_t) dg->payloadSize, GFP_ATOMIC);
+			if (NULL == dgInfo) {
+				atomic_dec(&delayedDGHostQueueSize);
+				VMCIResource_Release(resource);
+				return VMCI_ERROR_NO_MEM;
+			}
+
+			dgInfo->inDGHostQueue = true;
+			dgInfo->entry = dstEntry;
+			memcpy(&dgInfo->msg, dg, dgSize);
+
+			retval =
+			    VMCI_ScheduleDelayedWork
+			    (VMCIDatagramDelayedDispatchCB, dgInfo);
+			if (retval < VMCI_SUCCESS) {
+				VMCI_WARNING((LGPFX
+					      "Failed to schedule delayed work for datagram "
+					      "(result=%d).\n", retval));
+				kfree(dgInfo);
+				VMCIResource_Release(resource);
+				atomic_dec(&delayedDGHostQueueSize);
+				return retval;
+			}
+		} else {
+			retval = dstEntry->recvCB(dstEntry->clientData, dg);
+			VMCIResource_Release(resource);
+			if (retval < VMCI_SUCCESS) {
+				return retval;
+			}
+		}
+	} else {
+		/* Route to destination VM context. */
+		struct vmci_datagram *newDG;
+
+		if (contextID != dg->dst.context) {
+			if (VMCIDenyInteraction(srcPrivFlags,
+						VMCIContext_GetPrivFlags
+						(dg->dst.context))) {
+				return VMCI_ERROR_NO_ACCESS;
+			} else if (VMCI_CONTEXT_IS_VM(contextID)) {
+				/* If the sending context is a VM, it cannot reach another VM. */
+
+				VMCI_DEBUG_LOG(4,
+					       (LGPFX
+						"Datagram communication between VMs not"
+						"supported (src=0x%x, dst=0x%x).\n",
+						contextID, dg->dst.context));
+				return VMCI_ERROR_DST_UNREACHABLE;
+			}
+		}
+
+		/* We make a copy to enqueue. */
+		newDG = kmalloc(dgSize, GFP_KERNEL);
+		if (newDG == NULL) {
+			return VMCI_ERROR_NO_MEM;
+		}
+		memcpy(newDG, dg, dgSize);
+		retval = VMCIContext_EnqueueDatagram(dg->dst.context, newDG);
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
+ *------------------------------------------------------------------------------
+ *
+ *  VMCIDatagramDispatchAsGuest --
+ *
+ *     Dispatch datagram as a guest, down through the VMX and potentially to
+ *     the host.
+ *
+ *  Result:
+ *     Number of bytes sent on success, appropriate error code otherwise.
+ *
+ *  Side effects:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static int VMCIDatagramDispatchAsGuest(struct vmci_datagram *dg)
+{
+	int retval;
+	struct vmci_resource *resource;
+
+	resource = VMCIResource_Get(dg->src, VMCI_RESOURCE_TYPE_DATAGRAM);
+	if (NULL == resource) {
+		return VMCI_ERROR_NO_HANDLE;
+	}
+
+	retval = VMCI_SendDatagram(dg);
+	VMCIResource_Release(resource);
+	return retval;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  VMCIDatagram_Dispatch --
+ *
+ *     Dispatch datagram.  This will determine the routing for the datagram
+ *     and dispatch it accordingly.
+ *
+ *  Result:
+ *     Number of bytes sent on success, appropriate error code otherwise.
+ *
+ *  Side effects:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int
+VMCIDatagram_Dispatch(uint32_t contextID,
+		      struct vmci_datagram *dg, bool fromGuest)
+{
+	int retval;
+	enum vmci_route route;
+
+	ASSERT(dg);
+	ASSERT_ON_COMPILE(sizeof(struct vmci_datagram) == 24);
+
+	if (VMCI_DG_SIZE(dg) > VMCI_MAX_DG_SIZE) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX "Payload (size=%" FMT64
+				"u bytes) too big to " "send.\n",
+				dg->payloadSize));
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	retval = VMCI_Route(&dg->src, &dg->dst, fromGuest, &route);
+	if (retval < VMCI_SUCCESS) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Failed to route datagram (src=0x%x, dst=0x%x, "
+				"err=%d)\n.", dg->src.context,
+				dg->dst.context, retval));
+		return retval;
+	}
+
+	if (VMCI_ROUTE_AS_HOST == route) {
+		if (VMCI_INVALID_ID == contextID)
+			contextID = VMCI_HOST_CONTEXT_ID;
+		return VMCIDatagramDispatchAsHost(contextID, dg);
+	}
+
+	if (VMCI_ROUTE_AS_GUEST == route)
+		return VMCIDatagramDispatchAsGuest(dg);
+
+	VMCI_WARNING((LGPFX "Unknown route (%d) for datagram.\n", route));
+	return VMCI_ERROR_DST_UNREACHABLE;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  VMCIDatagram_InvokeGuestHandler --
+ *
+ *     Invoke the handler for the given datagram.  This is intended to be
+ *     called only when acting as a guest and receiving a datagram from the
+ *     virtual device.
+ *
+ *  Result:
+ *     VMCI_SUCCESS on success, other error values on failure.
+ *
+ *  Side effects:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int VMCIDatagram_InvokeGuestHandler(struct vmci_datagram *dg)	// IN
+{
+	int retval;
+	struct vmci_resource *resource;
+	struct datagram_entry *dstEntry;
+
+	ASSERT(dg);
+
+	resource = VMCIResource_Get(dg->dst, VMCI_RESOURCE_TYPE_DATAGRAM);
+	if (NULL == resource) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"destination (handle=0x%x:0x%x) doesn't exist.\n",
+				dg->dst.context, dg->dst.resource));
+		return VMCI_ERROR_NO_HANDLE;
+	}
+
+	dstEntry =
+	    RESOURCE_CONTAINER(resource, struct datagram_entry, resource);
+	if (dstEntry->runDelayed) {
+		struct delayed_datagram_info *dgInfo;
+
+		dgInfo =
+		    kmalloc(sizeof *dgInfo + (size_t) dg->payloadSize,
+			    GFP_ATOMIC);
+		if (NULL == dgInfo) {
+			VMCIResource_Release(resource);
+			retval = VMCI_ERROR_NO_MEM;
+			goto exit;
+		}
+
+		dgInfo->inDGHostQueue = false;
+		dgInfo->entry = dstEntry;
+		memcpy(&dgInfo->msg, dg, VMCI_DG_SIZE(dg));
+
+		retval =
+		    VMCI_ScheduleDelayedWork(VMCIDatagramDelayedDispatchCB,
+					     dgInfo);
+		if (retval < VMCI_SUCCESS) {
+			VMCI_WARNING((LGPFX
+				      "Failed to schedule delayed work for datagram "
+				      "(result=%d).\n", retval));
+			kfree(dgInfo);
+			VMCIResource_Release(resource);
+			dgInfo = NULL;
+			goto exit;
+		}
+	} else {
+		dstEntry->recvCB(dstEntry->clientData, dg);
+		VMCIResource_Release(resource);
+		retval = VMCI_SUCCESS;
+	}
+
+ exit:
+	return retval;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIDatagram_Send --
+ *
+ *      Sends the payload to the destination datagram handle.
+ *
+ * Results:
+ *      Returns number of bytes sent if success, or error code if failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int VMCIDatagram_Send(struct vmci_datagram *msg)	// IN
+{
+	if (msg == NULL)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	return VMCIDatagram_Dispatch(VMCI_INVALID_ID, msg, false);
+}
+
+EXPORT_SYMBOL(VMCIDatagram_Send);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIDatagram_Sync --
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
+ *-----------------------------------------------------------------------------
+ */
+
+void VMCIDatagram_Sync(void)
+{
+	VMCIResource_Sync();
+}
diff --git a/drivers/misc/vmw_vmci/vmciDatagram.h b/drivers/misc/vmw_vmci/vmciDatagram.h
new file mode 100644
index 0000000..9ae003e
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciDatagram.h
@@ -0,0 +1,42 @@
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
+#ifndef _VMCI_DATAGRAM_H_
+#define _VMCI_DATAGRAM_H_
+
+#include "vmci_call_defs.h"
+#include "vmci_iocontrols.h"
+#include "vmciContext.h"
+
+#define VMCI_MAX_DELAYED_DG_HOST_QUEUE_SIZE 256
+
+/* Init functions. */
+int VMCIDatagram_Init(void);
+
+/* Datagram API for non-public use. */
+int VMCIDatagram_Dispatch(uint32_t contextID, struct vmci_datagram *dg,
+			  bool fromGuest);
+int VMCIDatagram_InvokeGuestHandler(struct vmci_datagram *dg);
+int VMCIDatagram_GetPrivFlags(struct vmci_handle handle, uint32_t * privFlags);
+
+/* Misc. */
+void VMCIDatagram_Sync(void);
+
+#endif				// _VMCI_DATAGRAM_H_
-- 
1.7.0.4

