Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab0GVPDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 11:03:40 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:12147
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751634Ab0GVPDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 11:03:37 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz936eMzz1202hzz15d4Rz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L5YSHG-01-JQ1-02
X-M-MSG: 
Date: Thu, 22 Jul 2010 17:02:43 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Michal Schmidt <mschmidt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
Message-ID: <20100722150243.GC6601@aftab>
References: <20100714232201.00433aa9@hammerfall>
 <20100714233102.0f64614b@hammerfall>
 <4C3FDF43.6030203@zytor.com>
 <20100716063952.GB27546@aftab>
 <4C3F8418.5020803@zytor.com>
 <20100716072244.GA27954@aftab>
 <4C408298.8060004@zytor.com>
 <20100716162517.GF28902@aftab>
 <4C40DD11.4020803@zytor.com>
 <20100717102108.GA2239@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100717102108.GA2239@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>
Date: Sat, Jul 17, 2010 at 06:21:08AM -0400

> Btw, I think we should wait with whatever fix we come up until the
> merge window so that we have more time to fix any fallout then (which I
> don't expect but who knows) instead of rushing this now. We can always
> backport it then too.

Ok, I think we should go ahead and queue this up for .36 for now, let
it see some linux-next time and such. The other issue with the Gigabyte
boards is still ongoing and, as it looks so far, unrelated.

Michal, scream if you have objections to the patch:

--
From: Michal Schmidt <mschmidt@redhat.com>
Date: Wed, 14 Jul 2010 17:31:02 -0400
Subject: [PATCH] x86: fix keeping track of AMD C1E

Accomodate the original C1E-aware idle routine to the different points
during boot when the BIOS enables C1E. While at it, remove the synthetic
CPUID flag in favor of a single global setting which denotes C1E status
on the system.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/acpi.h       |    2 +-
 arch/x86/include/asm/cpufeature.h |    2 +-
 arch/x86/include/asm/processor.h  |    1 +
 arch/x86/kernel/process.c         |    6 ++++--
 drivers/acpi/processor_idle.c     |    2 +-
 5 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index aa2c39d..92091de 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -134,7 +134,7 @@ static inline unsigned int acpi_processor_cstate_check(unsigned int max_cstate)
 	    boot_cpu_data.x86_model <= 0x05 &&
 	    boot_cpu_data.x86_mask < 0x0A)
 		return 1;
-	else if (boot_cpu_has(X86_FEATURE_AMDC1E))
+	else if (c1e_detected)
 		return 1;
 	else
 		return max_cstate;
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 4681459..353154e 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -89,7 +89,7 @@
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* "" Lfence synchronizes RDTSC */
 #define X86_FEATURE_11AP	(3*32+19) /* "" Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
-#define X86_FEATURE_AMDC1E	(3*32+21) /* AMD C1E detected */
+					  /* 21 missing, was AMD_C1E workaround */
 #define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum extensions */
 #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7e5c6a6..336851e 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -762,6 +762,7 @@ extern void init_c1e_mask(void);
 extern unsigned long		boot_option_idle_override;
 extern unsigned long		idle_halt;
 extern unsigned long		idle_nomwait;
+extern int			c1e_detected;
 
 /*
  * on systems with caches, caches must be flashed as the absolute
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e7e3521..1b44a5c 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -561,8 +561,10 @@ no_c1e_idle:
 	return 0;
 }
 
+int c1e_detected;
+EXPORT_SYMBOL(c1e_detected);
+
 static cpumask_var_t c1e_mask;
-static int c1e_detected;
 
 void c1e_remove_cpu(int cpu)
 {
@@ -584,12 +586,12 @@ static void c1e_idle(void)
 		u32 lo, hi;
 
 		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
+
 		if (lo & K8_INTP_C1E_ACTIVE_MASK) {
 			c1e_detected = 1;
 			if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
 				mark_tsc_unstable("TSC halt in AMD C1E");
 			printk(KERN_INFO "System has AMD C1E enabled\n");
-			set_cpu_cap(&boot_cpu_data, X86_FEATURE_AMDC1E);
 		}
 	}
 
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index b1b3856..7cd95eb 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -159,7 +159,7 @@ static void lapic_timer_check_state(int state, struct acpi_processor *pr,
 	if (cpu_has(&cpu_data(pr->id), X86_FEATURE_ARAT))
 		return;
 
-	if (boot_cpu_has(X86_FEATURE_AMDC1E))
+	if (c1e_detected)
 		type = ACPI_STATE_C1;
 
 	/*
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

