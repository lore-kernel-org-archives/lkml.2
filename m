Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab0HDFDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 01:03:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54877 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab0HDFDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 01:03:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 4 Aug 2010 13:57:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH -mm] hibernation: freeze swap at hibernation v2
Message-Id: <20100804135739.1d3ed9e2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100804083119.8b7cd3f0.kamezawa.hiroyu@jp.fujitsu.com>
References: <201007282334.08063.rjw@sisk.pl>
	<20100730131432.891df49a.kamezawa.hiroyu@jp.fujitsu.com>
	<20100802150225.851b48fe.kamezawa.hiroyu@jp.fujitsu.com>
	<201008040109.15818.rjw@sisk.pl>
	<20100804083119.8b7cd3f0.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixed description and points of hooks. maybe much clearer.

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

At taking memory snapshot in hibernate_snapshot(), all (directly called)
memory allocator uses GFP_ATOMIC. And it seems swap-misusage during
hibernation never occurs.

But, from pessimistic point of view, there is no guarantee to trust 
any page allcation doesn't have __GFP_WAIT. It's better to have an indication
"we enter hibernation, don't use swap!".

This patch tries to freeze new-swap-allocation during hibernation.
(We can trust all user processes are freezed, then, dont't take care of swapin)

By this, no updates will be happen to swap_map[] among hibernate_snapshot()
to save_image(). swap is thawed when swsusp_free() is called.
We can trust swap-corruption will never happen without any doubts.

Changelog: 2010-08-04
 - Fixed hibernation_freeze_swap/thaw_swap call points.
 - Rewrite the all description.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/swap.h     |    8 +++-
 kernel/power/hibernate.c |    1 
 kernel/power/snapshot.c  |    1 
 kernel/power/swap.c      |    6 +--
 mm/swapfile.c            |   94 ++++++++++++++++++++++++++++++++++++-----------
 5 files changed, 84 insertions(+), 26 deletions(-)

Index: mmotm-0727/include/linux/swap.h
===================================================================
--- mmotm-0727.orig/include/linux/swap.h
+++ mmotm-0727/include/linux/swap.h
@@ -316,7 +316,6 @@ extern long nr_swap_pages;
 extern long total_swap_pages;
 extern void si_swapinfo(struct sysinfo *);
 extern swp_entry_t get_swap_page(void);
-extern swp_entry_t get_swap_page_of_type(int);
 extern int valid_swaphandles(swp_entry_t, unsigned long *);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
 extern void swap_shmem_alloc(swp_entry_t);
@@ -333,6 +332,13 @@ extern int reuse_swap_page(struct page *
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
 
+#ifdef CONFIG_HIBERNATION
+void hibernation_freeze_swap(void);
+void hibernation_thaw_swap(void);
+swp_entry_t get_swap_for_hibernation(int type);
+void swap_free_for_hibernation(swp_entry_t val);
+#endif
+
 /* linux/mm/thrash.c */
 extern struct mm_struct *swap_token_mm;
 extern void grab_swap_token(struct mm_struct *);
Index: mmotm-0727/mm/swapfile.c
===================================================================
--- mmotm-0727.orig/mm/swapfile.c
+++ mmotm-0727/mm/swapfile.c
@@ -47,6 +47,8 @@ long nr_swap_pages;
 long total_swap_pages;
 static int least_priority;
 
+static bool swap_for_hibernation;
+
 static const char Bad_file[] = "Bad swap file entry ";
 static const char Unused_file[] = "Unused swap file entry ";
 static const char Bad_offset[] = "Bad swap offset entry ";
@@ -449,6 +451,8 @@ swp_entry_t get_swap_page(void)
 	spin_lock(&swap_lock);
 	if (nr_swap_pages <= 0)
 		goto noswap;
+	if (swap_for_hibernation)
+		goto noswap;
 	nr_swap_pages--;
 
 	for (type = swap_list.next; type >= 0 && wrapped < 2; type = next) {
@@ -481,28 +485,6 @@ noswap:
 	return (swp_entry_t) {0};
 }
 
-/* The only caller of this function is now susupend routine */
-swp_entry_t get_swap_page_of_type(int type)
-{
-	struct swap_info_struct *si;
-	pgoff_t offset;
-
-	spin_lock(&swap_lock);
-	si = swap_info[type];
-	if (si && (si->flags & SWP_WRITEOK)) {
-		nr_swap_pages--;
-		/* This is called for allocating swap entry, not cache */
-		offset = scan_swap_map(si, 1);
-		if (offset) {
-			spin_unlock(&swap_lock);
-			return swp_entry(type, offset);
-		}
-		nr_swap_pages++;
-	}
-	spin_unlock(&swap_lock);
-	return (swp_entry_t) {0};
-}
-
 static struct swap_info_struct *swap_info_get(swp_entry_t entry)
 {
 	struct swap_info_struct *p;
@@ -762,6 +744,74 @@ int mem_cgroup_count_swap_user(swp_entry
 #endif
 
 #ifdef CONFIG_HIBERNATION
+
+static pgoff_t hibernation_offset[MAX_SWAPFILES];
+/*
+ * Once hibernation starts to use swap, we freeze swap_map[]. Otherwise,
+ * saved swap_map[] image to the disk will be an incomplete because it's
+ * changing without synchronization with hibernation snap shot.
+ * At resume, we just make swap_for_hibernation=false. We can forget
+ * used maps easily.
+ */
+void hibernation_freeze_swap(void)
+{
+	int i;
+
+	spin_lock(&swap_lock);
+
+	printk(KERN_INFO "PM: Freeze Swap\n");
+	swap_for_hibernation = true;
+	for (i = 0; i < MAX_SWAPFILES; i++)
+		hibernation_offset[i] = 1;
+	spin_unlock(&swap_lock);
+}
+
+void hibernation_thaw_swap(void)
+{
+	spin_lock(&swap_lock);
+	if (swap_for_hibernation) {
+		printk(KERN_INFO "PM: Thaw Swap\n");
+		swap_for_hibernation = false;
+	}
+	spin_unlock(&swap_lock);
+}
+
+/*
+ * Because updateing swap_map[] can make not-saved-status-change,
+ * we use our own easy allocator.
+ * Please see kernel/power/swap.c, Used swaps are recorded into
+ * RB-tree.
+ */
+swp_entry_t get_swap_for_hibernation(int type)
+{
+	pgoff_t off;
+	swp_entry_t val = {0};
+	struct swap_info_struct *si;
+
+	spin_lock(&swap_lock);
+
+	si = swap_info[type];
+	if (!si || !(si->flags & SWP_WRITEOK))
+		goto done;
+
+	for (off = hibernation_offset[type]; off < si->max; ++off) {
+		if (!si->swap_map[off])
+			break;
+	}
+	if (off < si->max) {
+		val = swp_entry(type, off);
+		hibernation_offset[type] = off + 1;
+	}
+done:
+	spin_unlock(&swap_lock);
+	return val;
+}
+
+void swap_free_for_hibernation(swp_entry_t ent)
+{
+	/* Nothing to do */
+}
+
 /*
  * Find the swap type that corresponds to given device (if any).
  *
Index: mmotm-0727/kernel/power/swap.c
===================================================================
--- mmotm-0727.orig/kernel/power/swap.c
+++ mmotm-0727/kernel/power/swap.c
@@ -135,10 +135,10 @@ sector_t alloc_swapdev_block(int swap)
 {
 	unsigned long offset;
 
-	offset = swp_offset(get_swap_page_of_type(swap));
+	offset = swp_offset(get_swap_for_hibernation(swap));
 	if (offset) {
 		if (swsusp_extents_insert(offset))
-			swap_free(swp_entry(swap, offset));
+			swap_free_for_hibernation(swp_entry(swap, offset));
 		else
 			return swapdev_block(swap, offset);
 	}
@@ -162,7 +162,7 @@ void free_all_swap_pages(int swap)
 		ext = container_of(node, struct swsusp_extent, node);
 		rb_erase(node, &swsusp_extents);
 		for (offset = ext->start; offset <= ext->end; offset++)
-			swap_free(swp_entry(swap, offset));
+			swap_free_for_hibernation(swp_entry(swap, offset));
 
 		kfree(ext);
 	}
Index: mmotm-0727/kernel/power/hibernate.c
===================================================================
--- mmotm-0727.orig/kernel/power/hibernate.c
+++ mmotm-0727/kernel/power/hibernate.c
@@ -338,6 +338,7 @@ int hibernation_snapshot(int platform_mo
 		goto Close;
 
 	suspend_console();
+	hibernation_freeze_swap();
 	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
 	error = dpm_suspend_start(PMSG_FREEZE);
 	if (error)
Index: mmotm-0727/kernel/power/snapshot.c
===================================================================
--- mmotm-0727.orig/kernel/power/snapshot.c
+++ mmotm-0727/kernel/power/snapshot.c
@@ -1086,6 +1086,7 @@ void swsusp_free(void)
 	buffer = NULL;
 	alloc_normal = 0;
 	alloc_highmem = 0;
+	hibernation_thaw_swap();
 }
 
 /* Helper functions used for the shrinking of memory. */

