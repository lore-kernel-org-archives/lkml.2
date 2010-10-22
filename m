Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab0JVSYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:24:41 -0400
Received: from kroah.org ([198.145.64.141]:37713 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758721Ab0JVSYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:24:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Manuel Lauss <manuel.lauss@googlemail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 43/49] Alchemy: Add UART PM methods.
Date: Fri, 22 Oct 2010 11:21:22 -0700
Message-Id: <1287771688-14805-43-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manuel Lauss <manuel.lauss@googlemail.com>

Custom UART PM hook for Alchemy chips:  do standard UART pm and
additionally en/disable uart block clocks as needed.
This allows to get rid of a debug port PM hack in the Alchemy pm code.

Tested on Db1200.

Signed-off-by: Manuel Lauss <manuel.lauss@googlemail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/mips/alchemy/common/platform.c |   28 ++++++++++++++++++++++++++++
 arch/mips/alchemy/common/power.c    |   35 -----------------------------------
 2 files changed, 28 insertions(+), 35 deletions(-)

diff --git a/arch/mips/alchemy/common/platform.c b/arch/mips/alchemy/common/platform.c
index 1dc55ee..3691630 100644
--- a/arch/mips/alchemy/common/platform.c
+++ b/arch/mips/alchemy/common/platform.c
@@ -24,6 +24,33 @@
 
 #include <prom.h>
 
+static void alchemy_8250_pm(struct uart_port *port, unsigned int state,
+			    unsigned int old_state)
+{
+	switch (state) {
+	case 0:
+		if ((__raw_readl(port->membase + UART_MOD_CNTRL) & 3) != 3) {
+			/* power-on sequence as suggested in the databooks */
+			__raw_writel(0, port->membase + UART_MOD_CNTRL);
+			wmb();
+			__raw_writel(1, port->membase + UART_MOD_CNTRL);
+			wmb();
+		}
+		__raw_writel(3, port->membase + UART_MOD_CNTRL); /* full on */
+		wmb();
+		serial8250_do_pm(port, state, old_state);
+		break;
+	case 3:		/* power off */
+		serial8250_do_pm(port, state, old_state);
+		__raw_writel(0, port->membase + UART_MOD_CNTRL);
+		wmb();
+		break;
+	default:
+		serial8250_do_pm(port, state, old_state);
+		break;
+	}
+}
+
 #define PORT(_base, _irq)					\
 	{							\
 		.mapbase	= _base,			\
@@ -33,6 +60,7 @@
 		.flags		= UPF_SKIP_TEST | UPF_IOREMAP |	\
 				  UPF_FIXED_TYPE,		\
 		.type		= PORT_16550A,			\
+		.pm		= alchemy_8250_pm,		\
 	}
 
 static struct plat_serial8250_port au1x00_uart_data[] = {
diff --git a/arch/mips/alchemy/common/power.c b/arch/mips/alchemy/common/power.c
index 5ef06a1..e5916a5 100644
--- a/arch/mips/alchemy/common/power.c
+++ b/arch/mips/alchemy/common/power.c
@@ -49,11 +49,6 @@
  * We only have to save/restore registers that aren't otherwise
  * done as part of a driver pm_* function.
  */
-static unsigned int sleep_uart0_inten;
-static unsigned int sleep_uart0_fifoctl;
-static unsigned int sleep_uart0_linectl;
-static unsigned int sleep_uart0_clkdiv;
-static unsigned int sleep_uart0_enable;
 static unsigned int sleep_usb[2];
 static unsigned int sleep_sys_clocks[5];
 static unsigned int sleep_sys_pinfunc;
@@ -62,22 +57,6 @@ static unsigned int sleep_static_memctlr[4][3];
 
 static void save_core_regs(void)
 {
-	extern void save_au1xxx_intctl(void);
-	extern void pm_eth0_shutdown(void);
-
-	/*
-	 * Do the serial ports.....these really should be a pm_*
-	 * registered function by the driver......but of course the
-	 * standard serial driver doesn't understand our Au1xxx
-	 * unique registers.
-	 */
-	sleep_uart0_inten = au_readl(UART0_ADDR + UART_IER);
-	sleep_uart0_fifoctl = au_readl(UART0_ADDR + UART_FCR);
-	sleep_uart0_linectl = au_readl(UART0_ADDR + UART_LCR);
-	sleep_uart0_clkdiv = au_readl(UART0_ADDR + UART_CLK);
-	sleep_uart0_enable = au_readl(UART0_ADDR + UART_MOD_CNTRL);
-	au_sync();
-
 #ifndef CONFIG_SOC_AU1200
 	/* Shutdown USB host/device. */
 	sleep_usb[0] = au_readl(USB_HOST_CONFIG);
@@ -175,20 +154,6 @@ static void restore_core_regs(void)
 	au_writel(sleep_static_memctlr[3][0], MEM_STCFG3);
 	au_writel(sleep_static_memctlr[3][1], MEM_STTIME3);
 	au_writel(sleep_static_memctlr[3][2], MEM_STADDR3);
-
-	/*
-	 * Enable the UART if it was enabled before sleep.
-	 * I guess I should define module control bits........
-	 */
-	if (sleep_uart0_enable & 0x02) {
-		au_writel(0, UART0_ADDR + UART_MOD_CNTRL); au_sync();
-		au_writel(1, UART0_ADDR + UART_MOD_CNTRL); au_sync();
-		au_writel(3, UART0_ADDR + UART_MOD_CNTRL); au_sync();
-		au_writel(sleep_uart0_inten, UART0_ADDR + UART_IER); au_sync();
-		au_writel(sleep_uart0_fifoctl, UART0_ADDR + UART_FCR); au_sync();
-		au_writel(sleep_uart0_linectl, UART0_ADDR + UART_LCR); au_sync();
-		au_writel(sleep_uart0_clkdiv, UART0_ADDR + UART_CLK); au_sync();
-	}
 }
 
 void au_sleep(void)
-- 
1.7.2

