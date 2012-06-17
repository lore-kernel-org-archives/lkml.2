Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab2FQSsu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:48:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50695 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757542Ab2FQSsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:48:47 -0400
Message-ID: <1339958907.4942.243.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 00/69] 3.2.21-stable review
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Date: Sun, 17 Jun 2012 19:48:27 +0100
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
References: <20120617175941.281333656@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-i0ot3Q+8NvcJmkbtGOOe"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-i0ot3Q+8NvcJmkbtGOOe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile b/Makefile
index c7e9cc4..59b96e7 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION =3D 3
 PATCHLEVEL =3D 2
-SUBLEVEL =3D 20
-EXTRAVERSION =3D
+SUBLEVEL =3D 21
+EXTRAVERSION =3D -rc1
 NAME =3D Saber-toothed Squirrel
=20
 # *DOCUMENTATION*
diff --git a/arch/arm/mach-imx/hotplug.c b/arch/arm/mach-imx/hotplug.c
index 89493ab..20ed2d5 100644
--- a/arch/arm/mach-imx/hotplug.c
+++ b/arch/arm/mach-imx/hotplug.c
@@ -12,6 +12,7 @@
=20
 #include <linux/errno.h>
 #include <asm/cacheflush.h>
+#include <asm/cp15.h>
 #include <mach/common.h>
=20
 int platform_cpu_kill(unsigned int cpu)
@@ -19,6 +20,44 @@ int platform_cpu_kill(unsigned int cpu)
 	return 1;
 }
=20
+static inline void cpu_enter_lowpower(void)
+{
+	unsigned int v;
+
+	flush_cache_all();
+	asm volatile(
+		"mcr	p15, 0, %1, c7, c5, 0\n"
+	"	mcr	p15, 0, %1, c7, c10, 4\n"
+	/*
+	 * Turn off coherency
+	 */
+	"	mrc	p15, 0, %0, c1, c0, 1\n"
+	"	bic	%0, %0, %3\n"
+	"	mcr	p15, 0, %0, c1, c0, 1\n"
+	"	mrc	p15, 0, %0, c1, c0, 0\n"
+	"	bic	%0, %0, %2\n"
+	"	mcr	p15, 0, %0, c1, c0, 0\n"
+	  : "=3D&r" (v)
+	  : "r" (0), "Ir" (CR_C), "Ir" (0x40)
+	  : "cc");
+}
+
+static inline void cpu_leave_lowpower(void)
+{
+	unsigned int v;
+
+	asm volatile(
+		"mrc	p15, 0, %0, c1, c0, 0\n"
+	"	orr	%0, %0, %1\n"
+	"	mcr	p15, 0, %0, c1, c0, 0\n"
+	"	mrc	p15, 0, %0, c1, c0, 1\n"
+	"	orr	%0, %0, %2\n"
+	"	mcr	p15, 0, %0, c1, c0, 1\n"
+	  : "=3D&r" (v)
+	  : "Ir" (CR_C), "Ir" (0x40)
+	  : "cc");
+}
+
 /*
  * platform-specific code to shutdown a CPU
  *
@@ -26,9 +65,10 @@ int platform_cpu_kill(unsigned int cpu)
  */
 void platform_cpu_die(unsigned int cpu)
 {
-	flush_cache_all();
+	cpu_enter_lowpower();
 	imx_enable_cpu(cpu, false);
 	cpu_do_idle();
+	cpu_leave_lowpower();
=20
 	/* We should never return from idle */
 	panic("cpu %d unexpectedly exit from shutdown\n", cpu);
diff --git a/arch/arm/mach-imx/mach-mx21ads.c b/arch/arm/mach-imx/mach-mx21=
ads.c
index 25f8402..ad994b3 100644
--- a/arch/arm/mach-imx/mach-mx21ads.c
+++ b/arch/arm/mach-imx/mach-mx21ads.c
@@ -32,7 +32,7 @@
  * Memory-mapped I/O on MX21ADS base board
  */
 #define MX21ADS_MMIO_BASE_ADDR   0xf5000000
-#define MX21ADS_MMIO_SIZE        SZ_16M
+#define MX21ADS_MMIO_SIZE        0xc00000
=20
 #define MX21ADS_REG_ADDR(offset)    (void __force __iomem *) \
 		(MX21ADS_MMIO_BASE_ADDR + (offset))
diff --git a/arch/arm/mach-mx5/crm_regs.h b/arch/arm/mach-mx5/crm_regs.h
index 5e11ba7..5e3f1f0 100644
--- a/arch/arm/mach-mx5/crm_regs.h
+++ b/arch/arm/mach-mx5/crm_regs.h
@@ -23,7 +23,7 @@
 #define MX53_DPLL1_BASE		MX53_IO_ADDRESS(MX53_PLL1_BASE_ADDR)
 #define MX53_DPLL2_BASE		MX53_IO_ADDRESS(MX53_PLL2_BASE_ADDR)
 #define MX53_DPLL3_BASE		MX53_IO_ADDRESS(MX53_PLL3_BASE_ADDR)
-#define MX53_DPLL4_BASE		MX53_IO_ADDRESS(MX53_PLL3_BASE_ADDR)
+#define MX53_DPLL4_BASE		MX53_IO_ADDRESS(MX53_PLL4_BASE_ADDR)
=20
 /* PLL Register Offsets */
 #define MXC_PLL_DP_CTL			0x00
diff --git a/arch/powerpc/kernel/module_32.c b/arch/powerpc/kernel/module_3=
2.c
index 0b6d796..2e3200c 100644
--- a/arch/powerpc/kernel/module_32.c
+++ b/arch/powerpc/kernel/module_32.c
@@ -176,8 +176,8 @@ int module_frob_arch_sections(Elf32_Ehdr *hdr,
=20
 static inline int entry_matches(struct ppc_plt_entry *entry, Elf32_Addr va=
l)
 {
-	if (entry->jump[0] =3D=3D 0x3d600000 + ((val + 0x8000) >> 16)
-	    && entry->jump[1] =3D=3D 0x396b0000 + (val & 0xffff))
+	if (entry->jump[0] =3D=3D 0x3d800000 + ((val + 0x8000) >> 16)
+	    && entry->jump[1] =3D=3D 0x398c0000 + (val & 0xffff))
 		return 1;
 	return 0;
 }
@@ -204,10 +204,9 @@ static uint32_t do_plt_call(void *location,
 		entry++;
 	}
=20
-	/* Stolen from Paul Mackerras as well... */
-	entry->jump[0] =3D 0x3d600000+((val+0x8000)>>16);	/* lis r11,sym@ha */
-	entry->jump[1] =3D 0x396b0000 + (val&0xffff);	/* addi r11,r11,sym@l*/
-	entry->jump[2] =3D 0x7d6903a6;			/* mtctr r11 */
+	entry->jump[0] =3D 0x3d800000+((val+0x8000)>>16); /* lis r12,sym@ha */
+	entry->jump[1] =3D 0x398c0000 + (val&0xffff);     /* addi r12,r12,sym@l*/
+	entry->jump[2] =3D 0x7d8903a6;                    /* mtctr r12 */
 	entry->jump[3] =3D 0x4e800420;			/* bctr */
=20
 	DEBUGP("Initialized plt for 0x%x at %p\n", val, entry);
diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-inte=
l_asm.S
index be6d9e3..3470624 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -2460,10 +2460,12 @@ ENTRY(aesni_cbc_dec)
 	pxor IN3, STATE4
 	movaps IN4, IV
 #else
-	pxor (INP), STATE2
-	pxor 0x10(INP), STATE3
 	pxor IN1, STATE4
 	movaps IN2, IV
+	movups (INP), IN1
+	pxor IN1, STATE2
+	movups 0x10(INP), IN2
+	pxor IN2, STATE3
 #endif
 	movups STATE1, (OUTP)
 	movups STATE2, 0x10(OUTP)
diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_=
bau.h
index 1b82f7e..679229f 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -149,7 +149,6 @@
 /* 4 bits of software ack period */
 #define UV2_ACK_MASK			0x7UL
 #define UV2_ACK_UNITS_SHFT		3
-#define UV2_LEG_SHFT UV2H_LB_BAU_MISC_CONTROL_USE_LEGACY_DESCRIPTOR_FORMAT=
S_SHFT
 #define UV2_EXT_SHFT UV2H_LB_BAU_MISC_CONTROL_ENABLE_EXTENDED_SB_STATUS_SH=
FT
=20
 /*
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 0bab2b1..3524e1f 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -571,6 +571,24 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
=20
+	/* re-enable TopologyExtensions if switched off by BIOS */
+	if ((c->x86 =3D=3D 0x15) &&
+	    (c->x86_model >=3D 0x10) && (c->x86_model <=3D 0x1f) &&
+	    !cpu_has(c, X86_FEATURE_TOPOEXT)) {
+		u64 val;
+
+		if (!rdmsrl_amd_safe(0xc0011005, &val)) {
+			val |=3D 1ULL << 54;
+			wrmsrl_amd_safe(0xc0011005, val);
+			rdmsrl(0xc0011005, val);
+			if (val & (1ULL << 54)) {
+				set_cpu_cap(c, X86_FEATURE_TOPOEXT);
+				printk(KERN_INFO FW_INFO "CPU: Re-enabling "
+				  "disabled Topology Extensions Support\n");
+			}
+		}
+	}
+
 	cpu_detect_cache_sizes(c);
=20
 	/* Multi core CPU? */
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mch=
eck/mce_amd.c
index f547421..445a61c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -52,6 +52,7 @@ struct threshold_block {
 	unsigned int		cpu;
 	u32			address;
 	u16			interrupt_enable;
+	bool			interrupt_capable;
 	u16			threshold_limit;
 	struct kobject		kobj;
 	struct list_head	miscj;
@@ -86,6 +87,21 @@ struct thresh_restart {
 	u16			old_limit;
 };
=20
+static bool lvt_interrupt_supported(unsigned int bank, u32 msr_high_bits)
+{
+	/*
+	 * bank 4 supports APIC LVT interrupts implicitly since forever.
+	 */
+	if (bank =3D=3D 4)
+		return true;
+
+	/*
+	 * IntP: interrupt present; if this bit is set, the thresholding
+	 * bank can generate APIC LVT interrupts
+	 */
+	return msr_high_bits & BIT(28);
+}
+
 static int lvt_off_valid(struct threshold_block *b, int apic, u32 lo, u32 =
hi)
 {
 	int msr =3D (hi & MASK_LVTOFF_HI) >> 20;
@@ -107,8 +123,10 @@ static int lvt_off_valid(struct threshold_block *b, in=
t apic, u32 lo, u32 hi)
 	return 1;
 };
=20
-/* must be called with correct cpu affinity */
-/* Called via smp_call_function_single() */
+/*
+ * Called via smp_call_function_single(), must be called with correct
+ * cpu affinity.
+ */
 static void threshold_restart_bank(void *_tr)
 {
 	struct thresh_restart *tr =3D _tr;
@@ -131,6 +149,12 @@ static void threshold_restart_bank(void *_tr)
 		    (new_count & THRESHOLD_MAX);
 	}
=20
+	/* clear IntType */
+	hi &=3D ~MASK_INT_TYPE_HI;
+
+	if (!tr->b->interrupt_capable)
+		goto done;
+
 	if (tr->set_lvt_off) {
 		if (lvt_off_valid(tr->b, tr->lvt_off, lo, hi)) {
 			/* set new lvt offset */
@@ -139,9 +163,10 @@ static void threshold_restart_bank(void *_tr)
 		}
 	}
=20
-	tr->b->interrupt_enable ?
-	    (hi =3D (hi & ~MASK_INT_TYPE_HI) | INT_TYPE_APIC) :
-	    (hi &=3D ~MASK_INT_TYPE_HI);
+	if (tr->b->interrupt_enable)
+		hi |=3D INT_TYPE_APIC;
+
+ done:
=20
 	hi |=3D MASK_COUNT_EN_HI;
 	wrmsr(tr->b->address, lo, hi);
@@ -206,14 +231,18 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 			if (shared_bank[bank] && c->cpu_core_id)
 				break;
 #endif
-			offset =3D setup_APIC_mce(offset,
-						(high & MASK_LVTOFF_HI) >> 20);
=20
 			memset(&b, 0, sizeof(b));
-			b.cpu		=3D cpu;
-			b.bank		=3D bank;
-			b.block		=3D block;
-			b.address	=3D address;
+			b.cpu			=3D cpu;
+			b.bank			=3D bank;
+			b.block			=3D block;
+			b.address		=3D address;
+			b.interrupt_capable	=3D lvt_interrupt_supported(bank, high);
+
+			if (b.interrupt_capable) {
+				int new =3D (high & MASK_LVTOFF_HI) >> 20;
+				offset  =3D setup_APIC_mce(offset, new);
+			}
=20
 			mce_threshold_block_init(&b, offset);
 			mce_threshold_vector =3D amd_threshold_interrupt;
@@ -313,6 +342,9 @@ store_interrupt_enable(struct threshold_block *b, const=
 char *buf, size_t size)
 	struct thresh_restart tr;
 	unsigned long new;
=20
+	if (!b->interrupt_capable)
+		return -EINVAL;
+
 	if (strict_strtoul(buf, 0, &new) < 0)
 		return -EINVAL;
=20
@@ -471,6 +503,7 @@ static __cpuinit int allocate_threshold_blocks(unsigned=
 int cpu,
 	b->cpu			=3D cpu;
 	b->address		=3D address;
 	b->interrupt_enable	=3D 0;
+	b->interrupt_capable	=3D lvt_interrupt_supported(bank, high);
 	b->threshold_limit	=3D THRESHOLD_MAX;
=20
 	INIT_LIST_HEAD(&b->miscj);
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 81aee5a..29a69550 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1304,7 +1304,6 @@ static void __init enable_timeouts(void)
 		 */
 		mmr_image |=3D (1L << SOFTACK_MSHIFT);
 		if (is_uv2_hub()) {
-			mmr_image &=3D ~(1L << UV2_LEG_SHFT);
 			mmr_image |=3D (1L << UV2_EXT_SHFT);
 		}
 		write_mmr_misc_control(pnode, mmr_image);
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index cca659e..44d4393 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -198,6 +198,9 @@ static void __init xen_banner(void)
 	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-AD)" =
: "");
 }
=20
+#define CPUID_THERM_POWER_LEAF 6
+#define APERFMPERF_PRESENT 0
+
 static __read_mostly unsigned int cpuid_leaf1_edx_mask =3D ~0;
 static __read_mostly unsigned int cpuid_leaf1_ecx_mask =3D ~0;
=20
@@ -218,6 +221,11 @@ static void xen_cpuid(unsigned int *ax, unsigned int *=
bx,
 		maskedx =3D cpuid_leaf1_edx_mask;
 		break;
=20
+	case CPUID_THERM_POWER_LEAF:
+		/* Disabling APERFMPERF for kernel usage */
+		maskecx =3D ~(1 << APERFMPERF_PRESENT);
+		break;
+
 	case 0xb:
 		/* Suppress extended topology stuff */
 		maskebx =3D 0;
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index b427711..58b49d1 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -897,6 +897,7 @@ static struct pci_device_id agp_intel_pci_table[] =3D {
 	ID(PCI_DEVICE_ID_INTEL_B43_HB),
 	ID(PCI_DEVICE_ID_INTEL_B43_1_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_D_HB),
+	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_D2_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_M_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_MA_HB),
 	ID(PCI_DEVICE_ID_INTEL_IRONLAKE_MC2_HB),
diff --git a/drivers/char/agp/intel-agp.h b/drivers/char/agp/intel-agp.h
index 5da67f1..6f24604 100644
--- a/drivers/char/agp/intel-agp.h
+++ b/drivers/char/agp/intel-agp.h
@@ -211,6 +211,7 @@
 #define PCI_DEVICE_ID_INTEL_G41_HB          0x2E30
 #define PCI_DEVICE_ID_INTEL_G41_IG          0x2E32
 #define PCI_DEVICE_ID_INTEL_IRONLAKE_D_HB	    0x0040
+#define PCI_DEVICE_ID_INTEL_IRONLAKE_D2_HB	    0x0069
 #define PCI_DEVICE_ID_INTEL_IRONLAKE_D_IG	    0x0042
 #define PCI_DEVICE_ID_INTEL_IRONLAKE_M_HB	    0x0044
 #define PCI_DEVICE_ID_INTEL_IRONLAKE_MA_HB	    0x0062
diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/at=
mel-rng.c
index 241df2e..0477982 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -36,6 +36,13 @@ static int atmel_trng_read(struct hwrng *rng, void *buf,=
 size_t max,
 	/* data ready? */
 	if (readl(trng->base + TRNG_ODATA) & 1) {
 		*data =3D readl(trng->base + TRNG_ODATA);
+		/*
+		  ensure data ready is only set again AFTER the next data
+		  word is ready in case it got set between checking ISR
+		  and reading ODATA, so we don't risk re-reading the
+		  same word
+		*/
+		readl(trng->base + TRNG_ISR);
 		return 4;
 	} else
 		return 0;
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_dr=
v.c
index d0f8830..3a1bfd7 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -214,6 +214,7 @@ static const struct intel_device_info intel_sandybridge=
_d_info =3D {
 	.need_gfx_hws =3D 1, .has_hotplug =3D 1,
 	.has_bsd_ring =3D 1,
 	.has_blt_ring =3D 1,
+	.has_force_wake =3D 1,
 };
=20
 static const struct intel_device_info intel_sandybridge_m_info =3D {
@@ -222,6 +223,7 @@ static const struct intel_device_info intel_sandybridge=
_m_info =3D {
 	.has_fbc =3D 1,
 	.has_bsd_ring =3D 1,
 	.has_blt_ring =3D 1,
+	.has_force_wake =3D 1,
 };
=20
 static const struct intel_device_info intel_ivybridge_d_info =3D {
@@ -229,6 +231,7 @@ static const struct intel_device_info intel_ivybridge_d=
_info =3D {
 	.need_gfx_hws =3D 1, .has_hotplug =3D 1,
 	.has_bsd_ring =3D 1,
 	.has_blt_ring =3D 1,
+	.has_force_wake =3D 1,
 };
=20
 static const struct intel_device_info intel_ivybridge_m_info =3D {
@@ -237,6 +240,7 @@ static const struct intel_device_info intel_ivybridge_m=
_info =3D {
 	.has_fbc =3D 0,	/* FBC is not enabled on Ivybridge mobile yet */
 	.has_bsd_ring =3D 1,
 	.has_blt_ring =3D 1,
+	.has_force_wake =3D 1,
 };
=20
 static const struct pci_device_id pciidlist[] =3D {		/* aka */
@@ -939,7 +943,7 @@ MODULE_LICENSE("GPL and additional rights");
=20
 /* We give fast paths for the really cool registers */
 #define NEEDS_FORCE_WAKE(dev_priv, reg) \
-	(((dev_priv)->info->gen >=3D 6) && \
+	((HAS_FORCE_WAKE((dev_priv)->dev)) && \
 	 ((reg) < 0x40000) &&		 \
 	 ((reg) !=3D FORCEWAKE) &&	 \
 	 ((reg) !=3D ECOBUS))
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_dr=
v.h
index ae294a0..d62c731 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -244,6 +244,7 @@ struct intel_device_info {
 	u8 is_broadwater:1;
 	u8 is_crestline:1;
 	u8 is_ivybridge:1;
+	u8 has_force_wake:1;
 	u8 has_fbc:1;
 	u8 has_pipe_cxsr:1;
 	u8 has_hotplug:1;
@@ -1001,6 +1002,8 @@ struct drm_i915_file_private {
 #define HAS_PCH_CPT(dev) (INTEL_PCH_TYPE(dev) =3D=3D PCH_CPT)
 #define HAS_PCH_IBX(dev) (INTEL_PCH_TYPE(dev) =3D=3D PCH_IBX)
=20
+#define HAS_FORCE_WAKE(dev) (INTEL_INFO(dev)->has_force_wake)
+
 #include "i915_trace.h"
=20
 extern struct drm_ioctl_desc i915_ioctls[];
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_re=
g.h
index 06ec1e5..fd53122 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -164,6 +164,14 @@
 #define MI_DISPLAY_FLIP		MI_INSTR(0x14, 2)
 #define MI_DISPLAY_FLIP_I915	MI_INSTR(0x14, 1)
 #define   MI_DISPLAY_FLIP_PLANE(n) ((n) << 20)
+/* IVB has funny definitions for which plane to flip. */
+#define   MI_DISPLAY_FLIP_IVB_PLANE_A  (0 << 19)
+#define   MI_DISPLAY_FLIP_IVB_PLANE_B  (1 << 19)
+#define   MI_DISPLAY_FLIP_IVB_SPRITE_A (2 << 19)
+#define   MI_DISPLAY_FLIP_IVB_SPRITE_B (3 << 19)
+#define   MI_DISPLAY_FLIP_IVB_PLANE_C  (4 << 19)
+#define   MI_DISPLAY_FLIP_IVB_SPRITE_C (5 << 19)
+
 #define MI_SET_CONTEXT		MI_INSTR(0x18, 0)
 #define   MI_MM_SPACE_GTT		(1<<8)
 #define   MI_MM_SPACE_PHYSICAL		(0<<8)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index 4720397..5c1cdb8 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7009,14 +7009,14 @@ static int intel_gen2_queue_flip(struct drm_device =
*dev,
=20
 	ret =3D intel_pin_and_fence_fb_obj(dev, obj, LP_RING(dev_priv));
 	if (ret)
-		goto out;
+		goto err;
=20
 	/* Offset into the new buffer for cases of shared fbs between CRTCs */
 	offset =3D crtc->y * fb->pitch + crtc->x * fb->bits_per_pixel/8;
=20
 	ret =3D BEGIN_LP_RING(6);
 	if (ret)
-		goto out;
+		goto err_unpin;
=20
 	/* Can't queue multiple flips, so wait for the previous
 	 * one to finish before executing the next.
@@ -7033,7 +7033,11 @@ static int intel_gen2_queue_flip(struct drm_device *=
dev,
 	OUT_RING(obj->gtt_offset + offset);
 	OUT_RING(MI_NOOP);
 	ADVANCE_LP_RING();
-out:
+	return 0;
+
+err_unpin:
+	i915_gem_object_unpin(obj);
+err:
 	return ret;
 }
=20
@@ -7050,14 +7054,14 @@ static int intel_gen3_queue_flip(struct drm_device =
*dev,
=20
 	ret =3D intel_pin_and_fence_fb_obj(dev, obj, LP_RING(dev_priv));
 	if (ret)
-		goto out;
+		goto err;
=20
 	/* Offset into the new buffer for cases of shared fbs between CRTCs */
 	offset =3D crtc->y * fb->pitch + crtc->x * fb->bits_per_pixel/8;
=20
 	ret =3D BEGIN_LP_RING(6);
 	if (ret)
-		goto out;
+		goto err_unpin;
=20
 	if (intel_crtc->plane)
 		flip_mask =3D MI_WAIT_FOR_PLANE_B_FLIP;
@@ -7072,7 +7076,11 @@ static int intel_gen3_queue_flip(struct drm_device *=
dev,
 	OUT_RING(MI_NOOP);
=20
 	ADVANCE_LP_RING();
-out:
+	return 0;
+
+err_unpin:
+	i915_gem_object_unpin(obj);
+err:
 	return ret;
 }
=20
@@ -7088,11 +7096,11 @@ static int intel_gen4_queue_flip(struct drm_device =
*dev,
=20
 	ret =3D intel_pin_and_fence_fb_obj(dev, obj, LP_RING(dev_priv));
 	if (ret)
-		goto out;
+		goto err;
=20
 	ret =3D BEGIN_LP_RING(4);
 	if (ret)
-		goto out;
+		goto err_unpin;
=20
 	/* i965+ uses the linear or tiled offsets from the
 	 * Display Registers (which do not change across a page-flip)
@@ -7111,7 +7119,11 @@ static int intel_gen4_queue_flip(struct drm_device *=
dev,
 	pipesrc =3D I915_READ(PIPESRC(intel_crtc->pipe)) & 0x0fff0fff;
 	OUT_RING(pf | pipesrc);
 	ADVANCE_LP_RING();
-out:
+	return 0;
+
+err_unpin:
+	i915_gem_object_unpin(obj);
+err:
 	return ret;
 }
=20
@@ -7127,11 +7139,11 @@ static int intel_gen6_queue_flip(struct drm_device =
*dev,
=20
 	ret =3D intel_pin_and_fence_fb_obj(dev, obj, LP_RING(dev_priv));
 	if (ret)
-		goto out;
+		goto err;
=20
 	ret =3D BEGIN_LP_RING(4);
 	if (ret)
-		goto out;
+		goto err_unpin;
=20
 	OUT_RING(MI_DISPLAY_FLIP |
 		 MI_DISPLAY_FLIP_PLANE(intel_crtc->plane));
@@ -7142,7 +7154,11 @@ static int intel_gen6_queue_flip(struct drm_device *=
dev,
 	pipesrc =3D I915_READ(PIPESRC(intel_crtc->pipe)) & 0x0fff0fff;
 	OUT_RING(pf | pipesrc);
 	ADVANCE_LP_RING();
-out:
+	return 0;
+
+err_unpin:
+	i915_gem_object_unpin(obj);
+err:
 	return ret;
 }
=20
@@ -7160,22 +7176,43 @@ static int intel_gen7_queue_flip(struct drm_device =
*dev,
 	struct drm_i915_private *dev_priv =3D dev->dev_private;
 	struct intel_crtc *intel_crtc =3D to_intel_crtc(crtc);
 	struct intel_ring_buffer *ring =3D &dev_priv->ring[BCS];
+	uint32_t plane_bit =3D 0;
 	int ret;
=20
 	ret =3D intel_pin_and_fence_fb_obj(dev, obj, ring);
 	if (ret)
-		goto out;
+		goto err;
+
+	switch(intel_crtc->plane) {
+	case PLANE_A:
+		plane_bit =3D MI_DISPLAY_FLIP_IVB_PLANE_A;
+		break;
+	case PLANE_B:
+		plane_bit =3D MI_DISPLAY_FLIP_IVB_PLANE_B;
+		break;
+	case PLANE_C:
+		plane_bit =3D MI_DISPLAY_FLIP_IVB_PLANE_C;
+		break;
+	default:
+		WARN_ONCE(1, "unknown plane in flip command\n");
+		ret =3D -ENODEV;
+		goto err;
+	}
=20
 	ret =3D intel_ring_begin(ring, 4);
 	if (ret)
-		goto out;
+		goto err_unpin;
=20
-	intel_ring_emit(ring, MI_DISPLAY_FLIP_I915 | (intel_crtc->plane << 19));
+	intel_ring_emit(ring, MI_DISPLAY_FLIP_I915 | plane_bit);
 	intel_ring_emit(ring, (fb->pitch | obj->tiling_mode));
 	intel_ring_emit(ring, (obj->gtt_offset));
 	intel_ring_emit(ring, (MI_NOOP));
 	intel_ring_advance(ring);
-out:
+	return 0;
+
+err_unpin:
+	i915_gem_object_unpin(obj);
+err:
 	return ret;
 }
=20
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915=
/intel_ringbuffer.c
index 62f9ac5..933e66b 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -263,10 +263,15 @@ u32 intel_ring_get_active_head(struct intel_ring_buff=
er *ring)
=20
 static int init_ring_common(struct intel_ring_buffer *ring)
 {
-	drm_i915_private_t *dev_priv =3D ring->dev->dev_private;
+	struct drm_device *dev =3D ring->dev;
+	drm_i915_private_t *dev_priv =3D dev->dev_private;
 	struct drm_i915_gem_object *obj =3D ring->obj;
+	int ret =3D 0;
 	u32 head;
=20
+	if (HAS_FORCE_WAKE(dev))
+		gen6_gt_force_wake_get(dev_priv);
+
 	/* Stop the ring if it's running. */
 	I915_WRITE_CTL(ring, 0);
 	I915_WRITE_HEAD(ring, 0);
@@ -314,7 +319,8 @@ static int init_ring_common(struct intel_ring_buffer *r=
ing)
 				I915_READ_HEAD(ring),
 				I915_READ_TAIL(ring),
 				I915_READ_START(ring));
-		return -EIO;
+		ret =3D -EIO;
+		goto out;
 	}
=20
 	if (!drm_core_check_feature(ring->dev, DRIVER_MODESET))
@@ -325,7 +331,11 @@ static int init_ring_common(struct intel_ring_buffer *=
ring)
 		ring->space =3D ring_space(ring);
 	}
=20
-	return 0;
+out:
+	if (HAS_FORCE_WAKE(dev))
+		gen6_gt_force_wake_put(dev_priv);
+
+	return ret;
 }
=20
 static int
@@ -1045,6 +1055,10 @@ int intel_init_ring_buffer(struct drm_device *dev,
 	if (ret)
 		goto err_unref;
=20
+	ret =3D i915_gem_object_set_to_gtt_domain(obj, true);
+	if (ret)
+		goto err_unpin;
+
 	ring->map.size =3D ring->size;
 	ring->map.offset =3D dev->agp->base + obj->gtt_offset;
 	ring->map.type =3D 0;
diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/=
nouveau/nouveau_connector.c
index cea6696..1e72db5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -602,6 +602,55 @@ nouveau_connector_scaler_modes_add(struct drm_connecto=
r *connector)
 	return modes;
 }
=20
+static void
+nouveau_connector_detect_depth(struct drm_connector *connector)
+{
+	struct drm_nouveau_private *dev_priv =3D connector->dev->dev_private;
+	struct nouveau_connector *nv_connector =3D nouveau_connector(connector);
+	struct nouveau_encoder *nv_encoder =3D nv_connector->detected_encoder;
+	struct nvbios *bios =3D &dev_priv->vbios;
+	struct drm_display_mode *mode =3D nv_connector->native_mode;
+	bool duallink;
+
+	/* if the edid is feeling nice enough to provide this info, use it */
+	if (nv_connector->edid && connector->display_info.bpc)
+		return;
+
+	/* EDID 1.4 is *supposed* to be supported on eDP, but, Apple... */
+	if (nv_connector->dcb->type =3D=3D DCB_CONNECTOR_eDP) {
+		connector->display_info.bpc =3D 6;
+		return;
+	}
+
+	/* we're out of options unless we're LVDS, default to 8bpc */
+	if (nv_encoder->dcb->type !=3D OUTPUT_LVDS) {
+		connector->display_info.bpc =3D 8;
+		return;
+	}
+
+	connector->display_info.bpc =3D 6;
+
+	/* LVDS: panel straps */
+	if (bios->fp_no_ddc) {
+		if (bios->fp.if_is_24bit)
+			connector->display_info.bpc =3D 8;
+		return;
+	}
+
+	/* LVDS: DDC panel, need to first determine the number of links to
+	 * know which if_is_24bit flag to check...
+	 */
+	if (nv_connector->edid &&
+	    nv_connector->dcb->type =3D=3D DCB_CONNECTOR_LVDS_SPWG)
+		duallink =3D ((u8 *)nv_connector->edid)[121] =3D=3D 2;
+	else
+		duallink =3D mode->clock >=3D bios->fp.duallink_transition_clk;
+
+	if ((!duallink && (bios->fp.strapless_is_24bit & 1)) ||
+	    ( duallink && (bios->fp.strapless_is_24bit & 2)))
+		connector->display_info.bpc =3D 8;
+}
+
 static int
 nouveau_connector_get_modes(struct drm_connector *connector)
 {
@@ -646,6 +695,12 @@ nouveau_connector_get_modes(struct drm_connector *conn=
ector)
 		ret =3D 1;
 	}
=20
+	/* Attempt to determine display colour depth, this has to happen after
+	 * we've determined the "native" mode for LVDS, as the VBIOS tables
+	 * require us to compare against a pixel clock in some cases..
+	 */
+	nouveau_connector_detect_depth(connector);
+
 	if (nv_encoder->dcb->type =3D=3D OUTPUT_TV)
 		ret =3D get_slave_funcs(encoder)->get_modes(encoder, connector);
=20
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/ev=
ergreen.c
index dac178b..931f4df 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2148,6 +2148,9 @@ static void evergreen_gpu_init(struct radeon_device *=
rdev)
 	smx_dc_ctl0 |=3D NUMBER_OF_SETS(rdev->config.evergreen.sx_num_of_sets);
 	WREG32(SMX_DC_CTL0, smx_dc_ctl0);
=20
+	if (rdev->family <=3D CHIP_SUMO2)
+		WREG32(SMX_SAR_CTL0, 0x00010000);
+
 	WREG32(SX_EXPORT_BUFFER_SIZES, (COLOR_BUFFER_SIZE((rdev->config.evergreen=
.sx_max_export_size / 4) - 1) |
 					POSITION_BUFFER_SIZE((rdev->config.evergreen.sx_max_export_pos_size /=
 4) - 1) |
 					SMX_BUFFER_SIZE((rdev->config.evergreen.sx_max_export_smx_size / 4) -=
 1)));
diff --git a/drivers/gpu/drm/radeon/evergreend.h b/drivers/gpu/drm/radeon/e=
vergreend.h
index 0128445..6ecd23f 100644
--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -270,6 +270,7 @@
 #define	SCRATCH_UMSK					0x8540
 #define	SCRATCH_ADDR					0x8544
=20
+#define	SMX_SAR_CTL0					0xA008
 #define	SMX_DC_CTL0					0xA020
 #define		USE_HASH_FUNCTION				(1 << 0)
 #define		NUMBER_OF_SETS(x)				((x) << 1)
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 9cdda0b..bdfa82a 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -1905,6 +1905,7 @@ void r600_gpu_init(struct radeon_device *rdev)
 	WREG32(PA_CL_ENHANCE, (CLIP_VTX_REORDER_ENA |
 			       NUM_CLIP_SEQ(3)));
 	WREG32(PA_SC_ENHANCE, FORCE_EOV_MAX_CLK_CNT(4095));
+	WREG32(VC_ENHANCE, 0);
 }
=20
=20
diff --git a/drivers/gpu/drm/radeon/r600d.h b/drivers/gpu/drm/radeon/r600d.=
h
index bfe1b5d..d4d23a8d 100644
--- a/drivers/gpu/drm/radeon/r600d.h
+++ b/drivers/gpu/drm/radeon/r600d.h
@@ -461,6 +461,7 @@
 #define		TC_L2_SIZE(x)					((x)<<5)
 #define		L2_DISABLE_LATE_HIT				(1<<9)
=20
+#define	VC_ENHANCE					0x9714
=20
 #define	VGT_CACHE_INVALIDATION				0x88C4
 #define		CACHE_INVALIDATION(x)				((x)<<0)
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.=
c
index e36ba7f..cc79449 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -782,6 +782,9 @@ static void rv770_gpu_init(struct radeon_device *rdev)
 				       ACK_FLUSH_CTL(3) |
 				       SYNC_FLUSH_CTL));
=20
+	if (rdev->family !=3D CHIP_RV770)
+		WREG32(SMX_SAR_CTL0, 0x00003f3f);
+
 	db_debug3 =3D RREG32(DB_DEBUG3);
 	db_debug3 &=3D ~DB_CLK_OFF_DELAY(0x1f);
 	switch (rdev->family) {
@@ -960,7 +963,7 @@ static void rv770_gpu_init(struct radeon_device *rdev)
=20
 	WREG32(PA_CL_ENHANCE, (CLIP_VTX_REORDER_ENA |
 					  NUM_CLIP_SEQ(3)));
-
+	WREG32(VC_ENHANCE, 0);
 }
=20
 void r700_vram_gtt_location(struct radeon_device *rdev, struct radeon_mc *=
mc)
diff --git a/drivers/gpu/drm/radeon/rv770d.h b/drivers/gpu/drm/radeon/rv770=
d.h
index 7538092..7095a71 100644
--- a/drivers/gpu/drm/radeon/rv770d.h
+++ b/drivers/gpu/drm/radeon/rv770d.h
@@ -208,6 +208,7 @@
 #define	SCRATCH_UMSK					0x8540
 #define	SCRATCH_ADDR					0x8544
=20
+#define	SMX_SAR_CTL0					0xA008
 #define	SMX_DC_CTL0					0xA020
 #define		USE_HASH_FUNCTION				(1 << 0)
 #define		CACHE_DEPTH(x)					((x) << 1)
@@ -307,6 +308,8 @@
 #define	TCP_CNTL					0x9610
 #define	TCP_CHAN_STEER					0x9614
=20
+#define	VC_ENHANCE					0x9714
+
 #define	VGT_CACHE_INVALIDATION				0x88C4
 #define		CACHE_INVALIDATION(x)				((x)<<0)
 #define			VC_ONLY						0
diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index 9a4c3ab..e8e18ca 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -61,14 +61,14 @@ static ssize_t show_power(struct device *dev,
 				  REG_TDP_RUNNING_AVERAGE, &val);
 	running_avg_capture =3D (val >> 4) & 0x3fffff;
 	running_avg_capture =3D sign_extend32(running_avg_capture, 21);
-	running_avg_range =3D val & 0xf;
+	running_avg_range =3D (val & 0xf) + 1;
=20
 	pci_bus_read_config_dword(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 5),
 				  REG_TDP_LIMIT3, &val);
=20
 	tdp_limit =3D val >> 16;
-	curr_pwr_watts =3D tdp_limit + data->base_tdp -
-		(s32)(running_avg_capture >> (running_avg_range + 1));
+	curr_pwr_watts =3D (tdp_limit + data->base_tdp) << running_avg_range;
+	curr_pwr_watts -=3D running_avg_capture;
 	curr_pwr_watts *=3D data->tdp_to_watts;
=20
 	/*
@@ -78,7 +78,7 @@ static ssize_t show_power(struct device *dev,
 	 * scaling factor 1/(2^16).  For conversion we use
 	 * (10^6)/(2^16) =3D 15625/(2^10)
 	 */
-	curr_pwr_watts =3D (curr_pwr_watts * 15625) >> 10;
+	curr_pwr_watts =3D (curr_pwr_watts * 15625) >> (10 + running_avg_range);
 	return sprintf(buf, "%u\n", (unsigned int) curr_pwr_watts);
 }
 static DEVICE_ATTR(power1_input, S_IRUGO, show_power, NULL);
diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 536bda0..8dc84d6 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -686,7 +686,7 @@ static int c_can_get_berr_counter(const struct net_devi=
ce *dev,
  *
  * We iterate from priv->tx_echo to priv->tx_next and check if the
  * packet has been transmitted, echo it back to the CAN framework.
- * If we discover a not yet transmitted package, stop looking for more.
+ * If we discover a not yet transmitted packet, stop looking for more.
  */
 static void c_can_do_tx(struct net_device *dev)
 {
@@ -698,7 +698,7 @@ static void c_can_do_tx(struct net_device *dev)
 	for (/* nix */; (priv->tx_next - priv->tx_echo) > 0; priv->tx_echo++) {
 		msg_obj_no =3D get_tx_echo_msg_obj(priv);
 		val =3D c_can_read_reg32(priv, &priv->regs->txrqst1);
-		if (!(val & (1 << msg_obj_no))) {
+		if (!(val & (1 << (msg_obj_no - 1)))) {
 			can_get_echo_skb(dev,
 					msg_obj_no - C_CAN_MSG_OBJ_TX_FIRST);
 			stats->tx_bytes +=3D priv->read_reg(priv,
@@ -706,6 +706,8 @@ static void c_can_do_tx(struct net_device *dev)
 					& IF_MCONT_DLC_MASK;
 			stats->tx_packets++;
 			c_can_inval_msg_object(dev, 0, msg_obj_no);
+		} else {
+			break;
 		}
 	}
=20
@@ -950,7 +952,7 @@ static int c_can_poll(struct napi_struct *napi, int quo=
ta)
 	struct net_device *dev =3D napi->dev;
 	struct c_can_priv *priv =3D netdev_priv(dev);
=20
-	irqstatus =3D priv->read_reg(priv, &priv->regs->interrupt);
+	irqstatus =3D priv->irqstatus;
 	if (!irqstatus)
 		goto end;
=20
@@ -1028,12 +1030,11 @@ end:
=20
 static irqreturn_t c_can_isr(int irq, void *dev_id)
 {
-	u16 irqstatus;
 	struct net_device *dev =3D (struct net_device *)dev_id;
 	struct c_can_priv *priv =3D netdev_priv(dev);
=20
-	irqstatus =3D priv->read_reg(priv, &priv->regs->interrupt);
-	if (!irqstatus)
+	priv->irqstatus =3D priv->read_reg(priv, &priv->regs->interrupt);
+	if (!priv->irqstatus)
 		return IRQ_NONE;
=20
 	/* disable all interrupts and schedule the NAPI */
@@ -1063,10 +1064,11 @@ static int c_can_open(struct net_device *dev)
 		goto exit_irq_fail;
 	}
=20
+	napi_enable(&priv->napi);
+
 	/* start the c_can controller */
 	c_can_start(dev);
=20
-	napi_enable(&priv->napi);
 	netif_start_queue(dev);
=20
 	return 0;
diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 9b7fbef..5f32d34 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -76,6 +76,7 @@ struct c_can_priv {
 	unsigned int tx_next;
 	unsigned int tx_echo;
 	void *priv;		/* for board-specific data */
+	u16 irqstatus;
 };
=20
 struct net_device *alloc_c_can_dev(void);
diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index ed1b432..864448b 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -943,7 +943,7 @@ struct sk_buff *sierra_net_tx_fixup(struct usbnet *dev,=
 struct sk_buff *skb,
 }
=20
 static const u8 sierra_net_ifnum_list[] =3D { 7, 10, 11 };
-static const struct sierra_net_info_data sierra_net_info_data_68A3 =3D {
+static const struct sierra_net_info_data sierra_net_info_data_direct_ip =
=3D {
 	.rx_urb_size =3D 8 * 1024,
 	.whitelist =3D {
 		.infolen =3D ARRAY_SIZE(sierra_net_ifnum_list),
@@ -951,7 +951,7 @@ static const struct sierra_net_info_data sierra_net_inf=
o_data_68A3 =3D {
 	}
 };
=20
-static const struct driver_info sierra_net_info_68A3 =3D {
+static const struct driver_info sierra_net_info_direct_ip =3D {
 	.description =3D "Sierra Wireless USB-to-WWAN Modem",
 	.flags =3D FLAG_WWAN | FLAG_SEND_ZLP,
 	.bind =3D sierra_net_bind,
@@ -959,12 +959,18 @@ static const struct driver_info sierra_net_info_68A3 =
=3D {
 	.status =3D sierra_net_status,
 	.rx_fixup =3D sierra_net_rx_fixup,
 	.tx_fixup =3D sierra_net_tx_fixup,
-	.data =3D (unsigned long)&sierra_net_info_data_68A3,
+	.data =3D (unsigned long)&sierra_net_info_data_direct_ip,
 };
=20
 static const struct usb_device_id products[] =3D {
 	{USB_DEVICE(0x1199, 0x68A3), /* Sierra Wireless USB-to-WWAN modem */
-	.driver_info =3D (unsigned long) &sierra_net_info_68A3},
+	.driver_info =3D (unsigned long) &sierra_net_info_direct_ip},
+	{USB_DEVICE(0x0F3D, 0x68A3), /* AT&T Direct IP modem */
+	.driver_info =3D (unsigned long) &sierra_net_info_direct_ip},
+	{USB_DEVICE(0x1199, 0x68AA), /* Sierra Wireless Direct IP LTE modem */
+	.driver_info =3D (unsigned long) &sierra_net_info_direct_ip},
+	{USB_DEVICE(0x0F3D, 0x68AA), /* AT&T Direct IP LTE modem */
+	.driver_info =3D (unsigned long) &sierra_net_info_direct_ip},
=20
 	{}, /* last item */
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless=
/iwlwifi/iwl-6000.c
index 0b9f797..9b6b010 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -49,17 +49,20 @@
 #define IWL6000_UCODE_API_MAX 6
 #define IWL6050_UCODE_API_MAX 5
 #define IWL6000G2_UCODE_API_MAX 6
+#define IWL6035_UCODE_API_MAX 6
=20
 /* Oldest version we won't warn about */
 #define IWL6000_UCODE_API_OK 4
 #define IWL6000G2_UCODE_API_OK 5
 #define IWL6050_UCODE_API_OK 5
 #define IWL6000G2B_UCODE_API_OK 6
+#define IWL6035_UCODE_API_OK 6
=20
 /* Lowest firmware API version supported */
 #define IWL6000_UCODE_API_MIN 4
 #define IWL6050_UCODE_API_MIN 4
-#define IWL6000G2_UCODE_API_MIN 4
+#define IWL6000G2_UCODE_API_MIN 5
+#define IWL6035_UCODE_API_MIN 6
=20
 #define IWL6000_FW_PRE "iwlwifi-6000-"
 #define IWL6000_MODULE_FIRMWARE(api) IWL6000_FW_PRE __stringify(api) ".uco=
de"
@@ -436,9 +439,24 @@ struct iwl_cfg iwl6030_2bg_cfg =3D {
 	IWL_DEVICE_6030,
 };
=20
+#define IWL_DEVICE_6035						\
+	.fw_name_pre =3D IWL6030_FW_PRE,				\
+	.ucode_api_max =3D IWL6035_UCODE_API_MAX,			\
+	.ucode_api_ok =3D IWL6035_UCODE_API_OK,			\
+	.ucode_api_min =3D IWL6035_UCODE_API_MIN,			\
+	.eeprom_ver =3D EEPROM_6030_EEPROM_VERSION,		\
+	.eeprom_calib_ver =3D EEPROM_6030_TX_POWER_VERSION,	\
+	.lib =3D &iwl6030_lib,					\
+	.base_params =3D &iwl6000_g2_base_params,			\
+	.bt_params =3D &iwl6000_bt_params,			\
+	.need_dc_calib =3D true,					\
+	.need_temp_offset_calib =3D true,				\
+	.led_mode =3D IWL_LED_RF_STATE,				\
+	.adv_pm =3D true
+
 struct iwl_cfg iwl6035_2agn_cfg =3D {
 	.name =3D "6035 Series 2x2 AGN/BT",
-	IWL_DEVICE_6030,
+	IWL_DEVICE_6035,
 	.ht_params =3D &iwl6000_ht_params,
 };
=20
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wirel=
ess/iwlwifi/iwl-agn-sta.c
index 5cfb3d1..ccf1524 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -1245,7 +1245,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 		key_flags |=3D STA_KEY_MULTICAST_MSK;
=20
 	sta_cmd.key.key_flags =3D key_flags;
-	sta_cmd.key.key_offset =3D WEP_INVALID_OFFSET;
+	sta_cmd.key.key_offset =3D keyconf->hw_key_idx;
 	sta_cmd.sta.modify_mask =3D STA_MODIFY_KEY_MASK;
 	sta_cmd.mode =3D STA_CONTROL_MODIFY_MSK;
=20
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/=
iwlwifi/iwl-agn.c
index d7d2512..16cdd12 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1696,6 +1696,7 @@ static int iwlagn_mac_setup_register(struct iwl_priv =
*priv,
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
 			    WIPHY_FLAG_IBSS_RSN;
=20
+#ifdef CONFIG_PM_SLEEP
 	if (priv->ucode_wowlan.code.len && device_can_wakeup(bus(priv)->dev)) {
 		hw->wiphy->wowlan.flags =3D WIPHY_WOWLAN_MAGIC_PKT |
 					  WIPHY_WOWLAN_DISCONNECT |
@@ -1712,6 +1713,7 @@ static int iwlagn_mac_setup_register(struct iwl_priv =
*priv,
 		hw->wiphy->wowlan.pattern_max_len =3D
 					IWLAGN_WOWLAN_MAX_PATTERN_LEN;
 	}
+#endif
=20
 	if (iwlagn_mod_params.power_save)
 		hw->wiphy->flags |=3D WIPHY_FLAG_PS_ON_BY_DEFAULT;
@@ -1739,6 +1741,7 @@ static int iwlagn_mac_setup_register(struct iwl_priv =
*priv,
 	ret =3D ieee80211_register_hw(priv->hw);
 	if (ret) {
 		IWL_ERR(priv, "Failed to register hw (error %d)\n", ret);
+		iwl_leds_exit(priv);
 		return ret;
 	}
 	priv->mac80211_registered =3D 1;
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless=
/iwlwifi/iwl-prph.h
index d9b089e..0683006 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -228,6 +228,7 @@
 #define SCD_TXFACT		(SCD_BASE + 0x10)
 #define SCD_ACTIVE		(SCD_BASE + 0x14)
 #define SCD_QUEUECHAIN_SEL	(SCD_BASE + 0xe8)
+#define SCD_CHAINEXT_EN		(SCD_BASE + 0x244)
 #define SCD_AGGR_SEL		(SCD_BASE + 0x248)
 #define SCD_INTERRUPT_MASK	(SCD_BASE + 0x108)
=20
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wi=
reless/iwlwifi/iwl-trans-pcie.c
index 5f17ab8..2f201cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -868,6 +868,11 @@ static void iwl_trans_pcie_tx_start(struct iwl_trans *=
trans)
 	iwl_write_prph(bus(trans), SCD_DRAM_BASE_ADDR,
 		       trans_pcie->scd_bc_tbls.dma >> 10);
=20
+	/* The chain extension of the SCD doesn't work well. This feature is
+	 * enabled by default by the HW, so we need to disable it manually.
+	 */
+	iwl_write_prph(trans, SCD_CHAINEXT_EN, 0);
+
 	/* Enable DMA channel */
 	for (chan =3D 0; chan < FH_TCSR_CHNL_NUM ; chan++)
 		iwl_write_direct32(bus(trans), FH_TCSR_CHNL_TX_CONFIG_REG(chan),
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt=
2x00/rt2x00.h
index 99ff12d..c778164 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -390,8 +390,7 @@ struct rt2x00_intf {
 	 * for hardware which doesn't support hardware
 	 * sequence counting.
 	 */
-	spinlock_t seqlock;
-	u16 seqno;
+	atomic_t seqno;
 };
=20
 static inline struct rt2x00_intf* vif_to_intf(struct ieee80211_vif *vif)
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless=
/rt2x00/rt2x00mac.c
index 373dae1..921da9a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -277,7 +277,6 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	else
 		rt2x00dev->intf_sta_count++;
=20
-	spin_lock_init(&intf->seqlock);
 	mutex_init(&intf->beacon_skb_mutex);
 	intf->beacon =3D entry;
=20
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wirele=
ss/rt2x00/rt2x00queue.c
index 9b1b2b7..50f92d5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -207,6 +207,7 @@ static void rt2x00queue_create_tx_descriptor_seq(struct=
 rt2x00_dev *rt2x00dev,
 	struct ieee80211_tx_info *tx_info =3D IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)skb->data;
 	struct rt2x00_intf *intf =3D vif_to_intf(tx_info->control.vif);
+	u16 seqno;
=20
 	if (!(tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
 		return;
@@ -227,15 +228,13 @@ static void rt2x00queue_create_tx_descriptor_seq(stru=
ct rt2x00_dev *rt2x00dev,
 	 * sequence counting per-frame, since those will override the
 	 * sequence counter given by mac80211.
 	 */
-	spin_lock(&intf->seqlock);
-
 	if (test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags))
-		intf->seqno +=3D 0x10;
-	hdr->seq_ctrl &=3D cpu_to_le16(IEEE80211_SCTL_FRAG);
-	hdr->seq_ctrl |=3D cpu_to_le16(intf->seqno);
-
-	spin_unlock(&intf->seqlock);
+		seqno =3D atomic_add_return(0x10, &intf->seqno);
+	else
+		seqno =3D atomic_read(&intf->seqno);
=20
+	hdr->seq_ctrl &=3D cpu_to_le16(IEEE80211_SCTL_FRAG);
+	hdr->seq_ctrl |=3D cpu_to_le16(seqno);
 }
=20
 static void rt2x00queue_create_tx_descriptor_plcp(struct rt2x00_dev *rt2x0=
0dev,
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6d4a531..e5b75eb 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1689,6 +1689,11 @@ int pci_prepare_to_sleep(struct pci_dev *dev)
 	if (target_state =3D=3D PCI_POWER_ERROR)
 		return -EIO;
=20
+	/* Some devices mustn't be in D3 during system sleep */
+	if (target_state =3D=3D PCI_D3hot &&
+			(dev->dev_flags & PCI_DEV_FLAGS_NO_D3_DURING_SLEEP))
+		return 0;
+
 	pci_enable_wake(dev, target_state, device_may_wakeup(&dev->dev));
=20
 	error =3D pci_set_power_state(dev, target_state);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 78fda9c..3c56fec 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2940,6 +2940,32 @@ static void __devinit disable_igfx_irq(struct pci_de=
v *dev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0102, disable_igfx_irq);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x010a, disable_igfx_irq);
=20
+/*
+ * The Intel 6 Series/C200 Series chipset's EHCI controllers on many
+ * ASUS motherboards will cause memory corruption or a system crash
+ * if they are in D3 while the system is put into S3 sleep.
+ */
+static void __devinit asus_ehci_no_d3(struct pci_dev *dev)
+{
+	const char *sys_info;
+	static const char good_Asus_board[] =3D "P8Z68-V";
+
+	if (dev->dev_flags & PCI_DEV_FLAGS_NO_D3_DURING_SLEEP)
+		return;
+	if (dev->subsystem_vendor !=3D PCI_VENDOR_ID_ASUSTEK)
+		return;
+	sys_info =3D dmi_get_system_info(DMI_BOARD_NAME);
+	if (sys_info && memcmp(sys_info, good_Asus_board,
+			sizeof(good_Asus_board) - 1) =3D=3D 0)
+		return;
+
+	dev_info(&dev->dev, "broken D3 during system sleep on ASUS\n");
+	dev->dev_flags |=3D PCI_DEV_FLAGS_NO_D3_DURING_SLEEP;
+	device_set_wakeup_capable(&dev->dev, false);
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1c26, asus_ehci_no_d3);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1c2d, asus_ehci_no_d3);
+
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt=
2sas_base.c
index ac336e1..e903077 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1739,7 +1739,7 @@ static inline void _base_writeq(__u64 b, volatile voi=
d __iomem *addr,
 static inline u8
 _base_get_msix_index(struct MPT2SAS_ADAPTER *ioc)
 {
-	return ioc->cpu_msix_table[smp_processor_id()];
+	return ioc->cpu_msix_table[raw_smp_processor_id()];
 }
=20
 /**
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core=
_alua.c
index 5b05744..0364ca2 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -352,9 +352,11 @@ int target_emulate_set_target_port_groups(struct se_ta=
sk *task)
=20
 out:
 	transport_kunmap_data_sg(cmd);
-	task->task_scsi_status =3D GOOD;
-	transport_complete_task(task, 1);
-	return 0;
+	if (!rc) {
+		task->task_scsi_status =3D GOOD;
+		transport_complete_task(task, 1);
+	}
+	return rc;
 }
=20
 static inline int core_alua_state_nonoptimized(
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index e61d9c4..1094469 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -498,6 +498,14 @@ static int acm_tty_open(struct tty_struct *tty, struct=
 file *filp)
=20
 	usb_autopm_put_interface(acm->control);
=20
+	/*
+	 * Unthrottle device in case the TTY was closed while throttled.
+	 */
+	spin_lock_irq(&acm->read_lock);
+	acm->throttled =3D 0;
+	acm->throttle_req =3D 0;
+	spin_unlock_irq(&acm->read_lock);
+
 	if (acm_submit_read_urbs(acm, GFP_KERNEL))
 		goto bail_out;
=20
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 554ac90..1bc00a2 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -31,6 +31,8 @@
 #define DRIVER_AUTHOR "Oliver Neukum"
 #define DRIVER_DESC "USB Abstract Control Model driver for USB WCM Device =
Management"
=20
+#define HUAWEI_VENDOR_ID	0x12D1
+
 static const struct usb_device_id wdm_ids[] =3D {
 	{
 		.match_flags =3D USB_DEVICE_ID_MATCH_INT_CLASS |
@@ -38,6 +40,29 @@ static const struct usb_device_id wdm_ids[] =3D {
 		.bInterfaceClass =3D USB_CLASS_COMM,
 		.bInterfaceSubClass =3D USB_CDC_SUBCLASS_DMM
 	},
+	{
+		/*=20
+		 * Huawei E392, E398 and possibly other Qualcomm based modems
+		 * embed the Qualcomm QMI protocol inside CDC on CDC ECM like
+		 * control interfaces.  Userspace access to this is required
+		 * to configure the accompanying data interface
+		 */
+		.match_flags        =3D USB_DEVICE_ID_MATCH_VENDOR |
+					USB_DEVICE_ID_MATCH_INT_INFO,
+		.idVendor           =3D HUAWEI_VENDOR_ID,
+		.bInterfaceClass    =3D USB_CLASS_VENDOR_SPEC,
+		.bInterfaceSubClass =3D 1,
+		.bInterfaceProtocol =3D 9, /* NOTE: CDC ECM control interface! */
+	},
+	{
+		 /* Vodafone/Huawei K5005 (12d1:14c8) and similar modems */
+		.match_flags        =3D USB_DEVICE_ID_MATCH_VENDOR |
+				      USB_DEVICE_ID_MATCH_INT_INFO,
+		.idVendor           =3D HUAWEI_VENDOR_ID,
+		.bInterfaceClass    =3D USB_CLASS_VENDOR_SPEC,
+		.bInterfaceSubClass =3D 1,
+		.bInterfaceProtocol =3D 57, /* NOTE: CDC ECM control interface! */
+	},
 	{ }
 };
=20
diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index 5f1404a..61d08dd 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -495,15 +495,6 @@ static int hcd_pci_suspend_noirq(struct device *dev)
=20
 	pci_save_state(pci_dev);
=20
-	/*
-	 * Some systems crash if an EHCI controller is in D3 during
-	 * a sleep transition.  We have to leave such controllers in D0.
-	 */
-	if (hcd->broken_pci_sleep) {
-		dev_dbg(dev, "Staying in PCI D0\n");
-		return retval;
-	}
-
 	/* If the root hub is dead rather than suspended, disallow remote
 	 * wakeup.  usb_hc_died() should ensure that both hosts are marked as
 	 * dying, so we only need to check the primary roothub.
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index ca717da..ef116a5 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1803,7 +1803,6 @@ free_interfaces:
 		intfc =3D cp->intf_cache[i];
 		intf->altsetting =3D intfc->altsetting;
 		intf->num_altsetting =3D intfc->num_altsetting;
-		intf->intf_assoc =3D find_iad(dev, cp, i);
 		kref_get(&intfc->ref);
=20
 		alt =3D usb_altnum_to_altsetting(intf, 0);
@@ -1816,6 +1815,8 @@ free_interfaces:
 		if (!alt)
 			alt =3D &intf->altsetting[0];
=20
+		intf->intf_assoc =3D
+			find_iad(dev, cp, alt->desc.bInterfaceNumber);
 		intf->cur_altsetting =3D alt;
 		usb_enable_interface(dev, intf, true);
 		intf->dev.parent =3D &dev->dev;
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index da2f711..339be10 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -620,6 +620,9 @@ static int ehci_init(struct usb_hcd *hcd)
 	hw =3D ehci->async->hw;
 	hw->hw_next =3D QH_NEXT(ehci, ehci->async->qh_dma);
 	hw->hw_info1 =3D cpu_to_hc32(ehci, QH_HEAD);
+#if defined(CONFIG_PPC_PS3)
+	hw->hw_info1 |=3D cpu_to_hc32(ehci, (1 << 7));	/* I =3D 1 */
+#endif
 	hw->hw_token =3D cpu_to_hc32(ehci, QTD_STS_HALT);
 	hw->hw_qtd_next =3D EHCI_LIST_END(ehci);
 	ehci->async->qh_state =3D QH_STATE_LINKED;
diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index ee85e81..a79e64b 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -144,14 +144,6 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
 			hcd->has_tt =3D 1;
 			tdi_reset(ehci);
 		}
-		if (pdev->subsystem_vendor =3D=3D PCI_VENDOR_ID_ASUSTEK) {
-			/* EHCI #1 or #2 on 6 Series/C200 Series chipset */
-			if (pdev->device =3D=3D 0x1c26 || pdev->device =3D=3D 0x1c2d) {
-				ehci_info(ehci, "broken D3 during system sleep on ASUS\n");
-				hcd->broken_pci_sleep =3D 1;
-				device_set_wakeup_capable(&pdev->dev, false);
-			}
-		}
 		break;
 	case PCI_VENDOR_ID_TDI:
 		if (pdev->device =3D=3D PCI_DEVICE_ID_TDI_EHCI) {
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 4232e868..a40ab98 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -693,10 +693,9 @@ static void xhci_free_tt_info(struct xhci_hcd *xhci,
 		struct xhci_virt_device *virt_dev,
 		int slot_id)
 {
-	struct list_head *tt;
 	struct list_head *tt_list_head;
-	struct list_head *tt_next;
-	struct xhci_tt_bw_info *tt_info;
+	struct xhci_tt_bw_info *tt_info, *next;
+	bool slot_found =3D false;
=20
 	/* If the device never made it past the Set Address stage,
 	 * it may not have the real_port set correctly.
@@ -708,34 +707,16 @@ static void xhci_free_tt_info(struct xhci_hcd *xhci,
 	}
=20
 	tt_list_head =3D &(xhci->rh_bw[virt_dev->real_port - 1].tts);
-	if (list_empty(tt_list_head))
-		return;
-
-	list_for_each(tt, tt_list_head) {
-		tt_info =3D list_entry(tt, struct xhci_tt_bw_info, tt_list);
-		if (tt_info->slot_id =3D=3D slot_id)
+	list_for_each_entry_safe(tt_info, next, tt_list_head, tt_list) {
+		/* Multi-TT hubs will have more than one entry */
+		if (tt_info->slot_id =3D=3D slot_id) {
+			slot_found =3D true;
+			list_del(&tt_info->tt_list);
+			kfree(tt_info);
+		} else if (slot_found) {
 			break;
+		}
 	}
-	/* Cautionary measure in case the hub was disconnected before we
-	 * stored the TT information.
-	 */
-	if (tt_info->slot_id !=3D slot_id)
-		return;
-
-	tt_next =3D tt->next;
-	tt_info =3D list_entry(tt, struct xhci_tt_bw_info,
-			tt_list);
-	/* Multi-TT hubs will have more than one entry */
-	do {
-		list_del(tt);
-		kfree(tt_info);
-		tt =3D tt_next;
-		if (list_empty(tt_list_head))
-			break;
-		tt_next =3D tt->next;
-		tt_info =3D list_entry(tt, struct xhci_tt_bw_info,
-				tt_list);
-	} while (tt_info->slot_id =3D=3D slot_id);
 }
=20
 int xhci_alloc_tt_info(struct xhci_hcd *xhci,
@@ -1699,17 +1680,9 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 {
 	struct pci_dev	*pdev =3D to_pci_dev(xhci_to_hcd(xhci)->self.controller);
 	struct dev_info	*dev_info, *next;
-	struct list_head *tt_list_head;
-	struct list_head *tt;
-	struct list_head *endpoints;
-	struct list_head *ep, *q;
-	struct xhci_tt_bw_info *tt_info;
-	struct xhci_interval_bw_table *bwt;
-	struct xhci_virt_ep *virt_ep;
-
 	unsigned long	flags;
 	int size;
-	int i;
+	int i, j, num_ports;
=20
 	/* Free the Event Ring Segment Table and the actual Event Ring */
 	size =3D sizeof(struct xhci_erst_entry)*(xhci->erst.num_entries);
@@ -1766,21 +1739,22 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	}
 	spin_unlock_irqrestore(&xhci->lock, flags);
=20
-	bwt =3D &xhci->rh_bw->bw_table;
-	for (i =3D 0; i < XHCI_MAX_INTERVAL; i++) {
-		endpoints =3D &bwt->interval_bw[i].endpoints;
-		list_for_each_safe(ep, q, endpoints) {
-			virt_ep =3D list_entry(ep, struct xhci_virt_ep, bw_endpoint_list);
-			list_del(&virt_ep->bw_endpoint_list);
-			kfree(virt_ep);
+	num_ports =3D HCS_MAX_PORTS(xhci->hcs_params1);
+	for (i =3D 0; i < num_ports; i++) {
+		struct xhci_interval_bw_table *bwt =3D &xhci->rh_bw[i].bw_table;
+		for (j =3D 0; j < XHCI_MAX_INTERVAL; j++) {
+			struct list_head *ep =3D &bwt->interval_bw[j].endpoints;
+			while (!list_empty(ep))
+				list_del_init(ep->next);
 		}
 	}
=20
-	tt_list_head =3D &xhci->rh_bw->tts;
-	list_for_each_safe(tt, q, tt_list_head) {
-		tt_info =3D list_entry(tt, struct xhci_tt_bw_info, tt_list);
-		list_del(tt);
-		kfree(tt_info);
+	for (i =3D 0; i < num_ports; i++) {
+		struct xhci_tt_bw_info *tt, *n;
+		list_for_each_entry_safe(tt, n, &xhci->rh_bw[i].tts, tt_list) {
+			list_del(&tt->tt_list);
+			kfree(tt);
+		}
 	}
=20
 	xhci->num_usb2_ports =3D 0;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 4c00606..05f82e9 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -783,8 +783,8 @@ int xhci_suspend(struct xhci_hcd *xhci)
 	command =3D xhci_readl(xhci, &xhci->op_regs->command);
 	command |=3D CMD_CSS;
 	xhci_writel(xhci, command, &xhci->op_regs->command);
-	if (handshake(xhci, &xhci->op_regs->status, STS_SAVE, 0, 10*100)) {
-		xhci_warn(xhci, "WARN: xHC CMD_CSS timeout\n");
+	if (handshake(xhci, &xhci->op_regs->status, STS_SAVE, 0, 10 * 1000)) {
+		xhci_warn(xhci, "WARN: xHC save state timeout\n");
 		spin_unlock_irq(&xhci->lock);
 		return -ETIMEDOUT;
 	}
@@ -836,8 +836,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 		command |=3D CMD_CRS;
 		xhci_writel(xhci, command, &xhci->op_regs->command);
 		if (handshake(xhci, &xhci->op_regs->status,
-			      STS_RESTORE, 0, 10*100)) {
-			xhci_dbg(xhci, "WARN: xHC CMD_CSS timeout\n");
+			      STS_RESTORE, 0, 10 * 1000)) {
+			xhci_warn(xhci, "WARN: xHC restore state timeout\n");
 			spin_unlock_irq(&xhci->lock);
 			return -ETIMEDOUT;
 		}
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.=
c
index c860597..9c8845a 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1234,6 +1234,7 @@ static int musb_gadget_disable(struct usb_ep *ep)
 	}
=20
 	musb_ep->desc =3D NULL;
+	musb_ep->end_point.desc =3D NULL;
=20
 	/* abort all pending DMA and requests */
 	nuke(musb_ep, -ESHUTDOWN);
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index f2c57e0..aa0c43f 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -82,6 +82,7 @@ static const struct usb_device_id id_table[] =3D {
 	{ USB_DEVICE(0x10C4, 0x8066) }, /* Argussoft In-System Programmer */
 	{ USB_DEVICE(0x10C4, 0x806F) }, /* IMS USB to RS422 Converter Cable */
 	{ USB_DEVICE(0x10C4, 0x807A) }, /* Crumb128 board */
+	{ USB_DEVICE(0x10C4, 0x80C4) }, /* Cygnal Integrated Products, Inc., Optr=
is infrared thermometer */
 	{ USB_DEVICE(0x10C4, 0x80CA) }, /* Degree Controls Inc */
 	{ USB_DEVICE(0x10C4, 0x80DD) }, /* Tracient RFID */
 	{ USB_DEVICE(0x10C4, 0x80F6) }, /* Suunto sports instrument */
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 450bdfe..4045e39 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -737,6 +737,7 @@ static struct usb_device_id id_table_combined [] =3D {
 	{ USB_DEVICE(TELLDUS_VID, TELLDUS_TELLSTICK_PID) },
 	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_SERIAL_VX7_PID) },
 	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_CT29B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_RTS01_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MAXSTREAM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_PHI_FISCO_PID) },
 	{ USB_DEVICE(TML_VID, TML_USB_SERIAL_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_si=
o_ids.h
index 219b199..d27d7d7 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -784,6 +784,7 @@
 #define RTSYSTEMS_VID			0x2100	/* Vendor ID */
 #define RTSYSTEMS_SERIAL_VX7_PID	0x9e52	/* Serial converter for VX-7 Radio=
s using FT232RL */
 #define RTSYSTEMS_CT29B_PID		0x9e54	/* CT29B Radio Cable */
+#define RTSYSTEMS_RTS01_PID		0x9e57	/* USB-RTS01 Radio Cable */
=20
=20
 /*
diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index ba0d287..42de17b 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -359,13 +359,16 @@ static int mct_u232_set_modem_ctrl(struct usb_serial =
*serial,
 			MCT_U232_SET_REQUEST_TYPE,
 			0, 0, buf, MCT_U232_SET_MODEM_CTRL_SIZE,
 			WDR_TIMEOUT);
-	if (rc < 0)
-		dev_err(&serial->dev->dev,
-			"Set MODEM CTRL 0x%x failed (error =3D %d)\n", mcr, rc);
+	kfree(buf);
+
 	dbg("set_modem_ctrl: state=3D0x%x =3D=3D> mcr=3D0x%x", control_state, mcr=
);
=20
-	kfree(buf);
-	return rc;
+	if (rc < 0) {
+		dev_err(&serial->dev->dev,
+			"Set MODEM CTRL 0x%x failed (error =3D %d)\n", mcr, rc);
+		return rc;
+	}
+	return 0;
 } /* mct_u232_set_modem_ctrl */
=20
 static int mct_u232_get_modem_stat(struct usb_serial *serial,
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index cbe3451..ce02457 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -47,6 +47,7 @@
 /* Function prototypes */
 static int  option_probe(struct usb_serial *serial,
 			const struct usb_device_id *id);
+static void option_release(struct usb_serial *serial);
 static int option_send_setup(struct usb_serial_port *port);
 static void option_instat_callback(struct urb *urb);
=20
@@ -150,6 +151,7 @@ static void option_instat_callback(struct urb *urb);
 #define HUAWEI_PRODUCT_E14AC			0x14AC
 #define HUAWEI_PRODUCT_K3806			0x14AE
 #define HUAWEI_PRODUCT_K4605			0x14C6
+#define HUAWEI_PRODUCT_K5005			0x14C8
 #define HUAWEI_PRODUCT_K3770			0x14C9
 #define HUAWEI_PRODUCT_K3771			0x14CA
 #define HUAWEI_PRODUCT_K4510			0x14CB
@@ -425,7 +427,7 @@ static void option_instat_callback(struct urb *urb);
 #define SAMSUNG_VENDOR_ID                       0x04e8
 #define SAMSUNG_PRODUCT_GT_B3730                0x6889
=20
-/* YUGA products  www.yuga-info.com*/
+/* YUGA products  www.yuga-info.com gavin.kx@qq.com */
 #define YUGA_VENDOR_ID				0x257A
 #define YUGA_PRODUCT_CEM600			0x1601
 #define YUGA_PRODUCT_CEM610			0x1602
@@ -442,6 +444,8 @@ static void option_instat_callback(struct urb *urb);
 #define YUGA_PRODUCT_CEU516			0x160C
 #define YUGA_PRODUCT_CEU528			0x160D
 #define YUGA_PRODUCT_CEU526			0x160F
+#define YUGA_PRODUCT_CEU881			0x161F
+#define YUGA_PRODUCT_CEU882			0x162F
=20
 #define YUGA_PRODUCT_CWM600			0x2601
 #define YUGA_PRODUCT_CWM610			0x2602
@@ -457,23 +461,26 @@ static void option_instat_callback(struct urb *urb);
 #define YUGA_PRODUCT_CWU518			0x260B
 #define YUGA_PRODUCT_CWU516			0x260C
 #define YUGA_PRODUCT_CWU528			0x260D
+#define YUGA_PRODUCT_CWU581			0x260E
 #define YUGA_PRODUCT_CWU526			0x260F
-
-#define YUGA_PRODUCT_CLM600			0x2601
-#define YUGA_PRODUCT_CLM610			0x2602
-#define YUGA_PRODUCT_CLM500			0x2603
-#define YUGA_PRODUCT_CLM510			0x2604
-#define YUGA_PRODUCT_CLM800			0x2605
-#define YUGA_PRODUCT_CLM900			0x2606
-
-#define YUGA_PRODUCT_CLU718			0x2607
-#define YUGA_PRODUCT_CLU716			0x2608
-#define YUGA_PRODUCT_CLU728			0x2609
-#define YUGA_PRODUCT_CLU726			0x260A
-#define YUGA_PRODUCT_CLU518			0x260B
-#define YUGA_PRODUCT_CLU516			0x260C
-#define YUGA_PRODUCT_CLU528			0x260D
-#define YUGA_PRODUCT_CLU526			0x260F
+#define YUGA_PRODUCT_CWU582			0x261F
+#define YUGA_PRODUCT_CWU583			0x262F
+
+#define YUGA_PRODUCT_CLM600			0x3601
+#define YUGA_PRODUCT_CLM610			0x3602
+#define YUGA_PRODUCT_CLM500			0x3603
+#define YUGA_PRODUCT_CLM510			0x3604
+#define YUGA_PRODUCT_CLM800			0x3605
+#define YUGA_PRODUCT_CLM900			0x3606
+
+#define YUGA_PRODUCT_CLU718			0x3607
+#define YUGA_PRODUCT_CLU716			0x3608
+#define YUGA_PRODUCT_CLU728			0x3609
+#define YUGA_PRODUCT_CLU726			0x360A
+#define YUGA_PRODUCT_CLU518			0x360B
+#define YUGA_PRODUCT_CLU516			0x360C
+#define YUGA_PRODUCT_CLU528			0x360D
+#define YUGA_PRODUCT_CLU526			0x360F
=20
 /* Viettel products */
 #define VIETTEL_VENDOR_ID			0x2262
@@ -666,6 +673,11 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3806, 0=
xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4605, 0=
xff, 0xff, 0xff),
 		.driver_info =3D (kernel_ulong_t) &huawei_cdc12_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4605, 0=
xff, 0x01, 0x31) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4605, 0=
xff, 0x01, 0x32) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K5005, 0=
xff, 0x01, 0x31) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K5005, 0=
xff, 0x01, 0x32) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K5005, 0=
xff, 0x01, 0x33) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0=
xff, 0x02, 0x31) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0=
xff, 0x02, 0x32) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3771, 0=
xff, 0x02, 0x31) },
@@ -1207,6 +1219,11 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU516) },
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU528) },
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CLU526) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEU881) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEU882) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWU581) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWU582) },
+	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CWU583) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(VIETTEL_VENDOR_ID, VIETTEL_PRODUCT_VT1000=
, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZD_VENDOR_ID, ZD_PRODUCT_7000, 0xff, 0xff=
, 0xff) },
 	{ USB_DEVICE(LG_VENDOR_ID, LG_PRODUCT_L02C) }, /* docomo L-02C modem */
@@ -1257,7 +1274,7 @@ static struct usb_serial_driver option_1port_device =
=3D {
 	.ioctl             =3D usb_wwan_ioctl,
 	.attach            =3D usb_wwan_startup,
 	.disconnect        =3D usb_wwan_disconnect,
-	.release           =3D usb_wwan_release,
+	.release           =3D option_release,
 	.read_int_callback =3D option_instat_callback,
 #ifdef CONFIG_PM
 	.suspend           =3D usb_wwan_suspend,
@@ -1267,35 +1284,6 @@ static struct usb_serial_driver option_1port_device =
=3D {
=20
 static int debug;
=20
-/* per port private data */
-
-#define N_IN_URB 4
-#define N_OUT_URB 4
-#define IN_BUFLEN 4096
-#define OUT_BUFLEN 4096
-
-struct option_port_private {
-	/* Input endpoints and buffer for this port */
-	struct urb *in_urbs[N_IN_URB];
-	u8 *in_buffer[N_IN_URB];
-	/* Output endpoints and buffer for this port */
-	struct urb *out_urbs[N_OUT_URB];
-	u8 *out_buffer[N_OUT_URB];
-	unsigned long out_busy;		/* Bit vector of URBs in use */
-	int opened;
-	struct usb_anchor delayed;
-
-	/* Settings for the port */
-	int rts_state;	/* Handshaking pins (outputs) */
-	int dtr_state;
-	int cts_state;	/* Handshaking pins (inputs) */
-	int dsr_state;
-	int dcd_state;
-	int ri_state;
-
-	unsigned long tx_start_time[N_OUT_URB];
-};
-
 /* Functions used by new usb-serial code. */
 static int __init option_init(void)
 {
@@ -1393,12 +1381,22 @@ static int option_probe(struct usb_serial *serial,
 	return 0;
 }
=20
+static void option_release(struct usb_serial *serial)
+{
+	struct usb_wwan_intf_private *priv =3D usb_get_serial_data(serial);
+
+	usb_wwan_release(serial);
+
+	kfree(priv);
+}
+
 static void option_instat_callback(struct urb *urb)
 {
 	int err;
 	int status =3D urb->status;
 	struct usb_serial_port *port =3D  urb->context;
-	struct option_port_private *portdata =3D usb_get_serial_port_data(port);
+	struct usb_wwan_port_private *portdata =3D
+					usb_get_serial_port_data(port);
=20
 	dbg("%s", __func__);
 	dbg("%s: urb %p port %p has data %p", __func__, urb, port, portdata);
@@ -1459,7 +1457,7 @@ static int option_send_setup(struct usb_serial_port *=
port)
 	struct usb_serial *serial =3D port->serial;
 	struct usb_wwan_intf_private *intfdata =3D
 		(struct usb_wwan_intf_private *) serial->private;
-	struct option_port_private *portdata;
+	struct usb_wwan_port_private *portdata;
 	int ifNum =3D serial->interface->cur_altsetting->desc.bInterfaceNumber;
 	int val =3D 0;
 	dbg("%s", __func__);
diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 3187d8b..6634477 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -105,7 +105,13 @@ static const struct usb_device_id id_table[] =3D {
 	{USB_DEVICE(0x1410, 0xa021)},	/* Novatel Gobi 3000 Composite */
 	{USB_DEVICE(0x413c, 0x8193)},	/* Dell Gobi 3000 QDL */
 	{USB_DEVICE(0x413c, 0x8194)},	/* Dell Gobi 3000 Composite */
+	{USB_DEVICE(0x1199, 0x9010)},	/* Sierra Wireless Gobi 3000 QDL */
+	{USB_DEVICE(0x1199, 0x9012)},	/* Sierra Wireless Gobi 3000 QDL */
 	{USB_DEVICE(0x1199, 0x9013)},	/* Sierra Wireless Gobi 3000 Modem device (=
MC8355) */
+	{USB_DEVICE(0x1199, 0x9014)},	/* Sierra Wireless Gobi 3000 QDL */
+	{USB_DEVICE(0x1199, 0x9015)},	/* Sierra Wireless Gobi 3000 Modem device *=
/
+	{USB_DEVICE(0x1199, 0x9018)},	/* Sierra Wireless Gobi 3000 QDL */
+	{USB_DEVICE(0x1199, 0x9019)},	/* Sierra Wireless Gobi 3000 Modem device *=
/
 	{USB_DEVICE(0x12D1, 0x14F0)},	/* Sony Gobi 3000 QDL */
 	{USB_DEVICE(0x12D1, 0x14F1)},	/* Sony Gobi 3000 Composite */
 	{ }				/* Terminating entry */
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index e093585..535d087 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -304,6 +304,10 @@ static const struct usb_device_id id_table[] =3D {
 	{ USB_DEVICE(0x1199, 0x68A3), 	/* Sierra Wireless Direct IP modems */
 	  .driver_info =3D (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
+	/* AT&T Direct IP LTE modems */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0F3D, 0x68AA, 0xFF, 0xFF, 0xFF),
+	  .driver_info =3D (kernel_ulong_t)&direct_ip_interface_blacklist
+	},
 	{ USB_DEVICE(0x0f3d, 0x68A3), 	/* Airprime/Sierra Wireless Direct IP mode=
ms */
 	  .driver_info =3D (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-seria=
l.c
index 38d7ebd..8bea45c 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -669,12 +669,14 @@ exit:
 static struct usb_serial_driver *search_serial_device(
 					struct usb_interface *iface)
 {
-	const struct usb_device_id *id;
+	const struct usb_device_id *id =3D NULL;
 	struct usb_serial_driver *drv;
+	struct usb_driver *driver =3D to_usb_driver(iface->dev.driver);
=20
 	/* Check if the usb id matches a known device */
 	list_for_each_entry(drv, &usb_serial_driver_list, driver_list) {
-		id =3D get_iface_id(drv, iface);
+		if (drv->usb_driver =3D=3D driver)
+			id =3D get_iface_id(drv, iface);
 		if (id)
 			return drv;
 	}
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusu=
al_devs.h
index 591f57f..6dcb5c4 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1107,6 +1107,13 @@ UNUSUAL_DEV( 0x090a, 0x1200, 0x0000, 0x9999,
 		USB_SC_RBC, USB_PR_BULK, NULL,
 		0 ),
=20
+/* Feiya QDI U2 DISK, reported by Hans de Goede <hdegoede@redhat.com> */
+UNUSUAL_DEV( 0x090c, 0x1000, 0x0000, 0xffff,
+		"Feiya",
+		"QDI U2 DISK",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_READ_CAPACITY_16 ),
+
 /* aeb */
 UNUSUAL_DEV( 0x090c, 0x1132, 0x0000, 0xffff,
 		"Feiya",
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 9f63e49..5ef7afb 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -858,6 +858,7 @@ int fuse_update_attributes(struct inode *inode, struct =
kstat *stat,
 		if (stat) {
 			generic_fillattr(inode, stat);
 			stat->mode =3D fi->orig_i_mode;
+			stat->ino =3D fi->orig_ino;
 		}
 	}
=20
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index cf6db0a..89c4a58 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -82,6 +82,9 @@ struct fuse_inode {
 	    preserve the original mode */
 	mode_t orig_i_mode;
=20
+	/** 64 bit inode number */
+	u64 orig_ino;
+
 	/** Version of last attribute change */
 	u64 attr_version;
=20
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index aa83109..1f82d95 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -91,6 +91,7 @@ static struct inode *fuse_alloc_inode(struct super_block =
*sb)
 	fi->nlookup =3D 0;
 	fi->attr_version =3D 0;
 	fi->writectr =3D 0;
+	fi->orig_ino =3D 0;
 	INIT_LIST_HEAD(&fi->write_files);
 	INIT_LIST_HEAD(&fi->queued_writes);
 	INIT_LIST_HEAD(&fi->writepages);
@@ -140,6 +141,18 @@ static int fuse_remount_fs(struct super_block *sb, int=
 *flags, char *data)
 	return 0;
 }
=20
+/*
+ * ino_t is 32-bits on 32-bit arch. We have to squash the 64-bit value dow=
n
+ * so that it will fit.
+ */
+static ino_t fuse_squash_ino(u64 ino64)
+{
+	ino_t ino =3D (ino_t) ino64;
+	if (sizeof(ino_t) < sizeof(u64))
+		ino ^=3D ino64 >> (sizeof(u64) - sizeof(ino_t)) * 8;
+	return ino;
+}
+
 void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *=
attr,
 				   u64 attr_valid)
 {
@@ -149,7 +162,7 @@ void fuse_change_attributes_common(struct inode *inode,=
 struct fuse_attr *attr,
 	fi->attr_version =3D ++fc->attr_version;
 	fi->i_time =3D attr_valid;
=20
-	inode->i_ino     =3D attr->ino;
+	inode->i_ino     =3D fuse_squash_ino(attr->ino);
 	inode->i_mode    =3D (inode->i_mode & S_IFMT) | (attr->mode & 07777);
 	set_nlink(inode, attr->nlink);
 	inode->i_uid     =3D attr->uid;
@@ -175,6 +188,8 @@ void fuse_change_attributes_common(struct inode *inode,=
 struct fuse_attr *attr,
 	fi->orig_i_mode =3D inode->i_mode;
 	if (!(fc->flags & FUSE_DEFAULT_PERMISSIONS))
 		inode->i_mode &=3D ~S_ISVTX;
+
+	fi->orig_ino =3D attr->ino;
 }
=20
 void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index a3cae5d..8000459 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1825,6 +1825,7 @@ static struct nfs4_state *nfs4_do_open(struct inode *=
dir, struct dentry *dentry,
 	struct nfs4_state *res;
 	int status;
=20
+	fmode &=3D FMODE_READ|FMODE_WRITE;
 	do {
 		status =3D _nfs4_do_open(dir, dentry, fmode, flags, sattr, cred, &res);
 		if (status =3D=3D 0)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7cda65b..c0cfa0d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -176,6 +176,8 @@ enum pci_dev_flags {
 	PCI_DEV_FLAGS_NO_D3 =3D (__force pci_dev_flags_t) 2,
 	/* Provide indication device is assigned by a Virtual Machine Manager */
 	PCI_DEV_FLAGS_ASSIGNED =3D (__force pci_dev_flags_t) 4,
+	/* Device causes system crash if in D3 during S3 sleep */
+	PCI_DEV_FLAGS_NO_D3_DURING_SLEEP =3D (__force pci_dev_flags_t) 8,
 };
=20
 enum pci_irq_reroute_variant {
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 2189d3f..d6955607 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -8,13 +8,15 @@
  * get good packing density in that tree, so the index should be dense in
  * the low-order bits.
  *
- * We arrange the `type' and `offset' fields so that `type' is at the five
+ * We arrange the `type' and `offset' fields so that `type' is at the seve=
n
  * high-order bits of the swp_entry_t and `offset' is right-aligned in the
- * remaining bits.
+ * remaining bits.  Although `type' itself needs only five bits, we allow =
for
+ * shmem/tmpfs to shift it all up a further two bits: see swp_to_radix_ent=
ry().
  *
  * swp_entry_t's are *never* stored anywhere in their arch-dependent forma=
t.
  */
-#define SWP_TYPE_SHIFT(e)	(sizeof(e.val) * 8 - MAX_SWAPFILES_SHIFT)
+#define SWP_TYPE_SHIFT(e)	((sizeof(e.val) * 8) - \
+			(MAX_SWAPFILES_SHIFT + RADIX_TREE_EXCEPTIONAL_SHIFT))
 #define SWP_OFFSET_MASK(e)	((1UL << SWP_TYPE_SHIFT(e)) - 1)
=20
 /*
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 64cec8d..03354d5 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -128,8 +128,6 @@ struct usb_hcd {
 	unsigned		wireless:1;	/* Wireless USB HCD */
 	unsigned		authorized_default:1;
 	unsigned		has_tt:1;	/* Integrated TT in root hub */
-	unsigned		broken_pci_sleep:1;	/* Don't put the
-			controller in PCI-D3 for system sleep */
=20
 	int			irq;		/* irq allocated */
 	void __iomem		*regs;		/* device memory/io */
diff --git a/kernel/sched.c b/kernel/sched.c
index 299f55c..576a27f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7429,11 +7429,8 @@ int sched_domain_level_max;
=20
 static int __init setup_relax_domain_level(char *str)
 {
-	unsigned long val;
-
-	val =3D simple_strtoul(str, NULL, 0);
-	if (val < sched_domain_level_max)
-		default_relax_domain_level =3D val;
+	if (kstrtoint(str, 0, &default_relax_domain_level))
+		pr_warn("Unable to set relax_domain_level\n");
=20
 	return 1;
 }
@@ -7636,7 +7633,6 @@ struct sched_domain *build_sched_domain(struct sched_=
domain_topology_level *tl,
 	if (!sd)
 		return child;
=20
-	set_domain_attribute(sd, attr);
 	cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
 	if (child) {
 		sd->level =3D child->level + 1;
@@ -7644,6 +7640,7 @@ struct sched_domain *build_sched_domain(struct sched_=
domain_topology_level *tl,
 		child->parent =3D sd;
 	}
 	sd->child =3D child;
+	set_domain_attribute(sd, attr);
=20
 	return sd;
 }
diff --git a/mm/swapfile.c b/mm/swapfile.c
index d3955f2..fad1830 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1921,24 +1921,20 @@ static unsigned long read_swap_header(struct swap_i=
nfo_struct *p,
=20
 	/*
 	 * Find out how many pages are allowed for a single swap
-	 * device. There are three limiting factors: 1) the number
+	 * device. There are two limiting factors: 1) the number
 	 * of bits for the swap offset in the swp_entry_t type, and
 	 * 2) the number of bits in the swap pte as defined by the
-	 * the different architectures, and 3) the number of free bits
-	 * in an exceptional radix_tree entry. In order to find the
+	 * different architectures. In order to find the
 	 * largest possible bit mask, a swap entry with swap type 0
 	 * and swap offset ~0UL is created, encoded to a swap pte,
 	 * decoded to a swp_entry_t again, and finally the swap
 	 * offset is extracted. This will mask all the bits from
 	 * the initial ~0UL mask that can't be encoded in either
 	 * the swp_entry_t or the architecture definition of a
-	 * swap pte.  Then the same is done for a radix_tree entry.
+	 * swap pte.
 	 */
 	maxpages =3D swp_offset(pte_to_swp_entry(
-			swp_entry_to_pte(swp_entry(0, ~0UL))));
-	maxpages =3D swp_offset(radix_to_swp_entry(
-			swp_to_radix_entry(swp_entry(0, maxpages)))) + 1;
-
+			swp_entry_to_pte(swp_entry(0, ~0UL)))) + 1;
 	if (maxpages > swap_header->info.last_page) {
 		maxpages =3D swap_header->info.last_page + 1;
 		/* p->max is an unsigned int: don't overflow it */
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 30d7355..f4ddf34 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -495,6 +495,18 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_=
data *sdata,
 		ieee80211_configure_filter(local);
 		break;
 	default:
+		mutex_lock(&local->mtx);
+		if (local->hw_roc_dev =3D=3D sdata->dev &&
+		    local->hw_roc_channel) {
+			/* ignore return value since this is racy */
+			drv_cancel_remain_on_channel(local);
+			ieee80211_queue_work(&local->hw, &local->hw_roc_done);
+		}
+		mutex_unlock(&local->mtx);
+
+		flush_work(&local->hw_roc_start);
+		flush_work(&local->hw_roc_done);
+
 		flush_work(&sdata->work);
 		/*
 		 * When we get here, the interface is marked down.
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 1b239be..db2c215 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -246,6 +246,22 @@ static void ieee80211_hw_roc_done(struct work_struct *=
work)
 		return;
 	}
=20
+	/* was never transmitted */
+	if (local->hw_roc_skb) {
+		u64 cookie;
+
+		cookie =3D local->hw_roc_cookie ^ 2;
+
+		cfg80211_mgmt_tx_status(local->hw_roc_dev, cookie,
+					local->hw_roc_skb->data,
+					local->hw_roc_skb->len, false,
+					GFP_KERNEL);
+
+		kfree_skb(local->hw_roc_skb);
+		local->hw_roc_skb =3D NULL;
+		local->hw_roc_skb_for_status =3D NULL;
+	}
+
 	if (!local->hw_roc_for_tx)
 		cfg80211_remain_on_channel_expired(local->hw_roc_dev,
 						   local->hw_roc_cookie,
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index d4ad50e..c80c162 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1358,7 +1358,8 @@ bc_svc_process(struct svc_serv *serv, struct rpc_rqst=
 *req,
 						sizeof(req->rq_snd_buf));
 		return bc_send(req);
 	} else {
-		/* Nothing to do to drop request */
+		/* drop request */
+		xprt_free_bc_request(req);
 		return 0;
 	}
 }
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 8bf8902..d38815d 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -943,6 +943,7 @@ int cfg80211_can_change_interface(struct cfg80211_regis=
tered_device *rdev,
 				  enum nl80211_iftype iftype)
 {
 	struct wireless_dev *wdev_iter;
+	u32 used_iftypes =3D BIT(iftype);
 	int num[NUM_NL80211_IFTYPES];
 	int total =3D 1;
 	int i, j;
@@ -976,12 +977,14 @@ int cfg80211_can_change_interface(struct cfg80211_reg=
istered_device *rdev,
=20
 		num[wdev_iter->iftype]++;
 		total++;
+		used_iftypes |=3D BIT(wdev_iter->iftype);
 	}
 	mutex_unlock(&rdev->devlist_mtx);
=20
 	for (i =3D 0; i < rdev->wiphy.n_iface_combinations; i++) {
 		const struct ieee80211_iface_combination *c;
 		struct ieee80211_iface_limit *limits;
+		u32 all_iftypes =3D 0;
=20
 		c =3D &rdev->wiphy.iface_combinations[i];
=20
@@ -996,6 +999,7 @@ int cfg80211_can_change_interface(struct cfg80211_regis=
tered_device *rdev,
 			if (rdev->wiphy.software_iftypes & BIT(iftype))
 				continue;
 			for (j =3D 0; j < c->n_limits; j++) {
+				all_iftypes |=3D limits[j].types;
 				if (!(limits[j].types & BIT(iftype)))
 					continue;
 				if (limits[j].max < num[iftype])
@@ -1003,7 +1007,20 @@ int cfg80211_can_change_interface(struct cfg80211_re=
gistered_device *rdev,
 				limits[j].max -=3D num[iftype];
 			}
 		}
-		/* yay, it fits */
+
+		/*
+		 * Finally check that all iftypes that we're currently
+		 * using are actually part of this combination. If they
+		 * aren't then we can't use this combination and have
+		 * to continue to the next.
+		 */
+		if ((all_iftypes & used_iftypes) !=3D used_iftypes)
+			goto cont;
+
+		/*
+		 * This combination covered all interface types and
+		 * supported the requested numbers, so we're good.
+		 */
 		kfree(limits);
 		return 0;
  cont:
diff --git a/sound/pci/hda/hda_codec.h b/sound/pci/hda/hda_codec.h
index 71f6744..78b2223 100644
--- a/sound/pci/hda/hda_codec.h
+++ b/sound/pci/hda/hda_codec.h
@@ -858,6 +858,7 @@ struct hda_codec {
 	unsigned int pins_shutup:1;	/* pins are shut up */
 	unsigned int no_trigger_sense:1; /* don't trigger at pin-sensing */
 	unsigned int ignore_misc_bit:1; /* ignore MISC_NO_PRESENCE bit */
+	unsigned int no_jack_detect:1;	/* Machine has no jack-detection */
 #ifdef CONFIG_SND_HDA_POWER_SAVE
 	unsigned int power_on :1;	/* current (global) power-state */
 	unsigned int power_transition :1; /* power-state in transition */
diff --git a/sound/pci/hda/hda_local.h b/sound/pci/hda/hda_local.h
index 368f0c5..c78b753 100644
--- a/sound/pci/hda/hda_local.h
+++ b/sound/pci/hda/hda_local.h
@@ -515,6 +515,8 @@ int snd_hda_jack_detect(struct hda_codec *codec, hda_ni=
d_t nid);
=20
 static inline bool is_jack_detectable(struct hda_codec *codec, hda_nid_t n=
id)
 {
+	if (codec->no_jack_detect)
+		return false;
 	if (!(snd_hda_query_pin_caps(codec, nid) & AC_PINCAP_PRES_DETECT))
 		return false;
 	if (!codec->ignore_misc_bit &&
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 0bc5a46..0005bde 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5278,8 +5278,10 @@ static const struct hda_amp_list alc861_loopbacks[] =
=3D {
=20
 /* Pin config fixes */
 enum {
-	PINFIX_FSC_AMILO_PI1505,
-	PINFIX_ASUS_A6RP,
+	ALC861_FIXUP_FSC_AMILO_PI1505,
+	ALC861_FIXUP_AMP_VREF_0F,
+	ALC861_FIXUP_NO_JACK_DETECT,
+	ALC861_FIXUP_ASUS_A6RP,
 };
=20
 /* On some laptops, VREF of pin 0x0f is abused for controlling the main am=
p */
@@ -5301,8 +5303,16 @@ static void alc861_fixup_asus_amp_vref_0f(struct hda=
_codec *codec,
 	spec->keep_vref_in_automute =3D 1;
 }
=20
+/* suppress the jack-detection */
+static void alc_fixup_no_jack_detect(struct hda_codec *codec,
+				     const struct alc_fixup *fix, int action)
+{
+	if (action =3D=3D ALC_FIXUP_ACT_PRE_PROBE)
+		codec->no_jack_detect =3D 1;
+}=09
+
 static const struct alc_fixup alc861_fixups[] =3D {
-	[PINFIX_FSC_AMILO_PI1505] =3D {
+	[ALC861_FIXUP_FSC_AMILO_PI1505] =3D {
 		.type =3D ALC_FIXUP_PINS,
 		.v.pins =3D (const struct alc_pincfg[]) {
 			{ 0x0b, 0x0221101f }, /* HP */
@@ -5310,16 +5320,29 @@ static const struct alc_fixup alc861_fixups[] =3D {
 			{ }
 		}
 	},
-	[PINFIX_ASUS_A6RP] =3D {
+	[ALC861_FIXUP_AMP_VREF_0F] =3D {
 		.type =3D ALC_FIXUP_FUNC,
 		.v.func =3D alc861_fixup_asus_amp_vref_0f,
 	},
+	[ALC861_FIXUP_NO_JACK_DETECT] =3D {
+		.type =3D ALC_FIXUP_FUNC,
+		.v.func =3D alc_fixup_no_jack_detect,
+	},
+	[ALC861_FIXUP_ASUS_A6RP] =3D {
+		.type =3D ALC_FIXUP_FUNC,
+		.v.func =3D alc861_fixup_asus_amp_vref_0f,
+		.chained =3D true,
+		.chain_id =3D ALC861_FIXUP_NO_JACK_DETECT,
+	}
 };
=20
 static const struct snd_pci_quirk alc861_fixup_tbl[] =3D {
-	SND_PCI_QUIRK_VENDOR(0x1043, "ASUS laptop", PINFIX_ASUS_A6RP),
-	SND_PCI_QUIRK(0x1584, 0x2b01, "Haier W18", PINFIX_ASUS_A6RP),
-	SND_PCI_QUIRK(0x1734, 0x10c7, "FSC Amilo Pi1505", PINFIX_FSC_AMILO_PI1505=
),
+	SND_PCI_QUIRK(0x1043, 0x1393, "ASUS A6Rp", ALC861_FIXUP_ASUS_A6RP),
+	SND_PCI_QUIRK_VENDOR(0x1043, "ASUS laptop", ALC861_FIXUP_AMP_VREF_0F),
+	SND_PCI_QUIRK(0x1462, 0x7254, "HP DX2200", ALC861_FIXUP_NO_JACK_DETECT),
+	SND_PCI_QUIRK(0x1584, 0x2b01, "Haier W18", ALC861_FIXUP_AMP_VREF_0F),
+	SND_PCI_QUIRK(0x1584, 0x0000, "Uniwill ECS M31EI", ALC861_FIXUP_AMP_VREF_=
0F),
+	SND_PCI_QUIRK(0x1734, 0x10c7, "FSC Amilo Pi1505", ALC861_FIXUP_FSC_AMILO_=
PI1505),
 	{}
 };
=20
@@ -5571,6 +5594,8 @@ enum {
 	ALC662_FIXUP_ASUS_MODE6,
 	ALC662_FIXUP_ASUS_MODE7,
 	ALC662_FIXUP_ASUS_MODE8,
+	ALC662_FIXUP_NO_JACK_DETECT,
+	ALC662_FIXUP_ZOTAC_Z68,
 };
=20
 static const struct alc_fixup alc662_fixups[] =3D {
@@ -5716,6 +5741,17 @@ static const struct alc_fixup alc662_fixups[] =3D {
 		.chained =3D true,
 		.chain_id =3D ALC662_FIXUP_SKU_IGNORE
 	},
+	[ALC662_FIXUP_NO_JACK_DETECT] =3D {
+		.type =3D ALC_FIXUP_FUNC,
+		.v.func =3D alc_fixup_no_jack_detect,
+	},
+	[ALC662_FIXUP_ZOTAC_Z68] =3D {
+		.type =3D ALC_FIXUP_PINS,
+		.v.pins =3D (const struct alc_pincfg[]) {
+			{ 0x1b, 0x02214020 }, /* Front HP */
+			{ }
+		}
+	},
 };
=20
 static const struct snd_pci_quirk alc662_fixup_tbl[] =3D {
@@ -5724,10 +5760,12 @@ static const struct snd_pci_quirk alc662_fixup_tbl[=
] =3D {
 	SND_PCI_QUIRK(0x1025, 0x031c, "Gateway NV79", ALC662_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x1025, 0x038b, "Acer Aspire 8943G", ALC662_FIXUP_ASPIRE),
 	SND_PCI_QUIRK(0x103c, 0x1632, "HP RP5800", ALC662_FIXUP_HP_RP5800),
+	SND_PCI_QUIRK(0x1043, 0x8469, "ASUS mobo", ALC662_FIXUP_NO_JACK_DETECT),
 	SND_PCI_QUIRK(0x105b, 0x0cd6, "Foxconn", ALC662_FIXUP_ASUS_MODE2),
 	SND_PCI_QUIRK(0x144d, 0xc051, "Samsung R720", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo Ideapad Y550P", ALC662_FIXUP_IDEAPA=
D),
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Ideapad Y550", ALC662_FIXUP_IDEAPAD=
),
+	SND_PCI_QUIRK(0x19da, 0xa130, "Zotac Z68", ALC662_FIXUP_ZOTAC_Z68),
 	SND_PCI_QUIRK(0x1b35, 0x2206, "CZC P10T", ALC662_FIXUP_CZC_P10T),
=20
 #if 0
diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 3e7aa22..de61b8a 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -41,6 +41,39 @@
 #define WM8994_NUM_DRC 3
 #define WM8994_NUM_EQ  3
=20
+static struct {
+	unsigned int reg;
+	unsigned int mask;
+} wm8994_vu_bits[] =3D {
+	{ WM8994_LEFT_LINE_INPUT_1_2_VOLUME, WM8994_IN1_VU },
+	{ WM8994_RIGHT_LINE_INPUT_1_2_VOLUME, WM8994_IN1_VU },
+	{ WM8994_LEFT_LINE_INPUT_3_4_VOLUME, WM8994_IN2_VU },
+	{ WM8994_RIGHT_LINE_INPUT_3_4_VOLUME, WM8994_IN2_VU },
+	{ WM8994_SPEAKER_VOLUME_LEFT, WM8994_SPKOUT_VU },
+	{ WM8994_SPEAKER_VOLUME_RIGHT, WM8994_SPKOUT_VU },
+	{ WM8994_LEFT_OUTPUT_VOLUME, WM8994_HPOUT1_VU },
+	{ WM8994_RIGHT_OUTPUT_VOLUME, WM8994_HPOUT1_VU },
+	{ WM8994_LEFT_OPGA_VOLUME, WM8994_MIXOUT_VU },
+	{ WM8994_RIGHT_OPGA_VOLUME, WM8994_MIXOUT_VU },
+
+	{ WM8994_AIF1_DAC1_LEFT_VOLUME, WM8994_AIF1DAC1_VU },
+	{ WM8994_AIF1_DAC1_RIGHT_VOLUME, WM8994_AIF1DAC1_VU },
+	{ WM8994_AIF1_DAC2_LEFT_VOLUME, WM8994_AIF1DAC2_VU },
+	{ WM8994_AIF1_DAC2_RIGHT_VOLUME, WM8994_AIF1DAC2_VU },
+	{ WM8994_AIF2_DAC_LEFT_VOLUME, WM8994_AIF2DAC_VU },
+	{ WM8994_AIF2_DAC_RIGHT_VOLUME, WM8994_AIF2DAC_VU },
+	{ WM8994_AIF1_ADC1_LEFT_VOLUME, WM8994_AIF1ADC1_VU },
+	{ WM8994_AIF1_ADC1_RIGHT_VOLUME, WM8994_AIF1ADC1_VU },
+	{ WM8994_AIF1_ADC2_LEFT_VOLUME, WM8994_AIF1ADC2_VU },
+	{ WM8994_AIF1_ADC2_RIGHT_VOLUME, WM8994_AIF1ADC2_VU },
+	{ WM8994_AIF2_ADC_LEFT_VOLUME, WM8994_AIF2ADC_VU },
+	{ WM8994_AIF2_ADC_RIGHT_VOLUME, WM8994_AIF1ADC2_VU },
+	{ WM8994_DAC1_LEFT_VOLUME, WM8994_DAC1_VU },
+	{ WM8994_DAC1_RIGHT_VOLUME, WM8994_DAC1_VU },
+	{ WM8994_DAC2_LEFT_VOLUME, WM8994_DAC2_VU },
+	{ WM8994_DAC2_RIGHT_VOLUME, WM8994_DAC2_VU },
+};
+
 static int wm8994_drc_base[] =3D {
 	WM8994_AIF1_DRC1_1,
 	WM8994_AIF1_DRC2_1,
@@ -889,6 +922,7 @@ static int aif1clk_ev(struct snd_soc_dapm_widget *w,
 	struct snd_soc_codec *codec =3D w->codec;
 	struct wm8994 *control =3D codec->control_data;
 	int mask =3D WM8994_AIF1DAC1L_ENA | WM8994_AIF1DAC1R_ENA;
+	int i;
 	int dac;
 	int adc;
 	int val;
@@ -947,6 +981,13 @@ static int aif1clk_ev(struct snd_soc_dapm_widget *w,
 				    WM8994_AIF1DAC2L_ENA);
 		break;
=20
+	case SND_SOC_DAPM_POST_PMU:
+		for (i =3D 0; i < ARRAY_SIZE(wm8994_vu_bits); i++)
+			snd_soc_write(codec, wm8994_vu_bits[i].reg,
+				      snd_soc_read(codec,
+						   wm8994_vu_bits[i].reg));
+		break;
+
 	case SND_SOC_DAPM_PRE_PMD:
 	case SND_SOC_DAPM_POST_PMD:
 		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_5,
@@ -972,6 +1013,7 @@ static int aif2clk_ev(struct snd_soc_dapm_widget *w,
 		      struct snd_kcontrol *kcontrol, int event)
 {
 	struct snd_soc_codec *codec =3D w->codec;
+	int i;
 	int dac;
 	int adc;
 	int val;
@@ -1022,6 +1064,13 @@ static int aif2clk_ev(struct snd_soc_dapm_widget *w,
 				    WM8994_AIF2DACR_ENA);
 		break;
=20
+	case SND_SOC_DAPM_POST_PMU:
+		for (i =3D 0; i < ARRAY_SIZE(wm8994_vu_bits); i++)
+			snd_soc_write(codec, wm8994_vu_bits[i].reg,
+				      snd_soc_read(codec,
+						   wm8994_vu_bits[i].reg));
+		break;
+
 	case SND_SOC_DAPM_PRE_PMD:
 	case SND_SOC_DAPM_POST_PMD:
 		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_5,
@@ -1090,17 +1139,19 @@ static int late_enable_ev(struct snd_soc_dapm_widge=
t *w,
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
 		if (wm8994->aif1clk_enable) {
-			aif1clk_ev(w, kcontrol, event);
+			aif1clk_ev(w, kcontrol, SND_SOC_DAPM_PRE_PMU);
 			snd_soc_update_bits(codec, WM8994_AIF1_CLOCKING_1,
 					    WM8994_AIF1CLK_ENA_MASK,
 					    WM8994_AIF1CLK_ENA);
+			aif1clk_ev(w, kcontrol, SND_SOC_DAPM_POST_PMU);
 			wm8994->aif1clk_enable =3D 0;
 		}
 		if (wm8994->aif2clk_enable) {
-			aif2clk_ev(w, kcontrol, event);
+			aif2clk_ev(w, kcontrol, SND_SOC_DAPM_PRE_PMU);
 			snd_soc_update_bits(codec, WM8994_AIF2_CLOCKING_1,
 					    WM8994_AIF2CLK_ENA_MASK,
 					    WM8994_AIF2CLK_ENA);
+			aif2clk_ev(w, kcontrol, SND_SOC_DAPM_POST_PMU);
 			wm8994->aif2clk_enable =3D 0;
 		}
 		break;
@@ -1121,15 +1172,17 @@ static int late_disable_ev(struct snd_soc_dapm_widg=
et *w,
 	switch (event) {
 	case SND_SOC_DAPM_POST_PMD:
 		if (wm8994->aif1clk_disable) {
+			aif1clk_ev(w, kcontrol, SND_SOC_DAPM_PRE_PMD);
 			snd_soc_update_bits(codec, WM8994_AIF1_CLOCKING_1,
 					    WM8994_AIF1CLK_ENA_MASK, 0);
-			aif1clk_ev(w, kcontrol, event);
+			aif1clk_ev(w, kcontrol, SND_SOC_DAPM_POST_PMD);
 			wm8994->aif1clk_disable =3D 0;
 		}
 		if (wm8994->aif2clk_disable) {
+			aif2clk_ev(w, kcontrol, SND_SOC_DAPM_PRE_PMD);
 			snd_soc_update_bits(codec, WM8994_AIF2_CLOCKING_1,
 					    WM8994_AIF2CLK_ENA_MASK, 0);
-			aif2clk_ev(w, kcontrol, event);
+			aif2clk_ev(w, kcontrol, SND_SOC_DAPM_POST_PMD);
 			wm8994->aif2clk_disable =3D 0;
 		}
 		break;
@@ -1466,9 +1519,11 @@ SND_SOC_DAPM_POST("Late Disable PGA", late_disable_e=
v)
=20
 static const struct snd_soc_dapm_widget wm8994_lateclk_widgets[] =3D {
 SND_SOC_DAPM_SUPPLY("AIF1CLK", WM8994_AIF1_CLOCKING_1, 0, 0, aif1clk_ev,
-		    SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_PRE_PMD),
+		    SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMU |
+		    SND_SOC_DAPM_PRE_PMD),
 SND_SOC_DAPM_SUPPLY("AIF2CLK", WM8994_AIF2_CLOCKING_1, 0, 0, aif2clk_ev,
-		    SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_PRE_PMD),
+		    SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMU |
+		    SND_SOC_DAPM_PRE_PMD),
 SND_SOC_DAPM_PGA("Direct Voice", SND_SOC_NOPM, 0, 0, NULL, 0),
 SND_SOC_DAPM_MIXER("SPKL", WM8994_POWER_MANAGEMENT_3, 8, 0,
 		   left_speaker_mixer, ARRAY_SIZE(left_speaker_mixer)),
@@ -3482,39 +3537,11 @@ static int wm8994_codec_probe(struct snd_soc_codec =
*codec)
=20
 	wm8994_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
=20
-	/* Latch volume updates (right only; we always do left then right). */
-	snd_soc_update_bits(codec, WM8994_AIF1_DAC1_LEFT_VOLUME,
-			    WM8994_AIF1DAC1_VU, WM8994_AIF1DAC1_VU);
-	snd_soc_update_bits(codec, WM8994_AIF1_DAC1_RIGHT_VOLUME,
-			    WM8994_AIF1DAC1_VU, WM8994_AIF1DAC1_VU);
-	snd_soc_update_bits(codec, WM8994_AIF1_DAC2_LEFT_VOLUME,
-			    WM8994_AIF1DAC2_VU, WM8994_AIF1DAC2_VU);
-	snd_soc_update_bits(codec, WM8994_AIF1_DAC2_RIGHT_VOLUME,
-			    WM8994_AIF1DAC2_VU, WM8994_AIF1DAC2_VU);
-	snd_soc_update_bits(codec, WM8994_AIF2_DAC_LEFT_VOLUME,
-			    WM8994_AIF2DAC_VU, WM8994_AIF2DAC_VU);
-	snd_soc_update_bits(codec, WM8994_AIF2_DAC_RIGHT_VOLUME,
-			    WM8994_AIF2DAC_VU, WM8994_AIF2DAC_VU);
-	snd_soc_update_bits(codec, WM8994_AIF1_ADC1_LEFT_VOLUME,
-			    WM8994_AIF1ADC1_VU, WM8994_AIF1ADC1_VU);
-	snd_soc_update_bits(codec, WM8994_AIF1_ADC1_RIGHT_VOLUME,
-			    WM8994_AIF1ADC1_VU, WM8994_AIF1ADC1_VU);
-	snd_soc_update_bits(codec, WM8994_AIF1_ADC2_LEFT_VOLUME,
-			    WM8994_AIF1ADC2_VU, WM8994_AIF1ADC2_VU);
-	snd_soc_update_bits(codec, WM8994_AIF1_ADC2_RIGHT_VOLUME,
-			    WM8994_AIF1ADC2_VU, WM8994_AIF1ADC2_VU);
-	snd_soc_update_bits(codec, WM8994_AIF2_ADC_LEFT_VOLUME,
-			    WM8994_AIF2ADC_VU, WM8994_AIF1ADC2_VU);
-	snd_soc_update_bits(codec, WM8994_AIF2_ADC_RIGHT_VOLUME,
-			    WM8994_AIF2ADC_VU, WM8994_AIF1ADC2_VU);
-	snd_soc_update_bits(codec, WM8994_DAC1_LEFT_VOLUME,
-			    WM8994_DAC1_VU, WM8994_DAC1_VU);
-	snd_soc_update_bits(codec, WM8994_DAC1_RIGHT_VOLUME,
-			    WM8994_DAC1_VU, WM8994_DAC1_VU);
-	snd_soc_update_bits(codec, WM8994_DAC2_LEFT_VOLUME,
-			    WM8994_DAC2_VU, WM8994_DAC2_VU);
-	snd_soc_update_bits(codec, WM8994_DAC2_RIGHT_VOLUME,
-			    WM8994_DAC2_VU, WM8994_DAC2_VU);
+	/* Latch volume update bits */
+	for (i =3D 0; i < ARRAY_SIZE(wm8994_vu_bits); i++)
+		snd_soc_update_bits(codec, wm8994_vu_bits[i].reg,
+				    wm8994_vu_bits[i].mask,
+				    wm8994_vu_bits[i].mask);
=20
 	/* Set the low bit of the 3D stereo depth so TLV matches */
 	snd_soc_update_bits(codec, WM8994_AIF1_DAC1_FILTERS_2,


--=20
Ben Hutchings
Time is nature's way of making sure that everything doesn't happen at once.

--=-i0ot3Q+8NvcJmkbtGOOe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT94me+e/yOyVhhEJAQocOQ//WkUygnkdQTbXW7808gvO1bhy8XfIh0BM
2Rfr2+kqiXVQ5S2f8HzTqwsQD+ZtH4cSwcT8zuhknuks9KHcv27qJKlLxklIiABT
V7nJh/pT33BqEESPv+Vvaq+5RwXensoapnFyeOkJGomlFbr1M4728xlnxj8vW3Jl
tptcAjXwd8UXxJcDz2u1bq0muOixyvLNzpgqfJKgAVnQppf77SKnT78GcukL6K77
r1CKu2cqfZ44eqiQspjnQTyUObsDeOOI0WnrwRbEIurxA71kKpdAES/jU9v5zR5J
9J0+86JQ4rSTHxQf+AHSZYRpurkYzNWBmOcKVL3qNsnfF4QZLbthTiEXy8YQeVU9
H9J41SjeCi4ljuwXW9968skXIH650HRBP4DSqsZY1y5Gj3WApSBkYYsR9Hn/leTb
rUB4n1/veuXmw0UfptwGfO+xnGX/fu5KfMEE6NDgp+r2KZsDiB4fFtcSqM91gMZU
+uRaJGYpmsDgBpAwPABF5vGVnaVHcOMO/XAKvKjHJC6HzjckFfmjVmOPunn85avj
iFMGfdawuQJsPi9/42ngTzOhmnIpXUi/DAHqahGYdZsGJNg0U9npbyopWwZfGP1t
4bhS5TfKKC5Yk6lPa67ZJK7YiyF5LQmRnyg9554BccWig9mNWML/uubPzPithe9M
g/EmpD20T78=
=0a1N
-----END PGP SIGNATURE-----

--=-i0ot3Q+8NvcJmkbtGOOe--
