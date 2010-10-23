Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0JWIqY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 04:46:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:33523 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab0JWIqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 04:46:21 -0400
Date: Sat, 23 Oct 2010 08:46:04 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: dirk.j.brandewie@intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dirk.j.brandewie@intel.com, tglx@linutronix.de
In-Reply-To: <1287510389-8388-1-git-send-email-dirk.brandewie@gmail.com>
References: <1287510389-8388-1-git-send-email-dirk.brandewie@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Allow platforms to force enable apic
Message-ID: <tip-f6e3a8e1bacfe5013becf416ce9dd2cb025d4177@git.kernel.org>
Git-Commit-ID: f6e3a8e1bacfe5013becf416ce9dd2cb025d4177
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 23 Oct 2010 08:46:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6e3a8e1bacfe5013becf416ce9dd2cb025d4177
Gitweb:     http://git.kernel.org/tip/f6e3a8e1bacfe5013becf416ce9dd2cb025d4177
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 19 Oct 2010 10:46:28 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 23 Oct 2010 10:43:19 +0200

x86: Allow platforms to force enable apic

Some embedded x86 platforms don't setup the APIC in the
BIOS/bootloader and would be forced to add "lapic" on the kernel
command line. That's a bit akward.

Split out the force enable code from detect_init_APIC() and allow
platform code to call it from the platform setup. That avoids the
command line parameter and possible replication of the MSR dance in
the force enable code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <1287510389-8388-1-git-send-email-dirk.brandewie@gmail.com>
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 arch/x86/include/asm/apic.h |    1 +
 arch/x86/kernel/apic/apic.c |   87 ++++++++++++++++++++++++++----------------
 2 files changed, 55 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 286de34..ad50aaa 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -238,6 +238,7 @@ extern void setup_boot_APIC_clock(void);
 extern void setup_secondary_APIC_clock(void);
 extern int APIC_init_uniprocessor(void);
 extern void enable_NMI_through_LVT0(void);
+extern int apic_force_enable(void);
 
 /*
  * On 32bit this is mach-xxx local
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 850657d..4638396 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1531,13 +1531,60 @@ static int __init detect_init_APIC(void)
 	return 0;
 }
 #else
+
+static int apic_verify(void)
+{
+	u32 features, h, l;
+
+	/*
+	 * The APIC feature bit should now be enabled
+	 * in `cpuid'
+	 */
+	features = cpuid_edx(1);
+	if (!(features & (1 << X86_FEATURE_APIC))) {
+		pr_warning("Could not enable APIC!\n");
+		return -1;
+	}
+	set_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
+	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
+
+	/* The BIOS may have set up the APIC at some other address */
+	rdmsr(MSR_IA32_APICBASE, l, h);
+	if (l & MSR_IA32_APICBASE_ENABLE)
+		mp_lapic_addr = l & MSR_IA32_APICBASE_BASE;
+
+	pr_info("Found and enabled local APIC!\n");
+	return 0;
+}
+
+int apic_force_enable(void)
+{
+	u32 h, l;
+
+	if (disable_apic)
+		return -1;
+
+	/*
+	 * Some BIOSes disable the local APIC in the APIC_BASE
+	 * MSR. This can only be done in software for Intel P6 or later
+	 * and AMD K7 (Model > 1) or later.
+	 */
+	rdmsr(MSR_IA32_APICBASE, l, h);
+	if (!(l & MSR_IA32_APICBASE_ENABLE)) {
+		pr_info("Local APIC disabled by BIOS -- reenabling.\n");
+		l &= ~MSR_IA32_APICBASE_BASE;
+		l |= MSR_IA32_APICBASE_ENABLE | APIC_DEFAULT_PHYS_BASE;
+		wrmsr(MSR_IA32_APICBASE, l, h);
+		enabled_via_apicbase = 1;
+	}
+	return apic_verify();
+}
+
 /*
  * Detect and initialize APIC
  */
 static int __init detect_init_APIC(void)
 {
-	u32 h, l, features;
-
 	/* Disabled by kernel option? */
 	if (disable_apic)
 		return -1;
@@ -1567,38 +1614,12 @@ static int __init detect_init_APIC(void)
 				"you can enable it with \"lapic\"\n");
 			return -1;
 		}
-		/*
-		 * Some BIOSes disable the local APIC in the APIC_BASE
-		 * MSR. This can only be done in software for Intel P6 or later
-		 * and AMD K7 (Model > 1) or later.
-		 */
-		rdmsr(MSR_IA32_APICBASE, l, h);
-		if (!(l & MSR_IA32_APICBASE_ENABLE)) {
-			pr_info("Local APIC disabled by BIOS -- reenabling.\n");
-			l &= ~MSR_IA32_APICBASE_BASE;
-			l |= MSR_IA32_APICBASE_ENABLE | APIC_DEFAULT_PHYS_BASE;
-			wrmsr(MSR_IA32_APICBASE, l, h);
-			enabled_via_apicbase = 1;
-		}
-	}
-	/*
-	 * The APIC feature bit should now be enabled
-	 * in `cpuid'
-	 */
-	features = cpuid_edx(1);
-	if (!(features & (1 << X86_FEATURE_APIC))) {
-		pr_warning("Could not enable APIC!\n");
-		return -1;
+		if (apic_force_enable())
+			return -1;
+	} else {
+		if (apic_verify())
+			return -1;
 	}
-	set_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
-	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
-
-	/* The BIOS may have set up the APIC at some other address */
-	rdmsr(MSR_IA32_APICBASE, l, h);
-	if (l & MSR_IA32_APICBASE_ENABLE)
-		mp_lapic_addr = l & MSR_IA32_APICBASE_BASE;
-
-	pr_info("Found and enabled local APIC!\n");
 
 	apic_pm_activate();
 
