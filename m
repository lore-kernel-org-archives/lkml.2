Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103Ab2AITgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 14:36:35 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49704 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932844Ab2AITge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 14:36:34 -0500
Date: Mon, 9 Jan 2012 14:36:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Michael Buesch <m@bues.ch>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Incorrect uses of get_driver()/put_driver()
In-Reply-To: <20120109184944.GA24320@core.coreip.homeip.net>
Message-ID: <Pine.LNX.4.44L0.1201091426460.1541-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jan 2012, Dmitry Torokhov wrote:

> > > > > lib/dma-debug.c:173:  drv = get_driver(dev->driver);
> > > > > lib/dma-debug.c:188:  put_driver(drv);
> > > > > 
> > > > > Joerg, these calls don't seem to do anything, as far as I can tell.  
> > > > > Is there any reason to keep them?
> > > > > 
> > > > > drivers/pci/xen-pcifront.c:596:       if (get_driver(&pdrv->driver)) {
> > > > > drivers/pci/xen-pcifront.c:626:               put_driver(&pdrv->driver);
> > > > > 
> > > > > Konrad, these calls don't seem to do anything either.
> > > > > 
> > > > 
> > > > Looks like they should be replaced with the try_module_get() equivalant
> > > > for the 'struct pci_driver'? Is there such one?
> > > 
> > > You seem to need stronger guarantees that the driver simply present in
> > > memory. You need to make sure that the driver you fetched is kept being
> > > bound to the device for entire duration of pcifront_common_process().
> > 
> > OK, any suggestions?
> 
> Nothing canned I'm afraid...

device_lock(&pcidev->dev) will block unbinding.  If you take the lock 
before looking at pcidev->driver, it should be okay.

The drawback is that pdrv->error_handler may end up doing something 
that takes the same lock.  If you can verify that won't happen, there 
won't be any problem.

Alan Stern

