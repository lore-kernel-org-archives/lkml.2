Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab1BAVYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:24:20 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64592 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab1BAVYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:24:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O5tLUbGTvTcGIqURJp8a8WLh/QDrNrjZbTnM6ZVbatjgEgwudChxKGOpQreHGARXZk
         C/k/7iiS/lNBlHEfQwsVbZXygRg+gH6L7XwGaWoq6tTLdMdo+YmRw8aTDml3NVJPGZIQ
         qtL2c3KNaFrC0A8B7OqcxT0aiZxf5AYfaDZBc=
MIME-Version: 1.0
In-Reply-To: <1295538108-26451-1-git-send-email-weber@corscience.de>
References: <1295538108-26451-1-git-send-email-weber@corscience.de>
Date: Tue, 1 Feb 2011 22:24:15 +0100
Message-ID: <AANLkTi=mbJrNSfRqRzqAvKmhU-LgRiYq0KDC2zekWdqm@mail.gmail.com>
Subject: Re: [PATCHv5] OMAP3: Devkit8000: Change lcd power pin
From: Thomas Weber <thomas.weber.linux@googlemail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        "open list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Daniel Morsing <daniel.morsing@gmail.com>, charu@ti.com,
        sshtylyov@mvista.com, manjugk@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 4:41 PM, Thomas Weber <weber@corscience.de> wrote:
> This patch fixes a wrongly used lcd enable pin.
>
> The Devkit8000 uses twl4030_ledA configured as output gpio only for
> the lcd enable line. twl4030_gpio.1 is used through the generic
> gpio functions while ledA is used via low level twl4030 calls.
>
> This patch removes the low level calls and use the generic gpio functions
> for initialization and use of ledA. This patch also fixes a bug where the
> lcd would not power down when blanking.
>
> Further this patch fixes an indentation issue. The comment line uses
> eight whitespace and is replaced with a hard tab.
>
> gpio_request + gpio_direction_output are replaced with gpio_request_one.
> The return value of gpio_request_one is used to set the value of the
> gpio to -EINVAL when unsuccessful, so that gpio_is_valid can detect the
> unsuccessful request. But already successful requested gpios are not freed.
>
> Reported-by: Daniel Morsing <daniel.morsing@gmail.com>
> Signed-off-by: Thomas Weber <weber@corscience.de>
> ---
> Changes from v4:
>        Merge of two patches
>        Use of gpio_request_one instead of gpio_request + gpio_direction_output
> Changes from v3:
>        Use return value of gpio_request
> Changes from v2:
>        Fix indention => indentation
>        Better comment for removing low level functions used for twl4030 gpio
> Changes from v1:
>        Pull the indentation fix into this patch
>        Change the pin for lcd pwren
>
>  arch/arm/mach-omap2/board-devkit8000.c |   27 ++++++++++++++++-----------
>  1 files changed, 16 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
> index a5eb955..e4c12fe 100644
> --- a/arch/arm/mach-omap2/board-devkit8000.c
> +++ b/arch/arm/mach-omap2/board-devkit8000.c
> @@ -115,9 +115,6 @@ static struct omap2_hsmmc_info mmc[] = {
>
>  static int devkit8000_panel_enable_lcd(struct omap_dss_device *dssdev)
>  {
> -       twl_i2c_write_u8(TWL4030_MODULE_GPIO, 0x80, REG_GPIODATADIR1);
> -       twl_i2c_write_u8(TWL4030_MODULE_LED, 0x0, 0x0);
> -
>        if (gpio_is_valid(dssdev->reset_gpio))
>                gpio_set_value_cansleep(dssdev->reset_gpio, 1);
>        return 0;
> @@ -247,6 +244,8 @@ static struct gpio_led gpio_leds[];
>  static int devkit8000_twl_gpio_setup(struct device *dev,
>                unsigned gpio, unsigned ngpio)
>  {
> +       int ret;
> +
>        omap_mux_init_gpio(29, OMAP_PIN_INPUT);
>        /* gpio + 0 is "mmc0_cd" (input/IRQ) */
>        mmc[0].gpio_cd = gpio + 0;
> @@ -255,17 +254,23 @@ static int devkit8000_twl_gpio_setup(struct device *dev,
>        /* TWL4030_GPIO_MAX + 1 == ledB, PMU_STAT (out, active low LED) */
>        gpio_leds[2].gpio = gpio + TWL4030_GPIO_MAX + 1;
>
> -        /* gpio + 1 is "LCD_PWREN" (out, active high) */
> -       devkit8000_lcd_device.reset_gpio = gpio + 1;
> -       gpio_request(devkit8000_lcd_device.reset_gpio, "LCD_PWREN");
> -       /* Disable until needed */
> -       gpio_direction_output(devkit8000_lcd_device.reset_gpio, 0);
> +       /* TWL4030_GPIO_MAX + 0 is "LCD_PWREN" (out, active high) */
> +       devkit8000_lcd_device.reset_gpio = gpio + TWL4030_GPIO_MAX + 0;
> +       ret = gpio_request_one(devkit8000_lcd_device.reset_gpio,
> +                       GPIOF_DIR_OUT | GPIOF_INIT_LOW, "LCD_PWREN");
> +       if (ret < 0) {
> +               devkit8000_lcd_device.reset_gpio = -EINVAL;
> +               printk(KERN_ERR "Failed to request GPIO for LCD_PWRN\n");
> +       }
>
>        /* gpio + 7 is "DVI_PD" (out, active low) */
>        devkit8000_dvi_device.reset_gpio = gpio + 7;
> -       gpio_request(devkit8000_dvi_device.reset_gpio, "DVI PowerDown");
> -       /* Disable until needed */
> -       gpio_direction_output(devkit8000_dvi_device.reset_gpio, 0);
> +       ret = gpio_request_one(devkit8000_dvi_device.reset_gpio,
> +                       GPIOF_DIR_OUT | GPIOF_INIT_LOW, "DVI PowerDown");
> +       if (ret < 0) {
> +               devkit8000_dvi_device.reset_gpio = -EINVAL;
> +               printk(KERN_ERR "Failed to request GPIO for DVI PowerDown\n");
> +       }
>
>        return 0;
>  }
> --
> 1.7.4.rc2
>
> --

Hello Tony,
can you apply this patch?

Thomas
