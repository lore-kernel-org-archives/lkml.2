Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964849Ab2JKCOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:14:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:24713 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964831Ab2JKCOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:14:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,567,1344236400"; 
   d="scan'208";a="225376017"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Richard L Maliszewski <richard.l.maliszewski@intel.com>,
        linux-kernel@vger.kernel.org, tboot-devel@lists.sourceforge.net,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>, Gang Wei <gang.wei@intel.com>
Subject: [PATCH v2] x86: add a new SMP bring up way for tboot case
Date: Thu, 11 Oct 2012 18:11:07 +0800
Message-Id: <1349950267-28328-1-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tboot provides a better AP wakeup mechanism based on cpu MWAIT feature for
OS/VMM. With this mechanism, system will boot faster and will NOT require
VT to be enabled. But it requires that OS/VMM must have support it, otherwise
system can never boot up.

Once this mechanism is enabled, tboot will put APs waiting in MWAIT loops
before launching kernel. kernel can check the new flag field in v6 tboot
shared page for the hint. If the bit TB_FLAG_AP_WAKE_SUPPORT in flag field
is set, kernel BSP has to write the monitored memory (tboot->ap_wake_trigger)
to bring APs out of MWAIT loops. The sipi vector should be written in
tboot->ap_wake_addr before waking up APs.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
Signed-off-by: Gang Wei <gang.wei@intel.com>
---
 arch/x86/kernel/smpboot.c |   21 +++++++++++----------
 arch/x86/kernel/tboot.c   |   17 +++++++++++++++++
 include/linux/tboot.h     |   17 +++++++++++++++++
 3 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c80a33b..884c3e7 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -662,8 +662,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 	/* start_ip had better be page-aligned! */
 	unsigned long start_ip = real_mode_header->trampoline_start;
 
-	unsigned long boot_error = 0;
-	int timeout;
+	int timeout, boot_error = 0;
 
 	/* Just in case we booted with a single CPU. */
 	alternatives_enable_smp();
@@ -710,14 +709,16 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 		}
 	}
 
-	/*
-	 * Kick the secondary CPU. Use the method in the APIC driver
-	 * if it's defined - or use an INIT boot APIC message otherwise:
-	 */
-	if (apic->wakeup_secondary_cpu)
-		boot_error = apic->wakeup_secondary_cpu(apicid, start_ip);
-	else
-		boot_error = wakeup_secondary_cpu_via_init(apicid, start_ip);
+	if (!tboot_wake_up(apicid, start_ip)) {
+		/*
+		 * Kick the secondary CPU. Use the method in the APIC driver
+		 * if it's defined - or use an INIT boot APIC message otherwise:
+		 */
+		if (apic->wakeup_secondary_cpu)
+			boot_error = apic->wakeup_secondary_cpu(apicid, start_ip);
+		else
+			boot_error = wakeup_secondary_cpu_via_init(apicid, start_ip);
+	}
 
 	if (!boot_error) {
 		/*
diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index f84fe00..e5e50b8 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -101,6 +101,8 @@ void __init tboot_probe(void)
 	pr_debug("shutdown_entry: 0x%x\n", tboot->shutdown_entry);
 	pr_debug("tboot_base: 0x%08x\n", tboot->tboot_base);
 	pr_debug("tboot_size: 0x%x\n", tboot->tboot_size);
+	if (tboot->version >= 6)
+		pr_info("flags: 0x%08x\n", tboot->flags);
 }
 
 static pgd_t *tboot_pg_dir;
@@ -453,3 +455,18 @@ int tboot_force_iommu(void)
 
 	return 1;
 }
+
+int tboot_wake_up(int apicid, unsigned long sipi_vec)
+{
+	if (!tboot_enabled())
+		return 0;
+
+	if ((tboot->version < 6) ||
+	    !(tboot->flags & TB_FLAG_AP_WAKE_SUPPORT))
+		return 0;
+
+	tboot->ap_wake_addr = sipi_vec;
+	tboot->ap_wake_trigger = apicid;
+
+	return 1;
+}
diff --git a/include/linux/tboot.h b/include/linux/tboot.h
index c75128b..d65f7e9 100644
--- a/include/linux/tboot.h
+++ b/include/linux/tboot.h
@@ -124,8 +124,23 @@ struct tboot {
 
 	/* number of processors in wait-for-SIPI */
 	u32 num_in_wfs;
+
+	/*
+	 * version 6+ fields:
+	 */
+
+	u32 flags;
+
+	/* phys addr of kernel/VMM SIPI vector */
+	u64 ap_wake_addr;
+
+	/* kernel/VMM writes APIC ID to wake AP */
+	u32 ap_wake_trigger;
 } __packed;
 
+/* kernel/VMM use INIT-SIPI-SIPI if clear, ap_wake_* if set */
+#define TB_FLAG_AP_WAKE_SUPPORT 0X00000001
+
 /*
  * UUID for tboot data struct to facilitate matching
  * defined as {663C8DFF-E8B3-4b82-AABF-19EA4D057A08} by tboot, which is
@@ -146,6 +161,7 @@ extern void tboot_shutdown(u32 shutdown_type);
 extern struct acpi_table_header *tboot_get_dmar_table(
 				      struct acpi_table_header *dmar_tbl);
 extern int tboot_force_iommu(void);
+extern int tboot_wake_up(int apicid, unsigned long sipi_vec);
 
 #else
 
@@ -156,6 +172,7 @@ extern int tboot_force_iommu(void);
 					do { } while (0)
 #define tboot_get_dmar_table(dmar_tbl)	(dmar_tbl)
 #define tboot_force_iommu()		0
+#define tboot_wake_up(apicid, sipi_vec) 0
 
 #endif /* !CONFIG_INTEL_TXT */
 
-- 
1.7.9.5

