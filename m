Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab0EEXEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 19:04:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:9040 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab0EEXEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 19:04:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,337,1270450800"; 
   d="scan'208";a="273812738"
Subject: Re: [RFC PATCH v2] nohz/sched: disable ilb on !mc_capable()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
In-Reply-To: <20100504201359.GA16545@comet.dominikbrodowski.net>
References: <20100426203136.GA1539@comet.dominikbrodowski.net>
	 <1272978864.5605.193.camel@twins>
	 <20100504201359.GA16545@comet.dominikbrodowski.net>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 05 May 2010 16:03:42 -0700
Message-Id: <1273100622.2867.26.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 13:14 -0700, Dominik Brodowski wrote:
> On Tue, May 04, 2010 at 03:14:24PM +0200, Peter Zijlstra wrote:
> > On Mon, 2010-04-26 at 22:31 +0200, Dominik Brodowski wrote:
> > > From: Dominik Brodowski <linux@dominikbrodowski.net>
> > > Date: Thu, 8 Apr 2010 21:51:18 +0200
> > > Subject: [PATCH] nohz/sched: disable ilb on !mc_capable()
> > > 
> > > On my dual-core, !mc_capbale() CPU, the idle load balancer (ilb) is one
> > > of the main reasons ticks are not stopped: Under moderate load (~98 % idle),
> > > upt o half of the calls to tick_nohz_top_sched_tick() are aborted due
> > > to calls to select_nohz_load_balancer(1).
> > > 
> > > I suspect this is caused by the following phenomenon:
> > > 
> > >     CPU0				CPU1
> > >     <active>				<active>
> > >     tick_nohz_stop_sched_tick(1)
> > >     select_nohz_load_balancer(1)
> > >      => CPU0 becomes ilb owner,		<CPU1 becomes idle a bit later>
> > >         tick is not stopped,		tick_nohz_stop_sched_tick(1)
> > >         CPU0 goes to sleep for		 => CPU1 isn't the ilb owner,
> > >         exactly 1 tick.			    tick is stopped.
> > >     <short sleep>			<long sleep>
> > >     ---> scheduler_tick()
> > >     tick_nohz_stop_sched_tick(0)
> > >     tick_nohz_stop_sched_tick(1)
> > >      => is ilb owner, all CPUs are
> > >         idle, CPU0 may go to sleep.
> > > 
> > > If all CPU cores have hardly anything to do, letting the active CPU do
> > > idle load balancing allows us to enter deep sleep states earlier, and for
> > > longer periods of time. Furthermore, on !mc_capable() systems, it seems that
> > > the ilb algorithm isn't needed at all. Let's show this for a 2-core system:
> > > 
> > > - if both cores are active, ilb is deactivated
> > > - if no core is active, ilb is deactivated
> > > - if only one core is active, it attempts to balance its load off to other
> > >   CPUs on each tick anyway. ilb wouldn't act quicker.
> > > 
> > > This patch decreases the amount of wakeups on my completely idle notebook by
> > > about two thirds.
> > 
> > Right, so I think the !mc_capable() check is buggy, at the very least on
> > sparc64 which is 'creative' with its sched_domain maps.
> > 
> > I'm also not sure what a single socket AMD Magny-Cours will do.
> > 
> > On a single socket Nehalem we will have a non trivial sched_domain
> > because we also have the threads included.
> > 
> > I think we can only do your optimization for machines that end up having
> > a single sched_domain that covers the entire machine.
> 
> Is there an easy way to determine there's just a single sched_domain?

Dominik, We have posted some patches in the past to solve this issue.

http://lkml.org/lkml/2009/12/10/470

I will be re-posting the cleaned up patches shortly to address this.

thanks,
suresh

