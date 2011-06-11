Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab1FKKtv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 06:49:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63637 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab1FKKtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 06:49:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Subject: Re: [PATCHv3 -next] MFD: MFD module of DA9052 PMIC driver
Date: Sat, 11 Jun 2011 12:49:04 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen@diasemi.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BC62219@KCINPUNHJCMS01.kpit.com>
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BC62219@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106111249.05204.arnd@arndb.de>
X-Provags-ID: V02:K0:xH8LWAOfImNVofBfLmi+r/v1BpzCkeJLXLZ08ubN9uB
 FgMwvaDL83cVjjUSDImotNntIlt9Xk5CegfUfqOoATlTXhj6JN
 QgVNJqVY94vyNbxUfuNpPVEFBMiEHgPoxjGvUrn+ULK9SelrQf
 j+Ls9CZ6HURXEvTvivhHyACWTSGZPmLi1sDAAzbGNQ5cRGbaQ8
 TCDEBn5zK9oWm4W9xqcog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 May 2011 13:59:29 Ashish Jangam wrote:
> Hi Mark,
> MFD Driver for Dialog Semiconductor DA9052 PMICs.
> 
> Changes made since last submission:
> . moved read_events to irq file
> . logic modified for the chip method bus_sync_unlock
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>

Hi David,

I'm joining in late in the review process, since I only learned of this driver
after Paul Liu posted a submission of the DA9053 driver and Mark mentioned
that it's essentially the same code. I might be bringing up points that
you have already discussed or that are on your TODO list.

To make this easier, please follow the normal submission style, which includes:

* Use git-format-patch/git-send-email to produce the patches, or other tools
  that have the same effect.

* Split the series in one patch per subsystem that you touch, or by logical
  changes.

* Include a useful changeset comment at the top of the email, as described in
  the Documentation/SubmittingPatches file. Every patch should have at least
  one multi-line paragraph describing what the patch is good for.

* The introductory text that you have in your email above is not the changeset
  comment, please put such text in the [PATCH 00/XX] email, or below the '---'
  marker.

* Include a diffstat in each mail, including the [PATCH 00/XX].

* Make every patch email a reply to the [PATCH 00/XX] introductory email,
  to ensure that they show up as one thread in normal email clients.
  git-send-email --thread --no-chain-reply will do that.

Back to the contents of your submission: I can see that the quality of the
driver is quite good now, thanks to the many review rounds it's been through
already. What I don't see from the code is how generic it is regarding
similar hardware. Looking at your web site at
http://www.diasemi.com/product_table.php, I can see seven other da90xx
models that seem to share some of the same basic units. Please explain
in the description for each of the individual drivers for which of
these products is is responsible for. Obviously, we cannot accept
multiple device drivers for almost-identical hardware, they will have
to be handled by a common driver.

> diff -Naur linux-next-20110421.orig/drivers/leds/Kconfig linux-next-20110421/drivers/leds/Kconfig
> --- linux-next-20110421.orig/drivers/leds/Kconfig       2011-04-26 09:32:34.000000000 +0500
> +++ linux-next-20110421/drivers/leds/Kconfig    2011-05-13 15:04:29.000000000 +0500
> @@ -284,6 +284,14 @@
>           This option enables support for on-chip LED drivers found
>           on Dialog Semiconductor DA9030/DA9034 PMICs.
> 
> +config LEDS_DA9052
> +       tristate "Dialog DA9052 LEDS"
> +       depends on LEDS_CLASS
> +       depends on PMIC_DA9052
> +       help
> +         This option enables support for on-chip LED drivers found
> +         on Dialog Semiconductor DA9052 PMICs
> +

Why is this driver different from the DA903x driver above? Would it be possible
to have one driver handle both?

> +int da9052_adc_manual_read(struct da9052 *da9052,
> +                       unsigned char channel)
> +{
> +       unsigned char timeout_cnt = 8;
> +       unsigned short calc_data;
> +       int ret;
> +       u16 data = 0;
> +       u8 mux_sel = 0;
> +
> +       switch (channel) {
> +       case DA9052_ADC_VDDOUT:
> +               mux_sel = DA9052_ADC_MAN_MUXSEL_VDDOUT;
> +               break;
> +       case DA9052_ADC_ICH:
> +               mux_sel = DA9052_ADC_MAN_MUXSEL_ICH;
> +               break;
> +       case DA9052_ADC_TBAT:
> +               mux_sel = DA9052_ADC_MAN_MUXSEL_TBAT;
> +               break;
> +       case DA9052_ADC_VBAT:
> +               mux_sel = DA9052_ADC_MAN_MUXSEL_VBAT;
> +               break;
> +       case DA9052_ADC_IN4:
> +               mux_sel = DA9052_ADC_MAN_MUXSEL_AD4;
> +               break;
> +       case DA9052_ADC_IN5:
> +               mux_sel = DA9052_ADC_MAN_MUXSEL_AD5;
> +               break;
> +       case DA9052_ADC_IN6:
> +               mux_sel = DA9052_ADC_MAN_MUXSEL_AD6;
> +               break;
> +       case DA9052_ADC_VBBAT:
> +               mux_sel = DA9052_ADC_MAN_MUXSEL_VBBAT;
> +               break;
> +       default:
> +               return -EINVAL;
> +       }

This can be better expressed as data:

	static const u8 chan_mux[DA9052_ADC_VBBAT + 1] = {
		[DA9052_ADC_VDDOUT]	= DA9052_ADC_MAN_MUXSEL_VDDOUT,
		[DA9052_ADC_ICH]	= DA9052_ADC_MAN_MUXSEL_ICH,
		[DA9052_ADC_TBAT]	= DA9052_ADC_MAN_MUXSEL_TBAT,
		[DA9052_ADC_VBAT]	= DA9052_ADC_MAN_MUXSEL_VBAT,
		...
	};

	if (channel > DA9052_ADC_VBBAT)
		return -EINVAL;

	mux_sel = chan_mux[channel] | DA9052_ADC_MAN_MAN_CONV;


> +       /* Channel gets activates on enabling the CONV bit */
> +       mux_sel |= DA9052_ADC_MAN_MAN_CONV;
> +
> +       mutex_lock(&da9052->auxadc_lock);
> +
> +       ret = da9052_reg_read(da9052, DA9052_ADC_MAN_REG);
> +       if (ret < 0) {
> +               mutex_unlock(&da9052->auxadc_lock);
> +               return ret;
> +       }
> +
> +       if (ret & DA9052_ADC_MAN_MAN_CONV) {
> +                       mutex_unlock(&da9052->auxadc_lock);
> +                       return -EBUSY;
> +               }
> +
> +       ret = da9052_reg_write(da9052, DA9052_ADC_MAN_REG,
> +                                       mux_sel);
> +       if (ret < 0) {
> +               mutex_unlock(&da9052->auxadc_lock);
> +               return ret;
> +               }

Better use 'goto err' to do error handling with locking. At the
end of the function, put a single mutex_unlock.

> +       do {
> +               msleep(10);
> +
> +               ret = da9052_reg_read(da9052, DA9052_ADC_MAN_REG);
> +               if (ret < 0)
> +                       return ret;
> +
> +               timeout_cnt--;
> +               if (timeout_cnt == 1) {
> +                       if (!(ret & DA9052_ADC_MAN_MAN_CONV))
> +                               break;
> +                       else
> +                               return -EIO;
> +               }
> +       } while (ret & DA9052_ADC_MAN_MAN_CONV);

This loop can take much longer than you expect. When you want to wait for
a maximum period of time, better use.

	unsigned long timeout = jiffies + msecs_to_jiffies(100);
	do {
		...
	} while (time_before(jiffies, timeout));

> +EXPORT_SYMBOL(da9052_adc_manual_read);

This should be EXPORT_SYMBOL_GPL, like all the other exports
in this file.

> +       mutex_lock(&da9052->io_lock);

Try to use mutex_lock_interruptible instead of mutex_lock where possible,
and handle the interrupted case.

> +static struct resource da9052_rtc_resource = {
> +       .name = "ALM",
> +       .start = DA9052_IRQ_ALARM,
> +       .end   = DA9052_IRQ_ALARM,
> +       .flags = IORESOURCE_IRQ,
> +};
> +
> +static struct resource da9052_onkey_resource = {
> +       .name = "ONKEY",
> +       .start = DA9052_IRQ_NONKEY,
> +       .end   = DA9052_IRQ_NONKEY,
> +       .flags = IORESOURCE_IRQ,
> +};
> +
> +static struct resource da9052_power_resources[] = {
> +       {
> +               .name = "CHGEND",
> +               .start = DA9052_IRQ_CHGEND,
> +               .end   = DA9052_IRQ_CHGEND,
> +               .flags = IORESOURCE_IRQ,
> +       },
> +       {
> +               .name = "TBAT",
> +               .start = DA9052_IRQ_TBAT,
> +               .end   = DA9052_IRQ_TBAT,
> +               .flags = IORESOURCE_IRQ,
> +       },
> +};

I may have missed some major development here, but it seems to me that
hardcoding interrupt numbers from a device driver does not work when
those numbers conflict with other interrupt numbers. Can anyone explain
how this works?

> +int da9052_add_regulator_devices(struct da9052 *da9052,
> +                               struct da9052_pdata *pdata)
> +{
> +       struct platform_device *pdev;
> +       int i;
> +       int ret;
> +
> +       for (i = 0; i < pdata->num_regulators; i++) {
> +               pdev = platform_device_alloc("da9052-regulator", i);
> +               if (!pdev) {
> +                       return -ENOMEM;
> +               }
> +
> +               pdev->dev.parent = da9052->dev;
> +               ret = platform_device_add(pdev);
> +               if (ret) {
> +                       platform_device_put(pdev);
> +                       return ret;
> +               }
> +       }
> +
> +       return 0;
> +}

This function should be static. This is an bug of the class that gets
automatically detected by the 'sparse' tool. Please run all your
code through sparse before every submission and fix the problems
that it finds.

Why is the regulator not an mfd cell like the other devices?

> +#define DA9052_SUBDEV(_name, _pdata, _pdata_sz, _res, _res_sz) \
> +       {                                       \
> +               .name = "da9052-"#_name,        \
> +               .platform_data = _pdata,        \
> +               .data_size = _pdata_sz,         \
> +               .num_resources = _res_sz,       \
> +               .resources = _res,              \
> +       }
> +
> +
> +static int da9052_add_subdevs(struct da9052 *da9052)
> +{
> +       struct da9052_pdata *pdata = da9052->dev->platform_data;
> +       int ret;
> +
> +       static struct mfd_cell __initdata da9052_subdev_info[] = {
> +               DA9052_SUBDEV(onkey, NULL, 0, &da9052_onkey_resource, 1),
> +               DA9052_SUBDEV(rtc, NULL, 0, &da9052_rtc_resource, 1),
> +               DA9052_SUBDEV(gpio, NULL, 0, NULL, 0),
> +               DA9052_SUBDEV(hwmon, NULL, 0, NULL, 0),
> +               DA9052_SUBDEV(leds, NULL, 0, NULL, 0),
> +               DA9052_SUBDEV(WLED1, NULL, 0, NULL, 0),
> +               DA9052_SUBDEV(WLED2, NULL, 0, NULL, 0),
> +               DA9052_SUBDEV(WLED3, NULL, 0, NULL, 0),
> +               DA9052_SUBDEV(tsi, NULL, 0, da9052_tsi_resources,
> +                                       ARRAY_SIZE(da9052_tsi_resources)),
> +               DA9052_SUBDEV(bat, NULL, 0, da9052_power_resources,
> +                                         ARRAY_SIZE(da9052_power_resources)),
> +               DA9052_SUBDEV(watchdog, NULL, 0, NULL, 0),
> +       };

Using the macro above doesn't seem to add any value. On the contrary, it
makes it harder to grep for identifiers like "da9052-gpio" when the identifiers
are constructed by string concatenation. Just declare the mfd_cells open-coded.
You can probably fit them all into one line each anyway, e.g.

static struct mfd_cell __initdata da9052_subdev_info[] = {
	{ "da9052-onkey", .resources = &da9052_onkey_resource, .num_resources = 1 },
	...
};

> diff -Naur linux-next-20110421.orig/drivers/mfd/da9052-i2c.c linux-next-20110421/drivers/mfd/da9052-i2c.c
> --- linux-next-20110421.orig/drivers/mfd/da9052-i2c.c   1970-01-01 05:00:00.000000000 +0500
> +++ linux-next-20110421/drivers/mfd/da9052-i2c.c        2011-05-13 14:51:28.000000000 +0500
> @@ -0,0 +1,170 @@
> +/*
> + * I2C access for Da9052 PMICs.

This driver really doesn't look specific to one device of the family, so
better name it da90xx-i2c. You can fan out to the individual MFD drivers
based on the i2c device id when you add support for similar devices.

> +int da9052_i2c_write_device(struct da9052 *da9052, unsigned char reg,
> +                           unsigned count, unsigned char *val)
> +int da9052_i2c_read_device(struct da9052 *da9052, unsigned char reg,
> +                          unsigned count, unsigned char *val)

More functions that should be static.

> +struct da9052_irq_data {
> +       int mask;
> +       int offset;
> +};
> +
> +#define DA9052_FIXME() { udelay(50); }
> +
> +static struct da9052_irq_data da9052_irqs[] = {
> +       [DA9052_IRQ_DCIN] = {
> +               .mask = DA9052_IRQMASK_A_M_DCIN_VLD,
> +               .offset = 0,
> +       },
> +       [DA9052_IRQ_VBUS] = {
> +               .mask = DA9052_IRQMASK_A_M_VBUS_VLD,
> +               .offset = 0,
> +       },

This long array would probably be more readable without the member names in it,
especially since the struct only has two members:

static struct da9052_irq_data da9052_irqs[] = {
        [DA9052_IRQ_DCIN]	= { DA9052_IRQMASK_A_M_DCIN_VLD, 0 },
        [DA9052_IRQ_VBUS]	= { DA9052_IRQMASK_A_M_VBUS_VLD, 0 },
        [DA9052_IRQ_DCINREM]	= { DA9052_IRQMASK_A_M_DCIN_REM, 0 },
        [DA9052_IRQ_VBUSREM]	= { DA9052_IRQMASK_A_M_VBUS_REM, 0 },
	...
};

Since the DA9052_IRQMASK_... macros are only used in this one place,
it would be even better to just get rid of the macros and open-code
the contents here, to avoid having the reader look it up in another
file:

static struct da9052_irq_data da9052_irqs[] = {
        [DA9052_IRQ_DCIN]	= { 0x01, 0 },
        [DA9052_IRQ_VBUS]	= { 0x02, 0 },
        [DA9052_IRQ_DCINREM]	= { 0x04, 0 },
        [DA9052_IRQ_VBUSREM]	= { 0x08, 0 },
	...
};

> +int da9052_spi_write_device(struct da9052 *da9052, unsigned char reg,
> +                           unsigned bytes, unsigned char *val)

> +int da9052_spi_read_device(struct da9052 *da9052, unsigned char reg,
> +                          unsigned bytes, unsigned char *val)

static

> diff -Naur linux-next-20110421.orig/drivers/video/backlight/da9052_bl.c linux-next-20110421/drivers/video/backlight/da9052_bl.c
> --- linux-next-20110421.orig/drivers/video/backlight/da9052_bl.c        1970-01-01 05:00:00.000000000 +0500
> +++ linux-next-20110421/drivers/video/backlight/da9052_bl.c     2011-05-13 14:52:54.000000000 +0500

Like the LED driver, there is already a da903x driver. How about merging them?

> +static struct platform_driver da9052_wled1_driver = {
> +       .driver = {
> +               .name   = "da9052-WLED1",
> +               .owner = THIS_MODULE,
> +       },
> +       .probe  = da9052_backlight_probe,
> +       .remove = da9052_backlight_remove,
> +};
> +
> +static struct platform_driver da9052_wled2_driver = {
> +       .driver = {
> +               .name   = "da9052-WLED2",
> +               .owner = THIS_MODULE,
> +       },
> +       .probe  = da9052_backlight_probe,
> +       .remove = da9052_backlight_remove,
> +};
> +
> +static struct platform_driver da9052_wled3_driver = {
> +       .driver = {
> +               .name   = "da9052-WLED3",
> +               .owner = THIS_MODULE,
> +       },
> +       .probe  = da9052_backlight_probe,
> +       .remove = da9052_backlight_remove,
> +};

No need to have three separate platform drivers here. You should just
name the all devices "da9052-wled" and give them distinct IDs.

When you get to another case where you want to match devices that
are actually different but handle them with the same driver like
da903x and da905x, you should use the 'id_table' member of
platform_driver to install both.

> +
> +#define        DA9052_STROBING_FILTER_ENABLE           0x0001
> +#define        DA9052_STROBING_FILTER_DISABLE  0x0002
> +
> +void start_strobing(struct work_struct *work);

The start_strobing function is used only in this file, so please make the
function 'static' and move it to the right place in the file so you don't
need a forward declaration.

> +struct da9052_wdt {
> +       struct platform_device *pdev;
> +       struct da9052_wdt_platform_data *pwdt;
> +       struct da9052 *da9052;
> +       struct work_struct wdt_strobe;
> +       unsigned long data;
> +};
> +
> +static struct da9052_wdt *wdt;
> +
> +/* Create a handler for the scheduling start_strobing function */
> +static unsigned char sm_str_req = DA9052_DISABLE;
> +static int nowayout = WATCHDOG_NOWAYOUT;
> +static uint strobe_interval;
> +static uint strobe_mode;
> +static struct timer_list monitoring_timer;
> +static struct miscdevice da9052_wdt_miscdev;
> +static unsigned long da9052_wdt_users;
> +static int da9052_wdt_expect_close;

Why do you have both a singleton 'da9052_wdt' structure and a set of
static variables? Just do one or the other.

> +void timer_callback(unsigned long *data)
> +{

static

> +       struct da9052_wdt *pwdt = (struct da9052_wdt *)
> +                               container_of(data, struct da9052_wdt, data);
> +
> +       if (((sm_str_req) && (strobe_mode == DA9052_STROBE_MANUAL)) ||
> +                                               (strobe_mode == DA9052_STROBE_AUTO))
> +               schedule_work(&pwdt->wdt_strobe);
> +       else {
> +               if (strobe_mode == DA9052_STROBE_MANUAL)
> +                       mod_timer(&monitoring_timer, jiffies + strobe_interval);
> +       }
> +}

This needs some explanation, preferably in the changeset comment for the watchdog
driver. Why on earth do you need a timer function in a watchdog driver?
What is strobing in this context?

> +/* HWMON Channel Definations */
> +#define DA9052_ADC_VDDOUT      0
> +#define DA9052_ADC_ICH         1
> +#define DA9052_ADC_TBAT        2
> +#define DA9052_ADC_VBAT        3
> +#define DA9052_ADC_IN4         4
> +#define DA9052_ADC_IN5         5
> +#define DA9052_ADC_IN6         6
> +#define DA9052_ADC_TSI         7
> +#define DA9052_ADC_TJUNC       8
> +#define DA9052_ADC_VBBAT       9

This list is used only in the MFD driver, so move it there or get rid of it
if you can.

> +int da9052_adc_manual_read(struct da9052 *da9052,
> +                                       unsigned char channel);
> +int da9052_reg_read(struct da9052 *da9052, unsigned char reg);
> +int da9052_reg_write(struct da9052 *da9052, unsigned char reg,
> +                       unsigned char val);
> +int da9052_group_read(struct da9052 *da9052, unsigned char reg,
> +                       unsigned bytes, unsigned char *val);
> +int da9052_group_write(struct da9052 *da9052, unsigned char reg,
> +                       unsigned bytes, unsigned char *val);
> +int da9052_reg_update(struct da9052 *da9052, unsigned char reg,
> +                       unsigned char bit_mask, unsigned char reg_val);
> +int da9052_set_bits(struct da9052 *da9052, unsigned char reg,
> +                       unsigned char bit_mask);
> +int da9052_clear_bits(struct da9052 *da9052, unsigned char reg,
> +                   unsigned char bit_mask);
> +
> +int da9052_device_init(struct da9052 *da9052);
> +void da9052_device_exit(struct da9052 *da9052);
> +
> +int da9052_irq_init(struct da9052 *da9052, struct da9052_pdata *pdata);
> +void da9052_irq_exit(struct da9052 *da9052);

Not all of these functions are actually used by any of the client drivers,
so please make them static if you don't need them.

> diff -Naur linux-next-20110421.orig/include/linux/mfd/da9052/irq.h linux-next-20110421/include/linux/mfd/da9052/irq.h
> --- linux-next-20110421.orig/include/linux/mfd/da9052/irq.h     1970-01-01 05:00:00.000000000 +0500
> +++ linux-next-20110421/include/linux/mfd/da9052/irq.h  2011-05-13 14:55:46.000000000 +0500

This file can be local to the mfd directory, because it is not needed by
any of the cell drivers. You can probably move some of its contents into
the files where it's used, if it's not used as an interface between
files.

> +/* STATUS REGISTER A */
> +#define DA9052_STATUSA_VDATDET (1<<7)
> +#define DA9052_STATUSA_VBUSSEL (1<<6)
> +#define DA9052_STATUSA_DCINSEL (1<<5)
> +#define DA9052_STATUSA_VBUSDET (1<<4)
> +#define DA9052_STATUSA_DCINDET (1<<3)
> +#define DA9052_STATUSA_IDGND           (1<<2)
> +#define DA9052_STATUSA_IDFLOAT (1<<1)
> +#define DA9052_STATUSA_NONKEY  (1<<0)

I personally find it much more readable to define these as hexadecimal
constants, like

#define DA9052_STATUSA_VDATDET	0x80
#define DA9052_STATUSA_VBUSSEL	0x40
#define DA9052_STATUSA_DCINSEL	0x20

> +/* TBAT_HIGHP regsister*/
> +#define DA9052_TBATHIGHP_TBATHIGHP             (255<<0)
> +
> +/* TBAT_HIGHN regsister*/
> +#define DA9052_TBATHIGHN_TBATHIGHN             (255<<0)

Especially when it gets as silly as this.

> diff -Naur linux-next-20110421.orig/include/linux/mfd/da9052/wdt.h linux-next-20110421/include/linux/mfd/da9052/wdt.h
> --- linux-next-20110421.orig/include/linux/mfd/da9052/wdt.h     1970-01-01 05:00:00.000000000 +0500
> +++ linux-next-20110421/include/linux/mfd/da9052/wdt.h  2011-05-13 14:56:15.000000000 +0500

This header is used only by a single file. No need to clutter the global
namespace with it, just move the contents into the implementation file.

	Arnd
