Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195Ab1D0W7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:59:55 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54661 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757052Ab1D0W7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:59:54 -0400
Date: Wed, 27 Apr 2011 15:59:49 -0700
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
Message-ID: <20110427225949.GB2135@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110426112756.GF4308@linux.vnet.ibm.com>
 <20110426183859.6ff6279b@neptune.home>
 <20110426190918.01660ccf@neptune.home>
 <BANLkTikjuqWP+PAsObJH4EAOyzgr2RbYNA@mail.gmail.com>
 <alpine.LFD.2.02.1104262314110.3323@ionos>
 <20110427081501.5ba28155@pluto.restena.lu>
 <20110427204139.1b0ea23b@neptune.home>
 <alpine.LFD.2.02.1104272351290.3323@ionos>
 <20110427222727.GU2135@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1104280028250.3323@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.02.1104280028250.3323@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 12:32:50AM +0200, Thomas Gleixner wrote:
> On Wed, 27 Apr 2011, Paul E. McKenney wrote:
> > On Thu, Apr 28, 2011 at 12:06:11AM +0200, Thomas Gleixner wrote:
> > > On Wed, 27 Apr 2011, Bruno Prémont wrote:
> > > > On Wed, 27 April 2011 Bruno Prémont wrote:
> > > > Voluntary context switches stay constant from the time on SLABs pile up.
> > > > (which makes sense as it doesn't run get CPU slices anymore)
> > > > 
> > > > > > Can you please enable CONFIG_SCHED_DEBUG and provide the output of
> > > > > > /proc/sched_stat when the problem surfaces and a minute after the
> > > > > > first snapshot?
> > > > 
> > > > hm, did you mean CONFIG_SCHEDSTAT or /proc/sched_debug?
> > > > 
> > > > I did use CONFIG_SCHED_DEBUG (and there is no /proc/sched_stat) so I took
> > > > /proc/sched_debug which exists... (attached, taken about 7min and +1min
> > > > after SLABs started piling up), though build processes were SIGSTOPped
> > > > during first minute.
> > > 
> > > Oops. /proc/sched_debug is the right thing.
> > > 
> > > > printk wrote (in case its timestamp is useful, more below):
> > > > [  518.480103] sched: RT throttling activated
> > > 
> > > Ok. Aside of the fact that the CPU time accounting is completely hosed
> > > this is pointing to the root cause of the problem.
> > > 
> > > kthread_rcu seems to run in circles for whatever reason and the RT
> > > throttler catches it. After that things go down the drain completely
> > > as it should get on the CPU again after that 50ms throttling break.
> > 
> > Ah.  This could happen if there was a huge number of callbacks, in
> > which case blimit would be set very large and kthread_rcu could then
> > go CPU-bound.  And this workload was generating large numbers of
> > callbacks due to filesystem operations, right?
> > 
> > So, perhaps I should kick kthread_rcu back to SCHED_NORMAL if blimit
> > has been set high.  Or have some throttling of my own.  I must confess
> > that throttling kthread_rcu for two hours seems a bit harsh.  ;-)
> 
> That's not the intended thing. See below.
> 
> > If this was just throttling kthread_rcu for a few hundred milliseconds,
> > or even for a second or two, things would be just fine.
> > 
> > Left to myself, I will put together a patch that puts callback processing
> > down to SCHED_NORMAL in the case where there are huge numbers of
> > callbacks to be processed.
> 
> Well that's going to paper over the problem at hand possibly. I really
> don't see why that thing would run for more than 950ms in a row even
> if there is a large number of callbacks pending.

True enough, it would probably take millions of callbacks to keep
rcu_do_batch() busy for 950 milliseconds.  Possible, but hopefully
unlikely.

Hmmm...  If this is happening, I should see it in the debug stuff that
Sedat sent me.  And the biggest change I see in a 15-second interval
is 50,000 RCU callbacks, which is large, but should not be problematic.
Even if they all showed up at once, I would hope that they could be
invoked within a few hundred milliseconds.

> And then I don't have an explanation for the hosed CPU accounting and
> why that thing does not get another 950ms RT time when the 50ms
> throttling break is over.

Would problems in the CPU accounting result in spurious throttles,
or are we talking different types of accounting here?

							Thanx, Paul
