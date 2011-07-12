Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365Ab1GLHo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 03:44:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46822 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab1GLHo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 03:44:27 -0400
Date: Tue, 12 Jul 2011 09:44:22 +0200
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Conny Seidel <conny.seidel@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH x86/mm 1/2] x86: s/PAGES_PER_ELEMENT/PAGES_PER_SECTION/
Message-ID: <20110712074422.GA2872@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9f5e6296923d7cf47738dfcd38ab9e333d3fd356 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 1 Jul 2011 18:22:39 +0200

DISCONTIGMEM on x86-32 implements pfn -> nid mapping similarly to
SPARSEMEM; however, it calls each mapping unit ELEMENT instead of
SECTION.  This patch renames it to SECTION so that PAGES_PER_SECTION
is valid for both DISCONTIGMEM and SPARSEMEM.  This will be used by
the next patch to implement mapping granularity check.

This patch is trivial constant rename.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
This one is identical as the original posting[1].  Only the second
patch is updated.  Please schedule for 3.1-rc1.  Also available on the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-x86-mm-base

Thanks.

[1] http://thread.gmane.org/gmane.linux.kernel/1161279/focus=1162583

 arch/x86/include/asm/mmzone_32.h |    6 +++---
 arch/x86/mm/numa_32.c            |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/mmzone_32.h b/arch/x86/include/asm/mmzone_32.h
index ffa037f..55728e1 100644
--- a/arch/x86/include/asm/mmzone_32.h
+++ b/arch/x86/include/asm/mmzone_32.h
@@ -34,15 +34,15 @@ static inline void resume_map_numa_kva(pgd_t *pgd) {}
  *    64Gb / 4096bytes/page = 16777216 pages
  */
 #define MAX_NR_PAGES 16777216
-#define MAX_ELEMENTS 1024
-#define PAGES_PER_ELEMENT (MAX_NR_PAGES/MAX_ELEMENTS)
+#define MAX_SECTIONS 1024
+#define PAGES_PER_SECTION (MAX_NR_PAGES/MAX_SECTIONS)
 
 extern s8 physnode_map[];
 
 static inline int pfn_to_nid(unsigned long pfn)
 {
 #ifdef CONFIG_NUMA
-	return((int) physnode_map[(pfn) / PAGES_PER_ELEMENT]);
+	return((int) physnode_map[(pfn) / PAGES_PER_SECTION]);
 #else
 	return 0;
 #endif
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 849a975..3adebe7 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -41,7 +41,7 @@
  *     physnode_map[16-31] = 1;
  *     physnode_map[32- ] = -1;
  */
-s8 physnode_map[MAX_ELEMENTS] __read_mostly = { [0 ... (MAX_ELEMENTS - 1)] = -1};
+s8 physnode_map[MAX_SECTIONS] __read_mostly = { [0 ... (MAX_SECTIONS - 1)] = -1};
 EXPORT_SYMBOL(physnode_map);
 
 void memory_present(int nid, unsigned long start, unsigned long end)
@@ -52,8 +52,8 @@ void memory_present(int nid, unsigned long start, unsigned long end)
 			nid, start, end);
 	printk(KERN_DEBUG "  Setting physnode_map array to node %d for pfns:\n", nid);
 	printk(KERN_DEBUG "  ");
-	for (pfn = start; pfn < end; pfn += PAGES_PER_ELEMENT) {
-		physnode_map[pfn / PAGES_PER_ELEMENT] = nid;
+	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
+		physnode_map[pfn / PAGES_PER_SECTION] = nid;
 		printk(KERN_CONT "%lx ", pfn);
 	}
 	printk(KERN_CONT "\n");
-- 
1.7.6

