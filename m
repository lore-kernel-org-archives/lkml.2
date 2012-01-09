Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab2AIRF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 12:05:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57246 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab2AIRF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 12:05:26 -0500
Date: Mon, 9 Jan 2012 09:05:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Problems with get_driver() and driver_attach() (and new_id too)
Message-ID: <20120109170515.GB15083@core.coreip.homeip.net>
References: <20120109084828.GE4049@core.coreip.homeip.net>
 <Pine.LNX.4.44L0.1201091133400.1541-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1201091133400.1541-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 11:37:57AM -0500, Alan Stern wrote:
> On Mon, 9 Jan 2012, Dmitry Torokhov wrote:
> 
> > > I don't think any of those calls actually accomplish anything, but it's
> > > hard to be certain.  Some of them appear to be futile attempts to
> > > prevent the driver from being unregistered or unloaded, others are
> > > there simply to drop the reference taken by driver_find().
> > > 
> > > In a few of them it's obvious that the driver can't be unregistered 
> > > while the critical section runs, but in the others I can't tell.  On 
> > > the other hand, if a critical section can race with unregistration 
> > > then the code is buggy now.
> > > 
> > > What do you think?
> > 
> > I think we need to audit them and decide on case-by-case basis. For
> > example drivers/s390/cio/device.c is completely nonsensical: it takes a
> > reference on a driver that is passed as argument before calling
> > driver_find_device(). But if passed driver was valid before we called
> > get_driver it won't become any more valid afterwards and it should not
> > disappear either.
> > 
> > drivers/s390/cio/ccwgroup.c - calls are useless;
> > 
> > Authors of drivers/net/phy/phy_device.c had their reservations:
> > 
> >         /* Make sure the driver is held.
> >          * XXX -- Is this correct? */
> >         drv = get_driver(phydev->dev.driver);
> > 
> > However it is in phydev_probe() and I hope our device core takes care of
> > not destroying drivers in the middle of binding to a device.
> 
> Yes, it does.  That one looks like a misunderstanding.  It calls
> get_driver during phy_probe and put_driver during phy_remove, which
> accomplishes nothing.
> 
> > drivers/ssb/main.c seems like needs some protection but does it
> > incorrectly as we do not wait for drivers to drop all references before
> > unloading modules.
> 
> Possibly it needs to be replaced with try_module_get.  I'll send out an 
> email to the maintainers of these drivers to see what they think.

Looking at SSB some more they seem to be releasing devices to make sure
nobody accesses them while SPROM is being written, but while they do
release all devices I do not see how they prevent new binding from
taking place. It all should probably replaced by doing
mutex_trylock(&bus->sprom_lock) in their probe() and using device core
iterators to unbind/rebind the drivers (do we even need to do the
bookkeeping of devices previously bound/not bound?).

Thanks.

-- 
Dmitry
