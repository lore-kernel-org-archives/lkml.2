Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab1HHDbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 23:31:31 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:50657 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753318Ab1HHDba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 23:31:30 -0400
Message-ID: <4E3F5817.2090405@metafoo.de>
Date: Mon, 08 Aug 2011 05:29:27 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Convert pcf50633 to use new register map API
References: <1312602304-21504-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1312602304-21504-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  #include <linux/mfd/pcf50633/core.h>
>  
[...]
>  /* Read a block of up to 32 regs  */
>  int pcf50633_read_block(struct pcf50633 *pcf, u8 reg,
>  					int nr_regs, u8 *data)
>  {
> -	int ret;
> -
> -	mutex_lock(&pcf->lock);
> -	ret = __pcf50633_read(pcf, reg, nr_regs, data);
> -	mutex_unlock(&pcf->lock);
> -
> -	return ret;
> +	return regmap_raw_read(pcf->regmap, reg, data, nr_regs);
>  }
>  EXPORT_SYMBOL_GPL(pcf50633_read_block);

There are callers which expect pcf50633_read_block to return the number of
bytes read. We could change the wrapper to return nr_regs if regmap_raw_read
returns 0. But I guess it is best to just update the callers. Incremental patch
which does this at the end of the mail.

>  
> @@ -69,23 +40,18 @@ EXPORT_SYMBOL_GPL(pcf50633_read_block);
>  int pcf50633_write_block(struct pcf50633 *pcf , u8 reg,
>  					int nr_regs, u8 *data)
>  {
> -	int ret;
> -
> -	mutex_lock(&pcf->lock);
> -	ret = __pcf50633_write(pcf, reg, nr_regs, data);
> -	mutex_unlock(&pcf->lock);
> -
> -	return ret;
> +	return regmap_raw_write(pcf->regmap, reg, data, nr_regs);
>  }
>  EXPORT_SYMBOL_GPL(pcf50633_write_block);
>  
>  u8 pcf50633_reg_read(struct pcf50633 *pcf, u8 reg)
>  {
> -	u8 val;
> +	unsigned int val;
> +	int ret;
>  
> -	mutex_lock(&pcf->lock);
> -	__pcf50633_read(pcf, reg, 1, &val);
> -	mutex_unlock(&pcf->lock);
> +	ret = regmap_read(pcf->regmap, reg, &val);
> +	if (ret < 0)
> +		return -1;
>  
>  	return val;
>  }
> @@ -93,56 +59,19 @@ EXPORT_SYMBOL_GPL(pcf50633_reg_read);
>  
>  int pcf50633_reg_write(struct pcf50633 *pcf, u8 reg, u8 val)
>  {
> -	int ret;
> -
> -	mutex_lock(&pcf->lock);
> -	ret = __pcf50633_write(pcf, reg, 1, &val);
> -	mutex_unlock(&pcf->lock);
> -
> -	return ret;
> +	return regmap_write(pcf->regmap, reg, val);
>  }
>  EXPORT_SYMBOL_GPL(pcf50633_reg_write);
>  
>  int pcf50633_reg_set_bit_mask(struct pcf50633 *pcf, u8 reg, u8 mask, u8 val)
>  {
> -	int ret;
> -	u8 tmp;
> -
> -	val &= mask;
> -
> -	mutex_lock(&pcf->lock);
> -	ret = __pcf50633_read(pcf, reg, 1, &tmp);
> -	if (ret < 0)
> -		goto out;
> -
> -	tmp &= ~mask;
> -	tmp |= val;
> -	ret = __pcf50633_write(pcf, reg, 1, &tmp);
> -
> -out:
> -	mutex_unlock(&pcf->lock);
> -
> -	return ret;
> +	return regmap_update_bits(pcf->regmap, reg, mask, val);
>  }
>  EXPORT_SYMBOL_GPL(pcf50633_reg_set_bit_mask);
>  
>  int pcf50633_reg_clear_bits(struct pcf50633 *pcf, u8 reg, u8 val)
>  {
> -	int ret;
> -	u8 tmp;
> -
> -	mutex_lock(&pcf->lock);
> -	ret = __pcf50633_read(pcf, reg, 1, &tmp);
> -	if (ret < 0)
> -		goto out;
> -
> -	tmp &= ~val;
> -	ret = __pcf50633_write(pcf, reg, 1, &tmp);
> -
> -out:
> -	mutex_unlock(&pcf->lock);
> -
> -	return ret;
> +	return regmap_update_bits(pcf->regmap, reg, val, 0);
>  }
>  EXPORT_SYMBOL_GPL(pcf50633_reg_clear_bits);

I would prefer making the wrappers static inline functions.

>  
> @@ -251,6 +180,11 @@ static int pcf50633_resume(struct device *dev)
>  
>  static SIMPLE_DEV_PM_OPS(pcf50633_pm, pcf50633_suspend, pcf50633_resume);
>  
> +static struct regmap_config pcf50633_regmap_config = {

const

> +	.reg_bits = 8,
> +	.val_bits = 8,
> +};
> +

------

diff --git a/drivers/base/regmap/regmap-i2c.c b/drivers/base/regmap/regmap-i2c.c
index c2231ff..ba107db 100644
--- a/drivers/base/regmap/regmap-i2c.c
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -70,6 +70,8 @@ static int regmap_i2c_read(struct device *dev,
 	struct i2c_msg xfer[2];
 	int ret;

+	printk("regmap_read: %d %d\n", reg_size, val_size);
+
 	xfer[0].addr = i2c->addr;
 	xfer[0].flags = 0;
 	xfer[0].len = reg_size;
diff --git a/drivers/mfd/pcf50633-irq.c b/drivers/mfd/pcf50633-irq.c
index 4b8269c..edc1897 100644
--- a/drivers/mfd/pcf50633-irq.c
+++ b/drivers/mfd/pcf50633-irq.c
@@ -96,7 +96,7 @@ static irqreturn_t pcf50633_irq(int irq, void *data)
 	/* Read the 5 INT regs in one transaction */
 	ret = pcf50633_read_block(pcf, PCF50633_REG_INT1,
 						ARRAY_SIZE(pcf_int), pcf_int);
-	if (ret != ARRAY_SIZE(pcf_int)) {
+	if (ret) {
 		dev_err(pcf->dev, "Error reading INT registers\n");

 		/*
diff --git a/drivers/rtc/rtc-pcf50633.c b/drivers/rtc/rtc-pcf50633.c
index b0dc8c2..5bcc8e2 100644
--- a/drivers/rtc/rtc-pcf50633.c
+++ b/drivers/rtc/rtc-pcf50633.c
@@ -114,9 +114,9 @@ static int pcf50633_rtc_read_time(struct device *dev,
 	ret = pcf50633_read_block(rtc->pcf, PCF50633_REG_RTCSC,
 					    PCF50633_TI_EXTENT,
 					    &pcf_tm.time[0]);
-	if (ret != PCF50633_TI_EXTENT) {
+	if (ret) {
 		dev_err(dev, "Failed to read time\n");
-		return -EIO;
+		return ret;
 	}

 	dev_dbg(dev, "PCF_TIME: %02x.%02x.%02x %02x:%02x:%02x\n",
@@ -186,9 +186,9 @@ static int pcf50633_rtc_read_alarm(struct device *dev,

 	ret = pcf50633_read_block(rtc->pcf, PCF50633_REG_RTCSCA,
 				PCF50633_TI_EXTENT, &pcf_tm.time[0]);
-	if (ret != PCF50633_TI_EXTENT) {
+	if (ret) {
 		dev_err(dev, "Failed to read time\n");
-		return -EIO;
+		return ret;
 	}

 	pcf2rtc_time(&alrm->time, &pcf_tm);
