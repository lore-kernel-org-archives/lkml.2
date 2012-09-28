Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab2I1OHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:07:15 -0400
Received: from smtp1.goneo.de ([212.90.139.80]:51083 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756714Ab2I1OHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:07:13 -0400
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2012 10:07:13 EDT
X-Spam-Flag: NO
X-Spam-Score: -2.898
From: Lars Poeschel <poeschel@lemonage.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: viperboard driver added
Date: Fri, 28 Sep 2012 15:59:07 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-amd64; KDE/4.8.4; x86_64; ; )
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, linux-kernel@vger.kernel.org
References: <1346072918-3982-1-git-send-email-larsi@wh2.tu-dresden.de> <86c9848e77fa42b6c48ba0703ebf637f@atlantis.wh2.tu-dresden.de> <20120925085559.GL28670@sortiz-mobl>
In-Reply-To: <20120925085559.GL28670@sortiz-mobl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209281559.08017.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Am Dienstag, 25. September 2012, 10:55:59 schrieb Samuel Ortiz:
> Hi Lars,
> 
> On Mon, Sep 24, 2012 at 06:46:19PM +0200, Lars Poeschel wrote:
> > Hi Samuel,
> > 
> > Thanks for your review.
> > 
> > Am 19.09.2012 17:29, schrieb Samuel Ortiz:
> > >Hi Lars,
> > >
> > >On Mon, Aug 27, 2012 at 03:08:38PM +0200, larsi@wh2.tu-dresden.de
> > >
> > >wrote:
> > >>From: Lars Poeschel <poeschel@lemonage.de>
> > >>
> > >>First version of the driver for Nano River Tech's
> > >>viperboard added.
> > >>It supports i2c, adc, gpio a and gpio b. spi and pwm on
> > >>the first gpio a pins is not supported yet.
> > >>
> > >>Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> > >>---
> > >>
> > >> drivers/mfd/Kconfig      |   17 +
> > >> drivers/mfd/Makefile     |    1 +
> > >> drivers/mfd/viperboard.c | 1084
> > >>
> > >>++++++++++++++++++++++++++++++++++++++++++++++
> > >>
> > >> 3 files changed, 1102 insertions(+)
> > >> create mode 100644 drivers/mfd/viperboard.c
> > >
> > >So the MFD driver contains a GPIO one, and an i2c bus driver.
> > >You should really split this code into at least 3 pieces: 1 for
> > >the GPIO
> > >(drivers/gpio), another one for your i2c bus algorithm
> > >(drivers/i2c/busses)
> > >and a last one for the actual MFD driver. Your Kconfig entries
> > >will define the
> > >dependencies between them.
> > >Then you can define your SoC subdevices as MFD cells and use the
> > >MFD APIs to
> > >add them as platform devices.
> > 
> > I am not really sure, but maybe you got mislead by the term
> > "viperboard". It is NOT an embedded evaluation board or starterkit.
> > It is an USB to SPI, I2C, GPIO and ADC interface. You can get a
> > quick overview here: http://nanorivertech.com/viperboard.html
> > The I2C, GPIO or ADC parts of this driver will never be part of a
> > "platform device" in terms of the linux kernel definining the
> > configuration of different embedded evaluation boards (a platform).
> 
> Well, that's something none of us know for sure :)
> We've seen various IPs re-used across several devices in the past, which is
> why we're keen on separating the various drivers.
> Also, from an architectural point of view, it makes more sense and is
> cleaner imho.
> 
> > Do you still think I should split up the different parts into their
> > respective subsystems in the kernel and have one "core" combining
> > those parts in MFD ?
> 
> Yes, I do.
> 
> > If so, I will do this. As there would be multiple different
> > maintainers involved, against which branch has my patch to be ?
> 
> Most of your sub devices (GPIO, I2C, ADC) will be depending on the MFD one
> (as in Kconfig dependency), so it's safe to send each driver to the
> specific sub system maintainer and expect him/her to take it. We usually
> figure that out once the patchset is ready for upstream inclusion.
> 
> > Should I simply CC the patch to all involved maintainers ?
> 
> It's better yes. Even though a maintainer typically cares about 1 or 2
> patches out of the whole patchset, they usually prefer to be able to get
> the whole picture and understand where you want to go with this
> submission.

I have done it, and it works! :-) And it looks indeed much cleaner now. But I 
have on problem left:
I can not rmmod the "core" module. I get an kernel oops stacktrace origination 
from mfd_remove_devices_fn. I think the problem is as follows:
Since my viperboard is an usb device, I write a struct usb_driver, that's 
probe function is called with struct usb_interface containing the struct 
device that I pass as parent device to mfd_add_devices.
During disconnect function I pass the same parent device to mfd_remove_devices 
for removal of mfd_cells. In mfd_remove_devices_fn the pointer is then 
containter_of 'd to struct platform_device and to struct usb_interface (struct 
usb_interface is not containing a mfd_cell pointer either), which then 
obviously accesses wrong memory in platform_device_unregister.
I am a bit confused now. Is the mfd_cell mechanism only working with 
platform_devices ?
What should I do ?
I think I have to options:
1. Extending mfd-core to have functions to work with usb_interface and add an 
mfd_cell to it.
2. Constructing some dummy platform_device in my core driver and passing this 
to mfd_add_devices and mfd_remove_devices to satisfy them. But this seems a 
bit ugly to me.

Or am I doing something completly wrong ?

Thanks for your help,
Lars
