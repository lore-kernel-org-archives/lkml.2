Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab1F0Vrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 17:47:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52288 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab1F0VqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 17:46:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-serial@vger.kernel.org
Subject: [PATCH 6/7] serial/8250: sanitize fourport handling
Date: Mon, 27 Jun 2011 23:45:19 +0200
Message-Id: <1309211120-2803-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309211120-2803-1-git-send-email-arnd@arndb.de>
References: <1309211120-2803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:fEWx5aLTeipPPSuDy1LsOysmNxHilTdxjAG5BAYTuzg
 RlxG9MvBvsQyByOw3XRmMokwF8FPCuhxdaL32v+taKIIU8RFHT
 QFK20J5EIZ+IvuBeDzmtmB9ZsVkzKF8rHmQg0W4uwbAuVEgtoQ
 /347U1aLpRnkoS1YrNkSIpqLJqlMAmMyLznMJlwwDp2dA+y7bt
 q4TIaFU+l7ii4hPtPe4JQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for AST fourport cards is always built into
the 8250 driver, even if CONFIG_SERIAL_8250_FOURPORT
is disabled. This introduces a set of macros for
accessing the special interrupt control register on
the fourport card, so that support is left out
when the option is disabled, without adding more #ifdef
lines to the driver itself.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/8250.c |   18 +++++++-----------
 drivers/tty/serial/8250.h |    8 ++++++++
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 0ddba34..2b06c27 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -995,15 +995,13 @@ static void autoconfig_irq(struct uart_8250_port *up)
 {
 	unsigned char save_mcr, save_ier;
 	unsigned char save_ICP = 0;
-	unsigned int ICP = 0;
 	unsigned long irqs;
 	int irq;
 
 	if (up->port.flags & UPF_FOURPORT) {
-		ICP = (up->port.iobase & 0xfe0) | 0x1f;
-		save_ICP = inb_p(ICP);
-		outb_p(0x80, ICP);
-		(void) inb_p(ICP);
+		save_ICP = fourport_icp_in(up);
+		fourport_icp_out(up, 0x80);
+		(void) fourport_icp_in(up);
 	}
 
 	/* forget possible initially masked and pending IRQ */
@@ -1035,7 +1033,7 @@ static void autoconfig_irq(struct uart_8250_port *up)
 	serial_outp(up, UART_IER, save_ier);
 
 	if (up->port.flags & UPF_FOURPORT)
-		outb_p(save_ICP, ICP);
+		fourport_icp_out(up, save_ICP);
 
 	up->port.irq = (irq > 0) ? irq : 0;
 }
@@ -1914,13 +1912,11 @@ dont_test_tx_en:
 	serial_outp(up, UART_IER, up->ier);
 
 	if (up->port.flags & UPF_FOURPORT) {
-		unsigned int icp;
 		/*
 		 * Enable interrupts on the AST Fourport board
 		 */
-		icp = (up->port.iobase & 0xfe0) | 0x01f;
-		outb_p(0x80, icp);
-		(void) inb_p(icp);
+		fourport_icp_out(up, 0x80);
+		(void) fourport_icp_in(up);
 	}
 
 	return 0;
@@ -1941,7 +1937,7 @@ static void serial8250_shutdown(struct uart_port *port)
 	spin_lock_irqsave(&up->port.lock, flags);
 	if (up->port.flags & UPF_FOURPORT) {
 		/* reset interrupts on the AST Fourport board */
-		inb((up->port.iobase & 0xfe0) | 0x1f);
+		(void) fourport_icp_in(up);
 		up->port.mctrl |= TIOCM_OUT1;
 	} else
 		up->port.mctrl &= ~TIOCM_OUT2;
diff --git a/drivers/tty/serial/8250.h b/drivers/tty/serial/8250.h
index 6edf4a6..1fc46fe 100644
--- a/drivers/tty/serial/8250.h
+++ b/drivers/tty/serial/8250.h
@@ -60,6 +60,14 @@ struct serial8250_config {
 #define SERIAL8250_SHARE_IRQS 0
 #endif
 
+#if defined(CONFIG_SERIAL_8250_FOURPORT) || defined(CONFIG_SERIAL_8250_FOURPORT_MODULE)
+# define fourport_icp_in(up) 	 inb_p((up->port.iobase & 0xfe0) | 0x01f)
+# define fourport_icp_out(up, v) outb_p(v, (up->port.iobase & 0xfe0) | 0x01f)
+#else
+# define fourport_icp_in(up)	 (0)
+# define fourport_icp_out(up, v) do { } while (0)
+#endif
+
 #if defined(__alpha__) && !defined(CONFIG_PCI)
 /*
  * Digital did something really horribly wrong with the OUT1 and OUT2
-- 
1.7.5.4

