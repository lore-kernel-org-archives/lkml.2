Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab1HaNiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:38:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34310 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab1HaNiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:38:03 -0400
Date: Wed, 31 Aug 2011 15:37:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 05/32] nohz: Move rcu dynticks idle mode handling to idle
 enter/exit APIs
Message-ID: <20110831133754.GA20598@somewhere>
References: <20110829175954.GF9748@somewhere.redhat.com>
 <1314641160.2816.128.camel@twins>
 <20110829233521.GK9748@somewhere.redhat.com>
 <1314703315.2799.5.camel@twins>
 <20110830143207.GP9748@somewhere.redhat.com>
 <1314717993.5812.11.camel@twins>
 <20110830153343.GW9748@somewhere.redhat.com>
 <1314737918.19586.8.camel@twins>
 <20110830222432.GD15953@somewhere.redhat.com>
 <1314782245.23993.9.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314782245.23993.9.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 11:17:25AM +0200, Peter Zijlstra wrote:
> On Wed, 2011-08-31 at 00:24 +0200, Frederic Weisbecker wrote:
> > On Tue, Aug 30, 2011 at 10:58:38PM +0200, Peter Zijlstra wrote:
> > > On Tue, 2011-08-30 at 17:42 +0200, Peter Zijlstra wrote:
> > > > On Tue, 2011-08-30 at 17:33 +0200, Frederic Weisbecker wrote:
> > > > > > See all that is still kernelspace ;-) I think I know what you mean to
> > > > > > say though, but seeing as you note there is even now a known shortcoming
> > > > > > I'm not very confident its a solid construction. What will help us find
> > > > > > such holes?
> > > > > 
> > > > > This: https://lkml.org/lkml/2011/6/23/744
> > > > > 
> > > > > It's in one of Paul's branches and should make it for the next merge window.
> > > > > This should detect any of such holes. I made that on purpose for the nohz cpusets
> > > > > when I saw how much error prone that can be with rcu :)
> > > > 
> > > > OK, good ;-)
> > > > 
> > > > > > I would much rather we not rely on such fragile things too much.. this
> > > > > > RCU stuff wants way more thought, as it stands your patch-set doesn't do
> > > > > > anything useful IMO.
> > > > > 
> > > > > Not sure what you mean. Well that Rcu thing for sure is fragile but we have
> > > > > the tools ready to find the problems. 
> > > > 
> > > > Right that thing you linked above does catch abuse, still your current
> > > > proposal means that due to RCU it will basically never disable the tick.
> > > 
> > > So how about something like:
> > > 
> > > Assuming we are in rcu_nohz state; on kernel enter we leave rcu_nohz but
> > > don't start the tick, instead we assign another cpu to run our state
> > > machine.
> > 
> > The nohz CPU still has to notice its own quiescent states. 
> 
> Why? rcu-sched can use a context-switch counter, rcu-preempt doesn't
> even need that. Remote cpus can notice those just fine.

If that's fine to only rely on context switches, which don't happen in
a bounded time in theory, then ok.

Would be nice to hear about Paul's opinion on that.
 
> > Now it could be
> > an optimization to ask another CPU to handle all the rest once that quiescent
> > state is found. That doesn't solve our main problem though which is to
> > reliably report quiescent states when asked for.
> 
> No, seriously, RCU should not, ever, need to re-enable the tick. Imagine
> a HPC workload where the system cores are also responsible for all IO
> and all the adaptive-nohz cores are simply crunching numbers. In that
> scenario you'll have a very high rcu usage because the system cores are
> all very busy arranging work for the computation cores.

Of course if we find a better way than having to restart this tick I'm
all for doing that way.

That said if it requires some significant changes this should be done
outside this patchset, as an optimization afterward may be, the patchset
is already big while still missing very important features for now that
the timer handles.

> > > On kernel exit we 'donate' all our rcu state to a willing victim (the
> > > same that earlier was kind enough to drive our state) and undo our
> > > entire GP accounting and re-enter rcu_nohz state.
> > 
> > That's already what does rcu_enter_nohz().
> 
> Almost but not quite, it doesn't donate the callbacks for example
> (something it does do on hotplug -- and therefore any assumption the
> callback will in fact run on the cpu you submit it on is already
> broken).

Good to know, so that would avoid to restart the tick on call_rcu() ?
Sounds good but again I think this should be done later.

> 
> > > If between that time we did restart the tick, we take back our rcu state
> > > and skip the donate and rcu_nohz enter on kernel exit.
> > 
> > That's also what is done in this patchset. 
> 
> Its not, since you don't hand of the grace period detectoring you don't
> take it back now do you..

So you are talking about grace period started locally due to local
callbacks enqueued, right?


> > As soon as we re-enter the kernel
> > or the tick had to be restarted before we re-enter the kernel,
> 
> Another impossibility, you can only restart the tick from the kernel.

Ok I meant it can be restarted from an interrupt interrupting userspace.
I was talking about kernel enter/exit considering the new hooks brought
(syscalls and exceptions).

> >  we call
> > rcu_exit_nohz() that pulls back the CPU to the whole RCU machinery.
> 
> But you then also start the tick again..

When we enter kernel? (minus interrupts)
No we only call rcu_exit_nohz().
