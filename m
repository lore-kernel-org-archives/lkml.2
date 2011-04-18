Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab1DRMSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 08:18:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51651 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1DRMSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 08:18:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 2/3] tile: replace mm->cpu_vm_mask with mm_cpumask()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Chris Metcalf <cmetcalf@tilera.com>
In-Reply-To: <20110418211455.9359.A69D9226@jp.fujitsu.com>
References: <20110418211455.9359.A69D9226@jp.fujitsu.com>
Message-Id: <20110418211914.9361.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 18 Apr 2011 21:18:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We plan to change mm->cpu_vm_mask definition later. Thus, this patch convert
it into proper macro.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/mmu_context.h |    4 ++--
 arch/tile/kernel/tlb.c              |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

tile is one of last two cpu_vm_mask direct access users. I hope convert it
even if anyone refuse [path 3/3].

Chris, I couldn't get cross compiler for tile. thus I hope you check it carefully.
Thanks.

diff --git a/arch/tile/include/asm/mmu_context.h b/arch/tile/include/asm/mmu_context.h
index 9bc0d07..15fb246 100644
--- a/arch/tile/include/asm/mmu_context.h
+++ b/arch/tile/include/asm/mmu_context.h
@@ -100,8 +100,8 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		__get_cpu_var(current_asid) = asid;
 
 		/* Clear cpu from the old mm, and set it in the new one. */
-		cpumask_clear_cpu(cpu, &prev->cpu_vm_mask);
-		cpumask_set_cpu(cpu, &next->cpu_vm_mask);
+		cpumask_clear_cpu(cpu, mm_cpumask(prev));
+		cpumask_set_cpu(cpu, mm_cpumask(next));
 
 		/* Re-load page tables */
 		install_page_table(next->pgd, asid);
diff --git a/arch/tile/kernel/tlb.c b/arch/tile/kernel/tlb.c
index 2dffc10..a5f241c 100644
--- a/arch/tile/kernel/tlb.c
+++ b/arch/tile/kernel/tlb.c
@@ -34,13 +34,13 @@ void flush_tlb_mm(struct mm_struct *mm)
 {
 	HV_Remote_ASID asids[NR_CPUS];
 	int i = 0, cpu;
-	for_each_cpu(cpu, &mm->cpu_vm_mask) {
+	for_each_cpu(cpu, mm_cpumask(mm)) {
 		HV_Remote_ASID *asid = &asids[i++];
 		asid->y = cpu / smp_topology.width;
 		asid->x = cpu % smp_topology.width;
 		asid->asid = per_cpu(current_asid, cpu);
 	}
-	flush_remote(0, HV_FLUSH_EVICT_L1I, &mm->cpu_vm_mask,
+	flush_remote(0, HV_FLUSH_EVICT_L1I, mm_cpumask(mm),
 		     0, 0, 0, NULL, asids, i);
 }
 
@@ -54,8 +54,8 @@ void flush_tlb_page_mm(const struct vm_area_struct *vma, struct mm_struct *mm,
 {
 	unsigned long size = hv_page_size(vma);
 	int cache = (vma->vm_flags & VM_EXEC) ? HV_FLUSH_EVICT_L1I : 0;
-	flush_remote(0, cache, &mm->cpu_vm_mask,
-		     va, size, size, &mm->cpu_vm_mask, NULL, 0);
+	flush_remote(0, cache, mm_cpumask(mm),
+		     va, size, size, mm_cpumask(mm), NULL, 0);
 }
 
 void flush_tlb_page(const struct vm_area_struct *vma, unsigned long va)
@@ -70,8 +70,8 @@ void flush_tlb_range(const struct vm_area_struct *vma,
 	unsigned long size = hv_page_size(vma);
 	struct mm_struct *mm = vma->vm_mm;
 	int cache = (vma->vm_flags & VM_EXEC) ? HV_FLUSH_EVICT_L1I : 0;
-	flush_remote(0, cache, &mm->cpu_vm_mask, start, end - start, size,
-		     &mm->cpu_vm_mask, NULL, 0);
+	flush_remote(0, cache, mm_cpumask(mm), start, end - start, size,
+		     mm_cpumask(mm), NULL, 0);
 }
 
 void flush_tlb_all(void)
-- 
1.7.3.1



