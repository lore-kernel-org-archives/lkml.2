Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab1G2HyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 03:54:07 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14996 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab1G2HyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 03:54:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 29 Jul 2011 00:54:04 -0700
From: Wei Ni <wni@nvidia.com>
To: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "mike@compulab.co.il" <mike@compulab.co.il>,
        Nitin Kumbhar <nkumbhar@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wei Ni <wni@nvidia.com>
Date: Fri, 29 Jul 2011 15:53:59 +0800
Subject: RE: [PATCH] mfd: tps6586x: add api to power off tps6586x
Thread-Topic: [PATCH] mfd: tps6586x: add api to power off tps6586x
Thread-Index: AcxM8APtsjYdo1KaShSxA6U5vowmFgA1FJwQ
Message-ID: <6B4D417B830BC44B8026029FD256F7F1C2CD7600BC@HKMAIL01.nvidia.com>
References: <1311834636-15940-1-git-send-email-wni@nvidia.com>
In-Reply-To: <1311834636-15940-1-git-send-email-wni@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p6T7sLVf015646

Could anyone review this patch?

Thanks
Wei.
nvpublic

>-----Original Message-----
>From: Wei Ni
>Sent: 2011å¹´7æœˆ28æ—¥ 14:31
>To: sameo@linux.intel.com; mike@compulab.co.il; gking@nvidia.com; Nitin Kumbhar
>Cc: linux-kernel@vger.kernel.org; Wei Ni
>Subject: [PATCH] mfd: tps6586x: add api to power off tps6586x
>
>From: Wei Ni <wni@nvidia.com>
>
>Add an api to put tps6586x in sleep mode by resetting EXITSLREQ and
>setting SLEEP_MODE in SUPPLYENE register. It will power off ldos.
>
>Signed-off-by: Wei Ni <wni@nvidia.com>
>Signed-off-by: Nitin Kumbhar <nkumbhar@nvidia.com>
>---
> drivers/mfd/tps6586x.c       |   29 +++++++++++++++++++++++++++++
> include/linux/mfd/tps6586x.h |    1 +
> 2 files changed, 30 insertions(+), 0 deletions(-)
>
>diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
>index bba26d9..d0eaa0a 100644
>--- a/drivers/mfd/tps6586x.c
>+++ b/drivers/mfd/tps6586x.c
>@@ -27,6 +27,10 @@
> #include <linux/mfd/core.h>
> #include <linux/mfd/tps6586x.h>
>
>+#define TPS6586X_SUPPLYENE	0x14
>+#define EXITSLREQ_BIT		BIT(1) /* Exit sleep mode request */
>+#define SLEEP_MODE_BIT		BIT(3) /* Sleep mode */
>+
> /* GPIO control registers */
> #define TPS6586X_GPIOSET1	0x5d
> #define TPS6586X_GPIOSET2	0x5e
>@@ -251,6 +255,29 @@ out:
> }
> EXPORT_SYMBOL_GPL(tps6586x_update);
>
>+static struct i2c_client *tps6586x_i2c_client;
>+int tps6586x_power_off(void)
>+{
>+	struct device *dev = NULL;
>+	int ret = -EINVAL;
>+
>+	if (!tps6586x_i2c_client)
>+		return ret;
>+
>+	dev = &tps6586x_i2c_client->dev;
>+
>+	ret = tps6586x_clr_bits(dev, TPS6586X_SUPPLYENE, EXITSLREQ_BIT);
>+	if (ret)
>+		return ret;
>+
>+	ret = tps6586x_set_bits(dev, TPS6586X_SUPPLYENE, SLEEP_MODE_BIT);
>+	if (ret)
>+		return ret;
>+
>+	return 0;
>+}
>+EXPORT_SYMBOL_GPL(tps6586x_power_off);
>+
> static int tps6586x_gpio_get(struct gpio_chip *gc, unsigned offset)
> {
> 	struct tps6586x *tps6586x = container_of(gc, struct tps6586x, gpio);
>@@ -525,6 +552,8 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
> 		goto err_add_devs;
> 	}
>
>+	tps6586x_i2c_client = client;
>+
> 	return 0;
>
> err_add_devs:
>diff --git a/include/linux/mfd/tps6586x.h b/include/linux/mfd/tps6586x.h
>index b6bab1b..cfbf387 100644
>--- a/include/linux/mfd/tps6586x.h
>+++ b/include/linux/mfd/tps6586x.h
>@@ -74,5 +74,6 @@ extern int tps6586x_set_bits(struct device *dev, int reg, uint8_t bit_mask);
> extern int tps6586x_clr_bits(struct device *dev, int reg, uint8_t bit_mask);
> extern int tps6586x_update(struct device *dev, int reg, uint8_t val,
> 			   uint8_t mask);
>+extern int tps6586x_power_off(void);
>
> #endif /*__LINUX_MFD_TPS6586X_H */
>--
>1.7.0

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
