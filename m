Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512Ab2EXQMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:12:43 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35211 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab2EXQMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:12:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [Update 2x][RFC][PATCH 2/2] PM / Domains: Add preliminary cpuidle support
Date: Thu, 24 May 2012 18:17:43 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Colin Cross <ccross@android.com>, Magnus Damm <magnus.damm@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
References: <201205092340.26561.rjw@sisk.pl> <201205162229.38252.rjw@sisk.pl> <87sjeqzge3.fsf@ti.com>
In-Reply-To: <87sjeqzge3.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205241817.43541.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 24, 2012, Kevin Hilman wrote:
> Hi Rafael,
> 
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > On some systems there are CPU cores located in the same power
> > domains as I/O devices.  Then, power can only be removed from the
> > domain if all I/O devices in it are not in use and the CPU core
> > is idle.  Add preliminary support for that to the generic PM domains
> > framework.
> >
> > First, the platform is expected to provide a cpuidle driver with one
> > extra state designated for use with the generic PM domains code.
> > This state should be initially disabled and its exit_latency value
> > should be set to whatever time is needed to bring up the CPU core
> > itself after restoring power to it, not including the domain's
> > power on latency.  Its .enter() callback should point to a procedure
> > that will remove power from the domain containing the CPU core at
> > the end of the CPU power transition.
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
> >    as the target by the cpuidle governor.
> >
> >  * When the first I/O device in the domain is resumed and
> >    __pm_genpd_poweron(() is called for the first time after
> >    power has been removed from the domain, the "domain" cpuidle
> >    state will be disabled to avoid subsequent surprise power removals
> >    via cpuidle.
> 
> This looks like a good approach.  I like that it keeps a pretty clean
> separation between CPUidle and PM domains.
> 
> My only comment would be that the recalc of the exit_latency should be
> described a bit more.  Specifically, I'm not sure why it's adjused at
> every genpd poweron.  At first I thought it was just supposed to be
> adjusted upon attach, then adjusted back on detatch, but with the recalc
> also in every poweron, I'm a little confused.  Care to clarify?

The problem is that the PM domains code measures the time it takes to
power off a domain and updates its power on latency parameter if the
measured time is greater.  This is done for PM QoS to operate on realistic
numbers (most of the time at least).

Of course, this also affects the CPU wakeup latency if the wakeup involves
turning a domain on.

Thanks,
Rafael
