Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab0KLNbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 08:31:24 -0500
Received: from smtp.nokia.com ([147.243.1.47]:27356 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555Ab0KLNbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 08:31:18 -0500
From: Emeltchenko Andrei <Andrei.Emeltchenko.news@gmail.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm@lists.arm.linux.org.uk, linux-serial@vger.kernel.org
Subject: [PATCHv5] OMAP: Serial: Define OMAP uart MDR1 reg and remove magic numbers
Date: Fri, 12 Nov 2010 15:29:17 +0200
Message-Id: <1289568557-9727-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
X-Mailer: git-send-email 1.7.0.4
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>

Define MDR1 register serial definitions used in serial and
bluetooth drivers.
Change magic number to ones defined in serial_reg for omap1/2
serial driver.
Remove redefined MDR1 register definitions in omap-serial driver.

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
---
 arch/arm/mach-omap1/serial.c                  |    6 ++++--
 arch/arm/mach-omap2/serial.c                  |   15 +++++++++------
 arch/arm/plat-omap/include/plat/omap-serial.h |    3 ---
 drivers/serial/omap-serial.c                  |    6 +++---
 include/linux/serial_reg.h                    |   12 ++++++++++++
 5 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-omap1/serial.c b/arch/arm/mach-omap1/serial.c
index b78d074..c73d1b7 100644
--- a/arch/arm/mach-omap1/serial.c
+++ b/arch/arm/mach-omap1/serial.c
@@ -52,9 +52,11 @@ static inline void omap_serial_outp(struct plat_serial8250_port *p, int offset,
  */
 static void __init omap_serial_reset(struct plat_serial8250_port *p)
 {
-	omap_serial_outp(p, UART_OMAP_MDR1, 0x07);	/* disable UART */
+	omap_serial_outp(p, UART_OMAP_MDR1,
+			UART_OMAP_MDR1_DISABLE);	/* disable UART */
 	omap_serial_outp(p, UART_OMAP_SCR, 0x08);	/* TX watermark */
-	omap_serial_outp(p, UART_OMAP_MDR1, 0x00);	/* enable UART */
+	omap_serial_outp(p, UART_OMAP_MDR1,
+			UART_OMAP_MDR1_16X_MODE);	/* enable UART */
 
 	if (!cpu_is_omap15xx()) {
 		omap_serial_outp(p, UART_OMAP_SYSC, 0x01);
diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
index becf0e3..edd7c99 100644
--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -168,9 +168,9 @@ static inline void serial_write_reg(struct omap_uart_state *uart, int offset,
 
 static inline void __init omap_uart_reset(struct omap_uart_state *uart)
 {
-	serial_write_reg(uart, UART_OMAP_MDR1, 0x07);
+	serial_write_reg(uart, UART_OMAP_MDR1, UART_OMAP_MDR1_DISABLE);
 	serial_write_reg(uart, UART_OMAP_SCR, 0x08);
-	serial_write_reg(uart, UART_OMAP_MDR1, 0x00);
+	serial_write_reg(uart, UART_OMAP_MDR1, UART_OMAP_MDR1_16X_MODE);
 }
 
 #if defined(CONFIG_PM) && defined(CONFIG_ARCH_OMAP3)
@@ -246,9 +246,10 @@ static void omap_uart_restore_context(struct omap_uart_state *uart)
 	uart->context_valid = 0;
 
 	if (uart->errata & UART_ERRATA_i202_MDR1_ACCESS)
-		omap_uart_mdr1_errataset(uart, 0x07, 0xA0);
+		omap_uart_mdr1_errataset(uart, UART_OMAP_MDR1_DISABLE, 0xA0);
 	else
-		serial_write_reg(uart, UART_OMAP_MDR1, 0x7);
+		serial_write_reg(uart, UART_OMAP_MDR1, UART_OMAP_MDR1_DISABLE);
+
 	serial_write_reg(uart, UART_LCR, 0xBF); /* Config B mode */
 	efr = serial_read_reg(uart, UART_EFR);
 	serial_write_reg(uart, UART_EFR, UART_EFR_ECB);
@@ -267,11 +268,13 @@ static void omap_uart_restore_context(struct omap_uart_state *uart)
 	serial_write_reg(uart, UART_OMAP_SCR, uart->scr);
 	serial_write_reg(uart, UART_OMAP_WER, uart->wer);
 	serial_write_reg(uart, UART_OMAP_SYSC, uart->sysc);
+
 	if (uart->errata & UART_ERRATA_i202_MDR1_ACCESS)
-		omap_uart_mdr1_errataset(uart, 0x00, 0xA1);
+		omap_uart_mdr1_errataset(uart, UART_OMAP_MDR1_16X_MODE, 0xA1);
 	else
 		/* UART 16x mode */
-		serial_write_reg(uart, UART_OMAP_MDR1, 0x00);
+		serial_write_reg(uart, UART_OMAP_MDR1,
+				UART_OMAP_MDR1_16X_MODE);
 }
 #else
 static inline void omap_uart_save_context(struct omap_uart_state *uart) {}
diff --git a/arch/arm/plat-omap/include/plat/omap-serial.h b/arch/arm/plat-omap/include/plat/omap-serial.h
index c8dae02..6a17880 100644
--- a/arch/arm/plat-omap/include/plat/omap-serial.h
+++ b/arch/arm/plat-omap/include/plat/omap-serial.h
@@ -31,9 +31,6 @@
  */
 #define OMAP_SERIAL_NAME	"ttyO"
 
-#define OMAP_MDR1_DISABLE	0x07
-#define OMAP_MDR1_MODE13X	0x03
-#define OMAP_MDR1_MODE16X	0x00
 #define OMAP_MODE13X_SPEED	230400
 
 /*
diff --git a/drivers/serial/omap-serial.c b/drivers/serial/omap-serial.c
index 14365f7..03a96db 100644
--- a/drivers/serial/omap-serial.c
+++ b/drivers/serial/omap-serial.c
@@ -753,7 +753,7 @@ serial_omap_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	/* Protocol, Baud Rate, and Interrupt Settings */
 
-	serial_out(up, UART_OMAP_MDR1, OMAP_MDR1_DISABLE);
+	serial_out(up, UART_OMAP_MDR1, UART_OMAP_MDR1_DISABLE);
 	serial_out(up, UART_LCR, OMAP_UART_LCR_CONF_MDB);
 
 	up->efr = serial_in(up, UART_EFR);
@@ -774,9 +774,9 @@ serial_omap_set_termios(struct uart_port *port, struct ktermios *termios,
 	serial_out(up, UART_LCR, cval);
 
 	if (baud > 230400 && baud != 3000000)
-		serial_out(up, UART_OMAP_MDR1, OMAP_MDR1_MODE13X);
+		serial_out(up, UART_OMAP_MDR1, UART_OMAP_MDR1_13X_MODE);
 	else
-		serial_out(up, UART_OMAP_MDR1, OMAP_MDR1_MODE16X);
+		serial_out(up, UART_OMAP_MDR1, UART_OMAP_MDR1_16X_MODE);
 
 	/* Hardware Flow Control Configuration */
 
diff --git a/include/linux/serial_reg.h b/include/linux/serial_reg.h
index c7a0ce1..6f38234 100644
--- a/include/linux/serial_reg.h
+++ b/include/linux/serial_reg.h
@@ -341,5 +341,17 @@
 #define UART_OMAP_SYSS		0x16	/* System status register */
 #define UART_OMAP_WER		0x17	/* Wake-up enable register */
 
+/*
+ * These are the definitions for the MDR1 register
+ */
+#define UART_OMAP_MDR1_16X_MODE		0x00	/* UART 16x mode */
+#define UART_OMAP_MDR1_SIR_MODE		0x01	/* SIR mode */
+#define UART_OMAP_MDR1_16X_ABAUD_MODE	0x02	/* UART 16x auto-baud */
+#define UART_OMAP_MDR1_13X_MODE		0x03	/* UART 13x mode */
+#define UART_OMAP_MDR1_MIR_MODE		0x04	/* MIR mode */
+#define UART_OMAP_MDR1_FIR_MODE		0x05	/* FIR mode */
+#define UART_OMAP_MDR1_CIR_MODE		0x06	/* CIR mode */
+#define UART_OMAP_MDR1_DISABLE		0x07	/* Disable (default state) */
+
 #endif /* _LINUX_SERIAL_REG_H */
 
-- 
1.7.0.4

