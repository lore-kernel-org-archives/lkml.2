Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030635Ab2HQDsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:48:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48541 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964812Ab2HQDsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:48:30 -0400
Date: Thu, 16 Aug 2012 20:48:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Lan, Tianyu" <tianyu.lan@intel.com>
Subject: Re: BUG: unable to handle kernel paging request in usb_match_id()
Message-ID: <20120817034825.GC7770@kroah.com>
References: <20120805025938.GA8954@localhost>
 <20120805165826.GB13913@kroah.com>
 <20120817020046.GA24406@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120817020046.GA24406@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 10:00:46AM +0800, Fengguang Wu wrote:
> On Sun, Aug 05, 2012 at 09:58:26AM -0700, Greg KH wrote:
> > On Sun, Aug 05, 2012 at 10:59:38AM +0800, Fengguang Wu wrote:
> > > Hi all,
> > > 
> > > This line triggers an oops in kvm boot test:
> > > 
> > > usb_match_id():
> > > ==>      748         for (; id->idVendor || id->idProduct || id->bDeviceClass ||
> > >          749                id->bInterfaceClass || id->driver_info; id++) {
> > >          750                 if (usb_match_one_id(interface, id))
> > >          751                         return id;
> > >          752         }
> > > 
> > > It's an old bug and happens also in linux 3.0. It's very reproducible
> > > for the attached config. I can send the initrd (yocto-minimal-i386.cgz)
> > > on your request in private email.
> > 
> > Odds are a driver without a terminating NULL for the device id list is
> > causing this to fail.
> > 
> > What devices are in the system and what drivers are trying to be bound?
> 
> The last match is for: drivers/usb/misc/emi62.c
> 
> Located down by Tianyu's debug patch:
> 
> [    2.206708] usb_device_match: device 1-1:1.0, driver cytherm
> [    2.207627] usb_device_match: device 1-1:1.0, driver emi62 - firmware loader
> [    2.208769] BUG: unable to handle kernel paging request at c1f7478e
> [    2.209726] IP: [<c14ac1c0>] usb_match_id+0x5b/0xcd
> 
> > --- a/drivers/usb/core/driver.c
> > +++ b/drivers/usb/core/driver.c
> > @@ -778,7 +778,8 @@ static int usb_device_match(struct device *dev, struct device_driver *drv)
> >
> >                 intf = to_usb_interface(dev);
> >                 usb_drv = to_usb_driver(drv);
> > -
> > +
> > +               pr_info("%s: device %s, driver %s \n", dev_name(dev), drv->name);
> >                 id = usb_match_id(intf, usb_drv->id_table);
> >                 if (id)
> >                         return 1;

Odd that it takes so long after you call that function for it to fail.

And that driver has a proper termination, so we aren't walking off the
end of the list, so it must be in the probe function itself.

Care to add some more debugging for that driver?

Also, I don't see the dev_info() message from the driver itself, in the
probe function, so it must not be getting called properly.

Something weird is happening...

greg k-h
