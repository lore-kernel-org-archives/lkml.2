Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab2KGRu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 12:50:56 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56823 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab2KGRuy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 12:50:54 -0500
MIME-Version: 1.0
In-Reply-To: <1352299488-11351-3-git-send-email-peter.ujfalusi@ti.com>
References: <1352299488-11351-1-git-send-email-peter.ujfalusi@ti.com>
	<1352299488-11351-3-git-send-email-peter.ujfalusi@ti.com>
Date: Wed, 7 Nov 2012 19:50:53 +0200
Message-ID: <CANOLnOM7sp+O+KBKjiRk2drWh_63D6-bY86dx+upWkrvs7pp9w@mail.gmail.com>
Subject: Re: [PATCH 2/3] pwm: New driver to support PWMs on TWL4030/6030
 series of PMICs
From: Grazvydas Ignotas <notasas@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Tero Kristo <t-kristo@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 4:44 PM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> The driver supports the following PWM outputs:
> TWL4030 PWM0 and PWM1
> TWL6030 PWM1 and PWM2
>
> On TWL4030 the PWM signals are muxed. Upon requesting the PWM the driver
> will select the correct mux so the PWM can be used. When the PWM has been
> freed the original configuration going to be restored.
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/pwm/Kconfig   |  10 ++
>  drivers/pwm/Makefile  |   1 +
>  drivers/pwm/pwm-twl.c | 304 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 315 insertions(+)
>  create mode 100644 drivers/pwm/pwm-twl.c
>

<snip>

> --- /dev/null
> +++ b/drivers/pwm/pwm-twl.c

<snip>

> +
> +static int twl4030_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +       int ret;
> +       u8 val;
> +
> +       ret = twl_i2c_read_u8(TWL4030_MODULE_INTBR, &val, TWL4030_GPBR1_REG);
> +       if (ret < 0) {
> +               dev_err(chip->dev, "%s: Failed to read GPBR1\n", pwm->label);
> +               return ret;
> +       }
> +
> +       val |= TWL4030_PWM_TOGGLE(pwm->hwpwm, TWL4030_PWMX_BITS);

In my experience doing it like this doesn't work reliably, i.e.
sometimes it just won't enable. I had to first set CLK_ENABLE bit, and
then ENABLE bit with separate i2c write. Perhaps it needs a cycle or
two of 32k clock or something (that doesn't seem to be documented
though).

> +
> +       ret = twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL4030_GPBR1_REG);
> +       if (ret < 0)
> +               dev_err(chip->dev, "%s: Failed to enable PWM\n", pwm->label);
> +
> +       return ret;
> +}
> +
> +static void twl4030_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +       int ret;
> +       u8 val;
> +
> +       ret = twl_i2c_read_u8(TWL4030_MODULE_INTBR, &val, TWL4030_GPBR1_REG);
> +       if (ret < 0) {
> +               dev_err(chip->dev, "%s: Failed to read GPBR1\n", pwm->label);
> +               return;
> +       }
> +
> +       val &= ~TWL4030_PWM_TOGGLE(pwm->hwpwm, TWL4030_PWMX_BITS);

Same problem here, I would sometimes get LED stuck at full brightness
after this, first clearing ENABLE and then CLK_ENABLE fixed it (we
have charger LED connected to PWM1 on pandora).

> +
> +       ret = twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL4030_GPBR1_REG);
> +       if (ret < 0)
> +               dev_err(chip->dev, "%s: Failed to disable PWM\n", pwm->label);
> +}
> +
> +static int twl4030_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +       struct twl_pwm_chip *twl = container_of(chip, struct twl_pwm_chip,
> +                                               chip);
> +       int ret;
> +       u8 val, mask, bits;
> +
> +       ret = twl_i2c_read_u8(TWL4030_MODULE_INTBR, &val, TWL4030_PMBR1_REG);
> +       if (ret < 0) {
> +               dev_err(chip->dev, "%s: Failed to read PMBR1\n", pwm->label);
> +               return ret;
> +       }
> +
> +       if (pwm->hwpwm) {
> +               /* PWM 1 */
> +               mask = TWL4030_GPIO7_VIBRASYNC_PWM1_MASK;
> +               bits = TWL4030_GPIO7_VIBRASYNC_PWM1_PWM1;
> +       } else {
> +               /* PWM 0 */
> +               mask = TWL4030_GPIO6_PWM0_MUTE_MASK;
> +               bits = TWL4030_GPIO6_PWM0_MUTE_PWM0;
> +       }
> +
> +       /* Save the current MUX configuration for the PWM */
> +       twl->twl4030_pwm_mux &= ~mask;
> +       twl->twl4030_pwm_mux |= (val & mask);

Do we really need this mask clearing here? After probe twl4030_pwm_mux
should be zero, and if twl4030_pwm_request is called twice you don't
clear the important bits before |=, I think 'twl4030_pwm_mux = val &
mask' would be better here.


-- 
Gražvydas
