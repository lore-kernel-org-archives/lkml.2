Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab1GMFek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 01:34:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:48640 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab1GMFei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 01:34:38 -0400
Date: Wed, 13 Jul 2011 05:34:25 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-1e01979c8f502ac13e3cdece4f38712c5944e6e8@git.kernel.org>
Cc: hans.rosenfeld@amd.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, conny.seidel@amd.com, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hans.rosenfeld@amd.com, conny.seidel@amd.com, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20110628174613.GP478@escobedo.osrc.amd.com>
References: <20110712074534.GB2872@htj.dyndns.org>
	<20110628174613.GP478@escobedo.osrc.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86, numa: Implement pfn -> nid mapping granularity check
Git-Commit-ID: 1e01979c8f502ac13e3cdece4f38712c5944e6e8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jul 2011 05:34:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e01979c8f502ac13e3cdece4f38712c5944e6e8
Gitweb:     http://git.kernel.org/tip/1e01979c8f502ac13e3cdece4f38712c5944e6e8
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 12 Jul 2011 09:45:34 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 12 Jul 2011 21:58:29 -0700

x86, numa: Implement pfn -> nid mapping granularity check

SPARSEMEM w/o VMEMMAP and DISCONTIGMEM, both used only on 32bit, use
sections array to map pfn to nid which is limited in granularity.  If
NUMA nodes are laid out such that the mapping cannot be accurate, boot
will fail triggering BUG_ON() in mminit_verify_page_links().

On 32bit, it's 512MiB w/ PAE and SPARSEMEM.  This seems to have been
granular enough until commit 2706a0bf7b (x86, NUMA: Enable
CONFIG_AMD_NUMA on 32bit too).  Apparently, there is a machine which
aligns NUMA nodes to 128MiB and has only AMD NUMA but not SRAT.  This
led to the following BUG_ON().

 On node 0 totalpages: 2096615
   DMA zone: 32 pages used for memmap
   DMA zone: 0 pages reserved
   DMA zone: 3927 pages, LIFO batch:0
   Normal zone: 1740 pages used for memmap
   Normal zone: 220978 pages, LIFO batch:31
   HighMem zone: 16405 pages used for memmap
   HighMem zone: 1853533 pages, LIFO batch:31
 BUG: Int 6: CR2   (null)
      EDI   (null)  ESI 00000002  EBP 00000002  ESP c1543ecc
      EBX f2400000  EDX 00000006  ECX   (null)  EAX 00000001
      err   (null)  EIP c16209aa   CS 00000060  flg 00010002
 Stack: f2400000 00220000 f7200800 c1620613 00220000 01000000 04400000 00238000
          (null) f7200000 00000002 f7200b58 f7200800 c1620929 000375fe   (null)
        f7200b80 c16395f0 00200a02 f7200a80   (null) 000375fe 00000002   (null)
 Pid: 0, comm: swapper Not tainted 2.6.39-rc5-00181-g2706a0b #17
 Call Trace:
  [<c136b1e5>] ? early_fault+0x2e/0x2e
  [<c16209aa>] ? mminit_verify_page_links+0x12/0x42
  [<c1620613>] ? memmap_init_zone+0xaf/0x10c
  [<c1620929>] ? free_area_init_node+0x2b9/0x2e3
  [<c1607e99>] ? free_area_init_nodes+0x3f2/0x451
  [<c1601d80>] ? paging_init+0x112/0x118
  [<c15f578d>] ? setup_arch+0x791/0x82f
  [<c15f43d9>] ? start_kernel+0x6a/0x257

This patch implements node_map_pfn_alignment() which determines
maximum internode alignment and update numa_register_memblks() to
reject NUMA configuration if alignment exceeds the pfn -> nid mapping
granularity of the memory model as determined by PAGES_PER_SECTION.

This makes the problematic machine boot w/ flatmem by rejecting the
NUMA config and provides protection against crazy NUMA configurations.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/20110712074534.GB2872@htj.dyndns.org
LKML-Reference: <20110628174613.GP478@escobedo.osrc.amd.com>
Reported-and-Tested-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Conny Seidel <conny.seidel@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa.c |   15 ++++++++++++++
 include/linux/mm.h |    1 +
 mm/page_alloc.c    |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index f5510d8..fbeaaf4 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -496,6 +496,7 @@ static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
 
 static int __init numa_register_memblks(struct numa_meminfo *mi)
 {
+	unsigned long uninitialized_var(pfn_align);
 	int i, nid;
 
 	/* Account for nodes with cpus and no memory */
@@ -511,6 +512,20 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 
 	/* for out of order entries */
 	sort_node_map();
+
+	/*
+	 * If sections array is gonna be used for pfn -> nid mapping, check
+	 * whether its granularity is fine enough.
+	 */
+#ifdef NODE_NOT_IN_PAGE_FLAGS
+	pfn_align = node_map_pfn_alignment();
+	if (pfn_align && pfn_align < PAGES_PER_SECTION) {
+		printk(KERN_WARNING "Node alignment %LuMB < min %LuMB, rejecting NUMA config\n",
+		       PFN_PHYS(pfn_align) >> 20,
+		       PFN_PHYS(PAGES_PER_SECTION) >> 20);
+		return -EINVAL;
+	}
+#endif
 	if (!numa_meminfo_cover_memory(mi))
 		return -EINVAL;
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9670f71..c70a326 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1313,6 +1313,7 @@ extern void remove_active_range(unsigned int nid, unsigned long start_pfn,
 					unsigned long end_pfn);
 extern void remove_all_active_ranges(void);
 void sort_node_map(void);
+unsigned long node_map_pfn_alignment(void);
 unsigned long __absent_pages_in_range(int nid, unsigned long start_pfn,
 						unsigned long end_pfn);
 extern unsigned long absent_pages_in_range(unsigned long start_pfn,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4e8985a..9119faa 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4585,6 +4585,60 @@ void __init sort_node_map(void)
 			cmp_node_active_region, NULL);
 }
 
+/**
+ * node_map_pfn_alignment - determine the maximum internode alignment
+ *
+ * This function should be called after node map is populated and sorted.
+ * It calculates the maximum power of two alignment which can distinguish
+ * all the nodes.
+ *
+ * For example, if all nodes are 1GiB and aligned to 1GiB, the return value
+ * would indicate 1GiB alignment with (1 << (30 - PAGE_SHIFT)).  If the
+ * nodes are shifted by 256MiB, 256MiB.  Note that if only the last node is
+ * shifted, 1GiB is enough and this function will indicate so.
+ *
+ * This is used to test whether pfn -> nid mapping of the chosen memory
+ * model has fine enough granularity to avoid incorrect mapping for the
+ * populated node map.
+ *
+ * Returns the determined alignment in pfn's.  0 if there is no alignment
+ * requirement (single node).
+ */
+unsigned long __init node_map_pfn_alignment(void)
+{
+	unsigned long accl_mask = 0, last_end = 0;
+	int last_nid = -1;
+	int i;
+
+	for_each_active_range_index_in_nid(i, MAX_NUMNODES) {
+		int nid = early_node_map[i].nid;
+		unsigned long start = early_node_map[i].start_pfn;
+		unsigned long end = early_node_map[i].end_pfn;
+		unsigned long mask;
+
+		if (!start || last_nid < 0 || last_nid == nid) {
+			last_nid = nid;
+			last_end = end;
+			continue;
+		}
+
+		/*
+		 * Start with a mask granular enough to pin-point to the
+		 * start pfn and tick off bits one-by-one until it becomes
+		 * too coarse to separate the current node from the last.
+		 */
+		mask = ~((1 << __ffs(start)) - 1);
+		while (mask && last_end <= (start & (mask << 1)))
+			mask <<= 1;
+
+		/* accumulate all internode masks */
+		accl_mask |= mask;
+	}
+
+	/* convert mask to number of pages */
+	return ~accl_mask + 1;
+}
+
 /* Find the lowest pfn for a node */
 static unsigned long __init find_min_pfn_for_node(int nid)
 {
