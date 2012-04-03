Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab2DCGV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 02:21:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36846 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab2DCGV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 02:21:26 -0400
From: "Shankarmurthy, Akshay" <akshay.s@ti.com>
To: <linux-serial@vger.kernel.org>
CC: <alan@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <paul.gortmaker@windriver.com>, <jamie@jamieiles.com>,
        <swarren@nvidia.com>, <dianders@chromium.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, <akshay.s@ti.com>,
        Chaithrika U S <chaithrika@ti.com>
Subject: [PATCH] serial: 8250: Add cpufreq support
Date: Tue, 3 Apr 2012 11:33:42 +0530
Message-ID: <1333433022-5455-1-git-send-email-akshay.s@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chaithrika U S <chaithrika@ti.com>

On DA850/OMAP-L138 SoC, the PLL which supplies the clock to CPU also
feeds the UART and the UART input frequency can change when the CPU
frequency is scaled.

This patch adds cpufreq support for 8250 serial driver. A clk structure
member has been added to the platform and port data structures.This
member is used by the cpufreq notifier callback to get the updated
clock rate. The implementation is based on the cpufreq implementation
for Samsung serial driver.

Tested on TI DA850/OMAP-L138 EVM.

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
Signed-off-by: Shankarmurthy, Akshay <akshay.s@ti.com>
---
This patch was submitted 2 years ago but didn't make it to the mainline. Now i am reposting it.

 drivers/tty/serial/8250/8250.c |   74 ++++++++++++++++++++++++++++++++++++++++
 drivers/tty/serial/8250/8250.h |    5 +++
 include/linux/serial_8250.h    |    1 +
 3 files changed, 80 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index 9b7336f..b7cfe6c 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -38,6 +38,8 @@
 #include <linux/nmi.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/cpufreq.h>
+#include <linux/clk.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -3015,6 +3017,70 @@ void serial8250_resume_port(int line)
 	uart_resume_port(&serial8250_reg, &up->port);
 }
 
+#ifdef CONFIG_CPU_FREQ
+static int serial8250_cpufreq_transition(struct notifier_block *nb,
+					     unsigned long val, void *data)
+{
+	struct uart_8250_port *p;
+	struct uart_port *uport;
+
+	p = container_of(nb, struct uart_8250_port, freq_transition);
+	uport = &p->port;
+
+	if (IS_ERR(p->clk))
+		goto cpu_freq_exit;
+
+	if (p->port.uartclk == clk_get_rate(p->clk))
+		goto cpu_freq_exit;
+
+	p->port.uartclk = clk_get_rate(p->clk);
+	if (val == CPUFREQ_POSTCHANGE) {
+		struct ktermios *termios;
+		struct tty_struct *tty;
+		if (uport->state == NULL)
+			goto cpu_freq_exit;
+
+		tty = uport->state->port.tty;
+		if (tty == NULL)
+			goto cpu_freq_exit;
+
+		termios = tty->termios;
+		if (termios == NULL) {
+			printk(KERN_WARNING "%s: no termios?\n", __func__);
+			goto cpu_freq_exit;
+		}
+
+		serial8250_set_termios(uport, termios, NULL);
+	}
+
+cpu_freq_exit:
+	return 0;
+}
+
+static inline int serial8250_cpufreq_register(struct uart_8250_port *p)
+{
+	p->freq_transition.notifier_call = serial8250_cpufreq_transition;
+
+	return cpufreq_register_notifier(&p->freq_transition,
+					 CPUFREQ_TRANSITION_NOTIFIER);
+}
+
+static inline void serial8250_cpufreq_deregister(struct uart_8250_port *p)
+{
+	cpufreq_unregister_notifier(&p->freq_transition,
+				    CPUFREQ_TRANSITION_NOTIFIER);
+}
+#else
+static inline int serial8250_cpufreq_register(struct uart_8250_port *p)
+{
+	return 0;
+}
+
+static inline void serial8250_cpufreq_deregister(struct uart_8250_port *p)
+{
+}
+#endif
+
 /*
  * Register a set of serial devices attached to a platform device.  The
  * list is terminated with a zero flags entry, which means we expect
@@ -3051,6 +3117,9 @@ static int __devinit serial8250_probe(struct platform_device *dev)
 		port.pm			= p->pm;
 		port.dev		= &dev->dev;
 		port.irqflags		|= irqflag;
+		if (p->clk)
+			serial8250_ports[i].clk = p->clk;
+
 		ret = serial8250_register_port(&port);
 		if (ret < 0) {
 			dev_err(&dev->dev, "unable to register port at index %d "
@@ -3227,6 +3296,10 @@ int serial8250_register_port(struct uart_port *port)
 		ret = uart_add_one_port(&serial8250_reg, &uart->port);
 		if (ret == 0)
 			ret = uart->port.line;
+
+		ret = serial8250_cpufreq_register(uart);
+		if (ret < 0)
+			printk(KERN_ERR "Failed to add cpufreq notifier\n");
 	}
 	mutex_unlock(&serial_mutex);
 
@@ -3246,6 +3319,7 @@ void serial8250_unregister_port(int line)
 	struct uart_8250_port *uart = &serial8250_ports[line];
 
 	mutex_lock(&serial_mutex);
+	serial8250_cpufreq_deregister(uart);
 	uart_remove_one_port(&serial8250_reg, &uart->port);
 	if (serial8250_isa_devs) {
 		uart->port.flags &= ~UPF_BOOT_AUTOCONF;
diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index ae027be..be05a03 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -37,6 +37,11 @@ struct uart_8250_port {
 	unsigned char		lsr_saved_flags;
 #define MSR_SAVE_FLAGS UART_MSR_ANY_DELTA
 	unsigned char		msr_saved_flags;
+	struct clk		*clk;
+#ifdef CONFIG_CPU_FREQ
+	struct notifier_block	freq_transition;
+#endif
+
 };
 
 struct old_serial_port {
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index 8f012f8..c2e1ce5 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -23,6 +23,7 @@ struct plat_serial8250_port {
 	resource_size_t	mapbase;	/* resource base */
 	unsigned int	irq;		/* interrupt number */
 	unsigned long	irqflags;	/* request_irq flags */
+	struct clk	*clk;
 	unsigned int	uartclk;	/* UART clock rate */
 	void            *private_data;
 	unsigned char	regshift;	/* register shift */
-- 
1.7.1

