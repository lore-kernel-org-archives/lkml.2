Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab1LHLxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 06:53:55 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33252 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab1LHLxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 06:53:51 -0500
MIME-Version: 1.0
In-Reply-To: <1314791341.5939.464.camel@rex>
References: <1314647628-21707-1-git-send-email-bryan.wu@canonical.com>
 <alpine.LFD.2.00.1108291630020.20358@xanadu.home> <1314653699.5939.299.camel@rex>
 <CAK5ve-+J3hzVB=_b0AOJ-Q1LYewahVraMti=y=6AaQy3+iy+rg@mail.gmail.com> <1314791341.5939.464.camel@rex>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Thu, 8 Dec 2011 19:53:30 +0800
X-Google-Sender-Auth: Sb9DanekS9RW2N7NtnosodAjzl0
Message-ID: <CAK5ve-LcUabPS2EGAPD7q3-_thS4XhmGyhafmRkOCUAAriaXSw@mail.gmail.com>
Subject: Re: [PATCH] leds: kill CONFIG_LEDS_CLASS option
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 7:49 PM, Richard Purdie <rpurdie@rpsys.net> wrote:
> On Wed, 2011-08-31 at 10:45 +0800, Bryan Wu wrote:
>> On Tue, Aug 30, 2011 at 5:34 AM, Richard Purdie <rpurdie@rpsys.net> wrote:
>> > On Mon, 2011-08-29 at 16:34 -0400, Nicolas Pitre wrote:
>> >> On Tue, 30 Aug 2011, Bryan Wu wrote:
>> >>
>> >> > Almost all the new leds driver and trigger driver are depends on
>> >> > CONFIG_LED_CLASS, so there is no such user with CONFIG_NEW_LEDS=y
>> >> > and CONFIG_LED_CLASS=n. Moreover, lots of API functions in led-class.c
>> >> > are very common and should be built-in when CONFIG_NEW_LEDS=y.
>> >> >
>> >> > Obviously, CONFIG_LEDS_CLASS is pointless. This patch kills it and
>> >> > also updates defconfigs which contains CONFIG_LEDS_CLASS.
>> >> >
>> >> > Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
>> >> > ---
>> >
>> > Looking at the code I'm a little concerned to see the direction this is
>> > going. There was originally a reason that there were two options, it was
>> > related to being able to compile as much of the LED code as a module as
>> > possible.
>> >
>>
>> I quite understand the original reason for 2 options, but I failed to
>> see any user of CONFIG_NEW_LEDS=y and CONFIG_LEDS_CLASS=n.
>
> Right, the intent was to support CONFIG_NEW_LEDS=y and
> CONFIG_LEDS_CLASS=m and I believe that still should be possible.
>
>> > It looks like commit 5ada28bf76752e33dce3d807bf0dfbe6d1b943ad changed
>> > the tristate to a bool at which point the separate option obviously
>> > becomes pointless.
>>
>> Exactly, this patch added some function API which are used very widely
>> as default LEDS driver behavior in some drivers.
>
> Looking at that commit, its adds the code to leds-class.c and shouldn't
> have needed to change the tristate to a bool. I know we discussed that
> at the time and I think that part might have been unnecessary and just
> accidentally committed. It could well be we can just revert that piece
> of the patch.
>

Richard,

Sorry for bringing up this topic so late. I was occupied by other
stuff for a while.

I'm trying to make leds-class.c as a module, but found APIs exported
from led-class.c are widely used in kernel.

For example: led_classdev_register()
--
linux-2.6$ grep -r led_classdev_register .
./include/linux/leds.h:extern int led_classdev_register(struct device *parent,
./drivers/mmc/host/au1xmmc.c:		ret = led_classdev_register(mmc_dev(mmc), led);
./drivers/mmc/host/sdhci.c:	ret = led_classdev_register(mmc_dev(mmc),
&host->led);
./drivers/macintosh/via-pmu-led.c:	return led_classdev_register(NULL, &pmu_led);
./drivers/input/joystick/xpad.c:	error =
led_classdev_register(&xpad->udev->dev, led_cdev);
./drivers/input/keyboard/lm8323.c:		if (led_classdev_register(dev,
&pwm->cdev) < 0) {
./drivers/input/misc/apanel.c:		err =
led_classdev_register(&client->dev, &ap->mail_led);
./drivers/input/misc/wistron_btns.c:			if
(led_classdev_register(parent, &wistron_wifi_led))
./drivers/input/misc/wistron_btns.c:		if
(led_classdev_register(parent, &wistron_mail_led))
./drivers/video/backlight/adp8870_bl.c:		ret =
led_classdev_register(&client->dev, &led_dat->cdev);
./drivers/video/backlight/adp8860_bl.c:		ret =
led_classdev_register(&client->dev, &led_dat->cdev);
./drivers/media/rc/winbond-cir.c:	err =
led_classdev_register(&device->dev, &data->led);
./drivers/leds/leds-wm831x-status.c:	ret =
led_classdev_register(wm831x->dev, &drvdata->cdev);
./drivers/leds/leds-ns2.c:	ret = led_classdev_register(&pdev->dev,
&led_dat->cdev);
./drivers/leds/leds-pwm.c:		ret = led_classdev_register(&pdev->dev,
&led_dat->cdev);
./drivers/leds/leds-dac124s085.c:		ret =
led_classdev_register(&spi->dev, &led->ldev);
./drivers/leds/leds-88pm860x.c:	ret = led_classdev_register(chip->dev,
&data->cdev);
./drivers/leds/leds-lm3530.c:	err =
led_classdev_register(&client->dev, &drvdata->led_dev);
./drivers/leds/leds-ams-delta.c:		ret = led_classdev_register(&pdev->dev,
./drivers/leds/leds-mc13783.c:		ret =
led_classdev_register(pdev->dev.parent, &led_dat->cdev);
./drivers/leds/leds-wm8350.c:	ret = led_classdev_register(&pdev->dev,
&led->cdev);
./drivers/leds/leds-adp5520.c:		ret =
led_classdev_register(led_dat->master, &led_dat->cdev);
./drivers/leds/leds-locomo.c:	ret = led_classdev_register(&ldev->dev,
&locomo_led0);
./drivers/leds/leds-locomo.c:	ret = led_classdev_register(&ldev->dev,
&locomo_led1);
./drivers/leds/leds-pca955x.c:		err =
led_classdev_register(&client->dev, &pca955x[i].led_cdev);
./drivers/leds/leds-sunfire.c:		err = led_classdev_register(&pdev->dev, lp);
./drivers/leds/leds-pca9532.c:			err =
led_classdev_register(&client->dev, &led->ldev);
./drivers/leds/leds-cobalt-qube.c:	retval =
led_classdev_register(&pdev->dev, &qube_front_led);
./drivers/leds/leds-lt3593.c:	ret = led_classdev_register(parent,
&led_dat->cdev);
./drivers/leds/leds-lp5523.c:		res = led_classdev_register(dev, &led->cdev);
./drivers/leds/leds-renesas-tpu.c:	ret =
led_classdev_register(&pdev->dev, &p->ldev);
./drivers/leds/leds-s3c24xx.c:	ret = led_classdev_register(&dev->dev,
&led->cdev);
./drivers/leds/leds-s3c24xx.c:		dev_err(&dev->dev,
"led_classdev_register failed\n");
./drivers/leds/leds-ss4200.c:	ret =
led_classdev_register(&nas_gpio_pci_dev->dev, led);
./drivers/leds/leds-bd2802.c:	ret =
led_classdev_register(&led->client->dev, &led->cdev_led1r);
./drivers/leds/leds-bd2802.c:	ret =
led_classdev_register(&led->client->dev, &led->cdev_led1g);
./drivers/leds/leds-bd2802.c:	ret =
led_classdev_register(&led->client->dev, &led->cdev_led1b);
./drivers/leds/leds-bd2802.c:	ret =
led_classdev_register(&led->client->dev, &led->cdev_led2r);
./drivers/leds/leds-bd2802.c:	ret =
led_classdev_register(&led->client->dev, &led->cdev_led2g);
./drivers/leds/leds-bd2802.c:	ret =
led_classdev_register(&led->client->dev, &led->cdev_led2b);
./drivers/leds/leds-lp5521.c:	res = led_classdev_register(dev, &led->cdev);
./drivers/leds/leds-fsg.c:	ret = led_classdev_register(&pdev->dev,
&fsg_wlan_led);
./drivers/leds/leds-fsg.c:	ret = led_classdev_register(&pdev->dev,
&fsg_wan_led);
./drivers/leds/leds-fsg.c:	ret = led_classdev_register(&pdev->dev,
&fsg_sata_led);
./drivers/leds/leds-fsg.c:	ret = led_classdev_register(&pdev->dev,
&fsg_usb_led);
./drivers/leds/leds-fsg.c:	ret = led_classdev_register(&pdev->dev,
&fsg_sync_led);
./drivers/leds/leds-fsg.c:	ret = led_classdev_register(&pdev->dev,
&fsg_ring_led);
./drivers/leds/leds-net48xx.c:	return
led_classdev_register(&pdev->dev, &net48xx_error_led);
./drivers/leds/leds-regulator.c:	ret =
led_classdev_register(&pdev->dev, &led->cdev);
./drivers/leds/dell-led.c:	return led_classdev_register(NULL, &dell_led);
./drivers/leds/leds-gpio.c:	ret = led_classdev_register(parent, &led_dat->cdev);
./drivers/leds/leds-da903x.c:	ret = led_classdev_register(led->master,
&led->cdev);
./drivers/leds/leds-lp3944.c:			err =
led_classdev_register(&client->dev, &led->ldev);
./drivers/leds/leds-wrap.c:	ret = led_classdev_register(&pdev->dev,
&wrap_power_led);
./drivers/leds/leds-wrap.c:	ret = led_classdev_register(&pdev->dev,
&wrap_error_led);
./drivers/leds/leds-wrap.c:	ret = led_classdev_register(&pdev->dev,
&wrap_extra_led);
./drivers/leds/leds-cobalt-raq.c:	retval =
led_classdev_register(&pdev->dev, &raq_power_off_led);
./drivers/leds/leds-cobalt-raq.c:	retval =
led_classdev_register(&pdev->dev, &raq_web_led);
./drivers/leds/leds-atmel-pwm.c:		status =
led_classdev_register(&pdev->dev, &led->cdev);
./drivers/leds/leds-asic3.c:	ret = led_classdev_register(&pdev->dev, led->cdev);
./drivers/leds/leds-clevo-mail.c:	return
led_classdev_register(&pdev->dev, &clevo_mail_led);
./drivers/leds/leds-hp6xx.c:	ret = led_classdev_register(&pdev->dev,
&hp6xx_red_led);
./drivers/leds/leds-hp6xx.c:	ret = led_classdev_register(&pdev->dev,
&hp6xx_green_led);
./drivers/leds/leds-netxbig.c:	ret = led_classdev_register(&pdev->dev,
&led_dat->cdev);
./drivers/leds/leds-rb532.c:	return led_classdev_register(&pdev->dev,
&rb532_uled);
./drivers/leds/led-class.c: * led_classdev_register - register a new
object of led_classdev class.
./drivers/leds/led-class.c:int led_classdev_register(struct device
*parent, struct led_classdev *led_cdev)
./drivers/leds/led-class.c:EXPORT_SYMBOL_GPL(led_classdev_register);
./drivers/leds/led-class.c: * Unregisters a previously registered via
led_classdev_register object.
./drivers/platform/x86/hp_accel.c:	ret = led_classdev_register(NULL,
&hpled_led.led_classdev);
./drivers/platform/x86/eeepc-laptop.c:	rv =
led_classdev_register(&eeepc->platform_device->dev,
./drivers/platform/x86/dell-laptop.c:	return
led_classdev_register(dev, &touchpad_led);
./drivers/platform/x86/fujitsu-laptop.c:		result =
led_classdev_register(&fujitsu->pf_device->dev,
./drivers/platform/x86/fujitsu-laptop.c:		result =
led_classdev_register(&fujitsu->pf_device->dev,
./drivers/platform/x86/acer-wmi.c:	return led_classdev_register(dev, &mail_led);
./drivers/platform/x86/thinkpad_acpi.c:	rc =
led_classdev_register(&tpacpi_pdev->dev,
./drivers/platform/x86/thinkpad_acpi.c:	rc =
led_classdev_register(&tpacpi_pdev->dev,
./drivers/platform/x86/asus-laptop.c:	return
led_classdev_register(&asus->platform_device->dev, led_cdev);
./drivers/platform/x86/asus-laptop.c:		r =
led_classdev_register(&asus->platform_device->dev, cdev);
./drivers/platform/x86/toshiba_acpi.c:		if
(!led_classdev_register(&acpi_dev->dev, &dev->led_dev))
./drivers/platform/x86/asus-wmi.c:		rv =
led_classdev_register(&asus->platform_device->dev,
./drivers/platform/x86/asus-wmi.c:		rv =
led_classdev_register(&asus->platform_device->dev,
./drivers/net/wireless/ath/ath9k/htc_drv_gpio.c:	ret =
led_classdev_register(wiphy_dev(priv->hw->wiphy), &priv->led_cdev);
./drivers/net/wireless/ath/ath9k/gpio.c:	ret =
led_classdev_register(wiphy_dev(sc->hw->wiphy), &sc->led_cdev);
./drivers/net/wireless/ath/ath5k/led.c:	err =
led_classdev_register(ah->dev, &led->led_dev);
./drivers/net/wireless/ath/carl9170/led.c:	err =
led_classdev_register(wiphy_dev(ar->hw->wiphy),
./drivers/net/wireless/p54/led.c:	err =
led_classdev_register(wiphy_dev(priv->hw->wiphy), &led->led_dev);
./drivers/net/wireless/iwlwifi/iwl-led.c:	ret =
led_classdev_register(bus(priv)->dev, &priv->led);
./drivers/net/wireless/b43legacy/leds.c:	err =
led_classdev_register(dev->dev->dev, &led->led_dev);
./drivers/net/wireless/rtl818x/rtl8187/leds.c:	err =
led_classdev_register(&priv->udev->dev, &led->led_dev);
./drivers/net/wireless/iwlegacy/iwl-led.c:	ret =
led_classdev_register(&priv->pci_dev->dev, &priv->led);
./drivers/net/wireless/rt2x00/rt2x00leds.c:	retval =
led_classdev_register(device, &led->led_dev);
./drivers/net/wireless/b43/leds.c:	err =
led_classdev_register(dev->dev->dev, &led->led_dev);
./drivers/hid/hid-wiimote.c:		ret = led_classdev_register(dev, led);
./drivers/hid/hid-picolcd.c:		ret = led_classdev_register(dev, data->led[i]);
./drivers/staging/nvec/nvec_leds.c:	ret =
led_classdev_register(&pdev->dev, &led->cdev);
./drivers/hwmon/applesmc.c:	return led_classdev_register(&pdev->dev,
&applesmc_backlight);
^C
--

When CONFIG_NEW_LEDS=y, CONFIG_LEDS_CLASS=m and CONFIG_LEDS_TRIGGER=y,
I got following error for building omap2plus_defconfig
--
arch/arm/plat-omap/built-in.o: In function `newled_init':
/opt/git/linux-2.6/arch/arm/plat-omap/debug-leds.c:248: undefined
reference to `led_classdev_register'
drivers/built-in.o: In function `led_trigger_blink':
/opt/git/linux-2.6/drivers/leds/led-triggers.c:248: undefined
reference to `led_blink_set'
drivers/built-in.o: In function `led_trigger_set':
/opt/git/linux-2.6/drivers/leds/led-triggers.c:116: undefined
reference to `led_brightness_set'
make: *** [.tmp_vmlinux1] Error 1
--

The commit 5ada28bf76752e33dce3d807bf0dfbe6d1b943ad "led-class: always
implement blinking" added 2 API (led_blink_set and
`led_brightness_set'), which are used by led-trigger.c

For this kind of errors, I think it's quite hard to set led-class.c as
a module now and suggest we merge NEW_LEDS and LEDS_CLASS together.

Thanks a lot,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.138-1617-6545 Mobile
Ubuntu ARM Team
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
