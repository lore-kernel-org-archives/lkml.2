Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab1IUVdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:33:20 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:58735
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777Ab1IUVdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:33:18 -0400
X-SpamScore: 7
X-BigFish: VPS7(z5c5ozzz1202hzz8275bhz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4E7A5806.9000209@am.sony.com>
Date: Wed, 21 Sep 2011 14:32:54 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: <tglx@linutronix.de>, <linux-rt-users@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] preempt-rt: allow immediate Magic SysRq output for PREEMPT_RT_FULL
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a CONFIG option to allow the output from Magic SysRq to be output
immediately, even if this causes large latencies.

If PREEMPT_RT_FULL, printk() will not try to acquire the console lock
when interrupts or preemption are disabled.  If the console lock is
not acquired the printk() output will be buffered, but will not be
output immediately.  Some drivers call into the Magic SysRq code
with interrupts or preemption disabled, so the output of Magic SysRq
will be buffered instead of printing immediately if this option is
not selected.

Even with this option selected, Magic SysRq output will be delayed
if the attempt to acquire the console lock fails.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 drivers/tty/serial/bcm63xx_uart.c           |    2 	1 +	1 -	0 !
 drivers/tty/serial/cpm_uart/cpm_uart_core.c |    2 	1 +	1 -	0 !
 drivers/tty/serial/mfd.c                    |    2 	1 +	1 -	0 !
 drivers/tty/serial/nwpserial.c              |    2 	1 +	1 -	0 !
 drivers/tty/serial/omap-serial.c            |    2 	1 +	1 -	0 !
 drivers/tty/serial/sunhv.c                  |    4 	2 +	2 -	0 !
 drivers/tty/serial/sunsab.c                 |    2 	1 +	1 -	0 !
 drivers/tty/serial/sunsu.c                  |    2 	1 +	1 -	0 !
 drivers/tty/serial/sunzilog.c               |    2 	1 +	1 -	0 !
 drivers/tty/serial/uartlite.c               |    2 	1 +	1 -	0 !
 drivers/tty/serial/xilinx_uartps.c          |    2 	1 +	1 -	0 !
 drivers/tty/sysrq.c                         |   23 	23 +	0 -	0 !
 include/linux/kernel.h                      |    5 	5 +	0 -	0 !
 kernel/printk.c                             |    4 	2 +	2 -	0 !
 lib/Kconfig.debug                           |   22 	22 +	0 -	0 !
 15 files changed, 64 insertions(+), 14 deletions(-)

Index: b/drivers/tty/sysrq.c
===================================================================
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -492,6 +492,23 @@ static void __sysrq_put_key_op(int key, 
                 sysrq_key_table[i] = op_p;
 }
 
+#ifdef CONFIG_MAGIC_SYSRQ_FORCE_PRINTK
+
+int sysrq_in_progress;
+
+static void set_sysrq_in_progress(int value)
+{
+	sysrq_in_progress = value;
+}
+
+#else
+
+static void set_sysrq_in_progress(int value)
+{
+}
+
+#endif
+
 void __handle_sysrq(int key, bool check_mask)
 {
 	struct sysrq_key_op *op_p;
@@ -500,6 +517,9 @@ void __handle_sysrq(int key, bool check_
 	unsigned long flags;
 
 	spin_lock_irqsave(&sysrq_key_table_lock, flags);
+
+	set_sysrq_in_progress(1);
+
 	/*
 	 * Raise the apparent loglevel to maximum so that the sysrq header
 	 * is shown to provide the user with positive feedback.  We do not
@@ -541,6 +561,9 @@ void __handle_sysrq(int key, bool check_
 		printk("\n");
 		console_loglevel = orig_log_level;
 	}
+
+	set_sysrq_in_progress(0);
+
 	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
 }
 
Index: b/include/linux/kernel.h
===================================================================
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -327,6 +327,11 @@ unsigned long int_sqrt(unsigned long);
 extern void bust_spinlocks(int yes);
 extern void wake_up_klogd(void);
 extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in progress */
+#ifdef CONFIG_MAGIC_SYSRQ_FORCE_PRINTK
+extern int sysrq_in_progress;
+#else
+#define sysrq_in_progress 0
+#endif
 extern int panic_timeout;
 extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
Index: b/kernel/printk.c
===================================================================
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -831,8 +831,8 @@ static int console_trylock_for_printk(un
 	__releases(&logbuf_lock)
 {
 #ifdef CONFIG_PREEMPT_RT_FULL
-	int lock = !early_boot_irqs_disabled && !irqs_disabled_flags(flags) &&
-		!preempt_count();
+	int lock = (!early_boot_irqs_disabled && !irqs_disabled_flags(flags) &&
+		!preempt_count()) || sysrq_in_progress;
 #else
 	int lock = 1;
 #endif
Index: b/drivers/tty/serial/bcm63xx_uart.c
===================================================================
--- a/drivers/tty/serial/bcm63xx_uart.c
+++ b/drivers/tty/serial/bcm63xx_uart.c
@@ -722,7 +722,7 @@ static void bcm_console_write(struct con
 	if (port->sysrq) {
 		/* bcm_uart_interrupt() already took the lock */
 		locked = 0;
-	} else if (oops_in_progress) {
+	} else if (oops_in_progress || sysrq_in_progress) {
 		locked = spin_trylock(&port->lock);
 	} else {
 		spin_lock(&port->lock);
Index: b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
===================================================================
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -1225,7 +1225,7 @@ static void cpm_uart_console_write(struc
 {
 	struct uart_cpm_port *pinfo = &cpm_uart_ports[co->index];
 	unsigned long flags;
-	int nolock = oops_in_progress;
+	int nolock = oops_in_progress || sysrq_in_progress;
 
 	if (unlikely(nolock)) {
 		local_irq_save(flags);
Index: b/drivers/tty/serial/mfd.c
===================================================================
--- a/drivers/tty/serial/mfd.c
+++ b/drivers/tty/serial/mfd.c
@@ -1118,7 +1118,7 @@ serial_hsu_console_write(struct console 
 	local_irq_save(flags);
 	if (up->port.sysrq)
 		locked = 0;
-	else if (oops_in_progress) {
+	else if (oops_in_progress || sysrq_in_progress) {
 		locked = spin_trylock(&up->port.lock);
 	} else
 		spin_lock(&up->port.lock);
Index: b/drivers/tty/serial/nwpserial.c
===================================================================
--- a/drivers/tty/serial/nwpserial.c
+++ b/drivers/tty/serial/nwpserial.c
@@ -70,7 +70,7 @@ nwpserial_console_write(struct console *
 	unsigned long flags;
 	int locked = 1;
 
-	if (oops_in_progress)
+	if (oops_in_progress || sysrq_in_progress)
 		locked = spin_trylock_irqsave(&up->port.lock, flags);
 	else
 		spin_lock_irqsave(&up->port.lock, flags);
Index: b/drivers/tty/serial/omap-serial.c
===================================================================
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -949,7 +949,7 @@ serial_omap_console_write(struct console
 
 	if (up->port.sysrq)
 		locked = 0;
-	else if (oops_in_progress)
+	else if (oops_in_progress || sysrq_in_progress)
 		locked = spin_trylock_irqsave(&up->port.lock, flags);
 	else
 		spin_lock_irqsave(&up->port.lock, flags);
Index: b/drivers/tty/serial/sunhv.c
===================================================================
--- a/drivers/tty/serial/sunhv.c
+++ b/drivers/tty/serial/sunhv.c
@@ -435,7 +435,7 @@ static void sunhv_console_write_paged(st
 	local_irq_save(flags);
 	if (port->sysrq) {
 		locked = 0;
-	} else if (oops_in_progress) {
+	} else if (oops_in_progress || sysrq_in_progress) {
 		locked = spin_trylock(&port->lock);
 	} else
 		spin_lock(&port->lock);
@@ -494,7 +494,7 @@ static void sunhv_console_write_bychar(s
 	local_irq_save(flags);
 	if (port->sysrq) {
 		locked = 0;
-	} else if (oops_in_progress) {
+	} else if (oops_in_progress || sysrq_in_progress) {
 		locked = spin_trylock(&port->lock);
 	} else
 		spin_lock(&port->lock);
Index: b/drivers/tty/serial/sunsab.c
===================================================================
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -852,7 +852,7 @@ static void sunsab_console_write(struct 
 	local_irq_save(flags);
 	if (up->port.sysrq) {
 		locked = 0;
-	} else if (oops_in_progress) {
+	} else if (oops_in_progress || sysrq_in_progress) {
 		locked = spin_trylock(&up->port.lock);
 	} else
 		spin_lock(&up->port.lock);
Index: b/drivers/tty/serial/sunsu.c
===================================================================
--- a/drivers/tty/serial/sunsu.c
+++ b/drivers/tty/serial/sunsu.c
@@ -1297,7 +1297,7 @@ static void sunsu_console_write(struct c
 	local_irq_save(flags);
 	if (up->port.sysrq) {
 		locked = 0;
-	} else if (oops_in_progress) {
+	} else if (oops_in_progress || sysrq_in_progress) {
 		locked = spin_trylock(&up->port.lock);
 	} else
 		spin_lock(&up->port.lock);
Index: b/drivers/tty/serial/sunzilog.c
===================================================================
--- a/drivers/tty/serial/sunzilog.c
+++ b/drivers/tty/serial/sunzilog.c
@@ -1204,7 +1204,7 @@ sunzilog_console_write(struct console *c
 	local_irq_save(flags);
 	if (up->port.sysrq) {
 		locked = 0;
-	} else if (oops_in_progress) {
+	} else if (oops_in_progress || sysrq_in_progress) {
 		locked = spin_trylock(&up->port.lock);
 	} else
 		spin_lock(&up->port.lock);
Index: b/drivers/tty/serial/uartlite.c
===================================================================
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -387,7 +387,7 @@ static void ulite_console_write(struct c
 	unsigned int ier;
 	int locked = 1;
 
-	if (oops_in_progress) {
+	if (oops_in_progress || sysrq_in_progress) {
 		locked = spin_trylock_irqsave(&port->lock, flags);
 	} else
 		spin_lock_irqsave(&port->lock, flags);
Index: b/drivers/tty/serial/xilinx_uartps.c
===================================================================
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -834,7 +834,7 @@ static void xuartps_console_write(struct
 	unsigned int imr;
 	int locked = 1;
 
-	if (oops_in_progress)
+	if (oops_in_progress || sysrq_in_progress)
 		locked = spin_trylock_irqsave(&port->lock, flags);
 	else
 		spin_lock_irqsave(&port->lock, flags);
Index: b/lib/Kconfig.debug
===================================================================
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -62,6 +62,28 @@ config MAGIC_SYSRQ
 	  keys are documented in <file:Documentation/sysrq.txt>. Don't say Y
 	  unless you really know what this hack does.
 
+config MAGIC_SYSRQ_FORCE_PRINTK
+	bool "Force printk from Magic SysRq"
+	depends on MAGIC_SYSRQ && PREEMPT_RT_FULL
+	default n
+	help
+	  Allow the output from Magic SysRq to be output immediately, even if
+	  this causes large latencies.  This can cause performance problems
+	  for real-time processes.
+
+	  If PREEMPT_RT_FULL, printk() will not try to acquire the console lock
+	  when interrupts or preemption are disabled.  If the console lock is
+	  not acquired the printk() output will be buffered, but will not be
+	  output immediately.  Some drivers call into the Magic SysRq code
+	  with interrupts or preemption disabled, so the output of Magic SysRq
+	  will be buffered instead of printing immediately if this option is
+	  not selected.
+
+	  Even with this option selected, Magic SysRq output will be delayed
+	  if the attempt to acquire the console lock fails.
+
+	  Don't say Y unless you really know what this hack does.
+
 config STRIP_ASM_SYMS
 	bool "Strip assembler-generated symbols during link"
 	default n

