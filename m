Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab2HTOxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:53:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44536 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab2HTOuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:50:12 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 07/12] tty/serial/amba-pl011: Implement clear_irqs callback
Date: Mon, 20 Aug 2012 07:47:25 -0700
Message-Id: <1345474050-8339-7-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <20120820144449.GA32560@lizard>
References: <20120820144449.GA32560@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's all pretty straightforward, except for TXIM interrupt. The interrupt
has meaning "ready to transmit", so it's almost always raised, and the
only way to silence it is to mask it. But that's OK, ops->start_tx will
unmask it.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/tty/serial/amba-pl011.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 90f2302..cf9278c 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1308,6 +1308,18 @@ static void pl010_put_poll_char(struct uart_port *port,
 	writew(ch, uap->port.membase + UART01x_DR);
 }
 
+static void pl010_clear_irqs(struct uart_port *port)
+{
+	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	unsigned char __iomem *regs = uap->port.membase;
+
+	writew(readw(regs + UART011_MIS), regs + UART011_ICR);
+	/*
+	 * There is no way to clear TXIM, this is "ready to transmit IRQ", so
+	 * we simply mask it. ops->start_tx will unmask it.
+	 */
+	writew(readw(regs + UART011_IMSC) & ~UART011_TXIM, regs + UART011_IMSC);
+}
 #endif /* CONFIG_CONSOLE_POLL */
 
 static int pl011_hwinit(struct uart_port *port)
@@ -1721,6 +1733,7 @@ static struct uart_ops amba_pl011_pops = {
 	.poll_init	= pl011_hwinit,
 	.poll_get_char = pl010_get_poll_char,
 	.poll_put_char = pl010_put_poll_char,
+	.clear_irqs    = pl010_clear_irqs,
 #endif
 };
 
-- 
1.7.11.5

