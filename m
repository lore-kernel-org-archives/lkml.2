Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933341Ab2C1XLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 19:11:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54840 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933311Ab2C1XLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 19:11:13 -0400
Date: Wed, 28 Mar 2012 16:11:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: linux-next: Tree for Mar 26 (usbcore)
Message-ID: <20120328231109.GA14945@kroah.com>
References: <20120326180736.GA2893@kroah.com>
 <Pine.LNX.4.44L0.1203261550290.1179-100000@iolanthe.rowland.org>
 <20120326201622.GA29228@kroah.com>
 <4F7342D0.1010706@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7342D0.1010706@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 09:56:48AM -0700, Randy Dunlap wrote:
> On 03/26/2012 01:16 PM, Greg KH wrote:
> 
> > On Mon, Mar 26, 2012 at 04:06:59PM -0400, Alan Stern wrote:
> >> On Mon, 26 Mar 2012, Greg KH wrote:
> >>
> >>> On Mon, Mar 26, 2012 at 09:58:36AM -0700, Randy Dunlap wrote:
> >>>> On 03/25/2012 09:28 PM, Stephen Rothwell wrote:
> >>>>
> >>>>> Hi all,
> >>>>>
> >>>>> Reminder: please do not add stuff destined for v3.5 to linux-next
> >>>>> included trees/branches until after v3.4-rc1 has been released.
> >>>>>
> >>>>> Changes since 20120323:
> >>>>
> >>>>
> >>>>
> >>>> on x86_64:
> >>>>
> >>>> ERROR: "utf16s_to_utf8s" [drivers/usb/core/usbcore.ko] undefined!
> >>>> ERROR: "usb_speed_string" [drivers/usb/core/usbcore.ko] undefined!
> >>>>
> >>>> Full randconfig file is attached.
> >>>
> >>> Odd, nothing in the usb core has changed in a while in this area,
> >>> although we might have gotten some core dependancies mixed up for random
> >>> configurations like this.
> >>
> >> This is puzzling.
> >>
> >> 	utf16s_to_utf8s is defined in fs/nls/nls_base.c,
> >> 	which is built according to CONFIG_NLS (in fs/nls/Makefile),
> >> 	which is selected by CONFIG_USB (in drivers/usb/Kconfig).
> >>
> >> But the config that Randy attached had CONFIG_USB set to M and 
> >> CONFIG_NLS not set.  How is that possible?
> >>
> >> 	usb_speed_string is defined in drivers/usb/usb-common.c,
> >> 	which is built according to CONFIG_USB_COMMON (in
> >> 		drivers/usb/Makefile),
> >> 	which defaults to Y if CONFIG_USB_SUPPORT and either
> >> 		CONFIG_USB or CONFIG_USB_GADGET is set (in 
> >> 		drivers/usb/Kconfig).
> >>
> >> The problem here was that CONFIG_USB_SUPPORT isn't set but CONFIG_USB
> >> is set to M.  This used not to be possible, since CONFIG_USB was
> >> defined inside an "if USB_SUPPORT" section.  Maybe that got changed and
> >> needs to be fixed (but
> >> https://git.kernel.org/?p=linux/kernel/git/next/linux-next.git thinks
> >> it's still not possible).  Or maybe Randy's tree is a little out of 
> >> date.
> > 
> > Yeah, that is strange, thanks for looking into it.
> > 
> > Randy, any thoughts?
> 
> 
> It's weird.  The same config file builds successfully on
> linux-next of Mar. 27.
> 
> I looked more at linux-next of Mar. 26 and found one problem:
> in drivers/gpu/drm/Kconfig, there is a "select USB" that should be
> protected by "depends on USB_ARCH_HAS_HCD".  I did that and then
> kconfig complained about unmet dependencies in drivers/gpu/drm/udl/Kconfig,
> so I added the same "depends on" there.  That led into an awful mess:
> 
> drivers/video/Kconfig:36:error: recursive dependency detected!
> drivers/video/Kconfig:36:	symbol FB is selected by DRM_KMS_HELPER
> drivers/gpu/drm/Kconfig:26:	symbol DRM_KMS_HELPER is selected by DRM_UDL
> drivers/gpu/drm/udl/Kconfig:1:	symbol DRM_UDL depends on USB_ARCH_HAS_HCD
> drivers/usb/Kconfig:78:	symbol USB_ARCH_HAS_HCD depends on USB_ARCH_HAS_OHCI
> drivers/usb/Kconfig:24:	symbol USB_ARCH_HAS_OHCI depends on I2C
> drivers/i2c/Kconfig:5:	symbol I2C is selected by FB_DDC
> drivers/video/Kconfig:86:	symbol FB_DDC is selected by FB_CYBER2000_DDC
> drivers/video/Kconfig:385:	symbol FB_CYBER2000_DDC depends on FB_CYBER2000
> drivers/video/Kconfig:373:	symbol FB_CYBER2000 depends on FB
> 
> and I don't know what to do with this.
> 
> Anyway, I do think that the problem is in drivers/gpu/drm/Kconfig
> and drivers/gpu/drm/udl/Kconfig.

Ok, thanks for looking.  I'm worried why DRM would care about USB, but
maybe I don't want to know...

greg k-h
