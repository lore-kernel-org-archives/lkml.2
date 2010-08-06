Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935930Ab0HFXEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 19:04:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:55039 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935897Ab0HFXC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 19:02:56 -0400
Date: Fri, 6 Aug 2010 23:02:23 GMT
Message-Id: <201008062302.o76N2N89016652@hera.kernel.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/mce for 2.6.36
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 Aug 2010 23:02:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit fc1caf6eafb30ea185720e29f7f5eccca61ecd60:

  Merge branch 'drm-core-next' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2010-08-05 16:02:01 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mce-for-linus

Huang Ying (4):
      x86, mce: Rename MSR_IA32_MCx_CTL2 value
      x86, mce: Fix MSR_IA32_MCI_CTL2 CMCI threshold setup
      x86, mce: Add HW_ERR printk prefix for hardware error logging
      x86, mce: Use HW_ERR in MCE handler

 arch/x86/include/asm/mce.h             |    4 ++++
 arch/x86/include/asm/msr-index.h       |    3 ---
 arch/x86/kernel/cpu/mcheck/mce.c       |   32 ++++++++++----------------------
 arch/x86/kernel/cpu/mcheck/mce_intel.c |    9 +++++----
 include/linux/kernel.h                 |    7 +++++++
 5 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index f32a430..c62c13c 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -38,6 +38,10 @@
 #define MCM_ADDR_MEM	 3	/* memory address */
 #define MCM_ADDR_GENERIC 7	/* generic */
 
+/* CTL2 register defines */
+#define MCI_CTL2_CMCI_EN		(1ULL << 30)
+#define MCI_CTL2_CMCI_THRESHOLD_MASK	0x7fffULL
+
 #define MCJ_CTX_MASK		3
 #define MCJ_CTX(flags)		((flags) & MCJ_CTX_MASK)
 #define MCJ_CTX_RANDOM		0    /* inject context: random */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 509a421..33184c2 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -96,9 +96,6 @@
 #define MSR_IA32_MC0_CTL2		0x00000280
 #define MSR_IA32_MCx_CTL2(x)		(MSR_IA32_MC0_CTL2 + (x))
 
-#define CMCI_EN			(1ULL << 30)
-#define CMCI_THRESHOLD_MASK		0xffffULL
-
 #define MSR_P6_PERFCTR0			0x000000c1
 #define MSR_P6_PERFCTR1			0x000000c2
 #define MSR_P6_EVNTSEL0			0x00000186
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 1970ef9..bba547d 100644
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
@@ -1221,7 +1209,7 @@ int mce_notify_irq(void)
 			schedule_work(&mce_trigger_work);
 
 		if (__ratelimit(&ratelimit))
-			printk(KERN_INFO "Machine check events logged\n");
+			pr_info(HW_ERR "Machine check events logged\n");
 
 		return 1;
 	}
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 62b48e4..6fcd093 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -95,19 +95,20 @@ static void cmci_discover(int banks, int boot)
 		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
 
 		/* Already owned by someone else? */
-		if (val & CMCI_EN) {
+		if (val & MCI_CTL2_CMCI_EN) {
 			if (test_and_clear_bit(i, owned) && !boot)
 				print_update("SHD", &hdr, i);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
 			continue;
 		}
 
-		val |= CMCI_EN | CMCI_THRESHOLD;
+		val &= ~MCI_CTL2_CMCI_THRESHOLD_MASK;
+		val |= MCI_CTL2_CMCI_EN | CMCI_THRESHOLD;
 		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
 		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
 
 		/* Did the enable bit stick? -- the bank supports CMCI */
-		if (val & CMCI_EN) {
+		if (val & MCI_CTL2_CMCI_EN) {
 			if (!test_and_set_bit(i, owned) && !boot)
 				print_update("CMCI", &hdr, i);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
@@ -155,7 +156,7 @@ void cmci_clear(void)
 			continue;
 		/* Disable CMCI */
 		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
-		val &= ~(CMCI_EN|CMCI_THRESHOLD_MASK);
+		val &= ~(MCI_CTL2_CMCI_EN|MCI_CTL2_CMCI_THRESHOLD_MASK);
 		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
 		__clear_bit(i, __get_cpu_var(mce_banks_owned));
 	}
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 5de838b..f05a468 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -252,6 +252,13 @@ extern struct pid *session_of_pgrp(struct pid *pgrp);
 #define FW_WARN		"[Firmware Warn]: "
 #define FW_INFO		"[Firmware Info]: "
 
+/*
+ * HW_ERR
+ * Add this to a message for hardware errors, so that user can report
+ * it to hardware vendor instead of LKML or software vendor.
+ */
+#define HW_ERR		"[Hardware Error]: "
+
 #ifdef CONFIG_PRINTK
 asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
