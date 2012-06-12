Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab2FLUpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 16:45:52 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:53760 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754235Ab2FLUpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 16:45:07 -0400
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        vm-crosstalk@vmware.com
Cc: gregkh@linuxfoundation.org, cschamp@vmware.com, dtor@vmware.com,
        acking@vmware.com, dsouders@vmware.com,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [vmw_vmci RFCv2 09/11] Apply VMCI resource code
Date: Tue, 12 Jun 2012 13:44:28 -0700
Message-Id: <1339533870-24187-10-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1339533870-24187-1-git-send-email-astiegmann@vmware.com>
References: <1339533870-24187-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tracks all used resources within the vmci code.

Signed-off-by: Andrew Stiegmann (stieg) <astiegmann@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_resource.c |  194 +++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_resource.h |   62 +++++++++++
 2 files changed, 256 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmci_resource.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_resource.h

diff --git a/drivers/misc/vmw_vmci/vmci_resource.c b/drivers/misc/vmw_vmci/vmci_resource.c
new file mode 100644
index 0000000..03d1f44
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_resource.c
@@ -0,0 +1,194 @@
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
+#include <linux/vmw_vmci_defs.h>
+
+#include "vmci_common_int.h"
+#include "vmci_hash_table.h"
+#include "vmci_resource.h"
+#include "vmci_driver.h"
+
+/* 0 through VMCI_RESERVED_RESOURCE_ID_MAX are reserved. */
+static uint32_t resourceID = VMCI_RESERVED_RESOURCE_ID_MAX + 1;
+static spinlock_t resourceIdLock;
+static struct vmci_hash_table *resourceTable;
+
+/*
+ * Initializes the VMCI Resource Access Control API. Creates a hashtable
+ * to hold all resources, and registers vectors and callbacks for
+ * hypercalls.
+ */
+int __init vmci_resource_init(void)
+{
+	spin_lock_init(&resourceIdLock);
+
+	resourceTable = vmci_hash_create(128);
+	if (resourceTable == NULL) {
+		pr_warn("Failed creating a resource hash table.");
+		return VMCI_ERROR_NO_MEM;
+	}
+
+	return VMCI_SUCCESS;
+}
+
+void vmci_resource_exit(void)
+{
+	if (resourceTable)
+		vmci_hash_destroy(resourceTable);
+}
+
+/*
+ * Return resource ID. The first VMCI_RESERVED_RESOURCE_ID_MAX are
+ * reserved so we start from its value + 1.  Returns
+ * VMCI resource id on success, VMCI_INVALID_ID on failure.
+ */
+uint32_t vmci_resource_get_id(uint32_t contextID)
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
+		handle = vmci_make_handle(contextID, currentRID);
+		resourceID++;
+		if (unlikely(resourceID == VMCI_INVALID_ID)) {
+			/* Skip the reserved rids. */
+
+			resourceID = VMCI_RESERVED_RESOURCE_ID_MAX + 1;
+		}
+		spin_unlock(&resourceIdLock);
+		foundRID = !vmci_hash_exists(resourceTable, handle);
+	} while (!foundRID && resourceID != oldRID);
+
+	return (unlikely(!foundRID)) ? VMCI_INVALID_ID : currentRID;
+}
+
+int vmci_resource_add(struct vmci_resource *resource,
+		      enum vmci_resource_type resourceType,
+		      struct vmci_handle resourceHandle,
+		      VMCIResourceFreeCB containerFreeCB,
+		      void *containerObject)
+{
+	int result;
+
+	ASSERT(resource);
+
+	if (VMCI_HANDLE_EQUAL(resourceHandle, VMCI_INVALID_HANDLE)) {
+		pr_devel("Invalid argument resource (handle=0x%x:0x%x)",
+			 resourceHandle.context, resourceHandle.resource);
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	vmci_hash_init_entry(&resource->hashEntry, resourceHandle);
+	resource->type = resourceType;
+	resource->containerFreeCB = containerFreeCB;
+	resource->containerObject = containerObject;
+
+	/* Add resource to hashtable. */
+	result = vmci_hash_add(resourceTable, &resource->hashEntry);
+	if (result != VMCI_SUCCESS) {
+		pr_devel("Failed to add entry to hash table " \
+			 "(result=%d).", result);
+		return result;
+	}
+
+	return result;
+}
+
+void vmci_resource_remove(struct vmci_handle resourceHandle,
+			  enum vmci_resource_type resourceType)
+{
+	struct vmci_resource *resource =
+		vmci_resource_get(resourceHandle, resourceType);
+
+	if (resource == NULL)
+		return;
+
+	/* Remove resource from hashtable. */
+	vmci_hash_remove(resourceTable, &resource->hashEntry);
+
+	vmci_resource_release(resource);
+	/* resource could be freed by now. */
+}
+
+struct vmci_resource *vmci_resource_get(struct vmci_handle resourceHandle,
+					enum vmci_resource_type resourceType)
+{
+	struct vmci_resource *resource;
+	struct vmci_hash_entry *entry =
+		vmci_hash_get(resourceTable, resourceHandle);
+
+	if (entry == NULL)
+		return NULL;
+
+	resource = container_of(entry, struct vmci_resource, hashEntry);
+	if (resourceType == VMCI_RESOURCE_TYPE_ANY ||
+	    resource->type == resourceType)
+		return resource;
+
+	vmci_hash_release(resourceTable, entry);
+	return NULL;
+}
+
+/*
+ * Hold the given resource.  This will hold the hashtable entry.  This
+ * is like doing a Get() but without having to lookup the resource by
+ * handle.
+ */
+void vmci_resource_hold(struct vmci_resource *resource)
+{
+	ASSERT(resource);
+	vmci_hash_hold(resourceTable, &resource->hashEntry);
+}
+
+/*
+ * resource's containerFreeCB will get called if last reference.
+ */
+int vmci_resource_release(struct vmci_resource *resource)
+{
+	int result;
+
+	ASSERT(resource);
+
+	result = vmci_hash_release(resourceTable, &resource->hashEntry);
+	if (result == VMCI_SUCCESS_ENTRY_DEAD && resource->containerFreeCB)
+		resource->containerFreeCB(resource->containerObject);
+
+	/*
+	 * We propagate the information back to caller in case it wants to know
+	 * whether entry was freed.
+	 */
+	return result;
+}
+
+struct vmci_handle vmci_resource_handle(struct vmci_resource *resource)
+{
+	ASSERT(resource);
+	return resource->hashEntry.handle;
+}
diff --git a/drivers/misc/vmw_vmci/vmci_resource.h b/drivers/misc/vmw_vmci/vmci_resource.h
new file mode 100644
index 0000000..81a4254
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_resource.h
@@ -0,0 +1,62 @@
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
+#ifndef _VMCI_RESOURCE_H_
+#define _VMCI_RESOURCE_H_
+
+#include <linux/vmw_vmci_defs.h>
+
+#include "vmci_context.h"
+#include "vmci_hash_table.h"
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
+	/* Callback to free container object when refCount is 0. */
+	VMCIResourceFreeCB containerFreeCB;
+	void *containerObject;	/* Container object reference. */
+};
+
+int vmci_resource_init(void);
+void vmci_resource_exit(void);
+uint32_t vmci_resource_get_id(uint32_t contextID);
+int vmci_resource_add(struct vmci_resource *resource,
+		      enum vmci_resource_type resourceType,
+		      struct vmci_handle resourceHandle,
+		      VMCIResourceFreeCB containerFreeCB,
+		      void *containerObject);
+void vmci_resource_remove(struct vmci_handle resourceHandle,
+			  enum vmci_resource_type resourceType);
+struct vmci_resource *vmci_resource_get(struct vmci_handle resourceHandle,
+					enum vmci_resource_type resourceType);
+void vmci_resource_hold(struct vmci_resource *resource);
+int vmci_resource_release(struct vmci_resource *resource);
+struct vmci_handle vmci_resource_handle(struct vmci_resource *resource);
+
+#endif /* _VMCI_RESOURCE_H_ */
-- 
1.7.0.4

