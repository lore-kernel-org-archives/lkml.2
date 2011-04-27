Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab1D0W1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:27:34 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48635 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490Ab1D0W1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:27:33 -0400
Date: Wed, 27 Apr 2011 15:27:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning,
 regression?
Message-ID: <20110427222727.GU2135@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110425214933.GO2468@linux.vnet.ibm.com>
 <20110426081904.0d2b1494@pluto.restena.lu>
 <20110426112756.GF4308@linux.vnet.ibm.com>
 <20110426183859.6ff6279b@neptune.home>
 <20110426190918.01660ccf@neptune.home>
 <BANLkTikjuqWP+PAsObJH4EAOyzgr2RbYNA@mail.gmail.com>
 <alpine.LFD.2.02.1104262314110.3323@ionos>
 <20110427081501.5ba28155@pluto.restena.lu>
 <20110427204139.1b0ea23b@neptune.home>
 <alpine.LFD.2.02.1104272351290.3323@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.02.1104272351290.3323@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 12:06:11AM +0200, Thomas Gleixner wrote:
> On Wed, 27 Apr 2011, Bruno Prémont wrote:
> > On Wed, 27 April 2011 Bruno Prémont wrote:
> > Voluntary context switches stay constant from the time on SLABs pile up.
> > (which makes sense as it doesn't run get CPU slices anymore)
> > 
> > > > Can you please enable CONFIG_SCHED_DEBUG and provide the output of
> > > > /proc/sched_stat when the problem surfaces and a minute after the
> > > > first snapshot?
> > 
> > hm, did you mean CONFIG_SCHEDSTAT or /proc/sched_debug?
> > 
> > I did use CONFIG_SCHED_DEBUG (and there is no /proc/sched_stat) so I took
> > /proc/sched_debug which exists... (attached, taken about 7min and +1min
> > after SLABs started piling up), though build processes were SIGSTOPped
> > during first minute.
> 
> Oops. /proc/sched_debug is the right thing.
> 
> > printk wrote (in case its timestamp is useful, more below):
> > [  518.480103] sched: RT throttling activated
> 
> Ok. Aside of the fact that the CPU time accounting is completely hosed
> this is pointing to the root cause of the problem.
> 
> kthread_rcu seems to run in circles for whatever reason and the RT
> throttler catches it. After that things go down the drain completely
> as it should get on the CPU again after that 50ms throttling break.

Ah.  This could happen if there was a huge number of callbacks, in
which case blimit would be set very large and kthread_rcu could then
go CPU-bound.  And this workload was generating large numbers of
callbacks due to filesystem operations, right?

So, perhaps I should kick kthread_rcu back to SCHED_NORMAL if blimit
has been set high.  Or have some throttling of my own.  I must confess
that throttling kthread_rcu for two hours seems a bit harsh.  ;-)

If this was just throttling kthread_rcu for a few hundred milliseconds,
or even for a second or two, things would be just fine.

Left to myself, I will put together a patch that puts callback processing
down to SCHED_NORMAL in the case where there are huge numbers of
callbacks to be processed.

> Though we should not ignore the fact, that the RT throttler hit, but
> none of the RT tasks actually accumulated runtime.
> 
> So there is a couple of questions:
> 
>    - Why does the scheduler detect the 950 ms RT runtime, but does
>      not accumulate that runtime to any thread
> 
>    - Why is the runtime accounting totally hosed
> 
>    - Why does that not happen (at least not reproducible) with 
>      TREE_RCU

This one I can answer -- In Linus's tree, TREE_RCU still uses softirq,
so there is no RCU kthread, so there is nothing to throttle other
than ksoftirqd itself.

							Thanx, Paul

> I need some sleep now, but I will try to come up with sensible
> debugging tomorrow unless Paul or someone else beats me to it.
> 
> Thanks,
> 
> 	tglx

