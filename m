Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018Ab2KVTcC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:32:02 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36125 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab2KVTb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:31:57 -0500
MIME-Version: 1.0
In-Reply-To: <20121122112451.GE4328@gmail.com>
References: <f1d508c64a01dfd492a1ab1fda28af4b7647d8ab.1353560936.git.viresh.kumar@linaro.org>
	<b81641051dad9660b72b0028d001e5620d901160.1353560936.git.viresh.kumar@linaro.org>
	<20121122112451.GE4328@gmail.com>
Date: Thu, 22 Nov 2012 19:24:09 +0530
Message-ID: <CAKohpo=F91sZ7St3XVXqwAEgmSWXjAxxXwRs1RD5qPyW99P1vA@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] mfd: stmpe: Extend DT support in stmpe driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 November 2012 16:54, Lee Jones <lee.jones@linaro.org> wrote:
> Big fat NACK.
>
> You've just overwritten the current implementation with your own.
> Please take time to understand the mechanisms in place before
> you submit any changes or additions to it.

:)

My fault. Comments on all overwritten stuff accepted

>> diff --git a/Documentation/devicetree/bindings/mfd/stmpe.txt b/Documentation/devicetree/bindings/mfd/stmpe.txt
>> +- irq-over-gpio: bool, true if gpio is used to get irq
>> +- irq-gpios: gpio number over which irq will be requested (significant only if
>> +  irq-over-gpio is true)
>
> You don't need these. Use gpio_to_irq() instead.

I am passing gpio numbers here and am doing gpio_to_irq() in driver.
Didn't get this one :(

>>  Optional properties:
>> - - interrupts                   : The interrupt outputs from the controller
>> - - interrupt-controller         : Marks the device node as an interrupt controller
>> - - interrupt-parent             : Specifies which IRQ controller we're connected to
>> - - i2c-client-wake              : Marks the input device as wakable
>> - - st,autosleep-timeout         : Valid entries (ms); 4, 16, 32, 64, 128, 256, 512 and 1024
>
> And you've removed these why?

No. They are readjusted...

One thing removed is interrupt-controller. I had a doubt on this.
stmpe, by itself doesn't give any interrupt lines to SoC to freely use
them. Instead
gpio controller driver part of it does. And so adding
interrupt-controller for that is
the right option.

stmpe is an interrupt controller for the IP's which are present inside
it: gpio, adc.
But interrupt lines for them are managed by stmpe driver internally. So should
we really add interrupt-controller for it?

>> +- keypad,scan-count: number of key scanning cycles to confirm key data. Maximum
>> +  is STMPE_KEYPAD_MAX_SCAN_COUNT.
>> +- keypad,debounce-ms: debounce interval, in ms. Maximum is
>> +  STMPE_KEYPAD_MAX_DEBOUNCE.
>> +- keypad,no-autorepeat: bool, disable key autorepeat
>
> See "When adding new bindings, ask yourself" above.

Yes, these are required. This is part of platform data it expects.

>> +stmpe-ts:
>> +-----------

> See "When adding new bindings, ask yourself" above.

Same. Can you explicitly point out, which bindings you didn't like.

>> +spi@e0100000 {
>
> This shouldn't be a child of the SPI device becuase it uses SPI.
>
> Drivers use clocks, regulators, IRQ controller too, but they're
> not children of those devices.

Yes.

>> +             reg = <0>;
>
> You have reg twice here. Also reg should never be '0'.

For SPI, there are chip selects and there is no reg offset.

>> +             stmpe610-ts {
>> +                     compatible = "stmpe,ts";
>> +                     ts,sample-time = <4>;
>> +                     ts,mod-12b = <1>;
>> +                     ts,ref-sel = <0>;
>> +                     ts,adc-freq = <1>;
>> +                     ts,ave-ctrl = <1>;
>> +                     ts,touch-det-delay = <2>;
>> +                     ts,settling = <2>;
>> +                     ts,fraction-z = <7>;
>> +                     ts,i-drive = <1>;
>
> Wow! See "When adding new bindings, ask yourself" above.

:)
They are required. I didn't get your point, sorry.

>> diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
>> +static struct stmpe_keypad_platform_data *
>> +get_keyboard_pdata_dt(struct device *dev, struct device_node *np)
>> +{
>> +     struct stmpe_keypad_platform_data *pdata;
>> +     u32 val;
>> +
>> +     pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
>> +     if (!pdata) {
>> +             dev_warn(dev, "stmpe keypad kzalloc fail\n");
>> +             return NULL;
>> +     }
>> +
>> +     if (!of_property_read_u32(np, "keypad,scan-count", &val))
>> +             pdata->scan_count = val;
>> +     if (!of_property_read_u32(np, "keypad,debounce-ms", &val))
>> +             pdata->debounce_ms = val;
>> +     if (of_property_read_bool(np, "keypad,no-autorepeat"))
>> +             pdata->no_autorepeat = true;
>
> Why are you (re)adding these here? Have you even looked in the driver?

Because i wanted to keep all DT stuff together. Obviously i have seen keypad
driver earlier :)

I am not setting pdata of stmpe here, but pdata of keypad.

>> +static struct stmpe_gpio_platform_data *get_gpio_pdata_dt(struct device *dev,
>> +             struct device_node *np)
>> +{
>> +     struct stmpe_gpio_platform_data *pdata;
>> +     u32 val;
>> +
>> +     pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
>> +     if (!pdata) {
>> +             dev_warn(dev, "stmpe gpio kzalloc fail\n");
>> +             return NULL;
>> +     }
>> +
>> +     if (!of_property_read_u32(np, "gpio,norequest-mask", &val))
>> +             pdata->norequest_mask = val;
>> +
>> +     /* assign gpio numbers dynamically */
>> +     pdata->gpio_base = -1;
>> +
>> +     return pdata;
>> +}
>
> Is this function really required? Even if is is, should it live here
> or in the STMPE driver?

As said earlier, either i can do DT parsing of sub-modules of stmpe in
their specific files or in stmpe driver itself. Because currently platform
data of those sub-modules is passed from stmpe, i kept them here only.
stmpe sub modules can't live without stmpe driver and so keeping all
binding stuff here isn't that bad of an idea.

>> +static struct stmpe_ts_platform_data *get_ts_pdata_dt(struct device *dev,
>> +             struct device_node *np)
>> +{
>> +     struct stmpe_ts_platform_data *pdata;
>> +     u32 val;
>> +
>> +     pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
>> +     if (!pdata) {
>> +             dev_warn(dev, "stmpe ts kzalloc fail\n");
>> +             return NULL;
>> +     }
>> +
>> +     if (!of_property_read_u32(np, "ts,sample-time", &val))
>> +             pdata->sample_time = val;
>> +     if (!of_property_read_u32(np, "ts,mod-12b", &val))
>> +             pdata->mod_12b = val;
>> +     if (!of_property_read_u32(np, "ts,ref-sel", &val))
>> +             pdata->ref_sel = val;
>> +     if (!of_property_read_u32(np, "ts,adc-freq", &val))
>> +             pdata->adc_freq = val;
>> +     if (!of_property_read_u32(np, "ts,ave-ctrl", &val))
>> +             pdata->ave_ctrl = val;
>> +     if (!of_property_read_u32(np, "ts,touch-det-delay", &val))
>> +             pdata->touch_det_delay = val;
>> +     if (!of_property_read_u32(np, "ts,settling", &val))
>> +             pdata->settling = val;
>> +     if (!of_property_read_u32(np, "ts,fraction-z", &val))
>> +             pdata->fraction_z = val;
>> +     if (!of_property_read_u32(np, "ts,i-drive", &val))
>> +             pdata->i_drive = val;
>> +
>> +     return pdata;
>> +}
>
> As above.
>
> I'm going to stop my review here. I think you get the idea.

I got most of your worries, but couldn't understand the issue of passing
all pdata fields as DT bindings.

Thanks for your review though. :)

--
viresh
