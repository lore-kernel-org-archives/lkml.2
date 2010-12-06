Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab0LFPBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:01:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:50420 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab0LFPBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:01:17 -0500
Date: Mon, 6 Dec 2010 15:00:59 GMT
From: tip-bot for Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dirk.brandewie@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dirk.brandewie@gmail.com, tglx@linutronix.de
In-Reply-To: <1290436128-17958-1-git-send-email-dirk.brandewie@gmail.com>
References: <1290436128-17958-1-git-send-email-dirk.brandewie@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] ce4100: Add errata fixes for UART on CE4100
Message-ID: <tip-5ec6960f6f0c7be9cc6e5506fdf0070add3b6e08@git.kernel.org>
Git-Commit-ID: 5ec6960f6f0c7be9cc6e5506fdf0070add3b6e08
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 15:00:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ec6960f6f0c7be9cc6e5506fdf0070add3b6e08
Gitweb:     http://git.kernel.org/tip/5ec6960f6f0c7be9cc6e5506fdf0070add3b6e08
Author:     Dirk Brandewie <dirk.brandewie@gmail.com>
AuthorDate: Mon, 22 Nov 2010 06:28:48 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 6 Dec 2010 15:58:26 +0100

ce4100: Add errata fixes for UART on CE4100

This patch enables the UART on the CE4100. The UART has a couple of
issues that need to be worked around. First the UART is mostly PC
compatible except that it is clocked eight times faster than a
standard PC so the default configuration provided in
arch/x86/include/asm/serial.h needs to be overridden. Second the TX
interrupt may not be set correctly all the time. Lastly accessing the
UART via I/O space for early_prink() hangs the chip when the IOAPIC is
enabled.

A custom mem_serial_in() is provided to work around the TX interrupt
issue. The configuration issues are dealt with in the call back
registered with the 8250 driver via serial8250_set_isa_configurator()

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
LKML-Reference: <1290436128-17958-1-git-send-email-dirk.brandewie@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/platform/ce4100/ce4100.c |   94 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 92 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index 0ede12b..d2c0d51 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -12,20 +12,110 @@
 #include <linux/kernel.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/serial_reg.h>
+#include <linux/serial_8250.h>
 
 #include <asm/setup.h>
+#include <asm/io.h>
 
 static int ce4100_i8042_detect(void)
 {
 	return 0;
 }
 
-static void __init sdv_arch_setup(void)
+static void __init sdv_find_smp_config(void)
 {
 }
 
-static void __init sdv_find_smp_config(void)
+#ifdef CONFIG_SERIAL_8250
+
+
+static unsigned int mem_serial_in(struct uart_port *p, int offset)
+{
+	offset = offset << p->regshift;
+	return readl(p->membase + offset);
+}
+
+/*
+ * The UART Tx interrupts are not set under some conditions and therefore serial
+ * transmission hangs. This is a silicon issue and has not been root caused. The
+ * workaround for this silicon issue checks UART_LSR_THRE bit and UART_LSR_TEMT
+ * bit of LSR register in interrupt handler to see whether at least one of these
+ * two bits is set, if so then process the transmit request. If this workaround
+ * is not applied, then the serial transmission may hang. This workaround is for
+ * errata number 9 in Errata - B step.
+*/
+
+static unsigned int ce4100_mem_serial_in(struct uart_port *p, int offset)
+{
+	unsigned int ret, ier, lsr;
+
+	if (offset == UART_IIR) {
+		offset = offset << p->regshift;
+		ret = readl(p->membase + offset);
+		if (ret & UART_IIR_NO_INT) {
+			/* see if the TX interrupt should have really set */
+			ier = mem_serial_in(p, UART_IER);
+			/* see if the UART's XMIT interrupt is enabled */
+			if (ier & UART_IER_THRI) {
+				lsr = mem_serial_in(p, UART_LSR);
+				/* now check to see if the UART should be
+				   generating an interrupt (but isn't) */
+				if (lsr & (UART_LSR_THRE | UART_LSR_TEMT))
+					ret &= ~UART_IIR_NO_INT;
+			}
+		}
+	} else
+		ret =  mem_serial_in(p, offset);
+	return ret;
+}
+
+static void ce4100_mem_serial_out(struct uart_port *p, int offset, int value)
+{
+	offset = offset << p->regshift;
+	writel(value, p->membase + offset);
+}
+
+static void ce4100_serial_fixup(int port, struct uart_port *up,
+	unsigned short *capabilites)
+{
+#ifdef CONFIG_EARLY_PRINTK
+	/*
+	 * Over ride the legacy port configuration that comes from
+	 * asm/serial.h. Using the ioport driver then switching to the
+	 * PCI memmaped driver hangs the IOAPIC
+	 */
+	if (up->iotype !=  UPIO_MEM32) {
+		up->uartclk  = 14745600;
+		up->mapbase = 0xdffe0200;
+		set_fixmap_nocache(FIX_EARLYCON_MEM_BASE,
+				up->mapbase & PAGE_MASK);
+		up->membase =
+			(void __iomem *)__fix_to_virt(FIX_EARLYCON_MEM_BASE);
+		up->membase += up->mapbase & ~PAGE_MASK;
+		up->iotype   = UPIO_MEM32;
+		up->regshift = 2;
+	}
+#endif
+	up->iobase = 0;
+	up->serial_in = ce4100_mem_serial_in;
+	up->serial_out = ce4100_mem_serial_out;
+
+	*capabilites |= (1 << 12);
+}
+
+static __init void sdv_serial_fixup(void)
+{
+	serial8250_set_isa_configurator(ce4100_serial_fixup);
+}
+
+#else
+static inline void sdv_serial_fixup(void);
+#endif
+
+static void __init sdv_arch_setup(void)
 {
+	sdv_serial_fixup();
 }
 
 /*
