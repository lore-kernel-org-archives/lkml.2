Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab2AEGeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 01:34:10 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55317 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2AEGeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 01:34:08 -0500
Date: Wed, 4 Jan 2012 22:34:00 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jan Steinhoff <mail@jan-steinhoff.de>
Cc: Oliver Neukum <oneukum@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Alessandro Rubini <rubini@cvml.unipv.it>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Synaptics USB device driver
Message-ID: <20120105063400.GA31895@core.coreip.homeip.net>
References: <20120103194033.779cb829@greyhound>
 <alpine.LNX.2.00.1201040954000.24984@pobox.suse.cz>
 <201201041020.41795.oneukum@suse.de>
 <20120104094103.GA29069@core.coreip.homeip.net>
 <20120105053957.6f01ae73@greyhound>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105053957.6f01ae73@greyhound>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 05:39:57AM +0000, Jan Steinhoff wrote:
> On Wed, 4 Jan 2012 01:41:03 -0800
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > Om, so I have been looking at the driver and the following seems to be
> > still working with my Lenovo composite touchpad/stick.
> > 
> > Changes:
> > 
> > - the stick is reported in relative mode; we might consider addig
> >   sensitivity control similar to trackpoint driver. Press-to-select -
> >   maybe in driver, or in client; undecided.
> > 
> > - got rid of BTN_MISC/BTN_MIDDLE option (at least for now);
> 
> Please make BTN_MIDDLE the default in this case for the cPad. This
> button is actually located where the middle button should be. Only if
> one uses the cPad's background display it obtains a "special" meaning.
> (Then pressing it should launch a menu on the background display and the
> touchpad works as a touchscreen for this display.)

OK, let's change it to MTN_MIDDLE. We may consider changing it to
BTN_MISC if cPad display support is merged and active.

> 
> > - added devices to HID blacklist;
> 
> I think it is more flexible and save to use the manual driver binding
> capability of the USB core instead:
> 
> http://lwn.net/Articles/143397/
> 
> Which driver to use for which device can then be set, e.g., with the
> help of udev config files.

However it is more work for distributions and users. As it stands now
adding blacklist and compiling synaptics_usb does not require any
additional userspace support (everyone packages and installs synaptics X
driver nowadays).

> 
> Blacklisting has the big disadvantage that the device will not work at
> all if the synaptics-usb kernel module is not loaded/present, whereas
> otherwise usbhid is used as the default. At least the corresponding
> part in the blacklist should be enclosed in
> #ifdef CONFIG_MOUSE_SYNAPTICS_USB ... #endif

This is a good idea, I'll add ifdefs.

> 
> Further, as noted in the initial comment, not all devices have been
> tested with this driver. This is another reason to allow the user to
> choose which driver to use.

I'll remove touchscreen from blacklist/device table as it really should
generate different set of events; the rest I hope we'll be able to fix
reasonably quickly if there are complaints.

> 
> > - runtime PM (hopefully I got it right);
> > 
> > - open/close.
> 
> I do not understand why needs_remote_wakeup is flipped in open/close.
> As far as I know, the device can not autosuspend after
> usb_autopm_get_interface was called anyway?

We do usb_autopm_put_interface as last action in open() so the device
will be suspended and needs wakeups.

> 
> > Still TODO:
> > 
> > - query device for supported rages instead of having module
> > parameters.
> 
> At least for the cPad the device does unfortunately not provide this
> information. I tried to read the HID descriptors once but just got
> errors. However, the defaults work quite well for all tested devices.
> The module parameters are actually meant to just provide a simple
> workaround in case one of the untested devices (especially the
> touchscreen) might need them.

OK, so why don't we replace module parameters with default ranges and
maybe later Synaptics guys will tell us how to query ranges properly?
Default ranges worked reasonably well for PS/2 version for several
years.

Thanks.

-- 
Dmitry
