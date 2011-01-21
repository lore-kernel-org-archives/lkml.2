Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab1AUJZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 04:25:58 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:10312 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab1AUJZz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 04:25:55 -0500
X-IronPort-AV: E=Sophos;i="4.60,357,1291611600"; 
   d="scan'208";a="27818853"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>
CC: "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Date: Fri, 21 Jan 2011 09:25:50 +0000
Subject: RE: [PATCH] backlight: new driver for the ADP8870 backlight devices
Thread-Topic: [PATCH] backlight: new driver for the ADP8870 backlight devices
Thread-Index: Acu5BOeOz/jkmygbSkChpDUkDDBGkAARdN8w
Message-ID: <544AC56F16B56944AEC3BD4E3D591771324C0A8C6F@LIMKCMBX1.ad.analog.com>
References: <1294794049-17337-1-git-send-email-vapier@gentoo.org>
 <20110120164816.5afa0561.akpm@linux-foundation.org>
In-Reply-To: <20110120164816.5afa0561.akpm@linux-foundation.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote on 2011-01-21:
> On Tue, 11 Jan 2011 20:00:48 -0500
> Mike Frysinger <vapier@gentoo.org> wrote:
>
>>
>> ...
>>
>> +#define FADE_VAL(in, out)   ((0xF & (in)) | ((0xF & (out)) << 4))
>> +#define BL_CFGR_VAL(law, blv)       ((((blv) & CFGR_BLV_MASK) <<
>> CFGR_BLV_SHIFT) | ((0x3 & (law)) << 1)) +#define
>> ALS_CMPR_CFG_VAL(filt)       ((0x7 & filt) << 1)
>
> Missing () around `filt'.
>
> There's no reason why these "functions" needed to be implemented as
> macros?  They'd be better as nice lowercase-named, commented, typesafe
> C functions.
>
>>
>> ...
>>
>> +static int adp8870_read(struct i2c_client *client, int reg, uint8_t
>> +*val) {
>> +    int ret;
>> +
>> +    ret = i2c_smbus_read_byte_data(client, reg);
>> +    if (ret < 0) {
>> +            dev_err(&client->dev, "failed reading at 0x%02x\n", reg);
>> +            return ret;
>> +    }
>> +
>> +    *val = (uint8_t)ret;
>
> the cast wasn't needed.
>
>> +    return 0;
>> +}
>> +
>> +
>>
>> ...
>>
>> +#if defined(ADP8870_USE_LEDS) +static void adp8870_led_work(struct
>> work_struct *work) { +       struct adp8870_led *led = container_of(work,
>> struct adp8870_led, work); + adp8870_write(led->client, ADP8870_ISC1 +
>> led->id - 1, +                        led->new_brightness >> 1); +} + +static void
>> adp8870_led_set(struct led_classdev *led_cdev, +                        enum
>> led_brightness value) +{ +   struct adp8870_led *led; + +    led =
>> container_of(led_cdev, struct adp8870_led, cdev); +  led->new_brightness
>> = value; +   schedule_work(&led->work); +}
>
> Why does it use schedule_work() instead of synchronously calling
> adp8870_write()?
>
> (And if I didn't know, other readers won't know either.  It needs a
> comment explaining this).

I2C transfers may sleep - calls from leds-class to brightness_set() may not need it.
However brightness_set() can also called from the led triggers.

I simply followed what all other SPI/I2C bus leds driver here do.

>>
>> ...
>>
>> +static int __devinit adp8870_led_probe(struct i2c_client *client) {
>> +    struct adp8870_backlight_platform_data *pdata =
>> +            client->dev.platform_data;
>> +    struct adp8870_bl *data = i2c_get_clientdata(client);
>> +    struct adp8870_led *led, *led_dat;
>> +    struct led_info *cur_led;
>> +    int ret, i;
>> +
>> +    led = kzalloc(sizeof(*led) * pdata->num_leds, GFP_KERNEL);
>
> kcalloc() is neater.
>
>> +    if (led == NULL) {
>> +            dev_err(&client->dev, "failed to alloc memory\n");
>> +            return -ENOMEM;
>> +    }
>> +
>> +    ret = adp8870_write(client, ADP8870_ISCLAW, pdata->led_fade_law);
>> +    ret = adp8870_write(client, ADP8870_ISCT1,
>> +                    (pdata->led_on_time & 0x3) << 6);
>
> I think you intended |= here.

Good catch

>> +    ret |= adp8870_write(client, ADP8870_ISCF,
>> +                    FADE_VAL(pdata->led_fade_in, pdata->led_fade_out));
>> +
>> +    if (ret) {
>
> But OR-ing errnos together is a bit grubby - if two calls return
> different errnos, we get garbage.

I'll fix those.

>> +            dev_err(&client->dev, "failed to write\n");
>> +            goto err_free;
>> +    }
>> +
>> +    for (i = 0; i < pdata->num_leds; ++i) {
>> +            cur_led = &pdata->leds[i];
>> +            led_dat = &led[i];
>> +
>> +            led_dat->id = cur_led->flags & ADP8870_FLAG_LED_MASK;
>> +
>> +            if (led_dat->id > 7 || led_dat->id < 1) {
>> +                    dev_err(&client->dev, "Invalid LED ID %d\n",
>> +                            led_dat->id);
>> +                    goto err;
>> +            }
>> +
>> +            if (pdata->bl_led_assign & (1 << (led_dat->id - 1))) {
>> +                    dev_err(&client->dev, "LED %d used by Backlight\n",
>> +                            led_dat->id);
>> +                    goto err;
>> +            }
>> +
>> +            led_dat->cdev.name = cur_led->name;
>> +            led_dat->cdev.default_trigger = cur_led->default_trigger;
>> +            led_dat->cdev.brightness_set = adp8870_led_set;
>> +            led_dat->cdev.brightness = LED_OFF;
>> +            led_dat->flags = cur_led->flags >> FLAG_OFFT_SHIFT;
>> +            led_dat->client = client;
>> +            led_dat->new_brightness = LED_OFF;
>> +            INIT_WORK(&led_dat->work, adp8870_led_work);
>> +
>> +            ret = led_classdev_register(&client->dev, &led_dat->cdev);
>> +            if (ret) {
>> +                    dev_err(&client->dev, "failed to register LED %d\n",
>> +                            led_dat->id);
>> +                    goto err;
>> +            }
>> +
>> +            ret = adp8870_led_setup(led_dat);
>> +            if (ret) {
>> +                    dev_err(&client->dev, "failed to write\n");
>> +                    i++;
>> +                    goto err;
>> +            }
>> +    }
>> +
>> +    data->led = led;
>> +
>> +    return 0;
>> +
>> + err:
>> +    for (i = i - 1; i >= 0; --i) {
>> +            led_classdev_unregister(&led[i].cdev);
>> +            cancel_work_sync(&led[i].work);
>> +    }
>> +
>> + err_free:
>> +    kfree(led);
>> +
>> +    return ret;
>> +}
>>
>> ...
>>
>> +static int adp8870_bl_setup(struct backlight_device *bl) { +        struct
>> adp8870_bl *data = bl_get_data(bl); +        struct i2c_client *client =
>> data->client; +      struct adp8870_backlight_platform_data *pdata =
>> data->pdata; +       int ret = 0; + +        ret |= adp8870_write(client,
>> ADP8870_BLSEL, ~pdata- bl_led_assign); +     ret |= adp8870_write(client,
>> ADP8870_PWMLED, pdata->pwm_assign); +        ret |= adp8870_write(client,
>> ADP8870_BLMX1, pdata- l1_daylight_max); +    ret |= adp8870_write(client,
>> ADP8870_BLDM1, pdata- l1_daylight_dim); + +  if (pdata->en_ambl_sens) {
>> +            data->cached_daylight_max = pdata->l1_daylight_max; +           ret |=
>> adp8870_write(client, ADP8870_BLMX2, +                                               pdata->l2_bright_max);
>> +            ret |= adp8870_write(client, ADP8870_BLDM2,
>> +                                            pdata->l2_bright_dim); +                ret |= adp8870_write(client,
>> ADP8870_BLMX3, +                                             pdata->l3_office_max); +                ret |=
>> adp8870_write(client, ADP8870_BLDM3, +                                               pdata->l3_office_dim);
>> +            ret |= adp8870_write(client, ADP8870_BLMX4,
>> +                                            pdata->l4_indoor_max); +                ret |= adp8870_write(client,
>> ADP8870_BLDM4, +                                             pdata->l4_indor_dim); +         ret |=
>> adp8870_write(client, ADP8870_BLMX5, +                                               pdata->l5_dark_max); +          ret
>> |= adp8870_write(client, ADP8870_BLDM5, +                                            pdata->l5_dark_dim); +
>> +            ret |= adp8870_write(client, ADP8870_L2TRP, pdata- l2_trip); +          ret
>> |= adp8870_write(client, ADP8870_L2HYS, pdata- l2_hyst); +           ret |=
>> adp8870_write(client, ADP8870_L3TRP, pdata- l3_trip); +              ret |=
>> adp8870_write(client, ADP8870_L3HYS, pdata- l3_hyst); +              ret |=
>> adp8870_write(client, ADP8870_L4TRP, pdata- l4_trip); +              ret |=
>> adp8870_write(client, ADP8870_L4HYS, pdata- l4_hyst); +              ret |=
>> adp8870_write(client, ADP8870_L5TRP, pdata- l5_trip); +              ret |=
>> adp8870_write(client, ADP8870_L5HYS, pdata- l5_hyst); +              ret |=
>> adp8870_write(client, ADP8870_ALS1_EN, L5_EN | L4_EN | +                                             L3_EN |
>> L2_EN); + +          ret |= adp8870_write(client, ADP8870_CMP_CTL,
>> +                    ALS_CMPR_CFG_VAL(pdata->abml_filt)); + +        } + +   ret |=
>> adp8870_write(client, ADP8870_CFGR, +                        BL_CFGR_VAL(pdata->bl_fade_law,
>> 0)); + +     ret |= adp8870_write(client, ADP8870_BLFR, FADE_VAL(pdata-
>> bl_fade_in, +                        pdata->bl_fade_out)); + +       /* +     * ADP8870 Rev0 requires
>> GDWN_DIS bit set +    */ + + ret |= adp8870_set_bits(client,
>> ADP8870_MDCR, BLEN | DIM_EN | NSTBY | +                      (data->revid == 0 ? GDWN_DIS
>> : 0)); + +   return ret; +}
>
> Much grubbiness.
>
> adp8870_write() can take a long time, I think.  What's the worst-case
> value of adapter->timeout?

It can be long.

> If the interface is timing out, this code
> will call the timing-out function ten or twenty times.  How long can
> all this take?  How many messages will it spew on the console?

Long and many.

The driver won't probe if the first i2c transaction fails.
If the first one succeeds, all following are likely to succeed as well.

Anyways you're right - it's cleaner to check each return value and abort.

>> +static ssize_t adp8870_show(struct device *dev, char *buf, int reg) {
>> +    struct adp8870_bl *data = dev_get_drvdata(dev); +       int error;
>> +    uint8_t reg_val; + +    mutex_lock(&data->lock); +      error =
>> adp8870_read(data->client, reg, &reg_val); + mutex_unlock(&data->lock);
>> + +  if (error < 0) +                return error; + +       return sprintf(buf, "%u\n",
>> reg_val); } + +static ssize_t adp8870_store(struct device *dev, const
>> char *buf, +                  size_t count, int reg) +{ +    struct adp8870_bl *data =
>> dev_get_drvdata(dev); +      unsigned long val; +    int ret; + +    ret =
>> strict_strtoul(buf, 10, &val); +     if (ret) +              return ret; +
>> +    mutex_lock(&data->lock); +      adp8870_write(data->client, reg, val);
>> +    mutex_unlock(&data->lock); + +  return count; +}
>
> Is the sysfs API documented anywhere?

Yes - http://wiki-analog.com/software/driver/linux/adp8870
I guess you are asking me to write something that goes into linux-2.6.x/Documentation?

Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368; Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin, Margaret Seif

