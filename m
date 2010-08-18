Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab0HRRcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 13:32:00 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:52920 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab0HRRb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 13:31:58 -0400
Date: Wed, 18 Aug 2010 19:34:01 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Alok Kataria <akataria@vmware.com>,
        the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "greg@kroah.com" <greg@kroah.com>,
        "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, tsc: Limit CPU frequency calibration on AMD
Message-ID: <20100818173401.GG9880@aftab>
References: <1281986754.23253.32.camel@ank32.eng.vmware.com>
 <4C69D02F.6090601@zytor.com>
 <1282024311.20786.2.camel@ank32.eng.vmware.com>
 <4C6A2C98.4060605@zytor.com>
 <20100817070520.GD32714@liondog.tnic>
 <1282063532.4388.8.camel@ank32.eng.vmware.com>
 <20100817185634.GA10597@liondog.tnic>
 <20100818161639.GF9880@aftab>
 <4C6C08EC.2080404@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6C08EC.2080404@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, Aug 18, 2010 at 12:23:08PM -0400

> calibrate_cpu() is AMD-specific, despite the generic name.  (It is also,
> strangely enough, only compiled on 64 bits for some reason???)

Yeah, this is ancient stuff, who knows. I will test the fix on 32-bit
too after we agree on the design tho.

> Either which way, it is definitely not okay for the test for when the
> code applies to be this distant from the code itself.

Makes sense.

> The easy way to fix this is to rename it amd_calibrate_cpu() and move
> the applicability test into the routine itself.  That is probably okay
> as long as there are no other users.  However, if there are other users,
> then this really should move into x86_init and have a function pointer
> associated with it.

Right, do you have strong preferences between x86_init and x86_platform?
The version below uses x86_platform because it has the calibrate_tsc()
function in there too. Also, the version below nicely moves all that
AMD-specific code to cpu/amd.c.

I didn't opt for a calibrate_cpu_noop stub because I didn't want to
pollute x86_init.c with yet another noop prototype. But I guess I should
do that since the pointer testing is still executed while stubs are
removed completely by smart compilers :).

Anyway, the version below builds, I'll test tomorrow and send an
official version then:

--

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index baa579c..f00ed28 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -146,6 +146,7 @@ struct x86_cpuinit_ops {
  */
 struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
+	unsigned long (*calibrate_cpu)(void);
 	unsigned long (*get_wallclock)(void);
 	int (*set_wallclock)(unsigned long nowtime);
 	void (*iommu_shutdown)(void);
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 60a57b1..6478bd5 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -6,6 +6,7 @@
 #include <asm/processor.h>
 #include <asm/apic.h>
 #include <asm/cpu.h>
+#include <asm/nmi.h>
 #include <asm/pci-direct.h>
 
 #ifdef CONFIG_X86_64
@@ -381,6 +382,56 @@ static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
 #endif
 }
 
+/*
+ * calibrate_cpu is used on systems with fixed rate TSCs to determine
+ * processor frequency
+ */
+#define TICK_COUNT 100000000
+unsigned long __init amd_calibrate_cpu(void)
+{
+	int tsc_start, tsc_now;
+	int i, no_ctr_free;
+	unsigned long evntsel3 = 0, pmc3 = 0, pmc_now = 0;
+	unsigned long flags;
+
+	for (i = 0; i < 4; i++)
+		if (avail_to_resrv_perfctr_nmi_bit(i))
+			break;
+	no_ctr_free = (i == 4);
+	if (no_ctr_free) {
+		WARN(1, KERN_WARNING "Warning: AMD perfctrs busy ... "
+		     "cpu_khz value may be incorrect.\n");
+		i = 3;
+		rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
+		wrmsrl(MSR_K7_EVNTSEL3, 0);
+		rdmsrl(MSR_K7_PERFCTR3, pmc3);
+	} else {
+		reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+		reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+	}
+	local_irq_save(flags);
+	/* start measuring cycles, incrementing from 0 */
+	wrmsrl(MSR_K7_PERFCTR0 + i, 0);
+	wrmsrl(MSR_K7_EVNTSEL0 + i, 1 << 22 | 3 << 16 | 0x76);
+	rdtscl(tsc_start);
+	do {
+		rdmsrl(MSR_K7_PERFCTR0 + i, pmc_now);
+		tsc_now = get_cycles();
+	} while ((tsc_now - tsc_start) < TICK_COUNT);
+
+	local_irq_restore(flags);
+	if (no_ctr_free) {
+		wrmsrl(MSR_K7_EVNTSEL3, 0);
+		wrmsrl(MSR_K7_PERFCTR3, pmc3);
+		wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
+	} else {
+		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+		release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+	}
+
+	return pmc_now * tsc_khz / (tsc_now - tsc_start);
+}
+
 static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
 	early_init_amd_mc(c);
@@ -412,6 +463,23 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
 	}
 #endif
+
+	/*
+	 * We can check for constant TSC CPUID bit here since this bit is
+	 * introduced with F10h.
+	 */
+	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
+
+		if (c->x86 > 0x10 ||
+		    (c->x86 == 0x10 && c->x86_model >= 0x2)) {
+			u64 val;
+
+			rdmsrl(MSR_K7_HWCR, val);
+			if (!(val & BIT(24)))
+				x86_platform.calibrate_cpu = amd_calibrate_cpu;
+		}
+	} else
+		x86_platform.calibrate_cpu = amd_calibrate_cpu;
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 41b2b8b..1915706 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -854,60 +854,6 @@ static void __init init_tsc_clocksource(void)
 	clocksource_register_khz(&clocksource_tsc, tsc_khz);
 }
 
-#ifdef CONFIG_X86_64
-/*
- * calibrate_cpu is used on systems with fixed rate TSCs to determine
- * processor frequency
- */
-#define TICK_COUNT 100000000
-static unsigned long __init calibrate_cpu(void)
-{
-	int tsc_start, tsc_now;
-	int i, no_ctr_free;
-	unsigned long evntsel3 = 0, pmc3 = 0, pmc_now = 0;
-	unsigned long flags;
-
-	for (i = 0; i < 4; i++)
-		if (avail_to_resrv_perfctr_nmi_bit(i))
-			break;
-	no_ctr_free = (i == 4);
-	if (no_ctr_free) {
-		WARN(1, KERN_WARNING "Warning: AMD perfctrs busy ... "
-		     "cpu_khz value may be incorrect.\n");
-		i = 3;
-		rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
-		wrmsrl(MSR_K7_EVNTSEL3, 0);
-		rdmsrl(MSR_K7_PERFCTR3, pmc3);
-	} else {
-		reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-		reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
-	}
-	local_irq_save(flags);
-	/* start measuring cycles, incrementing from 0 */
-	wrmsrl(MSR_K7_PERFCTR0 + i, 0);
-	wrmsrl(MSR_K7_EVNTSEL0 + i, 1 << 22 | 3 << 16 | 0x76);
-	rdtscl(tsc_start);
-	do {
-		rdmsrl(MSR_K7_PERFCTR0 + i, pmc_now);
-		tsc_now = get_cycles();
-	} while ((tsc_now - tsc_start) < TICK_COUNT);
-
-	local_irq_restore(flags);
-	if (no_ctr_free) {
-		wrmsrl(MSR_K7_EVNTSEL3, 0);
-		wrmsrl(MSR_K7_PERFCTR3, pmc3);
-		wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
-	} else {
-		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-		release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
-	}
-
-	return pmc_now * tsc_khz / (tsc_now - tsc_start);
-}
-#else
-static inline unsigned long calibrate_cpu(void) { return cpu_khz; }
-#endif
-
 void __init tsc_init(void)
 {
 	u64 lpj;
@@ -926,19 +872,8 @@ void __init tsc_init(void)
 		return;
 	}
 
-	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
-			(boot_cpu_data.x86_vendor == X86_VENDOR_AMD)) {
-
-		if (boot_cpu_data.x86 > 0x10 ||
-		    (boot_cpu_data.x86 == 0x10 &&
-		     boot_cpu_data.x86_model >= 0x2)) {
-			u64 val;
-
-			rdmsrl(MSR_K7_HWCR, val);
-			if (!(val & BIT(24)))
-				cpu_khz = calibrate_cpu();
-		}
-	}
+	if (x86_platform.calibrate_cpu)
+		cpu_khz = x86_platform.calibrate_cpu();
 
 	printk("Detected %lu.%03lu MHz processor.\n",
 			(unsigned long)cpu_khz / 1000,


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
