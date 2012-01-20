Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab2ATPq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:46:26 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37817 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753441Ab2ATPqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:46:24 -0500
Date: Fri, 20 Jan 2012 10:46:23 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Simon Glass <sjg@chromium.org>
cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH] usb: Use a workqueue in usb_add_hcd() to reduce boot
 time
In-Reply-To: <1327016262-17957-1-git-send-email-sjg@chromium.org>
Message-ID: <Pine.LNX.4.44L0.1201201033260.1509-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jan 2012, Simon Glass wrote:

> This allows the boot to progress while USB is being probed - which
> otherwise takes about 70ms per controller on my Tegra2 system.
> 
> It was mentioned some years ago in an email from Linus Torvalds:
> 
> https://lkml.org/lkml/2008/10/10/411
> 
> >  - they call usb_add_hcd, and usb_add_hcd is a horrible and slow
> > piece of crap that doesn't just add the host controller, but does all
> > the probing too.
> >
> > In other words, what should be fixed is not the initcall sequence,
> > and certainly not make PCI device probing (or other random buses) be
> > partly asynchronous, but simply make that USB host controller startup
> > function be asynchronous.

Too bad Linus didn't send this message to the linux-usb mailing list; 
it might have received more attention.  Also, it's not clear what he 
meant by "does all the probing too" -- since usb_add_hcd() is called 
from within various drivers' probe routines, it seems only reasonable 
that it _should_ do probing.

> It might be better to delay the work until much later unless USB is needed
> for the root disk, but that might have to be a command line option.

This may be a worthy goal, but your implementation is not good.  In
particular, if asynchronous usb_add_hcd fails then the driver should
not remain bound to the controller device.  Did you test what happens
when the delayed routine fails and you then try to unload the host
controller driver?

Also, you added at least one new field to the usb_hcd structure that is
pretty much just a copy of a field that already exists.  And you added
a delayed_work structure that is only going to be used once -- why not
allocate and free it separately instead?  And you created an entire new
workqueue just for registering new USB controllers; what's wrong with
using the system workqueue?

Finally, what justification is there for delaying everything by one 
second?  If a USB controller is critical then you don't want to delay 
it at all, if the controller was hotplugged some time after booting 
then a delay doesn't matter, and if the action takes place during 
booting then a 1-second delay isn't going to be long enough to make any 
difference.

Alan Stern

