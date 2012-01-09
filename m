Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab2AIIsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 03:48:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41510 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab2AIIse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 03:48:34 -0500
Date: Mon, 9 Jan 2012 00:48:28 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Problems with get_driver() and driver_attach() (and new_id too)
Message-ID: <20120109084828.GE4049@core.coreip.homeip.net>
References: <20120105200515.GA1071@core.coreip.homeip.net>
 <Pine.LNX.4.44L0.1201061505450.1326-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1201061505450.1326-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 03:29:34PM -0500, Alan Stern wrote:
> On Thu, 5 Jan 2012, Dmitry Torokhov wrote:
> 
> > > > I think pinning driver so that it can't be unregistered (and
> > > > consequently module unload hangs) its a mis-feature.
> > > 
:q> > > I suspect that references obtained from get_driver() aren't held very 
> > > long.  However I haven't checked every case.
> > 
> > Unless we stop exporting them we can not make any assumptions on how
> > long they will be held - code is changing constantly.
> 
> Something we need to watch out for: get_driver and put_driver are used
> in a bunch of other places, unrelated to driver_attach.  Here's what
> I found:
> 
> lib/dma-debug.c:173:  drv = get_driver(dev->driver);
> lib/dma-debug.c:188:  put_driver(drv);
> drivers/pci/xen-pcifront.c:596:       if (get_driver(&pdrv->driver)) {
> drivers/pci/xen-pcifront.c:626:               put_driver(&pdrv->driver);
> drivers/media/video/s5p-fimc/fimc-mdevice.c:348:      put_driver(driver);
> drivers/media/video/s5p-fimc/fimc-mdevice.c:356:              put_driver(driver);
> drivers/media/video/ivtv/ivtvfb.c:1296:       put_driver(drv);
> drivers/media/video/ivtv/ivtvfb.c:1313:       put_driver(drv);
> drivers/media/video/cx18/cx18-alsa-main.c:288:        put_driver(drv);
> drivers/media/video/s5p-tv/mixer_video.c:61:  put_driver(drv);
> drivers/s390/cio/ccwgroup.c:583:      get_driver(&cdriver->driver);
> drivers/s390/cio/ccwgroup.c:595:      put_driver(&cdriver->driver);
> drivers/s390/cio/device.c:1681:       drv = get_driver(&cdrv->driver);
> drivers/s390/cio/device.c:1687:       put_driver(drv);
> drivers/s390/net/smsgiucv_app.c:199:  put_driver(smsgiucv_drv);
> drivers/ssb/main.c:146:               get_driver(&drv->drv);
> drivers/ssb/main.c:153:               put_driver(&drv->drv);
> drivers/net/phy/phy_device.c:934:     drv = get_driver(phydev->dev.driver);
> drivers/net/phy/phy_device.c:975:     put_driver(dev->driver);
> 
> I don't think any of those calls actually accomplish anything, but it's
> hard to be certain.  Some of them appear to be futile attempts to
> prevent the driver from being unregistered or unloaded, others are
> there simply to drop the reference taken by driver_find().
> 
> In a few of them it's obvious that the driver can't be unregistered 
> while the critical section runs, but in the others I can't tell.  On 
> the other hand, if a critical section can race with unregistration 
> then the code is buggy now.
> 
> What do you think?

I think we need to audit them and decide on case-by-case basis. For
example drivers/s390/cio/device.c is completely nonsensical: it takes a
reference on a driver that is passed as argument before calling
driver_find_device(). But if passed driver was valid before we called
get_driver it won't become any more valid afterwards and it should not
disappear either.

drivers/s390/cio/ccwgroup.c - calls are useless;

Authors of drivers/net/phy/phy_device.c had their reservations:

        /* Make sure the driver is held.
         * XXX -- Is this correct? */
        drv = get_driver(phydev->dev.driver);

However it is in phydev_probe() and I hope our device core takes care of
not destroying drivers in the middle of binding to a device.

drivers/ssb/main.c seems like needs some protection but does it
incorrectly as we do not wait for drivers to drop all references before
unloading modules.

Thanks.

-- 
Dmitry
