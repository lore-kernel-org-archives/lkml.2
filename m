Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab2IMSyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:54:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18988 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab2IMSyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:54:13 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=2k-WFFBCSGIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=QGzj4c7tFq0A:10 a=z6gsHLkEAAAA:8 a=VwQbUJbxAAAA:8 a=FZDVmGl77e1u4vBlhBoA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120913185411.272972861@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 13 Sep 2012 14:52:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Frank Rowand <frank.rowand@am.sony.com>
Subject: [PATCH RT 1/2] fix printk flush of messages
References: <20120913185234.912247144@goodmis.org>
Content-Disposition: inline; filename=0001-fix-printk-flush-of-messages.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Rowand <frank.rowand@am.sony.com>

Reverse preempt-rt-allow-immediate-magic-sysrq-output-for-preempt_rt_full.patch

The problem addressed by that patch does not exist after applying
console-make-rt-friendly-update.patch

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
Link: http://lkml.kernel.org/r/4FB44EF1.9050809@am.sony.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/tty/serial/cpm_uart/cpm_uart_core.c |    2 +-
 drivers/tty/sysrq.c                         |   23 -----------------------
 include/linux/sysrq.h                       |    5 -----
 kernel/printk.c                             |    5 ++---
 lib/Kconfig.debug                           |   22 ----------------------
 5 files changed, 3 insertions(+), 54 deletions(-)

diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
index 2a75c84..9488da7 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -1225,7 +1225,7 @@ static void cpm_uart_console_write(struct console *co, const char *s,
 {
 	struct uart_cpm_port *pinfo = &cpm_uart_ports[co->index];
 	unsigned long flags;
-	int nolock = oops_in_progress || sysrq_in_progress;
+	int nolock = oops_in_progress;
 
 	if (unlikely(nolock)) {
 		local_irq_save(flags);
diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 5219738..43db715 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -492,23 +492,6 @@ static void __sysrq_put_key_op(int key, struct sysrq_key_op *op_p)
                 sysrq_key_table[i] = op_p;
 }
 
-#ifdef CONFIG_MAGIC_SYSRQ_FORCE_PRINTK
-
-int sysrq_in_progress;
-
-static void set_sysrq_in_progress(int value)
-{
-	sysrq_in_progress = value;
-}
-
-#else
-
-static void set_sysrq_in_progress(int value)
-{
-}
-
-#endif
-
 void __handle_sysrq(int key, bool check_mask)
 {
 	struct sysrq_key_op *op_p;
@@ -517,9 +500,6 @@ void __handle_sysrq(int key, bool check_mask)
 	unsigned long flags;
 
 	spin_lock_irqsave(&sysrq_key_table_lock, flags);
-
-	set_sysrq_in_progress(1);
-
 	/*
 	 * Raise the apparent loglevel to maximum so that the sysrq header
 	 * is shown to provide the user with positive feedback.  We do not
@@ -561,9 +541,6 @@ void __handle_sysrq(int key, bool check_mask)
 		printk("\n");
 		console_loglevel = orig_log_level;
 	}
-
-	set_sysrq_in_progress(0);
-
 	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
 }
 
diff --git a/include/linux/sysrq.h b/include/linux/sysrq.h
index d224c0b..7faf933 100644
--- a/include/linux/sysrq.h
+++ b/include/linux/sysrq.h
@@ -38,11 +38,6 @@ struct sysrq_key_op {
 	int enable_mask;
 };
 
-#ifdef CONFIG_MAGIC_SYSRQ_FORCE_PRINTK
-extern int sysrq_in_progress;
-#else
-#define sysrq_in_progress 0
-#endif
 #ifdef CONFIG_MAGIC_SYSRQ
 
 /* Generic SysRq interface -- you may call it from any device driver, supplying
diff --git a/kernel/printk.c b/kernel/printk.c
index f2c459f..ea71fae 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -21,7 +21,6 @@
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/console.h>
-#include <linux/sysrq.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
 #include <linux/nmi.h>
@@ -834,8 +833,8 @@ static int console_trylock_for_printk(unsigned int cpu, unsigned long flags)
 	__releases(&logbuf_lock)
 {
 #ifdef CONFIG_PREEMPT_RT_FULL
-	int lock = (!early_boot_irqs_disabled && !irqs_disabled_flags(flags) &&
-		(preempt_count() <= 1)) || sysrq_in_progress;
+	int lock = !early_boot_irqs_disabled && !irqs_disabled_flags(flags) &&
+		(preempt_count() <= 1);
 #else
 	int lock = 1;
 #endif
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 383b565..1685473 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -62,28 +62,6 @@ config MAGIC_SYSRQ
 	  keys are documented in <file:Documentation/sysrq.txt>. Don't say Y
 	  unless you really know what this hack does.
 
-config MAGIC_SYSRQ_FORCE_PRINTK
-	bool "Force printk from Magic SysRq"
-	depends on MAGIC_SYSRQ && PREEMPT_RT_FULL
-	default n
-	help
-	  Allow the output from Magic SysRq to be output immediately, even if
-	  this causes large latencies.  This can cause performance problems
-	  for real-time processes.
-
-	  If PREEMPT_RT_FULL, printk() will not try to acquire the console lock
-	  when interrupts or preemption are disabled.  If the console lock is
-	  not acquired the printk() output will be buffered, but will not be
-	  output immediately.  Some drivers call into the Magic SysRq code
-	  with interrupts or preemption disabled, so the output of Magic SysRq
-	  will be buffered instead of printing immediately if this option is
-	  not selected.
-
-	  Even with this option selected, Magic SysRq output will be delayed
-	  if the attempt to acquire the console lock fails.
-
-	  Don't say Y unless you really know what this hack does.
-
 config STRIP_ASM_SYMS
 	bool "Strip assembler-generated symbols during link"
 	default n
-- 
1.7.10.4


