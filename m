Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab0JVSeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:34:19 -0400
Received: from kroah.org ([198.145.64.141]:37709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758791Ab0JVSYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:24:25 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Manuel Lauss <manuel.lauss@googlemail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 42/49] 8250: allow platforms to override PM hook.
Date: Fri, 22 Oct 2010 11:21:21 -0700
Message-Id: <1287771688-14805-42-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manuel Lauss <manuel.lauss@googlemail.com>

Add a hook for platforms to specify custom pm methods.

Signed-off-by: Manuel Lauss <manuel.lauss@googlemail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250.c       |   27 ++++++++++++++++-----------
 include/linux/serial_8250.h |    4 ++++
 include/linux/serial_core.h |    2 ++
 3 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index b586406..6994afb 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -154,12 +154,6 @@ struct uart_8250_port {
 	unsigned char		lsr_saved_flags;
 #define MSR_SAVE_FLAGS UART_MSR_ANY_DELTA
 	unsigned char		msr_saved_flags;
-
-	/*
-	 * We provide a per-port pm hook.
-	 */
-	void			(*pm)(struct uart_port *port,
-				      unsigned int state, unsigned int old);
 };
 
 struct irq_info {
@@ -2436,16 +2430,24 @@ serial8250_set_ldisc(struct uart_port *port, int new)
 		port->flags &= ~UPF_HARDPPS_CD;
 }
 
-static void
-serial8250_pm(struct uart_port *port, unsigned int state,
-	      unsigned int oldstate)
+
+void serial8250_do_pm(struct uart_port *port, unsigned int state,
+		      unsigned int oldstate)
 {
 	struct uart_8250_port *p = (struct uart_8250_port *)port;
 
 	serial8250_set_sleep(p, state != 0);
+}
+EXPORT_SYMBOL(serial8250_do_pm);
 
-	if (p->pm)
-		p->pm(port, state, oldstate);
+static void
+serial8250_pm(struct uart_port *port, unsigned int state,
+	      unsigned int oldstate)
+{
+	if (port->pm)
+		port->pm(port, state, oldstate);
+	else
+		serial8250_do_pm(port, state, oldstate);
 }
 
 static unsigned int serial8250_port_size(struct uart_8250_port *pt)
@@ -3006,6 +3008,7 @@ static int __devinit serial8250_probe(struct platform_device *dev)
 		port.serial_in		= p->serial_in;
 		port.serial_out		= p->serial_out;
 		port.set_termios	= p->set_termios;
+		port.pm			= p->pm;
 		port.dev		= &dev->dev;
 		port.irqflags		|= irqflag;
 		ret = serial8250_register_port(&port);
@@ -3172,6 +3175,8 @@ int serial8250_register_port(struct uart_port *port)
 		/*  Possibly override set_termios call */
 		if (port->set_termios)
 			uart->port.set_termios = port->set_termios;
+		if (port->pm)
+			uart->port.pm = port->pm;
 
 		ret = uart_add_one_port(&serial8250_reg, &uart->port);
 		if (ret == 0)
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index 7638dea..bf9c2bd 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -35,6 +35,8 @@ struct plat_serial8250_port {
 	void		(*set_termios)(struct uart_port *,
 			               struct ktermios *new,
 			               struct ktermios *old);
+	void		(*pm)(struct uart_port *, unsigned int state,
+			      unsigned old);
 };
 
 /*
@@ -76,5 +78,7 @@ extern int serial8250_find_port_for_earlycon(void);
 extern int setup_early_serial8250_console(char *cmdline);
 extern void serial8250_do_set_termios(struct uart_port *port,
 		struct ktermios *termios, struct ktermios *old);
+extern void serial8250_do_pm(struct uart_port *port, unsigned int state,
+			     unsigned int oldstate);
 
 #endif
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index ac48082..99e5994 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -289,6 +289,8 @@ struct uart_port {
 	void			(*set_termios)(struct uart_port *,
 				               struct ktermios *new,
 				               struct ktermios *old);
+	void			(*pm)(struct uart_port *, unsigned int state,
+				      unsigned int old);
 	unsigned int		irq;			/* irq number */
 	unsigned long		irqflags;		/* irq flags  */
 	unsigned int		uartclk;		/* base uart clock */
-- 
1.7.2

