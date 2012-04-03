Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab2DCTrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 15:47:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34654 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753765Ab2DCTre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 15:47:34 -0400
Message-ID: <4F7B53C9.4040509@fb.com>
Date: Tue, 3 Apr 2012 12:47:21 -0700
From: sudhakar <sudhakar@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: <linux-serial@vger.kernel.org>
CC: <alan@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <dan.j.williams@intel.com>, <nhan.h.mai@intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] serial/8250_pci: Need to clear FIFOs for KT serial on
 BI
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-04-03_06:2012-04-03,2012-04-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sudhakar Mamillapalli <sudhakar@fb.com>

When using SOL thru a KT serial device and Intel ME gets reset
the serial FIFOs need to be cleared for sane SOL output.  On
a reset the device assertes BI, so using that as a cue FIFOs
are cleared.  One other problem is that the serial registers
might temporarily go to 0 on reset for this device. So
instead of restoring IER register from read value in
poll_char and other functions we get the value from
uart_8250_port which should have the same value.

Signed-off-by: Sudhakar Mamillapalli <sudhakar@fb.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Nhan H Mai <nhan.h.mai@intel.com>
---
 drivers/tty/serial/8250/8250.c     |   37 +++++++++++++++++++++++++++++++++--
 drivers/tty/serial/8250/8250_pci.c |    3 +-
 include/linux/serial_core.h        |    3 +-
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index 5fb0157..c61799e 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -282,6 +282,13 @@ static const struct serial8250_config uart_config[] = {
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
 		.flags		= UART_CAP_FIFO | UART_CAP_AFE | UART_CAP_EFR,
 	},
+	[PORT_KT_SERIAL] = {
+		.name		= "KTSERIAL",
+		.fifo_size	= 16,
+		.tx_loadsz	= 16,
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+		.flags		= UART_CAP_FIFO,
+	},
 };
 
 #if defined(CONFIG_MIPS_ALCHEMY)
@@ -1363,6 +1370,7 @@ serial8250_rx_chars(struct uart_8250_port *up, unsigned char lsr)
 	struct uart_port *port = &up->port;
 	struct tty_struct *tty = port->state->port.tty;
 	unsigned char ch;
+	unsigned char fcr;
 	int max_count = 256;
 	char flag;
 
@@ -1385,6 +1393,16 @@ serial8250_rx_chars(struct uart_8250_port *up, unsigned char lsr)
 		lsr |= up->lsr_saved_flags;
 		up->lsr_saved_flags = 0;
 
+		if ((up->port.type == PORT_KT_SERIAL) && (lsr & UART_LSR_BI)) {
+			/*
+			 * For KT serial device if break interrupt then got
+			 * to clear the fifos for sane SOL output.
+			 */
+			serial8250_clear_fifos(up);
+			fcr = uart_config[up->port.type].fcr;
+			serial_port_out(port, UART_FCR, fcr);
+		}
+
 		if (unlikely(lsr & UART_LSR_BRK_ERROR_BITS)) {
 			/*
 			 * For statistics only
@@ -1729,7 +1747,12 @@ static void serial8250_backup_timeout(unsigned long data)
 	 * based handler.
 	 */
 	if (up->port.irq) {
-		ier = serial_in(up, UART_IER);
+		/*
+		 * Get the ier value from up->ier rather than reading the
+		 * register, since some SOL uarts(for e.g. KT serial) it
+		 * goes to 0 momentarily on BMC reset.
+		 */
+		ier = up->ier;
 		serial_out(up, UART_IER, 0);
 	}
 
@@ -1896,8 +1919,12 @@ static void serial8250_put_poll_char(struct uart_port *port,
 
 	/*
 	 *	First save the IER then disable the interrupts
+	 *
+	 *      Get the ier value from up->ier rather than reading the
+	 *      register, since some SOL uarts(for e.g. KT serial) it
+	 *      goes to 0 momentarily on BMC reset.
 	 */
-	ier = serial_port_in(port, UART_IER);
+	ier = up->ier;
 	if (up->capabilities & UART_CAP_UUE)
 		serial_port_out(port, UART_IER, UART_IER_UUE);
 	else
@@ -2818,8 +2845,12 @@ serial8250_console_write(struct console *co, const char *s, unsigned int count)
 
 	/*
 	 *	First save the IER then disable the interrupts
+	 *
+	 *      Get the ier value from up->ier rather than reading the
+	 *      register, since some SOL uarts(for e.g. KT serial) it
+	 *      goes to 0 momentarily on BMC reset.
 	 */
-	ier = serial_port_in(port, UART_IER);
+	ier = up->ier;
 
 	if (up->capabilities & UART_CAP_UUE)
 		serial_port_out(port, UART_IER, UART_IER_UUE);
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 858dca8..1aebe63 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1096,7 +1096,8 @@ static int kt_serial_setup(struct serial_private *priv,
 			   const struct pciserial_board *board,
 			   struct uart_port *port, int idx)
 {
-	port->flags |= UPF_BUG_THRE;
+	port->flags |= UPF_BUG_THRE | UPF_FIXED_TYPE;
+	port->type = PORT_KT_SERIAL;
 	return skip_tx_en_setup(priv, board, port, idx);
 }
 
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 2db407a..efd7d0d 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -47,7 +47,8 @@
 #define PORT_U6_16550A	19	/* ST-Ericsson U6xxx internal UART */
 #define PORT_TEGRA	20	/* NVIDIA Tegra internal UART */
 #define PORT_XR17D15X	21	/* Exar XR17D15x UART */
-#define PORT_MAX_8250	21	/* max port ID */
+#define PORT_KT_SERIAL	22	/* KT Serial SOL device */
+#define PORT_MAX_8250	22	/* max port ID */
 
 /*
  * ARM specific type numbers.  These are not currently guaranteed
-- 
1.7.8.4

