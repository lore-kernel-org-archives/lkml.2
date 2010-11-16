Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249Ab0KPLr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 06:47:28 -0500
Received: from smtp.nokia.com ([147.243.128.26]:46853 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933110Ab0KPLr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:47:27 -0500
X-Greylist: delayed 2617 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Nov 2010 06:47:26 EST
From: Emeltchenko Andrei <Andrei.Emeltchenko.news@gmail.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm@lists.infradead.org, linux-serial@vger.kernel.org
Subject: [RFC] OMAP: Serial: Define register access modes in LCR
Date: Tue, 16 Nov 2010 13:01:40 +0200
Message-Id: <1289905300-31664-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>

Access to some registers depends on register access mode
Three different modes are available for OMAP (at least)
* Operational mode     LCR_REG[7] = 0x0
* Configuration mode A LCR_REG[7] = 0x1 and LCR_REG[7:0]! = 0xBF
* Configuration mode B LCR_REG[7] = 0x1 and LCR_REG[7:0]  = 0xBF

Define access modes and remove redefinitions and magic numbers
in serial drivers (and later in bluetooth driver).

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
---
 arch/arm/mach-omap2/serial.c                  |   12 ++++----
 arch/arm/plat-omap/include/plat/omap-serial.h |    9 ------
 drivers/serial/8250.c                         |   26 +++++++++---------
 drivers/serial/omap-serial.c                  |   34 ++++++++++++------------
 include/linux/serial_reg.h                    |    6 ++++
 5 files changed, 42 insertions(+), 45 deletions(-)

diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
index edd7c99..14c8715 100644
--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -218,7 +218,7 @@ static void omap_uart_save_context(struct omap_uart_state *uart)
 		return;
 
 	lcr = serial_read_reg(uart, UART_LCR);
-	serial_write_reg(uart, UART_LCR, 0xBF);
+	serial_write_reg(uart, UART_LCR, UART_LCR_CONF_MODE_B);
 	uart->dll = serial_read_reg(uart, UART_DLL);
 	uart->dlh = serial_read_reg(uart, UART_DLM);
 	serial_write_reg(uart, UART_LCR, lcr);
@@ -226,7 +226,7 @@ static void omap_uart_save_context(struct omap_uart_state *uart)
 	uart->sysc = serial_read_reg(uart, UART_OMAP_SYSC);
 	uart->scr = serial_read_reg(uart, UART_OMAP_SCR);
 	uart->wer = serial_read_reg(uart, UART_OMAP_WER);
-	serial_write_reg(uart, UART_LCR, 0x80);
+	serial_write_reg(uart, UART_LCR, UART_LCR_CONF_MODE_A);
 	uart->mcr = serial_read_reg(uart, UART_MCR);
 	serial_write_reg(uart, UART_LCR, lcr);
 
@@ -250,19 +250,19 @@ static void omap_uart_restore_context(struct omap_uart_state *uart)
 	else
 		serial_write_reg(uart, UART_OMAP_MDR1, UART_OMAP_MDR1_DISABLE);
 
-	serial_write_reg(uart, UART_LCR, 0xBF); /* Config B mode */
+	serial_write_reg(uart, UART_LCR, UART_LCR_CONF_MODE_B);
 	efr = serial_read_reg(uart, UART_EFR);
 	serial_write_reg(uart, UART_EFR, UART_EFR_ECB);
 	serial_write_reg(uart, UART_LCR, 0x0); /* Operational mode */
 	serial_write_reg(uart, UART_IER, 0x0);
-	serial_write_reg(uart, UART_LCR, 0xBF); /* Config B mode */
+	serial_write_reg(uart, UART_LCR, UART_LCR_CONF_MODE_B);
 	serial_write_reg(uart, UART_DLL, uart->dll);
 	serial_write_reg(uart, UART_DLM, uart->dlh);
 	serial_write_reg(uart, UART_LCR, 0x0); /* Operational mode */
 	serial_write_reg(uart, UART_IER, uart->ier);
-	serial_write_reg(uart, UART_LCR, 0x80);
+	serial_write_reg(uart, UART_LCR, UART_LCR_CONF_MODE_A);
 	serial_write_reg(uart, UART_MCR, uart->mcr);
-	serial_write_reg(uart, UART_LCR, 0xBF); /* Config B mode */
+	serial_write_reg(uart, UART_LCR, UART_LCR_CONF_MODE_B);
 	serial_write_reg(uart, UART_EFR, efr);
 	serial_write_reg(uart, UART_LCR, UART_LCR_WLEN8);
 	serial_write_reg(uart, UART_OMAP_SCR, uart->scr);
diff --git a/arch/arm/plat-omap/include/plat/omap-serial.h b/arch/arm/plat-omap/include/plat/omap-serial.h
index 6a17880..b3e0bad 100644
--- a/arch/arm/plat-omap/include/plat/omap-serial.h
+++ b/arch/arm/plat-omap/include/plat/omap-serial.h
@@ -33,15 +33,6 @@
 
 #define OMAP_MODE13X_SPEED	230400
 
-/*
- * LCR = 0XBF: Switch to Configuration Mode B.
- * In configuration mode b allow access
- * to EFR,DLL,DLH.
- * Reference OMAP TRM Chapter 17
- * Section: 1.4.3 Mode Selection
- */
-#define OMAP_UART_LCR_CONF_MDB	0XBF
-
 /* WER = 0x7F
  * Enable module level wakeup in WER reg
  */
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 4d8e14b..aaf9907 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -653,13 +653,13 @@ static void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
 {
 	if (p->capabilities & UART_CAP_SLEEP) {
 		if (p->capabilities & UART_CAP_EFR) {
-			serial_outp(p, UART_LCR, 0xBF);
+			serial_outp(p, UART_LCR, UART_LCR_CONF_MODE_B);
 			serial_outp(p, UART_EFR, UART_EFR_ECB);
 			serial_outp(p, UART_LCR, 0);
 		}
 		serial_outp(p, UART_IER, sleep ? UART_IERX_SLEEP : 0);
 		if (p->capabilities & UART_CAP_EFR) {
-			serial_outp(p, UART_LCR, 0xBF);
+			serial_outp(p, UART_LCR, UART_LCR_CONF_MODE_B);
 			serial_outp(p, UART_EFR, 0);
 			serial_outp(p, UART_LCR, 0);
 		}
@@ -752,7 +752,7 @@ static int size_fifo(struct uart_8250_port *up)
 	serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO |
 		    UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT);
 	serial_outp(up, UART_MCR, UART_MCR_LOOP);
-	serial_outp(up, UART_LCR, UART_LCR_DLAB);
+	serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_A);
 	old_dl = serial_dl_read(up);
 	serial_dl_write(up, 0x0001);
 	serial_outp(up, UART_LCR, 0x03);
@@ -764,7 +764,7 @@ static int size_fifo(struct uart_8250_port *up)
 		serial_inp(up, UART_RX);
 	serial_outp(up, UART_FCR, old_fcr);
 	serial_outp(up, UART_MCR, old_mcr);
-	serial_outp(up, UART_LCR, UART_LCR_DLAB);
+	serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_A);
 	serial_dl_write(up, old_dl);
 	serial_outp(up, UART_LCR, old_lcr);
 
@@ -782,7 +782,7 @@ static unsigned int autoconfig_read_divisor_id(struct uart_8250_port *p)
 	unsigned int id;
 
 	old_lcr = serial_inp(p, UART_LCR);
-	serial_outp(p, UART_LCR, UART_LCR_DLAB);
+	serial_outp(p, UART_LCR, UART_LCR_CONF_MODE_A);
 
 	old_dll = serial_inp(p, UART_DLL);
 	old_dlm = serial_inp(p, UART_DLM);
@@ -836,7 +836,7 @@ static void autoconfig_has_efr(struct uart_8250_port *up)
 	 * recommended for new designs).
 	 */
 	up->acr = 0;
-	serial_out(up, UART_LCR, 0xBF);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 	serial_out(up, UART_EFR, UART_EFR_ECB);
 	serial_out(up, UART_LCR, 0x00);
 	id1 = serial_icr_read(up, UART_ID1);
@@ -945,7 +945,7 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 	 * Check for presence of the EFR when DLAB is set.
 	 * Only ST16C650V1 UARTs pass this test.
 	 */
-	serial_outp(up, UART_LCR, UART_LCR_DLAB);
+	serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_A);
 	if (serial_in(up, UART_EFR) == 0) {
 		serial_outp(up, UART_EFR, 0xA8);
 		if (serial_in(up, UART_EFR) != 0) {
@@ -963,7 +963,7 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 	 * Maybe it requires 0xbf to be written to the LCR.
 	 * (other ST16C650V2 UARTs, TI16C752A, etc)
 	 */
-	serial_outp(up, UART_LCR, 0xBF);
+	serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_B);
 	if (serial_in(up, UART_EFR) == 0 && !broken_efr(up)) {
 		DEBUG_AUTOCONF("EFRv2 ");
 		autoconfig_has_efr(up);
@@ -1024,7 +1024,7 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 	serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO | UART_FCR7_64BYTE);
 	status1 = serial_in(up, UART_IIR) >> 5;
 	serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO);
-	serial_outp(up, UART_LCR, UART_LCR_DLAB);
+	serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_A);
 	serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO | UART_FCR7_64BYTE);
 	status2 = serial_in(up, UART_IIR) >> 5;
 	serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO);
@@ -1183,7 +1183,7 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 	 * We also initialise the EFR (if any) to zero for later.  The
 	 * EFR occupies the same register location as the FCR and IIR.
 	 */
-	serial_outp(up, UART_LCR, 0xBF);
+	serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_B);
 	serial_outp(up, UART_EFR, 0);
 	serial_outp(up, UART_LCR, 0);
 
@@ -1952,7 +1952,7 @@ static int serial8250_startup(struct uart_port *port)
 	if (up->port.type == PORT_16C950) {
 		/* Wake up and initialize UART */
 		up->acr = 0;
-		serial_outp(up, UART_LCR, 0xBF);
+		serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_B);
 		serial_outp(up, UART_EFR, UART_EFR_ECB);
 		serial_outp(up, UART_IER, 0);
 		serial_outp(up, UART_LCR, 0);
@@ -2002,7 +2002,7 @@ static int serial8250_startup(struct uart_port *port)
 	if (up->port.type == PORT_16850) {
 		unsigned char fctr;
 
-		serial_outp(up, UART_LCR, 0xbf);
+		serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_B);
 
 		fctr = serial_inp(up, UART_FCTR) & ~(UART_FCTR_RX|UART_FCTR_TX);
 		serial_outp(up, UART_FCTR, fctr | UART_FCTR_TRGD | UART_FCTR_RX);
@@ -2363,7 +2363,7 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 		if (termios->c_cflag & CRTSCTS)
 			efr |= UART_EFR_CTS;
 
-		serial_outp(up, UART_LCR, 0xBF);
+		serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_B);
 		serial_outp(up, UART_EFR, efr);
 	}
 
diff --git a/drivers/serial/omap-serial.c b/drivers/serial/omap-serial.c
index 03a96db..1201eff 100644
--- a/drivers/serial/omap-serial.c
+++ b/drivers/serial/omap-serial.c
@@ -570,7 +570,7 @@ serial_omap_configure_xonxoff
 	unsigned char efr = 0;
 
 	up->lcr = serial_in(up, UART_LCR);
-	serial_out(up, UART_LCR, OMAP_UART_LCR_CONF_MDB);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 	up->efr = serial_in(up, UART_EFR);
 	serial_out(up, UART_EFR, up->efr & ~UART_EFR_ECB);
 
@@ -598,7 +598,7 @@ serial_omap_configure_xonxoff
 		efr |= OMAP_UART_SW_RX;
 
 	serial_out(up, UART_EFR, up->efr | UART_EFR_ECB);
-	serial_out(up, UART_LCR, UART_LCR_DLAB);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
 
 	up->mcr = serial_in(up, UART_MCR);
 
@@ -612,14 +612,14 @@ serial_omap_configure_xonxoff
 		up->mcr |= UART_MCR_XONANY;
 
 	serial_out(up, UART_MCR, up->mcr | UART_MCR_TCRTLR);
-	serial_out(up, UART_LCR, OMAP_UART_LCR_CONF_MDB);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 	serial_out(up, UART_TI752_TCR, OMAP_UART_TCR_TRIG);
 	/* Enable special char function UARTi.EFR_REG[5] and
 	 * load the new software flow control mode IXON or IXOFF
 	 * and restore the UARTi.EFR_REG[4] ENHANCED_EN value.
 	 */
 	serial_out(up, UART_EFR, efr | UART_EFR_SCD);
-	serial_out(up, UART_LCR, UART_LCR_DLAB);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
 
 	serial_out(up, UART_MCR, up->mcr & ~UART_MCR_TCRTLR);
 	serial_out(up, UART_LCR, up->lcr);
@@ -724,22 +724,22 @@ serial_omap_set_termios(struct uart_port *port, struct ktermios *termios,
 	 * baud clock is not running
 	 * DLL_REG and DLH_REG set to 0.
 	 */
-	serial_out(up, UART_LCR, UART_LCR_DLAB);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
 	serial_out(up, UART_DLL, 0);
 	serial_out(up, UART_DLM, 0);
 	serial_out(up, UART_LCR, 0);
 
-	serial_out(up, UART_LCR, OMAP_UART_LCR_CONF_MDB);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 
 	up->efr = serial_in(up, UART_EFR);
 	serial_out(up, UART_EFR, up->efr | UART_EFR_ECB);
 
-	serial_out(up, UART_LCR, UART_LCR_DLAB);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
 	up->mcr = serial_in(up, UART_MCR);
 	serial_out(up, UART_MCR, up->mcr | UART_MCR_TCRTLR);
 	/* FIFO ENABLE, DMA MODE */
 	serial_out(up, UART_FCR, up->fcr);
-	serial_out(up, UART_LCR, OMAP_UART_LCR_CONF_MDB);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 
 	if (up->use_dma) {
 		serial_out(up, UART_TI752_TLR, 0);
@@ -748,27 +748,27 @@ serial_omap_set_termios(struct uart_port *port, struct ktermios *termios,
 	}
 
 	serial_out(up, UART_EFR, up->efr);
-	serial_out(up, UART_LCR, UART_LCR_DLAB);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
 	serial_out(up, UART_MCR, up->mcr);
 
 	/* Protocol, Baud Rate, and Interrupt Settings */
 
 	serial_out(up, UART_OMAP_MDR1, UART_OMAP_MDR1_DISABLE);
-	serial_out(up, UART_LCR, OMAP_UART_LCR_CONF_MDB);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 
 	up->efr = serial_in(up, UART_EFR);
 	serial_out(up, UART_EFR, up->efr | UART_EFR_ECB);
 
 	serial_out(up, UART_LCR, 0);
 	serial_out(up, UART_IER, 0);
-	serial_out(up, UART_LCR, OMAP_UART_LCR_CONF_MDB);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 
 	serial_out(up, UART_DLL, quot & 0xff);          /* LS of divisor */
 	serial_out(up, UART_DLM, quot >> 8);            /* MS of divisor */
 
 	serial_out(up, UART_LCR, 0);
 	serial_out(up, UART_IER, up->ier);
-	serial_out(up, UART_LCR, OMAP_UART_LCR_CONF_MDB);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 
 	serial_out(up, UART_EFR, up->efr);
 	serial_out(up, UART_LCR, cval);
@@ -782,18 +782,18 @@ serial_omap_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	if (termios->c_cflag & CRTSCTS) {
 		efr |= (UART_EFR_CTS | UART_EFR_RTS);
-		serial_out(up, UART_LCR, UART_LCR_DLAB);
+		serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
 
 		up->mcr = serial_in(up, UART_MCR);
 		serial_out(up, UART_MCR, up->mcr | UART_MCR_TCRTLR);
 
-		serial_out(up, UART_LCR, OMAP_UART_LCR_CONF_MDB);
+		serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 		up->efr = serial_in(up, UART_EFR);
 		serial_out(up, UART_EFR, up->efr | UART_EFR_ECB);
 
 		serial_out(up, UART_TI752_TCR, OMAP_UART_TCR_TRIG);
 		serial_out(up, UART_EFR, efr); /* Enable AUTORTS and AUTOCTS */
-		serial_out(up, UART_LCR, UART_LCR_DLAB);
+		serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
 		serial_out(up, UART_MCR, up->mcr | UART_MCR_RTS);
 		serial_out(up, UART_LCR, cval);
 	}
@@ -815,13 +815,13 @@ serial_omap_pm(struct uart_port *port, unsigned int state,
 	unsigned char efr;
 
 	dev_dbg(up->port.dev, "serial_omap_pm+%d\n", up->pdev->id);
-	serial_out(up, UART_LCR, OMAP_UART_LCR_CONF_MDB);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 	efr = serial_in(up, UART_EFR);
 	serial_out(up, UART_EFR, efr | UART_EFR_ECB);
 	serial_out(up, UART_LCR, 0);
 
 	serial_out(up, UART_IER, (state != 0) ? UART_IERX_SLEEP : 0);
-	serial_out(up, UART_LCR, OMAP_UART_LCR_CONF_MDB);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 	serial_out(up, UART_EFR, efr);
 	serial_out(up, UART_LCR, 0);
 	/* Enable module level wake up */
diff --git a/include/linux/serial_reg.h b/include/linux/serial_reg.h
index 6f38234..a371a0d 100644
--- a/include/linux/serial_reg.h
+++ b/include/linux/serial_reg.h
@@ -99,6 +99,12 @@
 #define UART_LCR_WLEN7		0x02 /* Wordlength: 7 bits */
 #define UART_LCR_WLEN8		0x03 /* Wordlength: 8 bits */
 
+/*
+ * These are definitions for register access modes using LCR
+ */
+#define UART_LCR_CONF_MODE_A	0x80	/* Configutation mode A */
+#define UART_LCR_CONF_MODE_B	0xBF	/* Configutation mode B */
+
 #define UART_MCR	4	/* Out: Modem Control Register */
 #define UART_MCR_CLKSEL		0x80 /* Divide clock by 4 (TI16C752, EFR[4]=1) */
 #define UART_MCR_TCRTLR		0x40 /* Access TCR/TLR (TI16C752, EFR[4]=1) */
-- 
1.7.0.4

