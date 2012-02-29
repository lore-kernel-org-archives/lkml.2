Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab2B2RvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:51:01 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57248 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757418Ab2B2Ru6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:50:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of andi.shyti@gmail.com designates 10.52.173.179 as permitted sender) smtp.mail=andi.shyti@gmail.com; dkim=pass header.i=andi.shyti@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330532668-5673-3-git-send-email-arun.murthy@stericsson.com>
References: <1330532668-5673-1-git-send-email-arun.murthy@stericsson.com>
	<1330532668-5673-3-git-send-email-arun.murthy@stericsson.com>
Date: Wed, 29 Feb 2012 18:50:57 +0100
Message-ID: <CANndwHasH6cVdVu=bzYkz2Ri8Hp5OBzaMeVmp6hMkvP99ujc6w@mail.gmail.com>
Subject: Re: [PATCH 2/4] power: ab8500-charger: AB8500 charger driver
From: Andi <andi.shyti@gmail.com>
To: Arun Murthy <arun.murthy@stericsson.com>
Cc: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        karl.komierowski@stericsson.com, johan.palsson@stericsson.com,
        linus.walleij@linaro.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Feb 29, 2012 at 5:24 PM, Arun Murthy <arun.murthy@stericsson.com> wrote:
> This driver is responsible for detecting the ac/usb plugin and also includes
> function to enable ac/usb charging and re-kick the watchdog.
> It registers with the power supply class and provides information to the user
> space. The information include status of ac/usb charger device.
> This information in turn will be used by the abx500 charging algorithm driver
> to enable/disable and monitor charging.
>
> Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/power/ab8500_charger.c       | 2789 ++++++++++++++++++++++++++++++++++
>  include/linux/mfd/abx500/ab8500-bm.h |  554 +++++++
>  2 files changed, 3343 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/power/ab8500_charger.c
>  create mode 100644 include/linux/mfd/abx500/ab8500-bm.h
>
> diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
> new file mode 100644
> index 0000000..bbc541a
> --- /dev/null
> +++ b/drivers/power/ab8500_charger.c
> @@ -0,0 +1,2789 @@
> +/**
> + * ab8500_charger_init_hw_registers() - Set up charger related registers
> + * @di:                pointer to the ab8500_charger structure
> + *
> + * Set up charger OVV, watchdog and maximum voltage registers as well as
> + * charging of the backup battery
> + */
> +static int ab8500_charger_init_hw_registers(struct ab8500_charger *di)
> +{
> +       int ret = 0;
> +
> +       /* Setup maximum charger current and voltage for ABB cut2.0 */
> +       if (!is_ab8500_1p1_or_earlier(di->parent)) {
> +               ret = abx500_set_register_interruptible(di->dev,
> +                       AB8500_CHARGER,
> +                       AB8500_CH_VOLT_LVL_MAX_REG, CH_VOL_LVL_4P6);
> +               if (ret) {
> +                       dev_err(di->dev,
> +                               "failed to set CH_VOLT_LVL_MAX_REG\n");
> +                       goto out;
> +               }
> +
> +               ret = abx500_set_register_interruptible(di->dev,
> +                       AB8500_CHARGER,
> +                       AB8500_CH_OPT_CRNTLVL_MAX_REG, CH_OP_CUR_LVL_1P6);
> +               if (ret) {
> +                       dev_err(di->dev,
> +                               "failed to set CH_OPT_CRNTLVL_MAX_REG\n");
> +                       goto out;
> +               }
> +       }
> +
> +       /* VBUS OVV set to 6.3V and enable automatic current limitiation */
> +       ret = abx500_set_register_interruptible(di->dev,
> +               AB8500_CHARGER,
> +               AB8500_USBCH_CTRL2_REG,
> +               VBUS_OVV_SELECT_6P3V | VBUS_AUTO_IN_CURR_LIM_ENA);
> +       if (ret) {
> +               dev_err(di->dev, "failed to set VBUS OVV\n");
> +               goto out;
> +       }
> +
> +       /* Enable main watchdog in OTP */
> +       ret = abx500_set_register_interruptible(di->dev,
> +               AB8500_OTP_EMUL, AB8500_OTP_CONF_15, OTP_ENABLE_WD);
> +       if (ret) {
> +               dev_err(di->dev, "failed to enable main WD in OTP\n");
> +               goto out;
> +       }
> +
> +       /* Enable main watchdog */
> +       ret = abx500_set_register_interruptible(di->dev,
> +               AB8500_SYS_CTRL2_BLOCK,
> +               AB8500_MAIN_WDOG_CTRL_REG, MAIN_WDOG_ENA);
> +       if (ret) {
> +               dev_err(di->dev, "faile to enable main watchdog\n");
> +               goto out;
> +       }
> +
> +       /*
> +        * Due to internal synchronisation, Enable and Kick watchdog bits
> +        * cannot be enabled in a single write.
> +        * A minimum delay of 2*32 kHz period (62.5µs) must be inserted
> +        * between writing Enable then Kick bits.
> +        */
> +       udelay(63);

Are you sure about this udelay?

> +
> +       /* Kick main watchdog */
> +       ret = abx500_set_register_interruptible(di->dev,
> +               AB8500_SYS_CTRL2_BLOCK,
> +               AB8500_MAIN_WDOG_CTRL_REG,
> +               (MAIN_WDOG_ENA | MAIN_WDOG_KICK));
> +       if (ret) {
> +               dev_err(di->dev, "failed to kick main watchdog\n");
> +               goto out;
> +       }
> +
> +       /* Disable main watchdog */
> +       ret = abx500_set_register_interruptible(di->dev,
> +               AB8500_SYS_CTRL2_BLOCK,
> +               AB8500_MAIN_WDOG_CTRL_REG, MAIN_WDOG_DIS);
> +       if (ret) {
> +               dev_err(di->dev, "failed to disable main watchdog\n");
> +               goto out;
> +       }
> +
> +       /* Set watchdog timeout */
> +       ret = abx500_set_register_interruptible(di->dev, AB8500_CHARGER,
> +               AB8500_CH_WD_TIMER_REG, WD_TIMER);
> +       if (ret) {
> +               dev_err(di->dev, "failed to set charger watchdog timeout\n");
> +               goto out;
> +       }
> +
> +       /* Backup battery voltage and current */
> +       ret = abx500_set_register_interruptible(di->dev,
> +               AB8500_RTC,
> +               AB8500_RTC_BACKUP_CHG_REG,
> +               di->bat->bkup_bat_v |
> +               di->bat->bkup_bat_i);
> +       if (ret) {
> +               dev_err(di->dev, "failed to setup backup battery charging\n");
> +               goto out;
> +       }
> +
> +       /* Enable backup battery charging */
> +       abx500_mask_and_set_register_interruptible(di->dev,
> +               AB8500_RTC, AB8500_RTC_CTRL_REG,
> +               RTC_BUP_CH_ENA, RTC_BUP_CH_ENA);
> +       if (ret < 0)
> +               dev_err(di->dev, "%s mask and set failed\n", __func__);
> +
> +out:
> +       return ret;
> +}
