Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab3AICev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 21:34:51 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55691 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab3AICeu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 21:34:50 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@ingics.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFT] regulator: lp8788-ldo: Use ldo->en_pin to check if
 regulator is enabled by external pin
Thread-Topic: [PATCH RFT] regulator: lp8788-ldo: Use ldo->en_pin to check if
 regulator is enabled by external pin
Thread-Index: AQHN6xcHWa3VEY62mE+Yi0u7YatEY5g9Mk0AgAEcjACAAG76AIABjcaA
Date: Wed, 9 Jan 2013 02:34:40 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E1205F@DQHE02.ent.ti.com>
References: <1357371223.22227.1.camel@phoenix>
 <20130107110818.GB4544@opensource.wolfsonmicro.com>
 <CAFRkauBBHtjR+GYogpVPxBwGnoJD2==MUaqhZ6KOC7TJE4SpAA@mail.gmail.com>
 <20130108104356.GK4544@opensource.wolfsonmicro.com>
In-Reply-To: <20130108104356.GK4544@opensource.wolfsonmicro.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Tuesday, January 08, 2013 7:44 PM
> To: Axel Lin
> Cc: Kim, Milo; Girdwood, Liam; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH RFT] regulator: lp8788-ldo: Use ldo->en_pin to
> check if regulator is enabled by external pin
> 
> On Tue, Jan 08, 2013 at 12:06:44PM +0800, Axel Lin wrote:
> 
> > In this driver,
> > There is a case that one gpio controls more than one regulator.
> > e.g. ALDO2, ALDO3, ALDO4 are controlled by the same pin.
> 
> > It looks like current regulator core does not support this case.
> 
> Then the code to cope with this should be ported over to the core
> instead of being open coded in the driver.

Mark, could you review the code below?

This covers multiple regulators are enabled by shared one GPIO pin.
It doesn't look nice yet, but I'd like to get your feedback on this idea first.

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 0f65b24..f63bdf1 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3328,6 +3328,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	struct device *dev;
 	int ret, i;
 	const char *supply = NULL;
+	bool shared_ena_pin = false;
 
 	if (regulator_desc == NULL || config == NULL)
 		return ERR_PTR(-EINVAL);
@@ -3409,17 +3410,24 @@ regulator_register(const struct regulator_desc *regulator_desc,
 		if (ret != 0) {
 			rdev_err(rdev, "Failed to request enable GPIO%d: %d\n",
 				 config->ena_gpio, ret);
-			goto wash;
+
+			if (ret == -EBUSY && config->is_gpio_shared)
+				shared_ena_pin = true;
+
+			if (!shared_ena_pin)
+				goto wash;
 		}
 
-		rdev->ena_gpio = config->ena_gpio;
-		rdev->ena_gpio_invert = config->ena_gpio_invert;
+		if (!shared_ena_pin) {
+			rdev->ena_gpio = config->ena_gpio;
+			rdev->ena_gpio_invert = config->ena_gpio_invert;
 
-		if (config->ena_gpio_flags & GPIOF_OUT_INIT_HIGH)
-			rdev->ena_gpio_state = 1;
+			if (config->ena_gpio_flags & GPIOF_OUT_INIT_HIGH)
+				rdev->ena_gpio_state = 1;
 
-		if (rdev->ena_gpio_invert)
-			rdev->ena_gpio_state = !rdev->ena_gpio_state;
+			if (rdev->ena_gpio_invert)
+				rdev->ena_gpio_state = !rdev->ena_gpio_state;
+		}
 	}
 
 	/* set regulator constraints */
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index d10bb0f..fa0e4e5 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -241,6 +241,8 @@ struct regulator_desc {
  * @regmap: regmap to use for core regmap helpers if dev_get_regulator() is
  *          insufficient.
  * @ena_gpio: GPIO controlling regulator enable.
+ * @is_gpio_shared: Set true if enable GPIO is shared (multiple regulators are
+ *                 enabled by one GPIO pin).
  * @ena_gpio_invert: Sense for GPIO enable control.
  * @ena_gpio_flags: Flags to use when calling gpio_request_one()
  */
@@ -252,6 +254,7 @@ struct regulator_config {
 	struct regmap *regmap;
 
 	int ena_gpio;
+	bool is_gpio_shared;
 	unsigned int ena_gpio_invert:1;
 	unsigned int ena_gpio_flags;
 };

Thanks,
Milo
