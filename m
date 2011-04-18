Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab1DRHnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 03:43:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:29987 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab1DRHns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 03:43:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,231,1301900400"; 
   d="scan'208";a="734920275"
Subject: Re: [patch v3 3/3] percpu_counter: use atomic64 for counter in SMP
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
In-Reply-To: <20110415041506.GC29512@mtj.dyndns.org>
References: <20110414020447.979946152@sli10-conroe.sh.intel.com>
	 <20110414020747.411215973@sli10-conroe.sh.intel.com>
	 <20110415041506.GC29512@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 15:43:45 +0800
Message-ID: <1303112625.3981.191.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-15 at 12:15 +0800, Tejun Heo wrote:
> Hello,
> 
> On Thu, Apr 14, 2011 at 10:04:50AM +0800, shaohua.li@intel.com wrote:
> > Index: linux/lib/percpu_counter.c
> > ===================================================================
> > --- linux.orig/lib/percpu_counter.c	2011-04-14 09:53:04.000000000 +0800
> > +++ linux/lib/percpu_counter.c	2011-04-14 10:01:29.000000000 +0800
> > @@ -59,13 +59,17 @@ void percpu_counter_set(struct percpu_co
> >  {
> >  	int cpu;
> >  
> > -	spin_lock(&fbc->lock);
> > +	/*
> > +	 * Don't really need to disable preempt here, just make sure there is
> > +	 * no big latency because of preemption
> > +	 */
> > +	preempt_disable();
> >  	for_each_possible_cpu(cpu) {
> >  		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
> >  		*pcount = 0;
> >  	}
> > -	fbc->count = amount;
> > -	spin_unlock(&fbc->lock);
> > +	atomic64_set(&fbc->count, amount);
> > +	preempt_enable();
> 
> Disabling preemption here doesn't make any sense.
> percpu_counter_set() inherently requires its users to guarantee that
> no other user is modifying the percpu counter.
ha, ok.
should I still rebase the patch against Christoph's patch? Looks that
one is still not settled down.


