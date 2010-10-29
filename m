Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761582Ab0J2Soj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 14:44:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:58543 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761570Ab0J2Soh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 14:44:37 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Dongdong Deng <dongdong.deng@windriver.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 5/7] debug_core,x86,blackfin: Clean up hw debug disable API
Date: Fri, 29 Oct 2010 13:43:39 -0500
Message-Id: <1288377821-24520-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1288377821-24520-1-git-send-email-jason.wessel@windriver.com>
References: <1288377821-24520-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 29 Oct 2010 18:43:51.0878 (UTC) FILETIME=[3B4CC660:01CB7799]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongdong Deng <dongdong.deng@windriver.com>

The kgdb_disable_hw_debug() was an architecture specific function for
disabling all hardware breakpoints on a per cpu basis when entering
the debug core.

This patch will remove the weak function kdbg_disable_hw_debug() and
change it into a call back which lives with the rest of hw breakpoint
call backs in struct kgdb_arch.

Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/blackfin/kernel/kgdb.c |    3 ++-
 arch/x86/kernel/kgdb.c      |    3 ++-
 include/linux/kgdb.h        |   13 +++----------
 kernel/debug/debug_core.c   |   16 +++-------------
 4 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/arch/blackfin/kernel/kgdb.c b/arch/blackfin/kernel/kgdb.c
index 08bc44e..edae461 100644
--- a/arch/blackfin/kernel/kgdb.c
+++ b/arch/blackfin/kernel/kgdb.c
@@ -320,7 +320,7 @@ static void bfin_correct_hw_break(void)
 	}
 }
 
-void kgdb_disable_hw_debug(struct pt_regs *regs)
+static void bfin_disable_hw_debug(struct pt_regs *regs)
 {
 	/* Disable hardware debugging while we are in kgdb */
 	bfin_write_WPIACTL(0);
@@ -406,6 +406,7 @@ struct kgdb_arch arch_kgdb_ops = {
 #endif
 	.set_hw_breakpoint = bfin_set_hw_break,
 	.remove_hw_breakpoint = bfin_remove_hw_break,
+	.disable_hw_break = bfin_disable_hw_debug,
 	.remove_all_hw_break = bfin_remove_all_hw_break,
 	.correct_hw_break = bfin_correct_hw_break,
 };
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index d81cfeb..ec592ca 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -387,7 +387,7 @@ kgdb_set_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
  *	disable hardware debugging while it is processing gdb packets or
  *	handling exception.
  */
-void kgdb_disable_hw_debug(struct pt_regs *regs)
+static void kgdb_disable_hw_debug(struct pt_regs *regs)
 {
 	int i;
 	int cpu = raw_smp_processor_id();
@@ -724,6 +724,7 @@ struct kgdb_arch arch_kgdb_ops = {
 	.flags			= KGDB_HW_BREAKPOINT,
 	.set_hw_breakpoint	= kgdb_set_hw_break,
 	.remove_hw_breakpoint	= kgdb_remove_hw_break,
+	.disable_hw_break	= kgdb_disable_hw_debug,
 	.remove_all_hw_break	= kgdb_remove_all_hw_break,
 	.correct_hw_break	= kgdb_correct_hw_break,
 };
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index cc96f0f..092e425 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -35,16 +35,6 @@ struct pt_regs;
  */
 extern int kgdb_skipexception(int exception, struct pt_regs *regs);
 
-/**
- *	kgdb_disable_hw_debug - (optional) Disable hardware debugging hook
- *	@regs: Current &struct pt_regs.
- *
- *	This function will be called if the particular architecture must
- *	disable hardware debugging while it is processing gdb packets or
- *	handling exception.
- */
-extern void kgdb_disable_hw_debug(struct pt_regs *regs);
-
 struct tasklet_struct;
 struct task_struct;
 struct uart_port;
@@ -243,6 +233,8 @@ extern void kgdb_arch_late(void);
  * breakpoint.
  * @remove_hw_breakpoint: Allow an architecture to specify how to remove a
  * hardware breakpoint.
+ * @disable_hw_break: Allow an architecture to specify how to disable
+ * hardware breakpoints for a single cpu.
  * @remove_all_hw_break: Allow an architecture to specify how to remove all
  * hardware breakpoints.
  * @correct_hw_break: Allow an architecture to specify how to correct the
@@ -256,6 +248,7 @@ struct kgdb_arch {
 	int	(*remove_breakpoint)(unsigned long, char *);
 	int	(*set_hw_breakpoint)(unsigned long, int, enum kgdb_bptype);
 	int	(*remove_hw_breakpoint)(unsigned long, int, enum kgdb_bptype);
+	void	(*disable_hw_break)(struct pt_regs *regs);
 	void	(*remove_all_hw_break)(void);
 	void	(*correct_hw_break)(void);
 };
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index fec596d..cefd4a1 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -209,18 +209,6 @@ int __weak kgdb_skipexception(int exception, struct pt_regs *regs)
 	return 0;
 }
 
-/**
- *	kgdb_disable_hw_debug - Disable hardware debugging while we in kgdb.
- *	@regs: Current &struct pt_regs.
- *
- *	This function will be called if the particular architecture must
- *	disable hardware debugging while it is processing gdb packets or
- *	handling exception.
- */
-void __weak kgdb_disable_hw_debug(struct pt_regs *regs)
-{
-}
-
 /*
  * Some architectures need cache flushes when we set/clear a
  * breakpoint:
@@ -484,7 +472,9 @@ static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs,
 		atomic_inc(&masters_in_kgdb);
 	else
 		atomic_inc(&slaves_in_kgdb);
-	kgdb_disable_hw_debug(ks->linux_regs);
+
+	if (arch_kgdb_ops.disable_hw_break)
+		arch_kgdb_ops.disable_hw_break(regs);
 
 acquirelock:
 	/*
-- 
1.6.3.3

