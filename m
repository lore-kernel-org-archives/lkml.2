Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab2GIWPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 18:15:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab2GIWP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:15:29 -0400
Date: Mon, 9 Jul 2012 15:15:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Hilman <khilman@ti.com>
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] drivers/rtc/rtc-twl.c: fix threaded IRQ to use
 IRQF_ONESHOT
Message-Id: <20120709151527.58f44c3a.akpm@linux-foundation.org>
In-Reply-To: <1341592434-4207-1-git-send-email-khilman@ti.com>
References: <1341592434-4207-1-git-send-email-khilman@ti.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Jul 2012 09:33:54 -0700
Kevin Hilman <khilman@ti.com> wrote:

> Requesting a threaded interrupt without a primary handler and without
> IRQF_ONESHOT is dangerous, and after commit 1c6c6952 (genirq: Reject
> bogus threaded irq requests), these requests are rejected.  This
> causes ->probe() to fail, and the RTC driver not to be availble.
> 
> To fix, add IRQF_ONESHOT to the IRQ flags.
> 
> Tested on OMAP3730/OveroSTORM and OMAP4430/Panda board using rtcwake
> to wake from system suspend multiple times.
> 
> Signed-off-by: Kevin Hilman <khilman@ti.com>
> ---
> Resending to broader audience and including Andrew.  Since, I understand
> that drivers/rtc is somewhat orphaned, Andrew, can you queue this fix for
> v3.5.  Thanks.
> 
>  drivers/rtc/rtc-twl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
> index 258abea..c5d06fe 100644
> --- a/drivers/rtc/rtc-twl.c
> +++ b/drivers/rtc/rtc-twl.c
> @@ -510,7 +510,7 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
>  	}
>  
>  	ret = request_threaded_irq(irq, NULL, twl_rtc_interrupt,
> -				   IRQF_TRIGGER_RISING,
> +				   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
>  				   dev_name(&rtc->dev), rtc);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "IRQ is not free.\n");

OK, this is the second such patch I've seen and it's time to wonder if
we should get grumpy at tglx.  afacit 1c6c6952 broke the following
drivers:


sound/soc/codecs/wm8994.c
sound/soc/codecs/max98095.c
sound/soc/codecs/twl6040.c
drivers/usb/otg/ab8500-usb.c
drivers/usb/otg/twl4030-usb.c
drivers/gpio/gpio-sx150x.c
drivers/gpio/gpio-ab8500.c
drivers/mfd/ab8500-gpadc.c
drivers/mfd/ti-ssp.c
drivers/mfd/twl4030-madc.c
drivers/mfd/htc-i2cpld.c
drivers/mfd/wm831x-auxadc.c
drivers/mfd/twl6040-core.c
drivers/mfd/wm8350-core.c
drivers/extcon/extcon-max8997.c
drivers/mmc/host/of_mmc_spi.c
drivers/mmc/core/cd-gpio.c
drivers/net/can/mcp251x.c
drivers/nfc/pn544_hci.c
drivers/nfc/pn544.c
drivers/power/ab8500_btemp.c
drivers/power/twl4030_charger.c
drivers/power/lp8727_charger.c
drivers/power/smb347-charger.c
drivers/power/max17042_battery.c
drivers/power/wm831x_power.c
drivers/power/ab8500_fg.c
drivers/power/max8903_charger.c
drivers/power/ab8500_charger.c
drivers/regulator/wm831x-isink.c
drivers/regulator/wm831x-ldo.c
drivers/regulator/wm831x-dcdc.c
drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
drivers/staging/iio/adc/adt7310.c
drivers/staging/iio/adc/adt7410.c
drivers/staging/iio/adc/ad7816.c
drivers/staging/iio/cdc/ad7150.c
drivers/staging/iio/accel/sca3000_core.c
drivers/staging/cptm1217/clearpad_tm1217.c
drivers/input/keyboard/tc3589x-keypad.c
drivers/input/keyboard/twl4030_keypad.c
drivers/input/misc/twl4030-pwrbutton.c
drivers/input/misc/twl6040-vibra.c
drivers/input/misc/wm831x-on.c
drivers/media/radio/si470x/radio-si470x-i2c.c
drivers/base/regmap/regmap-irq.c
drivers/rtc/rtc-wm831x.c
drivers/rtc/rtc-twl.c
drivers/rtc/rtc-ab8500.c
drivers/rtc/rtc-max8998.c
drivers/rtc/rtc-isl1208.c
drivers/platform/x86/intel_mid_powerbtn.c
include/linux/mfd/wm8994/core.h
include/linux/mfd/wm8350/core.h

what am I missing here?
