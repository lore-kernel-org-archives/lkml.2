Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab0ENVvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 17:51:51 -0400
Received: from mga06.intel.com ([134.134.136.21]:49795 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759781Ab0ENVsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 17:48:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,233,1272870000"; 
   d="scan'208";a="621797634"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 2/8] x86/mrst: add cpu type detection for Medfield
Date: Fri, 14 May 2010 14:41:15 -0700
Message-Id: <1273873281-17489-3-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Medfield is the follow-up of Moorestown, it is treated under the same
HW sub-architecture. However, we do need to know the CPU type such that
some drivers can act accordingly.

We also have different optimal clock configuration for each CPU type.
For Moorestown the CPU type is Lincroft and for Medfield the CPU type is
Penwell.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/mrst.h |   13 +++++++++++++
 arch/x86/kernel/mrst.c      |   21 +++++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 451d30e..ddf0ad8 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -11,8 +11,21 @@
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
 #define SFI_MTMR_MAX_NUM 8
 #define SFI_MRTC_MAX	8
 
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index 0aad867..a3e85be 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -27,6 +27,7 @@
 
 static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
 static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
+static u32 mrst_cpu_chip;
 int sfi_mtimer_num;
 
 struct sfi_rtc_table_entry sfi_mrtc_array[SFI_MRTC_MAX];
@@ -216,6 +217,26 @@ static void __init mrst_setup_boot_clock(void)
 		setup_boot_APIC_clock();
 };
 
+int mrst_identify_cpu(void)
+{
+	if (boot_cpu_data.x86 == 6 &&
+		boot_cpu_data.x86_model == 0x27 &&
+		boot_cpu_data.x86_mask == 1)
+		mrst_cpu_chip = MRST_CPU_CHIP_PENWELL;
+	else if (boot_cpu_data.x86 == 6 &&
+		boot_cpu_data.x86_model == 0x26)
+		mrst_cpu_chip = MRST_CPU_CHIP_LINCROFT;
+	else {
+		pr_err("Unknown Moorestown CPU type, default to Lincroft\n");
+		mrst_cpu_chip = MRST_CPU_CHIP_LINCROFT;
+	}
+	pr_debug("Moorestown CPU %s identified\n",
+		(mrst_cpu_chip == MRST_CPU_CHIP_LINCROFT) ?
+		"Lincroft" : "Penwell");
+
+	return mrst_cpu_chip;
+}
+
 /*
  * Moorestown specific x86_init function overrides and early setup
  * calls.
-- 
1.6.3.3

