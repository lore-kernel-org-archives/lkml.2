Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab1HOCU2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 22:20:28 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47205 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289Ab1HOCU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 22:20:26 -0400
X-Sasl-enc: UPWLc3AKr7Svq03fU1lRNJpY9yyY1Z901fb0FuePaRsu 1313374825
Date: Sun, 14 Aug 2011 19:20:15 -0700
From: Greg KH <greg@kroah.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: Driver framework: binding a driver to two devices?
Message-ID: <20110815022015.GA4886@kroah.com>
References: <CAMuHMdVr9iAyqQJUgHq4gcLg+gp7GxF=sH+SBKBuqVWYymXs8Q@mail.gmail.com>
 <20110814173816.GA10062@kroah.com>
 <CAMuHMdUdJvqm+U7EY-p+vmkKyBd7urcRYEfV_6BWU8zqo+b_tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdUdJvqm+U7EY-p+vmkKyBd7urcRYEfV_6BWU8zqo+b_tA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 09:32:01PM +0200, Geert Uytterhoeven wrote:
> On Sun, Aug 14, 2011 at 19:38, Greg KH <greg@kroah.com> wrote:
> > On Sat, Aug 13, 2011 at 10:44:42PM +0200, Geert Uytterhoeven wrote:
> >> As Amiga Zorro expansion boards have only one BAR (unlike PCI, which has
> >> multiple BARs), several Amiga graphics cards show up as two Zorro devices:
> >> one for the graphics memory and one for the graphics controller's registers.
> >>
> >> Traditionally, a driver for such a device used
> >>
> >>     dev1 = zorro_find_device(id1, ...)
> >>     dev2 = zorro_find_device(id2, ...)
> >>
> >> to find the two devices and match them.
> >>
> >> With the "new" driver framework, the matching with device id1 is now
> >> done using a
> >> struct zorro_driver with a table of IDs, while the matching with device id2 is
> >> still done by calling zorro_find_device(id2, ...).
> >>
> >> Recently (with cirrusfb) it turned out that the call to
> >> zorro_find_device(id2, ...)
> >> may fail to find the second device. I suspect this happens due to the second
> >> device haven't been probed for at the time the zorro_driver for the
> >> first device is
> >> initialized.
> >>
> >> I expect this can be fixed by delaying all calls to device_register() in
> >> amiga_zorro_probe() until all devices have been detected and added to the array
> >> used by zorro_find_device(). But I was wondering whether there's a more generic
> >> way in the driver framework to bind a driver to two devices?
> >
> > What you really want is the same "driver instance" bound to two devices,
> > right?  That way the device would operate "knowing" about both physical
> > devices so as to properly control the thing.
> 
> Yes, that's what I want.
> 
> > Right now, no, there's not a simple way to do this with the driver
> > model.  USB does this on its own for some devices that need to have
> > multiple "interfaces" (the USB equalivant for a "device") controlled at
> > the same time, so you might want to look at how that happens (in the
> > indivdual drivers, not in the USB core.)
> 
> Thanks, I'll have a look at the USB drivers.
> Do you know which examples to look at?

The drivers/usb/class/cdc-acm.c driver, in the acm_probe() function,
grabs the "control" and "data" interfaces.  The logic is messy, due to
the wide variety of broken devices out there, but you should get the
general idea.

What's needed is for your bus to be able to provide you a pointer to any
device you want to find.  PCI provides this, so you should be fine, and
should not have any problems.

Hope this helps,

greg k-h
