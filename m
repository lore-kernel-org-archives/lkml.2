Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab1KRDzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 22:55:08 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:34863 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756048Ab1KRDzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 22:55:06 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <baruch@tkos.co.il>, <grant.likely@secretlab.ca>, <rjw@sisk.pl>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>
Subject: [PATCH V2] GPIO/pl061: Add suspend resume capability
Date: Fri, 18 Nov 2011 09:24:39 +0530
Message-ID: <7edd51181a5c9ee7da0dc5115ec5c2dc336af1fc.1321588277.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Deepak Sikri <deepak.sikri@st.com>

This patch adds the suspend and resume operations in the driver. The patch
ensures the data save and restore for the device registers during the
suspend and resume operations respectively.

Signed-off-by: Deepak Sikri <deepak.sikri@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Acked-by: Baruch Siach <baruch@tkos.co.il>
---

Changes since V1:
- gpio_context_save_regs renamed to pl061_context_save_regs
- Hibernation callbacks added with help of SIMPLE_DEV_PM_OPS macro

 drivers/gpio/gpio-pl061.c |   68 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-pl061.c b/drivers/gpio/gpio-pl061.c
index 093c90b..5a54035 100644
--- a/drivers/gpio/gpio-pl061.c
+++ b/drivers/gpio/gpio-pl061.c
@@ -23,6 +23,7 @@
 #include <linux/amba/bus.h>
 #include <linux/amba/pl061.h>
 #include <linux/slab.h>
+#include <linux/pm.h>
 
 #define GPIODIR 0x400
 #define GPIOIS  0x404
@@ -35,6 +36,17 @@
 
 #define PL061_GPIO_NR	8
 
+#ifdef CONFIG_PM
+struct pl061_context_save_regs {
+	u8 gpio_data;
+	u8 gpio_dir;
+	u8 gpio_is;
+	u8 gpio_ibe;
+	u8 gpio_iev;
+	u8 gpio_ie;
+};
+#endif
+
 struct pl061_gpio {
 	/* We use a list of pl061_gpio structs for each trigger IRQ in the main
 	 * interrupts controller of the system. We need this to support systems
@@ -54,6 +66,10 @@ struct pl061_gpio {
 	void __iomem		*base;
 	unsigned		irq_base;
 	struct gpio_chip	gc;
+
+#ifdef CONFIG_PM
+	struct pl061_context_save_regs csave_regs;
+#endif
 };
 
 static int pl061_direction_input(struct gpio_chip *gc, unsigned offset)
@@ -330,6 +346,8 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
 		irq_set_chip_data(i + chip->irq_base, chip);
 	}
 
+	amba_set_drvdata(dev, chip);
+
 	return 0;
 
 iounmap:
@@ -342,6 +360,53 @@ free_mem:
 	return ret;
 }
 
+#ifdef CONFIG_PM
+static int pl061_suspend(struct device *dev)
+{
+	struct pl061_gpio *chip = dev_get_drvdata(dev);
+	int offset;
+
+	chip->csave_regs.gpio_data = 0;
+	chip->csave_regs.gpio_dir = readb(chip->base + GPIODIR);
+	chip->csave_regs.gpio_is = readb(chip->base + GPIOIS);
+	chip->csave_regs.gpio_ibe = readb(chip->base + GPIOIBE);
+	chip->csave_regs.gpio_iev = readb(chip->base + GPIOIEV);
+	chip->csave_regs.gpio_ie = readb(chip->base + GPIOIE);
+
+	for (offset = 0; offset < PL061_GPIO_NR; offset++) {
+		if (chip->csave_regs.gpio_dir & (1 << offset))
+			chip->csave_regs.gpio_data |=
+				pl061_get_value(&chip->gc, offset) << offset;
+	}
+
+	return 0;
+}
+
+static int pl061_resume(struct device *dev)
+{
+	struct pl061_gpio *chip = dev_get_drvdata(dev);
+	int offset;
+
+	for (offset = 0; offset < PL061_GPIO_NR; offset++) {
+		if (chip->csave_regs.gpio_dir & (1 << offset))
+			pl061_direction_output(&chip->gc, offset,
+					chip->csave_regs.gpio_data &
+					(1 << offset));
+		else
+			pl061_direction_input(&chip->gc, offset);
+	}
+
+	writeb(chip->csave_regs.gpio_is, chip->base + GPIOIS);
+	writeb(chip->csave_regs.gpio_ibe, chip->base + GPIOIBE);
+	writeb(chip->csave_regs.gpio_iev, chip->base + GPIOIEV);
+	writeb(chip->csave_regs.gpio_ie, chip->base + GPIOIE);
+
+	return 0;
+}
+
+SIMPLE_DEV_PM_OPS(pl061_dev_pm_ops, pl061_suspend, pl061_resume);
+#endif
+
 static struct amba_id pl061_ids[] = {
 	{
 		.id	= 0x00041061,
@@ -353,6 +418,9 @@ static struct amba_id pl061_ids[] = {
 static struct amba_driver pl061_gpio_driver = {
 	.drv = {
 		.name	= "pl061_gpio",
+#ifdef CONFIG_PM
+		.pm	= &pl061_dev_pm_ops,
+#endif
 	},
 	.id_table	= pl061_ids,
 	.probe		= pl061_probe,
-- 
1.7.2.2

