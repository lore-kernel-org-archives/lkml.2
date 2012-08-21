Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab2HUJUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:20:41 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:40746 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755461Ab2HUJU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:20:29 -0400
From: Felipe Balbi <balbi@ti.com>
To: alan@linux.intel.com
Cc: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [RFC/PATCH 10/13] serial: omap: stick to put_autosuspend
Date: Tue, 21 Aug 2012 12:15:52 +0300
Message-Id: <1345540555-24359-11-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345540555-24359-1-git-send-email-balbi@ti.com>
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Everytime we're done using our TTY, we want
the pm timer to be reinitilized. By sticking
to pm_runtime_pm_autosuspend() we make sure
that this will always be the case.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 6ea24c5..458d77c 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -164,7 +164,8 @@ static void serial_omap_enable_ms(struct uart_port *port)
 	pm_runtime_get_sync(up->dev);
 	up->ier |= UART_IER_MSI;
 	serial_out(up, UART_IER, up->ier);
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 }
 
 static void serial_omap_stop_tx(struct uart_port *port)
@@ -412,7 +413,8 @@ static unsigned int serial_omap_tx_empty(struct uart_port *port)
 	spin_lock_irqsave(&up->port.lock, flags);
 	ret = serial_in(up, UART_LSR) & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
 	spin_unlock_irqrestore(&up->port.lock, flags);
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 	return ret;
 }
 
@@ -424,7 +426,8 @@ static unsigned int serial_omap_get_mctrl(struct uart_port *port)
 
 	pm_runtime_get_sync(up->dev);
 	status = check_modem_status(up);
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 
 	dev_dbg(up->port.dev, "serial_omap_get_mctrl+%d\n", up->port.line);
 
@@ -460,7 +463,8 @@ static void serial_omap_set_mctrl(struct uart_port *port, unsigned int mctrl)
 	up->mcr = serial_in(up, UART_MCR);
 	up->mcr |= mcr;
 	serial_out(up, UART_MCR, up->mcr);
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 }
 
 static void serial_omap_break_ctl(struct uart_port *port, int break_state)
@@ -477,7 +481,8 @@ static void serial_omap_break_ctl(struct uart_port *port, int break_state)
 		up->lcr &= ~UART_LCR_SBC;
 	serial_out(up, UART_LCR, up->lcr);
 	spin_unlock_irqrestore(&up->port.lock, flags);
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 }
 
 static int serial_omap_startup(struct uart_port *port)
@@ -575,7 +580,8 @@ static void serial_omap_shutdown(struct uart_port *port)
 	if (serial_in(up, UART_LSR) & UART_LSR_DR)
 		(void) serial_in(up, UART_RX);
 
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 	free_irq(up->port.irq, up);
 }
 
@@ -846,7 +852,8 @@ serial_omap_set_termios(struct uart_port *port, struct ktermios *termios,
 	serial_omap_configure_xonxoff(up, termios);
 
 	spin_unlock_irqrestore(&up->port.lock, flags);
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 	dev_dbg(up->port.dev, "serial_omap_set_termios+%d\n", up->port.line);
 }
 
@@ -877,7 +884,8 @@ serial_omap_pm(struct uart_port *port, unsigned int state,
 			pm_runtime_allow(up->dev);
 	}
 
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 }
 
 static void serial_omap_release_port(struct uart_port *port)
@@ -959,7 +967,8 @@ static void serial_omap_poll_put_char(struct uart_port *port, unsigned char ch)
 	pm_runtime_get_sync(up->dev);
 	wait_for_xmitr(up);
 	serial_out(up, UART_TX, ch);
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 }
 
 static int serial_omap_poll_get_char(struct uart_port *port)
@@ -973,7 +982,8 @@ static int serial_omap_poll_get_char(struct uart_port *port)
 		return NO_POLL_CHAR;
 
 	status = serial_in(up, UART_RX);
-	pm_runtime_put(up->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 	return status;
 }
 
@@ -1305,7 +1315,8 @@ static int serial_omap_probe(struct platform_device *pdev)
 	if (ret != 0)
 		goto err_add_port;
 
-	pm_runtime_put(&pdev->dev);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
 	platform_set_drvdata(pdev, up);
 	return 0;
 
-- 
1.7.12.rc3

