Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab2AQKf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 05:35:29 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:50235 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960Ab2AQKfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 05:35:24 -0500
From: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
To: <gregkh@suse.de>, <linux-serial@vger.kernel.org>,
        <rmk+kernel@arm.linux.org.uk>
Cc: <linux-kernel@vger.kernel.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Subject: [PATCH] amba-pl011: clear previous interrupts before request_irq
Date: Tue, 17 Jan 2012 16:04:53 +0530
Message-ID: <1326796493-16080-1-git-send-email-shreshthakumar.sahu@stericsson.com>
X-Mailer: git-send-email 1.7.4.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>

All previous interrupts should be cleared before installing
interrupt handler i.e. before request_irq. pl011_shutdown
clears the interrupt register but there may be case where
bootloader transfers control to kernel and there are some
pending interrupts. In this case interrupt handler will get
called even before interrupt mask is enabled.

Change-Id: Ie58ca0a36dec76ac38babc057ce1d66b3129d8f9
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/tty/serial/amba-pl011.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 6958594..6dafaa2 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1381,6 +1381,15 @@ static int pl011_startup(struct uart_port *port)
 	uap->port.uartclk = clk_get_rate(uap->clk);
 
 	/*
+	 * Clear previous interrupts before installing interrupt handler
+	 */
+	spin_lock_irq(&uap->port.lock);
+	uap->im = 0;
+	writew(uap->im, uap->port.membase + UART011_IMSC);
+	writew(0xffff, uap->port.membase + UART011_ICR);
+	spin_unlock_irq(&uap->port.lock);
+
+	/*
 	 * Allocate the IRQ
 	 */
 	retval = request_irq(uap->port.irq, pl011_int, 0, "uart-pl011", uap);
-- 
1.7.4.3

