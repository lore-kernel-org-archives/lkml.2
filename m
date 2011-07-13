Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1GMFeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 01:34:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:48628 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab1GMFeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 01:34:22 -0400
Date: Wed, 13 Jul 2011 05:33:56 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-d0ead157387f19801beb1b419568723b2e9b7c79@git.kernel.org>
Cc: hans.rosenfeld@amd.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, tj@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hans.rosenfeld@amd.com, tj@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20110712074422.GA2872@htj.dyndns.org>
References: <20110712074422.GA2872@htj.dyndns.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86, mm: s/PAGES_PER_ELEMENT/PAGES_PER_SECTION/
Git-Commit-ID: d0ead157387f19801beb1b419568723b2e9b7c79
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jul 2011 05:34:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d0ead157387f19801beb1b419568723b2e9b7c79
Gitweb:     http://git.kernel.org/tip/d0ead157387f19801beb1b419568723b2e9b7c79
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 12 Jul 2011 09:44:22 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 12 Jul 2011 21:58:11 -0700

x86, mm: s/PAGES_PER_ELEMENT/PAGES_PER_SECTION/

DISCONTIGMEM on x86-32 implements pfn -> nid mapping similarly to
SPARSEMEM; however, it calls each mapping unit ELEMENT instead of
SECTION.  This patch renames it to SECTION so that PAGES_PER_SECTION
is valid for both DISCONTIGMEM and SPARSEMEM.  This will be used by
the next patch to implement mapping granularity check.

This patch is trivial constant rename.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/20110712074422.GA2872@htj.dyndns.org
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
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
