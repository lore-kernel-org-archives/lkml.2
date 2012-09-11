Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab2IKJiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 05:38:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60311 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140Ab2IKJiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 05:38:17 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: [PATCH 07/12] tty/serial/amba-pl011: Implement clear_irqs callback
Date: Tue, 11 Sep 2012 02:35:01 -0700
Message-Id: <1347356106-25368-7-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <20120911093042.GA12471@lizard>
References: <20120911093042.GA12471@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's all pretty straightforward, except for TXIM interrupt. The interrupt
has meaning "ready to transmit", so it's almost always raised, and the
only way to silence it is to mask it. But that's OK, ops->start_tx will
unmask it.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/tty/serial/amba-pl011.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 45137e4..ec15312 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1307,6 +1307,27 @@ static void pl011_put_poll_char(struct uart_port *port,
 	writew(ch, uap->port.membase + UART01x_DR);
 }
 
+static void pl011_clear_irqs(struct uart_port *port)
+{
+	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	unsigned char __iomem *regs = uap->port.membase;
+
+	writew(readw(regs + UART011_MIS), regs + UART011_ICR);
+	/*
+	 * There is no way to clear TXIM as this is "ready to transmit IRQ", so
+	 * we simply mask it. start_tx() will unmask it.
+	 *
+	 * Note we can race with start_tx(), and if the race happens, the
+	 * clear_irq() caller might get another interrupt just after we clear
+	 * it.  But it should be OK and can happen even w/o the race, e.g.
+	 * controller immediately got some new data and raised the IRQ.
+	 *
+	 * And whoever calls clear_irqs() assumes that the caller manages the
+	 * device (including tx queue), so we're also fine with start_tx()'s
+	 * caller side.
+	 */
+	writew(readw(regs + UART011_IMSC) & ~UART011_TXIM, regs + UART011_IMSC);
+}
 #endif /* CONFIG_CONSOLE_POLL */
 
 static int pl011_hwinit(struct uart_port *port)
@@ -1712,6 +1733,7 @@ static struct uart_ops amba_pl011_pops = {
 	.poll_init     = pl011_hwinit,
 	.poll_get_char = pl011_get_poll_char,
 	.poll_put_char = pl011_put_poll_char,
+	.clear_irqs    = pl011_clear_irqs,
 #endif
 };
 
-- 
1.7.11.5

