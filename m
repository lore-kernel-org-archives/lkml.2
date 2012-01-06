Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030502Ab2AFU3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:29:37 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48477 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932638Ab2AFU3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:29:35 -0500
Date: Fri, 6 Jan 2012 15:29:34 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Problems with get_driver() and driver_attach() (and new_id too)
In-Reply-To: <20120105200515.GA1071@core.coreip.homeip.net>
Message-ID: <Pine.LNX.4.44L0.1201061505450.1326-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jan 2012, Dmitry Torokhov wrote:

> > > I think pinning driver so that it can't be unregistered (and
> > > consequently module unload hangs) its a mis-feature.
> > 
> > I suspect that references obtained from get_driver() aren't held very 
> > long.  However I haven't checked every case.
> 
> Unless we stop exporting them we can not make any assumptions on how
> long they will be held - code is changing constantly.

Something we need to watch out for: get_driver and put_driver are used
in a bunch of other places, unrelated to driver_attach.  Here's what
I found:

lib/dma-debug.c:173:  drv = get_driver(dev->driver);
lib/dma-debug.c:188:  put_driver(drv);
drivers/pci/xen-pcifront.c:596:       if (get_driver(&pdrv->driver)) {
drivers/pci/xen-pcifront.c:626:               put_driver(&pdrv->driver);
drivers/media/video/s5p-fimc/fimc-mdevice.c:348:      put_driver(driver);
drivers/media/video/s5p-fimc/fimc-mdevice.c:356:              put_driver(driver);
drivers/media/video/ivtv/ivtvfb.c:1296:       put_driver(drv);
drivers/media/video/ivtv/ivtvfb.c:1313:       put_driver(drv);
drivers/media/video/cx18/cx18-alsa-main.c:288:        put_driver(drv);
drivers/media/video/s5p-tv/mixer_video.c:61:  put_driver(drv);
drivers/s390/cio/ccwgroup.c:583:      get_driver(&cdriver->driver);
drivers/s390/cio/ccwgroup.c:595:      put_driver(&cdriver->driver);
drivers/s390/cio/device.c:1681:       drv = get_driver(&cdrv->driver);
drivers/s390/cio/device.c:1687:       put_driver(drv);
drivers/s390/net/smsgiucv_app.c:199:  put_driver(smsgiucv_drv);
drivers/ssb/main.c:146:               get_driver(&drv->drv);
drivers/ssb/main.c:153:               put_driver(&drv->drv);
drivers/net/phy/phy_device.c:934:     drv = get_driver(phydev->dev.driver);
drivers/net/phy/phy_device.c:975:     put_driver(dev->driver);

I don't think any of those calls actually accomplish anything, but it's
hard to be certain.  Some of them appear to be futile attempts to
prevent the driver from being unregistered or unloaded, others are
there simply to drop the reference taken by driver_find().

In a few of them it's obvious that the driver can't be unregistered 
while the critical section runs, but in the others I can't tell.  On 
the other hand, if a critical section can race with unregistration 
then the code is buggy now.

What do you think?

Alan Stern

