Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab0ENVvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 17:51:48 -0400
Received: from mga06.intel.com ([134.134.136.21]:35340 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759930Ab0ENVsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 17:48:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,233,1272870000"; 
   d="scan'208";a="621797644"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 3/8] x86/mrst: add more timer options to include Medfield
Date: Fri, 14 May 2010 14:41:16 -0700
Message-Id: <1273873281-17489-4-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Medfield has added always-on lapic timer which will be ranked higher
than the platform timers. This patch allows more timer options to
support optimal configuration for both Moorestown and Medfield.

i.e. per CPU always-on lapic timers for Medfield
     per CPU APB timers for Moorestown

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/mrst.h |    7 ++++++
 arch/x86/kernel/mrst.c      |   51 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index ddf0ad8..f683603 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -12,6 +12,7 @@
 #define _ASM_X86_MRST_H
 extern int pci_mrst_init(void);
 extern int mrst_identify_cpu(void);
+extern int mrst_timer_options __cpuinitdata;
 int __init sfi_parse_mrtc(struct sfi_table_header *table);
 
 /**
@@ -26,6 +27,12 @@ enum mrst_cpu_type {
 	MRST_CPU_CHIP_PENWELL,
 };
 
+enum mrst_timer_options {
+	MRST_TIMER_DEFAULT,
+	MRST_TIMER_APBT_ONLY,
+	MRST_TIMER_LAPIC_APBT,
+};
+
 #define SFI_MTMR_MAX_NUM 8
 #define SFI_MRTC_MAX	8
 
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index a3e85be..339d7f5 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -25,6 +25,29 @@
 #include <asm/i8259.h>
 #include <asm/apb_timer.h>
 
+/**
+ * the clockevent devices on Moorestown/Medfield can be APBT or LAPIC clock,
+ * cmdline option x86_mrst_timer can be used to override the configuration
+ * to prefer one or the other.
+ * at runtime, there are basically three timer configurations:
+ * 1. per cpu apbt clock only
+ * 2. per cpu always-on lapic clocks only, this is Penwell/Medfield only
+ * 3. per cpu lapic clock (C3STOP) and one apbt clock, with broadcast.
+ *
+ * by default (without cmdline option), platform code first detects cpu type
+ * to see if we are on lincroft or penwell, then set up both lapic or apbt
+ * clocks accordingly.
+ * i.e. by default, medfield uses configuration #2, moorestown uses #1.
+ * config #3 is supported but not recommended on medfield.
+ *
+ * rating and feature summary:
+ * lapic (with C3STOP) --------- 100
+ * apbt (always-on) ------------ 110
+ * lapic (always-on,ARAT) ------ 150
+ */
+
+int mrst_timer_options __cpuinitdata;
+
 static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
 static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
 static u32 mrst_cpu_chip;
@@ -168,15 +191,16 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
 	return 0;
 }
 
-/*
- * the secondary clock in Moorestown can be APBT or LAPIC clock, default to
- * APBT but cmdline option can also override it.
- */
 static void __cpuinit mrst_setup_secondary_clock(void)
 {
-	/* restore default lapic clock if disabled by cmdline */
-	if (disable_apbt_percpu)
-		return setup_secondary_APIC_clock();
+	if ((mrst_timer_options == MRST_TIMER_APBT_ONLY))
+		return apbt_setup_secondary_clock();
+	if (cpu_has(&current_cpu_data, X86_FEATURE_ARAT)
+		||  (mrst_timer_options == MRST_TIMER_LAPIC_APBT)) {
+		pr_info("using lapic timers for secondary clock\n");
+		setup_secondary_APIC_clock();
+		return;
+	}
 	apbt_setup_secondary_clock();
 }
 
@@ -196,6 +220,13 @@ static unsigned long __init mrst_calibrate_tsc(void)
 
 void __init mrst_time_init(void)
 {
+	mrst_identify_cpu();
+
+	/* if cpu is penwell, lapic timer will be used by default */
+	if ((mrst_cpu_chip == MRST_CPU_CHIP_PENWELL) &&
+		(mrst_timer_options == MRST_TIMER_DEFAULT))
+		return;
+
 	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
 	pre_init_apic_IRQ0();
 	apbt_time_init();
@@ -212,8 +243,10 @@ void __init mrst_rtc_init(void)
  */
 static void __init mrst_setup_boot_clock(void)
 {
-	pr_info("%s: per cpu apbt flag %d \n", __func__, disable_apbt_percpu);
-	if (disable_apbt_percpu)
+	if (mrst_timer_options == MRST_TIMER_APBT_ONLY)
+		return;
+	if ((mrst_timer_options == MRST_TIMER_LAPIC_APBT)
+		|| (mrst_cpu_chip == MRST_CPU_CHIP_PENWELL))
 		setup_boot_APIC_clock();
 };
 
-- 
1.6.3.3

