Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966738Ab2JZWR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 18:17:28 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:39203 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109Ab2JZWR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 18:17:26 -0400
Date: Fri, 26 Oct 2012 15:16:02 -0700 (PDT)
From: Min Zhang <mzhang@mvista.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: gregkh@linuxfoundation.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2] serial: 8250 check iir rdi in interrupt
In-Reply-To: <20121026151902.0a382d16@pyramind.ukuu.org.uk>
Message-ID: <alpine.LFD.2.02.1210261503570.9262@nightowl>
References: <alpine.LFD.2.02.1210221633450.28146@nightowl> <20121023110133.62bed522@pyramind.ukuu.org.uk> <CAJ0e-Fofs48N9VnYr1_8Kch6+yHjGx9iCWBRtRsqpD-B_rWutQ@mail.gmail.com> <20121026151902.0a382d16@pyramind.ukuu.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch works around two UART interrupt bugs when the serial console is
flooded with inputs:
1. syslog shows "serial8250: too much works for irq"
2. serial console stops responding to key stroke

serial8250_handle_irq() checks UART_IIR_RDI before reading receive fifo
and clears bogus interrupt UART_IIR_RDI without accompanying UART_LSR_DR,
otherwise RDI interrupt could freeze or too many unhandled RDI interrupts.

Added module parameter skip_rdi_check to opt out this workaround.

Tested on Radisys ATCA 46XX which uses FPGA 16550-compatible and
other generic 16550 UART. It takes from an hour to days to reproduce by
pumping inputs to serial console continously using TeraTerm script:

Signed-off-by: Min Zhang <mzhang@mvista.com>
---
  drivers/tty/serial/8250/8250.c |   50 ++++++++++++++++++++++++++++++++++++++++
  1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index 3ba4234..dfc13d1 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -64,6 +64,7 @@ static int serial_index(struct uart_port *port)
  }

  static unsigned int skip_txen_test; /* force skip of txen test at init time */
+static unsigned int skip_rdi_check = 1; /* skip of IIR RDI check in interrupt */

  /*
   * Debugging.
@@ -1479,6 +1480,46 @@ unsigned int serial8250_modem_status(struct uart_8250_port *up)
  EXPORT_SYMBOL_GPL(serial8250_modem_status);

  /*
+ * Check if status UART_LSR_RD accompanies with interrupt UART_IIR_RDI.
+ * If they are mismatch, massage the status or interupt cause accordingly:
+ *
+ * Return a cleared UART_LSR_RD status if there is no accompanying
+ * UART_IIR_RDI. Hopefully the new status is used by interrupt handler
+ * to skip reading receive FIFO. Otherwise some UART controller stops
+ * generating RDI interrupt after this unnotified FIFO read, until other
+ * interrupts maybe transmit interrupt reads UART_LSR again.
+ *
+ * Or clear interrupt cause UART_IIR_RDI without UART_LSR_RD. The UART sets
+ * UART_IIR_RDI *even* if the received data has been read out from the FIFO
+ * before the timeout occurs.  To clear UART_IIR_RDI, read receive buffer
+ * register. Reading it also clears timeout interrupt for 16550+. Otherwise
+ * the uncleared UART_IIR_RDI will keep triggering IRQ but interrupt
+ * handler finds nothing to do.
+ *
+ * Skip this workaround if interrupt is not expected, such as backup timer,
+ * so that handler can still solely rely on original status register.
+ */
+static inline unsigned char serial8250_iir_rdi_check(struct uart_8250_port *up,
+						     unsigned char status,
+						     unsigned int iir)
+{
+	unsigned int rdi_stat, rdi_intr;
+
+	/* skip for timer based handler */
+	if (up->timer.data)
+		return status;
+
+	rdi_stat = status & UART_LSR_DR;
+	rdi_intr = iir & UART_IIR_RDI;
+
+	if (rdi_stat && !rdi_intr)
+		status &= ~UART_LSR_DR;
+	else if (!rdi_stat && rdi_intr)
+		serial_in(up, UART_RX);
+	return status;
+}
+
+/*
   * This handles the interrupt from one port.
   */
  int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
@@ -1497,6 +1538,12 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)

  	DEBUG_INTR("status = %x...", status);

+	/* Some UART controller has mismatched UART_IIR_RDI and UART_LSR_DR,
+	   which causes either too many interrupts or interrupt freeze
+	 */
+	if (!skip_rdi_check)
+		status = serial8250_iir_rdi_check(up, status, iir);
+
  	if (status & (UART_LSR_DR | UART_LSR_BI))
  		status = serial8250_rx_chars(up, status);
  	serial8250_modem_status(up);
@@ -3338,6 +3385,9 @@ MODULE_PARM_DESC(nr_uarts, "Maximum number of UARTs supported. (1-" __MODULE_STR
  module_param(skip_txen_test, uint, 0644);
  MODULE_PARM_DESC(skip_txen_test, "Skip checking for the TXEN bug at init time");

+module_param(skip_rdi_check, uint, 0644);
+MODULE_PARM_DESC(skip_rdi_check, "Skip checking IIR RDI bug in interrupt");
+
  #ifdef CONFIG_SERIAL_8250_RSA
  module_param_array(probe_rsa, ulong, &probe_rsa_count, 0444);
  MODULE_PARM_DESC(probe_rsa, "Probe I/O ports for RSA");
-- 
1.7.0.1

