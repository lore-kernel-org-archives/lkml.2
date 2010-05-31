Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab0EaLZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 07:25:20 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37685 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab0EaLZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 07:25:18 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Graf Yang <graf.yang@analog.com>
Subject: [PATCH 1/2] serial: bfin_5xx: IRDA is not affected by anomaly 05000230
Date: Mon, 31 May 2010 07:29:31 -0400
Message-Id: <1275305372-20523-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Anomaly 05000230 (over sampling of the UART STOP bit) applies only when
the peripheral is operating in UART mode.  So drop the anomaly handling
when the UART is in IRDA mode.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/bfin_5xx.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 96f7e74..a78652b 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -869,7 +869,12 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
 	}
 
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16);
-	quot = uart_get_divisor(port, baud) - ANOMALY_05000230;
+	quot = uart_get_divisor(port, baud);
+
+	/* If discipline is not IRDA, apply ANOMALY_05000230 */
+	if (termios->c_line != N_IRDA)
+		quot -= ANOMALY_05000230;
+
 	spin_lock_irqsave(&uart->port.lock, flags);
 
 	UART_SET_ANOMALY_THRESHOLD(uart, USEC_PER_SEC / baud * 15);
-- 
1.7.1

