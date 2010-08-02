Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab0HBGH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 02:07:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55354 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab0HBGHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 02:07:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 2 Aug 2010 15:02:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFC][PATCH -mm] hibernation: freeze swap at hibernation (Was Re:
 Memory corruption during hibernation since 2.6.31
Message-Id: <20100802150225.851b48fe.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100730131432.891df49a.kamezawa.hiroyu@jp.fujitsu.com>
References: <201007282334.08063.rjw@sisk.pl>
	<20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
	<20100729142245.4AA5.A69D9226@jp.fujitsu.com>
	<20100729142429.58b49dce.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
	<20100730090146.7e65d1c1.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTing_3HoC9oWNheHJPgQWp2xmN6-C_cyZxoJUqc_@mail.gmail.com>
	<20100730131432.891df49a.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jul 2010 13:14:32 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 29 Jul 2010 21:10:10 -0700
> Hugh Dickins <hughd@google.com> wrote:
> 
> > On Thu, Jul 29, 2010 at 5:01 PM, KAMEZAWA Hiroyuki
> > <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > I think the best way is kexec(). But maybe rollback from hibernation failure
> > > will be difficult. Considering how crash-dump works well and under maintainance
> > > by many enterprise guys, hibernation-by-kexec is a choice. I think. It can make
> > > reuse of kdump code, ...or, hibernation-resume code can eat kdump image
> > > directly. Maybe the problem will be the speed of dump.
> > 
> > I've no appetite for a total rework of hibernation, and I don't see
> > how that would
> > address the issue: I'm just looking for some protection against swap
> > reuse danger.
> > 
> Okay ;) (And I forget that kexec has to prepare memory at boot time for 2nd kernel.
> It will be harmful for small device guys.)
> 
> I'll prepare a routine not-quick-fix.

Ok, here. Passed easy tests as
# echo disk > /sys/power/state


Looks like a big hammer ? But I think following kind of patch is required.
About swap-reuse, it's only possible when a page is added to swap cache
but try_to_unmap() fails and the page remains in memory. IIUC, most of this
kind of pages will be backed to swap by shrink_all_memory(). So, reuse-swap
happens only when the user unlucky. This patch ignores reuse-swap but freeze
swap_map[] for saving swap_map[] to the disk in consistent way.

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

swap_map[] is a one of objects which can be update while hibernation. I.E,
usage counter in swap_map[] is updated while hibernation is making a copy
of memory image to the disk.

At resume, hibenation code doesn't call swap_free() against the swaps they
used...So, the swap_map[] will turns to be an initial state.

With small consideration, the question is how swap_map[] updated before
dumping to the disk is treated. In swap-system view, there are no guarantee
that swap_map[] are properly reloaded and there is no leak in swap count.

This patch tries to freeze swap_map[] during hibernation.
By this, no updates will be happen to swap_map[] among save_image().
At load_image(), the swap_map[] has no record for swap entries used by
save_image(), we can simply forget it.

Note: I'm not a specialist of hibernation...so, I'm not sure the hooks
      to kernel/power/user.c is appropriate or not.
      And this disables swap-out once hibernation starts saving.
      Should we afraid of OOM ?

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/swap.h |    7 +++
 kernel/power/swap.c  |   15 ++++++--
 kernel/power/user.c  |    1 
 mm/swapfile.c        |   93 ++++++++++++++++++++++++++++++++++++++-------------
 4 files changed, 90 insertions(+), 26 deletions(-)

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
@@ -333,6 +332,12 @@ extern int reuse_swap_page(struct page *
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
 
+#ifdef CONFIG_HIBERNATION
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
@@ -762,6 +744,73 @@ int mem_cgroup_count_swap_user(swp_entry
 #endif
 
 #ifdef CONFIG_HIBERNATION
+
+static pgoff_t hibernation_offset[MAX_SWAPFILES];
+static void hibernation_freeze_swap(void)
+{
+	int i;
+
+	printk(KERN_INFO "PM: Freeze Swap\n");
+	swap_for_hibernation = true;
+	for (i = 0; i < MAX_SWAPFILES; i++)
+		hibernation_offset[i] = 1;
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
+	/*
+	 * Once hibernation starts to use swap, we freeze swap_map[]. Otherwise,
+	 * saved swap_map[] image to the disk will be an incomplete because it's
+	 * changing without synchronization with hibernation snap shot.
+	 * At resume, we just make swap_for_hibernation=false. We can forget
+	 * used maps easily.
+	 */
+	if (!swap_for_hibernation)
+		hibernation_freeze_swap();
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
@@ -162,10 +162,11 @@ void free_all_swap_pages(int swap)
 		ext = container_of(node, struct swsusp_extent, node);
 		rb_erase(node, &swsusp_extents);
 		for (offset = ext->start; offset <= ext->end; offset++)
-			swap_free(swp_entry(swap, offset));
+			swap_free_for_hibernation(swp_entry(swap, offset));
 
 		kfree(ext);
 	}
+	hibernation_thaw_swap();
 }
 
 int swsusp_swap_in_use(void)
@@ -440,10 +441,12 @@ int swsusp_write(unsigned int flags)
 	error = get_swap_writer(&handle);
 	if (error) {
 		printk(KERN_ERR "PM: Cannot get swap writer\n");
+		hibernation_thaw_swap();
 		return error;
 	}
 	if (!enough_swap(pages)) {
 		printk(KERN_ERR "PM: Not enough free swap\n");
+		hibernation_thaw_swap();
 		error = -ENOSPC;
 		goto out_finish;
 	}
@@ -461,6 +464,8 @@ int swsusp_write(unsigned int flags)
 		error = save_image(&handle, &snapshot, pages - 1);
 out_finish:
 	error = swap_writer_finish(&handle, flags, error);
+	if (error)
+		hibernation_thaw_swap();
 	return error;
 }
 
@@ -614,6 +619,10 @@ int swsusp_read(unsigned int *flags_p)
 	if (!error)
 		error = load_image(&handle, &snapshot, header->pages - 1);
 	swap_reader_finish(&handle);
+	/*
+	 * When we saved kernel image, swap is freezed, thaw it.
+	 */
+	hibernation_thaw_swap();
 end:
 	if (!error)
 		pr_debug("PM: Image successfully loaded\n");
Index: mmotm-0727/kernel/power/user.c
===================================================================
--- mmotm-0727.orig/kernel/power/user.c
+++ mmotm-0727/kernel/power/user.c
@@ -135,6 +135,7 @@ static int snapshot_release(struct inode
 	free_basic_memory_bitmaps();
 	data = filp->private_data;
 	free_all_swap_pages(data->swap);
+	hibernation_thaw_swap();
 	if (data->frozen)
 		thaw_processes();
 	pm_notifier_call_chain(data->mode == O_WRONLY ?


