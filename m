Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab0ESVwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:52:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:41490 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab0ESVwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:52:14 -0400
Date: Wed, 19 May 2010 21:51:59 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, hpa@linux.intel.com, jacob.jun.pan@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jacob.jun.pan@linux.intel.com, hpa@linux.intel.com
In-Reply-To: <1274295685-6774-3-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1274295685-6774-3-git-send-email-jacob.jun.pan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, mrst: add cpu type detection
Message-ID: <tip-a0c173bd8a3fd0541be8e4ef962170e48d8811c7@git.kernel.org>
Git-Commit-ID: a0c173bd8a3fd0541be8e4ef962170e48d8811c7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 19 May 2010 21:52:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a0c173bd8a3fd0541be8e4ef962170e48d8811c7
Gitweb:     http://git.kernel.org/tip/a0c173bd8a3fd0541be8e4ef962170e48d8811c7
Author:     Jacob Pan <jacob.jun.pan@linux.intel.com>
AuthorDate: Wed, 19 May 2010 12:01:24 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 19 May 2010 13:32:29 -0700

x86, mrst: add cpu type detection

Medfield is the follow-up of Moorestown, it is treated under the same
HW sub-architecture. However, we do need to know the CPU type in order
for some of the driver to act accordingly.
We also have different optimal clock configuration for each CPU type.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
LKML-Reference: <1274295685-6774-3-git-send-email-jacob.jun.pan@linux.intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
index e796448..ceaebeb 100644
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
