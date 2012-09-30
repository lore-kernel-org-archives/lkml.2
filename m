Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042Ab2I3JIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 05:08:45 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62538 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2I3JIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 05:08:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120930105350.16e54037@endymion.delvare>
References: <CAMuHMdXqsPgfToNyjbxJ-WM=-kEEvAweE03wb3vtkwVO+-RR3A@mail.gmail.com>
	<20120927115134.GA5654@osiris.de.ibm.com>
	<CAMuHMdUqXnY5ZNgjYN0YMpLkPw0j41MXM18H9qiLoEk-BzKYMg@mail.gmail.com>
	<20120930105350.16e54037@endymion.delvare>
Date: Sun, 30 Sep 2012 11:08:41 +0200
X-Google-Sender-Auth: J9zWUfkG0YuSaEciP-BuWxX8x48
Message-ID: <CAMuHMdV=mcVuVuJaWrVjwxLz0+gkBoC=NUq6=C176B3W7j8Yag@mail.gmail.com>
Subject: Re: [-next]: s390 *_irq() link errors
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Huewe <peterhuewe@gmx.de>, linux-s390@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 10:53 AM, Jean Delvare <khali@linux-fr.org> wrote:
> On Sat, 29 Sep 2012 18:39:13 +0200, Geert Uytterhoeven wrote:
>> On Thu, Sep 27, 2012 at 1:51 PM, Heiko Carstens
>> > From 24c68e72b6198b8412a8605fac7d9c90796502ac Mon Sep 17 00:00:00 2001
>> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
>> > Date: Thu, 27 Sep 2012 13:37:14 +0200
>> > Subject: [PATCH] i2c: Make I2C unavailable on s390 again
>> >
>> > "i2c: Make I2C available on UML" removed the IOMEM dependency from I2C which
>> > resulted in I2C being avaible on s390 and causing allmodconfig and allyesconfig
>> > builds to fail:
>> >
>> > drivers/misc/altera-stapl/altera-lpt.c: In function 'byteblaster_write':
>> > drivers/misc/altera-stapl/altera-lpt.c:34:2: error: implicit declaration of function 'outb' [-Werror=implicit-function-declaration]
>> >
>> > Adding a HAS_PORT dependency to that driver reveals that there are lots
>> > of other build errors waiting for discovery because of this change since
>> > s390 does not support generic hardirqs:
>> >
>> > ERROR: "free_irq" [drivers/power/smb347-charger.ko] undefined!
>> > ERROR: "free_irq" [drivers/power/sbs-battery.ko] undefined!
>> > ERROR: "enable_irq" [drivers/power/max17042_battery.ko] undefined!
>> > ERROR: "request_irq" [drivers/power/max17042_battery.ko] undefined!
>> > ERROR: "free_irq" [drivers/power/max17042_battery.ko] undefined!
>> > ERROR: "disable_irq" [drivers/power/max17042_battery.ko] undefined!
>> > ERROR: "request_irq" [drivers/power/lp8727_charger.ko] undefined!
>> > ERROR: "free_irq" [drivers/power/lp8727_charger.ko] undefined!
>> > ERROR: "request_irq" [drivers/nfc/pn544_hci.ko] undefined!
>> > ERROR: "free_irq" [drivers/nfc/pn544_hci.ko] undefined!
>> > ERROR: "request_irq" [drivers/nfc/pn544.ko] undefined!
>> > ERROR: "free_irq" [drivers/nfc/pn544.ko] undefined!
>> > ERROR: "request_irq" [drivers/misc/fsa9480.ko] undefined!
>> > ERROR: "free_irq" [drivers/misc/fsa9480.ko] undefined!
>> > ERROR: "request_irq" [drivers/misc/bh1770glc.ko] undefined!
>> > ERROR: "free_irq" [drivers/misc/bh1770glc.ko] undefined!
>> > ERROR: "request_irq" [drivers/misc/apds990x.ko] undefined!
>> > ERROR: "free_irq" [drivers/misc/apds990x.ko] undefined!
>> >
>> > Since UML seems to need generic I2C support, but lot's of now available
>> > drivers fail to compile on s390, just add a !S390 dependency.
>> >
>> > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> > Cc: Peter Huewe <peterhuewe@gmx.de>
>> > Cc: Jean Delvare <khali@linux-fr.org>
>> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
>>
>> Yeah, s390 is so special that it's the only architecture that can be used
>> in depends on !, so
>>
>> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> > ---
>> >  drivers/i2c/Kconfig | 1 +
>> >  1 file changed, 1 insertion(+)
>> >
>> > diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
>> > index 17b35c1..2f8c76b 100644
>> > --- a/drivers/i2c/Kconfig
>> > +++ b/drivers/i2c/Kconfig
>> > @@ -4,6 +4,7 @@
>> >
>> >  menuconfig I2C
>> >         tristate "I2C support"
>> > +       depends on !S390
>> >         select RT_MUTEXES
>> >         ---help---
>> >           I2C (pronounce: I-squared-C) is a slow serial bus protocol used in
>
> I thought we were trying to move away from explicit arch exclusions,
> but if S390 is special then fine with me. I've folded Heiko's fix into

"depends on GENERIC_HARDIRQS" is the alternative...

Hmm, I just noticed we already have lots of dependencies on GENERIC_HARDIRQS,
especially w.r.t I2C:

drivers/gpio/Kconfig:	depends on GPIO_MAX732X=y && GENERIC_HARDIRQS
drivers/iio/Kconfig:	depends on GENERIC_HARDIRQS
drivers/input/touchscreen/Kconfig:        depends on SPI_MASTER &&
GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on GENERIC_HARDIRQS && GPIOLIB && ARM
drivers/mfd/Kconfig:	depends on GENERIC_HARDIRQS && GPIOLIB && ARM
drivers/mfd/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on (I2C=y || SPI_MASTER=y) && GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on SPI_MASTER && GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on GENERIC_HARDIRQS && SPI_MASTER
drivers/mfd/Kconfig:	depends on GENERIC_HARDIRQS && ABX500_CORE &&
MFD_DB8500_PRCMU
drivers/mfd/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
drivers/mfd/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
drivers/net/wireless/p54/Kconfig:	depends on P54_COMMON && SPI_MASTER
&& GENERIC_HARDIRQS
drivers/net/wireless/ti/wl1251/Kconfig:	depends on MAC80211 &&
EXPERIMENTAL && GENERIC_HARDIRQS
drivers/net/wireless/ti/wlcore/Kconfig:	depends on WL_TI &&
GENERIC_HARDIRQS && MAC80211
drivers/power/Kconfig:	depends on GENERIC_HARDIRQS
drivers/pps/clients/Kconfig:	depends on PPS && GENERIC_HARDIRQS
drivers/w1/masters/Kconfig:	depends on W1 && GENERIC_HARDIRQS
kernel/irq/Kconfig:config GENERIC_HARDIRQS
lib/Kconfig.debug:	depends on DEBUG_KERNEL && GENERIC_HARDIRQS
net/Kconfig:	depends on RPS && GENERIC_HARDIRQS
sound/soc/samsung/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
sound/soc/samsung/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS
sound/soc/samsung/Kconfig:	depends on I2C=y && GENERIC_HARDIRQS

> Peter's patch, as it is not committed yet. Result is at:
>
> http://khali.linux-fr.org/devel/linux-3/jdelvare-i2c/i2c-make-I2C-available-on-UML.patch
>
> That's what will be in the next linux-next.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
