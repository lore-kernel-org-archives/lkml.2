Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab1GYIci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:32:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:53777 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab1GYIcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:32:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,259,1309762800"; 
   d="scan'208";a="31911902"
Subject: Re: [PATCH v2 1/6] perf: Add interface to add general events to
 sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1311580641.2617.16.camel@laptop>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
	 <1310740503-15608-2-git-send-email-ming.m.lin@intel.com>
	 <1310996068.13765.67.camel@twins>
	 <1311061926.3938.205.camel@minggr.sh.intel.com>
	 <1311580641.2617.16.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 16:32:31 +0800
Message-ID: <1311582751.3938.1481.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 15:57 +0800, Peter Zijlstra wrote:
> On Tue, 2011-07-19 at 15:52 +0800, Lin Ming wrote:
> 
> > > I'd rather not have a function pointer here, and all the kobj thingies
> > > can be hooking into the existing struct device, right?
> > 
> > I forgot to mention one important reason why I added a function pointer.
> > 
> > The events can only be added to sysfs after PMU sysfs is initialized in
> > perf_event_sysfs_init ->
> >     pmu_dev_alloc
> 
> Right.
> 
> > > @@ -5571,6 +5571,8 @@ static int pmu_dev_alloc(struct pmu *pmu)
> > >        if (ret)
> > >                goto free_dev;
> > >
> > > +       if (pmu->add_events)
> > > +               pmu->add_events();
> > 
> > So we need a pmu callback which is called in pmu_dev_alloc to add events
> > to sysfs.
> > 
> > You suggested a new interface,
> > int perf_pmu_add_event(struct pmu *pmu, const char *name, u64 config)
> > 
> > But where should it be called?
> > I guess you mean to call it in pmu init function, for example,
> > uncore_pmu_init.
> > 
> > But pmu init function maybe called before perf_event_sysfs_init, which
> > means the pmu sysfs has not been initialized yet.
> 
> Right, so there is no reason to call perf_pmu_register() really early,
> except for the normal pmu and the software pmu (since they're used by
> the watchdog muck).
> 
> The uncore for example can use late_initcall() just fine and use both
> perf_pmu_register() and the proposed perf_pmu_add_event() from the same 
> init call.
> 
> Only for the primary pmu and software thingies do we need to add an
> extra init call.

This seems a solution.

I'll use late_initcall for uncore.
Then later we can add an extra late_initcall for normal pmu and software
pmu.


