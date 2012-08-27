Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2H0V7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 17:59:47 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37666 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab2H0V7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 17:59:44 -0400
MIME-Version: 1.0
In-Reply-To: <1345241877-16200-8-git-send-email-cheiny@synaptics.com>
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com>
	<1345241877-16200-8-git-send-email-cheiny@synaptics.com>
Date: Mon, 27 Aug 2012 14:59:43 -0700
Message-ID: <CACRpkdaGoPfieJQnryHmorh9LcxdLU+WjpnER8fXbuMAji2DDA@mail.gmail.com>
Subject: Re: [RFC PATCH 7/17] input: RMI4 F01 device control
From: Linus Walleij <linus.walleij@linaro.org>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Henrik Rydberg <rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 3:17 PM, Christopher Heiny <cheiny@synaptics.com> wrote:

(...)
> +++ b/drivers/input/rmi4/rmi_f01.c
(...)
> +union f01_device_commands {
> +       struct {
> +               u8 reset:1;
> +               u8 reserved:1;

I would just use bool for one-bit variables.

But I see that some protocol people often cast a piece of data on top
of  a struct, and have it packed to fit on top of each other.

It looks like that is what is going on here.

> +       };
> +       u8 reg;
> +};

If you're doing bitstuffing, use
__attribute__((__packed__));
after each struct.

> +struct f01_device_control {
> +       union f01_device_control_0 ctrl0;
> +       u8 *interrupt_enable;
> +       u8 doze_interval;
> +       u8 wakeup_threshold;
> +       u8 doze_holdoff;
> +};

These could use some kerneldoc.

__attribute__((__packed__));

> +union f01_query_42 {
> +       struct {
> +               u8 has_ds4_queries:1;
> +               u8 has_multi_phy:1;
> +               u8 has_guest:1;
> +               u8 reserved:5;
> +       };
> +       u8 regs[1];
> +};

__attribute__((__packed__));

> +union f01_ds4_queries {
> +       struct {
> +               u8 length:4;
> +               u8 reserved_1:4;
> +
> +               u8 has_package_id_query:1;
> +               u8 has_packrat_query:1;
> +               u8 has_reset_query:1;
> +               u8 has_maskrev_query:1;
> +               u8 reserved_2:4;
> +
> +               u8 has_i2c_control:1;
> +               u8 has_spi_control:1;
> +               u8 has_attn_control:1;
> +               u8 reserved_3:5;
> +
> +               u8 reset_enabled:1;
> +               u8 reset_polarity:1;
> +               u8 pullup_enabled:1;
> +               u8 reserved_4:1;
> +               u8 reset_pin_number:4;
> +       };
> +       u8 regs[4];
> +};

__attribute__((__packed__));


(...)
> +static struct device_attribute fn_01_attrs[] = {
> +       __ATTR(productinfo, RMI_RO_ATTR,
> +              rmi_fn_01_productinfo_show, rmi_store_error),
> +       __ATTR(productid, RMI_RO_ATTR,
> +              rmi_fn_01_productid_show, rmi_store_error),
> +       __ATTR(manufacturer, RMI_RO_ATTR,
> +              rmi_fn_01_manufacturer_show, rmi_store_error),
> +       __ATTR(datecode, RMI_RO_ATTR,
> +              rmi_fn_01_datecode_show, rmi_store_error),
> +
> +       /* control register access */
> +       __ATTR(sleepmode, RMI_RW_ATTR,
> +              rmi_fn_01_sleepmode_show, rmi_fn_01_sleepmode_store),
> +       __ATTR(nosleep, RMI_RW_ATTR,
> +              rmi_fn_01_nosleep_show, rmi_fn_01_nosleep_store),
> +       __ATTR(chargerinput, RMI_RW_ATTR,
> +              rmi_fn_01_chargerinput_show, rmi_fn_01_chargerinput_store),
> +       __ATTR(reportrate, RMI_RW_ATTR,
> +              rmi_fn_01_reportrate_show, rmi_fn_01_reportrate_store),
> +       __ATTR(interrupt_enable, RMI_RW_ATTR,
> +              rmi_fn_01_interrupt_enable_show,
> +               rmi_fn_01_interrupt_enable_store),
> +       __ATTR(doze_interval, RMI_RW_ATTR,
> +              rmi_fn_01_doze_interval_show,
> +               rmi_fn_01_doze_interval_store),
> +       __ATTR(wakeup_threshold, RMI_RW_ATTR,
> +              rmi_fn_01_wakeup_threshold_show,
> +               rmi_fn_01_wakeup_threshold_store),
> +       __ATTR(doze_holdoff, RMI_RW_ATTR,
> +              rmi_fn_01_doze_holdoff_show,
> +               rmi_fn_01_doze_holdoff_store),
> +
> +       /* We make report rate RO, since the driver uses that to look for
> +        * resets.  We don't want someone faking us out by changing that
> +        * bit.
> +        */
> +       __ATTR(configured, RMI_RO_ATTR,
> +              rmi_fn_01_configured_show, rmi_store_error),
> +
> +       /* Command register access. */
> +       __ATTR(reset, RMI_WO_ATTR,
> +              rmi_show_error, rmi_fn_01_reset_store),
> +
> +       /* STatus register access. */
> +       __ATTR(unconfigured, RMI_RO_ATTR,
> +              rmi_fn_01_unconfigured_show, rmi_store_error),
> +       __ATTR(flashprog, RMI_RO_ATTR,
> +              rmi_fn_01_flashprog_show, rmi_store_error),
> +       __ATTR(statuscode, RMI_RO_ATTR,
> +              rmi_fn_01_statuscode_show, rmi_store_error),
> +};

Can you partition this into one set of stuff that goes into sysfs and
another part that goes into debugfs, depending on usage?

The sysfs portions need to be documented in
Documentation/ABI/testing/*

> +/* Utility routine to set the value of a bit field in a register. */
> +int rmi_set_bit_field(struct rmi_device *rmi_dev,

This is not what the function is doing. It is doing
read/mask/set/write, so rmi_mask_and_set() is a better name.

> +                     unsigned short address,

u16?

> +                     unsigned char field_mask,

u8?

Just "mask" is fine.

> +                     unsigned char bits)

u8?

Call it "set" (IMHO)?

(...)
> +static ssize_t rmi_fn_01_interrupt_enable_store(struct device *dev,
> +                                         struct device_attribute *attr,
> +                                         const char *buf, size_t count)
> +{
> +       struct rmi_function_container *fc;
> +       struct f01_data *data;
> +       int i;
> +       int irq_count = 0;
> +       int retval = count;
> +       int irq_reg = 0;
> +
> +       fc = to_rmi_function_container(dev);
> +       data = fc->data;
> +       for (i = 0; i < data->irq_count && *buf != 0;
> +            i++, buf += 2) {
> +               int irq_shift;
> +               int interrupt_enable;
> +               int result;
> +
> +               irq_reg = i / 8;
> +               irq_shift = i % 8;
> +
> +               /* get next interrupt mapping value and store and bump up to
> +                * point to next item in buf */
> +               result = sscanf(buf, "%u", &interrupt_enable);
> +               if ((result != 1) ||
> +                       (interrupt_enable != 0 && interrupt_enable != 1)) {
> +                       dev_err(dev,
> +                               "%s: Error - interrupt enable[%d]"
> +                               " is not a valid value 0x%x.\n",
> +                               __func__, i, interrupt_enable);
> +                       return -EINVAL;
> +               }
> +               if (interrupt_enable == 0) {
> +                       data->device_control.interrupt_enable[irq_reg] &=
> +                               (1 << irq_shift) ^ 0xFF;
> +               } else
> +                       data->device_control.interrupt_enable[irq_reg] |=
> +                               (1 << irq_shift);
> +               irq_count++;
> +       }
> +
> +       /* Make sure the irq count matches */
> +       if (irq_count != data->irq_count) {
> +               dev_err(dev,
> +                       "%s: Error - interrupt enable count of %d"
> +                       " doesn't match device count of %d.\n",
> +                        __func__, irq_count, data->irq_count);
> +               return -EINVAL;
> +       }
> +
> +       /* write back to the control register */
> +       retval = rmi_write_block(fc->rmi_dev, data->interrupt_enable_addr,
> +                       data->device_control.interrupt_enable,
> +                       sizeof(u8)*(data->num_of_irq_regs));
> +       if (retval < 0) {
> +               dev_err(dev, "%s : Could not write interrupt_enable_store"
> +                       " to 0x%x\n", __func__, data->interrupt_enable_addr);
> +               return retval;
> +       }
> +
> +       return count;
> +
> +}

I cannot figure out why you would want to enable/disable IRQs from
sysfs nodes? Please describe the usecase... If this is only for
debugging and testing, debugfs is the right place.

(...)
> +static int rmi_f01_reset(struct rmi_function_container *fc)
> +{
> +       /*do nothing here */
> +       return 0;
> +}

Doesn't look very useful?

> +static int rmi_f01_init(struct rmi_function_container *fc)
> +{
> +       return 0;
> +}

Neither does this.

> +static struct rmi_function_handler function_handler = {
> +       .func = 0x01,
> +       .init = rmi_f01_init,
> +       .config = rmi_f01_config,
> +       .reset = rmi_f01_reset,
> +       .attention = rmi_f01_attention,

So make .reset and .init by checking for them being NULL in the
bus driver and avoid calling them in this case like that:

if (!func->init)
   return 0;

> +#ifdef CONFIG_PM
> +#if defined(CONFIG_HAS_EARLYSUSPEND) && \
> +                       !defined(CONFIG_RMI4_SPECIAL_EARLYSUSPEND)
> +       .early_suspend = rmi_f01_suspend,
> +       .late_resume = rmi_f01_resume,
> +#else
> +       .suspend = rmi_f01_suspend,
> +       .resume = rmi_f01_resume,
> +#endif  /* defined(CONFIG_HAS_EARLYSUSPEND) && !def... */
> +#endif  /* CONFIG_PM */

More Android stuff not in the mainline kernel...

(...)
> +++ b/drivers/input/rmi4/rmi_f01.h
(...)
> +union f01_basic_queries {
> +       struct {
> +               u8 manufacturer_id:8;
> +
> +               u8 custom_map:1;
> +               u8 non_compliant:1;
> +               u8 has_lts:1;
> +               u8 has_sensor_id:1;
> +               u8 has_charger_input:1;
> +               u8 has_adjustable_doze:1;
> +               u8 has_adjustable_doze_holdoff:1;
> +               u8 has_product_properties_2:1;
> +
> +               u8 productinfo_1:7;
> +               u8 q2_bit_7:1;
> +               u8 productinfo_2:7;
> +               u8 q3_bit_7:1;
> +
> +               u8 year:5;
> +               u8 month:4;
> +               u8 day:5;
> +               u8 cp1:1;
> +               u8 cp2:1;
> +               u8 wafer_id1_lsb:8;
> +               u8 wafer_id1_msb:8;
> +               u8 wafer_id2_lsb:8;
> +               u8 wafer_id2_msb:8;
> +               u8 wafer_id3_lsb:8;
> +       };
> +       u8 regs[11];
> +};

__attribute__((packed));

?

> +union f01_device_status {
> +       struct {
> +               u8 status_code:4;
> +               u8 reserved:2;
> +               u8 flash_prog:1;
> +               u8 unconfigured:1;
> +       };
> +       u8 regs[1];
> +};

__attribute__((packed));

?


> +/* control register bits */
> +#define RMI_SLEEP_MODE_NORMAL (0x00)
> +#define RMI_SLEEP_MODE_SENSOR_SLEEP (0x01)
> +#define RMI_SLEEP_MODE_RESERVED0 (0x02)
> +#define RMI_SLEEP_MODE_RESERVED1 (0x03)

Funny reserved modes but whatever...

> +
> +#define RMI_IS_VALID_SLEEPMODE(mode) \
> +       (mode >= RMI_SLEEP_MODE_NORMAL && mode <= RMI_SLEEP_MODE_RESERVED1)
> +
> +union f01_device_control_0 {
> +       struct {
> +               u8 sleep_mode:2;
> +               u8 nosleep:1;
> +               u8 reserved:2;
> +               u8 charger_input:1;
> +               u8 report_rate:1;
> +               u8 configured:1;
> +       };
> +       u8 regs[1];
> +};

__attribute__((packed));

?

Yours,
Linus Walleij
