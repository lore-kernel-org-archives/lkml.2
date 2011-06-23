Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313Ab1FWSTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:19:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:7566 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933256Ab1FWSTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:19:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,414,1304319600"; 
   d="scan'208";a="17632726"
Subject: Re: [patch 3/4] stop_machine: implement
 stop_machine_from_offline_cpu()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "trenn@novell.com" <trenn@novell.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>
In-Reply-To: <1308821119.1022.84.camel@twins>
References: <20110622222021.904952469@sbsiddha-MOBL3.sc.intel.com>
	 <20110622222044.038298780@sbsiddha-MOBL3.sc.intel.com>
	 <1308821119.1022.84.camel@twins>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 23 Jun 2011 11:19:13 -0700
Message-Id: <1308853153.15847.90.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 02:25 -0700, Peter Zijlstra wrote:
> On Wed, 2011-06-22 at 15:20 -0700, Suresh Siddha wrote:
> > +int stop_machine_from_offline_cpu(int (*fn)(void *), void *data,
> > +                                 const struct cpumask *cpus)
> > +{
> > +       struct stop_machine_data smdata = { .fn = fn, .data = data,
> > +                                           .active_cpus = cpus };
> > +       struct cpu_stop_done done;
> > +       int ret;
> > +
> > +       /* Local CPU must be offline and CPU hotplug in progress. */
> > +       BUG_ON(cpu_online(raw_smp_processor_id()));
> > +       smdata.num_threads = num_online_cpus() + 1;     /* +1 for local */
> > +
> > +       /* No proper task established and can't sleep - busy wait for lock. */
> > +       while (!mutex_trylock(&stop_cpus_mutex))
> > +               cpu_relax();
> > +
> > +       /* Schedule work on other CPUs and execute directly for local CPU */
> > +       set_state(&smdata, STOPMACHINE_PREPARE);
> > +       cpu_stop_init_done(&done, num_online_cpus());
> > +       queue_stop_cpus_work(cpu_online_mask, stop_machine_cpu_stop, &smdata,
> > +                            &done);
> > +       ret = stop_machine_cpu_stop(&smdata);
> > +
> > +       /* Busy wait for completion. */
> > +       while (!completion_done(&done.completion))
> > +               cpu_relax();
> > +
> > +       mutex_unlock(&stop_cpus_mutex);
> > +       return ret ?: done.ret;
> > +} 
> 
> Damn thats ugly, I sure hope you're going to make those hardware folks
> pay for this :-)

yeah, with more cores and sockets, this is becoming a pain. We will
bring this up with HW folks.

> 
> In commit d0af9eed5aa91b6b7b5049cae69e5ea956fd85c3 you mention that its
> specific to HT, wouldn't it make sense to limit the stop-machine use in
> the next patch to the sibling mask instead of the whole machine?

That specific issue was seen in the context of HT. But the SDM
guidelines (pre date HT and) are applicable for SMP too.

thanks,
suresh

