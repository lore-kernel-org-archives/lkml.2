Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965230Ab2CBWjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:39:03 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46259 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137Ab2CBWjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:39:02 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.74.197 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Fri, 2 Mar 2012 14:38:53 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kay Sievers <kay.sievers@vrfy.org>,
        Federico Vaga <federico.vaga@gmail.com>
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org
Subject: Re: How to make a bus with heterogeneous devices?
Message-ID: <20120302223853.GA24929@kroah.com>
References: <20120224152051.GA23232@mail.gnudd.com>
 <20120225004008.GA3973@kroah.com>
 <1380686.VGpImaUmFA@harkonnen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380686.VGpImaUmFA@harkonnen>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 11:18:59AM +0100, Federico Vaga wrote:
> > That's fine, it is what happens with lots of drivers, you can do this
> > with the default attribute group assigned to that driver, right?
> 
> We can't because a driver can handle devices with different set of 
> attributes. We  can't use device->groups because only if match succeed 
> we know which attributes add to the device.
> That's because the same driver handles several similar devices, to avoid 
> proliferation of almost-identical drivers. So the drivers attaches 
> attributes to the device after match succeeds.

Unless you manage the uevents by "hand", you can run into big problems
with userspace tools if you add the attributes after the device is
matched to a driver.  Be very careful here.

> The solution that I temporarily  implemented is the following:
> 
> > > [...]
> > > 3- Attributes may be added after match succeeds, before calling
> > > probe.
> > > This cam be done with a "raw" call to sysfs_create_group(); then
> > > groups cna be added to dev->groups so they will be removed on
> > > device_unregister().
> > > [...]
> 
> (with calling probe I mean calling "my" driver probe)
> 
> I know it's not a nice solution and I know it's not nice add groups to 
> device->groups after registration. I can use sysfs_create_group() and 
> sysfs_remove_group() without touching the device.

It's not an issue of "touching" the device, it's an issue of "userspace
just got missed all of those attributes", so your tools will be all
confused.  The kernel has no problem with it :)

> > I think you need to look at how the system bus is handled.  It just 
> > went into 3.3-rc and allows for "different" types of devices to all be 
> > on the same bus, with different drivers and attributes.  Let me know if 
> > how that works does not work out for you.
> 
> (thank you for the reference to the patches)
> 
> I think it doesn't work in our case for the same reason we can't use 
> device_driver->groups: we know too late in the register process which 
> attributes add to a device, practically at the end of the registration.
> Maybe I'm missing something.

I think you are.

Kay, you know this area of the driver core better than I do at the
moment, given your most recent changes here.  Any reason why Alessandro
and Federico can't do the same thing that the sysdev rework did for
their devices here?

thanks,

greg k-h
