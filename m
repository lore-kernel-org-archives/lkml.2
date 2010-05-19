Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab0ESTIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:08:34 -0400
Received: from mga06.intel.com ([134.134.136.21]:15519 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754248Ab0ESTIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:08:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,265,1272870000"; 
   d="scan'208";a="519453413"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Alek Du <alek.du@intel.com>, Alan Cox <alan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 2/3] x86/mrst: add cpu type detection
Date: Wed, 19 May 2010 12:01:24 -0700
Message-Id: <1274295685-6774-3-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1274295685-6774-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1274295685-6774-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Medfield is the follow-up of Moorestown, it is treated under the same
HW sub-architecture. However, we do need to know the CPU type in order
for some of the driver to act accordingly.
We also have different optimal clock configuration for each CPU type.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/mrst.h |   19 +++++++++++++++++++
 arch/x86/kernel/mrst.c      |   26 ++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 451d30e..dc5c850 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -11,8 +11,27 @@
 #ifndef _ASM_X86_MRST_H
 #define _ASM_X86_MRST_H
 extern int pci_mrst_init(void);
+extern int mrst_identify_cpu(void);
 int __init sfi_parse_mrtc(struct sfi_table_header *table);
 
+/*
+ * Medfield is the follow-up of Moorestown, it combines two chip solution into
+ * one. Other than that it also added always-on and constant tsc and lapic
+ * timers. Medfield is the platform name, and the chip name is called Penwell
+ * we treat Medfield/Penwell as a variant of Moorestown. Penwell can be
+ * identified via MSRs.
+ */
+enum mrst_cpu_type {
+	MRST_CPU_CHIP_LINCROFT = 1,
+	MRST_CPU_CHIP_PENWELL,
+};
+
+enum mrst_timer_options {
+	MRST_TIMER_DEFAULT,
+	MRST_TIMER_APBT_ONLY,
+	MRST_TIMER_LAPIC_APBT,
+};
+
 #define SFI_MTMR_MAX_NUM 8
 #define SFI_MRTC_MAX	8
 
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index 0aad867..248809a 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -27,6 +27,8 @@
 
 static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
 static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
+static int mrst_cpu_chip;
+
 int sfi_mtimer_num;
 
 struct sfi_rtc_table_entry sfi_mrtc_array[SFI_MRTC_MAX];
@@ -216,6 +218,28 @@ static void __init mrst_setup_boot_clock(void)
 		setup_boot_APIC_clock();
 };
 
+int mrst_identify_cpu(void)
+{
+	return mrst_cpu_chip;
+}
+EXPORT_SYMBOL_GPL(mrst_identify_cpu);
+
+void __cpuinit mrst_arch_setup(void)
+{
+	if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 0x27)
+		mrst_cpu_chip = MRST_CPU_CHIP_PENWELL;
+	else if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 0x26)
+		mrst_cpu_chip = MRST_CPU_CHIP_LINCROFT;
+	else {
+		pr_err("Unknown Moorestown CPU (%d:%d), default to Lincroft\n",
+			boot_cpu_data.x86, boot_cpu_data.x86_model);
+		mrst_cpu_chip = MRST_CPU_CHIP_LINCROFT;
+	}
+	pr_debug("Moorestown CPU %s identified\n",
+		(mrst_cpu_chip == MRST_CPU_CHIP_LINCROFT) ?
+		"Lincroft" : "Penwell");
+}
+
 /*
  * Moorestown specific x86_init function overrides and early setup
  * calls.
@@ -230,6 +254,8 @@ void __init x86_mrst_early_setup(void)
 
 	x86_init.irqs.pre_vector_init = x86_init_noop;
 
+	x86_init.oem.arch_setup = mrst_arch_setup;
+
 	x86_cpuinit.setup_percpu_clockev = mrst_setup_secondary_clock;
 
 	x86_platform.calibrate_tsc = mrst_calibrate_tsc;
-- 
1.6.3.3

