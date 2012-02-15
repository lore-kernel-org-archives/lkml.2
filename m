Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761545Ab2BOBPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 20:15:52 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:52333 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761439Ab2BOBOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 20:14:45 -0500
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: vm-crosstalk@vmware.com, dtor@vmware.com, cschamp@vmware.com,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [PATCH 08/14] Add vmciResource.*
Date: Tue, 14 Feb 2012 17:05:49 -0800
Message-Id: <1329267955-32367-9-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
References: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/misc/vmw_vmci/vmciResource.c |  383 ++++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmciResource.h |   68 ++++++
 2 files changed, 451 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmciResource.c
 create mode 100644 drivers/misc/vmw_vmci/vmciResource.h

diff --git a/drivers/misc/vmw_vmci/vmciResource.c b/drivers/misc/vmw_vmci/vmciResource.c
new file mode 100644
index 0000000..f4a3710
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciResource.c
@@ -0,0 +1,383 @@
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
+#include "vmci_defs.h"
+#include "vmci_infrastructure.h"
+#include "vmci_kernel_if.h"
+#include "vmciCommonInt.h"
+#include "vmciHashtable.h"
+#include "vmciResource.h"
+#include "vmciDriver.h"
+
+#define LGPFX "VMCIResource: "
+
+/* 0 through VMCI_RESERVED_RESOURCE_ID_MAX are reserved. */
+static uint32_t resourceID = VMCI_RESERVED_RESOURCE_ID_MAX + 1;
+static spinlock_t resourceIdLock;
+static struct vmci_hash_table *resourceTable = NULL;
+
+/* Public Resource Access Control API. */
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIResource_Init --
+ *
+ *      Initializes the VMCI Resource Access Control API. Creates a hashtable
+ *      to hold all resources, and registers vectors and callbacks for
+ *      hypercalls.
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
+int VMCIResource_Init(void)
+{
+	spin_lock_init(&resourceIdLock);
+
+	resourceTable = VMCIHashTable_Create(128);
+	if (resourceTable == NULL) {
+		VMCI_WARNING((LGPFX
+			      "Failed creating a resource hash table for VMCI.\n"));
+		return VMCI_ERROR_NO_MEM;
+	}
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIResource_Exit --
+ *
+ *      Cleans up resources.
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
+void VMCIResource_Exit(void)
+{
+	if (resourceTable)
+		VMCIHashTable_Destroy(resourceTable);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  VMCIResource_GetID --
+ *
+ *     Return resource ID. The first VMCI_RESERVED_RESOURCE_ID_MAX are
+ *     reserved so we start from its value + 1.
+ *
+ *  Result:
+ *     VMCI resource id on success, VMCI_INVALID_ID on failure.
+ *
+ *  Side effects:
+ *     None.
+ *
+ *
+ *------------------------------------------------------------------------------
+ */
+
+uint32_t VMCIResource_GetID(uint32_t contextID)
+{
+	uint32_t oldRID = resourceID;
+	uint32_t currentRID;
+	bool foundRID = false;
+
+	/*
+	 * Generate a unique resource ID.  Keep on trying until we wrap around
+	 * in the RID space.
+	 */
+	ASSERT(oldRID > VMCI_RESERVED_RESOURCE_ID_MAX);
+
+	do {
+		struct vmci_handle handle;
+
+		spin_lock(&resourceIdLock);
+		currentRID = resourceID;
+		handle = VMCI_MAKE_HANDLE(contextID, currentRID);
+		resourceID++;
+		if (unlikely(resourceID == VMCI_INVALID_ID)) {
+			/*
+			 * Skip the reserved rids.
+			 */
+
+			resourceID = VMCI_RESERVED_RESOURCE_ID_MAX + 1;
+		}
+		spin_unlock(&resourceIdLock);
+		foundRID = !VMCIHashTable_EntryExists(resourceTable, handle);
+	} while (!foundRID && resourceID != oldRID);
+
+	if (unlikely(!foundRID)) {
+		return VMCI_INVALID_ID;
+	} else {
+		return currentRID;
+	}
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIResource_Add --
+ *
+ * Results:
+ *      VMCI_SUCCESS if successful, error code if not.
+ *
+ * Side effects:
+ *      None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int VMCIResource_Add(struct vmci_resource *resource,	// IN
+		     enum vmci_resource_type resourceType,	// IN
+		     struct vmci_handle resourceHandle,	// IN
+		     VMCIResourceFreeCB containerFreeCB,	// IN
+		     void *containerObject)	// IN
+{
+	int result;
+
+	ASSERT(resource);
+
+	if (VMCI_HANDLE_EQUAL(resourceHandle, VMCI_INVALID_HANDLE)) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Invalid argument resource (handle=0x%x:0x%x).\n",
+				resourceHandle.context,
+				resourceHandle.resource));
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	VMCIHashTable_InitEntry(&resource->hashEntry, resourceHandle);
+	resource->type = resourceType;
+	resource->containerFreeCB = containerFreeCB;
+	resource->containerObject = containerObject;
+
+	/* Add resource to hashtable. */
+	result = VMCIHashTable_AddEntry(resourceTable, &resource->hashEntry);
+	if (result != VMCI_SUCCESS) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX "Failed to add entry to hash table "
+				"(result=%d).\n", result));
+		return result;
+	}
+
+	return result;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIResource_Remove --
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
+void VMCIResource_Remove(struct vmci_handle resourceHandle,	// IN:
+			 enum vmci_resource_type resourceType)	// IN:
+{
+	struct vmci_resource *resource =
+	    VMCIResource_Get(resourceHandle, resourceType);
+	if (resource == NULL)
+		return;
+
+	/* Remove resource from hashtable. */
+	VMCIHashTable_RemoveEntry(resourceTable, &resource->hashEntry);
+
+	VMCIResource_Release(resource);
+	/* resource could be freed by now. */
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIResource_Get --
+ *
+ * Results:
+ *      Resource is successful. Otherwise NULL.
+ *
+ * Side effects:
+ *      None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+struct vmci_resource *VMCIResource_Get(struct vmci_handle resourceHandle,	// IN
+				       enum vmci_resource_type resourceType)	// IN
+{
+	struct vmci_resource *resource;
+	struct vmci_hash_entry *entry =
+	    VMCIHashTable_GetEntry(resourceTable, resourceHandle);
+	if (entry == NULL) {
+		return NULL;
+	}
+	resource = RESOURCE_CONTAINER(entry, struct vmci_resource, hashEntry);
+	if (resourceType == VMCI_RESOURCE_TYPE_ANY
+	    || resource->type == resourceType) {
+		return resource;
+	}
+	VMCIHashTable_ReleaseEntry(resourceTable, entry);
+	return NULL;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIResource_Hold --
+ *
+ *      Hold the given resource.  This will hold the hashtable entry.  This
+ *      is like doing a Get() but without having to lookup the resource by
+ *      handle.
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
+void VMCIResource_Hold(struct vmci_resource *resource)
+{
+	ASSERT(resource);
+	VMCIHashTable_HoldEntry(resourceTable, &resource->hashEntry);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIResourceDoRemove --
+ *
+ *      Deallocates data structures associated with the given resource
+ *      and invoke any call back registered for the resource.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      May deallocate memory and invoke a callback for the removed resource.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static void inline VMCIResourceDoRemove(struct vmci_resource *resource)
+{
+	ASSERT(resource);
+
+	if (resource->containerFreeCB) {
+		resource->containerFreeCB(resource->containerObject);
+		/* Resource has been freed don't dereference it. */
+	}
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIResource_Release --
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      resource's containerFreeCB will get called if last reference.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int VMCIResource_Release(struct vmci_resource *resource)
+{
+	int result;
+
+	ASSERT(resource);
+
+	result =
+	    VMCIHashTable_ReleaseEntry(resourceTable, &resource->hashEntry);
+	if (result == VMCI_SUCCESS_ENTRY_DEAD)
+		VMCIResourceDoRemove(resource);
+
+	/*
+	 * We propagate the information back to caller in case it wants to know
+	 * whether entry was freed.
+	 */
+	return result;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIResource_Handle --
+ *
+ *      Get the handle for the given resource.
+ *
+ * Results:
+ *      The resource's associated handle.
+ *
+ * Side effects:
+ *      None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+struct vmci_handle VMCIResource_Handle(struct vmci_resource *resource)
+{
+	ASSERT(resource);
+	return resource->hashEntry.handle;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ * VMCIResource_Sync --
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
+void VMCIResource_Sync(void)
+{
+	VMCIHashTable_Sync(resourceTable);
+}
diff --git a/drivers/misc/vmw_vmci/vmciResource.h b/drivers/misc/vmw_vmci/vmciResource.h
new file mode 100644
index 0000000..1c5d5f6
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciResource.h
@@ -0,0 +1,68 @@
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
+#ifndef _VMCI_RESOURCE_H_
+#define _VMCI_RESOURCE_H_
+
+#include "vmci_defs.h"
+#include "vmci_kernel_if.h"
+#include "vmciHashtable.h"
+#include "vmciContext.h"
+
+#define RESOURCE_CONTAINER(ptr, type, member)			\
+	((type *)((char *)(ptr) - offsetof(type, member)))
+
+typedef void (*VMCIResourceFreeCB) (void *resource);
+
+enum vmci_resource_type {
+	VMCI_RESOURCE_TYPE_ANY,
+	VMCI_RESOURCE_TYPE_API,
+	VMCI_RESOURCE_TYPE_GROUP,
+	VMCI_RESOURCE_TYPE_DATAGRAM,
+	VMCI_RESOURCE_TYPE_DOORBELL,
+};
+
+struct vmci_resource {
+	struct vmci_hash_entry hashEntry;
+	enum vmci_resource_type type;
+	VMCIResourceFreeCB containerFreeCB;	// Callback to free container
+	/* object when refCount is 0. */
+	void *containerObject;	// Container object reference.
+};
+
+int VMCIResource_Init(void);
+void VMCIResource_Exit(void);
+void VMCIResource_Sync(void);
+
+uint32_t VMCIResource_GetID(uint32_t contextID);
+
+int VMCIResource_Add(struct vmci_resource *resource,
+		     enum vmci_resource_type resourceType,
+		     struct vmci_handle resourceHandle,
+		     VMCIResourceFreeCB containerFreeCB, void *containerObject);
+void VMCIResource_Remove(struct vmci_handle resourceHandle,
+			 enum vmci_resource_type resourceType);
+struct vmci_resource *VMCIResource_Get(struct vmci_handle resourceHandle,
+				       enum vmci_resource_type resourceType);
+void VMCIResource_Hold(struct vmci_resource *resource);
+int VMCIResource_Release(struct vmci_resource *resource);
+struct vmci_handle VMCIResource_Handle(struct vmci_resource *resource);
+
+#endif				/* _VMCI_RESOURCE_H_ */
-- 
1.7.0.4

