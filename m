Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab0FFOkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 10:40:39 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49722 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab0FFOki convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 10:40:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ILy37hUe2w6+ZqoxJPv/4cywNBZquzp07wr+En5DzQOQqKGtnXcb83mbPwUhk+0vXD
         NT72AZlHnKHJFUYeoyhMh2JcCyXV85JYNUFIsab8XV7MzOP8pm+FEoC/o/ZOA+ufvTMf
         JfKWiIN9Gej+ggIzvIdHNfBcvh8w8cKB0+xoA=
MIME-Version: 1.0
In-Reply-To: <1269508155-9432-1-git-send-email-gregory.hermant@calao-systems.com>
References: <1269508155-9432-1-git-send-email-gregory.hermant@calao-systems.com>
Date: Sun, 6 Jun 2010 22:40:36 +0800
Message-ID: <AANLkTimA4b6lPK_Xk-Z_-89byR0mzrcNgF9UjNK5C1DE@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH] Add rv3029c2 RTC support
From: Wan ZongShun <mcuos.com@gmail.com>
To: rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,

Your patch has been hung for long time.
I didnot know whether you still want it be merged?

2010/3/25 Gregory Hermant <gregory.hermant@calao-systems.com>:
>
> Signed-off-by: Gregory Hermant <gregory.hermant@calao-systems.com>
> ---
>  drivers/rtc/Kconfig        |    9 +
>  drivers/rtc/Makefile       |    1 +
>  drivers/rtc/rtc-rv3029c2.c |  380 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 390 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/rtc/rtc-rv3029c2.c
>
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index 6a13037..9eb256a 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -324,6 +324,15 @@ config RTC_DRV_RX8025
>          This driver can also be built as a module. If so, the module
>          will be called rtc-rx8025.
>
> +config RTC_DRV_RV3029C2
> +       tristate "Micro-crytal RTC"
> +       help
> +         If you say yes here you get support for the Micro-crystal
> +         RV3029-C2 RTC chips.
> +
> +         This driver can also be built as a module. If so, the module
> +         will be called rtc-rv3029c2.
> +
>  endif # I2C
>
>  comment "SPI RTC drivers"
> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
> index 44ef194..2f6a729 100644
> --- a/drivers/rtc/Makefile
> +++ b/drivers/rtc/Makefile
> @@ -74,6 +74,7 @@ obj-$(CONFIG_RTC_DRV_RP5C01)  += rtc-rp5c01.o
>  obj-$(CONFIG_RTC_DRV_RS5C313)  += rtc-rs5c313.o
>  obj-$(CONFIG_RTC_DRV_RS5C348)  += rtc-rs5c348.o
>  obj-$(CONFIG_RTC_DRV_RS5C372)  += rtc-rs5c372.o
> +obj-$(CONFIG_RTC_DRV_RV3029C2) += rtc-rv3029c2.o
>  obj-$(CONFIG_RTC_DRV_RX8025)   += rtc-rx8025.o
>  obj-$(CONFIG_RTC_DRV_RX8581)   += rtc-rx8581.o
>  obj-$(CONFIG_RTC_DRV_S35390A)  += rtc-s35390a.o
> diff --git a/drivers/rtc/rtc-rv3029c2.c b/drivers/rtc/rtc-rv3029c2.c
> new file mode 100644
> index 0000000..3e61530
> --- /dev/null
> +++ b/drivers/rtc/rtc-rv3029c2.c
> @@ -0,0 +1,380 @@
> +/*
> + * Mcrystal RV-3029C2 rtc class driver
> + *
> + * Author: Gregory Hermant <gregory.hermant@calao-systems.com>
> + *
> + * based on previously existing rtc class drivers
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * NOTE: Currently this driver only supports the bare minimum for read
> + * and write the RTC. The extra features provided by this chip
> + * (alarms, trickle charger, eeprom, T° compensation) are unavailable.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/bcd.h>
> +#include <linux/rtc.h>
> +
> +#define DRV_VERSION "0.1"
> +
> +/* Register map */
> +/* control section */
> +#define RV3029C2_ONOFF_CTRL            0x00
> +#define RV3029C2_IRQ_CTRL              0x01
> +#define RV3029C2_IRQ_FLAGS             0x02
> +#define RV3029C2_STATUS                        0x03
> +#define RV3029C2_STATUS_VLOW1          (1 << 2)
> +#define RV3029C2_STATUS_VLOW2          (1 << 3)
> +#define RV3029C2_STATUS_SR             (1 << 4)
> +#define RV3029C2_STATUS_EEBUSY         (1 << 7)
> +#define RV3029C2_RST_CTRL              0x04
> +#define RV3029C2_CONTROL_SECTION_LEN   0x05
> +
> +/* watch section */
> +#define RV3029C2_W_SECONDS             0x08
> +#define RV3029C2_W_MINUTES             0x09
> +#define RV3029C2_W_HOURS               0x0A
> +#define RV3029C2_REG_HR_12_24          (1<<6)  /* 24h/12h mode */
> +#define RV3029C2_REG_HR_PM             (1<<5)  /* PM/AM bit in 12h mode */
> +#define RV3029C2_W_DATE                        0x0B
> +#define RV3029C2_W_DAYS                        0x0C
> +#define RV3029C2_W_MONTHS              0x0D
> +#define RV3029C2_W_YEARS               0x0E
> +#define RV3029C2_WATCH_SECTION_LEN     0x07
> +
> +/* alarm section */
> +#define RV3029C2_A_SC                  0x10
> +#define RV3029C2_A_MN                  0x11
> +#define RV3029C2_A_HR                  0x12
> +#define RV3029C2_A_DT                  0x13
> +#define RV3029C2_A_DW                  0x14
> +#define RV3029C2_A_MO                  0x15
> +#define RV3029C2_A_YR                  0x16
> +#define RV3029C2_ALARM_SECTION_LEN     0x07
> +
> +/* timer section */
> +#define RV3029C2_TIMER_LOW                     0x18
> +#define RV3029C2_TIMER_HIGH                    0x19
> +
> +/* temperature section */
> +#define RV3029C2_TEMP_PAGE                     0x20
> +
> +/* eeprom data section */
> +#define RV3029C2_E2P_EEDATA1                   0x28
> +#define RV3029C2_E2P_EEDATA2                   0x29
> +
> +/* eeprom control section */
> +#define RV3029C2_CONTROL_E2P_EECTRL            0x30
> +#define RV3029C2_TRICKLE_1K                    (1<<0)  /*  1K resistance */
> +#define RV3029C2_TRICKLE_5K                    (1<<1)  /*  5K resistance */
> +#define RV3029C2_TRICKLE_20K                   (1<<2)  /* 20K resistance */
> +#define RV3029C2_TRICKLE_80K                   (1<<3)  /* 80K resistance */
> +#define RV3029C2_CONTROL_E2P_XTALOFFSET                0x31
> +#define RV3029C2_CONTROL_E2P_QCOEF             0x32
> +#define RV3029C2_CONTROL_E2P_TURNOVER          0x33
> +
> +/* user ram section */
> +#define RV3029C2_USR1_RAM_PAGE                 0x38
> +#define RV3029C2_USR1_SECTION_LEN              0x04
> +#define RV3029C2_USR2_RAM_PAGE                 0x3C
> +#define RV3029C2_USR2_SECTION_LEN              0x04
> +

>From 'timer section' to here, all the Micro definitions format should
be alignment,
I think it looks like good, if so.

> +static struct i2c_driver rv3029c2_driver;
> +
> +static int
> +rv3029c2_i2c_read_regs(struct i2c_client *client, u8 reg, u8 *buf,
> +                       unsigned len)
> +{
> +       u8 reg_addr[1] = { reg } ;
> +       struct i2c_msg msgs[2] = {
> +               {client->addr, 0, sizeof(reg_addr), reg_addr}
> +               ,
> +               {client->addr, I2C_M_RD, len, buf}
> +       };
> +       int ret;
> +
> +       BUG_ON(reg > RV3029C2_USR1_RAM_PAGE + 7);
> +       BUG_ON(reg + len > RV3029C2_USR1_RAM_PAGE + 8);
> +
> +       ret = i2c_transfer(client->adapter, msgs, 2);
> +       if (ret > 0)
> +               ret = 0;
> +       return ret;
> +}
> +
> +static int
> +rv3029c2_i2c_write_regs(struct i2c_client *client, u8 reg, u8 const buf[],
> +                       unsigned len)
> +{
> +       u8 i2c_buf[8];
> +       struct i2c_msg msgs[1] = {
> +               {client->addr, 0, len + 1, i2c_buf}
> +       };
> +       int ret;
> +
> +       BUG_ON(reg > RV3029C2_USR1_RAM_PAGE + 7);
> +       BUG_ON(reg + len > RV3029C2_USR1_RAM_PAGE + 8);
> +
> +       i2c_buf[0] = reg;
> +       memcpy(&i2c_buf[1], &buf[0], len);
> +       ret = i2c_transfer(client->adapter, msgs, 1);
> +       if (ret > 0)
> +               ret = 0;
> +       return ret;
> +}
> +
> +/* simple check to see if we have a rv3029c2 */
> +static int
> +rv3029c2_i2c_validate_client(struct i2c_client *client)
> +{
> +       u8 regs[RV3029C2_WATCH_SECTION_LEN] = { 0, };
> +       u8 zero_mask[RV3029C2_WATCH_SECTION_LEN] = {
> +               0x80, 0x80, 0x80, 0xc0, 0xf8, 0xe0, 0x80
> +       };
> +       int i;
> +       int ret;
> +
> +       ret = rv3029c2_i2c_read_regs(client, RV3029C2_W_SECONDS, regs,
> +                                       RV3029C2_WATCH_SECTION_LEN);
> +       if (ret < 0)
> +               return ret;
> +
> +       for (i = 0; i < RV3029C2_WATCH_SECTION_LEN; ++i) {
> +               if (regs[i] & zero_mask[i])     /* check if bits are cleared */
> +                       return -ENODEV;
> +       }
> +
> +       return 0;
> +}
> +
> +static int
> +rv3029c2_i2c_get_sr(struct i2c_client *client)
> +{
> +       u8 buf[1] = { 0, };
> +       int sr = rv3029c2_i2c_read_regs(client, RV3029C2_STATUS, buf, 1);
> +       printk(KERN_INFO "status = 0x%.2x (%d)\n", buf[0], buf[0]);

Please don't use printk directly, the dev_[warn/err] is preferd.

> +       if (sr < 0)
> +               return -EIO;
> +       return sr;
> +}
> +
> +static int
> +rv3029c2_i2c_read_time(struct i2c_client *client, struct rtc_time *tm)
> +{
> +       int sr;
> +       u8 regs[RV3029C2_WATCH_SECTION_LEN] = { 0, };
> +
> +       sr = rv3029c2_i2c_get_sr(client);
> +       if (sr < 0) {
> +               dev_err(&client->dev, "%s: reading SR failed\n", __func__);
> +               return -EIO;
> +       }
> +
> +       sr = rv3029c2_i2c_read_regs(client, RV3029C2_W_SECONDS , regs,
> +                                       RV3029C2_WATCH_SECTION_LEN);
> +       if (sr < 0) {
> +               dev_err(&client->dev, "%s: reading RTC section failed\n",
> +                       __func__);
> +               return sr;
> +       }
> +
> +       tm->tm_sec = bcd2bin(regs[RV3029C2_W_SECONDS-RV3029C2_W_SECONDS]);
> +       tm->tm_min = bcd2bin(regs[RV3029C2_W_MINUTES-RV3029C2_W_SECONDS]);
> +
> +       /* HR field has a more complex interpretation */
> +       {
> +               const u8 _hr = regs[RV3029C2_W_HOURS-RV3029C2_W_SECONDS];
> +               if (_hr & RV3029C2_REG_HR_12_24)        /* 24h format */
> +                       tm->tm_hour = bcd2bin(_hr & 0x3f);
> +               else {
> +                       /* 12h format */
> +                       tm->tm_hour = bcd2bin(_hr & 0x1f);
> +                       if (_hr & RV3029C2_REG_HR_PM)   /* PM flag set */
> +                               tm->tm_hour += 12;
> +               }
> +       }
> +
> +       tm->tm_mday = bcd2bin(regs[RV3029C2_W_DATE-RV3029C2_W_SECONDS]);
> +       tm->tm_mon = bcd2bin(regs[RV3029C2_W_MONTHS-RV3029C2_W_SECONDS])-1 ;
> +       tm->tm_year = bcd2bin(regs[RV3029C2_W_YEARS-RV3029C2_W_SECONDS])+100;
> +       tm->tm_wday = bcd2bin(regs[RV3029C2_W_DAYS-RV3029C2_W_SECONDS])-1;
> +

When returning 'tm' value, please take advantage of 'rtc_valid_tm(tm)'
to check it.

> +       return 0;
> +}
> +
> +static int rv3029c2_rtc_read_time(struct device *dev, struct rtc_time *tm)
> +{
> +       return rv3029c2_i2c_read_time(to_i2c_client(dev), tm);
> +}
> +
> +static int
> +rv3029c2_i2c_read_alarm(struct i2c_client *client, struct rtc_wkalrm *alarm)
> +{
> +       struct rtc_time *const tm = &alarm->time;
> +       int sr;
> +       u8 regs[8];
> +
> +       sr = rv3029c2_i2c_get_sr(client);
> +       if (sr < 0) {
> +               dev_err(&client->dev, "%s: reading SR failed\n", __func__);
> +               return -EIO;
> +       }
> +
> +       sr = rv3029c2_i2c_read_regs(client, RV3029C2_A_SC, regs,
> +                                       RV3029C2_ALARM_SECTION_LEN);
> +
> +       if (sr < 0) {
> +               dev_err(&client->dev, "%s: reading alarm section failed\n",
> +                       __func__);
> +               return sr;
> +       }
> +
> +       tm->tm_sec = bcd2bin(regs[RV3029C2_A_SC-RV3029C2_A_SC] & 0x7f);
> +       tm->tm_min = bcd2bin(regs[RV3029C2_A_MN-RV3029C2_A_SC] & 0x7f);
> +       tm->tm_hour = bcd2bin(regs[RV3029C2_A_HR-RV3029C2_A_SC] & 0x3f);
> +       tm->tm_mday = bcd2bin(regs[RV3029C2_A_DT-RV3029C2_A_SC] & 0x3f);
> +       tm->tm_mon = bcd2bin(regs[RV3029C2_A_MO-RV3029C2_A_SC] & 0x1f) - 1;
> +       tm->tm_year = bcd2bin(regs[RV3029C2_A_YR-RV3029C2_A_SC] & 0x7f) + 100;
> +       tm->tm_wday = bcd2bin(regs[RV3029C2_A_DW-RV3029C2_A_SC] & 0x07) - 1;
> +

Ditto.

> +       return 0;
> +}
> +
> +static int
> +rv3029c2_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
> +{
> +       return rv3029c2_i2c_read_alarm(to_i2c_client(dev), alarm);
> +}
> +
> +static int
> +rv3029c2_i2c_set_time(struct i2c_client *client, struct rtc_time const *tm)
> +{
> +       u8 regs[8];
> +       int sr;
> +
> +       /* The clock has an 8 bit wide bcd-coded register (they never learn)
> +        * for the year. tm_year is an offset from 1900 and we are interested
> +        * in the 2000-2099 range, so any value less than 100 is invalid.
> +        */
> +       if (tm->tm_year < 100)
> +               return -EINVAL;
> +
> +       regs[RV3029C2_W_SECONDS-RV3029C2_W_SECONDS] = bin2bcd(tm->tm_sec);
> +       regs[RV3029C2_W_MINUTES-RV3029C2_W_SECONDS] = bin2bcd(tm->tm_min);
> +       regs[RV3029C2_W_HOURS-RV3029C2_W_SECONDS] =
> +                               bin2bcd(tm->tm_hour) | RV3029C2_REG_HR_12_24;
> +       regs[RV3029C2_W_DATE-RV3029C2_W_SECONDS] = bin2bcd(tm->tm_mday);
> +       regs[RV3029C2_W_MONTHS-RV3029C2_W_SECONDS] = bin2bcd(tm->tm_mon+1);
> +       regs[RV3029C2_W_DAYS-RV3029C2_W_SECONDS] = bin2bcd((tm->tm_wday & 7)+1);
> +       regs[RV3029C2_W_YEARS-RV3029C2_W_SECONDS] = bin2bcd(tm->tm_year - 100);
> +
> +       sr = rv3029c2_i2c_get_sr(client);
> +       if (sr < 0) {
> +               dev_err(&client->dev, "%s: reading SR failed\n", __func__);
> +               return sr;
> +       }
> +
> +       sr = rv3029c2_i2c_write_regs(client, RV3029C2_W_SECONDS, regs,
> +                                       RV3029C2_WATCH_SECTION_LEN);
> +       if (sr < 0)
> +               return sr;
> +
> +       return 0;
> +}
> +
> +static int rv3029c2_rtc_set_time(struct device *dev, struct rtc_time *tm)
> +{
> +       return rv3029c2_i2c_set_time(to_i2c_client(dev), tm);
> +}
> +
> +static const struct rtc_class_ops rv3029c2_rtc_ops = {
> +       .read_time = rv3029c2_rtc_read_time,
> +       .set_time = rv3029c2_rtc_set_time,
> +       .read_alarm = rv3029c2_rtc_read_alarm,
> +       /*.set_alarm = rv3029c2_rtc_set_alarm, */

Why not implement .set_alarm, but put it marked here?

> +};
> +
> +static int
> +rv3029c2_probe(struct i2c_client *client, const struct i2c_device_id *id)
> +{
> +       struct rtc_device *rtc;
> +       int rc = 0;
> +
> +       if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
> +               return -ENODEV;
> +
> +       if (rv3029c2_i2c_validate_client(client) < 0)
> +               return -ENODEV;
> +
> +       dev_info(&client->dev,
> +                "chip found, driver version " DRV_VERSION "\n");
> +

Kernel have had many print info, so there is no need to 'dev_info' here.

> +       rtc = rtc_device_register(rv3029c2_driver.driver.name,
> +                                 &client->dev, &rv3029c2_rtc_ops,
> +                                 THIS_MODULE);
> +
> +       if (IS_ERR(rtc))
> +               return PTR_ERR(rtc);
> +
> +       i2c_set_clientdata(client, rtc);
> +
> +       rc = rv3029c2_i2c_get_sr(client);
> +       if (rc < 0) {
> +               dev_err(&client->dev, "reading status failed\n");
> +               goto exit_unregister;
> +       }
> +
> +       return 0;
> +
> +exit_unregister:
> +       rtc_device_unregister(rtc);
> +
> +       return rc;
> +}
> +
> +static int rv3029c2_remove(struct i2c_client *client)
> +{
> +       struct rtc_device *rtc = i2c_get_clientdata(client);
> +
> +       if (rtc)
> +               rtc_device_unregister(rtc);

The rtc can't be NULL, Please don't check for it.

> +
> +       return 0;
> +}
> +
> +static struct i2c_device_id rv3029c2_id[] = {
> +       { "rv3029c2", 0 },
> +       { }
> +};
> +MODULE_DEVICE_TABLE(i2c, rv3029c2_id);
> +
> +static struct i2c_driver rv3029c2_driver = {
> +       .driver = {
> +                  .name = "rtc-rv3029c2",
> +                  },
> +       .probe = rv3029c2_probe,
> +       .remove = rv3029c2_remove,
> +       .id_table = rv3029c2_id,
> +};
> +
> +static int __init rv3029c2_init(void)
> +{
> +       return i2c_add_driver(&rv3029c2_driver);
> +}
> +
> +static void __exit rv3029c2_exit(void)
> +{
> +       i2c_del_driver(&rv3029c2_driver);
> +}
> +
> +MODULE_AUTHOR("Gregory Hermant <gregory.hermant@calao-systems.com>");
> +MODULE_DESCRIPTION("Micro crystal RV3029C2 RTC driver");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION(DRV_VERSION);
> +
> +module_init(rv3029c2_init);
> +module_exit(rv3029c2_exit);

Please put MODULE_XXX at the end rather than module_[init/exit]
> --
> 1.5.6.3
>
> --
> You received this message because you are subscribed to "rtc-linux".
> Membership options at http://groups.google.com/group/rtc-linux .
> Please read http://groups.google.com/group/rtc-linux/web/checklist
> before submitting a driver.
>
> To unsubscribe from this group, send email to rtc-linux+unsubscribegooglegroups.com or reply to this email with the words "REMOVE ME" as the subject.
>



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
