Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab1BOXN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 18:13:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48995 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058Ab1BOXN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 18:13:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [RFC][PATCH 1/2] PM: Add support for device power domains
Date: Wed, 16 Feb 2011 00:12:56 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.44L0.1102141110400.1716-100000@iolanthe.rowland.org> <201102142334.47553.rjw@sisk.pl> <AANLkTimejb2FifpEC1pu+RCmFsT-aR9GCdHLQ=PZkJx9@mail.gmail.com>
In-Reply-To: <AANLkTimejb2FifpEC1pu+RCmFsT-aR9GCdHLQ=PZkJx9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102160012.57181.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 15, 2011, Magnus Damm wrote:
> On Tue, Feb 15, 2011 at 7:34 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, February 14, 2011, Alan Stern wrote:
> >> On Sat, 12 Feb 2011, Rafael J. Wysocki wrote:
> >>
> >> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >> >
> >> > The platform bus type is often used to handle Systems-on-a-Chip (SoC)
> >> > where all devices are represented by objects of type struct
> >> > platform_device.  In those cases the same "platform" device driver
> >> > may be used with multiple different system configurations, but the
> >> > actions needed to put the devices it handles into a low-power state
> >> > and back into the full-power state may depend on the design of the
> >> > given SoC.  The driver, however, cannot possibly include all the
> >> > information necessary for the power management of its device on all
> >> > the systems it is used with.  Moreover, the device hierarchy in its
> >> > current form also is not suitable for representing this kind of
> >> > information.
> >> >
> >> > The patch below attempts to address this problem by introducing
> >> > objects of type struct dev_power_domain that can be used for
> >> > representing power domains within a SoC.  Every struct
> >> > dev_power_domain object provides a sets of device power
> >> > management callbacks that can be used to perform what's needed for
> >> > device power management in addition to the operations carried out by
> >> > the device's driver and subsystem.
> >> >
> >> > Namely, if a struct dev_power_domain object is pointed to by the
> >> > pwr_domain field in a struct device, the callbacks provided by its
> >> > ops member will be executed in addition to the corresponding
> >> > callbacks provided by the device's subsystem and driver during all
> >> > power transitions.
> >>
> >> Overall this looks very good.
> 
> I think so too.
> 
> >> > Index: linux-2.6/include/linux/pm.h
> >> > ===================================================================
> >> > --- linux-2.6.orig/include/linux/pm.h
> >> > +++ linux-2.6/include/linux/pm.h
> >> > @@ -463,6 +463,14 @@ struct dev_pm_info {
> >> >
> >> >  extern void update_pm_runtime_accounting(struct device *dev);
> >> >
> >> > +/*
> >> > + * Power domains provide callbacks that are executed during system suspend,
> >> > + * hibernation, system resume and during runtime PM transitions along with
> >> > + * subsystem-level and driver-level callbacks.
> >> > + */
> >> > +struct dev_power_domain {
> >> > +   struct dev_pm_ops       ops;
> >> > +};
> >>
> >> I don't have a clear picture of how people are going to want to use
> >> these dev_power_domain structures.  Should there be a
> >>
> >>       void                    *priv;
> >>
> >> member as well?
> >
> > Well, I'm not sure.  What would be the purpose of it?
> 
> As Alan pointed out, a private pointer may be useful for the
> SoC-specific power domain code. I'm yet to tie in this code with
> working hardware power domain support, so it's hard for me to say if a
> private pointer will help or not at this point. An alternative to
> private pointers for the SoC-specific power domain code is to use
> devres_alloc().

I'm not against the priv pointer, but I'd simply prefer to add it once we
have a good use case for it.

> I believe it is important to have some kind of power domain mapping
> for each hardware block on a SoC device.
> On SH-Mobile I had this hidden in the SoC-specific code, grep for
> HWBLK to find my approach to deal with power domains. The HWBLK enums
> provide a unique identifier for each device instance on the SoC.
> 
> Having the power domain code framework as generic as possible is of
> course a good idea. So I'm very happy to see these patches. Per-struct
> device power domain pointers make sense IMO.

Good.

> I do wonder how this ties into multiple levels of power management.
> This will be needed for Runtime PM at some point.
> 
> To compare Runtime PM with CPUIdle, I believe the CPUIdle core can ask
> the cpu-specific code to enter a certain level of sleep mode, but the
> cpu-specific code can chose to not follow this and sleep lightly if
> for instance hardware dependencies prevent the deep sleep mode to be
> entered. I believe something similar will be needed on Runtime PM, but
> controlling power domains instead of sleep modes.
> 
> Any ideas?

One possibility is that the power domain callbacks will decide what power
state to put the domain into (once "idle" has been called for all devices
in the domain).  Of course, they will need some input allowing them to make
the decision (like what's the greatest acceptable resume latency for example).

Still, the PCI bus type has a similar problem, but PCI devices are put into
low-power states by the bus type callbacks, so those callbacks would have to
decide what state to choose (currently they simply choose the lowest power
state available and we don't really take the resume latency into
consideration).

So, whatever approach we invent, it should be suitable for both the cases
above, or it will have to stay platform-specific.

Thanks,
Rafael
