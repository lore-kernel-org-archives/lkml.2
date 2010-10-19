Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab0JSSiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:38:24 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:36843
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755419Ab0JSSiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:38:23 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h62h)
X-Spam-TCS-SCL: 1:0
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <u.kleine-koenig@pengutronix.de>,
        <valentin.longchamp@epfl.ch>, <daniel@caiaq.de>,
        <grant.likely@secretlab.ca>, <amit.kucheria@canonical.com>,
        <xiao-lizhang@freescale.com>, Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv3 2/2] ARM: imx: Add wake functionality to GPIO
Date: Tue, 19 Oct 2010 13:39:52 -0500
Message-ID: <1287513592-6655-2-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1287513592-6655-1-git-send-email-Dinh.Nguyen@freescale.com>
References: <1287513592-6655-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: az33egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

Add function definition for irq_chip.set_wake to enable GPIO to
wake-up the system.

This patch is based on Sascha Hauer's imx/linux-2.6 for-rmk tree.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/plat-mxc/gpio.c              |   34 +++++++++++++++++++++++++++++++++
 arch/arm/plat-mxc/include/mach/gpio.h |    1 +
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-mxc/gpio.c b/arch/arm/plat-mxc/gpio.c
index 9d38da0..e52c658 100644
--- a/arch/arm/plat-mxc/gpio.c
+++ b/arch/arm/plat-mxc/gpio.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
@@ -201,11 +202,44 @@ static void mx2_gpio_irq_handler(u32 irq, struct irq_desc *desc)
 	}
 }
 
+/*
+ * Set interrupt number "irq" in the GPIO as a wake-up source.
+ * While system is running, all registered GPIO interrupts need to have
+ * wake-up enabled. When system is suspended, only selected GPIO interrupts
+ * need to have wake-up enabled.
+ * @param  irq          interrupt source number
+ * @param  enable       enable as wake-up if equal to non-zero
+ * @return       This function returns 0 on success.
+ */
+static int gpio_set_wake_irq(u32 irq, u32 enable)
+{
+	u32 gpio = irq_to_gpio(irq);
+	u32 gpio_idx = gpio & 0x1F;
+	struct mxc_gpio_port *port = &mxc_gpio_ports[gpio / 32];
+
+	if (enable) {
+		port->suspend_wakeup |= (1 << gpio_idx);
+		if (port->irq_high && (gpio_idx >= 16))
+			enable_irq_wake(port->irq_high);
+		else
+			enable_irq_wake(port->irq);
+	} else {
+		port->suspend_wakeup &= ~(1 << gpio_idx);
+		if (port->irq_high && (gpio_idx >= 16))
+			disable_irq_wake(port->irq_high);
+		else
+			disable_irq_wake(port->irq);
+	}
+
+	return 0;
+}
+
 static struct irq_chip gpio_irq_chip = {
 	.ack = gpio_ack_irq,
 	.mask = gpio_mask_irq,
 	.unmask = gpio_unmask_irq,
 	.set_type = gpio_set_irq_type,
+	.set_wake = gpio_set_wake_irq,
 };
 
 static void _set_gpio_direction(struct gpio_chip *chip, unsigned offset,
diff --git a/arch/arm/plat-mxc/include/mach/gpio.h b/arch/arm/plat-mxc/include/mach/gpio.h
index af33b74..133150e 100644
--- a/arch/arm/plat-mxc/include/mach/gpio.h
+++ b/arch/arm/plat-mxc/include/mach/gpio.h
@@ -39,6 +39,7 @@ struct mxc_gpio_port {
 	struct gpio_chip chip;
 	u32 both_edges;
 	spinlock_t lock;
+	u32 suspend_wakeup;
 };
 
 int mxc_gpio_init(struct mxc_gpio_port*, int);
-- 
1.6.0.4


