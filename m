Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab2KHHOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 02:14:43 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41904 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab2KHHOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 02:14:41 -0500
Message-ID: <509B5BDC.3030005@ti.com>
Date: Thu, 8 Nov 2012 08:14:36 +0100
From: =?UTF-8?B?UMOpdGVyIFVqZmFsdXNp?= <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121105 Thunderbird/16.0.1
MIME-Version: 1.0
To: Grazvydas Ignotas <notasas@gmail.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Tero Kristo <t-kristo@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/3] pwm: New driver to support PWMs on TWL4030/6030 series
 of PMICs
References: <1352299488-11351-1-git-send-email-peter.ujfalusi@ti.com> <1352299488-11351-3-git-send-email-peter.ujfalusi@ti.com> <CANOLnOM7sp+O+KBKjiRk2drWh_63D6-bY86dx+upWkrvs7pp9w@mail.gmail.com>
In-Reply-To: <CANOLnOM7sp+O+KBKjiRk2drWh_63D6-bY86dx+upWkrvs7pp9w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 06:50 PM, Grazvydas Ignotas wrote:
>> +static int twl4030_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +       int ret;
>> +       u8 val;
>> +
>> +       ret = twl_i2c_read_u8(TWL4030_MODULE_INTBR, &val, TWL4030_GPBR1_REG);
>> +       if (ret < 0) {
>> +               dev_err(chip->dev, "%s: Failed to read GPBR1\n", pwm->label);
>> +               return ret;
>> +       }
>> +
>> +       val |= TWL4030_PWM_TOGGLE(pwm->hwpwm, TWL4030_PWMX_BITS);
> 
> In my experience doing it like this doesn't work reliably, i.e.
> sometimes it just won't enable. I had to first set CLK_ENABLE bit, and
> then ENABLE bit with separate i2c write. Perhaps it needs a cycle or
> two of 32k clock or something (that doesn't seem to be documented
> though).

Thanks, I'll change to the reliable sequence. I do not have HW where I can
test the twl4030 PWMs.

> 
>> +
>> +       ret = twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL4030_GPBR1_REG);
>> +       if (ret < 0)
>> +               dev_err(chip->dev, "%s: Failed to enable PWM\n", pwm->label);
>> +
>> +       return ret;
>> +}
>> +
>> +static void twl4030_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +       int ret;
>> +       u8 val;
>> +
>> +       ret = twl_i2c_read_u8(TWL4030_MODULE_INTBR, &val, TWL4030_GPBR1_REG);
>> +       if (ret < 0) {
>> +               dev_err(chip->dev, "%s: Failed to read GPBR1\n", pwm->label);
>> +               return;
>> +       }
>> +
>> +       val &= ~TWL4030_PWM_TOGGLE(pwm->hwpwm, TWL4030_PWMX_BITS);
> 
> Same problem here, I would sometimes get LED stuck at full brightness
> after this, first clearing ENABLE and then CLK_ENABLE fixed it (we
> have charger LED connected to PWM1 on pandora).

I would guessed that if we need special care we should have turned off CLK
followed by disabling the PWM.
I'll use the sequence you described in the next version.

> 
>> +
>> +       ret = twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL4030_GPBR1_REG);
>> +       if (ret < 0)
>> +               dev_err(chip->dev, "%s: Failed to disable PWM\n", pwm->label);
>> +}
>> +
>> +static int twl4030_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +       struct twl_pwm_chip *twl = container_of(chip, struct twl_pwm_chip,
>> +                                               chip);
>> +       int ret;
>> +       u8 val, mask, bits;
>> +
>> +       ret = twl_i2c_read_u8(TWL4030_MODULE_INTBR, &val, TWL4030_PMBR1_REG);
>> +       if (ret < 0) {
>> +               dev_err(chip->dev, "%s: Failed to read PMBR1\n", pwm->label);
>> +               return ret;
>> +       }
>> +
>> +       if (pwm->hwpwm) {
>> +               /* PWM 1 */
>> +               mask = TWL4030_GPIO7_VIBRASYNC_PWM1_MASK;
>> +               bits = TWL4030_GPIO7_VIBRASYNC_PWM1_PWM1;
>> +       } else {
>> +               /* PWM 0 */
>> +               mask = TWL4030_GPIO6_PWM0_MUTE_MASK;
>> +               bits = TWL4030_GPIO6_PWM0_MUTE_PWM0;
>> +       }
>> +
>> +       /* Save the current MUX configuration for the PWM */
>> +       twl->twl4030_pwm_mux &= ~mask;
>> +       twl->twl4030_pwm_mux |= (val & mask);
> 
> Do we really need this mask clearing here? After probe twl4030_pwm_mux
> should be zero, and if twl4030_pwm_request is called twice you don't
> clear the important bits before |=, I think 'twl4030_pwm_mux = val &
> mask' would be better here.

I'm storing both PWM's state in the same variable, but in different offsets:
PWM0: bits 2-3
PWM1: bits 4-5
Probably it is over engineering to clear the relevant bits in the backup
storage, but better to be safe IMHO.
I would leave this part as it is.

-- 
Péter
