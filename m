Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab0FDUsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:48:04 -0400
Received: from kroah.org ([198.145.64.141]:44005 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756236Ab0FDUr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:47:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/11] msm_serial: fix serial on trout
Date: Fri,  4 Jun 2010 13:47:47 -0700
Message-Id: <1275684477-20172-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100604204445.GB19761@kroah.com>
References: <20100604204445.GB19761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>

Set the mnd counter based on uartclk. This fixes a problem
on 7x30 where the uartclk is 19.2Mhz rather than the usual
4.8Mhz.

Trout incorrectly reports uartclk to be running at 19.2Mhz
It is actually running at 4.8Mhz.  For trout force mnd
counter values as if uartclk was fed by tcxo/4.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
[dwalker@codeaurora.org: inlined, moved into header, added comments.]
Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
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
-- 
1.7.1

