Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab2EJFDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 01:03:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:21455 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab2EJFCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 01:02:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="142177414"
From: Alex Shi <alex.shi@intel.com>
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, gregkh@linuxfoundation.org, borislav.petkov@amd.com,
        alex.shi@intel.com, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, dhowells@redhat.com, fenghua.yu@intel.com,
        ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/7] x86/tlb: add tlb flush all factor for specific CPU
Date: Thu, 10 May 2012 13:00:11 +0800
Message-Id: <1336626013-28413-6-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Testing show different CPU type(micro architectures and NUMA mode) has
different balance points between the TLB flush all and multiple invlpg.
And there also has cases the tlb flush change has no any help.

This patch give a interface to let x86 vendor developers have a chance
to set different factors for different CPU type.

like some machine in my hands, balance points is 16 entries on Romely-EP;
while it is at 8 entries on Bloomfield NHM-EP; but on model 15 core2 Xeon
using invlpg has nothing help.

For untested machine, do a conservative optimization, same as NHM CPU.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/kernel/cpu/common.c     |   14 ++++++++++++--
 arch/x86/kernel/cpu/intel.c      |   28 ++++++++++++++++++++++++++++
 arch/x86/mm/tlb.c                |    8 ++++----
 4 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 797faca..6a7e9c3 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -72,6 +72,8 @@ extern u16 __read_mostly tlb_lli_4m[NR_INFO];
 extern u16 __read_mostly tlb_lld_4k[NR_INFO];
 extern u16 __read_mostly tlb_lld_2m[NR_INFO];
 extern u16 __read_mostly tlb_lld_4m[NR_INFO];
+extern u16 __read_mostly tlb_flushall_factor;
+
 /*
  *  CPU type and hardware bug flags. Kept separately for each CPU.
  *  Members of this structure are referenced in head.S, so think twice
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 0152082..8879d20 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -459,16 +459,26 @@ u16 __read_mostly tlb_lld_4k[NR_INFO];
 u16 __read_mostly tlb_lld_2m[NR_INFO];
 u16 __read_mostly tlb_lld_4m[NR_INFO];
 
+/*
+ * tlb_flushall_factor shows the balance point in replacing cr3 write
+ * with multiple 'invlpg'. It will do this replacement when
+ *   flush_tlb_lines <= active_lines/2^tlb_flushall_factor.
+ * If tlb_flushall_factor is -1, means the replacement will be disabled.
+ */
+u16 __read_mostly tlb_flushall_factor;
+
 void __cpuinit cpu_detect_tlb(struct cpuinfo_x86 *c)
 {
 	if (c->x86_vendor == X86_VENDOR_INTEL)
 		intel_cpu_detect_tlb(c);
 
 	printk(KERN_INFO "Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n" \
-		"Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d\n",
+		"Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d\n"	     \
+		"tlb_flushall_factor is 0x%x\n",
 		tlb_lli_4k[ENTRIES], tlb_lli_2m[ENTRIES],
 		tlb_lli_4m[ENTRIES], tlb_lld_4k[ENTRIES],
-		tlb_lld_2m[ENTRIES], tlb_lld_4m[ENTRIES]);
+		tlb_lld_2m[ENTRIES], tlb_lld_4m[ENTRIES],
+		tlb_flushall_factor);
 }
 
 void __cpuinit detect_ht(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 86e6131..2fedb94 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -610,6 +610,33 @@ void intel_tlb_lookup(const unsigned char desc)
 	}
 }
 
+void intel_tlb_flushall_factor_set(struct cpuinfo_x86 *c)
+{
+	if (!cpu_has_invlpg) {
+		tlb_flushall_factor = -1;
+		return;
+	}
+	switch ((c->x86 << 8) + c->x86_model) {
+	case 0x60f: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
+		tlb_flushall_factor = -1;
+		break;
+	case 0x61a: /* 45 nm nehalem, "Bloomfield" */
+	case 0x61e: /* 45 nm nehalem, "Lynnfield" */
+	case 0x625: /* 32 nm nehalem, "Clarkdale" */
+	case 0x62c: /* 32 nm nehalem, "Gulftown" */
+	case 0x62e: /* 45 nm nehalem-ex, "Beckton" */
+	case 0x62f: /* 32 nm Xeon E7 */
+		tlb_flushall_factor = 6;
+		break;
+	case 0x62a: /* SandyBridge */
+	case 0x62d: /* SandyBridge, "Romely-EP" */
+		tlb_flushall_factor = 5;
+		break;
+	default:
+		tlb_flushall_factor = 6;
+	}
+}
+
 void intel_cpu_detect_tlb(struct cpuinfo_x86 *c)
 {
 	int i, j, n;
@@ -630,6 +657,7 @@ void intel_cpu_detect_tlb(struct cpuinfo_x86 *c)
 		for (j = 1 ; j < 16 ; j++)
 			intel_tlb_lookup(desc[j]);
 	}
+	intel_tlb_flushall_factor_set(c);
 }
 
 static const struct cpu_dev __cpuinitconst intel_cpu_dev = {
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 5793a3b..4d8fb09 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -314,8 +314,6 @@ void flush_tlb_mm(struct mm_struct *mm)
 	preempt_enable();
 }
 
-#define FLUSHALL_BAR	16
-
 static inline int has_large_page(struct mm_struct *mm,
 				 unsigned long start, unsigned long end)
 {
@@ -343,7 +341,8 @@ void flush_tlb_range(struct vm_area_struct *vma,
 {
 	struct mm_struct *mm;
 
-	if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB) {
+	if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB
+			|| tlb_flushall_factor == (u16)TLB_FLUSH_ALL) {
 flush_all:
 		flush_tlb_mm(vma->vm_mm);
 		return;
@@ -364,7 +363,8 @@ flush_all:
 			act_entries = tlb_entries > mm->total_vm ?
 					mm->total_vm : tlb_entries;
 
-			if ((end - start)/PAGE_SIZE > act_entries/FLUSHALL_BAR)
+			if ((end - start) >> PAGE_SHIFT >
+					act_entries >> tlb_flushall_factor)
 				local_flush_tlb();
 			else {
 				if (has_large_page(mm, start, end)) {
-- 
1.7.5.4

