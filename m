Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab1DGGQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 02:16:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58390 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab1DGGQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 02:16:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC][PATCH] PM / Platform: Remove __weak definitions of runtime PM callbacks
Date: Thu, 7 Apr 2011 08:15:41 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>, Magnus Damm <magnus.damm@gmail.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org
References: <201103270058.41632.rjw@sisk.pl> <201104070729.45484.rjw@sisk.pl> <20110407054806.GC6427@angua.secretlab.ca>
In-Reply-To: <20110407054806.GC6427@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104070815.41579.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 07, 2011, Grant Likely wrote:
> On Thu, Apr 07, 2011 at 07:29:45AM +0200, Rafael J. Wysocki wrote:
> > On Thursday, April 07, 2011, Kevin Hilman wrote:
> > > Hi Rafael, Magnus,
> > > 
> > > "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> > > 
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > >
> > > > Remove the __weak definitions of platform bus type runtime PM
> > > > callbacks, make platform_dev_pm_ops point to the generic routines
> > > > as appropriate and allow architectures using platform_dev_pm_ops to
> > > > replace the runtime PM callbacks in that structure with their own
> > > > set.
> > > >
> > > > Convert architectures providing its own definitions of the platform
> > > > runtime PM callbacks to use the new mechanism.
> > > >
> > > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > I dont't think we should be adding yet another new interface for setting
> > > platform-specific runtime PM ops.
> > > 
> > > We now have 3.  Two existing ones:
> > > 
> > > 1) new device power domains (presumably preferred)
> > > 2) platform_bus_set_pm_ops() (disliked by many)
> > 
> > Hmm, I wasn't aware of that one, will have a look.
> > 
> > > and now the new one you create here
> > > 
> > > 3) platform_set_runtime_pm_ops()
> > > 
> > > This new one is basically the same as platform_bus_set_pm_ops(), but
> > > targetted only at runtime PM ops, and also has all the same problems
> > > that have been discussed before.  Namely, it overrides the pm ops for
> > > *every* device on the platform_bus, instead of targetting only specific
> > > devices.
> > 
> > This is not a problem for this particular use case.  We really want to
> > replace the PM ops for all of the platform devices on that platform.
> 
> I strongly doubt that you really want to do that.  platform_devices
> can appear anywhere in the system, and many of them will end up being
> entirely outside the SoC, and hence outside of any SoC specific
> behaviour.

That is a valid observation, but I still think the way Kevin attempted to
use the power domain callbacks wasn't the right one for addressing this
particular issue.

> What is the use case for overriding every platform_device's PM ops?

The basic idea, which I agree with, is that we should avoid saving device
registers when the device is not going to be powered down (i.e. we only
want to gate its clock).  Since the saving of device registers is generally
done by device drivers' suspend callbacks, it's better to avoid executing
those callbacks until we know the devices in question are going to be powered
down.  That, however, is not known to the default platform bus type
callbacks that automatically invoke the drivers' callbacks if they exist.
Hence, it's better to replace the default platform bus type callbacks with
other ones that only disable the devices' clocks and let power domain
callbacks (that should know whether or not the devices will be powered down)
handle the rest.

Thanks,
Rafael
