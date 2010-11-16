Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919Ab0KPWAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:00:37 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:47401 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932851Ab0KPWAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:00:35 -0500
From: Daniel Drake <dsd@laptop.org>
To: akpm@linux-foundation.org
Cc: dilinger@queued.net
Cc: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca
Subject: [PATCH] cs5535: add some additional cs5535-specific GPIO functionality
Message-Id: <20101116220022.8A2769D401B@zog.reactivated.net>
Date: Tue, 16 Nov 2010 22:00:22 +0000 (GMT)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=9LhU04gBgN4A:10 a=In_Hgl4hAAAA:8 a=Op-mwl0xAAAA:8 a=28nFXd7xsnNWrVUJYbMA:9 a=TIVmI8-T96Iv6lvQyNoA:7 a=b_-Ldlfm7crHErqo970F20KADssA:4 a=ro211Ng2IWAA:10 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andres Salomon <dilinger@queued.net>

This adds (well, re-adds actually) handling for events/IRQs through cs5535
GPIOs.  In the wild and wooly world of CS5535, setup_event() is for
assigning an IRQ to a GPIO filter/event pair, and set_irq() sets up
the pair to trigger IRQs.

These should really only be used in highly platform-specific drivers (such
as OLPC's DCON driver).  Sadly, because set_irq() uses MSRs, this causes the
driver to become X86-specific.

Signed-off-by: Andres Salomon <dilinger@queued.net>
Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/gpio/Kconfig       |    2 +-
 drivers/gpio/cs5535-gpio.c |   52 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cs5535.h     |    2 +
 3 files changed, 55 insertions(+), 1 deletions(-)

GPIO seems to be without maintainer..?

Needed for further development of the OLPC DCON driver, currently in staging

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 3143ac7..9180165 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -295,7 +295,7 @@ comment "PCI GPIO expanders:"
 
 config GPIO_CS5535
 	tristate "AMD CS5535/CS5536 GPIO support"
-	depends on PCI && !CS5535_GPIO
+	depends on PCI && X86 && !CS5535_GPIO
 	help
 	  The AMD CS5535 and CS5536 southbridges support 28 GPIO pins that
 	  can be used for quite a number of things.  The CS5535/6 is found on
diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/cs5535-gpio.c
index e23c068..7e5ab74 100644
--- a/drivers/gpio/cs5535-gpio.c
+++ b/drivers/gpio/cs5535-gpio.c
@@ -15,6 +15,7 @@
 #include <linux/gpio.h>
 #include <linux/io.h>
 #include <linux/cs5535.h>
+#include <asm/msr.h>
 
 #define DRV_NAME "cs5535-gpio"
 #define GPIO_BAR 1
@@ -121,6 +122,57 @@ int cs5535_gpio_isset(unsigned offset, unsigned int reg)
 }
 EXPORT_SYMBOL_GPL(cs5535_gpio_isset);
 
+int cs5535_gpio_set_irq(unsigned group, unsigned irq)
+{
+	uint32_t lo, hi;
+
+	if (group > 7 || irq > 15)
+		return -EINVAL;
+
+	rdmsr(MSR_PIC_ZSEL_HIGH, lo, hi);
+
+	lo &= ~(0xF << (group * 4));
+	lo |= (irq & 0xF) << (group * 4);
+
+	wrmsr(MSR_PIC_ZSEL_HIGH, lo, hi);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cs5535_gpio_set_irq);
+
+void cs5535_gpio_setup_event(unsigned offset, int pair, int pme)
+{
+	struct cs5535_gpio_chip *chip = &cs5535_gpio_chip;
+	uint32_t shift = (offset % 8) * 4;
+	unsigned long flags;
+	uint32_t val;
+
+	if (offset >= 24)
+		offset = GPIO_MAP_W;
+	else if (offset >= 16)
+		offset = GPIO_MAP_Z;
+	else if (offset >= 8)
+		offset = GPIO_MAP_Y;
+	else
+		offset = GPIO_MAP_X;
+
+	spin_lock_irqsave(&chip->lock, flags);
+	val = inl(chip->base + offset);
+
+	/* Clear whatever was there before */
+	val &= ~(0xF << shift);
+
+	/* Set the new value */
+	val |= ((pair & 7) << shift);
+
+	/* Set the PME bit if this is a PME event */
+	if (pme)
+		val |= (1 << (shift + 3));
+
+	outl(val, chip->base + offset);
+	spin_unlock_irqrestore(&chip->lock, flags);
+}
+EXPORT_SYMBOL_GPL(cs5535_gpio_setup_event);
+
 /*
  * Generic gpio_chip API support.
  */
diff --git a/include/linux/cs5535.h b/include/linux/cs5535.h
index d5a1d48..213cc50 100644
--- a/include/linux/cs5535.h
+++ b/include/linux/cs5535.h
@@ -111,6 +111,8 @@ static inline int cs5535_has_vsa2(void)
 void cs5535_gpio_set(unsigned offset, unsigned int reg);
 void cs5535_gpio_clear(unsigned offset, unsigned int reg);
 int cs5535_gpio_isset(unsigned offset, unsigned int reg);
+int cs5535_gpio_set_irq(unsigned group, unsigned irq);
+void cs5535_gpio_setup_event(unsigned offset, int pair, int pme);
 
 /* MFGPTs */
 
-- 
1.7.3.2

