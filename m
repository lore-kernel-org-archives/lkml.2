Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251Ab0E0WDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:03:43 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27201 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345Ab0E0WDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:03:41 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5995"; a="42641626"
Subject: [GIT PULL] MSM serial driver update for 2.6.35
From: Daniel Walker <dwalker@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 15:03:39 -0700
Message-ID: <1274997819.10998.44.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

	Just one fix for our serial driver to get it working with MSM7x30,
which was added this merge window.

Daniel


The following changes since commit be1066bbcd443a65df312fdecea7e4959adedb45:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6 (2010-04-30 10:16:55 -0700)

are available in the git repository at:

  git://codeaurora.org/quic/kernel/dwalker/linux-msm.git msm-serial

Abhijeet Dharmapurikar (1):
      msm: serial: fix serial on MSM7x30

 drivers/serial/msm_serial.c |   21 ++-------------
 drivers/serial/msm_serial.h |   56 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 18 deletions(-)

diff --git a/drivers/serial/msm_serial.c b/drivers/serial/msm_serial.c
index ecdc0fa..f8c816e 100644
--- a/drivers/serial/msm_serial.c
+++ b/drivers/serial/msm_serial.c
@@ -41,19 +41,6 @@ struct msm_port {
 	unsigned int		imr;
 };
 
-#define UART_TO_MSM(uart_port)	((struct msm_port *) uart_port)
-
-static inline void msm_write(struct uart_port *port, unsigned int val,
-			     unsigned int off)
-{
-	__raw_writel(val, port->membase + off);
-}
-
-static inline unsigned int msm_read(struct uart_port *port, unsigned int off)
-{
-	return __raw_readl(port->membase + off);
-}
-
 static void msm_stop_tx(struct uart_port *port)
 {
 	struct msm_port *msm_port = UART_TO_MSM(port);
@@ -320,11 +307,7 @@ static void msm_init_clock(struct uart_port *port)
 	struct msm_port *msm_port = UART_TO_MSM(port);
 
 	clk_enable(msm_port->clk);
-
-	msm_write(port, 0xC0, UART_MREG);
-	msm_write(port, 0xB2, UART_NREG);
-	msm_write(port, 0x7D, UART_DREG);
-	msm_write(port, 0x1C, UART_MNDREG);
+	msm_serial_set_mnd_regs(port);
 }
 
 static int msm_startup(struct uart_port *port)
@@ -706,6 +689,8 @@ static int __init msm_serial_probe(struct platform_device *pdev)
 	if (unlikely(IS_ERR(msm_port->clk)))
 		return PTR_ERR(msm_port->clk);
 	port->uartclk = clk_get_rate(msm_port->clk);
+	printk(KERN_INFO "uartclk = %d\n", port->uartclk);
+
 
 	resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (unlikely(!resource))
diff --git a/drivers/serial/msm_serial.h b/drivers/serial/msm_serial.h
index 689f1fa..f6ca9ca 100644
--- a/drivers/serial/msm_serial.h
+++ b/drivers/serial/msm_serial.h
@@ -114,4 +114,60 @@
 #define UART_MISR	0x0010
 #define UART_ISR	0x0014
 
+#define UART_TO_MSM(uart_port)	((struct msm_port *) uart_port)
+
+static inline
+void msm_write(struct uart_port *port, unsigned int val, unsigned int off)
+{
+	__raw_writel(val, port->membase + off);
+}
+
+static inline
+unsigned int msm_read(struct uart_port *port, unsigned int off)
+{
+	return __raw_readl(port->membase + off);
+}
+
+/*
+ * Setup the MND registers to use the TCXO clock.
+ */
+static inline void msm_serial_set_mnd_regs_tcxo(struct uart_port *port)
+{
+	msm_write(port, 0x06, UART_MREG);
+	msm_write(port, 0xF1, UART_NREG);
+	msm_write(port, 0x0F, UART_DREG);
+	msm_write(port, 0x1A, UART_MNDREG);
+}
+
+/*
+ * Setup the MND registers to use the TCXO clock divided by 4.
+ */
+static inline void msm_serial_set_mnd_regs_tcxoby4(struct uart_port *port)
+{
+	msm_write(port, 0x18, UART_MREG);
+	msm_write(port, 0xF6, UART_NREG);
+	msm_write(port, 0x0F, UART_DREG);
+	msm_write(port, 0x0A, UART_MNDREG);
+}
+
+static inline
+void msm_serial_set_mnd_regs_from_uartclk(struct uart_port *port)
+{
+	if (port->uartclk == 19200000)
+		msm_serial_set_mnd_regs_tcxo(port);
+	else
+		msm_serial_set_mnd_regs_tcxoby4(port);
+}
+
+/*
+ * TROUT has a specific defect that makes it report it's uartclk
+ * as 19.2Mhz (TCXO) when it's actually 4.8Mhz (TCXO/4). This special
+ * cases TROUT to use the right clock.
+ */
+#ifdef CONFIG_MACH_TROUT
+#define msm_serial_set_mnd_regs msm_serial_set_mnd_regs_tcxoby4
+#else
+#define msm_serial_set_mnd_regs msm_serial_set_mnd_regs_from_uartclk
+#endif
+
 #endif	/* __DRIVERS_SERIAL_MSM_SERIAL_H */


