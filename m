Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab2ICKHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 06:07:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60311 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab2ICKHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 06:07:08 -0400
Date: Mon, 3 Sep 2012 11:07:04 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 3/3] i2c: nomadik: Add Device Tree support to the Nomadik
 I2C driver
Message-ID: <20120903100656.GC5782@gmail.com>
References: <1345734087-21803-1-git-send-email-lee.jones@linaro.org>
 <1345734087-21803-3-git-send-email-lee.jones@linaro.org>
 <20120831112258.GA2624@pengutronix.de>
 <20120831122323.GC5962@gmail.com>
 <CACRpkdZ=C1EV4WO2b=1YLHPNhsDsQdq7Kfnpzm8i7uGRtVjJuQ@mail.gmail.com>
 <20120903094448.GB11780@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120903094448.GB11780@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Author: Lee Jones <lee.jones@linaro.org>
Date:   Mon Aug 6 11:09:57 2012 +0100

    i2c: nomadik: Add Device Tree support to the Nomadik I2C driver
    
    Here we apply the bindings required for successful Device Tree
    probing of the i2c-nomadik driver.
    
    Cc: linux-i2c@vger.kernel.org
    Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 61b00ed..c2da711 100644
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
+                       struct nmk_i2c_controller *pdata)
+{
+       of_property_read_u32(np, "clock-frequency", &pdata->clk_freq);
+
+       /* This driver only supports 'standard' and 'fast' modes of operation. */
+       if (pdata->clk_freq <= 100000)
+               pdata->sm = I2C_FREQ_MODE_STANDARD;
+       else
+               pdata->sm = I2C_FREQ_MODE_FAST;
+}
+
 static atomic_t adapter_id = ATOMIC_INIT(0);
 
 static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 {
        int ret = 0;
        struct nmk_i2c_controller *pdata = adev->dev.platform_data;
+       struct device_node *np = adev->dev.of_node;
        struct nmk_i2c_dev      *dev;
        struct i2c_adapter *adap;
 
+       if (np) {
+               if (!pdata) {
+                       pdata = devm_kzalloc(&adev->dev, sizeof(*pdata), GFP_KERNEL);
+                       if (!pdata) {
+                               ret = -ENOMEM;
+                               goto err_no_mem;
+                       }
+               }
+               /* Provide the default configuration as a base. */
+               memcpy(pdata, &u8500_i2c, sizeof(struct nmk_i2c_controller));
+
+               nmk_i2c_of_probe(np, pdata);
+       }
+
        if (!pdata)
                /* No i2c configuration found, using the default. */
                pdata = &u8500_i2c;
diff --git a/include/linux/platform_data/i2c-nomadik.h b/include/linux/platform_data/i2c-nomadik.h
index c2303c3..3a8be9c 100644
--- a/include/linux/platform_data/i2c-nomadik.h
+++ b/include/linux/platform_data/i2c-nomadik.h
@@ -28,7 +28,7 @@ enum i2c_freq_mode {
  * @sm:                speed mode
  */
 struct nmk_i2c_controller {
-       unsigned long   clk_freq;
+       u32             clk_freq;
        unsigned short  slsu;
        unsigned char   tft;
        unsigned char   rft;
