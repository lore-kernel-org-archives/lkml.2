Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab2JIQkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:40:52 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39497 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab2JIQkt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:40:49 -0400
Date: Tue, 9 Oct 2012 17:40:45 +0100
From: Morten Rasmussen <Morten.Rasmussen@arm.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "pjt@google.com" <pjt@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "linaro-sched-sig@lists.linaro.org" 
	<linaro-sched-sig@lists.linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Robin Randhawa <Robin.Randhawa@arm.com>
Subject: Re: [RFC PATCH 04/10] sched: Introduce priority-based task migration
 filter
Message-ID: <20121009164045.GB3729@e103034-lin>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
 <1348252345-5642-5-git-send-email-morten.rasmussen@arm.com>
 <CAKohpo=gvA4o=d3rw18O8sMOfXCh1M=39OcdOre4c4Azs42REg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAKohpo=gvA4o=d3rw18O8sMOfXCh1M=39OcdOre4c4Azs42REg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 09 Oct 2012 16:40:45.0556 (UTC) FILETIME=[D469BB40:01CDA63C]
X-MC-Unique: 112100917404800301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 07:27:00AM +0100, Viresh Kumar wrote:
> On 22 September 2012 00:02,  <morten.rasmussen@arm.com> wrote:
> 
> > +config SCHED_HMP_PRIO_FILTER
> > +       bool "(EXPERIMENTAL) Filter HMP migrations by task priority"
> > +       depends on SCHED_HMP
> 
> Should it depend on EXPERIMENTAL?
> 
> > +       help
> > +         Enables task priority based HMP migration filter. Any task with
> > +         a NICE value above the threshold will always be on low-power cpus
> > +         with less compute capacity.
> > +
> > +config SCHED_HMP_PRIO_FILTER_VAL
> > +       int "NICE priority threshold"
> > +       default 5
> > +       depends on SCHED_HMP_PRIO_FILTER
> > +
> >  config HAVE_ARM_SCU
> >         bool
> >         help
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 490f1f0..8f0f3b9 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -3129,9 +3129,12 @@ static int __init hmp_cpu_mask_setup(void)
> >   * hmp_down_threshold: max. load allowed for tasks migrating to a slower cpu
> >   * The default values (512, 256) offer good responsiveness, but may need
> >   * tweaking suit particular needs.
> > + *
> > + * hmp_up_prio: Only up migrate task with high priority (<hmp_up_prio)
> >   */
> >  unsigned int hmp_up_threshold = 512;
> >  unsigned int hmp_down_threshold = 256;
> > +unsigned int hmp_up_prio = NICE_TO_PRIO(CONFIG_SCHED_HMP_PRIO_FILTER_VAL);
> >
> >  static unsigned int hmp_up_migration(int cpu, struct sched_entity *se);
> >  static unsigned int hmp_down_migration(int cpu, struct sched_entity *se);
> > @@ -5491,6 +5494,12 @@ static unsigned int hmp_up_migration(int cpu, struct sched_entity *se)
> >         if (hmp_cpu_is_fastest(cpu))
> >                 return 0;
> >
> > +#ifdef CONFIG_SCHED_HMP_PRIO_FILTER
> > +       /* Filter by task priority */
> > +       if (p->prio >= hmp_up_prio)
> > +               return 0;
> > +#endif
> > +
> >         if (cpumask_intersects(&hmp_faster_domain(cpu)->cpus,
> >                                         tsk_cpus_allowed(p))
> >                 && se->avg.load_avg_ratio > hmp_up_threshold) {
> > @@ -5507,6 +5516,12 @@ static unsigned int hmp_down_migration(int cpu, struct sched_entity *se)
> >         if (hmp_cpu_is_slowest(cpu))
> >                 return 0;
> >
> > +#ifdef CONFIG_SCHED_HMP_PRIO_FILTER
> > +       /* Filter by task priority */
> > +       if (p->prio >= hmp_up_prio)
> > +               return 1;
> > +#endif
> 
> Even if below cpumask_intersects() fails?
> 

No. Good catch :)

> >         if (cpumask_intersects(&hmp_slower_domain(cpu)->cpus,
> >                                         tsk_cpus_allowed(p))
> >                 && se->avg.load_avg_ratio < hmp_down_threshold) {
> 
> --
> viresh
> 

Thanks,
Morten

