Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030335Ab2I1TCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:02:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030303Ab2I1TC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:02:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Xinyu Chen <xinyu.chen@freescale.com>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [ 171/262] tty: serial: imx: console write routing is unsafe on SMP
Date: Fri, 28 Sep 2012 11:51:40 -0700
Message-Id: <20120928183018.203575737@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xinyu Chen <xinyu.chen@freescale.com>

commit 9ec1882df244c4ee1baa692676fef5e8b0f5487d upstream.

The console feature's write routing is unsafe on SMP with
the startup/shutdown call.

There could be several consumers of the console
* the kernel printk
* the init process using /dev/kmsg to call printk to show log
* shell, which open /dev/console and write with sys_write()

The shell goes into the normal uart open/write routing,
but the other two go into the console operations.
The open routing calls imx serial startup, which will write USR1/2
register without any lock and critical with imx_console_write call.

Add a spin_lock for startup/shutdown/console_write routing.

This patch is a port from Freescale's Android kernel.

Signed-off-by: Xinyu Chen <xinyu.chen@freescale.com>
Tested-by: Dirk Behme <dirk.behme@de.bosch.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/imx.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -758,6 +758,7 @@ static int imx_startup(struct uart_port
 		}
 	}
 
+	spin_lock_irqsave(&sport->port.lock, flags);
 	/*
 	 * Finally, clear and enable interrupts
 	 */
@@ -811,7 +812,6 @@ static int imx_startup(struct uart_port
 	/*
 	 * Enable modem status interrupts
 	 */
-	spin_lock_irqsave(&sport->port.lock,flags);
 	imx_enable_ms(&sport->port);
 	spin_unlock_irqrestore(&sport->port.lock,flags);
 
@@ -841,10 +841,13 @@ static void imx_shutdown(struct uart_por
 {
 	struct imx_port *sport = (struct imx_port *)port;
 	unsigned long temp;
+	unsigned long flags;
 
+	spin_lock_irqsave(&sport->port.lock, flags);
 	temp = readl(sport->port.membase + UCR2);
 	temp &= ~(UCR2_TXEN);
 	writel(temp, sport->port.membase + UCR2);
+	spin_unlock_irqrestore(&sport->port.lock, flags);
 
 	if (USE_IRDA(sport)) {
 		struct imxuart_platform_data *pdata;
@@ -873,12 +876,14 @@ static void imx_shutdown(struct uart_por
 	 * Disable all interrupts, port and break condition.
 	 */
 
+	spin_lock_irqsave(&sport->port.lock, flags);
 	temp = readl(sport->port.membase + UCR1);
 	temp &= ~(UCR1_TXMPTYEN | UCR1_RRDYEN | UCR1_RTSDEN | UCR1_UARTEN);
 	if (USE_IRDA(sport))
 		temp &= ~(UCR1_IREN);
 
 	writel(temp, sport->port.membase + UCR1);
+	spin_unlock_irqrestore(&sport->port.lock, flags);
 }
 
 static void
@@ -1221,6 +1226,9 @@ imx_console_write(struct console *co, co
 	struct imx_port *sport = imx_ports[co->index];
 	struct imx_port_ucrs old_ucr;
 	unsigned int ucr1;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sport->port.lock, flags);
 
 	/*
 	 *	First, save UCR1/2/3 and then disable interrupts
@@ -1246,6 +1254,8 @@ imx_console_write(struct console *co, co
 	while (!(readl(sport->port.membase + USR2) & USR2_TXDC));
 
 	imx_port_ucrs_restore(&sport->port, &old_ucr);
+
+	spin_unlock_irqrestore(&sport->port.lock, flags);
 }
 
 /*


