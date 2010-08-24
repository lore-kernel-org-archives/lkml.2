Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab0HXPw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:52:56 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53021 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab0HXPww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:52:52 -0400
Date: Tue, 24 Aug 2010 17:53:05 +0200
From: Borislav Petkov <bp@amd64.org>
To: Alok Kataria <akataria@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "greg@kroah.com" <greg@kroah.com>,
        "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2] x86, tsc: Limit CPU frequency calibration on AMD
Message-ID: <20100824155305.GA18220@aftab>
References: <1282024311.20786.2.camel@ank32.eng.vmware.com>
 <4C6A2C98.4060605@zytor.com>
 <20100817070520.GD32714@liondog.tnic>
 <1282063532.4388.8.camel@ank32.eng.vmware.com>
 <20100817185634.GA10597@liondog.tnic>
 <20100818161639.GF9880@aftab>
 <4C6C08EC.2080404@zytor.com>
 <20100818173401.GG9880@aftab>
 <1282153895.15158.45.camel@ank32.eng.vmware.com>
 <20100818184534.GA12842@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818184534.GA12842@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

6b37f5a20c0e5c334c010a587058354215433e92 introduced the CPU frequency
calibration code for AMD CPUs whose TSCs didn't increment with the
core's P0 frequency. From F10h, revB onward, the TSC increment rate is
denoted by MSRC001_0015[24] and when this bit is set (which is normally
done by the BIOS,) the TSC increments with the P0 frequency so the
calibration is not needed and booting can be a couple of mcecs faster on
those machines.

While at it, make the code work on 32-bit. In addition, use the 4th
perfctr since using perfctr 0 might clash with perfctr-watchdog.c during
LAPIC init. Finally, warn about wrongly calibrated value in the most
seldom cases when the core TSC is not incrementing with P0 frequency.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---

Here's the new version, had to change quite a lot and check all families
first.

@Alok, I think in your case you will want to do

	x86_cpuinit.calibrate_cpu = NULL;

since this means no need to recalibrate.

Sorry for the delay.


 arch/x86/include/asm/x86_init.h |    1 +
 arch/x86/kernel/cpu/amd.c       |   74 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/tsc.c           |   65 ++++------------------------------
 3 files changed, 83 insertions(+), 57 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index baa579c..c63ab76 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -133,6 +133,7 @@ struct x86_init_ops {
  */
 struct x86_cpuinit_ops {
 	void (*setup_percpu_clockev)(void);
+	unsigned long (*calibrate_cpu)(void);
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ba5f62f..236bcff 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -6,6 +6,7 @@
 #include <asm/processor.h>
 #include <asm/apic.h>
 #include <asm/cpu.h>
+#include <asm/nmi.h>
 #include <asm/pci-direct.h>
 
 #ifdef CONFIG_X86_64
@@ -381,6 +382,62 @@ static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
 #endif
 }
 
+/*
+ * This is used on systems with fixed rate TSCs to determine processor frequency
+ * when the TSC on those systems is not incrementing with the P0 frequency.
+ */
+#define TICK_COUNT 100000000
+unsigned long __cpuinit amd_calibrate_cpu(void)
+{
+	u64 evntsel3 = 0, pmc3 = 0, pmcs = 0;
+	int tsc_start, tscs, i, no_ctr_free;
+	unsigned long flags;
+
+	for (i = 3; i >= -1; i--)
+		if (avail_to_resrv_perfctr_nmi_bit(i))
+			break;
+
+	no_ctr_free = (i == -1);
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
+
+	/* start measuring cycles, incrementing from 0 */
+	local_irq_save(flags);
+	wrmsrl(MSR_K7_PERFCTR0 + i, 0);
+	wrmsrl(MSR_K7_EVNTSEL0 + i, 1 << 22 | 3 << 16 | 0x76);
+	rdtscl(tsc_start);
+	do {
+		rdmsrl(MSR_K7_PERFCTR0 + i, pmcs);
+		tscs = get_cycles();
+	} while ((tscs - tsc_start) < TICK_COUNT);
+	local_irq_restore(flags);
+
+	if (no_ctr_free) {
+		wrmsrl(MSR_K7_EVNTSEL3, 0);
+		wrmsrl(MSR_K7_PERFCTR3, pmc3);
+		wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
+	} else {
+		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+		release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+	}
+
+	pmcs *= tsc_khz;
+	tscs -= tsc_start;
+
+	(void)do_div(pmcs, tscs);
+
+	return pmcs;
+}
+
 static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
 	early_init_amd_mc(c);
@@ -412,6 +469,23 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
 	}
 #endif
+
+	/* We need to do the following only once */
+	if (c != &boot_cpu_data)
+		return;
+
+	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
+
+		if (c->x86 > 0x10 ||
+		    (c->x86 == 0x10 && c->x86_model >= 0x2)) {
+			u64 val;
+
+			rdmsrl(MSR_K7_HWCR, val);
+			if (!(val & BIT(24)))
+				x86_cpuinit.calibrate_cpu = amd_calibrate_cpu;
+		} else
+			x86_cpuinit.calibrate_cpu = amd_calibrate_cpu;
+	}
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index ce8e502..6b4f22f 100644
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
@@ -926,9 +872,14 @@ void __init tsc_init(void)
 		return;
 	}
 
-	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
-			(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
-		cpu_khz = calibrate_cpu();
+	if (x86_cpuinit.calibrate_cpu) {
+		cpu_khz = x86_cpuinit.calibrate_cpu();
+		if (cpu_khz < tsc_khz) {
+			printk(KERN_WARNING "TSC possibly calibrated at non-P0 "
+			      "core frequency, fall back to previous value.\n");
+			cpu_khz = tsc_khz;
+		}
+	}
 
 	printk("Detected %lu.%03lu MHz processor.\n",
 			(unsigned long)cpu_khz / 1000,
-- 
1.7.1

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
