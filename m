Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab1IUNOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:14:30 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:50958
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978Ab1IUNO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:14:29 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Shawn Guo <shawn.guo@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Jamie Iles <jamie@jamieiles.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <patches@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] gpio/mxc: add chained_irq_enter/exit() to mx3_gpio_irq_handler()
Date: Wed, 21 Sep 2011 21:24:04 +0800
Message-ID: <1316611444-14126-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mx3_gpio_irq_handler() is also called on imx6q which has GIC as
the primary interrupt controller.  As GIC implements the fasteoi flow
control, we need to add chained_irq_enter/exit() to
mx3_gpio_irq_handler() for signaling EOI, otherwise system will hang
whenever there is a gpio irq triggered.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
This is the second post of '[PATCH] gpio/mxc: make it work with imx6q'
to adopt the point given by Jamie.

 drivers/gpio/gpio-mxc.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 4340aca..82f7b65 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -30,6 +30,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <asm-generic/bug.h>
+#include <asm/mach/irq.h>
 
 enum mxc_gpio_hwtype {
 	IMX1_GPIO,	/* runs on i.mx1 */
@@ -232,10 +233,15 @@ static void mx3_gpio_irq_handler(u32 irq, struct irq_desc *desc)
 {
 	u32 irq_stat;
 	struct mxc_gpio_port *port = irq_get_handler_data(irq);
+	struct irq_chip *chip = irq_get_chip(irq);
+
+	chained_irq_enter(chip, desc);
 
 	irq_stat = readl(port->base + GPIO_ISR) & readl(port->base + GPIO_IMR);
 
 	mxc_gpio_irq_handler(port, irq_stat);
+
+	chained_irq_exit(chip, desc);
 }
 
 /* MX2 has one interrupt *for all* gpio ports */
-- 
1.7.4.1


