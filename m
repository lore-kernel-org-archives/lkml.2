Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab2H3Qly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 12:41:54 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:44240 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754291Ab2H3Qlw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 12:41:52 -0400
From: George Zhang <georgezhang@vmware.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Thu, 30 Aug 2012 09:41:37 -0700
Subject: [PATCH 07/11] vmci_hash_table.patch: VMCI hash table implementation.
Thread-Topic: [PATCH 07/11] vmci_hash_table.patch: VMCI hash table
 implementation.
Thread-Index: Ac2CHC9vs851JqbYQ5+pghzaWJGaYQEsiOzg
Message-ID: <15333E71B3DDCB48A90165AD57993F285685DB43DD@exch-mbx-114.vmware.com>
References: <20120824171042.4775.36871.stgit@promb-2n-dhcp175.eng.vmware.com>,<20120824171622.4775.49916.stgit@promb-2n-dhcp175.eng.vmware.com>
In-Reply-To: <20120824171622.4775.49916.stgit@promb-2n-dhcp175.eng.vmware.com>
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
 drivers/misc/vmw_vmci/vmci_hash_table.c |  329 +++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_hash_table.h |   53 +++++
 2 files changed, 382 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmci_hash_table.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_hash_table.h

diff --git a/drivers/misc/vmw_vmci/vmci_hash_table.c b/drivers/misc/vmw_vmci/vmci_hash_table.c
new file mode 100644
index 0000000..a447cfc
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_hash_table.c
@@ -0,0 +1,329 @@
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
+#include <linux/slab.h>
+
+#include "vmci_common_int.h"
+#include "vmci_hash_table.h"
+#include "vmci_context.h"
+#include "vmci_driver.h"
+
+#define VMCI_HANDLE_TO_CONTEXT_ID(_handle) ((_handle).context)
+#define VMCI_HANDLE_TO_RESOURCE_ID(_handle) ((_handle).resource)
+#define VMCI_HASHTABLE_HASH(_h, _sz)                           \
+       vmci_hash_calc(VMCI_HANDLE_TO_RESOURCE_ID(_h), (_sz))
+
+struct vmci_hash_table *vmci_hash_create(int size)
+{
+       struct vmci_hash_table *table;
+
+       table = kmalloc(sizeof(*table), GFP_KERNEL);
+       if (table == NULL)
+               return NULL;
+
+       table->entries = kcalloc(size, sizeof(*table->entries), GFP_KERNEL);
+       if (table->entries == NULL) {
+               kfree(table);
+               return NULL;
+       }
+
+       table->size = size;
+       spin_lock_init(&table->lock);
+
+       return table;
+}
+
+/*
+ * This function should be called at module exit time.
+ * We rely on the module ref count to insure that no one is accessing any
+ * hash table entries at this point in time. Hence we should be able to just
+ * remove all entries from the hash table.
+ */
+void vmci_hash_destroy(struct vmci_hash_table *table)
+{
+       ASSERT(table);
+
+       spin_lock_bh(&table->lock);
+       kfree(table->entries);
+       table->entries = NULL;
+       spin_unlock_bh(&table->lock);
+       kfree(table);
+}
+
+void vmci_hash_init_entry(struct vmci_hash_entry *entry,
+                         struct vmci_handle handle)
+{
+       ASSERT(entry);
+       entry->handle = handle;
+       entry->refCount = 0;
+}
+
+/*
+ * Unlocked version of vmci_hash_exists.
+ * True if handle already in hashtable. false otherwise.
+ */
+static bool hash_exists_locked(struct vmci_hash_table *table,
+                              struct vmci_handle handle)
+{
+       struct vmci_hash_entry *entry;
+       int idx;
+
+       ASSERT(table);
+
+       idx = VMCI_HASHTABLE_HASH(handle, table->size);
+
+       for (entry = table->entries[idx]; entry; entry = entry->next) {
+               if (VMCI_HANDLE_TO_RESOURCE_ID(entry->handle) ==
+                   VMCI_HANDLE_TO_RESOURCE_ID(handle) &&
+                   ((VMCI_HANDLE_TO_CONTEXT_ID(entry->handle) ==
+                     VMCI_HANDLE_TO_CONTEXT_ID(handle)) ||
+                    (VMCI_INVALID_ID == VMCI_HANDLE_TO_CONTEXT_ID(handle)) ||
+                    (VMCI_INVALID_ID ==
+                     VMCI_HANDLE_TO_CONTEXT_ID(entry->handle)))) {
+                       return true;
+               }
+       }
+
+       return false;
+}
+
+/*
+ * Assumes caller holds table lock.
+ */
+static int hash_unlink(struct vmci_hash_table *table,
+                      struct vmci_hash_entry *entry)
+{
+       int result;
+       struct vmci_hash_entry *prev, *cur;
+       const int idx = VMCI_HASHTABLE_HASH(entry->handle, table->size);
+
+       prev = NULL;
+       cur = table->entries[idx];
+       while (true) {
+               if (cur == NULL) {
+                       result = VMCI_ERROR_NOT_FOUND;
+                       break;
+               }
+               if (VMCI_HANDLE_EQUAL(cur->handle, entry->handle)) {
+                       ASSERT(cur == entry);
+
+                       /* Remove entry and break. */
+                       if (prev)
+                               prev->next = cur->next;
+                       else
+                               table->entries[idx] = cur->next;
+
+                       cur->next = NULL;
+                       result = VMCI_SUCCESS;
+                       break;
+               }
+               prev = cur;
+               cur = cur->next;
+       }
+
+       return result;
+}
+
+int vmci_hash_add(struct vmci_hash_table *table,
+                 struct vmci_hash_entry *entry)
+{
+       int idx;
+
+       ASSERT(entry);
+       ASSERT(table);
+
+       spin_lock_bh(&table->lock);
+
+       /* Creation of a new hashtable entry is always allowed. */
+       if (hash_exists_locked(table, entry->handle)) {
+               pr_devel("Entry (handle=0x%x:0x%x) already exists.",
+                        entry->handle.context, entry->handle.resource);
+               spin_unlock_bh(&table->lock);
+               return VMCI_ERROR_DUPLICATE_ENTRY;
+       }
+
+       idx = VMCI_HASHTABLE_HASH(entry->handle, table->size);
+       ASSERT(idx < table->size);
+
+       /* New entry is added to top/front of hash bucket. */
+       entry->refCount++;
+       entry->next = table->entries[idx];
+       table->entries[idx] = entry;
+       spin_unlock_bh(&table->lock);
+
+       return VMCI_SUCCESS;
+}
+
+int vmci_hash_remove(struct vmci_hash_table *table,
+                    struct vmci_hash_entry *entry)
+{
+       int result;
+
+       ASSERT(table);
+       ASSERT(entry);
+
+       spin_lock_bh(&table->lock);
+
+       /* First unlink the entry. */
+       result = hash_unlink(table, entry);
+       if (result == VMCI_SUCCESS) {
+               /* Decrement refcount and check if this is last reference. */
+               entry->refCount--;
+               if (entry->refCount == 0)
+                       result = VMCI_SUCCESS_ENTRY_DEAD;
+       }
+
+       spin_unlock_bh(&table->lock);
+
+       return result;
+}
+
+/*
+ * Looks up an entry in the hash table, that is already locked.
+ * If the element is found, a pointer to the element is returned.
+ * Else NULL.
+ */
+static struct vmci_hash_entry *hash_get_locked(struct vmci_hash_table *table,
+                                              struct vmci_handle handle)
+{
+       struct vmci_hash_entry *cur = NULL;
+       int idx;
+
+       ASSERT(!VMCI_HANDLE_EQUAL(handle, VMCI_INVALID_HANDLE));
+       ASSERT(table);
+
+       idx = VMCI_HASHTABLE_HASH(handle, table->size);
+
+       for (cur = table->entries[idx]; cur != NULL; cur = cur->next) {
+               if (VMCI_HANDLE_TO_RESOURCE_ID(cur->handle) ==
+                   VMCI_HANDLE_TO_RESOURCE_ID(handle) &&
+                   ((VMCI_HANDLE_TO_CONTEXT_ID(cur->handle) ==
+                     VMCI_HANDLE_TO_CONTEXT_ID(handle)) ||
+                    (VMCI_INVALID_ID ==
+                     VMCI_HANDLE_TO_CONTEXT_ID(cur->handle)))) {
+                       cur->refCount++;
+                       break;
+               }
+       }
+
+       return cur;
+}
+
+struct vmci_hash_entry *vmci_hash_get(struct vmci_hash_table *table,
+                                     struct vmci_handle handle)
+{
+       struct vmci_hash_entry *entry;
+
+       if (VMCI_HANDLE_EQUAL(handle, VMCI_INVALID_HANDLE))
+               return NULL;
+
+       ASSERT(table);
+
+       spin_lock_bh(&table->lock);
+       entry = hash_get_locked(table, handle);
+       spin_unlock_bh(&table->lock);
+
+       return entry;
+}
+
+/*
+ * Hold the given entry.  This will increment the entry's reference count.
+ * This is like a GetEntry() but without having to lookup the entry by
+ * handle.
+ */
+void vmci_hash_hold(struct vmci_hash_table *table,
+                   struct vmci_hash_entry *entry)
+{
+       ASSERT(table);
+       ASSERT(entry);
+
+       spin_lock_bh(&table->lock);
+       entry->refCount++;
+       spin_unlock_bh(&table->lock);
+}
+
+/*
+ * Releases an element previously obtained with hash_get_locked.
+ * If the entry is removed from the hash table, VMCI_SUCCESS_ENTRY_DEAD
+ * is returned. Otherwise, VMCI_SUCCESS is returned.
+ */
+static int hash_release_locked(struct vmci_hash_table *table,
+                              struct vmci_hash_entry *entry)
+{
+       int result = VMCI_SUCCESS;
+
+       ASSERT(table);
+       ASSERT(entry);
+
+       entry->refCount--;
+       /* Check if this is last reference and report if so. */
+       if (entry->refCount == 0) {
+               /*
+                * Remove entry from hash table if not already
+                * removed. This could have happened already because
+                * vmci_hash_remove was called to unlink it. We ignore
+                * if it is not found. Datagram handles will often
+                * have RemoveEntry called, whereas SharedMemory
+                * regions rely on ReleaseEntry to unlink the entry,
+                * since the creator does not call RemoveEntry when it
+                * detaches.
+                */
+               hash_unlink(table, entry);
+               result = VMCI_SUCCESS_ENTRY_DEAD;
+       }
+
+       return result;
+}
+
+int vmci_hash_release(struct vmci_hash_table *table,
+                     struct vmci_hash_entry *entry)
+{
+       int result;
+
+       spin_lock_bh(&table->lock);
+       result = hash_release_locked(table, entry);
+       spin_unlock_bh(&table->lock);
+
+       return result;
+}
+
+bool vmci_hash_exists(struct vmci_hash_table *table,
+                     struct vmci_handle handle)
+{
+       bool exists;
+
+       spin_lock_bh(&table->lock);
+       exists = hash_exists_locked(table, handle);
+       spin_unlock_bh(&table->lock);
+
+       return exists;
+}
+
+/*
+ * Hash function used by the Simple Datagram API. Hashes only a VMCI id
+ * (not the full VMCI handle) Based on the djb2 hash function by
+ * Dan Bernstein.
+ */
+int vmci_hash_calc(uint32_t id, unsigned size)
+{
+       unsigned i;
+       int hash = 5381;
+
+       for (i = 0; i < sizeof(id); i++)
+               hash = ((hash << 5) + hash) + (uint8_t) (id >> (i * 8));
+
+       return hash & (size - 1);
+}
diff --git a/drivers/misc/vmw_vmci/vmci_hash_table.h b/drivers/misc/vmw_vmci/vmci_hash_table.h
new file mode 100644
index 0000000..8eeab2d
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_hash_table.h
@@ -0,0 +1,53 @@
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
+#ifndef _VMCI_HASH_TABLE_H_
+#define _VMCI_HASH_TABLE_H_
+
+#include <linux/vmw_vmci_defs.h>
+#include <linux/spinlock.h>
+
+struct vmci_hash_entry {
+       struct vmci_handle handle;
+       int refCount;
+       struct vmci_hash_entry *next;
+};
+
+struct vmci_hash_table {
+       struct vmci_hash_entry **entries;
+       int size;               /* Number of buckets in above array. */
+       spinlock_t lock;
+};
+
+struct vmci_hash_table *vmci_hash_create(int size);
+void vmci_hash_destroy(struct vmci_hash_table *table);
+void vmci_hash_init_entry(struct vmci_hash_entry *entry,
+                         struct vmci_handle handle);
+int vmci_hash_add(struct vmci_hash_table *table,
+                 struct vmci_hash_entry *entry);
+int vmci_hash_remove(struct vmci_hash_table *table,
+                    struct vmci_hash_entry *entry);
+struct vmci_hash_entry *vmci_hash_get(struct vmci_hash_table
+                                     *table,
+                                     struct vmci_handle handle);
+void vmci_hash_hold(struct vmci_hash_table *table,
+                   struct vmci_hash_entry *entry);
+int vmci_hash_release(struct vmci_hash_table *table,
+                     struct vmci_hash_entry *entry);
+bool vmci_hash_exists(struct vmci_hash_table *table,
+                     struct vmci_handle handle);
+int vmci_hash_calc(uint32_t id, unsigned size);
+
+#endif /* _VMCI_HASH_TABLE_H_ */

