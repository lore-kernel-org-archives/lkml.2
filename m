Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1AXNBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 08:01:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56504 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab1AXNBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 08:01:33 -0500
Date: Mon, 24 Jan 2011 14:01:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110124130119.GA26553@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Akinobu Mita (1):
      x86: Use asm-generic/cacheflush.h

Borislav Petkov (1):
      x86, hotplug: Fix powersavings with offlined cores on AMD

Dave Jones (1):
      x86: Update CPU cache attributes table descriptors

Fenghua Yu (1):
      x86, mcheck, therm_throt.c: Export symbol platform_thermal_notify to allow coretemp to handler intr

Matthieu CASTET (1):
      x86: Fix jump label with RO/NX module protection crash


 arch/x86/include/asm/cacheflush.h        |   42 +-----------------------------
 arch/x86/include/asm/cpu.h               |    1 +
 arch/x86/include/asm/jump_label.h        |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c    |    3 ++
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    1 +
 arch/x86/kernel/process.c                |    3 +-
 arch/x86/kernel/smpboot.c                |    3 +-
 7 files changed, 11 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index 63e35ec..62f0844 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -1,48 +1,8 @@
 #ifndef _ASM_X86_CACHEFLUSH_H
 #define _ASM_X86_CACHEFLUSH_H
 
-/* Keep includes the same across arches.  */
-#include <linux/mm.h>
-
 /* Caches aren't brain-dead on the intel. */
-static inline void flush_cache_all(void) { }
-static inline void flush_cache_mm(struct mm_struct *mm) { }
-static inline void flush_cache_dup_mm(struct mm_struct *mm) { }
-static inline void flush_cache_range(struct vm_area_struct *vma,
-				     unsigned long start, unsigned long end) { }
-static inline void flush_cache_page(struct vm_area_struct *vma,
-				    unsigned long vmaddr, unsigned long pfn) { }
-#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
-static inline void flush_dcache_page(struct page *page) { }
-static inline void flush_dcache_mmap_lock(struct address_space *mapping) { }
-static inline void flush_dcache_mmap_unlock(struct address_space *mapping) { }
-static inline void flush_icache_range(unsigned long start,
-				      unsigned long end) { }
-static inline void flush_icache_page(struct vm_area_struct *vma,
-				     struct page *page) { }
-static inline void flush_icache_user_range(struct vm_area_struct *vma,
-					   struct page *page,
-					   unsigned long addr,
-					   unsigned long len) { }
-static inline void flush_cache_vmap(unsigned long start, unsigned long end) { }
-static inline void flush_cache_vunmap(unsigned long start,
-				      unsigned long end) { }
-
-static inline void copy_to_user_page(struct vm_area_struct *vma,
-				     struct page *page, unsigned long vaddr,
-				     void *dst, const void *src,
-				     unsigned long len)
-{
-	memcpy(dst, src, len);
-}
-
-static inline void copy_from_user_page(struct vm_area_struct *vma,
-				       struct page *page, unsigned long vaddr,
-				       void *dst, const void *src,
-				       unsigned long len)
-{
-	memcpy(dst, src, len);
-}
+#include <asm-generic/cacheflush.h>
 
 #ifdef CONFIG_X86_PAT
 /*
diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 4fab24d..6e6e755 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -32,5 +32,6 @@ extern void arch_unregister_cpu(int);
 
 DECLARE_PER_CPU(int, cpu_state);
 
+int __cpuinit mwait_usable(const struct cpuinfo_x86 *);
 
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index f52d42e..574dbc2 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -14,7 +14,7 @@
 	do {							\
 		asm goto("1:"					\
 			JUMP_LABEL_INITIAL_NOP			\
-			".pushsection __jump_table,  \"a\" \n\t"\
+			".pushsection __jump_table,  \"aw\" \n\t"\
 			_ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
 			".popsection \n\t"			\
 			: :  "i" (key) :  : label);		\
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 7283e98..ec2c19a 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -45,6 +45,7 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0x0a, LVL_1_DATA, 8 },	/* 2 way set assoc, 32 byte line size */
 	{ 0x0c, LVL_1_DATA, 16 },	/* 4-way set assoc, 32 byte line size */
 	{ 0x0d, LVL_1_DATA, 16 },	/* 4-way set assoc, 64 byte line size */
+	{ 0x0e, LVL_1_DATA, 24 },	/* 6-way set assoc, 64 byte line size */
 	{ 0x21, LVL_2,      256 },	/* 8-way set assoc, 64 byte line size */
 	{ 0x22, LVL_3,      512 },	/* 4-way set assoc, sectored cache, 64 byte line size */
 	{ 0x23, LVL_3,      MB(1) },	/* 8-way set assoc, sectored cache, 64 byte line size */
@@ -66,6 +67,7 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0x45, LVL_2,      MB(2) },	/* 4-way set assoc, 32 byte line size */
 	{ 0x46, LVL_3,      MB(4) },	/* 4-way set assoc, 64 byte line size */
 	{ 0x47, LVL_3,      MB(8) },	/* 8-way set assoc, 64 byte line size */
+	{ 0x48, LVL_2,      MB(3) },	/* 12-way set assoc, 64 byte line size */
 	{ 0x49, LVL_3,      MB(4) },	/* 16-way set assoc, 64 byte line size */
 	{ 0x4a, LVL_3,      MB(6) },	/* 12-way set assoc, 64 byte line size */
 	{ 0x4b, LVL_3,      MB(8) },	/* 16-way set assoc, 64 byte line size */
@@ -87,6 +89,7 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0x7c, LVL_2,      MB(1) },	/* 8-way set assoc, sectored cache, 64 byte line size */
 	{ 0x7d, LVL_2,      MB(2) },	/* 8-way set assoc, 64 byte line size */
 	{ 0x7f, LVL_2,      512 },	/* 2-way set assoc, 64 byte line size */
+	{ 0x80, LVL_2,      512 },	/* 8-way set assoc, 64 byte line size */
 	{ 0x82, LVL_2,      256 },	/* 8-way set assoc, 32 byte line size */
 	{ 0x83, LVL_2,      512 },	/* 8-way set assoc, 32 byte line size */
 	{ 0x84, LVL_2,      MB(1) },	/* 8-way set assoc, 32 byte line size */
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index e12246f..6f8c5e9 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -59,6 +59,7 @@ struct thermal_state {
 
 /* Callback to handle core threshold interrupts */
 int (*platform_thermal_notify)(__u64 msr_val);
+EXPORT_SYMBOL(platform_thermal_notify);
 
 static DEFINE_PER_CPU(struct thermal_state, thermal_state);
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index d8286ed..e764fc0 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -14,6 +14,7 @@
 #include <linux/utsname.h>
 #include <trace/events/power.h>
 #include <linux/hw_breakpoint.h>
+#include <asm/cpu.h>
 #include <asm/system.h>
 #include <asm/apic.h>
 #include <asm/syscalls.h>
@@ -505,7 +506,7 @@ static void poll_idle(void)
 #define MWAIT_ECX_EXTENDED_INFO		0x01
 #define MWAIT_EDX_C1			0xf0
 
-static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
+int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
 {
 	u32 eax, ebx, ecx, edx;
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 763df77..0cbe8c0 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1402,8 +1402,9 @@ static inline void mwait_play_dead(void)
 	unsigned int highest_subcstate = 0;
 	int i;
 	void *mwait_ptr;
+	struct cpuinfo_x86 *c = __this_cpu_ptr(&cpu_info);
 
-	if (!cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_MWAIT))
+	if (!(cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)))
 		return;
 	if (!cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLSH))
 		return;
