Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab2KQAWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 19:22:38 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36981 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab2KQAWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 19:22:36 -0500
Date: Fri, 16 Nov 2012 16:22:32 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>,
        linux-acpi@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, lenb@kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 0/3] acpi: Introduce prepare_remove device
 operation
Message-ID: <20121117002232.GA22543@kroah.com>
References: <1352974970-6643-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
 <1446291.TgLDtXqY7q@vostro.rjw.lan>
 <1353105943.12509.60.camel@misato.fc.hp.com>
 <20121116230143.GA15338@kroah.com>
 <1353107684.12509.65.camel@misato.fc.hp.com>
 <20121116233355.GA21144@kroah.com>
 <1353108906.10624.5.camel@misato.fc.hp.com>
 <20121117000250.GA4425@kroah.com>
 <1353110933.10939.6.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353110933.10939.6.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 05:08:53PM -0700, Toshi Kani wrote:
> > > > > > > > So the question is, does the ACPI core have to do that and if so, then why?
> > > > > > > 
> > > > > > > The problem is that acpi_memory_devcie_remove() can fail.  However,
> > > > > > > device_release_driver() is a void function, so it cannot report its
> > > > > > > error.  Here are function flows for SCI, sysfs eject and unbind.
> > > > > > 
> > > > > > Then don't ever let acpi_memory_device_remove() fail.  If the user wants
> > > > > > it gone, it needs to go away.  Just like any other device in the system
> > > > > > that can go away at any point in time, you can't "fail" that.
> > > > > 
> > > > > That would be ideal, but we cannot delete a memory device that contains
> > > > > kernel memory.  I am curious, how do you deal with a USB device that is
> > > > > being mounted in this case?
> > > > 
> > > > As the device is physically gone now, we deal with it and clean up
> > > > properly.
> > > > 
> > > > And that's the point here, what happens if the memory really is gone?
> > > > You will still have to handle it now being removed, you can't "fail" a
> > > > physical removal of a device.
> > > > 
> > > > If you remove a memory device that has kernel memory on it, well, you
> > > > better be able to somehow remap it before the kernel needs it :)
> > > 
> > > :)
> > > 
> > > Well, we are not trying to support surprise removal here.  All three
> > > use-cases (SCI, eject, and unbind) are for graceful removal.  Therefore
> > > they should fail if the removal operation cannot complete in graceful
> > > way.
> > 
> > Then handle that in the ACPI bus code, it isn't anything that the driver
> > core should care about, right?
> 
> Unfortunately not.  Please take a look at the function flow for the
> unbind case in my first email.  This request directly goes to
> driver_unbind(), which is a driver core function.

Yes, and as the user asked for the driver to be unbound from the device,
it can not fail.

And that is WAY different from removing the memory from the system
itself.  Don't think that this is the "normal" way that memory should be
removed, that is what stuff like "eject" was created for the PCI slots.

Don't confuse the two things here, unbinding a driver from a device
should not remove the memory from the system, it doesn't do that for any
other type of 'unbind' call for any other bus.  The device is still
present, just that specific driver isn't controlling it anymore.

In other words, you should NEVER have a normal userspace flow that is
trying to do unbind.  unbind is only for radical things like
disconnecting a driver from a device if a userspace driver wants to
control it, or a hacked up way to implement revoke() for a device.

Again, no driver core changes are needed here.

greg k-h
