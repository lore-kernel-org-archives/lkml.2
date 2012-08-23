Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030561Ab2HWPBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:01:50 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56817 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab2HWPBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:01:43 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, w.sang@pengutronix.de, Lee Jones <lee.jones@linaro.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH 3/3] i2c: nomadik: Add Device Tree support to the Nomadik I2C driver
Date: Thu, 23 Aug 2012 16:01:27 +0100
Message-Id: <1345734087-21803-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345734087-21803-1-git-send-email-lee.jones@linaro.org>
References: <1345734087-21803-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we apply the bindings required for successful Device Tree
probing of the i2c-nomadik driver.

Cc: linux-i2c@vger.kernel.org
Acked-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/i2c/busses/i2c-nomadik.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 61b00ed..8168389 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -25,6 +25,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/pm_runtime.h>
 #include <linux/platform_data/i2c-nomadik.h>
+#include <linux/of.h>
 
 #define DRIVER_NAME "nmk-i2c"
 
@@ -920,15 +921,42 @@ static struct nmk_i2c_controller u8500_i2c = {
 	.sm             = I2C_FREQ_MODE_FAST,
 };
 
+static void nmk_i2c_of_probe(struct device_node *np,
+			struct nmk_i2c_controller *pdata)
+{
+	/* Provide the default configuration as a base. */
+	pdata = &u8500_i2c;
+
+	of_property_read_u32(np, "clock-frequency", (u32*)&pdata->clk_freq);
+
+	/* This driver only supports 'standard' and 'fast' modes of operation. */
+	if (pdata->clk_freq <= 100000)
+		pdata->sm = I2C_FREQ_MODE_STANDARD;
+	else
+		pdata->sm = I2C_FREQ_MODE_FAST;
+}
+
 static atomic_t adapter_id = ATOMIC_INIT(0);
 
 static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 {
 	int ret = 0;
 	struct nmk_i2c_controller *pdata = adev->dev.platform_data;
+	struct device_node *np = adev->dev.of_node;
 	struct nmk_i2c_dev	*dev;
 	struct i2c_adapter *adap;
 
+	if (np) {
+		if (!pdata) {
+			pdata = devm_kzalloc(&adev->dev, sizeof(*pdata), GFP_KERNEL);
+			if (!pdata) {
+				ret = -ENOMEM;
+				goto err_no_mem;
+			}
+		}
+		nmk_i2c_of_probe(np, pdata);
+	}
+
 	if (!pdata)
 		/* No i2c configuration found, using the default. */
 		pdata = &u8500_i2c;
-- 
1.7.9.5

