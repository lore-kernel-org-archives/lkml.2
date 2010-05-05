Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab0EEUz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:55:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:35262 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650Ab0EEUzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:55:55 -0400
Date: Wed, 5 May 2010 22:55:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Oliver Neukum <oneukum@suse.de>, linux-pm@lists.linux-foundation.org,
       list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, jslaby@suse.cz
Subject: Re: [linux-pm] s2ram slow (radeon) / failing (usb)
In-Reply-To: <20100505225329.622633d0@neptune.home>
Message-ID: <alpine.LNX.2.00.1005052255350.9849@pobox.suse.cz>
References: <20100503214642.67577f91@neptune.home> <20100503225735.6b5e2687@neptune.home> <20100503231154.486c27d6@neptune.home> <201005040842.35260.oneukum@suse.de> <alpine.LNX.2.00.1005041028300.9849@pobox.suse.cz> <20100505223054.25a0f847@neptune.home>
 <20100505225329.622633d0@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Jiri Slaby added to CC ]

On Wed, 5 May 2010, Bruno Prémont wrote:

> On Wed, 05 May 2010 Bruno Prémont <bonbons@linux-vserver.org> wrote:
> 
> > On Tue, 04 May 2010 Jiri Kosina <jkosina@suse.cz> wrote:
> > 
> > > On Tue, 4 May 2010, Oliver Neukum wrote:
> > > 
> > > > > [  477.543304] usb 1-2.1: usb_autosuspend_device: cnt 1 -> 0
> > > > > [  477.543316] usbhid 1-2.1:1.1: __pm_runtime_suspend()!
> > > > > [  477.543326] usbhid 1-2.1:1.1: __pm_runtime_suspend() returns 0!
> > > > > [  477.543380] usbcore: registered new interface driver usbhid
> > > > > [  477.549457] usbhid: USB HID core driver
> > > > > 
> > > > > And suspend is freezing inside of hid_cancel_delayed_stuff(usbhid) call
> > > > > from hid_suspend() in drivers/hid/usbhid/hid-core.c ...
> > > > > 
> > > > > Is it worth continuing iteration and adding further printk's down there?
> > > > > Jiri, what's your opinion on this?
> > > > 
> > > > Ugh. That looks like a bug in usbhid that I introduced. A fix is not trivial.
> > > > In short, I did not think the device could be undergoing a queued resumption
> > > > while suspend() is being called. I wonder why this is happening.
> > > 
> > > Hmmm ... seems to me that in this case, the problem might be that there is 
> > > a device hanging in the air, for which the parsing of report descriptor 
> > > failed (interface .0002), but it's still somehow there on the bus.
> > > 
> > > It's a bit strange that we are not seeing 
> > > 
> > > 	dev_err(&intf->dev, "can't add hid device: %d\n", ret);
> > > 
> > > message from usbhid_probe(), are we? That would mean, that we are 
> > > returning ENODEV from the usb_driver->probe routine properly.
> > > 
> > > Bruno, could you, for testing purposes, check, whether the patch below 
> > > changes the behavior you are seeing (and also check what the actual return 
> > > value from device_add() was, see the added printk()).
> > > Thanks.
> > > 
> > > 
> > > 
> > >  drivers/hid/hid-core.c        |    5 +++--
> > >  drivers/hid/usbhid/hid-core.c |    4 ++--
> > >  2 files changed, 5 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> > > index 2e2aa75..7186f9f 100644
> > > --- a/drivers/hid/hid-core.c
> > > +++ b/drivers/hid/hid-core.c
> > > @@ -1770,10 +1770,11 @@ int hid_add_device(struct hid_device *hdev)
> > >  		     hdev->vendor, hdev->product, atomic_inc_return(&id));
> > >  
> > >  	ret = device_add(&hdev->dev);
> > > +	printk(KERN_DEBUG "HID: device_add() returned %d\n", ret);
> > >  	if (!ret)
> > >  		hdev->status |= HID_STAT_ADDED;
> > > -
> > > -	hid_debug_register(hdev, dev_name(&hdev->dev));
> > > +	else
> > > +		hid_debug_register(hdev, dev_name(&hdev->dev));
> > >  
> > >  	return ret;
> > >  }
> > 
> > Ok, I've been digging some further...
> > 
> > The hid_device_probe properly returns -ENODEV, but:
> > 
> > Call trace:
> > [ 3228.866146]  [<ffffffffa01a00e6>] hid_device_probe+0xd6/0x1f0 [hid]
> >     return -ENODEV
> > [ 3228.874594]  [<ffffffff8130995a>] driver_probe_device+0xaa/0x1d0
> >     calls inlined really_probe from drivers/base/dd.c
> >     which ALLWAYS returns 0:
> >      dd.c:147 /*
> >           148  * Ignore errors returned by ->probe so that the next driver can try
> >           149  * its luck.
> >           150  */
> >           151 ret = 0;
> >      and has on line 139 (under same failure label):
> >               dev->driver = NULL;
> > [ 3228.882758]  [<ffffffff81309b20>] ? __device_attach+0x0/0x50
> > [ 3228.890555]  [<ffffffff81309b6b>] __device_attach+0x4b/0x50
> >      lets 0 bubble up
> > [ 3228.898272]  [<ffffffff81308d28>] bus_for_each_drv+0x68/0x90
> >      lets 0 bubble up
> > [ 3228.906080]  [<ffffffff81309c3b>] device_attach+0x8b/0xa0
> >      lets 0 bubble up
> > [ 3228.913603]  [<ffffffff81308b15>] bus_probe_device+0x25/0x40
> >      returns void and does WARN_ON(device_attach() < 0)
> > [ 3228.921356]  [<ffffffff81307166>] device_add+0x3d6/0x610
> >      returns 0 here as there was no local error
> > [ 3228.928772]  [<ffffffffa019fc53>] hid_add_device+0x183/0x1e0 [hid]
> > [ 3228.937098]  [<ffffffffa01b4a77>] usbhid_probe+0x287/0x420 [usbhid]
> > [ 3228.945535]  [<ffffffffa005006d>] usb_probe_interface+0x14d/0x230 [usbcore]
> > ...
> > 
> > So IMHO in hid_add_device() we should also check for hdev->dev.driver
> > when device_add() returns 0 and consider that one being NULL as a
> > (possible) error.
> 
> Something like the delow diff causes the HID registration to fail
> gracefully and `echo devices > pm_test` suspend attempt to pass.
> 
> (note, to be manually applied, is edited copy from console, so does
>  not preserve tabs and line numbers may not match due to debug printks
>  added all over the place)
> 
> 
> I don't know what impact it could have on auto-probing of device
> if a specialized HID driver that would fix reports or whatever was
> loaded later on when device is already plugged into USB.
> 
> Thanks,
> Bruno
> 
> 
> @@ -1770,11 +1779,13 @@ int hid_add_device(struct hid_device *hdev)
>                      hdev->vendor, hdev->product, atomic_inc_return(&id));
>  
>         ret = device_add(&hdev->dev);
> -       if (!ret)
> +       if (ret == 0 && !hdev->dev.driver) {
> +               device_del(&hdev->dev);
> +               ret = -ENODEV;
> +       } else {
>                 hdev->status |= HID_STAT_ADDED;
> -
> -       hid_debug_register(hdev, dev_name(&hdev->dev));
> -
> +               hid_debug_register(hdev, dev_name(&hdev->dev));
> +       }
>         return ret;
>  }
>  EXPORT_SYMBOL_GPL(hid_add_device);
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
