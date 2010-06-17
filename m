Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623Ab0FQKdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 06:33:16 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57519 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab0FQKdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 06:33:14 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jun 2010 06:33:14 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LXBvhNZ1PE1cfTIUIhmZx7Eh6feSlJwtZ9Ci/18fsGNSw7f8Q635P4neAvQUKgY+TJ
         VGWsdEZiba40e6TaBuVNQMQItiRWQsScpPd/LKFOalm0TYvJjO1TsA81HKeJzu2aDB7P
         obE87tucTWGOQfD5JqVAcO8RG0H92mWUJQQL4=
MIME-Version: 1.0
In-Reply-To: <201006171123.31484.roman.fietze@telemotive.de>
References: <201006171123.31484.roman.fietze@telemotive.de>
Date: Thu, 17 Jun 2010 18:28:11 +0800
Message-ID: <AANLkTilPqFdeMLSabEkrwIQieJU0vhLnSBVe5_LH8x0G@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH] isl12022: added Intersil ISL12022 RTC
From: Wan ZongShun <mcuos.com@gmail.com>
To: rtc-linux@googlegroups.com, Roman Fietze <roman.fietze@telemotive.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman Fietze ,

Some minor comments inline.

2010/6/17 Roman Fietze <roman.fietze@telemotive.de>:
> Hello,
>
> We are using this on our MPC5200B board. Any comments on the code are
> welcome.
>
> From 7cf874201eb882beea406013bb38a8fcdd980782 Mon Sep 17 00:00:00 2001
> From: Roman Fietze <roman.fietze@telemotive.de>
> Date: Thu, 17 Jun 2010 10:57:13 +0200
> Subject: [PATCH] isl12022: added Intersil ISL12022 RTC
>
> - derived from rtc-pcf8563
> - no SRAM driver
>
> Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
> ---
>  drivers/rtc/Kconfig        |    9 ++
>  drivers/rtc/Makefile       |    1 +
>  drivers/rtc/rtc-isl12022.c |  312 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 322 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/rtc/rtc-isl12022.c
>
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index 6a13037..ade6427 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -203,6 +203,15 @@ config RTC_DRV_ISL1208
>          This driver can also be built as a module. If so, the module
>          will be called rtc-isl1208.
>
> +config RTC_DRV_ISL12022
> +       tristate "Intersil ISL12022"
> +       help
> +         If you say yes here you get support for the
> +         Intersil ISL12022 RTC chip.
> +
> +         This driver can also be built as a module. If so, the module
> +         will be called rtc-isl12022.
> +
>  config RTC_DRV_X1205
>        tristate "Xicor/Intersil X1205"
>        help
> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
> index 44ef194..782d516 100644
> --- a/drivers/rtc/Makefile
> +++ b/drivers/rtc/Makefile
> @@ -45,6 +45,7 @@ obj-$(CONFIG_RTC_DRV_EP93XX)  += rtc-ep93xx.o
>  obj-$(CONFIG_RTC_DRV_FM3130)   += rtc-fm3130.o
>  obj-$(CONFIG_RTC_DRV_GENERIC)  += rtc-generic.o
>  obj-$(CONFIG_RTC_DRV_ISL1208)  += rtc-isl1208.o
> +obj-$(CONFIG_RTC_DRV_ISL12022) += rtc-isl12022.o
>  obj-$(CONFIG_RTC_DRV_M41T80)   += rtc-m41t80.o
>  obj-$(CONFIG_RTC_DRV_M41T94)   += rtc-m41t94.o
>  obj-$(CONFIG_RTC_DRV_M48T35)   += rtc-m48t35.o
> diff --git a/drivers/rtc/rtc-isl12022.c b/drivers/rtc/rtc-isl12022.c
> new file mode 100644
> index 0000000..e0a340f
> --- /dev/null
> +++ b/drivers/rtc/rtc-isl12022.c
> @@ -0,0 +1,312 @@
> +/*
> + * An I2C driver for the Intersil ISL 12022
> + *
> + * Author: Roman Fietze <roman.fietze@telemotive.de>
> + *
> + * Based on the Philips PCF8563 RTC
> + * by Alessandro Zummo <a.zummo@towertech.it>.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/bcd.h>
> +#include <linux/rtc.h>
> +#include <linux/slab.h>
> +
> +#define DRV_VERSION "0.1"
> +
> +/* ISL register offsets */
> +#define ISL12022_REG_SC                0x00
> +#define ISL12022_REG_MN                0x01
> +#define ISL12022_REG_HR                0x02
> +#define ISL12022_REG_DT                0x03
> +#define ISL12022_REG_MO                0x04
> +#define ISL12022_REG_YR                0x05
> +#define ISL12022_REG_DW                0x06
> +
> +#define ISL12022_REG_SR                0x07
> +#define ISL12022_REG_INT       0x08
> +
> +/* ISL register bits */
> +#define ISL12022_HR_MIL                (1 << 7)        /* military or 24 hour time */
> +
> +#define ISL12022_SR_LBAT85     (1 << 2)
> +#define ISL12022_SR_LBAT75     (1 << 1)
> +
> +#define ISL12022_INT_WRTC      (1 << 6)
> +
> +
> +static struct i2c_driver isl12022_driver;
> +
> +struct isl12022 {
> +       struct rtc_device *rtc;
> +
> +       bool write_enabled;     /* true if write enable is set */
> +};
> +
> +
> +static int isl12022_read_regs(struct i2c_client *client, uint8_t reg, uint8_t *data, size_t n)
> +{
> +       struct i2c_msg msgs[] = {
> +               {
> +                       .addr   = client->addr,
> +                       .flags  = 0,
> +                       .len    = 1,
> +                       .buf    = data
> +               },              /* setup read ptr */
> +               {
> +                       .addr   = client->addr,
> +                       .flags  = I2C_M_RD,
> +                       .len    = n,
> +                       .buf    = data
> +               }
> +       };
> +
> +       int ret;
> +
> +       data[0] = reg;
> +       ret = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
> +       if (ret != ARRAY_SIZE(msgs)) {
> +               dev_err(&client->dev, "%s: read error, ret=%d\n", __func__, ret);
> +               return -EIO;
> +       }
> +
> +       return 0;
> +}
> +
> +
> +static int isl12022_write_reg(struct i2c_client *client, uint8_t reg, uint8_t val)
> +{
> +       uint8_t data[2] = { reg, val };
> +       int err;
> +
> +       err = i2c_master_send(client, data, sizeof(data));
> +       if (err != sizeof(data)) {
> +               dev_err(&client->dev,
> +                       "%s: err=%d addr=%02x, data=%02x\n",
> +                       __func__, err, data[0], data[1]);
> +               return -EIO;
> +       }
> +
> +       return 0;
> +}
> +
> +
> +/*
> + * In the routines that deal directly with the isl12022 hardware, we use
> + * rtc_time -- month 0-11, hour 0-23, yr = calendar year-epoch.
> + */
> +static int isl12022_get_datetime(struct i2c_client *client, struct rtc_time *tm)
> +{
> +       uint8_t buf[ISL12022_REG_INT + 1];
> +       int ret;
> +
> +       ret = isl12022_read_regs(client, ISL12022_REG_SC, buf, sizeof(buf));
> +       if (ret)
> +               return ret;
> +
> +       if (buf[ISL12022_REG_SR] & (ISL12022_SR_LBAT85 | ISL12022_SR_LBAT75)) {
> +               dev_warn(&client->dev,
> +                        "voltage dropped below %u%%, date and time is not reliable.\n",
> +                        buf[ISL12022_REG_SR] & ISL12022_SR_LBAT85 ? 85 : 75);
> +       }
> +
> +       dev_dbg(&client->dev,
> +               "%s: raw data is sec=%02x, min=%02x, hr=%02x, "
> +               "mday=%02x, mon=%02x, year=%02x, wday=%02x, "
> +               "sr=%02x, int=%02x",
> +               __func__,
> +               buf[ISL12022_REG_SC], buf[ISL12022_REG_MN], buf[ISL12022_REG_HR],
> +               buf[ISL12022_REG_DT], buf[ISL12022_REG_MO], buf[ISL12022_REG_YR],
> +               buf[ISL12022_REG_DW],
> +               buf[ISL12022_REG_SR], buf[ISL12022_REG_INT]);
> +
> +       tm->tm_sec = bcd2bin(buf[ISL12022_REG_SC] & 0x7F);
> +       tm->tm_min = bcd2bin(buf[ISL12022_REG_MN] & 0x7F);
> +       tm->tm_hour = bcd2bin(buf[ISL12022_REG_HR] & 0x3F);
> +       tm->tm_mday = bcd2bin(buf[ISL12022_REG_DT] & 0x3F);
> +       tm->tm_wday = buf[ISL12022_REG_DW] & 0x07;
> +       tm->tm_mon = bcd2bin(buf[ISL12022_REG_MO] & 0x1F) - 1;
> +       tm->tm_year = bcd2bin(buf[ISL12022_REG_YR]) + 100;
> +
> +       dev_dbg(&client->dev, "%s: secs=%d, mins=%d, hours=%d, "
> +               "mday=%d, mon=%d, year=%d, wday=%d\n",
> +               __func__,
> +               tm->tm_sec, tm->tm_min, tm->tm_hour,
> +               tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
> +
> +       /* The clock can give out invalid datetime, but we cannot
> +        * return -EINVAL otherwise hwclock will refuse to set the
> +        * time on bootup. */
> +       if (rtc_valid_tm(tm) < 0)
> +               dev_err(&client->dev, "retrieved date and time is invalid.\n");
> +
> +       return 0;
> +}
> +
> +static int isl12022_set_datetime(struct i2c_client *client, struct rtc_time *tm)
> +{
> +       struct isl12022 *isl12022 = i2c_get_clientdata(client);
> +       size_t i;
> +       int ret;
> +       uint8_t buf[ISL12022_REG_DW + 1];
> +
> +       dev_dbg(&client->dev, "%s: secs=%d, mins=%d, hours=%d, "
> +               "mday=%d, mon=%d, year=%d, wday=%d\n",
> +               __func__,
> +               tm->tm_sec, tm->tm_min, tm->tm_hour,
> +               tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
> +
> +       if (!isl12022->write_enabled) {
> +
> +               ret = isl12022_read_regs(client, ISL12022_REG_INT, buf, 1);
> +               if (ret)
> +                       return ret;
> +
> +               /* Check if WRTC (write rtc enable) is set factory default is 0 (not set) */
> +               if (!(buf[0] & ISL12022_INT_WRTC))
> +               {
> +                       dev_info(&client->dev, "init write enable and 24 hour format\n");
> +
> +                       /* Set the write enable bit. */
> +                       ret = isl12022_write_reg(client, ISL12022_REG_INT, buf[0] | ISL12022_INT_WRTC);
> +                       if (ret)
> +                               return ret;
> +
> +                       /* Write to any RTC register to start RTC, we use the HR register, setting
> +                        * the MIL bit to use the 24 hour format. */
> +                       ret = isl12022_read_regs(client, ISL12022_REG_HR, buf, 1);
> +                       if (ret)
> +                               return ret;
> +                       ret = isl12022_write_reg(client, ISL12022_REG_HR, buf[0] | ISL12022_HR_MIL);
> +                       if (ret)
> +                               return ret;
> +               }
> +
> +               isl12022->write_enabled = 1;
> +       }
> +
> +       /* hours, minutes and seconds */
> +       buf[ISL12022_REG_SC] = bin2bcd(tm->tm_sec);
> +       buf[ISL12022_REG_MN] = bin2bcd(tm->tm_min);
> +       buf[ISL12022_REG_HR] = bin2bcd(tm->tm_hour);
> +
> +       buf[ISL12022_REG_DT] = bin2bcd(tm->tm_mday);
> +
> +       /* month, 1 - 12 */
> +       buf[ISL12022_REG_MO] = bin2bcd(tm->tm_mon + 1);
> +
> +       /* year and century */
> +       buf[ISL12022_REG_YR] = bin2bcd(tm->tm_year % 100);
> +
> +       buf[ISL12022_REG_DW] = tm->tm_wday & 0x07;
> +
> +       /* write register's data */
> +       for (i = 0; i < ARRAY_SIZE(buf); i++) {
> +               ret = isl12022_write_reg(client, ISL12022_REG_SC + i, buf[ISL12022_REG_SC + i]);
> +               if (ret)
> +                       return -EIO;
> +       };
> +
> +       return 0;
> +}
> +
> +static int isl12022_rtc_read_time(struct device *dev, struct rtc_time *tm)
> +{
> +       return isl12022_get_datetime(to_i2c_client(dev), tm);
> +}
> +
> +static int isl12022_rtc_set_time(struct device *dev, struct rtc_time *tm)
> +{
> +       return isl12022_set_datetime(to_i2c_client(dev), tm);
> +}
> +
> +static const struct rtc_class_ops isl12022_rtc_ops = {
> +       .read_time      = isl12022_rtc_read_time,
> +       .set_time       = isl12022_rtc_set_time,
> +};
> +
> +static int isl12022_probe(struct i2c_client *client,
> +                         const struct i2c_device_id *id)
> +{
> +       struct isl12022 *isl12022;
> +
> +       int ret = 0;
> +
> +       dev_dbg(&client->dev, "%s\n", __func__);
> +
> +       if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
> +               return -ENODEV;
> +
> +       isl12022 = kzalloc(sizeof(struct isl12022), GFP_KERNEL);
> +       if (!isl12022)
> +               return -ENOMEM;
> +
> +       dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
> +

There is no need to print your private driver info in Kernel, please
get rid of it.

> +       i2c_set_clientdata(client, isl12022);
> +
> +       isl12022->rtc = rtc_device_register(isl12022_driver.driver.name,
> +                                           &client->dev, &isl12022_rtc_ops, THIS_MODULE);
> +
> +       if (IS_ERR(isl12022->rtc)) {
> +               ret = PTR_ERR(isl12022->rtc);
> +               goto exit_kfree;
> +       }
> +
> +       return 0;
> +
> +exit_kfree:
> +       kfree(isl12022);
> +
> +       return ret;
> +}
> +
> +static int isl12022_remove(struct i2c_client *client)
> +{
> +       struct isl12022 *isl12022 = i2c_get_clientdata(client);
> +
> +       if (isl12022->rtc)
> +               rtc_device_unregister(isl12022->rtc);

'isl12022->rtc' can't be NULL in remove(), there is no need to check it.

> +
> +       kfree(isl12022);
> +
> +       return 0;
> +}
> +
> +static const struct i2c_device_id isl12022_id[] = {
> +       { "isl12022", 0 },
> +       { "rtc8564", 0 },
> +       { }
> +};
> +MODULE_DEVICE_TABLE(i2c, isl12022_id);
> +
> +static struct i2c_driver isl12022_driver = {
> +       .driver         = {
> +               .name   = "rtc-isl12022",
> +       },
> +       .probe          = isl12022_probe,
> +       .remove         = isl12022_remove,
> +       .id_table       = isl12022_id,
> +};
> +
> +static int __init isl12022_init(void)
> +{
> +       return i2c_add_driver(&isl12022_driver);
> +}
> +
> +static void __exit isl12022_exit(void)
> +{
> +       i2c_del_driver(&isl12022_driver);
> +}
> +
> +MODULE_AUTHOR("roman.fietze@telemotive.de");
> +MODULE_DESCRIPTION("ISL 12022 RTC driver");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION(DRV_VERSION);
> +

Please put MODULE_XXX at the end.

> +module_init(isl12022_init);
> +module_exit(isl12022_exit);
> --
> 1.7.1
>
>
>
> --
> Roman Fietze                Telemotive AG Büro Mühlhausen
> Breitwiesen                              73347 Mühlhausen
> Tel.: +49(0)7335/18493-45        http://www.telemotive.de
>
> --
> You received this message because you are subscribed to "rtc-linux".
> Membership options at http://groups.google.com/group/rtc-linux .
> Please read http://groups.google.com/group/rtc-linux/web/checklist
> before submitting a driver.



-- 
*linux-arm-kernel mailing list
mail addr:linux-arm-kernel@lists.infradead.org
you can subscribe by:
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

* linux-arm-NUC900 mailing list
mail addr:NUC900@googlegroups.com
main web: https://groups.google.com/group/NUC900
you can subscribe it by sending me mail:
mcuos.com@gmail.com
