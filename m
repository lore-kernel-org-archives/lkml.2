Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab0HBR2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:28:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:49920 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab0HBR2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:28:00 -0400
Date: Mon, 2 Aug 2010 17:27:44 GMT
From: tip-bot for Michal Schmidt <mschmidt@redhat.com>
Cc: linux-kernel@vger.kernel.org, mschmidt@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mschmidt@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        borislav.petkov@amd.com
In-Reply-To: <20100727165335.GA11630@aftab>
References: <20100727165335.GA11630@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Fix keeping track of AMD C1E
Message-ID: <tip-e8c534ec068af1a0845aceda373a9bfd2de62030@git.kernel.org>
Git-Commit-ID: e8c534ec068af1a0845aceda373a9bfd2de62030
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 17:27:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e8c534ec068af1a0845aceda373a9bfd2de62030
Gitweb:     http://git.kernel.org/tip/e8c534ec068af1a0845aceda373a9bfd2de62030
Author:     Michal Schmidt <mschmidt@redhat.com>
AuthorDate: Tue, 27 Jul 2010 18:53:35 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 2 Aug 2010 08:45:56 -0700

x86: Fix keeping track of AMD C1E

Accomodate the original C1E-aware idle routine to the different times
during boot when the BIOS enables C1E. While at it, remove the synthetic
CPUID flag in favor of a single global setting which denotes C1E status
on the system.

[ hpa: changed c1e_enabled to be a bool; clarified cpu bit 3:21 comment ]

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
LKML-Reference: <20100727165335.GA11630@aftab>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/acpi.h       |    2 +-
 arch/x86/include/asm/cpufeature.h |    2 +-
 arch/x86/include/asm/processor.h  |    1 +
 arch/x86/kernel/process.c         |    8 +++++---
 drivers/acpi/processor_idle.c     |    2 +-
 5 files changed, 9 insertions(+), 6 deletions(-)

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
index 817aa31..0b205b8 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -89,7 +89,7 @@
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* "" Lfence synchronizes RDTSC */
 #define X86_FEATURE_11AP	(3*32+19) /* "" Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
-#define X86_FEATURE_AMDC1E	(3*32+21) /* AMD C1E detected */
+					  /* 21 available, was AMD_C1E */
 #define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum extensions */
 #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index d85637b..325b7bd 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -762,6 +762,7 @@ extern void init_c1e_mask(void);
 extern unsigned long		boot_option_idle_override;
 extern unsigned long		idle_halt;
 extern unsigned long		idle_nomwait;
+extern bool			c1e_detected;
 
 /*
  * on systems with caches, caches must be flashed as the absolute
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 553b02f..b944f89 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -525,8 +525,10 @@ static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
 	return (edx & MWAIT_EDX_C1);
 }
 
+bool c1e_detected;
+EXPORT_SYMBOL(c1e_detected);
+
 static cpumask_var_t c1e_mask;
-static int c1e_detected;
 
 void c1e_remove_cpu(int cpu)
 {
@@ -548,12 +550,12 @@ static void c1e_idle(void)
 		u32 lo, hi;
 
 		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
+
 		if (lo & K8_INTP_C1E_ACTIVE_MASK) {
-			c1e_detected = 1;
+			c1e_detected = true;
 			if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
 				mark_tsc_unstable("TSC halt in AMD C1E");
 			printk(KERN_INFO "System has AMD C1E enabled\n");
-			set_cpu_cap(&boot_cpu_data, X86_FEATURE_AMDC1E);
 		}
 	}
 
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index e9a8026..eead3f5 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -164,7 +164,7 @@ static void lapic_timer_check_state(int state, struct acpi_processor *pr,
 	if (cpu_has(&cpu_data(pr->id), X86_FEATURE_ARAT))
 		return;
 
-	if (boot_cpu_has(X86_FEATURE_AMDC1E))
+	if (c1e_detected)
 		type = ACPI_STATE_C1;
 
 	/*
