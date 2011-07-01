Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab1GAQXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:23:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32928 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144Ab1GAQWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:22:44 -0400
Date: Fri, 1 Jul 2011 18:22:39 +0200
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Conny Seidel <conny.seidel@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH x86/urgent 1/2] x86: s/PAGES_PER_ELEMENT/PAGES_PER_SECTION/
Message-ID: <20110701162239.GX3386@htj.dyndns.org>
References: <20110621174131.054f0422.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110626102235.GC12200@mtj.dyndns.org>
 <20110626223807.47cef5c6.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110628174613.GP478@escobedo.osrc.amd.com>
 <20110629094451.GJ3386@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629094451.GJ3386@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DISCONTIGMEM on x86-32 implements pfn -> nid mapping similarly to
SPARSEMEM; however, it calls each mapping unit ELEMENT instead of
SECTION.  This patch renames it to SECTION so that PAGES_PER_SECTION
is valid for both DISCONTIGMEM and SPARSEMEM.  This will be used by
the next patch to implement mapping granularity check.

This patch is trivial constant rename.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/mmzone_32.h |    6 +++---
 arch/x86/mm/numa_32.c            |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

Index: work/arch/x86/include/asm/mmzone_32.h
===================================================================
--- work.orig/arch/x86/include/asm/mmzone_32.h
+++ work/arch/x86/include/asm/mmzone_32.h
@@ -34,15 +34,15 @@ static inline void resume_map_numa_kva(p
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
Index: work/arch/x86/mm/numa_32.c
===================================================================
--- work.orig/arch/x86/mm/numa_32.c
+++ work/arch/x86/mm/numa_32.c
@@ -41,7 +41,7 @@
  *     physnode_map[16-31] = 1;
  *     physnode_map[32- ] = -1;
  */
-s8 physnode_map[MAX_ELEMENTS] __read_mostly = { [0 ... (MAX_ELEMENTS - 1)] = -1};
+s8 physnode_map[MAX_SECTIONS] __read_mostly = { [0 ... (MAX_SECTIONS - 1)] = -1};
 EXPORT_SYMBOL(physnode_map);
 
 void memory_present(int nid, unsigned long start, unsigned long end)
@@ -52,8 +52,8 @@ void memory_present(int nid, unsigned lo
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
