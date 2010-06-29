Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab0F2I45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 04:56:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55032 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab0F2I44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:56:56 -0400
Date: Tue, 29 Jun 2010 10:55:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [rfc] Describe events in a structured way via sysfs
Message-ID: <20100629085532.GE22344@elte.hu>
References: <1277110509.18390.28.camel@minggr.sh.intel.com>
 <1277112858.3618.16.camel@jlt3.sipsolutions.net>
 <1277187920.4467.3.camel@minggr.sh.intel.com>
 <1277189971.3637.5.camel@jlt3.sipsolutions.net>
 <1277191359.5025.4.camel@minggr.sh.intel.com>
 <1277192007.3637.8.camel@jlt3.sipsolutions.net>
 <20100624093625.GA26931@elte.hu>
 <1277396053.3870.16.camel@jlt3.sipsolutions.net>
 <20100624173315.GA30403@elte.hu>
 <1277792114.5400.5.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277792114.5400.5.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lin Ming <ming.m.lin@intel.com> wrote:

> On Fri, 2010-06-25 at 01:33 +0800, Ingo Molnar wrote:
> > * Johannes Berg <johannes@sipsolutions.net> wrote:
> > 
> > > On Thu, 2010-06-24 at 11:36 +0200, Ingo Molnar wrote:
> > > 
> > > > That's probably best achieved via a TRACE_EVENT() variant, by passing in the 
> > > > sysfs location.
> > > > 
> > > > It might even make sense to make this a part of TRACE_EVENT() itself and make 
> > > > 'NULL' the current default, non-sysfs-enumerated behavior. That way we can 
> > > > gradually (and non-intrusively) find all the right sysfs places for events.
> > > 
> > > No, this doesn't work. A lot of events are multi-instance. Say you have an 
> > > event for each USB device. This event would have to show up in many places 
> > > in sysfs, and each trace_foo() invocation needs to get the struct device 
> > > pointer, not just the TRACE_EVENT() definition. Additionally, to 
> > > create/destroy the sysfs pieces we need something like init_trace_foo(dev) 
> > > and destroy_trace_foo(dev) be called when the sysfs points for the device 
> > > should be created/destroyed.
> > 
> > Yes - but even this could be expressed via TRACE_EVENT(): by giving it a 
> > device-specific function pointer and then instantiating individual events from 
> > a single, central place in sysfs.
> > 
> > That is the place where we already know where it ends up in sysfs, and where 
> > the event-specific function can match up whether that particular node belongs 
> > to it and whether an additional event directory should be created for that 
> > particular sysfs node.
> > 
> > > The TRACE_EVENT() just defines the template, but such multi-instance events 
> > > really should be standardised in terms of their struct device (or maybe 
> > > kobject).
> > > 
> > > I think that needs some TRACE_DEVICE_EVENT macro that creates the required 
> > > inlines etc, and including the init/destroy that are called when the event 
> > > should show up in sysfs.
> > > 
> > > There's no way you can have the event show up in sysfs at the right spot 
> > > with _just_ a TRACE_EVENT macro, since at define time in the header file you 
> > > don't even have a valid struct device pointer.
> > 
> > That would be another possible way to do it - to explicitly create the events 
> > directory. It looks a bit simpler as we wouldnt have to touch TRACE_EVENT() 
> > and because it directly expresses the 'this node has an events directory' 
> > property at the place where we create the device node.
> 
> Let me take i915 tracepoints as an example.
> Do you mean something like below?
> 
> diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
> index 423dc90..9e7e4a0 100644
> --- a/drivers/gpu/drm/i915/i915_drv.c
> +++ b/drivers/gpu/drm/i915/i915_drv.c
> @@ -28,6 +28,7 @@
>   */
>  
>  #include <linux/device.h>
> +#include <linux/perf_event.h>
>  #include "drmP.h"
>  #include "drm.h"
>  #include "i915_drm.h"
> @@ -413,7 +414,17 @@ int i965_reset(struct drm_device *dev, u8 flags)
>  static int __devinit
>  i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  {
> -	return drm_get_dev(pdev, ent, &driver);
> +	struct kobject *kobj;
> +	int ret;
> +
> +	ret = drm_get_dev(pdev, ent, &driver);
> +
> +	if (!ret) {
> +		kobj = &pdev->dev.kobj;
> +		perf_sys_register_tp(kobj, "i915");
> +	}
> +
> +	return ret;

Yeah, something like that - assuming that this means that we'll add the events 
directory to the device directory, to all the 
/sys/bus/pci/drivers/i915/*/events/ driver directories right? (i havent 
checked the DRM code)

Small detail, it could be written a bit more compactly, like:

> +	int ret;
> +
> +	ret = drm_get_dev(pdev, ent, &driver);
> +	if (!ret)
> +		perf_sys_register_tp(&pdev->dev.kobj, "i915");
> +
> +	return ret;

Also, we can (optionally) consider 'generic', subsystem level events to also 
show up under:

   /sys/bus/pci/drivers/i915/events/

This would give a model to non-device-specific events to be listed one level 
higher in the sysfs hierarchy.

This too would be done in the driver, not by generic code. It's generally the 
driver which knows how the events should be categorized.

I'd imagine something similar for wireless drivers as well - most currently 
defined events would show up on a per device basis there.

Can you see practical problems with this scheme?

	Ingo
