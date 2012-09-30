Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab2I3IyL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 04:54:11 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:2149 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab2I3IyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 04:54:08 -0400
Date: Sun, 30 Sep 2012 10:53:50 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Huewe <peterhuewe@gmx.de>, linux-s390@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [-next]: s390 *_irq() link errors
Message-ID: <20120930105350.16e54037@endymion.delvare>
In-Reply-To: <CAMuHMdUqXnY5ZNgjYN0YMpLkPw0j41MXM18H9qiLoEk-BzKYMg@mail.gmail.com>
References: <CAMuHMdXqsPgfToNyjbxJ-WM=-kEEvAweE03wb3vtkwVO+-RR3A@mail.gmail.com>
	<20120927115134.GA5654@osiris.de.ibm.com>
	<CAMuHMdUqXnY5ZNgjYN0YMpLkPw0j41MXM18H9qiLoEk-BzKYMg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Sep 2012 18:39:13 +0200, Geert Uytterhoeven wrote:
> On Thu, Sep 27, 2012 at 1:51 PM, Heiko Carstens
> > From 24c68e72b6198b8412a8605fac7d9c90796502ac Mon Sep 17 00:00:00 2001
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Date: Thu, 27 Sep 2012 13:37:14 +0200
> > Subject: [PATCH] i2c: Make I2C unavailable on s390 again
> >
> > "i2c: Make I2C available on UML" removed the IOMEM dependency from I2C which
> > resulted in I2C being avaible on s390 and causing allmodconfig and allyesconfig
> > builds to fail:
> >
> > drivers/misc/altera-stapl/altera-lpt.c: In function 'byteblaster_write':
> > drivers/misc/altera-stapl/altera-lpt.c:34:2: error: implicit declaration of function 'outb' [-Werror=implicit-function-declaration]
> >
> > Adding a HAS_PORT dependency to that driver reveals that there are lots
> > of other build errors waiting for discovery because of this change since
> > s390 does not support generic hardirqs:
> >
> > ERROR: "free_irq" [drivers/power/smb347-charger.ko] undefined!
> > ERROR: "free_irq" [drivers/power/sbs-battery.ko] undefined!
> > ERROR: "enable_irq" [drivers/power/max17042_battery.ko] undefined!
> > ERROR: "request_irq" [drivers/power/max17042_battery.ko] undefined!
> > ERROR: "free_irq" [drivers/power/max17042_battery.ko] undefined!
> > ERROR: "disable_irq" [drivers/power/max17042_battery.ko] undefined!
> > ERROR: "request_irq" [drivers/power/lp8727_charger.ko] undefined!
> > ERROR: "free_irq" [drivers/power/lp8727_charger.ko] undefined!
> > ERROR: "request_irq" [drivers/nfc/pn544_hci.ko] undefined!
> > ERROR: "free_irq" [drivers/nfc/pn544_hci.ko] undefined!
> > ERROR: "request_irq" [drivers/nfc/pn544.ko] undefined!
> > ERROR: "free_irq" [drivers/nfc/pn544.ko] undefined!
> > ERROR: "request_irq" [drivers/misc/fsa9480.ko] undefined!
> > ERROR: "free_irq" [drivers/misc/fsa9480.ko] undefined!
> > ERROR: "request_irq" [drivers/misc/bh1770glc.ko] undefined!
> > ERROR: "free_irq" [drivers/misc/bh1770glc.ko] undefined!
> > ERROR: "request_irq" [drivers/misc/apds990x.ko] undefined!
> > ERROR: "free_irq" [drivers/misc/apds990x.ko] undefined!
> >
> > Since UML seems to need generic I2C support, but lot's of now available
> > drivers fail to compile on s390, just add a !S390 dependency.
> >
> > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Peter Huewe <peterhuewe@gmx.de>
> > Cc: Jean Delvare <khali@linux-fr.org>
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Yeah, s390 is so special that it's the only architecture that can be used
> in depends on !, so
> 
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > ---
> >  drivers/i2c/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
> > index 17b35c1..2f8c76b 100644
> > --- a/drivers/i2c/Kconfig
> > +++ b/drivers/i2c/Kconfig
> > @@ -4,6 +4,7 @@
> >
> >  menuconfig I2C
> >         tristate "I2C support"
> > +       depends on !S390
> >         select RT_MUTEXES
> >         ---help---
> >           I2C (pronounce: I-squared-C) is a slow serial bus protocol used in

I thought we were trying to move away from explicit arch exclusions,
but if S390 is special then fine with me. I've folded Heiko's fix into
Peter's patch, as it is not committed yet. Result is at:

http://khali.linux-fr.org/devel/linux-3/jdelvare-i2c/i2c-make-I2C-available-on-UML.patch

That's what will be in the next linux-next.

-- 
Jean Delvare
