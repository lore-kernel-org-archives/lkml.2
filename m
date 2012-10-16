Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab2JPAir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:38:47 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:43289 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755336Ab2JPAh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:37:56 -0400
Subject: [PATCH 08/10] VMCI: resource object implementation.
To: linux-kernel@vger.kernel.org, georgezhang@vmware.com,
        virtualization@lists.linux-foundation.org
From: George Zhang <georgezhang@vmware.com>
Cc: pv-drivers@vmware.com, vm-crosstalk@vmware.com, gregkh@linuxfoundation.org
Date: Mon, 15 Oct 2012 17:29:37 -0700
Message-ID: <20121016002929.26205.99294.stgit@promb-2n-dhcp175.eng.vmware.com>
In-Reply-To: <20121016002550.26205.67037.stgit@promb-2n-dhcp175.eng.vmware.com>
References: <20121016002550.26205.67037.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMCI resource tracks all used resources within the vmci code.


Signed-off-by: George Zhang <georgezhang@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_resource.c |  237 +++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_resource.h |   59 ++++++++
 2 files changed, 296 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmci_resource.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_resource.h

diff --git a/drivers/misc/vmw_vmci/vmci_resource.c b/drivers/misc/vmw_vmci/vmci_resource.c
new file mode 100644
index 0000000..a2f5fd0
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_resource.c
@@ -0,0 +1,237 @@
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
+#include <linux/hash.h>
+#include <linux/types.h>
+#include <linux/rculist.h>
+
+#include "vmci_common_int.h"
+#include "vmci_resource.h"
+#include "vmci_driver.h"
+
+
+#define VMCI_RESOURCE_HASH_BITS         7
+#define VMCI_RESOURCE_HASH_BUCKETS      (1 << VMCI_RESOURCE_HASH_BITS)
+
+struct vmci_hash_table {
+	spinlock_t lock;
+	struct hlist_head entries[VMCI_RESOURCE_HASH_BUCKETS];
+};
+
+static struct vmci_hash_table vmci_resource_table = {
+	.lock = __SPIN_LOCK_UNLOCKED(vmci_resource_table.lock),
+};
+
+static unsigned int vmci_resource_hash(struct vmci_handle handle)
+{
+	return hash_32(VMCI_HANDLE_TO_RESOURCE_ID(handle),
+		       VMCI_RESOURCE_HASH_BITS);
+}
+
+/*
+ * Gets a resource (if one exists) matching given handle from the hash table.
+ */
+static struct vmci_resource *vmci_resource_lookup(struct vmci_handle handle)
+{
+	struct vmci_resource *r, *resource = NULL;
+	struct hlist_node *node;
+	unsigned int idx = vmci_resource_hash(handle);
+
+	BUG_ON(VMCI_HANDLE_EQUAL(handle, VMCI_INVALID_HANDLE));
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(r, node,
+				 &vmci_resource_table.entries[idx], node) {
+		u32 rid = VMCI_HANDLE_TO_RESOURCE_ID(r->handle);
+		u32 cid = VMCI_HANDLE_TO_CONTEXT_ID(r->handle);
+
+		if (rid == VMCI_HANDLE_TO_RESOURCE_ID(handle) &&
+		    (cid == VMCI_HANDLE_TO_CONTEXT_ID(handle) ||
+		     cid == VMCI_INVALID_ID)) {
+			resource = r;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return resource;
+}
+
+/*
+ * Find an unused resource ID and return it. The first
+ * VMCI_RESERVED_RESOURCE_ID_MAX are reserved so we start from
+ * its value + 1.
+ * Returns VMCI resource id on success, VMCI_INVALID_ID on failure.
+ */
+static u32 vmci_resource_find_id(u32 context_id)
+{
+	static u32 resource_id = VMCI_RESERVED_RESOURCE_ID_MAX + 1;
+	u32 old_rid = resource_id;
+	u32 current_rid;
+
+	/*
+	 * Generate a unique resource ID.  Keep on trying until we wrap around
+	 * in the RID space.
+	 */
+	BUG_ON(old_rid <= VMCI_RESERVED_RESOURCE_ID_MAX);
+
+	do {
+		struct vmci_handle handle;
+
+		current_rid = resource_id;
+		resource_id++;
+		if (unlikely(resource_id == VMCI_INVALID_ID)) {
+			/* Skip the reserved rids. */
+			resource_id = VMCI_RESERVED_RESOURCE_ID_MAX + 1;
+		}
+
+		handle = vmci_make_handle(context_id, current_rid);
+		if (!vmci_resource_lookup(handle))
+			return current_rid;
+	} while (resource_id != old_rid);
+
+	return VMCI_INVALID_ID;
+}
+
+
+int vmci_resource_add(struct vmci_resource *resource,
+		      enum vmci_resource_type resource_type,
+		      struct vmci_handle handle)
+
+{
+	unsigned int idx;
+	int result;
+
+	BUG_ON(!resource);
+
+	spin_lock(&vmci_resource_table.lock);
+
+	if (handle.resource == VMCI_INVALID_ID) {
+		handle.resource = vmci_resource_find_id(handle.context);
+		if (handle.resource == VMCI_INVALID_ID) {
+			result = VMCI_ERROR_NO_HANDLE;
+			goto out;
+		}
+	} else if (vmci_resource_lookup(handle)) {
+		result = VMCI_ERROR_ALREADY_EXISTS;
+		goto out;
+	}
+
+	resource->handle = handle;
+	resource->type = resource_type;
+	INIT_HLIST_NODE(&resource->node);
+	kref_init(&resource->kref);
+	init_completion(&resource->done);
+
+	idx = vmci_resource_hash(resource->handle);
+	BUG_ON(idx >= VMCI_RESOURCE_HASH_BUCKETS);
+	hlist_add_head_rcu(&resource->node, &vmci_resource_table.entries[idx]);
+
+	result = VMCI_SUCCESS;
+
+out:
+	spin_unlock(&vmci_resource_table.lock);
+	return result;
+}
+
+void vmci_resource_remove(struct vmci_resource *resource)
+{
+	struct vmci_handle handle = resource->handle;
+	unsigned int idx = vmci_resource_hash(handle);
+	struct vmci_resource *r;
+	struct hlist_node *node;
+
+	/* Remove resource from hash table. */
+	spin_lock(&vmci_resource_table.lock);
+
+	hlist_for_each_entry(r, node, &vmci_resource_table.entries[idx], node) {
+		if (VMCI_HANDLE_EQUAL(r->handle, resource->handle)) {
+			BUG_ON(r != resource);
+			hlist_del_init_rcu(&r->node);
+			break;
+		}
+	}
+
+	spin_unlock(&vmci_resource_table.lock);
+	synchronize_rcu();
+
+	vmci_resource_put(resource);
+	wait_for_completion(&resource->done);
+}
+
+struct vmci_resource *
+vmci_resource_by_handle(struct vmci_handle resource_handle,
+			enum vmci_resource_type resource_type)
+{
+	struct vmci_resource *r, *resource = NULL;
+
+	rcu_read_lock();
+
+	r = vmci_resource_lookup(resource_handle);
+	if (r &&
+	    (resource_type == r->type ||
+	     resource_type == VMCI_RESOURCE_TYPE_ANY)) {
+		resource = vmci_resource_get(r);
+	}
+
+	rcu_read_unlock();
+
+	return resource;
+}
+
+/*
+ * Get a reference to given resource.
+ */
+struct vmci_resource *vmci_resource_get(struct vmci_resource *resource)
+{
+	kref_get(&resource->kref);
+
+	return resource;
+}
+
+static void vmci_release_resource(struct kref *kref)
+{
+	struct vmci_resource *resource =
+		container_of(kref, struct vmci_resource, kref);
+
+	/* Verify the resource has been unlinked from hash table */
+	WARN_ON(!hlist_unhashed(&resource->node));
+
+	/* Signal that container of this resource can now be destroyed */
+	complete(&resource->done);
+}
+
+/*
+ * resource's release function will get called if last reference.
+ */
+int vmci_resource_put(struct vmci_resource *resource)
+{
+	BUG_ON(!resource);
+
+	/*
+	 * We propagate the information back to caller in case it wants to know
+	 * whether entry was freed.
+	 */
+	return kref_put(&resource->kref, vmci_release_resource) ?
+		VMCI_SUCCESS_ENTRY_DEAD : VMCI_SUCCESS;
+}
+
+struct vmci_handle vmci_resource_handle(struct vmci_resource *resource)
+{
+	BUG_ON(!resource);
+
+	return resource->handle;
+}
diff --git a/drivers/misc/vmw_vmci/vmci_resource.h b/drivers/misc/vmw_vmci/vmci_resource.h
new file mode 100644
index 0000000..9190cd2
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_resource.h
@@ -0,0 +1,59 @@
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
+#ifndef _VMCI_RESOURCE_H_
+#define _VMCI_RESOURCE_H_
+
+#include <linux/vmw_vmci_defs.h>
+#include <linux/types.h>
+
+#include "vmci_context.h"
+
+
+enum vmci_resource_type {
+	VMCI_RESOURCE_TYPE_ANY,
+	VMCI_RESOURCE_TYPE_API,
+	VMCI_RESOURCE_TYPE_GROUP,
+	VMCI_RESOURCE_TYPE_DATAGRAM,
+	VMCI_RESOURCE_TYPE_DOORBELL,
+	VMCI_RESOURCE_TYPE_QPAIR_GUEST,
+	VMCI_RESOURCE_TYPE_QPAIR_HOST
+};
+
+struct vmci_resource {
+	struct vmci_handle handle;
+	enum vmci_resource_type type;
+	struct hlist_node node;
+	struct kref kref;
+	struct completion done;
+};
+
+
+int vmci_resource_add(struct vmci_resource *resource,
+		      enum vmci_resource_type resource_type,
+		      struct vmci_handle handle);
+
+void vmci_resource_remove(struct vmci_resource *resource);
+
+struct vmci_resource *
+vmci_resource_by_handle(struct vmci_handle resource_handle,
+			enum vmci_resource_type resource_type);
+
+struct vmci_resource *vmci_resource_get(struct vmci_resource *resource);
+int vmci_resource_put(struct vmci_resource *resource);
+
+struct vmci_handle vmci_resource_handle(struct vmci_resource *resource);
+
+#endif /* _VMCI_RESOURCE_H_ */

