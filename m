Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab0ESVwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:52:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:41523 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213Ab0ESVwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:52:51 -0400
Date: Wed, 19 May 2010 21:52:35 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, jacob.jun.pan@linux.intel.com, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com, jacob.jun.pan@linux.intel.com
In-Reply-To: <1274295685-6774-3-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1274295685-6774-3-git-send-email-jacob.jun.pan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, mrst: make mrst_identify_cpu() an inline returning enum
Message-ID: <tip-a75af580bb1fd261bf63cc00e4b324e17ceb15cf@git.kernel.org>
Git-Commit-ID: a75af580bb1fd261bf63cc00e4b324e17ceb15cf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 19 May 2010 21:52:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a75af580bb1fd261bf63cc00e4b324e17ceb15cf
Gitweb:     http://git.kernel.org/tip/a75af580bb1fd261bf63cc00e4b324e17ceb15cf
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 19 May 2010 13:40:14 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 19 May 2010 13:47:11 -0700

x86, mrst: make mrst_identify_cpu() an inline returning enum

We have an enum, might as well use it.  While we're at it, make it an
inline... there is really no point in calling a function for this
stuff.

LKML-Reference: <1274295685-6774-3-git-send-email-jacob.jun.pan@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/mrst.h |    7 ++++++-
 arch/x86/kernel/mrst.c      |   17 ++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 67ad315..1869c18 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -11,7 +11,6 @@
 #ifndef _ASM_X86_MRST_H
 #define _ASM_X86_MRST_H
 extern int pci_mrst_init(void);
-extern int mrst_identify_cpu(void);
 extern int mrst_timer_options __cpuinitdata;
 int __init sfi_parse_mrtc(struct sfi_table_header *table);
 
@@ -27,6 +26,12 @@ enum mrst_cpu_type {
 	MRST_CPU_CHIP_PENWELL,
 };
 
+extern enum mrst_cpu_type __mrst_cpu_chip;
+static enum mrst_cpu_type mrst_identify_cpu(void)
+{
+	return __mrst_cpu_chip;
+}
+
 enum mrst_timer_options {
 	MRST_TIMER_DEFAULT,
 	MRST_TIMER_APBT_ONLY,
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index 636b53b..967f268 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -50,7 +50,8 @@ int mrst_timer_options __cpuinitdata;
 
 static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
 static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
-static int mrst_cpu_chip;
+enum mrst_cpu_type __mrst_cpu_chip;
+EXPORT_SYMBOL_GPL(__mrst_cpu_chip);
 
 int sfi_mtimer_num;
 
@@ -233,25 +234,19 @@ void __init mrst_rtc_init(void)
 	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
 }
 
-int mrst_identify_cpu(void)
-{
-	return mrst_cpu_chip;
-}
-EXPORT_SYMBOL_GPL(mrst_identify_cpu);
-
 void __cpuinit mrst_arch_setup(void)
 {
 	if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 0x27)
-		mrst_cpu_chip = MRST_CPU_CHIP_PENWELL;
+		__mrst_cpu_chip = MRST_CPU_CHIP_PENWELL;
 	else if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 0x26)
-		mrst_cpu_chip = MRST_CPU_CHIP_LINCROFT;
+		__mrst_cpu_chip = MRST_CPU_CHIP_LINCROFT;
 	else {
 		pr_err("Unknown Moorestown CPU (%d:%d), default to Lincroft\n",
 			boot_cpu_data.x86, boot_cpu_data.x86_model);
-		mrst_cpu_chip = MRST_CPU_CHIP_LINCROFT;
+		__mrst_cpu_chip = MRST_CPU_CHIP_LINCROFT;
 	}
 	pr_debug("Moorestown CPU %s identified\n",
-		(mrst_cpu_chip == MRST_CPU_CHIP_LINCROFT) ?
+		(__mrst_cpu_chip == MRST_CPU_CHIP_LINCROFT) ?
 		"Lincroft" : "Penwell");
 }
 
