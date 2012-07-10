Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab2GJH2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 03:28:34 -0400
Received: from smtp-out-150.synserver.de ([212.40.185.150]:1063 "EHLO
	smtp-out-150.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab2GJH2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 03:28:33 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 28798
Message-ID: <4FFBDA85.8070708@metafoo.de>
Date: Tue, 10 Jul 2012 09:32:21 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Kevin Hilman <khilman@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] drivers/rtc/rtc-twl.c: fix threaded IRQ to use IRQF_ONESHOT
References: <1341592434-4207-1-git-send-email-khilman@ti.com> <20120709151527.58f44c3a.akpm@linux-foundation.org>
In-Reply-To: <20120709151527.58f44c3a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 12:15 AM, Andrew Morton wrote:
> On Fri,  6 Jul 2012 09:33:54 -0700
> Kevin Hilman <khilman@ti.com> wrote:
> 
>> Requesting a threaded interrupt without a primary handler and without
>> IRQF_ONESHOT is dangerous, and after commit 1c6c6952 (genirq: Reject
>> bogus threaded irq requests), these requests are rejected.  This
>> causes ->probe() to fail, and the RTC driver not to be availble.
>>
>> To fix, add IRQF_ONESHOT to the IRQ flags.
>>
>> Tested on OMAP3730/OveroSTORM and OMAP4430/Panda board using rtcwake
>> to wake from system suspend multiple times.
>>
>> Signed-off-by: Kevin Hilman <khilman@ti.com>
>> ---
>> Resending to broader audience and including Andrew.  Since, I understand
>> that drivers/rtc is somewhat orphaned, Andrew, can you queue this fix for
>> v3.5.  Thanks.
>>
>>  drivers/rtc/rtc-twl.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
>> index 258abea..c5d06fe 100644
>> --- a/drivers/rtc/rtc-twl.c
>> +++ b/drivers/rtc/rtc-twl.c
>> @@ -510,7 +510,7 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
>>  	}
>>  
>>  	ret = request_threaded_irq(irq, NULL, twl_rtc_interrupt,
>> -				   IRQF_TRIGGER_RISING,
>> +				   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
>>  				   dev_name(&rtc->dev), rtc);
>>  	if (ret < 0) {
>>  		dev_err(&pdev->dev, "IRQ is not free.\n");
> 
> OK, this is the second such patch I've seen and it's time to wonder if
> we should get grumpy at tglx.  afacit 1c6c6952 broke the following
> drivers:

If you want to be grumpy, be grumpy at Linus. Thomas actually posted a patch
which just emits a warning, instead of failing to request the IRQ, but Linus
didn't want to take it. The whole thread is here
https://lkml.org/lkml/2012/6/12/151

> 
> 
> sound/soc/codecs/wm8994.c
> sound/soc/codecs/max98095.c
> sound/soc/codecs/twl6040.c
> drivers/usb/otg/ab8500-usb.c
> drivers/usb/otg/twl4030-usb.c
> drivers/gpio/gpio-sx150x.c
> drivers/gpio/gpio-ab8500.c
> drivers/mfd/ab8500-gpadc.c
> drivers/mfd/ti-ssp.c
> drivers/mfd/twl4030-madc.c
> drivers/mfd/htc-i2cpld.c
> drivers/mfd/wm831x-auxadc.c
> drivers/mfd/twl6040-core.c
> drivers/mfd/wm8350-core.c
> drivers/extcon/extcon-max8997.c
> drivers/mmc/host/of_mmc_spi.c
> drivers/mmc/core/cd-gpio.c
> drivers/net/can/mcp251x.c
> drivers/nfc/pn544_hci.c
> drivers/nfc/pn544.c
> drivers/power/ab8500_btemp.c
> drivers/power/twl4030_charger.c
> drivers/power/lp8727_charger.c
> drivers/power/smb347-charger.c
> drivers/power/max17042_battery.c
> drivers/power/wm831x_power.c
> drivers/power/ab8500_fg.c
> drivers/power/max8903_charger.c
> drivers/power/ab8500_charger.c
> drivers/regulator/wm831x-isink.c
> drivers/regulator/wm831x-ldo.c
> drivers/regulator/wm831x-dcdc.c
> drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> drivers/staging/iio/adc/adt7310.c
> drivers/staging/iio/adc/adt7410.c
> drivers/staging/iio/adc/ad7816.c
> drivers/staging/iio/cdc/ad7150.c
> drivers/staging/iio/accel/sca3000_core.c
> drivers/staging/cptm1217/clearpad_tm1217.c
> drivers/input/keyboard/tc3589x-keypad.c
> drivers/input/keyboard/twl4030_keypad.c
> drivers/input/misc/twl4030-pwrbutton.c
> drivers/input/misc/twl6040-vibra.c
> drivers/input/misc/wm831x-on.c
> drivers/media/radio/si470x/radio-si470x-i2c.c
> drivers/base/regmap/regmap-irq.c
> drivers/rtc/rtc-wm831x.c
> drivers/rtc/rtc-twl.c
> drivers/rtc/rtc-ab8500.c
> drivers/rtc/rtc-max8998.c
> drivers/rtc/rtc-isl1208.c
> drivers/platform/x86/intel_mid_powerbtn.c
> include/linux/mfd/wm8994/core.h
> include/linux/mfd/wm8350/core.h
> 
> what am I missing here?
> 

Most of these drivers are not broken (anymore), the majority drivers which
were broken by Thomas's patch have already been fixed. As for your list:
I've already sent out a fix for all of the staging/iio/ drivers a couple of
days ago. And drivers which use nested interrupts are not affected by this
problem. In your list these are basically all drivers with wm*, twl* and
ab8500 in their names. But still leaves a handful of broken driver which
should be fixed.

- Lars
