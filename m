Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab2AIRfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 12:35:12 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49628 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751147Ab2AIRfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 12:35:10 -0500
Date: Mon, 9 Jan 2012 12:35:09 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Joerg Roedel <joerg.roedel@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Michael Buesch <m@bues.ch>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Incorrect uses of get_driver()/put_driver()
In-Reply-To: <Pine.LNX.4.44L0.1201091133400.1541-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1201091202090.1541-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The get_driver() and put_driver() routines in the device core are not
documented well, and what they really do is quite different from what
people might think they do.  In particular, get_driver() does not
prevent a driver from being unregistered or unloaded -- the API which 
comes closest to doing that is try_module_get().

In fact, get_driver() and put_driver() are pretty much useless for
normal purposes, and Dmitry and I have been discussing getting rid of
them entirely.  But first we need to make sure that doing so won't mess
anything up.

The purpose of this email is to check with the maintainers of the
various drivers that seem to be using these routines in questionable
ways, to make sure nothing will go wrong.  Here are the places we have 
identified:

lib/dma-debug.c:173:  drv = get_driver(dev->driver);
lib/dma-debug.c:188:  put_driver(drv);

Joerg, these calls don't seem to do anything, as far as I can tell.  
Is there any reason to keep them?

drivers/pci/xen-pcifront.c:596:       if (get_driver(&pdrv->driver)) {
drivers/pci/xen-pcifront.c:626:               put_driver(&pdrv->driver);

Konrad, these calls don't seem to do anything either.

drivers/s390/cio/device.c:1681:       drv = get_driver(&cdrv->driver);
drivers/s390/cio/device.c:1687:       put_driver(drv);

Martin, these calls seem to be useless.  The calls in ccwgroup.c are 
definitely useless; there's no reason to take a reference to a driver 
while it's being unregistered, since it can't go away until the 
unregistration is finished.

drivers/ssb/main.c:146:               get_driver(&drv->drv);
drivers/ssb/main.c:153:               put_driver(&drv->drv);

Michael, these are part of ssb_driver_get() and ssb_driver_put(), used
in ssb_devices_freeze() and ssb_devices_thaw().  They don't currently
do anything, but it looks as if they are meant to prevent the driver
from being unloaded.  Should they be replaced with try_module_get()?  
Or would it be good enough to call device_attach() in 
ssb_devices_thaw()?

Alan Stern

