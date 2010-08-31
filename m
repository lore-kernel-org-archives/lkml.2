Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab0HaIYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 04:24:13 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:44947 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596Ab0HaIYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 04:24:10 -0400
Date: Tue, 31 Aug 2010 10:26:06 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH/RFC 1/5] [PATCH] sched: merge cpu_to_core_group
 functions
Message-ID: <20100831082606.GA2166@osiris.boeblingen.de.ibm.com>
References: <20100812172544.655648128@de.ibm.com>
 <20100812172621.703227914@de.ibm.com>
 <1281733914.2704.28.camel@sbsiddha-MOBL3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281733914.2704.28.camel@sbsiddha-MOBL3.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 02:11:54PM -0700, Suresh Siddha wrote:
> On Thu, 2010-08-12 at 10:25 -0700, Heiko Carstens wrote:
> > diff -urpN linux-2.6/kernel/sched.c linux-2.6-patched/kernel/sched.c
> > --- linux-2.6/kernel/sched.c	2010-08-11 13:47:16.000000000 +0200
> > +++ linux-2.6-patched/kernel/sched.c	2010-08-11 13:47:22.000000000 +0200
> > @@ -6546,31 +6546,23 @@ cpu_to_cpu_group(int cpu, const struct c
> >  #ifdef CONFIG_SCHED_MC
> >  static DEFINE_PER_CPU(struct static_sched_domain, core_domains);
> >  static DEFINE_PER_CPU(struct static_sched_group, sched_group_core);
> > -#endif /* CONFIG_SCHED_MC */
> >  
> > -#if defined(CONFIG_SCHED_MC) && defined(CONFIG_SCHED_SMT)
> >  static int
> >  cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
> >  		  struct sched_group **sg, struct cpumask *mask)
> >  {
> >  	int group;
> > -
> > +#ifdef CONFIG_SCHED_SMT
> >  	cpumask_and(mask, topology_thread_cpumask(cpu), cpu_map);
> >  	group = cpumask_first(mask);
> > +#else
> > +	group = cpu;
> > +#endif
> >  	if (sg)
> >  		*sg = &per_cpu(sched_group_core, group).sg;
> >  	return group;
> >  }
> > -#elif defined(CONFIG_SCHED_MC)
> > -static int
> > -cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
> > -		  struct sched_group **sg, struct cpumask *unused)
> > -{
> > -	if (sg)
> > -		*sg = &per_cpu(sched_group_core, cpu).sg;
> > -	return cpu;
> > -}
> > -#endif
> > +#endif /* CONFIG_SCHED_MC */
> >  
> >  static DEFINE_PER_CPU(struct static_sched_domain, phys_domains);
> >  static DEFINE_PER_CPU(struct static_sched_group, sched_group_phys);
> 
> Reason why this code was structured like this was because of the
> feedback from Andrew Morton. http://lkml.org/lkml/2006/1/27/308

Well, if I wouldn't merge this then the upcoming cpu_to_book_group
function would just be horribly long and unreadable. I think merging
this so it looks the same like cpu_to_phys_group is the right thing
to do.
If I wouldn't do that then the cpu_to_book_group function would just
be a real big mess instead of quite simple function.
