Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966602Ab0GSTfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 15:35:25 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:27156 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966411Ab0GSTfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 15:35:22 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz1432N98dN936eMzz1202hzz15d4Rz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L5TL2Q-02-7GZ-02
X-M-MSG: 
Date: Mon, 19 Jul 2010 21:34:54 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Heinz Diehl <htd@fancy-poultry.org>
CC: Michal Schmidt <mschmidt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
Message-ID: <20100719193454.GB19344@aftab>
References: <20100713185816.2866.17837.stgit@localhost.localdomain>
 <20100713185957.2866.50995.stgit@localhost.localdomain>
 <20100714160704.GA10473@kryptos.osrc.amd.com>
 <20100714232201.00433aa9@hammerfall>
 <20100714233102.0f64614b@hammerfall>
 <20100718162239.GA21151@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100718162239.GA21151@fancy-poultry.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinz Diehl <htd@fancy-poultry.org>
Date: Sun, Jul 18, 2010 at 12:22:39PM -0400

> On 15.07.2010, Michal Schmidt wrote: 
> 
> > This suggests that another way to fix my problem would be this (tested):
> [....]
> 
> Did apply this patch to stock 2.6.35-rc5, it does _not_ fix my C1E problem.
> It takes a lot of key pressing in the boot process to get the system up,
> just as it has been before.

Ok, come to think of it, there are a couple of things you could also test:

First of all, there's this HPET readback on ATI chipsets which wasn't in
your testing kernel and it would be a good thing to test it - I'm little
sceptical but it fixes the same symptoms for another user so it wouldn't
hurt. You'll have to apply the following patches:

1. The latest fix from Michal (adding it here for completeness):

--
>From 8edc23442afd629e71b17789fdf2a4b657c29e37 Mon Sep 17 00:00:00 2001
From: Michal Schmidt <mschmidt@redhat.com>
Date: Wed, 14 Jul 2010 17:31:02 -0400
Subject: [PATCH] x86: fix keeping track of AMD C1E

On Wed, 14 Jul 2010 23:22:01 +0200 Michal Schmidt wrote:
> identify_cpu: before ANDing, c1e_detected: 0, boot_cpu_has(C1E): 0
> identify_cpu:  after ANDing, c1e_detected: 0, boot_cpu_has(C1E): 0
> c1e_idle: cpu: 1, bits 0x10000000, c1e_detected: 0,
> boot_cpu_has(C1E): 0 lockdep: fixing up alternatives.
>  #2
> System has AMD C1E enabled
> Switch to broadcast mode on CPU1
> identify_cpu: before ANDing, c1e_detected: 1, boot_cpu_has(C1E): 1
> identify_cpu:  after ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
> Switch to broadcast mode on CPU2
> lockdep: fixing up alternatives.
>  #3
> identify_cpu: before ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
> identify_cpu:  after ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
> Switch to broadcast mode on CPU3
> lockdep: fixing up alternatives.
>  #4
> identify_cpu: before ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
> identify_cpu:  after ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
> Switch to broadcast mode on CPU4
> lockdep: fixing up alternatives.
>  #5 Ok.
> identify_cpu: before ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
> identify_cpu:  after ANDing, c1e_detected: 1, boot_cpu_has(C1E): 0
> Brought up 6 CPUs
> Switch to broadcast mode on CPU5
> Total of 6 processors activated (38528.67 BogoMIPS).
> Switch to broadcast mode on CPU0

This suggests that another way to fix my problem would be this (tested):
---
 arch/x86/include/asm/acpi.h       |    8 ++++++--
 arch/x86/include/asm/cpufeature.h |    2 +-
 arch/x86/include/asm/processor.h  |    1 +
 arch/x86/kernel/process.c         |   12 ++++++++++--
 drivers/acpi/processor_idle.c     |    2 +-
 5 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index aa2c39d..7583f19 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -134,10 +134,14 @@ static inline unsigned int acpi_processor_cstate_check(unsigned int max_cstate)
 	    boot_cpu_data.x86_model <= 0x05 &&
 	    boot_cpu_data.x86_mask < 0x0A)
 		return 1;
-	else if (boot_cpu_has(X86_FEATURE_AMDC1E))
+	else if (c1e_detected) {
+		pr_err("%s: C1E\n", __func__);
 		return 1;
-	else
+	}
+	else {
+		pr_err("%s: max_cstate: %d\n", __func__, max_cstate);
 		return max_cstate;
+	}
 }
 
 static inline bool arch_has_acpi_pdc(void)
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
index e7e3521..0c2d4df 100644
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
@@ -584,12 +586,18 @@ static void c1e_idle(void)
 		u32 lo, hi;
 
 		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
+
+		pr_err("%s: bits 0x%08x\n",
+			__func__, lo & K8_INTP_C1E_ACTIVE_MASK);
+
+		pr_err("%s: cpu: %d, c1e_detected: %d\n",
+			__func__, raw_smp_processor_id(), c1e_detected);
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

and

2. the patch at http://git.kernel.org/tip/08be97962bf338161325d4901642f956ce8c1adb

Please boot this on your machine and send me the whole dmesg, as usual.

Now, if it still shows hickups, we'd like to rule out that there's some
funny HPET IRQ routing issue so please rerun the same test with the same
2 patches ontop but also with "nolapic_timer hpet=verbose" on the kernel
command line. As above, catch the whole dmesg and send it to me.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

