Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab2I0LvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:51:21 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:37418 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2I0LvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:51:19 -0400
Date: Thu, 27 Sep 2012 13:51:34 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>, Peter Huewe <peterhuewe@gmx.de>,
        Jean Delvare <khali@linux-fr.org>
Cc: linux-s390@vger.kernel.org, Linux-Next <linux-next@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [-next]: s390 *_irq() link errors
Message-ID: <20120927115134.GA5654@osiris.de.ibm.com>
References: <CAMuHMdXqsPgfToNyjbxJ-WM=-kEEvAweE03wb3vtkwVO+-RR3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXqsPgfToNyjbxJ-WM=-kEEvAweE03wb3vtkwVO+-RR3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12092711-5024-0000-0000-000003E711BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 09:07:54PM +0200, Geert Uytterhoeven wrote:
> After applying http://www.spinics.net/lists/linux-next/msg21973.html,
> the s390 allmodconfig build in linux-next fails in the linking stage with:
> 
> ERROR: "free_irq" [drivers/power/smb347-charger.ko] undefined!
> ERROR: "free_irq" [drivers/power/sbs-battery.ko] undefined!
> ERROR: "enable_irq" [drivers/power/max17042_battery.ko] undefined!
> ERROR: "request_irq" [drivers/power/max17042_battery.ko] undefined!
> ERROR: "free_irq" [drivers/power/max17042_battery.ko] undefined!
> ERROR: "disable_irq" [drivers/power/max17042_battery.ko] undefined!
> ERROR: "request_irq" [drivers/power/lp8727_charger.ko] undefined!
> ERROR: "free_irq" [drivers/power/lp8727_charger.ko] undefined!
> ERROR: "request_irq" [drivers/nfc/pn544_hci.ko] undefined!
> ERROR: "free_irq" [drivers/nfc/pn544_hci.ko] undefined!
> ERROR: "request_irq" [drivers/nfc/pn544.ko] undefined!
> ERROR: "free_irq" [drivers/nfc/pn544.ko] undefined!
> ERROR: "request_irq" [drivers/misc/fsa9480.ko] undefined!
> ERROR: "free_irq" [drivers/misc/fsa9480.ko] undefined!
> ERROR: "request_irq" [drivers/misc/bh1770glc.ko] undefined!
> ERROR: "free_irq" [drivers/misc/bh1770glc.ko] undefined!
> ERROR: "request_irq" [drivers/misc/apds990x.ko] undefined!
> ERROR: "free_irq" [drivers/misc/apds990x.ko] undefined!
> 
> What should these drivers depend on? GENERIC_HARDIRQS?

Probably, but...

> S390 is the only non-GENERIC_HARDIRQS architecture left, but all
> other former non-GENERIC_HARDIRQS architectures did provide e.g. request_irq()
> and free_irq().

All of this started because I2C lost its HAS_IOMEM dependency. Can't
we simply add an !S390 dependency instead and all is well? :)

Something like below?

>From 24c68e72b6198b8412a8605fac7d9c90796502ac Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Thu, 27 Sep 2012 13:37:14 +0200
Subject: [PATCH] i2c: Make I2C unavailable on s390 again

"i2c: Make I2C available on UML" removed the IOMEM dependency from I2C which
resulted in I2C being avaible on s390 and causing allmodconfig and allyesconfig
builds to fail:

drivers/misc/altera-stapl/altera-lpt.c: In function 'byteblaster_write':
drivers/misc/altera-stapl/altera-lpt.c:34:2: error: implicit declaration of function 'outb' [-Werror=implicit-function-declaration]

Adding a HAS_PORT dependency to that driver reveals that there are lots
of other build errors waiting for discovery because of this change since
s390 does not support generic hardirqs:

ERROR: "free_irq" [drivers/power/smb347-charger.ko] undefined!
ERROR: "free_irq" [drivers/power/sbs-battery.ko] undefined!
ERROR: "enable_irq" [drivers/power/max17042_battery.ko] undefined!
ERROR: "request_irq" [drivers/power/max17042_battery.ko] undefined!
ERROR: "free_irq" [drivers/power/max17042_battery.ko] undefined!
ERROR: "disable_irq" [drivers/power/max17042_battery.ko] undefined!
ERROR: "request_irq" [drivers/power/lp8727_charger.ko] undefined!
ERROR: "free_irq" [drivers/power/lp8727_charger.ko] undefined!
ERROR: "request_irq" [drivers/nfc/pn544_hci.ko] undefined!
ERROR: "free_irq" [drivers/nfc/pn544_hci.ko] undefined!
ERROR: "request_irq" [drivers/nfc/pn544.ko] undefined!
ERROR: "free_irq" [drivers/nfc/pn544.ko] undefined!
ERROR: "request_irq" [drivers/misc/fsa9480.ko] undefined!
ERROR: "free_irq" [drivers/misc/fsa9480.ko] undefined!
ERROR: "request_irq" [drivers/misc/bh1770glc.ko] undefined!
ERROR: "free_irq" [drivers/misc/bh1770glc.ko] undefined!
ERROR: "request_irq" [drivers/misc/apds990x.ko] undefined!
ERROR: "free_irq" [drivers/misc/apds990x.ko] undefined!

Since UML seems to need generic I2C support, but lot's of now available
drivers fail to compile on s390, just add a !S390 dependency.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Peter Huewe <peterhuewe@gmx.de>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/i2c/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
index 17b35c1..2f8c76b 100644
--- a/drivers/i2c/Kconfig
+++ b/drivers/i2c/Kconfig
@@ -4,6 +4,7 @@
 
 menuconfig I2C
 	tristate "I2C support"
+	depends on !S390
 	select RT_MUTEXES
 	---help---
 	  I2C (pronounce: I-squared-C) is a slow serial bus protocol used in
-- 
1.7.11.7

