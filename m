Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab2EOPIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:08:42 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:37278 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933101Ab2EOPHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:07:30 -0400
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: acking@vmware.com, dtor@vmware.com, dsouders@vmware.com,
        cschamp@vmware.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, virtualization@lists.linux-foundation.org,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [vmw_vmci RFC 07/11] Apply VMCI hash table
Date: Tue, 15 May 2012 08:07:04 -0700
Message-Id: <1337094428-20453-8-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337094428-20453-1-git-send-email-astiegmann@vmware.com>
References: <1337094428-20453-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implements a hash table for VMCI's use.

Signed-off-by: Andrew Stiegmann (stieg) <astiegmann@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_hash_table.c |  494 +++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_hash_table.h |   56 ++++
 2 files changed, 550 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmci_hash_table.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_hash_table.h

diff --git a/drivers/misc/vmw_vmci/vmci_hash_table.c b/drivers/misc/vmw_vmci/vmci_hash_table.c
new file mode 100644
index 0000000..d2e74da
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_hash_table.c
@@ -0,0 +1,494 @@
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
+#include "vmci_context.h"
+#include "vmci_common_int.h"
+#include "vmci_driver.h"
+#include "vmci_hash_table.h"
+
+#define VMCI_HANDLE_TO_CONTEXT_ID(_handle) ((_handle).context)
+#define VMCI_HANDLE_TO_RESOURCE_ID(_handle) ((_handle).resource)
+#define VMCI_HASHTABLE_HASH(_h, _sz)				\
+	vmci_hash_calc(VMCI_HANDLE_TO_RESOURCE_ID(_h), (_sz))
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  vmci_hash_create --
+ *
+ *  Result:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+struct vmci_hash_table *vmci_hash_create(int size)
+{
+	struct vmci_hash_table *table;
+
+	table = kmalloc(sizeof *table, GFP_KERNEL);
+	if (table == NULL)
+		return NULL;
+
+	table->entries = kcalloc(size, sizeof *table->entries, GFP_KERNEL);
+	if (table->entries == NULL) {
+		kfree(table);
+		return NULL;
+	}
+
+	table->size = size;
+	spin_lock_init(&table->lock);
+
+	return table;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  vmci_hash_destroy --
+ *     This function should be called at module exit time.
+ *     We rely on the module ref count to insure that no one is accessing any
+ *     hash table entries at this point in time. Hence we should be able to just
+ *     remove all entries from the hash table.
+ *
+ *  Result:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+void vmci_hash_destroy(struct vmci_hash_table *table)
+{
+	ASSERT(table);
+
+	spin_lock_bh(&table->lock);
+	kfree(table->entries);
+	table->entries = NULL;
+	spin_unlock_bh(&table->lock);
+	kfree(table);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  vmci_hash_init_entry --
+ *     Initializes a hash entry;
+ *
+ *  Result:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+void vmci_hash_init_entry(struct vmci_hash_entry *entry,	// IN
+				 struct vmci_handle handle)	// IN
+{
+	ASSERT(entry);
+	entry->handle = handle;
+	entry->refCount = 0;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  hash_exists_locked --
+ *
+ *     Unlocked version of vmci_hash_exists.
+ *
+ *  Result:
+ *     true if handle already in hashtable. false otherwise.
+ *
+ *  Side effects:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static bool hash_exists_locked(struct vmci_hash_table *table,	// IN
+			       struct vmci_handle handle)	// IN
+{
+	struct vmci_hash_entry *entry;
+	int idx;
+
+	ASSERT(table);
+
+	idx = VMCI_HASHTABLE_HASH(handle, table->size);
+
+	for (entry = table->entries[idx]; entry; entry = entry->next) {
+		if (VMCI_HANDLE_TO_RESOURCE_ID(entry->handle) ==
+		    VMCI_HANDLE_TO_RESOURCE_ID(handle) &&
+		    ((VMCI_HANDLE_TO_CONTEXT_ID(entry->handle) ==
+		      VMCI_HANDLE_TO_CONTEXT_ID(handle)) ||
+		     (VMCI_INVALID_ID == VMCI_HANDLE_TO_CONTEXT_ID(handle))
+		     || (VMCI_INVALID_ID ==
+			 VMCI_HANDLE_TO_CONTEXT_ID(entry->handle)))) {
+			return true;
+		}
+	}
+
+	return false;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  hash_unlink --
+ *     Assumes caller holds table lock.
+ *
+ *  Result:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static int hash_unlink(struct vmci_hash_table *table,	// IN
+		       struct vmci_hash_entry *entry)	// IN
+{
+	int result;
+	struct vmci_hash_entry *prev, *cur;
+	const int idx = VMCI_HASHTABLE_HASH(entry->handle, table->size);
+
+	prev = NULL;
+	cur = table->entries[idx];
+	while (true) {
+		if (cur == NULL) {
+			result = VMCI_ERROR_NOT_FOUND;
+			break;
+		}
+		if (VMCI_HANDLE_EQUAL(cur->handle, entry->handle)) {
+			ASSERT(cur == entry);
+
+			/* Remove entry and break. */
+			if (prev)
+				prev->next = cur->next;
+			else
+				table->entries[idx] = cur->next;
+
+			cur->next = NULL;
+			result = VMCI_SUCCESS;
+			break;
+		}
+		prev = cur;
+		cur = cur->next;
+	}
+
+	return result;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  vmci_hash_add --
+ *
+ *  Result:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int vmci_hash_add(struct vmci_hash_table *table,	// IN
+		  struct vmci_hash_entry *entry)	// IN
+{
+	int idx;
+
+	ASSERT(entry);
+	ASSERT(table);
+
+	spin_lock_bh(&table->lock);
+
+	/* Creation of a new hashtable entry is always allowed. */
+	if (hash_exists_locked(table, entry->handle)) {
+		pr_devel("Entry (handle=0x%x:0x%x) already exists.",
+			 entry->handle.context, entry->handle.resource);
+		spin_unlock_bh(&table->lock);
+		return VMCI_ERROR_DUPLICATE_ENTRY;
+	}
+
+	idx = VMCI_HASHTABLE_HASH(entry->handle, table->size);
+	ASSERT(idx < table->size);
+
+	/* New entry is added to top/front of hash bucket. */
+	entry->refCount++;
+	entry->next = table->entries[idx];
+	table->entries[idx] = entry;
+	spin_unlock_bh(&table->lock);
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  vmci_hash_remove --
+ *
+ *  Result:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int vmci_hash_remove(struct vmci_hash_table *table,	// IN
+		     struct vmci_hash_entry *entry)	// IN
+{
+	int result;
+
+	ASSERT(table);
+	ASSERT(entry);
+
+	spin_lock_bh(&table->lock);
+
+	/* First unlink the entry. */
+	result = hash_unlink(table, entry);
+	if (result == VMCI_SUCCESS) {
+		/* Decrement refcount and check if this is last reference. */
+		entry->refCount--;
+		if (entry->refCount == 0)
+			result = VMCI_SUCCESS_ENTRY_DEAD;
+	}
+
+	spin_unlock_bh(&table->lock);
+
+	return result;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  hash_get_locked --
+ *
+ *       Looks up an entry in the hash table, that is already locked.
+ *
+ *  Result:
+ *       If the element is found, a pointer to the element is returned.
+ *       Otherwise NULL is returned.
+ *
+ *  Side effects:
+ *       The reference count of the returned element is increased.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static struct vmci_hash_entry *hash_get_locked(struct vmci_hash_table *table,	// IN
+					       struct vmci_handle handle)	// IN
+{
+	struct vmci_hash_entry *cur = NULL;
+	int idx;
+
+	ASSERT(!VMCI_HANDLE_EQUAL(handle, VMCI_INVALID_HANDLE));
+	ASSERT(table);
+
+	idx = VMCI_HASHTABLE_HASH(handle, table->size);
+
+	for (cur = table->entries[idx]; cur != NULL; cur = cur->next) {
+		if (VMCI_HANDLE_TO_RESOURCE_ID(cur->handle) ==
+		    VMCI_HANDLE_TO_RESOURCE_ID(handle) &&
+		    ((VMCI_HANDLE_TO_CONTEXT_ID(cur->handle) ==
+		      VMCI_HANDLE_TO_CONTEXT_ID(handle)) ||
+		     (VMCI_INVALID_ID ==
+		      VMCI_HANDLE_TO_CONTEXT_ID(cur->handle)))) {
+			cur->refCount++;
+			break;
+		}
+	}
+
+	return cur;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  vmci_hash_get --
+ *
+ *  Result:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+struct vmci_hash_entry *vmci_hash_get(struct vmci_hash_table *table,	// IN
+				      struct vmci_handle handle)	// IN
+{
+	struct vmci_hash_entry *entry;
+
+	if (VMCI_HANDLE_EQUAL(handle, VMCI_INVALID_HANDLE))
+		return NULL;
+
+	ASSERT(table);
+
+	spin_lock_bh(&table->lock);
+	entry = hash_get_locked(table, handle);
+	spin_unlock_bh(&table->lock);
+
+	return entry;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  vmci_hash_hold --
+ *
+ *     Hold the given entry.  This will increment the entry's reference count.
+ *     This is like a GetEntry() but without having to lookup the entry by
+ *     handle.
+ *
+ *  Result:
+ *     None.
+ *
+ *  Side effects:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+void vmci_hash_hold(struct vmci_hash_table *table,	// IN
+		    struct vmci_hash_entry *entry)	// IN/OUT
+{
+	ASSERT(table);
+	ASSERT(entry);
+
+	spin_lock_bh(&table->lock);
+	entry->refCount++;
+	spin_unlock_bh(&table->lock);
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  hash_release_locked --
+ *
+ *       Releases an element previously obtained with
+ *       hash_get_locked.
+ *
+ *  Result:
+ *       If the entry is removed from the hash table, VMCI_SUCCESS_ENTRY_DEAD
+ *       is returned. Otherwise, VMCI_SUCCESS is returned.
+ *
+ *  Side effects:
+ *       The reference count of the entry is decreased and the entry is removed
+ *       from the hash table on 0.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static int hash_release_locked(struct vmci_hash_table *table,	// IN
+			       struct vmci_hash_entry *entry)	// IN
+{
+	int result = VMCI_SUCCESS;
+
+	ASSERT(table);
+	ASSERT(entry);
+
+	entry->refCount--;
+	/* Check if this is last reference and report if so. */
+	if (entry->refCount == 0) {
+
+		/*
+		 * Remove entry from hash table if not already removed. This could have
+		 * happened already because vmci_hash_remove was called to unlink
+		 * it. We ignore if it is not found. Datagram handles will often have
+		 * RemoveEntry called, whereas SharedMemory regions rely on ReleaseEntry
+		 * to unlink the entry, since the creator does not call RemoveEntry when
+		 * it detaches.
+		 */
+
+		hash_unlink(table, entry);
+		result = VMCI_SUCCESS_ENTRY_DEAD;
+	}
+
+	return result;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  vmci_hash_release --
+ *
+ *  Result:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int vmci_hash_release(struct vmci_hash_table *table,	// IN
+			     struct vmci_hash_entry *entry)	// IN
+{
+	int result;
+
+	spin_lock_bh(&table->lock);
+	result = hash_release_locked(table, entry);
+	spin_unlock_bh(&table->lock);
+
+	return result;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  vmci_hash_exists --
+ *
+ *  Result:
+ *     true if handle already in hashtable. false otherwise.
+ *
+ *  Side effects:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+bool vmci_hash_exists(struct vmci_hash_table * table,	// IN
+			     struct vmci_handle handle)	// IN
+{
+	bool exists;
+
+	spin_lock_bh(&table->lock);
+	exists = hash_exists_locked(table, handle);
+	spin_unlock_bh(&table->lock);
+
+	return exists;
+}
+
+/*
+ *-------------------------------------------------------------------------
+ *
+ *  vmci_hash_calc --
+ *
+ *     Hash function used by the Simple Datagram API. Hashes only a VMCI id
+ *     (not the full VMCI handle) Based on the djb2
+ *     hash function by Dan Bernstein.
+ *
+ *  Result:
+ *     Returns guest call size.
+ *
+ *  Side effects:
+ *     None.
+ *
+ *-------------------------------------------------------------------------
+ */
+
+int vmci_hash_calc(uint32_t id, unsigned size)
+{
+	unsigned i;
+	int hash = 5381;
+
+	for (i = 0; i < sizeof id; i++)
+		hash = ((hash << 5) + hash) + (uint8_t) (id >> (i * 8));
+
+	return hash & (size - 1);
+}
diff --git a/drivers/misc/vmw_vmci/vmci_hash_table.h b/drivers/misc/vmw_vmci/vmci_hash_table.h
new file mode 100644
index 0000000..77428b4
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_hash_table.h
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
+#ifndef _VMCI_HASH_TABLE_H_
+#define _VMCI_HASH_TABLE_H_
+
+#include <linux/vmw_vmci_defs.h>
+
+struct vmci_hash_entry {
+	struct vmci_handle handle;
+	int refCount;
+	struct vmci_hash_entry *next;
+};
+
+struct vmci_hash_table {
+	struct vmci_hash_entry **entries;
+	int size;		/* Number of buckets in above array. */
+	spinlock_t lock;
+};
+
+struct vmci_hash_table *vmci_hash_create(int size);
+void vmci_hash_destroy(struct vmci_hash_table *table);
+void vmci_hash_init_entry(struct vmci_hash_entry *entry,
+			  struct vmci_handle handle);
+int vmci_hash_add(struct vmci_hash_table *table,
+		  struct vmci_hash_entry *entry);
+int vmci_hash_remove(struct vmci_hash_table *table,
+		     struct vmci_hash_entry *entry);
+struct vmci_hash_entry *vmci_hash_get(struct vmci_hash_table
+				      *table,
+				      struct vmci_handle handle);
+void vmci_hash_hold(struct vmci_hash_table *table,
+		    struct vmci_hash_entry *entry);
+int vmci_hash_release(struct vmci_hash_table *table,
+		      struct vmci_hash_entry *entry);
+bool vmci_hash_exists(struct vmci_hash_table *table,
+		      struct vmci_handle handle);
+int vmci_hash_calc(uint32_t id, unsigned size);
+
+#endif				// _VMCI_HASH_TABLE_H_
-- 
1.7.0.4

