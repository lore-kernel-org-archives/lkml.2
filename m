Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab2EJHY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 03:24:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53972 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab2EJHYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 03:24:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120509184709.GC32037@sirena.org.uk>
References: <1336580695-1184-1-git-send-email-yadi.brar@samsung.com>
	<1336580695-1184-3-git-send-email-yadi.brar@samsung.com>
	<20120509184709.GC32037@sirena.org.uk>
Date: Thu, 10 May 2012 12:54:24 +0530
Message-ID: <CAKew6eWEYBP1zXXwLL4eWOhOKZ-HwAfUX_kg8cnsaDyUXVKSkQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] regulator: Add support for MAX77686.
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Yadwinder Singh <yadi.brar@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, May 10, 2012 at 12:17 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, May 09, 2012 at 09:54:55PM +0530, Yadwinder Singh wrote:
>
>> +/* Voltage maps in mV */
>> +static const struct voltage_map_desc ldo_voltage_map_desc = {
>> +     .min = 800,     .max = 3950,    .step = 50,     .n_bits = 6,
>> +};                           /* LDO3 ~ 5, 9 ~ 14, 16 ~ 26 */
>
> Hrm, funnily enough I was just thinking about factoring this stuff out
> into the core after a conversation with Graeme Gregory the other week.
> Let's do that...
>
>> +     [MAX77686_EN32KHZ_AP] = NULL,
>> +     [MAX77686_EN32KHZ_CP] = NULL,
>
> Now that the generic clock API is in mainline these should be moved over
> to use it.
>

Sorry, I cann't get your point here. Please explain it little bit more.

>> +static int max77686_get_voltage_unit(int rid)
>> +{
>> +     int unit = 0;
>> +
>> +     switch (rid) {
>> +     case MAX77686_BUCK2...MAX77686_BUCK4:
>> +             unit = 1;       /* BUCK2,3,4 is uV */
>> +             break;
>> +     default:
>> +             unit = 1000;
>
> Why not just list everything in uV?
>

Yes, everything should be in uV, I will correct it.

>> +static int max77686_get_voltage(struct regulator_dev *rdev)
>> +{
>
> Implement get_voltage_sel().
>
>> +static inline int max77686_get_voltage_proper_val(const struct voltage_map_desc
>> +                                               *desc, int min_vol,
>> +                                               int max_vol)
>> +{
>> +     int i = 0;
>> +
>> +     if (desc == NULL)
>> +             return -EINVAL;
>> +
>> +     if (max_vol < desc->min || min_vol > desc->max)
>> +             return -EINVAL;
>> +
>> +     while (desc->min + desc->step * i < min_vol &&
>> +            desc->min + desc->step * i < desc->max)
>> +             i++;
>
> Why are you iterating here?  Calculate!  Though like I say let's factor
> this out anyway.
>

Yes, I will do it.

>> +     if (rid == MAX77686_BUCK2 || rid == MAX77686_BUCK3 ||
>> +         rid == MAX77686_BUCK4) {
>> +             /* If the voltage is increasing */
>> +             if (org < i)
>> +                     udelay(DIV_ROUND_UP(desc->step * (i - org),
>> +                                         ramp[max77686->ramp_delay]));
>> +     }
>
> Don't do this, implement set_voltage_time_sel().
>

Ok, I will implement it.

>> +     .enable = max77686_reg_enable,
>> +     .disable = max77686_reg_disable,
>> +     .set_suspend_enable = max77686_reg_enable,
>> +     .set_suspend_disable = max77686_reg_disable,
>
> You've got the same ops for suspend and non-suspend cases here, this is
> clearly buggy.
>
>> +/* count the number of regulators to be supported in pmic */
>> +     pdata->num_regulators = 0;
>
> Coding style.
>
>> +     if (iodev->dev->of_node) {
>> +             ret = max77686_pmic_dt_parse_pdata(iodev, pdata);
>> +             if (ret)
>> +                     return ret;
>
> This ought to use of_regulator_match().
>

Ok, I will look into it.

>> +     }
>> +
>> +     if (!pdata) {
>> +             dev_err(&pdev->dev, "platform data not found\n");
>> +             return -ENODEV;
>> +     }
>
> This should be totally fine.
>

I will look into it.

>> +     max77686 = kzalloc(sizeof(struct max77686_data), GFP_KERNEL);
>> +     if (!max77686)
>> +             return -ENOMEM;
>
> devm_kzalloc().
>

Yes, its better option.

>> +     if (pdata->ramp_delay) {
>> +             max77686->ramp_delay = pdata->ramp_delay;
>> +             max77686_update_reg(i2c, MAX77686_REG_BUCK2CTRL1,
>> +                     RAMP_VALUE, RAMP_MASK);
>
> This appears not to actually use the value passed in as platform_data.
>

It gets corresponding index of ramp_rate value in ramp_rate_value
table supported by hardware, from platform_data which we write to
ramp_rate control bits of control registers.

>> +
>> +     for (i = 0; i < pdata->num_regulators; i++) {
>> +             const struct voltage_map_desc *desc;
>> +             int id = pdata->regulators[i].id;
>> +
>> +             desc = reg_voltage_map[id];
>> +             if (desc)
>> +                     regulators[id].n_voltages =
>> +                         (desc->max - desc->min) / desc->step + 1;
>> +
>> +             rdev[i] = regulator_register(&regulators[id], max77686->dev,
>> +                                          pdata->regulators[i].initdata,
>> +                                          max77686, NULL);
>
> No, you should unconditionally register all regulators the device
> physically has.  This is useful for debug and simplifies the code.
>

Ok. I will do it.

> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

Thanks,
Yadwinder.
