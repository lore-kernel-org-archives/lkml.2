Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab2ARKEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:04:25 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:57555 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757284Ab2ARKEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:04:23 -0500
Date: Wed, 18 Jan 2012 15:34:11 +0530
From: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
To: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amba-pl011: clear previous interrupts before
 request_irq
Message-ID: <20120118100410.GB889@bnru02.bnr.st.com>
References: <1326796493-16080-1-git-send-email-shreshthakumar.sahu@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1326796493-16080-1-git-send-email-shreshthakumar.sahu@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 0742fc49405b2a6f562981f61d93198e1595f30d Mon Sep 17 00:00:00 2001
From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Date: Tue, 17 Jan 2012 12:23:19 +0530
Subject: [PATCH v2] amba-pl011: clear previous interrupts before request_irq

All previous interrupts should be cleared before installing
interrupt handler i.e. before request_irq. pl011_shutdown
clears the interrupt register but there may be case where
bootloader transfers control to kernel and there are some
pending interrupts. In this case interrupt handler will get
called even before interrupt mask is enabled.

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

