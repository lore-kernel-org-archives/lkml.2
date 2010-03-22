Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab0CVBjg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 21:39:36 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:32263 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab0CVBjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 21:39:33 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/10] x86: kill smpboot_hooks.h
Date: Sun, 21 Mar 2010 18:36:04 -0700
Message-Id: <1269221770-9667-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269221770-9667-1-git-send-email-yinghai@kernel.org>
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BA6CA38.008E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

only one user, move it back to smpboot.c

remove smpboot_clear_io_apic, and only keep smpboot_clear_io_apic_irqs.

and check nr_legacy_irqs before clear it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/smpboot_hooks.h |   61 ----------------------------------
 arch/x86/kernel/smpboot.c            |   57 ++++++++++++++++++++++++++++++--
 2 files changed, 54 insertions(+), 64 deletions(-)
 delete mode 100644 arch/x86/include/asm/smpboot_hooks.h

diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
deleted file mode 100644
index 1def601..0000000
--- a/arch/x86/include/asm/smpboot_hooks.h
+++ /dev/null
@@ -1,61 +0,0 @@
-/* two abstractions specific to kernel/smpboot.c, mainly to cater to visws
- * which needs to alter them. */
-
-static inline void smpboot_clear_io_apic_irqs(void)
-{
-#ifdef CONFIG_X86_IO_APIC
-	io_apic_irqs = 0;
-#endif
-}
-
-static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
-{
-	CMOS_WRITE(0xa, 0xf);
-	local_flush_tlb();
-	pr_debug("1.\n");
-	*((volatile unsigned short *)phys_to_virt(apic->trampoline_phys_high)) =
-								 start_eip >> 4;
-	pr_debug("2.\n");
-	*((volatile unsigned short *)phys_to_virt(apic->trampoline_phys_low)) =
-							 start_eip & 0xf;
-	pr_debug("3.\n");
-}
-
-static inline void smpboot_restore_warm_reset_vector(void)
-{
-	/*
-	 * Install writable page 0 entry to set BIOS data area.
-	 */
-	local_flush_tlb();
-
-	/*
-	 * Paranoid:  Set warm reset code and vector here back
-	 * to default values.
-	 */
-	CMOS_WRITE(0, 0xf);
-
-	*((volatile long *)phys_to_virt(apic->trampoline_phys_low)) = 0;
-}
-
-static inline void __init smpboot_setup_io_apic(void)
-{
-#ifdef CONFIG_X86_IO_APIC
-	/*
-	 * Here we can be sure that there is an IO-APIC in the system. Let's
-	 * go and set it up:
-	 */
-	if (!skip_ioapic_setup && nr_ioapics)
-		setup_IO_APIC();
-	else {
-		nr_ioapics = 0;
-		localise_nmi_watchdog();
-	}
-#endif
-}
-
-static inline void smpboot_clear_io_apic(void)
-{
-#ifdef CONFIG_X86_IO_APIC
-	nr_ioapics = 0;
-#endif
-}
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 06d98ae..ba43b3b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -67,7 +67,6 @@
 #include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
 
-#include <asm/smpboot_hooks.h>
 #include <asm/i8259.h>
 
 #ifdef CONFIG_X86_32
@@ -701,6 +700,35 @@ static void __cpuinit announce_cpu(int cpu, int apicid)
 			node, cpu, apicid);
 }
 
+static void smpboot_setup_warm_reset_vector(unsigned long start_eip)
+{
+	CMOS_WRITE(0xa, 0xf);
+	local_flush_tlb();
+	pr_debug("1.\n");
+	*((volatile unsigned short *)phys_to_virt(apic->trampoline_phys_high)) =
+								 start_eip >> 4;
+	pr_debug("2.\n");
+	*((volatile unsigned short *)phys_to_virt(apic->trampoline_phys_low)) =
+							 start_eip & 0xf;
+	pr_debug("3.\n");
+}
+
+static void smpboot_restore_warm_reset_vector(void)
+{
+	/*
+	 * Install writable page 0 entry to set BIOS data area.
+	 */
+	local_flush_tlb();
+
+	/*
+	 * Paranoid:  Set warm reset code and vector here back
+	 * to default values.
+	 */
+	CMOS_WRITE(0, 0xf);
+
+	*((volatile long *)phys_to_virt(apic->trampoline_phys_low)) = 0;
+}
+
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
  * (ie clustered apic addressing mode), this is a LOGICAL apic ID.
@@ -928,6 +956,13 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	return 0;
 }
 
+static void smpboot_clear_io_apic_irqs(void)
+{
+#ifdef CONFIG_X86_IO_APIC
+	if (legacy_pic->nr_legacy_irqs)
+		io_apic_irqs = 0;
+#endif
+}
 /*
  * Fall back to non SMP mode after errors.
  *
@@ -1027,7 +1062,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 			pr_err("... forcing use of dummy APIC emulation."
 				"(tell your hw vendor)\n");
 		}
-		smpboot_clear_io_apic();
+		smpboot_clear_io_apic_irqs();
 		arch_disable_smp_support();
 		return -1;
 	}
@@ -1039,7 +1074,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	 */
 	if (!max_cpus) {
 		printk(KERN_INFO "SMP mode deactivated.\n");
-		smpboot_clear_io_apic();
+		smpboot_clear_io_apic_irqs();
 
 		localise_nmi_watchdog();
 
@@ -1064,6 +1099,22 @@ static void __init smp_cpu_index_default(void)
 	}
 }
 
+static void __init smpboot_setup_io_apic(void)
+{
+#ifdef CONFIG_X86_IO_APIC
+	/*
+	 * Here we can be sure that there is an IO-APIC in the system. Let's
+	 * go and set it up:
+	 */
+	if (!skip_ioapic_setup && nr_ioapics)
+		setup_IO_APIC();
+	else {
+		nr_ioapics = 0;
+		localise_nmi_watchdog();
+	}
+#endif
+}
+
 /*
  * Prepare for SMP bootup.  The MP table or ACPI has been read
  * earlier.  Just do some sanity checking here and enable APIC mode.
-- 
1.6.4.2

