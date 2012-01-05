Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab2AESll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:41:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33168 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab2AESlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:41:39 -0500
Date: Thu, 5 Jan 2012 11:41:36 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>, Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Driver core support for early platform devices
Message-ID: <20120105184136.GJ22653@ponder.secretlab.ca>
References: <0282FD61-7E73-45CE-8EC8-32BF411C7619@boeing.com>
 <20111222174521.GA29144@suse.de>
 <99F3E881-FB9E-4D49-9A91-793FDD04795D@boeing.com>
 <4EF396CD.2000601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF396CD.2000601@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 02:45:01PM -0600, Rob Herring wrote:
> On 12/22/2011 11:55 AM, Moffett, Kyle D wrote:
> > On Dec 22, 2011, at 12:45, Greg KH wrote:
> >> On Thu, Dec 22, 2011 at 11:15:06AM -0600, Moffett, Kyle D wrote:
> >>> Hi,
> >>>
> >>> I'm tinkering with some improvements to the way that OpenPIC/MPIC are
> >>> detected and loaded on PowerPC platforms, and it seems like I am trying
> >>> to use the driver model before it is fully initialized.
> >>>
> >>> In particular, it seems like it should be possible to simply declare an
> >>> OpenPIC in the device-tree and have it automatically bound to a platform
> >>> driver declaring the right OpenFirmware match strings.
> >>>
> >>> Unfortunately, it needs to be bound by init_IRQ() time, while the driver
> >>> model does not get initialized until much later (after the scheduler is
> >>> up and running).
> >>>
> >>> As far as I can tell, there seem to be 2 possible approaches to making
> >>> that possible:
> >>>
> >>> (1) Split the driver-model initialization into "early" and "late" phases
> >>>    so that drivers can be registered and devices probed very early on
> >>>    and then replay the necessary scheduler-dependent things after the
> >>>    system is mostly started up (IE: devtmpfs, etc).
> >>
> >> We already have that today with the "early_platform*" functions, right?
> >> Will those work for you, or do you need this for a bus you are creating
> >> and not using the platform bus?
> > 
> > Well, I can't figure out how "early_platform" is actually supposed to
> > integrate with the platform bus itself.  It seems designed mostly for
> > drivers like "earlyprintk" et. al. for which loading is controlled by
> > a kernel parameter.
> > 
> > Specifically, I don't see any "early_platform" logic to match devices in
> > the OF device-tree based on the driver "of_match" parameters, just based
> > on text strings in early_param().
> > 
> > Furthermore, if I register an "early_platform" device, it seems to get
> > unregistered when the normal driver model is brought up, instead of
> > being sucked in and promoted to a normal platform_device.  That code is
> > pretty poorly documented and only used in a couple places right now,
> > though, so it's possible I am misreading it.
> > 
> > Cheers,
> > Kyle Moffett
> 
> There was a proposal for DT support of early platform devices here:
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2011-June/054529.html

I'm not a fan of early platform devices, and as Kyle points out, it
doesn't really solve his problem.

Kyle, I wouldn't get too tied up with thinking about the device model.
There are always some critical core devices, like root interrupt
controllers, that just have to be set up way earlier than any of the
initcalls.  So, yes, it would be nice if the kernel automagically
picked up the root irq controller from the device tree, and if it was
wired into the driver model. However, in practical terms it doesn't
buy us much.  You can get almost the same behaviour by the SoC support
code providing a table of the irq controllers that need to be set up
at boot time and using a helper function to initialize them in the
correct order.

Have a look at of_irq_init().  It might do what you need.

g.

