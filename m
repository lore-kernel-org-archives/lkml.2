Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab2JSIxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:53:55 -0400
Received: from zmc.proxad.net ([212.27.53.206]:51557 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab2JSIxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:53:51 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Oct 2012 04:53:50 EDT
From: Florian Fainelli <ffainelli@freebox.fr>
To: alan@linux.intel.com
Cc: linux-serial@vger.kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, mbizon@freebox.fr,
        Florian Fainelli <ffainelli@freebox.fr>
Subject: [PATCH tty-next] x86: ce4100: allow second UART usage
Date: Fri, 19 Oct 2012 10:45:07 +0200
Message-Id: <1350636307-23476-1-git-send-email-ffainelli@freebox.fr>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Bizon <mbizon@freebox.fr>

The current CE4100 and 8250_pci code have both a limitation preventing the
registration and usage of CE4100's second UART. This patch changes the
platform code fixing up the UART port to work on a relative UART port
base address, as well as the 8250_pci code to make it register 2 UART ports
for CE4100 and pass the port index down to all consumers.

Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
---
 arch/x86/platform/ce4100/ce4100.c  |    3 +++
 drivers/tty/serial/8250/8250_pci.c |    6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index 4c61b52..0dcc30e 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -92,8 +92,11 @@ static void ce4100_serial_fixup(int port, struct uart_port *up,
 		up->membase =
 			(void __iomem *)__fix_to_virt(FIX_EARLYCON_MEM_BASE);
 		up->membase += up->mapbase & ~PAGE_MASK;
+		up->mapbase += port * 0x100;
+		up->membase += port * 0x100;
 		up->iotype   = UPIO_MEM32;
 		up->regshift = 2;
+		up->irq = 4;
 	}
 #endif
 	up->iobase = 0;
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 17b7d26..cec8852 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1068,7 +1068,7 @@ ce4100_serial_setup(struct serial_private *priv,
 {
 	int ret;
 
-	ret = setup_port(priv, port, 0, 0, board->reg_shift);
+	ret = setup_port(priv, port, idx, 0, board->reg_shift);
 	port->port.iotype = UPIO_MEM32;
 	port->port.type = PORT_XSCALE;
 	port->port.flags = (port->port.flags | UPF_FIXED_PORT | UPF_FIXED_TYPE);
@@ -2658,8 +2658,8 @@ static struct pciserial_board pci_boards[] __devinitdata = {
 		.first_offset	= 0x1000,
 	},
 	[pbn_ce4100_1_115200] = {
-		.flags		= FL_BASE0,
-		.num_ports	= 1,
+		.flags		= FL_BASE_BARS,
+		.num_ports	= 2,
 		.base_baud	= 921600,
 		.reg_shift      = 2,
 	},
-- 
1.7.9.5

