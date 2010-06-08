Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab0FHGgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 02:36:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:37386 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab0FHGf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 02:35:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,383,1272870000"; 
   d="scan'208";a="574269041"
Subject: [PATCH 2/2] Use HW_ERR in MCE handler
From: Huang Ying <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jun 2010 14:35:39 +0800
Message-ID: <1275978939.3444.668.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use HW_ERR printk prefix in MCE handler. To make it more explicit that
this is hardware error instead of software error.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   32 ++++++++++----------------------
 1 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 18cc425..094b228 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -107,8 +107,8 @@ EXPORT_SYMBOL_GPL(x86_mce_decoder_chain);
 static int default_decode_mce(struct notifier_block *nb, unsigned long val,
 			       void *data)
 {
-	pr_emerg("No human readable MCE decoding support on this CPU type.\n");
-	pr_emerg("Run the message through 'mcelog --ascii' to decode.\n");
+	pr_emerg(HW_ERR "No human readable MCE decoding support on this CPU type.\n");
+	pr_emerg(HW_ERR "Run the message through 'mcelog --ascii' to decode.\n");
 
 	return NOTIFY_STOP;
 }
@@ -211,11 +211,11 @@ void mce_log(struct mce *mce)
 
 static void print_mce(struct mce *m)
 {
-	pr_emerg("CPU %d: Machine Check Exception: %16Lx Bank %d: %016Lx\n",
+	pr_emerg(HW_ERR "CPU %d: Machine Check Exception: %Lx Bank %d: %016Lx\n",
 	       m->extcpu, m->mcgstatus, m->bank, m->status);
 
 	if (m->ip) {
-		pr_emerg("RIP%s %02x:<%016Lx> ",
+		pr_emerg(HW_ERR "RIP%s %02x:<%016Lx> ",
 			!(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
 				m->cs, m->ip);
 
@@ -224,14 +224,14 @@ static void print_mce(struct mce *m)
 		pr_cont("\n");
 	}
 
-	pr_emerg("TSC %llx ", m->tsc);
+	pr_emerg(HW_ERR "TSC %llx ", m->tsc);
 	if (m->addr)
 		pr_cont("ADDR %llx ", m->addr);
 	if (m->misc)
 		pr_cont("MISC %llx ", m->misc);
 
 	pr_cont("\n");
-	pr_emerg("PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
+	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
 		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid);
 
 	/*
@@ -241,16 +241,6 @@ static void print_mce(struct mce *m)
 	atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
 }
 
-static void print_mce_head(void)
-{
-	pr_emerg("\nHARDWARE ERROR\n");
-}
-
-static void print_mce_tail(void)
-{
-	pr_emerg("This is not a software problem!\n");
-}
-
 #define PANIC_TIMEOUT 5 /* 5 seconds */
 
 static atomic_t mce_paniced;
@@ -291,7 +281,6 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 		if (atomic_inc_return(&mce_fake_paniced) > 1)
 			return;
 	}
-	print_mce_head();
 	/* First print corrected ones that are still unlogged */
 	for (i = 0; i < MCE_LOG_LEN; i++) {
 		struct mce *m = &mcelog.entry[i];
@@ -322,16 +311,15 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 			apei_err = apei_write_mce(final);
 	}
 	if (cpu_missing)
-		printk(KERN_EMERG "Some CPUs didn't answer in synchronization\n");
-	print_mce_tail();
+		pr_emerg(HW_ERR "Some CPUs didn't answer in synchronization\n");
 	if (exp)
-		printk(KERN_EMERG "Machine check: %s\n", exp);
+		pr_emerg(HW_ERR "Machine check: %s\n", exp);
 	if (!fake_panic) {
 		if (panic_timeout == 0)
 			panic_timeout = mce_panic_timeout;
 		panic(msg);
 	} else
-		printk(KERN_EMERG "Fake kernel panic: %s\n", msg);
+		pr_emerg(HW_ERR "Fake kernel panic: %s\n", msg);
 }
 
 /* Support code for software error injection */
@@ -1220,7 +1208,7 @@ int mce_notify_irq(void)
 			schedule_work(&mce_trigger_work);
 
 		if (__ratelimit(&ratelimit))
-			printk(KERN_INFO "Machine check events logged\n");
+			pr_info(HW_ERR "Machine check events logged\n");
 
 		return 1;
 	}


