Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab0GNVbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 17:31:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356Ab0GNVbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 17:31:09 -0400
Date: Wed, 14 Jul 2010 23:31:02 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
Message-ID: <20100714233102.0f64614b@hammerfall>
In-Reply-To: <20100714232201.00433aa9@hammerfall>
References: <20100713185816.2866.17837.stgit@localhost.localdomain>
	<20100713185957.2866.50995.stgit@localhost.localdomain>
	<20100714160704.GA10473@kryptos.osrc.amd.com>
	<20100714232201.00433aa9@hammerfall>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index e7e3521..7667977 100644
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
@@ -589,7 +591,6 @@ static void c1e_idle(void)
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
