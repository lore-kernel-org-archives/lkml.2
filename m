Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab1CKGCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 01:02:43 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50787 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab1CKGC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 01:02:27 -0500
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 2/2] tty: serial: Check UPF_FOURPORT, when CONFIG_SERIAL_8250_FOURPORT is defined
Date: Fri, 11 Mar 2011 14:54:57 +0900
Message-Id: <1299822897-7047-2-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299822897-7047-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
References: <1299822897-7047-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_SERIAL_8250_FOURPORT is defined, driver uses UPF_FOURPORT in port.flags.
Though CONFIG_SERIAL_8250_FOURPORT is not defined, there is a case to check UPF_FOURPORT.
When CONFIG_SERIAL_8250_FOURPORT is defined only, this checks UPF_FOURPORT.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
---
 drivers/tty/serial/8250.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 5c1f353..c7d8f63 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -1297,17 +1297,20 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 static void autoconfig_irq(struct uart_8250_port *up)
 {
 	unsigned char save_mcr, save_ier;
-	unsigned char save_ICP = 0;
-	unsigned int ICP = 0;
 	unsigned long irqs;
 	int irq;
 
+#ifdef CONFIG_SERIAL_8250_FOURPORT
+	unsigned char save_ICP = 0;
+	unsigned int ICP = 0;
+
 	if (up->port.flags & UPF_FOURPORT) {
 		ICP = (up->port.iobase & 0xfe0) | 0x1f;
 		save_ICP = inb_p(ICP);
 		outb_p(0x80, ICP);
 		(void) inb_p(ICP);
 	}
+#endif /* CONFIG_SERIAL_8250_FOURPORT */
 
 	/* forget possible initially masked and pending IRQ */
 	probe_irq_off(probe_irq_on());
@@ -1337,8 +1340,10 @@ static void autoconfig_irq(struct uart_8250_port *up)
 	serial_outp(up, UART_MCR, save_mcr);
 	serial_outp(up, UART_IER, save_ier);
 
+#ifdef CONFIG_SERIAL_8250_FOURPORT
 	if (up->port.flags & UPF_FOURPORT)
 		outb_p(save_ICP, ICP);
+#endif
 
 	up->port.irq = (irq > 0) ? irq : 0;
 }
@@ -2199,6 +2204,7 @@ dont_test_tx_en:
 	up->ier = UART_IER_RLSI | UART_IER_RDI;
 	serial_outp(up, UART_IER, up->ier);
 
+#ifdef CONFIG_SERIAL_8250_FOURPORT
 	if (up->port.flags & UPF_FOURPORT) {
 		unsigned int icp;
 		/*
@@ -2208,6 +2214,7 @@ dont_test_tx_en:
 		outb_p(0x80, icp);
 		(void) inb_p(icp);
 	}
+#endif
 
 	return 0;
 }
@@ -2225,11 +2232,13 @@ static void serial8250_shutdown(struct uart_port *port)
 	serial_outp(up, UART_IER, 0);
 
 	spin_lock_irqsave(&up->port.lock, flags);
+#ifdef CONFIG_SERIAL_8250_FOURPORT
 	if (up->port.flags & UPF_FOURPORT) {
 		/* reset interrupts on the AST Fourport board */
 		inb((up->port.iobase & 0xfe0) | 0x1f);
 		up->port.mctrl |= TIOCM_OUT1;
 	} else
+#endif
 		up->port.mctrl &= ~TIOCM_OUT2;
 
 	serial8250_set_mctrl(&up->port, up->port.mctrl);
-- 
1.7.2.3

