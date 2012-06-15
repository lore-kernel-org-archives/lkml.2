Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab2FOBxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 21:53:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40414 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab2FOBxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 21:53:38 -0400
Date: Fri, 15 Jun 2012 10:53:31 +0900
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
Message-ID: <20120615015331.GC12624@mtj.dyndns.org>
References: <20120613102823.373180763@linutronix.de>
 <20120613105815.206105518@linutronix.de>
 <20120613183301.GE2427@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206132050270.3086@ionos>
 <1339661331.2559.5.camel@twins>
 <1339661848.2559.7.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339661848.2559.7.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 10:17:28AM +0200, Peter Zijlstra wrote:
> On Thu, 2012-06-14 at 10:08 +0200, Peter Zijlstra wrote:
> > On Wed, 2012-06-13 at 20:56 +0200, Thomas Gleixner wrote:
> > > If it's just a spurious wakeup then it goes back to sleep right away
> > > as nothing cleared the park bit. 
> > 
> > Your spurious wakeup will have destroyed the binding though. So you need
> > to be careful.
> 
> We should probably do something like the below..
> 
> TJ does this wreck workqueues? Its somewhat 'creative' in that regard
> and really wants fixing.
> 
> ---
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5018,6 +5018,8 @@ void do_set_cpus_allowed(struct task_str
>  
>  	cpumask_copy(&p->cpus_allowed, new_mask);
>  	p->nr_cpus_allowed = cpumask_weight(new_mask);
> +	if (p->nr_cpus_allowed != 1)
> +		p->flags &= ~PF_THREAD_BOUND;

The only reason wq workers use PF_THREAD_BOUND is to prevent userland
from mucking with cpus_allowed, so the above wouldn't break anything
in itself although userland would be able to wreck it afterwards.

Thanks.

-- 
tejun
