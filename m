Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761352Ab2EJSgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:36:54 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36661 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761329Ab2EJSgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:36:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [RFC][PATCH 2/2] PM / Domains: Add preliminary cpuidle support
Date: Thu, 10 May 2012 20:41:42 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Colin Cross <ccross@android.com>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>
References: <201205092340.26561.rjw@sisk.pl> <201205092343.11050.rjw@sisk.pl> <4FAB9412.5030102@ti.com>
In-Reply-To: <4FAB9412.5030102@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205102041.42473.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 10, 2012, Santosh Shilimkar wrote:
> Rafael,
> 
> On Thursday 10 May 2012 03:13 AM, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > On some systems there are CPU cores located in the same power
> > domains as I/O devices.  Then, power can only be removed from the
> > domain if all I/O devices in it are not in use and the CPU core
> > is idle.  Add preliminary support for that to the generic PM domains
> > framework.
> > 
> I am just curious to know, what kind of IO devices, you are
> talking here?

Nothing specific, really.  It can be any kind of I/O devices that happen
to be in the same power domain.  This includes USB, SDHI, MMCIF controllers
on the SoC I have in mind in particular.

> And also how those devices linked with CPU low power
> states apart from being part of same power domain. And is it
> the power domain or more of voltage domain, we are talking here.

Depending on the definitions I guess.  How do you define a power domain and
a voltage domain?

> > This assumes that there is only one CPU core in the system and it is
> > supposed to be set up in the following way.
> > 
> > First, the platform is expected to provide a cpuidle driver with one
> > extra state designated for the generic PM domains code to handle.
> > This state should be initially disabled and its exit_latency value
> > should be set to whatever time is needed to bring up the CPU core
> > itself after restoring power to it, not including the domain's
> > power on latency.  Its .enter() callback should point to a procedure
> > that will save the CPU core's state as appropriate before power
> > removal.  On success, it should return the same value as it has
> > been passed as its third argument, but it shouldn't put the CPU
> > core into a C-state.  If it is about to return the index of
> > a different cpuidle state, however, it should make sure that the CPU
> > be put into that state before it returns.
> > 
> > The remaining characteristics of the extra cpuidle state, referred to
> > as the "domain" cpuidle state below, (e.g. power usage, target
> > residency) should be populated in accordance with the properties of
> > the hardware.
> > 
> > Next, the platform should execute genpd_attach_cpuidle() on the PM
> > domain containing the CPU core.  That will cause the generic PM
> > domains framework to treat that domain in a special way such that:
> > 
> >  * When all devices in the domain have been suspended and it is about
> >    to be turned off, the states of the devices will be saved, but
> >    power will not be removed from the domain.  Instead, the "domain"
> >    cpuidle state will be enabled so that power can be removed from
> >    the domain when the CPU core is idle and the state has been chosen
> >    as the target by the cpuidle governor.  In that case, before
> >    removing power from the domain, the framework will execute the
> >    .enter() callback initially defined for the "domain" state.
> > 
> >  * When the first I/O device in the domain is resumed and
> >    __pm_genpd_poweron(() is called for the first time after
> >    power has been removed from the domain, the "domain" cpuidle
> >    state will be disabled to avoid subsequent surprise power removals
> >    via cpuidle.
> > 
> 
> If these are CPU cluster/package specific IO's like interrupt
> controller, cache controller, Coherency interconnect etc and
> if the intention is to ensure that these devices context
> is saved/restored in cpuidle entry/exit, it can be handled with
> CPU PM notifiers.

Maybe it can, but I'm not so sure of that in general.

> We already do that for ARM SOCs.

Surely not all of them?  I know of a few at least where this isn't done.

> From the patch description it seems, they are general purpose
> peripherals.

Yes, they are.

> We had one thermal sensor on OMAP which
> wrongly clocked from the CPU clock source and needed
> some idle notifier infrastructure to prepare/resume
> this device for idle entry/exit.

The system I have in mind is designed in such a way that there is a power
domain with three subdomains, one of which contains the CPU core and the
remaining two contain I/O devices of various kinds.  General purpose as well
as "core".

Thanks,
Rafael
