Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab0ETWUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 18:20:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1519 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab0ETWUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 18:20:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5988"; a="42096738"
Subject: Re: [PATCH] msm_serial: fix serial on trout
From: Daniel Walker <dwalker@codeaurora.org>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>, Alan Cox <alan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Brian Swetland <swetland@google.com>, linux-arm-msm@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1274310072-14802-1-git-send-email-adharmap@codeaurora.org>
References: <1274308464.22641.31.camel@c-dwalke-linux.qualcomm.com>
	 <1274310072-14802-1-git-send-email-adharmap@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 May 2010 15:20:23 -0700
Message-ID: <1274394023.29117.4.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 16:01 -0700, Abhijeet Dharmapurikar wrote:
> Set the mnd counter based on uartclk.This fixes a problem
> on 7x30 where the uartclk is 19.2Mhz rather than the usual
> 4.8Mhz.
> Trout incorrectly reports uartclk to be running at 19.2Mhz
> It is actually running at 4.8Mhz.  For trout force mnd
> counter values as if uartclk was fed by tcxo/4.
> 
> Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
> ---

couple of changes ..


Subject: [PATCH] msm: serial: fix serial on MSM7x30

Set the mnd counter based on uartclk. This fixes a problem
on 7x30 where the uartclk is 19.2Mhz rather than the usual
4.8Mhz.

Trout incorrectly reports uartclk to be running at 19.2Mhz
It is actually running at 4.8Mhz.  For trout force mnd
counter values as if uartclk was fed by tcxo/4.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
[dwalker@codeaurora.org: inlined, moved into header, added comments.]
Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
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



