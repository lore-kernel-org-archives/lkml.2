Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902Ab1D2ULG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:11:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37006 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756786Ab1D2ULE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:11:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Subject: Re: [linux-pm] [RFC][PATCH 1/2] PM / Runtime: Support for generic I/O power domains
Date: Fri, 29 Apr 2011 22:11:03 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-sh@vger.kernel.org, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
References: <201104290154.12966.rjw@sisk.pl> <201104290154.56145.rjw@sisk.pl> <BANLkTinsKELoZAZgu0wzT_fQc1kWnd-EVg@mail.gmail.com>
In-Reply-To: <BANLkTinsKELoZAZgu0wzT_fQc1kWnd-EVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104292211.03702.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 29, 2011, MyungJoo Ham wrote:
> On Fri, Apr 29, 2011 at 8:54 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Introcude common headers, helper functions and callbacks allowing
> > platforms to use simple generic power domains for runtime power
> > management.
> >
> > Introduce struct generic_power_domain to be used for representing
> > power domains that each contain a number of devices and may be
> > master domains or subdomains with respect to other power domains.
> > Among other things, this structure includes callbacks to be
> > provided by platforms for performing specific tasks related to
> > power management (i.e. ->stop_device() may disable a device's
> > clocks, while ->start_device() may enable them, ->power_on() is
> > supposed to remove power from the entire power domain
> > and ->power_off() is supposed to restore it).
> >
> > Introduce functions that can be used as power domain runtime PM
> > callbacks, pm_genpd_runtime_suspend() and pm_genpd_runtime_resume(),
> > as well as helper functions for the initialization of a power
> > domain represented by a struct generic_power_domain object,
> > adding a device to or removing a device from it and adding or
> > removing subdomains.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Hi!
> 
> The pm_domain is assuming that there is at most one powerdomain per
> device, which is perfectly fine with my machines and the concept of
> in-SoC powerdomains.
> 
> However, if so, wouldn't it be possible to simply set powerdomain by
> setting a device's parent?
> For example, for a device, struct device *dev, and a powerdomain,
> struct device *pd, use
>  "dev.parent = pd;", and let runtime-pm handle including the
> "dev_power_governor" in the pm_domain's pm related code.

Well, not really.  There are a few things to consider.

First, in general, there may be devices that have a real parent and belong
to a power domain at the same time, so we can't "steal" the parent
pointers from them.

Second, we generally don't want subsystem-level runtime PM callbacks to be
executed directly for devices in a power domain and the domain's
callbacks are used instead.  Normally, subsystem (e.g. bus type) callbacks
execute drivers' callbacks, but for devices in a power domain we may not
really want the drivers' callbacks to be executed until the domain is ready
for power removal (i.e. pm_runtime_suspend() or equivalent has been called
for all devices in the domain already).  If we were to use the approach
you suggest, we'd need to override the subsystem's runtime PM callbacks for
the devices in the power domain _anyway_ and _additionally_ we'd need to
represent that power domain as the parent of all of those devices.  While that
might work in principle, I think it's more straightforward to do it like
in the $subject patch.  [In this approach a power domain may be regarded as an
entity providing PM callbacks replacing the subsystem ones for devices
belonging to it and those callbacks should be sufficient to make things work
without additional modifications of the device hierarchy.]

Next, if power domains were to be represented by device objects, we'd
need to create subsystem (e.g. bus type) objects providing PM callbacks
for them (so, for example, we'd have a "generic power domain" bus type)
and we'd probably need drivers for power domain "devices".  It seems that
this additional infrastructure would be a bit overweight.

Finally, if a power domain were represented as a parent of its devices,
its (or its subsystem's) runtime PM callbacks would end up executing the
runtime PM callbacks provided by its child devices' drivers, which would be
kind of unusual, so to speak.

There probably are more arguments, but I guess the above are sufficient. :-)

Thanks,
Rafael
