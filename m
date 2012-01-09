Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297Ab2AITsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 14:48:17 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49716 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933046Ab2AITsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 14:48:16 -0500
Date: Mon, 9 Jan 2012 14:48:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Incorrect uses of get_driver()/put_driver()
In-Reply-To: <20120109181449.GF15083@core.coreip.homeip.net>
Message-ID: <Pine.LNX.4.44L0.1201091438010.1541-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jan 2012, Dmitry Torokhov wrote:

> On Mon, Jan 09, 2012 at 07:03:21PM +0100, Michael Büsch wrote:
> > On Mon, 9 Jan 2012 12:35:09 -0500 (EST)
> > Alan Stern <stern@rowland.harvard.edu> wrote:
> > 
> > > drivers/ssb/main.c:146:               get_driver(&drv->drv);
> > > drivers/ssb/main.c:153:               put_driver(&drv->drv);
> > > 
> > > Michael, these are part of ssb_driver_get() and ssb_driver_put(), used
> > > in ssb_devices_freeze() and ssb_devices_thaw().  They don't currently
> > > do anything, but it looks as if they are meant to prevent the driver
> > > from being unloaded.  Should they be replaced with try_module_get()?  
> > > Or would it be good enough to call device_attach() in 
> > > ssb_devices_thaw()?
> > 
> > Hm, It seems that this code is trying to pin the ssb_driver, so that
> > it doesn't become invalid during the freeze period. So it most likely wants
> > to protect against module unload and driver unbind here. Not sure
> > if that actually works, though :/
> > 
> 
> Not at all ;)

Maybe you want to call device_lock(&sdev->dev) here?  It will prevent
the driver from being unbound (and therefore from being unloaded), and
it's likely that sdrv's remove and probe routines expect to be called
with this lock held, because that's what the device core does.  The
drawback is that holding the lock prevents other things from happening
as well, like unregistering sdev.

Alternatively, we can simply remove ssb_driver_get/put.

Alan Stern

