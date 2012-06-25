Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab2FYGLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 02:11:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:27904 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab2FYGLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 02:11:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="162132976"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, alex.shi@intel.com, luto@mit.edu, yinghai@kernel.org,
        riel@redhat.com, avi@redhat.com, len.brown@intel.com, tj@kernel.org,
        akpm@linux-foundation.org, cl@gentwo.org, borislav.petkov@amd.com,
        ak@linux.intel.com, jbeulich@suse.com, eric.dumazet@gmail.com,
        akinobu.mita@gmail.com, vapier@gentoo.org, cpw@sgi.com,
        steiner@sgi.com, viro@zeniv.linux.org.uk,
        kamezawa.hiroyu@jp.fujitsu.com, rientjes@google.com,
        aarcange@redhat.com, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com
Subject: [PATCH v9 3/9] x86/tlb: fall back to flush all when meet a THP large page
Date: Mon, 25 Jun 2012 14:08:21 +0800
Message-Id: <1340604507-11214-4-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340604507-11214-1-git-send-email-alex.shi@intel.com>
References: <1340604507-11214-1-git-send-email-alex.shi@intel.com>
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
index 3b91c98..184a02a 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -318,12 +318,42 @@ void flush_tlb_mm(struct mm_struct *mm)
 
 #define FLUSHALL_BAR	16
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline unsigned long has_large_page(struct mm_struct *mm,
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
+						return addr;
+			}
+		}
+	}
+	return 0;
+}
+#else
+static inline unsigned long has_large_page(struct mm_struct *mm,
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
@@ -346,6 +376,10 @@ void flush_tlb_range(struct vm_area_struct *vma,
 			if ((end - start)/PAGE_SIZE > act_entries/FLUSHALL_BAR)
 				local_flush_tlb();
 			else {
+				if (has_large_page(mm, start, end)) {
+					preempt_enable();
+					goto flush_all;
+				}
 				for (addr = start; addr < end;
 						addr += PAGE_SIZE)
 					__flush_tlb_single(addr);
-- 
1.7.5.4

