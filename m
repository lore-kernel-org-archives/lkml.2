Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab0KKLDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:03:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40487 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613Ab0KKLDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:03:20 -0500
Date: Thu, 11 Nov 2010 12:03:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20101111110307.GA22017@elte.hu>
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
Andi Kleen (1):
      x86: Address gcc4.6 "set but not used" warnings in apic.h

Jack Steiner (1):
      x86, UV: Update node controller MMRs

Jan Beulich (1):
      x86: Adjust section annotations in AMD Fam10 MMCONF enabling code

Jesper Juhl (2):
      x86: Remove unnecessary casts of void ptr returning alloc function return values
      x86, apic: Remove double #include

Kusanagi Kouichi (1):
      x86, pvclock: Remove leftover scale_delta() function

Rakib Mullick (1):
      x86, mm: Fix section mismatch in tlb.c


 arch/x86/include/asm/apic.h        |   10 +-
 arch/x86/include/asm/uv/uv_mmrs.h  |  189 ++++++++++++++++++------------------
 arch/x86/kernel/apic/apic.c        |    1 -
 arch/x86/kernel/apic/x2apic_uv_x.c |   12 +-
 arch/x86/kernel/microcode_amd.c    |    2 +-
 arch/x86/kernel/mmconf-fam10h_64.c |    7 +-
 arch/x86/kernel/pvclock.c          |   38 -------
 arch/x86/mm/tlb.c                  |    2 +-
 arch/x86/platform/uv/tlb_uv.c      |   13 +--
 9 files changed, 119 insertions(+), 155 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 286de34..f6ce0bd 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -141,13 +141,13 @@ static inline void native_apic_msr_write(u32 reg, u32 v)
 
 static inline u32 native_apic_msr_read(u32 reg)
 {
-	u32 low, high;
+	u64 msr;
 
 	if (reg == APIC_DFR)
 		return -1;
 
-	rdmsr(APIC_BASE_MSR + (reg >> 4), low, high);
-	return low;
+	rdmsrl(APIC_BASE_MSR + (reg >> 4), msr);
+	return (u32)msr;
 }
 
 static inline void native_x2apic_wait_icr_idle(void)
@@ -181,12 +181,12 @@ extern void enable_x2apic(void);
 extern void x2apic_icr_write(u32 low, u32 id);
 static inline int x2apic_enabled(void)
 {
-	int msr, msr2;
+	u64 msr;
 
 	if (!cpu_has_x2apic)
 		return 0;
 
-	rdmsr(MSR_IA32_APICBASE, msr, msr2);
+	rdmsrl(MSR_IA32_APICBASE, msr);
 	if (msr & X2APIC_ENABLE)
 		return 1;
 	return 0;
diff --git a/arch/x86/include/asm/uv/uv_mmrs.h b/arch/x86/include/asm/uv/uv_mmrs.h
index b2f2d2e..6d90adf 100644
--- a/arch/x86/include/asm/uv/uv_mmrs.h
+++ b/arch/x86/include/asm/uv/uv_mmrs.h
@@ -806,6 +806,78 @@ union uvh_node_present_table_u {
 };
 
 /* ========================================================================= */
+/*                 UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR                  */
+/* ========================================================================= */
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR 0x16000c8UL
+
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR_BASE_SHFT 24
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR_BASE_MASK 0x00000000ff000000UL
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR_M_ALIAS_SHFT 48
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR_M_ALIAS_MASK 0x001f000000000000UL
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR_ENABLE_SHFT 63
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR_ENABLE_MASK 0x8000000000000000UL
+
+union uvh_rh_gam_alias210_overlay_config_0_mmr_u {
+    unsigned long	v;
+    struct uvh_rh_gam_alias210_overlay_config_0_mmr_s {
+	unsigned long	rsvd_0_23: 24;  /*    */
+	unsigned long	base    :  8;  /* RW */
+	unsigned long	rsvd_32_47: 16;  /*    */
+	unsigned long	m_alias :  5;  /* RW */
+	unsigned long	rsvd_53_62: 10;  /*    */
+	unsigned long	enable  :  1;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
+/*                 UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR                  */
+/* ========================================================================= */
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR 0x16000d8UL
+
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR_BASE_SHFT 24
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR_BASE_MASK 0x00000000ff000000UL
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR_M_ALIAS_SHFT 48
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR_M_ALIAS_MASK 0x001f000000000000UL
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR_ENABLE_SHFT 63
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR_ENABLE_MASK 0x8000000000000000UL
+
+union uvh_rh_gam_alias210_overlay_config_1_mmr_u {
+    unsigned long	v;
+    struct uvh_rh_gam_alias210_overlay_config_1_mmr_s {
+	unsigned long	rsvd_0_23: 24;  /*    */
+	unsigned long	base    :  8;  /* RW */
+	unsigned long	rsvd_32_47: 16;  /*    */
+	unsigned long	m_alias :  5;  /* RW */
+	unsigned long	rsvd_53_62: 10;  /*    */
+	unsigned long	enable  :  1;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
+/*                 UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR                  */
+/* ========================================================================= */
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR 0x16000e8UL
+
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR_BASE_SHFT 24
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR_BASE_MASK 0x00000000ff000000UL
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR_M_ALIAS_SHFT 48
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR_M_ALIAS_MASK 0x001f000000000000UL
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR_ENABLE_SHFT 63
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR_ENABLE_MASK 0x8000000000000000UL
+
+union uvh_rh_gam_alias210_overlay_config_2_mmr_u {
+    unsigned long	v;
+    struct uvh_rh_gam_alias210_overlay_config_2_mmr_s {
+	unsigned long	rsvd_0_23: 24;  /*    */
+	unsigned long	base    :  8;  /* RW */
+	unsigned long	rsvd_32_47: 16;  /*    */
+	unsigned long	m_alias :  5;  /* RW */
+	unsigned long	rsvd_53_62: 10;  /*    */
+	unsigned long	enable  :  1;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
 /*                UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR                  */
 /* ========================================================================= */
 #define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR 0x16000d0UL
@@ -857,6 +929,29 @@ union uvh_rh_gam_alias210_redirect_config_2_mmr_u {
 };
 
 /* ========================================================================= */
+/*                          UVH_RH_GAM_CONFIG_MMR                            */
+/* ========================================================================= */
+#define UVH_RH_GAM_CONFIG_MMR 0x1600000UL
+
+#define UVH_RH_GAM_CONFIG_MMR_M_SKT_SHFT 0
+#define UVH_RH_GAM_CONFIG_MMR_M_SKT_MASK 0x000000000000003fUL
+#define UVH_RH_GAM_CONFIG_MMR_N_SKT_SHFT 6
+#define UVH_RH_GAM_CONFIG_MMR_N_SKT_MASK 0x00000000000003c0UL
+#define UVH_RH_GAM_CONFIG_MMR_MMIOL_CFG_SHFT 12
+#define UVH_RH_GAM_CONFIG_MMR_MMIOL_CFG_MASK 0x0000000000001000UL
+
+union uvh_rh_gam_config_mmr_u {
+    unsigned long	v;
+    struct uvh_rh_gam_config_mmr_s {
+	unsigned long	m_skt     :  6;  /* RW */
+	unsigned long	n_skt     :  4;  /* RW */
+	unsigned long	rsvd_10_11:  2;  /*    */
+	unsigned long	mmiol_cfg :  1;  /* RW */
+	unsigned long	rsvd_13_63: 51;  /*    */
+    } s;
+};
+
+/* ========================================================================= */
 /*                    UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR                      */
 /* ========================================================================= */
 #define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR 0x1600010UL
@@ -987,97 +1082,5 @@ union uvh_rtc1_int_config_u {
     } s;
 };
 
-/* ========================================================================= */
-/*                          UVH_SI_ADDR_MAP_CONFIG                           */
-/* ========================================================================= */
-#define UVH_SI_ADDR_MAP_CONFIG 0xc80000UL
-
-#define UVH_SI_ADDR_MAP_CONFIG_M_SKT_SHFT 0
-#define UVH_SI_ADDR_MAP_CONFIG_M_SKT_MASK 0x000000000000003fUL
-#define UVH_SI_ADDR_MAP_CONFIG_N_SKT_SHFT 8
-#define UVH_SI_ADDR_MAP_CONFIG_N_SKT_MASK 0x0000000000000f00UL
-
-union uvh_si_addr_map_config_u {
-    unsigned long	v;
-    struct uvh_si_addr_map_config_s {
-	unsigned long	m_skt :  6;  /* RW */
-	unsigned long	rsvd_6_7:  2;  /*    */
-	unsigned long	n_skt :  4;  /* RW */
-	unsigned long	rsvd_12_63: 52;  /*    */
-    } s;
-};
-
-/* ========================================================================= */
-/*                       UVH_SI_ALIAS0_OVERLAY_CONFIG                        */
-/* ========================================================================= */
-#define UVH_SI_ALIAS0_OVERLAY_CONFIG 0xc80008UL
-
-#define UVH_SI_ALIAS0_OVERLAY_CONFIG_BASE_SHFT 24
-#define UVH_SI_ALIAS0_OVERLAY_CONFIG_BASE_MASK 0x00000000ff000000UL
-#define UVH_SI_ALIAS0_OVERLAY_CONFIG_M_ALIAS_SHFT 48
-#define UVH_SI_ALIAS0_OVERLAY_CONFIG_M_ALIAS_MASK 0x001f000000000000UL
-#define UVH_SI_ALIAS0_OVERLAY_CONFIG_ENABLE_SHFT 63
-#define UVH_SI_ALIAS0_OVERLAY_CONFIG_ENABLE_MASK 0x8000000000000000UL
-
-union uvh_si_alias0_overlay_config_u {
-    unsigned long	v;
-    struct uvh_si_alias0_overlay_config_s {
-	unsigned long	rsvd_0_23: 24;  /*    */
-	unsigned long	base    :  8;  /* RW */
-	unsigned long	rsvd_32_47: 16;  /*    */
-	unsigned long	m_alias :  5;  /* RW */
-	unsigned long	rsvd_53_62: 10;  /*    */
-	unsigned long	enable  :  1;  /* RW */
-    } s;
-};
-
-/* ========================================================================= */
-/*                       UVH_SI_ALIAS1_OVERLAY_CONFIG                        */
-/* ========================================================================= */
-#define UVH_SI_ALIAS1_OVERLAY_CONFIG 0xc80010UL
-
-#define UVH_SI_ALIAS1_OVERLAY_CONFIG_BASE_SHFT 24
-#define UVH_SI_ALIAS1_OVERLAY_CONFIG_BASE_MASK 0x00000000ff000000UL
-#define UVH_SI_ALIAS1_OVERLAY_CONFIG_M_ALIAS_SHFT 48
-#define UVH_SI_ALIAS1_OVERLAY_CONFIG_M_ALIAS_MASK 0x001f000000000000UL
-#define UVH_SI_ALIAS1_OVERLAY_CONFIG_ENABLE_SHFT 63
-#define UVH_SI_ALIAS1_OVERLAY_CONFIG_ENABLE_MASK 0x8000000000000000UL
-
-union uvh_si_alias1_overlay_config_u {
-    unsigned long	v;
-    struct uvh_si_alias1_overlay_config_s {
-	unsigned long	rsvd_0_23: 24;  /*    */
-	unsigned long	base    :  8;  /* RW */
-	unsigned long	rsvd_32_47: 16;  /*    */
-	unsigned long	m_alias :  5;  /* RW */
-	unsigned long	rsvd_53_62: 10;  /*    */
-	unsigned long	enable  :  1;  /* RW */
-    } s;
-};
-
-/* ========================================================================= */
-/*                       UVH_SI_ALIAS2_OVERLAY_CONFIG                        */
-/* ========================================================================= */
-#define UVH_SI_ALIAS2_OVERLAY_CONFIG 0xc80018UL
-
-#define UVH_SI_ALIAS2_OVERLAY_CONFIG_BASE_SHFT 24
-#define UVH_SI_ALIAS2_OVERLAY_CONFIG_BASE_MASK 0x00000000ff000000UL
-#define UVH_SI_ALIAS2_OVERLAY_CONFIG_M_ALIAS_SHFT 48
-#define UVH_SI_ALIAS2_OVERLAY_CONFIG_M_ALIAS_MASK 0x001f000000000000UL
-#define UVH_SI_ALIAS2_OVERLAY_CONFIG_ENABLE_SHFT 63
-#define UVH_SI_ALIAS2_OVERLAY_CONFIG_ENABLE_MASK 0x8000000000000000UL
-
-union uvh_si_alias2_overlay_config_u {
-    unsigned long	v;
-    struct uvh_si_alias2_overlay_config_s {
-	unsigned long	rsvd_0_23: 24;  /*    */
-	unsigned long	base    :  8;  /* RW */
-	unsigned long	rsvd_32_47: 16;  /*    */
-	unsigned long	m_alias :  5;  /* RW */
-	unsigned long	rsvd_53_62: 10;  /*    */
-	unsigned long	enable  :  1;  /* RW */
-    } s;
-};
-
 
-#endif /* _ASM_X86_UV_UV_MMRS_H */
+#endif /* __ASM_UV_MMRS_X86_H__ */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 850657d..3f838d5 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -52,7 +52,6 @@
 #include <asm/mce.h>
 #include <asm/kvm_para.h>
 #include <asm/tsc.h>
-#include <asm/atomic.h>
 
 unsigned int num_processors;
 
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index ed4118d..194539a 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -379,14 +379,14 @@ struct redir_addr {
 #define DEST_SHIFT UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR_DEST_BASE_SHFT
 
 static __initdata struct redir_addr redir_addrs[] = {
-	{UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR, UVH_SI_ALIAS0_OVERLAY_CONFIG},
-	{UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_1_MMR, UVH_SI_ALIAS1_OVERLAY_CONFIG},
-	{UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_2_MMR, UVH_SI_ALIAS2_OVERLAY_CONFIG},
+	{UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR, UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR},
+	{UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_1_MMR, UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR},
+	{UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_2_MMR, UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR},
 };
 
 static __init void get_lowmem_redirect(unsigned long *base, unsigned long *size)
 {
-	union uvh_si_alias0_overlay_config_u alias;
+	union uvh_rh_gam_alias210_overlay_config_2_mmr_u alias;
 	union uvh_rh_gam_alias210_redirect_config_2_mmr_u redirect;
 	int i;
 
@@ -660,7 +660,7 @@ void uv_nmi_init(void)
 
 void __init uv_system_init(void)
 {
-	union uvh_si_addr_map_config_u m_n_config;
+	union uvh_rh_gam_config_mmr_u  m_n_config;
 	union uvh_node_id_u node_id;
 	unsigned long gnode_upper, lowmem_redir_base, lowmem_redir_size;
 	int bytes, nid, cpu, lcpu, pnode, blade, i, j, m_val, n_val;
@@ -670,7 +670,7 @@ void __init uv_system_init(void)
 
 	map_low_mmrs();
 
-	m_n_config.v = uv_read_local_mmr(UVH_SI_ADDR_MAP_CONFIG);
+	m_n_config.v = uv_read_local_mmr(UVH_RH_GAM_CONFIG_MMR );
 	m_val = m_n_config.s.m_skt;
 	n_val = m_n_config.s.n_skt;
 	mmr_base =
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index e1af7c0..ce0cb47 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -212,7 +212,7 @@ static int install_equiv_cpu_table(const u8 *buf)
 		return 0;
 	}
 
-	equiv_cpu_table = (struct equiv_cpu_entry *) vmalloc(size);
+	equiv_cpu_table = vmalloc(size);
 	if (!equiv_cpu_table) {
 		pr_err("failed to allocate equivalent CPU table\n");
 		return 0;
diff --git a/arch/x86/kernel/mmconf-fam10h_64.c b/arch/x86/kernel/mmconf-fam10h_64.c
index 7182580..6da143c 100644
--- a/arch/x86/kernel/mmconf-fam10h_64.c
+++ b/arch/x86/kernel/mmconf-fam10h_64.c
@@ -217,13 +217,13 @@ void __cpuinit fam10h_check_enable_mmcfg(void)
 	wrmsrl(address, val);
 }
 
-static int __devinit set_check_enable_amd_mmconf(const struct dmi_system_id *d)
+static int __init set_check_enable_amd_mmconf(const struct dmi_system_id *d)
 {
         pci_probe |= PCI_CHECK_ENABLE_AMD_MMCONF;
         return 0;
 }
 
-static const struct dmi_system_id __cpuinitconst mmconf_dmi_table[] = {
+static const struct dmi_system_id __initconst mmconf_dmi_table[] = {
         {
                 .callback = set_check_enable_amd_mmconf,
                 .ident = "Sun Microsystems Machine",
@@ -234,7 +234,8 @@ static const struct dmi_system_id __cpuinitconst mmconf_dmi_table[] = {
 	{}
 };
 
-void __cpuinit check_enable_amd_mmconf_dmi(void)
+/* Called from a __cpuinit function, but only on the BSP. */
+void __ref check_enable_amd_mmconf_dmi(void)
 {
 	dmi_check_system(mmconf_dmi_table);
 }
diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index bab3b9e..008b91e 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -41,44 +41,6 @@ void pvclock_set_flags(u8 flags)
 	valid_flags = flags;
 }
 
-/*
- * Scale a 64-bit delta by scaling and multiplying by a 32-bit fraction,
- * yielding a 64-bit result.
- */
-static inline u64 scale_delta(u64 delta, u32 mul_frac, int shift)
-{
-	u64 product;
-#ifdef __i386__
-	u32 tmp1, tmp2;
-#endif
-
-	if (shift < 0)
-		delta >>= -shift;
-	else
-		delta <<= shift;
-
-#ifdef __i386__
-	__asm__ (
-		"mul  %5       ; "
-		"mov  %4,%%eax ; "
-		"mov  %%edx,%4 ; "
-		"mul  %5       ; "
-		"xor  %5,%5    ; "
-		"add  %4,%%eax ; "
-		"adc  %5,%%edx ; "
-		: "=A" (product), "=r" (tmp1), "=r" (tmp2)
-		: "a" ((u32)delta), "1" ((u32)(delta >> 32)), "2" (mul_frac) );
-#elif defined(__x86_64__)
-	__asm__ (
-		"mul %%rdx ; shrd $32,%%rdx,%%rax"
-		: "=a" (product) : "0" (delta), "d" ((u64)mul_frac) );
-#else
-#error implement me!
-#endif
-
-	return product;
-}
-
 static u64 pvclock_get_nsec_offset(struct pvclock_shadow_time *shadow)
 {
 	u64 delta = native_read_tsc() - shadow->tsc_timestamp;
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 4935848..12cdbb1 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -251,7 +251,7 @@ static void __cpuinit calculate_tlb_offset(void)
 	}
 }
 
-static int tlb_cpuhp_notify(struct notifier_block *n,
+static int __cpuinit tlb_cpuhp_notify(struct notifier_block *n,
 		unsigned long action, void *hcpu)
 {
 	switch (action & 0xf) {
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 20ea20a..a318194 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1343,8 +1343,8 @@ uv_activation_descriptor_init(int node, int pnode)
 	 * each bau_desc is 64 bytes; there are 8 (UV_ITEMS_PER_DESCRIPTOR)
 	 * per cpu; and up to 32 (UV_ADP_SIZE) cpu's per uvhub
 	 */
-	bau_desc = (struct bau_desc *)kmalloc_node(sizeof(struct bau_desc)*
-		UV_ADP_SIZE*UV_ITEMS_PER_DESCRIPTOR, GFP_KERNEL, node);
+	bau_desc = kmalloc_node(sizeof(struct bau_desc) * UV_ADP_SIZE
+				* UV_ITEMS_PER_DESCRIPTOR, GFP_KERNEL, node);
 	BUG_ON(!bau_desc);
 
 	pa = uv_gpa(bau_desc); /* need the real nasid*/
@@ -1402,9 +1402,9 @@ uv_payload_queue_init(int node, int pnode)
 	struct bau_payload_queue_entry *pqp_malloc;
 	struct bau_control *bcp;
 
-	pqp = (struct bau_payload_queue_entry *) kmalloc_node(
-		(DEST_Q_SIZE + 1) * sizeof(struct bau_payload_queue_entry),
-		GFP_KERNEL, node);
+	pqp = kmalloc_node((DEST_Q_SIZE + 1)
+			   * sizeof(struct bau_payload_queue_entry),
+			   GFP_KERNEL, node);
 	BUG_ON(!pqp);
 	pqp_malloc = pqp;
 
@@ -1520,8 +1520,7 @@ static void __init uv_init_per_cpu(int nuvhubs)
 
 	timeout_us = calculate_destination_timeout();
 
-	uvhub_descs = (struct uvhub_desc *)
-		kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
+	uvhub_descs = kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
 	memset(uvhub_descs, 0, nuvhubs * sizeof(struct uvhub_desc));
 	uvhub_mask = kzalloc((nuvhubs+7)/8, GFP_KERNEL);
 	for_each_present_cpu(cpu) {
