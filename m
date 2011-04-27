Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640Ab1D0RQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 13:16:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38160 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759588Ab1D0RQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 13:16:07 -0400
Date: Wed, 27 Apr 2011 13:16:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Tanya Brokhman <tlinder@codeaurora.org>, <gregkh@suse.de>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        <balbi@ti.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "'Matthew Wilcox'" <matthew.r.wilcox@intel.com>
Subject: Re: [RFC/PATCH v3 2/5] uas: MS UAS Gadget driver - Infrastructure
In-Reply-To: <20110426200625.GB5405@xanatos>
Message-ID: <Pine.LNX.4.44L0.1104271304460.2239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011, Sarah Sharp wrote:

> I meant that during enumeration, configuration 1 would be installed, and
> because the USB core doesn't try to install a particular alternate
> interface setting, alt setting 0 would be active by default.

Unless the driver changed it.

> How would the usb-storage driver reject a bind by the USB core?  By
> returning an error from the probe function?  Would the USB core go and
> search for the next driver after the BOT driver rejected the bind?  It
> looks like usb_probe_interface will just return an error if the first
> driver's probe function fails.

If a driver's or subsystem's probe routine returns an error then the
driver core continues looking for another driver.  If the error code is
-ENODEV or -ENXIO then it doesn't even put a warning in the kernel log;  
the driver core takes this to mean that the driver detected it couldn't
handle the device.  See drivers/base/dd.c:really_probe().

> > Which reminds me...  Fallbacks are always a good idea.  If usb-storage 
> > did decide not to bind to combined BOT/UAS devices, we should have a 
> > mechanism for overriding this choice (i.e., forcing usb-storage to bind 
> > regardless).
> 
> Sure, maybe a module parameter like "own_uas"?  Or do we want something
> fancier, like a way to specify a list of VID:PIDs that the usb-storage
> driver should own?  (I think the list parsing might be a bit hard to
> implement though.)

The VID:PID thing would work; usb-storage already has a "quirks" 
parameter that accepts such things.  We could add a quirk for binding
to a BOT/UAS interface.

> > Likewise, Sarah, you should consider adding a mechanism to xhci-hcd for 
> > forcing individual root-hub ports not to run at SuperSpeed (rather like 
> > the "companion" attribute file in ehci-hcd, although I'm sure you can 
> > come up with a better name).
> 
> I'm not entirely sure I can force a port down to USB 2.0 speeds, because
> I'm not sure I can disable the port or turn off SuperSpeed terminations
> from the xHCI driver.  I'd have to look into it.

This sounds like the problem we encountered while trying to disable a
SuperSpeed port.  It merely forced the device to switch over to the
USB-2 bus.  That wasn't what we wanted then, but it is what we're
interested in now.

Getting things to switch back might be harder -- re-enabling the 
SuperSpeed terminations won't force the device to stop using the USB-2 
bus.  It might be necessary to reset the USB-2 port.

Alan Stern

