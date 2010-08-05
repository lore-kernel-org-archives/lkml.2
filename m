Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767Ab0HEUjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:39:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:48065 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760616Ab0HEUip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:38:45 -0400
Date: Thu, 5 Aug 2010 20:38:02 GMT
Message-Id: <201008052038.o75Kc2MQ022091@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/gcc46 for 2.6.36
Cc: Andi Kleen <ak@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 05 Aug 2010 20:38:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit cdd854bc42b5e6c79bbbc40c6600d995ffe6e747:

  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2010-08-05 09:03:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-gcc46-for-linus

Andi Kleen (2):
      x86, gcc-4.6: Avoid unused by set variables in rdmsr
      x86, gcc-4.6: Fix set but not read variables

 arch/x86/include/asm/msr.h         |    4 ++--
 arch/x86/kernel/aperture_64.c      |    4 ++--
 arch/x86/kernel/cpu/mtrr/generic.c |    3 +--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index c5bc4c2..084ef95 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -148,8 +148,8 @@ static inline unsigned long long native_read_pmc(int counter)
 #define rdmsr(msr, val1, val2)					\
 do {								\
 	u64 __val = native_read_msr((msr));			\
-	(val1) = (u32)__val;					\
-	(val2) = (u32)(__val >> 32);				\
+	(void)((val1) = (u32)__val);				\
+	(void)((val2) = (u32)(__val >> 32));			\
 } while (0)
 
 static inline void wrmsr(unsigned msr, unsigned low, unsigned high)
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index b5d8b0b..a2e0caf 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -280,7 +280,7 @@ void __init early_gart_iommu_check(void)
 	 * or BIOS forget to put that in reserved.
 	 * try to update e820 to make that region as reserved.
 	 */
-	u32 agp_aper_base = 0, agp_aper_order = 0;
+	u32 agp_aper_order = 0;
 	int i, fix, slot, valid_agp = 0;
 	u32 ctl;
 	u32 aper_size = 0, aper_order = 0, last_aper_order = 0;
@@ -291,7 +291,7 @@ void __init early_gart_iommu_check(void)
 		return;
 
 	/* This is mostly duplicate of iommu_hole_init */
-	agp_aper_base = search_agp_bridge(&agp_aper_order, &valid_agp);
+	search_agp_bridge(&agp_aper_order, &valid_agp);
 
 	fix = 0;
 	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index fd31a44..7d28d7d 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -433,13 +433,12 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 {
 	unsigned int mask_lo, mask_hi, base_lo, base_hi;
 	unsigned int tmp, hi;
-	int cpu;
 
 	/*
 	 * get_mtrr doesn't need to update mtrr_state, also it could be called
 	 * from any cpu, so try to print it out directly.
 	 */
-	cpu = get_cpu();
+	get_cpu();
 
 	rdmsr(MTRRphysMask_MSR(reg), mask_lo, mask_hi);
 
