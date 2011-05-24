Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab1EXQDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 12:03:10 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:57540 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab1EXQDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 12:03:06 -0400
X-Auth-Info: 1iBqXMm8nKfA8NafEyYEfjNk1xmN2s8aBtw02qMnXSw=
From: Anatolij Gustschin <agust@denx.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, dzu@denx.de, Anatolij Gustschin <agust@denx.de>
Subject: [PATCH 2/2] misc/eeprom: add eeprom access driver for digsy_mtc board
Date: Tue, 24 May 2011 18:02:43 +0200
Message-Id: <1306252963-20746-2-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1306252963-20746-1-git-send-email-agust@denx.de>
References: <1306252963-20746-1-git-send-email-agust@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both displays on digsy_mtc board obtain their configuration
from MicroWire EEPROMs which are connected to the SoC
over GPIO lines. We need an easy way to access the EEPROMs
to write the needed display configuration or to read out the
currently programmed configuration. The generic gpio-93xx46
driver added by previous patch allows EEPROM access over sysfs.
Using the simple driver added by this patch we provide used
GPIO interface and access control description on the board for
generic gpio-93xx46 driver.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/misc/eeprom/Kconfig            |   13 ++++++
 drivers/misc/eeprom/Makefile           |    1 +
 drivers/misc/eeprom/digsy_mtc_eeprom.c |   75 ++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/eeprom/digsy_mtc_eeprom.c

diff --git a/drivers/misc/eeprom/Kconfig b/drivers/misc/eeprom/Kconfig
index fcceffd..b74b402 100644
--- a/drivers/misc/eeprom/Kconfig
+++ b/drivers/misc/eeprom/Kconfig
@@ -80,4 +80,17 @@ config EEPROM_GPIO_93XX46
 
 	  If unsure, say N.
 
+config DIGSY_MTC_CFG_EEPROM
+	tristate "DigsyMTC display configuration EEPROMs device"
+	depends on PPC_MPC5200_GPIO
+	select EEPROM_GPIO_93XX46
+	help
+	  This option enables access to display configuration EEPROMs on
+	  digsy_mtc board. sysfs entries will be created for that EEPROM
+	  allowing to read/write the configuration data or to erase the
+	  whole EEPROM.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called digsy_mtc_eeprom.
+
 endmenu
diff --git a/drivers/misc/eeprom/Makefile b/drivers/misc/eeprom/Makefile
index 38d8259..cbbb282 100644
--- a/drivers/misc/eeprom/Makefile
+++ b/drivers/misc/eeprom/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_EEPROM_LEGACY)	+= eeprom.o
 obj-$(CONFIG_EEPROM_MAX6875)	+= max6875.o
 obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
 obj-$(CONFIG_EEPROM_GPIO_93XX46) += gpio-93xx46.o
+obj-$(CONFIG_DIGSY_MTC_CFG_EEPROM) += digsy_mtc_eeprom.o
diff --git a/drivers/misc/eeprom/digsy_mtc_eeprom.c b/drivers/misc/eeprom/digsy_mtc_eeprom.c
new file mode 100644
index 0000000..301d4bb
--- /dev/null
+++ b/drivers/misc/eeprom/digsy_mtc_eeprom.c
@@ -0,0 +1,75 @@
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/gpio.h>
+#include <linux/gpio-93xx46.h>
+#include <linux/platform_device.h>
+
+#define GPIO_EEPROM_OE	255
+
+static void digsy_mtc_op_prepare(void *p)
+{
+	/* enable */
+	gpio_set_value(GPIO_EEPROM_OE, 0);
+}
+
+static void digsy_mtc_op_finish(void *p)
+{
+	/* disable */
+	gpio_set_value(GPIO_EEPROM_OE, 1);
+}
+
+static const struct gpio_93xx46_platform_data digsy_mtc_93xx46_gpio = {
+	.clk		= 216,
+	.cs		= 210,
+	.din		= 217,
+	.dout		= 249,
+	.flags		= EE_ADDR8 | EE_CS_LOW,
+	.prepare	= digsy_mtc_op_prepare,
+	.finish		= digsy_mtc_op_finish,
+};
+
+struct platform_device *digsy_mtc_93xx46_device;
+
+static int __init digsy_mtc_93xx46_init(void)
+{
+	struct platform_device *pdev;
+	int ret;
+
+	pdev = platform_device_alloc("gpio-93xx46", 0);
+	if (!pdev)
+		return -ENOMEM;
+
+	ret = platform_device_add_data(pdev, &digsy_mtc_93xx46_gpio,
+				       sizeof(digsy_mtc_93xx46_gpio));
+	if (ret)
+		goto err;
+
+	ret = gpio_request_one(GPIO_EEPROM_OE, GPIOF_OUT_INIT_HIGH,
+				"93xx46 EEPROM OE");
+	if (ret)
+		goto err;
+
+	ret = platform_device_add(pdev);
+	if (ret)
+		goto err;
+
+	digsy_mtc_93xx46_device = pdev;
+	return 0;
+
+err:
+	platform_device_put(pdev);
+	return ret;
+}
+module_init(digsy_mtc_93xx46_init);
+
+static void __exit digsy_mtc_93xx46_exit(void)
+{
+	platform_device_unregister(digsy_mtc_93xx46_device);
+	digsy_mtc_93xx46_device = NULL;
+	gpio_free(GPIO_EEPROM_OE);
+}
+module_exit(digsy_mtc_93xx46_exit);
+
+MODULE_DESCRIPTION("DigsyMTC 93xx46 EEPROM device");
+MODULE_AUTHOR("Anatolij Gustschin <agust@denx.de>");
+MODULE_LICENSE("GPL");
-- 
1.7.1

