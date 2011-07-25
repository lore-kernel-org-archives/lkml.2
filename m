Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223Ab1GYHIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 03:08:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:65128 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab1GYHIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 03:08:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,259,1309762800"; 
   d="scan'208";a="31519283"
Subject: Re: [PATCH v2 1/6] perf: Add interface to add general events to
 sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1311061926.3938.205.camel@minggr.sh.intel.com>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
	 <1310740503-15608-2-git-send-email-ming.m.lin@intel.com>
	 <1310996068.13765.67.camel@twins>
	 <1311061926.3938.205.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 15:08:37 +0800
Message-ID: <1311577717.3938.1468.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 15:52 +0800, Lin Ming wrote:
> On Mon, 2011-07-18 at 21:34 +0800, Peter Zijlstra wrote:
> > On Fri, 2011-07-15 at 14:34 +0000, Lin Ming wrote:
> > > PMU can implement ::add_events() to add its general events to sysfs.
> > > 
> > > For example,
> > > 
> > > /sys/bus/event_source/devices/uncore/events
> > > └── cycle
> > > 
> > > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > > ---
> > >  include/linux/perf_event.h |    9 +++++++
> > >  kernel/events/core.c       |   52 ++++++++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 61 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> > > index 3f2711c..14337a3 100644
> > > --- a/include/linux/perf_event.h
> > > +++ b/include/linux/perf_event.h
> > > @@ -676,6 +676,14 @@ struct pmu {
> > >  	 * for each successful ->add() during the transaction.
> > >  	 */
> > >  	void (*cancel_txn)		(struct pmu *pmu); /* optional */
> > > +
> > > +	void (*add_events)		(void);
> > > +};
> > 
> > I'd rather not have a function pointer here, and all the kobj thingies
> > can be hooking into the existing struct device, right?
> 
> I forgot to mention one important reason why I added a function pointer.
> 
> The events can only be added to sysfs after PMU sysfs is initialized in
> perf_event_sysfs_init ->
>     pmu_dev_alloc
> 
> > @@ -5571,6 +5571,8 @@ static int pmu_dev_alloc(struct pmu *pmu)
> >        if (ret)
> >                goto free_dev;
> >
> > +       if (pmu->add_events)
> > +               pmu->add_events();
> 
> So we need a pmu callback which is called in pmu_dev_alloc to add events
> to sysfs.
> 
> You suggested a new interface,
> int perf_pmu_add_event(struct pmu *pmu, const char *name, u64 config)
> 
> But where should it be called?
> I guess you mean to call it in pmu init function, for example,
> uncore_pmu_init.
> 
> But pmu init function maybe called before perf_event_sysfs_init, which
> means the pmu sysfs has not been initialized yet.

Hi, Peter

Will you have a chance to look at this?

Thanks.

> 
> Lin Ming


