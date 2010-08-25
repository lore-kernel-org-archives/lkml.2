Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab0HYViu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 17:38:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:41781 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab0HYVit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 17:38:49 -0400
Date: Wed, 25 Aug 2010 21:36:45 GMT
From: tip-bot for Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, bp@amd64.org,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@amd64.org, hpa@linux.intel.com,
        borislav.petkov@amd.com
In-Reply-To: <20100825162823.GE26438@aftab>
References: <20100825162823.GE26438@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, tsc: Remove CPU frequency calibration on AMD
Message-ID: <tip-acf01734b1747b1ec4be6f159aff579ea5f7f8e2@git.kernel.org>
Git-Commit-ID: acf01734b1747b1ec4be6f159aff579ea5f7f8e2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 Aug 2010 21:36:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  acf01734b1747b1ec4be6f159aff579ea5f7f8e2
Gitweb:     http://git.kernel.org/tip/acf01734b1747b1ec4be6f159aff579ea5f7f8e2
Author:     Borislav Petkov <bp@amd64.org>
AuthorDate: Wed, 25 Aug 2010 18:28:23 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 25 Aug 2010 13:32:52 -0700

x86, tsc: Remove CPU frequency calibration on AMD

6b37f5a20c0e5c334c010a587058354215433e92 introduced the CPU frequency
calibration code for AMD CPUs whose TSCs didn't increment with the
core's P0 frequency. From F10h, revB onward, however, the TSC increment
rate is denoted by MSRC001_0015[24] and when this bit is set (which
should be done by the BIOS) the TSC increments with the P0 frequency
so the calibration is not needed and booting can be a couple of mcecs
faster on those machines.

Besides, there should be virtually no machines out there which don't
have this bit set, therefore this calibration can be safely removed. It
is a shaky hack anyway since it assumes implicitly that the core is in
P0 when BIOS hands off to the OS, which might not always be the case.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20100825162823.GE26438@aftab>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/amd.c |   17 +++++++++++++
 arch/x86/kernel/tsc.c     |   58 ---------------------------------------------
 2 files changed, 17 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ba5f62f..fc563fa 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -412,6 +412,23 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
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
+				printk(KERN_WARNING FW_BUG "TSC doesn't count "
+					"with P0 frequency!\n");
+		}
+	}
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index ce8e502..13b6a6c 100644
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
@@ -926,10 +872,6 @@ void __init tsc_init(void)
 		return;
 	}
 
-	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
-			(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
-		cpu_khz = calibrate_cpu();
-
 	printk("Detected %lu.%03lu MHz processor.\n",
 			(unsigned long)cpu_khz / 1000,
 			(unsigned long)cpu_khz % 1000);
