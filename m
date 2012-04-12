Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762357Ab2DLStA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:49:00 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44852 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289Ab2DLSpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:45:22 -0400
Date: Thu, 12 Apr 2012 20:45:25 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 06/13] s5p-tv: Add initial DT-support for SiI9234
In-reply-to: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, thomas.abraham@linaro.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, olof@lixom.net, kgene.kim@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Message-id: <1334256332-29867-7-git-send-email-k.lewandowsk@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.9.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it possible to instantiate SiI9234, Mobile HD Link driver (MHL),
from regular device tree description.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 .../devicetree/bindings/i2c/sil-mhl9234.txt        |   14 +++++++++++++
 drivers/media/video/s5p-tv/sii9234_drv.c           |   21 +++++++++++++++++++-
 2 files changed, 34 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/sil-mhl9234.txt

diff --git a/Documentation/devicetree/bindings/i2c/sil-mhl9234.txt b/Documentation/devicetree/bindings/i2c/sil-mhl9234.txt
new file mode 100644
index 0000000..b5d92ea
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/sil-mhl9234.txt
@@ -0,0 +1,14 @@
+* Silicon Image Mobile HD Link (MHL) 9234
+
+Required properties :
+ - compatible : "sil,mhl-9234"
+ - reg        : i2c device address
+ - gpio-reset : gpio line used to reset IC
+
+Example:
+
+	mhl@39 {
+		compatible = "sil,mhl-9234";
+		reg = <0x39>;
+		gpio-reset = <&gpf3 4 0 0 0>;
+	};
diff --git a/drivers/media/video/s5p-tv/sii9234_drv.c b/drivers/media/video/s5p-tv/sii9234_drv.c
index 0f31ecc..05df5e8 100644
--- a/drivers/media/video/s5p-tv/sii9234_drv.c
+++ b/drivers/media/video/s5p-tv/sii9234_drv.c
@@ -22,6 +22,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/regulator/machine.h>
 #include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
 
 #include <mach/gpio.h>
 #include <plat/gpio-cfg.h>
@@ -338,7 +340,16 @@ static int __devinit sii9234_probe(struct i2c_client *client,
 		goto fail_ctx;
 	}
 
-	ctx->gpio_n_reset = pdata->gpio_n_reset;
+	if (dev->of_node) {
+		ctx->gpio_n_reset = of_get_named_gpio(dev->of_node, "gpio-reset", 0);
+		if (!gpio_is_valid(ctx->gpio_n_reset)) {
+			ret = -ENODEV;
+			goto fail_power;
+		}
+	} else {
+		ctx->gpio_n_reset = pdata->gpio_n_reset;
+	}
+
 	ret = gpio_request(ctx->gpio_n_reset, "MHL_RST");
 	if (ret) {
 		dev_err(dev, "failed to acquire MHL_RST gpio\n");
@@ -401,6 +412,13 @@ static int __devexit sii9234_remove(struct i2c_client *client)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id sii9234_dt_match[] = {
+	{ .compatible = "sil,mhl-9234" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, sii9234_dt_match);
+#endif
 
 static const struct i2c_device_id sii9234_id[] = {
 	{ "SII9234", 0 },
@@ -413,6 +431,7 @@ static struct i2c_driver sii9234_driver = {
 		.name	= "sii9234",
 		.owner	= THIS_MODULE,
 		.pm = &sii9234_pm_ops,
+		.of_match_table = of_match_ptr(sii9234_dt_match),
 	},
 	.probe		= sii9234_probe,
 	.remove		= __devexit_p(sii9234_remove),
-- 
1.7.9.1

