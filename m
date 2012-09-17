Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab2IQBX0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:23:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33539 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752921Ab2IQAt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:59 -0400
Message-Id: <20120917003641.451592910@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:15 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Xinyu Chen <xinyu.chen@freescale.com>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 110/135] tty: serial: imx: console write routing is unsafe on SMP
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/imx.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -725,6 +725,7 @@ static int imx_startup(struct uart_port
 		}
 	}
 
+	spin_lock_irqsave(&sport->port.lock, flags);
 	/*
 	 * Finally, clear and enable interrupts
 	 */
@@ -778,7 +779,6 @@ static int imx_startup(struct uart_port
 	/*
 	 * Enable modem status interrupts
 	 */
-	spin_lock_irqsave(&sport->port.lock,flags);
 	imx_enable_ms(&sport->port);
 	spin_unlock_irqrestore(&sport->port.lock,flags);
 
@@ -808,10 +808,13 @@ static void imx_shutdown(struct uart_por
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
@@ -840,12 +843,14 @@ static void imx_shutdown(struct uart_por
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
@@ -1119,6 +1124,9 @@ imx_console_write(struct console *co, co
 {
 	struct imx_port *sport = imx_ports[co->index];
 	unsigned int old_ucr1, old_ucr2, ucr1;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sport->port.lock, flags);
 
 	/*
 	 *	First, save UCR1/2 and then disable interrupts
@@ -1145,6 +1153,8 @@ imx_console_write(struct console *co, co
 
 	writel(old_ucr1, sport->port.membase + UCR1);
 	writel(old_ucr2, sport->port.membase + UCR2);
+
+	spin_unlock_irqrestore(&sport->port.lock, flags);
 }
 
 /*


