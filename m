Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab1BPAVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:21:36 -0500
Received: from kroah.org ([198.145.64.141]:39306 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757131Ab1BPAVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:37 2011
Message-Id: <20110216001437.244167945@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Milton Miller <miltonm@bga.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: [122/272] mm: migration: use rcu_dereference_protected when dereferencing the radix tree slot during file page migration
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mel Gorman <mel@csn.ul.ie>

commit 29c1f677d424e8c5683a837fc4f03fc9f19201d7 upstream.

migrate_pages() -> unmap_and_move() only calls rcu_read_lock() for
anonymous pages, as introduced by git commit
989f89c57e6361e7d16fbd9572b5da7d313b073d ("fix rcu_read_lock() in page
migraton").  The point of the RCU protection there is part of getting a
stable reference to anon_vma and is only held for anon pages as file pages
are locked which is sufficient protection against freeing.

However, while a file page's mapping is being migrated, the radix tree is
double checked to ensure it is the expected page.  This uses
radix_tree_deref_slot() -> rcu_dereference() without the RCU lock held
triggering the following warning.

[  173.674290] ===================================================
[  173.676016] [ INFO: suspicious rcu_dereference_check() usage. ]
[  173.676016] ---------------------------------------------------
[  173.676016] include/linux/radix-tree.h:145 invoked rcu_dereference_check() without protection!
[  173.676016]
[  173.676016] other info that might help us debug this:
[  173.676016]
[  173.676016]
[  173.676016] rcu_scheduler_active = 1, debug_locks = 0
[  173.676016] 1 lock held by hugeadm/2899:
[  173.676016]  #0:  (&(&inode->i_data.tree_lock)->rlock){..-.-.}, at: [<c10e3d2b>] migrate_page_move_mapping+0x40/0x1ab
[  173.676016]
[  173.676016] stack backtrace:
[  173.676016] Pid: 2899, comm: hugeadm Not tainted 2.6.37-rc5-autobuild
[  173.676016] Call Trace:
[  173.676016]  [<c128cc01>] ? printk+0x14/0x1b
[  173.676016]  [<c1063502>] lockdep_rcu_dereference+0x7d/0x86
[  173.676016]  [<c10e3db5>] migrate_page_move_mapping+0xca/0x1ab
[  173.676016]  [<c10e41ad>] migrate_page+0x23/0x39
[  173.676016]  [<c10e491b>] buffer_migrate_page+0x22/0x107
[  173.676016]  [<c10e48f9>] ? buffer_migrate_page+0x0/0x107
[  173.676016]  [<c10e425d>] move_to_new_page+0x9a/0x1ae
[  173.676016]  [<c10e47e6>] migrate_pages+0x1e7/0x2fa

This patch introduces radix_tree_deref_slot_protected() which calls
rcu_dereference_protected().  Users of it must pass in the
mapping->tree_lock that is protecting this dereference.  Holding the tree
lock protects against parallel updaters of the radix tree meaning that
rcu_dereference_protected is allowable.

[akpm@linux-foundation.org: remove unneeded casts]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Milton Miller <miltonm@bga.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/radix-tree.h |   16 ++++++++++++++++
 mm/migrate.c               |    4 ++--
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -146,6 +146,22 @@ static inline void *radix_tree_deref_slo
 }
 
 /**
+ * radix_tree_deref_slot_protected	- dereference a slot without RCU lock but with tree lock held
+ * @pslot:	pointer to slot, returned by radix_tree_lookup_slot
+ * Returns:	item that was stored in that slot with any direct pointer flag
+ *		removed.
+ *
+ * Similar to radix_tree_deref_slot but only used during migration when a pages
+ * mapping is being moved. The caller does not hold the RCU read lock but it
+ * must hold the tree lock to prevent parallel updates.
+ */
+static inline void *radix_tree_deref_slot_protected(void **pslot,
+							spinlock_t *treelock)
+{
+	return rcu_dereference_protected(*pslot, lockdep_is_held(treelock));
+}
+
+/**
  * radix_tree_deref_retry	- check radix_tree_deref_slot
  * @arg:	pointer returned by radix_tree_deref_slot
  * Returns:	0 if retry is not required, otherwise retry is required
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -246,7 +246,7 @@ static int migrate_page_move_mapping(str
 
 	expected_count = 2 + page_has_private(page);
 	if (page_count(page) != expected_count ||
-			(struct page *)radix_tree_deref_slot(pslot) != page) {
+		radix_tree_deref_slot_protected(pslot, &mapping->tree_lock) != page) {
 		spin_unlock_irq(&mapping->tree_lock);
 		return -EAGAIN;
 	}
@@ -318,7 +318,7 @@ int migrate_huge_page_move_mapping(struc
 
 	expected_count = 2 + page_has_private(page);
 	if (page_count(page) != expected_count ||
-	    (struct page *)radix_tree_deref_slot(pslot) != page) {
+		radix_tree_deref_slot_protected(pslot, &mapping->tree_lock) != page) {
 		spin_unlock_irq(&mapping->tree_lock);
 		return -EAGAIN;
 	}


