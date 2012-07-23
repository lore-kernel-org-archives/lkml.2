Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2GWHul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 03:50:41 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:52946 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab2GWHuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 03:50:40 -0400
Message-ID: <1343029838.6692.26.camel@vlad>
Subject: Re: [RFC] optimize the locking in the rebalance_domains()
From: Vlad Zolotarov <vlad@scalemp.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Date: Mon, 23 Jul 2012 10:50:38 +0300
In-Reply-To: <87fw8j6wnw.fsf@sejong.aot.lge.com>
References: <1342974235.6692.20.camel@vlad>
	 <87fw8j6wnw.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-23 at 11:25 +0900, Namhyung Kim wrote:
> Hi, Vlad
> 
> On Sun, 22 Jul 2012 19:23:55 +0300, Vlad Zolotarov wrote:
> > Ingo, we've noticed that rebalance_domains() will try to take a lock
> > every time it's called (every jiffy) if SD_SERIALIZE is set (which is a
> > default configuration). This is done regardless the fact that maybe
> > there hasn't passed enough time since the last rebalancing in which case
> > there is no need to take a lock the first place.
> >
> > The above creates a heavy false sharing problem on the "balancing"
> > spin-lock on large SMP systems: try_lock() is implemented with an
> > (atomic) xchng instruction which invalidates the cache line "balancing"
> > belongs to and therefore creates an intensive cross-NUMA-nodes traffic.
> >
> > The below patch will minimize the above phenomena to the time slots it's
> > really needed, namely when the "interval" has really passed.
> >
> > Pls., comment.
> >
> > thanks,
> > vlad
> >
> > ---
> >  kernel/sched/fair.c |   20 +++++++++++---------
> >  1 file changed, 11 insertions(+), 9 deletions(-)
> >
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index c099cc6..6777d38 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -4689,6 +4689,9 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
> >  		interval = msecs_to_jiffies(interval);
> >  		interval = clamp(interval, 1UL, max_load_balance_interval);
> >  
> > +                if (!time_after_eq(jiffies, sd->last_balance + interval))
> > +			goto out;
> > +
> 
> First line looks like white-space-damaged.

Looks like it. ;) Thanks for catching. I'll surely fix it if we get to
posting the patch for applying.

> Anyway, wouldn't it be better using time_before() here?

Sure. I'll fix it as well. However I'd like to hear what u and other
people on the mailing list think about the idea in general.

Thanks,
vlad

> 
> Thanks,
> Namhyung
> 
> 
> >  		need_serialize = sd->flags & SD_SERIALIZE;
> >  
> >  		if (need_serialize) {
> > @@ -4696,16 +4699,15 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
> >  				goto out;
> >  		}
> >  
> > -		if (time_after_eq(jiffies, sd->last_balance + interval)) {
> > -			if (load_balance(cpu, rq, sd, idle, &balance)) {
> > -				/*
> > -				 * We've pulled tasks over so either we're no
> > -				 * longer idle.
> > -				 */
> > -				idle = CPU_NOT_IDLE;
> > -			}
> > -			sd->last_balance = jiffies;
> > +		if (load_balance(cpu, rq, sd, idle, &balance)) {
> > +			/*
> > +			 * We've pulled tasks over so either we're no
> > +			 * longer idle.
> > +			 */
> > +			idle = CPU_NOT_IDLE;
> >  		}
> > +		sd->last_balance = jiffies;
> > +
> >  		if (need_serialize)
> >  			spin_unlock(&balancing);
> >  out:


