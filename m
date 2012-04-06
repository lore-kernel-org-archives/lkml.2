Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab2DFSeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 14:34:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:49576 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064Ab2DFSe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 14:34:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="126154854"
Subject: [PATCH 5/6] serial/8250_pci: Clear FIFOs for Intel ME Serial Over
 Lan device on BI
To: gregkh@linuxfoundation.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: Sudhakar Mamillapalli <sudhakar@fb.com>, Nhan H Mai <nhan.h.mai@intel.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Date: Fri, 06 Apr 2012 11:50:05 -0700
Message-ID: <20120406185002.22088.20641.stgit@dwillia2-linux.jf.intel.com>
In-Reply-To: <20120406184346.21744.18004.stgit@dwillia2-linux.jf.intel.com>
References: <20120406184346.21744.18004.stgit@dwillia2-linux.jf.intel.com>
User-Agent: StGit/0.16-1-g7004
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudhakar Mamillapalli <sudhakar@fb.com>

When using Serial Over Lan (SOL) over the virtual serial port in a Intel
management engine (ME) device, on device reset the serial FIFOs need to
be cleared to keep the FIFO indexes in-sync between the host and the
engine.

On a reset the serial device assertes BI, so using that as a cue FIFOs
are cleared.  So for this purpose a new handle_break callback has been
added.  One other problem is that the serial registers might temporarily
go to 0 on reset of this device.  So instead of using the IER register
read, if 0 returned use the ier value in uart_8250_port. This is hidden
under a custom serial_in.

Cc: Alan Cox <alan@linux.intel.com>
Cc: Nhan H Mai <nhan.h.mai@intel.com>
Signed-off-by: Sudhakar Mamillapalli <sudhakar@fb.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/tty/serial/8250/8250.c     |   10 +++++++++
 drivers/tty/serial/8250/8250.h     |    2 ++
 drivers/tty/serial/8250/8250_pci.c |   39 ++++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index d1e0b3d..3fc7619 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -590,6 +590,16 @@ static void serial8250_clear_fifos(struct uart_8250_port *p)
 	}
 }
 
+void serial8250_clear_and_reinit_fifos(struct uart_8250_port *p)
+{
+	unsigned char fcr;
+
+	serial8250_clear_fifos(p);
+	fcr = uart_config[p->port.type].fcr;
+	serial_out(p, UART_FCR, fcr);
+}
+EXPORT_SYMBOL_GPL(serial8250_clear_and_reinit_fifos);
+
 /*
  * IER sleep support.  UARTs which have EFRs need the "extended
  * capability" bit enabled.  Note that on XR16C850s, we need to
diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index ae027be..5efa6c5 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -86,6 +86,8 @@ struct serial8250_config {
 #define SERIAL8250_SHARE_IRQS 0
 #endif
 
+void serial8250_clear_and_reinit_fifos(struct uart_8250_port *p);
+
 #if defined(__alpha__) && !defined(CONFIG_PCI)
 /*
  * Digital did something really horribly wrong with the OUT1 and OUT2
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 858dca8..024551a 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/tty.h>
+#include <linux/serial_reg.h>
 #include <linux/serial_core.h>
 #include <linux/8250_pci.h>
 #include <linux/bitops.h>
@@ -1092,11 +1093,49 @@ static int skip_tx_en_setup(struct serial_private *priv,
 	return pci_default_setup(priv, board, port, idx);
 }
 
+static void kt_handle_break(struct uart_port *p)
+{
+	struct uart_8250_port *up =
+		container_of(p, struct uart_8250_port, port);
+	/*
+	 * On receipt of a BI, serial device in Intel ME (Intel
+	 * management engine) needs to have its fifos cleared for sane
+	 * SOL (Serial Over Lan) output.
+	 */
+	serial8250_clear_and_reinit_fifos(up);
+}
+
+static unsigned int kt_serial_in(struct uart_port *p, int offset)
+{
+	struct uart_8250_port *up =
+		container_of(p, struct uart_8250_port, port);
+	unsigned int val;
+
+	/*
+	 * When the Intel ME (management engine) gets reset its serial
+	 * port registers could return 0 momentarily.  Functions like
+	 * serial8250_console_write, read and save the IER, perform
+	 * some operation and then restore it.  In order to avoid
+	 * setting IER register inadvertently to 0, if the value read
+	 * is 0, double check with ier value in uart_8250_port and use
+	 * that instead.  up->ier should be the same value as what is
+	 * currently configured.
+	 */
+	val = inb(p->iobase + offset);
+	if (offset == UART_IER) {
+		if (val == 0)
+			val = up->ier;
+	}
+	return val;
+}
+
 static int kt_serial_setup(struct serial_private *priv,
 			   const struct pciserial_board *board,
 			   struct uart_port *port, int idx)
 {
 	port->flags |= UPF_BUG_THRE;
+	port->serial_in = kt_serial_in;
+	port->handle_break = kt_handle_break;
 	return skip_tx_en_setup(priv, board, port, idx);
 }
 

