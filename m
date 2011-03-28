Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab1C1WaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 18:30:16 -0400
Received: from smtp-out.google.com ([74.125.121.67]:6384 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab1C1WaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 18:30:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=v/Wcyc2zBPgkKMJ5yE0ExHu7qopzG/jVa4HLIqOnt1xO/j4KybbVLBEZx1oEQkil41
         uFbFOGv1CKomndi+rxFw==
Date: Mon, 28 Mar 2011 15:30:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Kyle McMartin <kyle@mcmartin.ca>,
        Helge Deller <deller@gmx.de>, James Bottomley <jejb@parisc-linux.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Subject: [patch] arch, mm: filter disallowed nodes from arch specific show_mem
 functions
Message-ID: <alpine.DEB.2.00.1103281528450.7148@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures that implement their own show_mem() function did not pass
the filter argument to show_free_areas() to appropriately avoid emitting
the state of nodes that are disallowed in the current context.  This patch
now passes the filter argument to show_free_areas() so those nodes are
now avoided.

This patch also removes the show_free_areas() wrapper around
__show_free_areas() and converts existing callers to pass an empty
filter.

ia64 emits additional information for each node, so
skip_free_areas_zone() must be made global to filter disallowed nodes and
it is converted to use a nid argument rather than a zone for this use
case.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/arm/mm/init.c               |    2 +-
 arch/ia64/mm/contig.c            |   10 ++++++----
 arch/ia64/mm/discontig.c         |   10 ++++++----
 arch/parisc/mm/init.c            |    2 +-
 arch/sparc/kernel/setup_32.c     |    2 +-
 arch/sparc/mm/init_32.c          |    2 +-
 arch/unicore32/mm/init.c         |    2 +-
 drivers/net/ioc3-eth.c           |    2 +-
 drivers/tty/serial/68328serial.c |    2 +-
 include/linux/mm.h               |    6 +++---
 lib/show_mem.c                   |    2 +-
 mm/nommu.c                       |    6 +++---
 mm/page_alloc.c                  |   22 ++++++++--------------
 13 files changed, 34 insertions(+), 36 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -85,7 +85,7 @@ void show_mem(unsigned int filter)
 	struct meminfo * mi = &meminfo;
 
 	printk("Mem-info:\n");
-	show_free_areas();
+	show_free_areas(filter);
 
 	for_each_bank (i, mi) {
 		struct membank *bank = &mi->bank[i];
diff --git a/arch/ia64/mm/contig.c b/arch/ia64/mm/contig.c
--- a/arch/ia64/mm/contig.c
+++ b/arch/ia64/mm/contig.c
@@ -44,13 +44,16 @@ void show_mem(unsigned int filter)
 	pg_data_t *pgdat;
 
 	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
+	show_free_areas(filter);
 	printk(KERN_INFO "Node memory in pages:\n");
 	for_each_online_pgdat(pgdat) {
 		unsigned long present;
 		unsigned long flags;
 		int shared = 0, cached = 0, reserved = 0;
+		int nid = pgdat->node_id;
 
+		if (skip_free_areas_node(filter, nid))
+			continue;
 		pgdat_resize_lock(pgdat, &flags);
 		present = pgdat->node_present_pages;
 		for(i = 0; i < pgdat->node_spanned_pages; i++) {
@@ -64,8 +67,7 @@ void show_mem(unsigned int filter)
 				if (max_gap < LARGE_GAP)
 					continue;
 #endif
-				i = vmemmap_find_next_valid_pfn(pgdat->node_id,
-					 i) - 1;
+				i = vmemmap_find_next_valid_pfn(nid, i) - 1;
 				continue;
 			}
 			if (PageReserved(page))
@@ -81,7 +83,7 @@ void show_mem(unsigned int filter)
 		total_cached += cached;
 		total_shared += shared;
 		printk(KERN_INFO "Node %4d:  RAM: %11ld, rsvd: %8d, "
-		       "shrd: %10d, swpd: %10d\n", pgdat->node_id,
+		       "shrd: %10d, swpd: %10d\n", nid,
 		       present, reserved, shared, cached);
 	}
 	printk(KERN_INFO "%ld pages of RAM\n", total_present);
diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -622,13 +622,16 @@ void show_mem(unsigned int filter)
 	pg_data_t *pgdat;
 
 	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
+	show_free_areas(filter);
 	printk(KERN_INFO "Node memory in pages:\n");
 	for_each_online_pgdat(pgdat) {
 		unsigned long present;
 		unsigned long flags;
 		int shared = 0, cached = 0, reserved = 0;
+		int nid = pgdat->node_id;
 
+		if (skip_free_areas_node(filter, nid))
+			continue;
 		pgdat_resize_lock(pgdat, &flags);
 		present = pgdat->node_present_pages;
 		for(i = 0; i < pgdat->node_spanned_pages; i++) {
@@ -638,8 +641,7 @@ void show_mem(unsigned int filter)
 			if (pfn_valid(pgdat->node_start_pfn + i))
 				page = pfn_to_page(pgdat->node_start_pfn + i);
 			else {
-				i = vmemmap_find_next_valid_pfn(pgdat->node_id,
-					 i) - 1;
+				i = vmemmap_find_next_valid_pfn(nid, i) - 1;
 				continue;
 			}
 			if (PageReserved(page))
@@ -655,7 +657,7 @@ void show_mem(unsigned int filter)
 		total_cached += cached;
 		total_shared += shared;
 		printk(KERN_INFO "Node %4d:  RAM: %11ld, rsvd: %8d, "
-		       "shrd: %10d, swpd: %10d\n", pgdat->node_id,
+		       "shrd: %10d, swpd: %10d\n", nid,
 		       present, reserved, shared, cached);
 	}
 	printk(KERN_INFO "%ld pages of RAM\n", total_present);
diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -550,7 +550,7 @@ void show_mem(unsigned int filter)
 	int shared = 0, cached = 0;
 
 	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
+	show_free_areas(filter);
 #ifndef CONFIG_DISCONTIGMEM
 	i = max_mapnr;
 	while (i-- > 0) {
diff --git a/arch/sparc/kernel/setup_32.c b/arch/sparc/kernel/setup_32.c
--- a/arch/sparc/kernel/setup_32.c
+++ b/arch/sparc/kernel/setup_32.c
@@ -82,7 +82,7 @@ static void prom_sync_me(void)
 			     "nop\n\t" : : "r" (&trapbase));
 
 	prom_printf("PROM SYNC COMMAND...\n");
-	show_free_areas();
+	show_free_areas(0);
 	if(current->pid != 0) {
 		local_irq_enable();
 		sys_sync();
diff --git a/arch/sparc/mm/init_32.c b/arch/sparc/mm/init_32.c
--- a/arch/sparc/mm/init_32.c
+++ b/arch/sparc/mm/init_32.c
@@ -78,7 +78,7 @@ void __init kmap_init(void)
 void show_mem(unsigned int filter)
 {
 	printk("Mem-info:\n");
-	show_free_areas();
+	show_free_areas(filter);
 	printk("Free swap:       %6ldkB\n",
 	       nr_swap_pages << (PAGE_SHIFT-10));
 	printk("%ld pages of RAM\n", totalram_pages);
diff --git a/arch/unicore32/mm/init.c b/arch/unicore32/mm/init.c
--- a/arch/unicore32/mm/init.c
+++ b/arch/unicore32/mm/init.c
@@ -62,7 +62,7 @@ void show_mem(unsigned int filter)
 	struct meminfo *mi = &meminfo;
 
 	printk(KERN_DEFAULT "Mem-info:\n");
-	show_free_areas();
+	show_free_areas(filter);
 
 	for_each_bank(i, mi) {
 		struct membank *bank = &mi->bank[i];
diff --git a/drivers/net/ioc3-eth.c b/drivers/net/ioc3-eth.c
--- a/drivers/net/ioc3-eth.c
+++ b/drivers/net/ioc3-eth.c
@@ -917,7 +917,7 @@ static void ioc3_alloc_rings(struct net_device *dev)
 
 			skb = ioc3_alloc_skb(RX_BUF_ALLOC_SIZE, GFP_ATOMIC);
 			if (!skb) {
-				show_free_areas();
+				show_free_areas(0);
 				continue;
 			}
 
diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -281,7 +281,7 @@ static void receive_chars(struct m68k_serial *info, unsigned short rx)
 #ifdef CONFIG_MAGIC_SYSRQ
 			} else if (ch == 0x10) { /* ^P */
 				show_state();
-				show_free_areas();
+				show_free_areas(0);
 				show_buffers();
 /*				show_net_buffers(); */
 				return;
diff --git a/include/linux/mm.h b/include/linux/mm.h
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -861,13 +861,13 @@ extern void pagefault_out_of_memory(void);
 #define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
 
 /*
- * Flags passed to show_mem() and __show_free_areas() to suppress output in
+ * Flags passed to show_mem() and show_free_areas() to suppress output in
  * various contexts.
  */
 #define SHOW_MEM_FILTER_NODES	(0x0001u)	/* filter disallowed nodes */
 
-extern void show_free_areas(void);
-extern void __show_free_areas(unsigned int flags);
+extern void show_free_areas(unsigned int flags);
+extern bool skip_free_areas_node(unsigned int flags, int nid);
 
 int shmem_lock(struct file *file, int lock, struct user_struct *user);
 struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags);
diff --git a/lib/show_mem.c b/lib/show_mem.c
--- a/lib/show_mem.c
+++ b/lib/show_mem.c
@@ -16,7 +16,7 @@ void show_mem(unsigned int filter)
 		nonshared = 0, highmem = 0;
 
 	printk("Mem-Info:\n");
-	__show_free_areas(filter);
+	show_free_areas(filter);
 
 	for_each_online_pgdat(pgdat) {
 		unsigned long i, flags;
diff --git a/mm/nommu.c b/mm/nommu.c
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1235,7 +1235,7 @@ error_free:
 enomem:
 	printk("Allocation of length %lu from process %d (%s) failed\n",
 	       len, current->pid, current->comm);
-	show_free_areas();
+	show_free_areas(0);
 	return -ENOMEM;
 }
 
@@ -1468,14 +1468,14 @@ error_getting_vma:
 	printk(KERN_WARNING "Allocation of vma for %lu byte allocation"
 	       " from process %d failed\n",
 	       len, current->pid);
-	show_free_areas();
+	show_free_areas(0);
 	return -ENOMEM;
 
 error_getting_region:
 	printk(KERN_WARNING "Allocation of vm region for %lu byte allocation"
 	       " from process %d failed\n",
 	       len, current->pid);
-	show_free_areas();
+	show_free_areas(0);
 	return -ENOMEM;
 }
 EXPORT_SYMBOL(do_mmap_pgoff);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2446,10 +2446,10 @@ void si_meminfo_node(struct sysinfo *val, int nid)
 #endif
 
 /*
- * Determine whether the zone's node should be displayed or not, depending on
- * whether SHOW_MEM_FILTER_NODES was passed to __show_free_areas().
+ * Determine whether the node should be displayed or not, depending on whether
+ * SHOW_MEM_FILTER_NODES was passed to show_free_areas().
  */
-static bool skip_free_areas_zone(unsigned int flags, const struct zone *zone)
+bool skip_free_areas_node(unsigned int flags, int nid)
 {
 	bool ret = false;
 
@@ -2457,8 +2457,7 @@ static bool skip_free_areas_zone(unsigned int flags, const struct zone *zone)
 		goto out;
 
 	get_mems_allowed();
-	ret = !node_isset(zone->zone_pgdat->node_id,
-				cpuset_current_mems_allowed);
+	ret = !node_isset(nid, cpuset_current_mems_allowed);
 	put_mems_allowed();
 out:
 	return ret;
@@ -2473,13 +2472,13 @@ out:
  * Suppresses nodes that are not allowed by current's cpuset if
  * SHOW_MEM_FILTER_NODES is passed.
  */
-void __show_free_areas(unsigned int filter)
+void show_free_areas(unsigned int filter)
 {
 	int cpu;
 	struct zone *zone;
 
 	for_each_populated_zone(zone) {
-		if (skip_free_areas_zone(filter, zone))
+		if (skip_free_areas_node(filter, zone_to_nid(zone)))
 			continue;
 		show_node(zone);
 		printk("%s per-cpu:\n", zone->name);
@@ -2522,7 +2521,7 @@ void __show_free_areas(unsigned int filter)
 	for_each_populated_zone(zone) {
 		int i;
 
-		if (skip_free_areas_zone(filter, zone))
+		if (skip_free_areas_node(filter, zone_to_nid(zone)))
 			continue;
 		show_node(zone);
 		printk("%s"
@@ -2591,7 +2590,7 @@ void __show_free_areas(unsigned int filter)
 	for_each_populated_zone(zone) {
  		unsigned long nr[MAX_ORDER], flags, order, total = 0;
 
-		if (skip_free_areas_zone(filter, zone))
+		if (skip_free_areas_node(filter, zone_to_nid(zone)))
 			continue;
 		show_node(zone);
 		printk("%s: ", zone->name);
@@ -2612,11 +2611,6 @@ void __show_free_areas(unsigned int filter)
 	show_swap_cache_info();
 }
 
-void show_free_areas(void)
-{
-	__show_free_areas(0);
-}
-
 static void zoneref_set_zone(struct zone *zone, struct zoneref *zoneref)
 {
 	zoneref->zone = zone;
