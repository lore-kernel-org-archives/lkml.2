Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab2D1IxI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 04:53:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:29098 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781Ab2D1IxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 04:53:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="134675372"
From: Alex Shi <alex.shi@intel.com>
To: andi.kleen@intel.com, tim.c.chen@linux.intel.com, jeremy@goop.org,
        chrisw@sous-sol.org, akataria@vmware.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com
Cc: riel@redhat.com, luto@mit.edu, alex.shi@intel.com, avi@redhat.com,
        len.brown@intel.com, paul.gortmaker@windriver.com, dhowells@redhat.com,
        fenghua.yu@intel.com, borislav.petkov@amd.com, yinghai@kernel.org,
        cpw@sgi.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com
Subject: [PATCH 3/3] x86/tlb: fall back to flush all when meet a THP large page
Date: Sat, 28 Apr 2012 16:51:39 +0800
Message-Id: <1335603099-2624-4-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335603099-2624-1-git-send-email-alex.shi@intel.com>
References: <1335603099-2624-1-git-send-email-alex.shi@intel.com>
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
 arch/x86/mm/tlb.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index c4e694d..049fcdf 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -316,12 +316,20 @@ void flush_tlb_mm(struct mm_struct *mm)
 
 #define FLUSHALL_BAR	16
 
+/* Is better to have a vm_flags to show if large pages exist in a VMA? */
+static inline int in_large_page(struct mm_struct *mm, unsigned long addr){
+	pmd_t *pmd;
+	pmd = pmd_offset(pud_offset(pgd_offset(mm, addr), addr), addr);
+	return pmd_large(*pmd);
+}
+
 void flush_tlb_range(struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end)
 {
 	struct mm_struct *mm;
 
 	if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB) {
+flush_all:
 		flush_tlb_mm(vma->vm_mm);
 		return;
 	}
@@ -345,9 +353,15 @@ void flush_tlb_range(struct vm_area_struct *vma,
 				local_flush_tlb();
 			else {
 				for (addr = start; addr <= end;
-						addr += PAGE_SIZE)
+						addr += HPAGE_SIZE)
+					if (in_large_page(mm, addr)) {
+						preempt_enable();
+						goto flush_all;
+					}
+				for (addr = start; addr <= end;
+						addr += PAGE_SIZE) {
 					__flush_tlb_single(addr);
-
+				}
 				if (cpumask_any_but(mm_cpumask(mm),
 					smp_processor_id()) < nr_cpu_ids)
 					flush_tlb_others(mm_cpumask(mm), mm,
-- 
1.7.5.4

