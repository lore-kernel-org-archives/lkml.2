Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422Ab2EWORZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:17:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:17504 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932915Ab2EWORV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:17:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="156126964"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, seto.hidetoshi@jp.fujitsu.com, borislav.petkov@amd.com,
        alex.shi@intel.com, tony.luck@intel.com, luto@mit.edu, riel@redhat.com,
        avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        yinghai@kernel.org, ak@linux.intel.com, jbeulich@suse.com,
        akpm@linux-foundation.org, eric.dumazet@gmail.com,
        akinobu.mita@gmail.com, cpw@sgi.com, steiner@sgi.com,
        penberg@kernel.org, a.p.zijlstra@chello.nl, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com
Subject: [PATCH v7 3/8] x86/tlb: fall back to flush all when meet a THP large page
Date: Wed, 23 May 2012 22:15:50 +0800
Message-Id: <1337782555-8088-4-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337782555-8088-1-git-send-email-alex.shi@intel.com>
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to flush large pages by PAGE_SIZE step, that just waste
time. and actually, large page don't need 'invlpg' optimizing according
to our macro benchmark. So, just flush whole TLB is enough for them.

The following result is tested on a 2CPU * 4cores * 2HT NHM EP machine,
with THP 'always' setting.

Multi-thread testing, '-t' paramter is thread number:
                       without this patch 	with this patch
./mprotect -t 1         14ns                       13ns
./mprotect -t 2         13ns                       13ns
./mprotect -t 4         12ns                       11ns
./mprotect -t 8         14ns                       10ns
./mprotect -t 16        28ns                       28ns
./mprotect -t 32        54ns                       52ns
./mprotect -t 128       200ns                      200ns

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/mm/tlb.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 7d92079..22e5bb1 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -316,12 +316,42 @@ void flush_tlb_mm(struct mm_struct *mm)
 
 #define FLUSHALL_BAR	16
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline int has_large_page(struct mm_struct *mm,
+				 unsigned long start, unsigned long end)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	unsigned long addr = ALIGN(start, HPAGE_SIZE);
+	for (; addr < end; addr += HPAGE_SIZE) {
+		pgd = pgd_offset(mm, addr);
+		if (likely(!pgd_none(*pgd))) {
+			pud = pud_offset(pgd, addr);
+			if (likely(!pud_none(*pud))) {
+				pmd = pmd_offset(pud, addr);
+				if (likely(!pmd_none(*pmd)))
+					if (pmd_large(*pmd))
+						return 1;
+			}
+		}
+	}
+	return 0;
+}
+#else
+static inline int has_large_page(struct mm_struct *mm,
+				 unsigned long start, unsigned long end)
+{
+	return 0;
+}
+#endif
 void flush_tlb_range(struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end)
 {
 	struct mm_struct *mm;
 
 	if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB) {
+flush_all:
 		flush_tlb_mm(vma->vm_mm);
 		return;
 	}
@@ -344,6 +374,10 @@ void flush_tlb_range(struct vm_area_struct *vma,
 			if ((end - start)/PAGE_SIZE > act_entries/FLUSHALL_BAR)
 				local_flush_tlb();
 			else {
+				if (has_large_page(mm, start, end)) {
+					preempt_enable();
+					goto flush_all;
+				}
 				for (addr = start; addr <= end;
 						addr += PAGE_SIZE)
 					__flush_tlb_single(addr);
-- 
1.7.5.4

