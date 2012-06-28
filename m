Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab2F1Pk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 11:40:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59641 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab2F1Pk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 11:40:27 -0400
Date: Thu, 28 Jun 2012 08:40:16 -0700
From: tip-bot for Alex Shi <alex.shi@intel.com>
Message-ID: <tip-c4211f42d3e66875298a5e26a75109878c80f15b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        alex.shi@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, alex.shi@intel.com
In-Reply-To: <1340845344-27557-5-git-send-email-alex.shi@intel.com>
References: <1340845344-27557-5-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/tlb: add tlb_flushall_shift for specific CPU
Git-Commit-ID: c4211f42d3e66875298a5e26a75109878c80f15b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 28 Jun 2012 08:40:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4211f42d3e66875298a5e26a75109878c80f15b
Gitweb:     http://git.kernel.org/tip/c4211f42d3e66875298a5e26a75109878c80f15b
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Thu, 28 Jun 2012 09:02:19 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 27 Jun 2012 19:29:10 -0700

x86/tlb: add tlb_flushall_shift for specific CPU

Testing show different CPU type(micro architectures and NUMA mode) has
different balance points between the TLB flush all and multiple invlpg.
And there also has cases the tlb flush change has no any help.

This patch give a interface to let x86 vendor developers have a chance
to set different shift for different CPU type.

like some machine in my hands, balance points is 16 entries on
Romely-EP; while it is at 8 entries on Bloomfield NHM-EP; and is 256 on
IVB mobile CPU. but on model 15 core2 Xeon using invlpg has nothing
help.

For untested machine, do a conservative optimization, same as NHM CPU.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Link: http://lkml.kernel.org/r/1340845344-27557-5-git-send-email-alex.shi@intel.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/kernel/cpu/common.c     |   14 ++++++++++++--
 arch/x86/kernel/cpu/intel.c      |   34 ++++++++++++++++++++++++++++++++++
 arch/x86/mm/tlb.c                |    7 +++----
 include/asm-generic/tlb.h        |    3 ++-
 5 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 39b2bd4..d048cad 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -72,6 +72,8 @@ extern u16 __read_mostly tlb_lli_4m[NR_INFO];
 extern u16 __read_mostly tlb_lld_4k[NR_INFO];
 extern u16 __read_mostly tlb_lld_2m[NR_INFO];
 extern u16 __read_mostly tlb_lld_4m[NR_INFO];
+extern s8  __read_mostly tlb_flushall_shift;
+
 /*
  *  CPU type and hardware bug flags. Kept separately for each CPU.
  *  Members of this structure are referenced in head.S, so think twice
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index b2016df..7595552 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -459,16 +459,26 @@ u16 __read_mostly tlb_lld_4k[NR_INFO];
 u16 __read_mostly tlb_lld_2m[NR_INFO];
 u16 __read_mostly tlb_lld_4m[NR_INFO];
 
+/*
+ * tlb_flushall_shift shows the balance point in replacing cr3 write
+ * with multiple 'invlpg'. It will do this replacement when
+ *   flush_tlb_lines <= active_lines/2^tlb_flushall_shift.
+ * If tlb_flushall_shift is -1, means the replacement will be disabled.
+ */
+s8  __read_mostly tlb_flushall_shift = -1;
+
 void __cpuinit cpu_detect_tlb(struct cpuinfo_x86 *c)
 {
 	if (this_cpu->c_detect_tlb)
 		this_cpu->c_detect_tlb(c);
 
 	printk(KERN_INFO "Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n" \
-		"Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d\n",
+		"Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d\n"	     \
+		"tlb_flushall_shift is 0x%x\n",
 		tlb_lli_4k[ENTRIES], tlb_lli_2m[ENTRIES],
 		tlb_lli_4m[ENTRIES], tlb_lld_4k[ENTRIES],
-		tlb_lld_2m[ENTRIES], tlb_lld_4m[ENTRIES]);
+		tlb_lld_2m[ENTRIES], tlb_lld_4m[ENTRIES],
+		tlb_flushall_shift);
 }
 
 void __cpuinit detect_ht(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index ed0d512..0a4ce29 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -610,6 +610,39 @@ static void __cpuinit intel_tlb_lookup(const unsigned char desc)
 	}
 }
 
+static void __cpuinit intel_tlb_flushall_shift_set(struct cpuinfo_x86 *c)
+{
+	if (!cpu_has_invlpg) {
+		tlb_flushall_shift = -1;
+		return;
+	}
+	switch ((c->x86 << 8) + c->x86_model) {
+	case 0x60f: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
+	case 0x616: /* single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L" */
+	case 0x617: /* current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale" */
+	case 0x61d: /* six-core 45 nm xeon "Dunnington" */
+		tlb_flushall_shift = -1;
+		break;
+	case 0x61a: /* 45 nm nehalem, "Bloomfield" */
+	case 0x61e: /* 45 nm nehalem, "Lynnfield" */
+	case 0x625: /* 32 nm nehalem, "Clarkdale" */
+	case 0x62c: /* 32 nm nehalem, "Gulftown" */
+	case 0x62e: /* 45 nm nehalem-ex, "Beckton" */
+	case 0x62f: /* 32 nm Xeon E7 */
+		tlb_flushall_shift = 6;
+		break;
+	case 0x62a: /* SandyBridge */
+	case 0x62d: /* SandyBridge, "Romely-EP" */
+		tlb_flushall_shift = 5;
+		break;
+	case 0x63a: /* Ivybridge */
+		tlb_flushall_shift = 1;
+		break;
+	default:
+		tlb_flushall_shift = 6;
+	}
+}
+
 static void __cpuinit intel_detect_tlb(struct cpuinfo_x86 *c)
 {
 	int i, j, n;
@@ -630,6 +663,7 @@ static void __cpuinit intel_detect_tlb(struct cpuinfo_x86 *c)
 		for (j = 1 ; j < 16 ; j++)
 			intel_tlb_lookup(desc[j]);
 	}
+	intel_tlb_flushall_shift_set(c);
 }
 
 static const struct cpu_dev __cpuinitconst intel_cpu_dev = {
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 184a02a..2939f2f 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -316,8 +316,6 @@ void flush_tlb_mm(struct mm_struct *mm)
 	preempt_enable();
 }
 
-#define FLUSHALL_BAR	16
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline unsigned long has_large_page(struct mm_struct *mm,
 				 unsigned long start, unsigned long end)
@@ -352,7 +350,7 @@ void flush_tlb_range(struct vm_area_struct *vma,
 {
 	struct mm_struct *mm;
 
-	if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB) {
+	if (vma->vm_flags & VM_HUGETLB || tlb_flushall_shift == -1) {
 flush_all:
 		flush_tlb_mm(vma->vm_mm);
 		return;
@@ -373,7 +371,8 @@ flush_all:
 			act_entries = tlb_entries > mm->total_vm ?
 					mm->total_vm : tlb_entries;
 
-			if ((end - start)/PAGE_SIZE > act_entries/FLUSHALL_BAR)
+			if ((end - start) >> PAGE_SHIFT >
+					act_entries >> tlb_flushall_shift)
 				local_flush_tlb();
 			else {
 				if (has_large_page(mm, start, end)) {
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index f96a5b5..75e888b 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -113,7 +113,8 @@ static inline int tlb_fast_mode(struct mmu_gather *tlb)
 
 void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, bool fullmm);
 void tlb_flush_mmu(struct mmu_gather *tlb);
-void tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end);
+void tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start,
+							unsigned long end);
 int __tlb_remove_page(struct mmu_gather *tlb, struct page *page);
 
 /* tlb_remove_page
