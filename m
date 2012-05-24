Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab2EXGBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 02:01:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:14631 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab2EXGBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 02:01:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103647327"
Message-ID: <4FBDCE4A.7050900@intel.com>
Date: Thu, 24 May 2012 13:59:38 +0800
From: ShuoX Liu <shuox.liu@intel.com>
Reply-To: shuox.liu@intel.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Borislav Petkov <bp@alien8.de>, andi@firstfloor.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v2] printk: ignore recursion_bug flag in HW error handle process
References: <4FBC444A.6060500@intel.com> <20120523100138.GA13506@x1.osrc.amd.com>
In-Reply-To: <20120523100138.GA13506@x1.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ShuoX Liu <shuox.liu@intel.com>

When MCE happens in printk, we ignore recursion_bug to make sure MCE logs printed out.

According to Boris' suggestion, we add some helper functions.
1) hw_error_enter: Call it when specific arch begins to process a hardware error.
2) hw_error_exit: Call it when specific arch finishes the processing of a hardware error.
3) in_hw_error():indicates whether HW error handling is in processing.

Each arch could call the helpers in their arch-dependent HW error handlers.

Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
---
 arch/x86/include/asm/mce.h       |    2 --
 arch/x86/kernel/cpu/mcheck/mce.c |    6 ++----
 include/linux/cpu.h              |   17 +++++++++++++++++
 kernel/cpu.c                     |    3 +++
 kernel/printk.c                  |    3 ++-
 5 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 441520e..aeda4cc 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -187,8 +187,6 @@ int mce_available(struct cpuinfo_x86 *c);
 DECLARE_PER_CPU(unsigned, mce_exception_count);
 DECLARE_PER_CPU(unsigned, mce_poll_count);
 
-extern atomic_t mce_entry;
-
 typedef DECLARE_BITMAP(mce_banks_t, MAX_NR_BANKS);
 DECLARE_PER_CPU(mce_banks_t, mce_poll_banks);
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2afcbd2..aaf41d2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -61,8 +61,6 @@ int mce_disabled __read_mostly;
 
 #define SPINUNIT 100	/* 100ns */
 
-atomic_t mce_entry;
-
 DEFINE_PER_CPU(unsigned, mce_exception_count);
 
 /*
@@ -1015,7 +1013,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	DECLARE_BITMAP(toclear, MAX_NR_BANKS);
 	char *msg = "Unknown";
 
-	atomic_inc(&mce_entry);
+	hw_error_enter();
 
 	this_cpu_inc(mce_exception_count);
 
@@ -1143,7 +1141,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		mce_report_event(regs);
 	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
 out:
-	atomic_dec(&mce_entry);
+	hw_error_exit();
 	sync_core();
 }
 EXPORT_SYMBOL_GPL(do_machine_check);
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 7230bb5..beb56d0 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -210,4 +210,21 @@ static inline int disable_nonboot_cpus(void) { return 0; }
 static inline void enable_nonboot_cpus(void) {}
 #endif /* !CONFIG_PM_SLEEP_SMP */
 
+/* HW error handle status helpers */
+extern atomic_t hw_error;
+static inline void hw_error_enter(void)
+{
+	atomic_inc(&hw_error);
+}
+
+static inline void hw_error_exit(void)
+{
+	atomic_dec(&hw_error);
+}
+
+static inline int in_hw_error(void)
+{
+	return atomic_read(&hw_error);
+}
+
 #endif /* _LINUX_CPU_H_ */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 0e6353c..54b9c1f 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -679,3 +679,6 @@ void init_cpu_online(const struct cpumask *src)
 {
 	cpumask_copy(to_cpumask(cpu_online_bits), src);
 }
+
+/* hardware error status */
+atomic_t hw_error __read_mostly = ATOMIC_INIT(0);
diff --git a/kernel/printk.c b/kernel/printk.c
index 32462d2..6f0f216 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1295,7 +1295,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 * recursion and return - but flag the recursion so that
 		 * it can be printed at the next appropriate moment:
 		 */
-		if (!oops_in_progress && !lockdep_recursing(current)) {
+		if (!oops_in_progress && !in_hw_error()
+				&& !lockdep_recursing(current)) {
 			recursion_bug = 1;
 			goto out_restore_irqs;
 		}
-- 
1.7.1
