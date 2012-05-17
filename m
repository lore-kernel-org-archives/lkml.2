Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360Ab2EQBGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 21:06:17 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:16028
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755145Ab2EQBGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 21:06:15 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2fh2a8h668h839hd25h)
X-Forefront-Antispam-Report: CIP:160.33.194.230;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail03v.am.sony.com;RD:mail03.sonyusa.com;EFVD:NLI
Message-ID: <4FB44EF1.9050809@am.sony.com>
Date: Wed, 16 May 2012 18:05:53 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Subject: [PATCH RT 1/2] fix printk flush of messages
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reverse preempt-rt-allow-immediate-magic-sysrq-output-for-preempt_rt_full.patch

The problem addressed by that patch does not exist after applying
console-make-rt-friendly-update.patch

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>

---
 drivers/tty/serial/cpm_uart/cpm_uart_core.c |    2 	1 +	1 -	0 !
 drivers/tty/sysrq.c                         |   23 	0 +	23 -	0 !
 include/linux/sysrq.h                       |    5 	0 +	5 -	0 !
 kernel/printk.c                             |    5 	2 +	3 -	0 !
 lib/Kconfig.debug                           |   22 	0 +	22 -	0 !
 5 files changed, 3 insertions(+), 54 deletions(-)

Index: b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
===================================================================
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -1226,7 +1226,7 @@ static void cpm_uart_console_write(struc
 {
 	struct uart_cpm_port *pinfo = &cpm_uart_ports[co->index];
 	unsigned long flags;
-	int nolock = oops_in_progress || sysrq_in_progress;
+	int nolock = oops_in_progress;
 
 	if (unlikely(nolock)) {
 		local_irq_save(flags);
Index: b/drivers/tty/sysrq.c
===================================================================
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -495,23 +495,6 @@ static void __sysrq_put_key_op(int key, 
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
@@ -520,9 +503,6 @@ void __handle_sysrq(int key, bool check_
 	unsigned long flags;
 
 	spin_lock_irqsave(&sysrq_key_table_lock, flags);
-
-	set_sysrq_in_progress(1);
-
 	/*
 	 * Raise the apparent loglevel to maximum so that the sysrq header
 	 * is shown to provide the user with positive feedback.  We do not
@@ -564,9 +544,6 @@ void __handle_sysrq(int key, bool check_
 		printk("\n");
 		console_loglevel = orig_log_level;
 	}
-
-	set_sysrq_in_progress(0);
-
 	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
 }
 
Index: b/include/linux/sysrq.h
===================================================================
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
Index: b/kernel/printk.c
===================================================================
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
@@ -847,8 +846,8 @@ static int console_trylock_for_printk(un
 {
 	int retval = 0, wake = 0;
 #ifdef CONFIG_PREEMPT_RT_FULL
-	int lock = (!early_boot_irqs_disabled && !irqs_disabled_flags(flags) &&
-		!preempt_count()) || sysrq_in_progress;
+	int lock = !early_boot_irqs_disabled && !irqs_disabled_flags(flags) &&
+		!preempt_count();
 #else
 	int lock = 1;
 #endif
Index: b/lib/Kconfig.debug
===================================================================
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

