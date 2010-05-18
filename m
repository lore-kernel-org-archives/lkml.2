Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab0ERMK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 08:10:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:11272 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757201Ab0ERMJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 08:09:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,255,1272870000"; 
   d="scan'208";a="518927056"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Alek Du <alek.du@intel.com>, Alan Cox <alan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 1/2] v4 x86/mrst: add cpu type detection
Date: Tue, 18 May 2010 05:02:45 -0700
Message-Id: <1274184166-17242-2-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1274184166-17242-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1274184166-17242-1-git-send-email-jacob.jun.pan@linux.intel.com>
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
 arch/x86/kernel/mrst.c      |   20 ++++++++++++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 451d30e..a25eff3 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -11,8 +11,27 @@
 #ifndef _ASM_X86_MRST_H
 #define _ASM_X86_MRST_H
 extern int pci_mrst_init(void);
+extern int mrst_identify_cpu(void);
 int __init sfi_parse_mrtc(struct sfi_table_header *table);
 
+/**
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
index 0aad867..0bca837 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -216,6 +216,26 @@ static void __init mrst_setup_boot_clock(void)
 		setup_boot_APIC_clock();
 };
 
+int mrst_identify_cpu(void)
+{
+	u32 mrst_cpu_chip;
+
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
+	return mrst_cpu_chip;
+}
+EXPORT_SYMBOL_GPL(mrst_identify_cpu);
+
 /*
  * Moorestown specific x86_init function overrides and early setup
  * calls.
-- 
1.6.3.3

