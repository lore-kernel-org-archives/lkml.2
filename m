Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab2BOBOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 20:14:12 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:43540 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757539Ab2BOBOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 20:14:05 -0500
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: vm-crosstalk@vmware.com, dtor@vmware.com, cschamp@vmware.com,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [PATCH 06/14] Add vmciHashtable.*
Date: Tue, 14 Feb 2012 17:05:47 -0800
Message-Id: <1329267955-32367-7-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
References: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/misc/vmw_vmci/vmciHashtable.c |  519 +++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmciHashtable.h |   58 ++++
 2 files changed, 577 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmciHashtable.c
 create mode 100644 drivers/misc/vmw_vmci/vmciHashtable.h

diff --git a/drivers/misc/vmw_vmci/vmciHashtable.c b/drivers/misc/vmw_vmci/vmciHashtable.c
new file mode 100644
index 0000000..dd5c4cd
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciHashtable.c
@@ -0,0 +1,519 @@
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
+#include "vmciDriver.h"
+#include "vmciHashtable.h"
+
+#define LGPFX "VMCIHashTable: "
+
+#define VMCI_HASHTABLE_HASH(_h, _sz)				\
+	VMCI_HashId(VMCI_HANDLE_TO_RESOURCE_ID(_h), (_sz))
+
+/* static int HashTableUnlinkEntry(struct vmci_hash_table *table, */
+/* 				struct vmci_hash_entry *entry); */
+/* static bool VMCIHashTableEntryExistsLocked(struct vmci_hash_table *table, */
+/* 					   struct vmci_handle handle); */
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  VMCIHashTable_Create --
+ *     XXX: Factor out the hashtable code to be shared amongst host and guest.
+ *
+ *  Result:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+struct vmci_hash_table *VMCIHashTable_Create(int size)
+{
+
+	struct vmci_hash_table *table = kmalloc(sizeof *table, GFP_KERNEL);
+	if (table == NULL)
+		return NULL;
+
+	table->entries = kmalloc(sizeof *table->entries * size, GFP_KERNEL);
+	if (table->entries == NULL) {
+		kfree(table);
+		return NULL;
+	}
+	memset(table->entries, 0, sizeof *table->entries * size);
+	table->size = size;
+
+	spin_lock_init(&table->lock);
+
+	return table;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  VMCIHashTable_Destroy --
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
+void VMCIHashTable_Destroy(struct vmci_hash_table *table)
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
+ *  VMCIHashTable_InitEntry --
+ *     Initializes a hash entry;
+ *
+ *  Result:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+void VMCIHashTable_InitEntry(struct vmci_hash_entry *entry,	// IN
+			     struct vmci_handle handle)	// IN
+{
+	ASSERT(entry);
+	entry->handle = handle;
+	entry->refCount = 0;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  VMCIHashTableEntryExistsLocked --
+ *
+ *     Unlocked version of VMCIHashTable_EntryExists.
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
+static bool VMCIHashTableEntryExistsLocked(struct vmci_hash_table *table,	// IN
+					   struct vmci_handle handle)	// IN
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
+ *  HashTableUnlinkEntry --
+ *     XXX Factor out the hashtable code to shared amongst API and perhaps
+ *     host and guest.
+ *     Assumes caller holds table lock.
+ *
+ *  Result:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static int HashTableUnlinkEntry(struct vmci_hash_table *table,	// IN
+				struct vmci_hash_entry *entry)	// IN
+{
+	int result;
+	struct vmci_hash_entry *prev, *cur;
+	int idx;
+
+	idx = VMCI_HASHTABLE_HASH(entry->handle, table->size);
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
+			if (prev) {
+				prev->next = cur->next;
+			} else {
+				table->entries[idx] = cur->next;
+			}
+			cur->next = NULL;
+			result = VMCI_SUCCESS;
+			break;
+		}
+		prev = cur;
+		cur = cur->next;
+	}
+	return result;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  VMCIHashTable_AddEntry --
+ *     XXX Factor out the hashtable code to be shared amongst host and guest.
+ *
+ *  Result:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int VMCIHashTable_AddEntry(struct vmci_hash_table *table,	// IN
+			   struct vmci_hash_entry *entry)	// IN
+{
+	int idx;
+
+	ASSERT(entry);
+	ASSERT(table);
+
+	spin_lock_bh(&table->lock);
+
+	/* Creation of a new hashtable entry is always allowed. */
+	if (VMCIHashTableEntryExistsLocked(table, entry->handle)) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX
+				"Entry (handle=0x%x:0x%x) already exists.\n",
+				entry->handle.context, entry->handle.resource));
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
+ *  VMCIHashTable_RemoveEntry --
+ *     XXX Factor out the hashtable code to shared amongst API and perhaps
+ *     host and guest.
+ *
+ *  Result:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int VMCIHashTable_RemoveEntry(struct vmci_hash_table *table,	// IN
+			      struct vmci_hash_entry *entry)	// IN
+{
+	int result;
+
+	ASSERT(table);
+	ASSERT(entry);
+
+	spin_lock_bh(&table->lock);
+
+	/* First unlink the entry. */
+	result = HashTableUnlinkEntry(table, entry);
+	if (result != VMCI_SUCCESS) {
+		/* We failed to find the entry. */
+		goto done;
+	}
+
+	/* Decrement refcount and check if this is last reference. */
+	entry->refCount--;
+	if (entry->refCount == 0) {
+		result = VMCI_SUCCESS_ENTRY_DEAD;
+		goto done;
+	}
+
+ done:
+	spin_unlock_bh(&table->lock);
+
+	return result;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  VMCIHashTableGetEntryLocked --
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
+static inline struct vmci_hash_entry *VMCIHashTableGetEntryLocked(struct vmci_hash_table *table,	// IN
+								  struct vmci_handle handle)	// IN
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
+ *  VMCIHashTable_GetEntry --
+ *     XXX Factor out the hashtable code to shared amongst API and perhaps
+ *     host and guest.
+ *
+ *  Result:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+struct vmci_hash_entry *VMCIHashTable_GetEntry(struct vmci_hash_table *table,	// IN
+					       struct vmci_handle handle)	// IN
+{
+	struct vmci_hash_entry *entry;
+
+	if (VMCI_HANDLE_EQUAL(handle, VMCI_INVALID_HANDLE))
+		return NULL;
+
+	ASSERT(table);
+
+	spin_lock_bh(&table->lock);
+	entry = VMCIHashTableGetEntryLocked(table, handle);
+	spin_unlock_bh(&table->lock);
+
+	return entry;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  VMCIHashTable_HoldEntry --
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
+void VMCIHashTable_HoldEntry(struct vmci_hash_table *table,	// IN
+			     struct vmci_hash_entry *entry)	// IN/OUT
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
+ *  VMCIHashTableReleaseEntryLocked --
+ *
+ *       Releases an element previously obtained with
+ *       VMCIHashTableGetEntryLocked.
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
+static inline int VMCIHashTableReleaseEntryLocked(struct vmci_hash_table *table,	// IN
+						  struct vmci_hash_entry *entry)	// IN
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
+		 * happened already because VMCIHashTable_RemoveEntry was called to unlink
+		 * it. We ignore if it is not found. Datagram handles will often have
+		 * RemoveEntry called, whereas SharedMemory regions rely on ReleaseEntry
+		 * to unlink the entry, since the creator does not call RemoveEntry when
+		 * it detaches.
+		 */
+
+		HashTableUnlinkEntry(table, entry);
+		result = VMCI_SUCCESS_ENTRY_DEAD;
+	}
+
+	return result;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  VMCIHashTable_ReleaseEntry --
+ *     XXX Factor out the hashtable code to shared amongst API and perhaps
+ *     host and guest.
+ *
+ *  Result:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+int VMCIHashTable_ReleaseEntry(struct vmci_hash_table *table,	// IN
+			       struct vmci_hash_entry *entry)	// IN
+{
+	int result;
+
+	ASSERT(table);
+	spin_lock_bh(&table->lock);
+	result = VMCIHashTableReleaseEntryLocked(table, entry);
+	spin_unlock_bh(&table->lock);
+
+	return result;
+}
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  VMCIHashTable_EntryExists --
+ *     XXX Factor out the hashtable code to shared amongst API and perhaps
+ *     host and guest.
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
+bool VMCIHashTable_EntryExists(struct vmci_hash_table * table,	// IN
+			       struct vmci_handle handle)	// IN
+{
+	bool exists;
+
+	ASSERT(table);
+
+	spin_lock_bh(&table->lock);
+	exists = VMCIHashTableEntryExistsLocked(table, handle);
+	spin_unlock_bh(&table->lock);
+
+	return exists;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIHashTable_Sync --
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
+void VMCIHashTable_Sync(struct vmci_hash_table *table)
+{
+	ASSERT(table);
+	spin_lock_bh(&table->lock);
+	spin_unlock_bh(&table->lock);
+}
diff --git a/drivers/misc/vmw_vmci/vmciHashtable.h b/drivers/misc/vmw_vmci/vmciHashtable.h
new file mode 100644
index 0000000..33d5503
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciHashtable.h
@@ -0,0 +1,58 @@
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
+#ifndef _VMCI_HASHTABLE_H_
+#define _VMCI_HASHTABLE_H_
+
+#include "vmci_defs.h"
+#include "vmci_kernel_if.h"
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
+struct vmci_hash_table *VMCIHashTable_Create(int size);
+void VMCIHashTable_Destroy(struct vmci_hash_table *table);
+void VMCIHashTable_InitEntry(struct vmci_hash_entry *entry,
+			     struct vmci_handle handle);
+int VMCIHashTable_AddEntry(struct vmci_hash_table *table,
+			   struct vmci_hash_entry *entry);
+int VMCIHashTable_RemoveEntry(struct vmci_hash_table *table,
+			      struct vmci_hash_entry *entry);
+struct vmci_hash_entry *VMCIHashTable_GetEntry(struct vmci_hash_table
+					       *table,
+					       struct vmci_handle handle);
+void VMCIHashTable_HoldEntry(struct vmci_hash_table *table,
+			     struct vmci_hash_entry *entry);
+int VMCIHashTable_ReleaseEntry(struct vmci_hash_table *table,
+			       struct vmci_hash_entry *entry);
+bool VMCIHashTable_EntryExists(struct vmci_hash_table *table,
+			       struct vmci_handle handle);
+void VMCIHashTable_Sync(struct vmci_hash_table *table);
+
+#endif				// _VMCI_HASHTABLE_H_
-- 
1.7.0.4

