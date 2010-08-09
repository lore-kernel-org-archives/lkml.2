Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab0HINso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 09:48:44 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:57166 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756155Ab0HINsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 09:48:43 -0400
From: Rabin Vincent <rabin.vincent@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>
Cc: <STEricsson_nomadik_linux@list.st.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 3/4] tc35892-gpio: add setup/remove callbacks
Date: Mon, 9 Aug 2010 19:18:16 +0530
Message-ID: <1281361697-4874-3-git-send-email-rabin.vincent@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1281361697-4874-1-git-send-email-rabin.vincent@stericsson.com>
References: <1281361697-4874-1-git-send-email-rabin.vincent@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For board-specific initialization.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
---
 drivers/gpio/tc35892-gpio.c |    8 ++++++++
 include/linux/mfd/tc35892.h |    4 ++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/tc35892-gpio.c b/drivers/gpio/tc35892-gpio.c
index 1be6288..7e10c93 100644
--- a/drivers/gpio/tc35892-gpio.c
+++ b/drivers/gpio/tc35892-gpio.c
@@ -322,6 +322,9 @@ static int __devinit tc35892_gpio_probe(struct platform_device *pdev)
 		goto out_freeirq;
 	}
 
+	if (pdata->setup)
+		pdata->setup(tc35892, tc35892_gpio->chip.base);
+
 	platform_set_drvdata(pdev, tc35892_gpio);
 
 	return 0;
@@ -338,9 +341,14 @@ out_free:
 static int __devexit tc35892_gpio_remove(struct platform_device *pdev)
 {
 	struct tc35892_gpio *tc35892_gpio = platform_get_drvdata(pdev);
+	struct tc35892 *tc35892 = tc35892_gpio->tc35892;
+	struct tc35892_gpio_platform_data *pdata = tc35892->pdata->gpio;
 	int irq = platform_get_irq(pdev, 0);
 	int ret;
 
+	if (pdata->remove)
+		pdata->remove(tc35892, tc35892_gpio->chip.base);
+
 	ret = gpiochip_remove(&tc35892_gpio->chip);
 	if (ret < 0) {
 		dev_err(tc35892_gpio->dev,
diff --git a/include/linux/mfd/tc35892.h b/include/linux/mfd/tc35892.h
index e47f770..eff3094 100644
--- a/include/linux/mfd/tc35892.h
+++ b/include/linux/mfd/tc35892.h
@@ -111,9 +111,13 @@ extern int tc35892_set_bits(struct tc35892 *tc35892, u8 reg, u8 mask, u8 val);
  * struct tc35892_gpio_platform_data - TC35892 GPIO platform data
  * @gpio_base: first gpio number assigned to TC35892.  A maximum of
  *	       %TC35892_NR_GPIOS GPIOs will be allocated.
+ * @setup: callback for board-specific initialization
+ * @remove: callback for board-specific teardown
  */
 struct tc35892_gpio_platform_data {
 	int gpio_base;
+	void (*setup)(struct tc35892 *tc35892, unsigned gpio_base);
+	void (*remove)(struct tc35892 *tc35892, unsigned gpio_base);
 };
 
 /**
-- 
1.7.2.dirty

