Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab2LEJn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 04:43:28 -0500
Received: from smtp2.goneo.de ([212.90.139.82]:12243 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab2LEJnZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 04:43:25 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.897
From: Lars Poeschel <poeschel@lemonage.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH RFC] misc/at24: distinguish between eeprom and fram chips
Date: Wed, 5 Dec 2012 10:43:07 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
References: <201212041758.38600.poeschel@lemonage.de> <20121204183238.GA15067@pengutronix.de>
In-Reply-To: <20121204183238.GA15067@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201212051043.07460.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see there where to much "no"s to get anything in, but thank you for
your comments and explanations.

> > I wanted to use a fm24c04 i2c fram chip with linux. I grepped the source
> > and found nothing. I later found that my chip can be handled by at24
> > eeprom driver. It creates a sysfs file called eeprom to read from and
> > write to the chip. Userspace has no chance to distinguish if it is
> > writing an eeprom or a fram chip.
> 
> Why should it?

Because writes are much faster and it doesn't have to take care on erase
cycles. It could use other write strategies on such devices and update
informations that have to survive power downs more often.
 
> > diff --git a/drivers/misc/eeprom/Kconfig b/drivers/misc/eeprom/Kconfig
> > index c9e695e..55948a5 100644
> > --- a/drivers/misc/eeprom/Kconfig
> > +++ b/drivers/misc/eeprom/Kconfig
> > @@ -12,6 +12,12 @@ config EEPROM_AT24
> > 
> >  	     24c00, 24c01, 24c02, spd (readonly 24c02), 24c04, 24c08,
> >  	     24c16, 24c32, 24c64, 24c128, 24c256, 24c512, 24c1024
> > 
> > +	  This driver also supports I2C FRAM chips that are feature
> > +	  compatible to the 24cxx ones. In your at24_platform_data set
> > +	  .flags = AT24_FLAG_FRAM. These generic names are supported:
> > +
> > +	     fm24c04
> > +
> 
> The method of accessing EEPROMs is used by way more chips than FRAMs.
> So, I'd prefer to have the text updated more generic like "EEPROMs and
> similar devices like RAMs, ROMs, etc...". Describing setting .flags in
> Kconfig is overkill.

A patch updating Kconfig is below.
 
> > -		chip.page_size = 1;
> > +		if (chip.flags & AT24_FLAG_FRAM)
> > +			chip.page_size = 128;
> > +		else
> > +			chip.page_size = 1;
> 
> I'd think most FRAMs can have the chip_size as the page_size since they
> probably don't do buffering. But do you know for all the chips out
> there? So, let's still play safe. If you want performance, you need to
> setup the driver properly.

No one knows all chips out there.
For the fm24c04 I use page_size != chip_size. It does not buffer but it has 
two pages, 256 bytes each.

-- >8 --
>From 82f77ade238755b7a1196b24f41a03a0e7344d89 Mon Sep 17 00:00:00 2001
From: Lars Poeschel <poeschel@lemonage.de>
Date: Wed, 5 Dec 2012 10:08:07 +0100
Subject: [PATCH] misc/at24: Update Kconfig to mention FRAMs, SRAMs and ROMs

As the at24 driver is able handle a bunch of serial storage chips other than
EEPROMs this is now mentioned in Kconfig.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>

diff --git a/drivers/misc/eeprom/Kconfig b/drivers/misc/eeprom/Kconfig
index c9e695e..04f2e1f 100644
--- a/drivers/misc/eeprom/Kconfig
+++ b/drivers/misc/eeprom/Kconfig
@@ -1,13 +1,14 @@
 menu "EEPROM support"
 
 config EEPROM_AT24
-	tristate "I2C EEPROMs from most vendors"
+	tristate "I2C EEPROMs / RAMs / ROMs from most vendors"
 	depends on I2C && SYSFS
 	help
-	  Enable this driver to get read/write support to most I2C EEPROMs,
-	  after you configure the driver to know about each EEPROM on
-	  your target board.  Use these generic chip names, instead of
-	  vendor-specific ones like at24c64 or 24lc02:
+	  Enable this driver to get read/write support to most I2C EEPROMs
+	  and compatible devices like FRAMs, SRAMs, ROMs etc. After you
+	  configure the driver to know about each chip on your target
+	  board.  Use these generic chip names, instead of vendor-specific
+	  ones like at24c64, 24lc02 or fm24c04:
 
 	     24c00, 24c01, 24c02, spd (readonly 24c02), 24c04, 24c08,
 	     24c16, 24c32, 24c64, 24c128, 24c256, 24c512, 24c1024
-- 
1.7.10.4

