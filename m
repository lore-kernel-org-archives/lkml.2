Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab1KBPOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:14:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:15846 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782Ab1KBPO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:14:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,443,1315206000"; 
   d="scan'208";a="32562723"
Subject: Re: [Patch] Idle balancer: cache align nohz structure to improve
 idle load balancing scalability
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Venki Pallipadi <venki@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20111102135414.GC6820@linux.vnet.ibm.com>
References: <1319060737.2604.38.camel@schen9-DESK>
	 <m2wrc0xpbg.fsf@firstfloor.org>
	 <CABeCy1a20npBt=4ee38zLH+6Fi7nfASd0dL3od6pOccV=LJDkA@mail.gmail.com>
	 <4FF5AC937153B0459463C1A88EB478F20135D6ECB5@orsmsx505.amr.corp.intel.com>
	 <1320191558.28097.44.camel@sbsiddha-desk.sc.intel.com>
	 <20111102135414.GC6820@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel
Date: Wed, 02 Nov 2011 08:13:32 -0700
Message-ID: <1320246812.2565.3.camel@sbsiddha-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-02 at 06:54 -0700, Srivatsa Vaddagiri wrote:
> * Suresh Siddha <suresh.b.siddha@intel.com> [2011-11-01 16:52:38]:
> 
> > +	/*
> > +	 * We were recently in tickless idle mode. We will do the delayed
> > +	 * update of busy mode now (first busy tick after returning from idle).
> > +	 */
> > +	if (unlikely(rq->tick_stopped)) {
> > +		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
> > +
> > +		if (cpumask_bits(nohz.idle_cpus_mask)[BIT_WORD(cpu)] == 0 &&
> > +		    cpumask_empty(nohz.idle_cpus_mask))
> > +			clear_bit(NOHZ_NEED_BALANCING, &nohz.bits);
> 
> Can't this clear_bit race with set_bit() in select_nohz_load_balancer()?
> 
>    CPU0				CPU1
> 
> cpumask_clear_cpu()
> if ( ...)
> 				cpumask_set_cpu();
> 				set_bit();
> 
> 	clear_bit();
> 
> ?

Yes. All I want is a quick way of getting the
cpumask_weight(nohz.idle_cpus_mask) so that the busy cpu need not spend
much time to see if there is an idle cpu that needs idle load balancing.
Let me see if there is any simple way or else we need nohz.nr_idle_cpus

thanks,
suresh

