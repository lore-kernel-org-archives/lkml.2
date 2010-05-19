Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab0ESXBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 19:01:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46175 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0ESXBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 19:01:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5987"; a="41996471"
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
       David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>, Alan Cox <alan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Brian Swetland <swetland@google.com>, linux-arm-msm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] msm_serial: fix serial on trout
Date: Wed, 19 May 2010 16:01:12 -0700
Message-Id: <1274310072-14802-1-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1274308464.22641.31.camel@c-dwalke-linux.qualcomm.com>
References: <1274308464.22641.31.camel@c-dwalke-linux.qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the mnd counter based on uartclk.This fixes a problem
on 7x30 where the uartclk is 19.2Mhz rather than the usual
4.8Mhz.
Trout incorrectly reports uartclk to be running at 19.2Mhz
It is actually running at 4.8Mhz.  For trout force mnd
counter values as if uartclk was fed by tcxo/4.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
---
 drivers/serial/msm_serial.c |   33 ++++++++++++++++++++++++++++-----
 drivers/serial/msm_serial.h |    6 ++++++
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/serial/msm_serial.c b/drivers/serial/msm_serial.c
index ecdc0fa..7021c8c 100644
--- a/drivers/serial/msm_serial.c
+++ b/drivers/serial/msm_serial.c
@@ -315,16 +315,37 @@ static void msm_reset(struct uart_port *port)
 	msm_write(port, UART_CR_CMD_SET_RFR, UART_CR);
 }
 
+
+static void msm_serial_set_mnd_regs_tcxo(struct uart_port *port)
+{
+	msm_write(port, 0x06, UART_MREG);
+	msm_write(port, 0xF1, UART_NREG);
+	msm_write(port, 0x0F, UART_DREG);
+	msm_write(port, 0x1A, UART_MNDREG);
+}
+
+static void msm_serial_set_mnd_regs_tcxoby4(struct uart_port *port)
+{
+	msm_write(port, 0x18, UART_MREG);
+	msm_write(port, 0xF6, UART_NREG);
+	msm_write(port, 0x0F, UART_DREG);
+	msm_write(port, 0x0A, UART_MNDREG);
+}
+
+static void msm_serial_set_mnd_regs_from_uartclk(struct uart_port *port)
+{
+	if (port->uartclk == 19200000)
+		msm_serial_set_mnd_regs_tcxo(port);
+	else
+		msm_serial_set_mnd_regs_tcxoby4(port);
+}
+
 static void msm_init_clock(struct uart_port *port)
 {
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
@@ -706,6 +727,8 @@ static int __init msm_serial_probe(struct platform_device *pdev)
 	if (unlikely(IS_ERR(msm_port->clk)))
 		return PTR_ERR(msm_port->clk);
 	port->uartclk = clk_get_rate(msm_port->clk);
+	printk(KERN_INFO "uartclk = %d\n", port->uartclk);
+
 
 	resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (unlikely(!resource))
diff --git a/drivers/serial/msm_serial.h b/drivers/serial/msm_serial.h
index 689f1fa..4767211 100644
--- a/drivers/serial/msm_serial.h
+++ b/drivers/serial/msm_serial.h
@@ -114,4 +114,10 @@
 #define UART_MISR	0x0010
 #define UART_ISR	0x0014
 
+#ifdef CONFIG_MACH_TROUT
+#define msm_serial_set_mnd_regs msm_serial_set_mnd_regs_tcxoby4
+#else
+#define msm_serial_set_mnd_regs msm_serial_set_mnd_regs_from_uartclk
+#endif
+
 #endif	/* __DRIVERS_SERIAL_MSM_SERIAL_H */
-- 
1.5.6.3

