Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0JSRdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 13:33:55 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45488 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab0JSRdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 13:33:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=q0m4bCWzKBMfMtzQG9nKQUKvOmcBGuS4P9D/PWw/uI8ZApPsdH7PTAWctYfbnHaDYq
         BbsHJ3W8XmNnw6UmWhpV0ozzrrLCoeR7m6vNJxV1AydlPRunao8oPbw3AKP8xP/koqn6
         6Ck+BMENEo9Mc98FtXMzip00Ris4x+dKC0EZY=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org
Subject: [PATCH] x86: Allow platforms to force enable apic
Date: Tue, 19 Oct 2010 10:46:28 -0700
Message-Id: <1287510389-8388-1-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Some embedded x86 platforms don't setup the APIC in the
BIOS/bootloader and would be forced to add "lapic" on the kernel
command line. That's a bit akward.

Split out the force enable code from detect_init_APIC() and allow
platform code to call it from the platform setup.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h |    1 +
 arch/x86/kernel/apic/apic.c |   87 ++++++++++++++++++++++++++----------------
 2 files changed, 55 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 1fa03e0..4261a39 100644
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
index e3b534c..67ba18a 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1481,13 +1481,60 @@ static int __init detect_init_APIC(void)
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
@@ -1517,38 +1564,12 @@ static int __init detect_init_APIC(void)
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
 
-- 
1.7.2.3

