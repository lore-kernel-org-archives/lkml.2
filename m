Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789Ab0EEVfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 17:35:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48992 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758728Ab0EEVfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 17:35:32 -0400
Date: Wed, 5 May 2010 17:35:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Kosina <jkosina@suse.cz>
cc: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
       Oliver Neukum <oneukum@suse.de>, <linux-pm@lists.linux-foundation.org>,
       list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <jslaby@suse.cz>
Subject: Re: [linux-pm] s2ram slow (radeon) / failing (usb)
In-Reply-To: <alpine.LNX.2.00.1005052255350.9849@pobox.suse.cz>
Message-ID: <Pine.LNX.4.44L0.1005051724260.1885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 May 2010, Jiri Kosina wrote:

> > > Ok, I've been digging some further...
> > > 
> > > The hid_device_probe properly returns -ENODEV, but:
> > > 
> > > Call trace:
> > > [ 3228.866146]  [<ffffffffa01a00e6>] hid_device_probe+0xd6/0x1f0 [hid]
> > >     return -ENODEV
> > > [ 3228.874594]  [<ffffffff8130995a>] driver_probe_device+0xaa/0x1d0
> > >     calls inlined really_probe from drivers/base/dd.c
> > >     which ALLWAYS returns 0:
> > >      dd.c:147 /*
> > >           148  * Ignore errors returned by ->probe so that the next driver can try
> > >           149  * its luck.
> > >           150  */
> > >           151 ret = 0;
> > >      and has on line 139 (under same failure label):
> > >               dev->driver = NULL;
> > > [ 3228.882758]  [<ffffffff81309b20>] ? __device_attach+0x0/0x50
> > > [ 3228.890555]  [<ffffffff81309b6b>] __device_attach+0x4b/0x50
> > >      lets 0 bubble up
> > > [ 3228.898272]  [<ffffffff81308d28>] bus_for_each_drv+0x68/0x90
> > >      lets 0 bubble up
> > > [ 3228.906080]  [<ffffffff81309c3b>] device_attach+0x8b/0xa0
> > >      lets 0 bubble up
> > > [ 3228.913603]  [<ffffffff81308b15>] bus_probe_device+0x25/0x40
> > >      returns void and does WARN_ON(device_attach() < 0)
> > > [ 3228.921356]  [<ffffffff81307166>] device_add+0x3d6/0x610
> > >      returns 0 here as there was no local error
> > > [ 3228.928772]  [<ffffffffa019fc53>] hid_add_device+0x183/0x1e0 [hid]
> > > [ 3228.937098]  [<ffffffffa01b4a77>] usbhid_probe+0x287/0x420 [usbhid]
> > > [ 3228.945535]  [<ffffffffa005006d>] usb_probe_interface+0x14d/0x230 [usbcore]
> > > ...
> > > 
> > > So IMHO in hid_add_device() we should also check for hdev->dev.driver
> > > when device_add() returns 0 and consider that one being NULL as a
> > > (possible) error.

Note that it is perfectly normal for devices to be registered on a bus 
without a driver.  Perhaps the usbhid core doesn't expect this, though, 
or perhaps it doesn't make sense for HID devices.  Regardless, I don't 
see how this could cause the problem.

Earlier, Bruno said that the hang occurs in hid_cancel_delayed_stuff(), 
presumably during one of its cancel_work_sync() calls, and presumably 
because the workqueue has been frozen.  But as far as I can tell, 
cancel_work_sync() should work just fine if the workqueue has been 
frozen.  Maybe this should be investigated more closely.

Bruno, can you confirm that the hang occurs during one of those 
cancel_work_sync() calls?

Alan Stern

