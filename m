Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab2LKODC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 09:03:02 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23368 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab2LKODA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:03:00 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=DhgVYC8l6PEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=PwOMEcHXvqEA:10 a=hJ3tXogHtnBvSq9QUNMA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355234577.17101.288.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH RT 3/4] sched/rt: Use IPI to trigger RT task push
 migration instead of pulling
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: frank.rowand@am.sony.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Tue, 11 Dec 2012 09:02:57 -0500
In-Reply-To: <alpine.LFD.2.02.1212111326310.3028@ionos>
References: <20121207235615.206108556@goodmis.org>
	  <20121208000900.613917378@goodmis.org> <50C682F6.5030709@am.sony.com>
	  <50C68922.5030203@am.sony.com>
	 <1355190830.17101.280.camel@gandalf.local.home>
	 <alpine.LFD.2.02.1212111326310.3028@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-11 at 13:43 +0100, Thomas Gleixner wrote:
> On Mon, 10 Dec 2012, Steven Rostedt wrote:
> > On Mon, 2012-12-10 at 17:15 -0800, Frank Rowand wrote:
> > 
> > > I should have also mentioned some previous experience using IPIs to
> > > avoid runq lock contention on wake up.  Someone encountered IPI
> > > storms when using the TTWU_QUEUE feature, thus it defaults to off
> > > for CONFIG_PREEMPT_RT_FULL:
> > > 
> > >   #ifndef CONFIG_PREEMPT_RT_FULL
> > >   /*
> > >    * Queue remote wakeups on the target CPU and process them
> > >    * using the scheduler IPI. Reduces rq->lock contention/bounces.
> > >    */
> > >   SCHED_FEAT(TTWU_QUEUE, true)
> > >   #else
> > >   SCHED_FEAT(TTWU_QUEUE, false)
> > > 
> > 
> > Interesting, but I'm wondering if this also does it for every wakeup? If
> > you have 1000 tasks waking up on another CPU, this could potentially
> > send out 1000 IPIs. The number of IPIs here looks to be # of tasks
> > waking up, and perhaps more than that, as there could be multiple
> > instances that try to wake up the same task.
> 
> Not using the TTWU_QUEUE feature limits the IPIs to a single one,
> which is only sent if the newly woken task preempts the current task
> on the remote cpu and the NEED_RESCHED flag was not yet set.
>  
> With TTWU_QUEUE you can induce massive latencies just by starting
> hackbench. You get a herd wakeup on CPU0 which then enqueues hundreds
> of tasks to the remote pull list and sends IPIs. The remote CPUs pulls
> the tasks and activate them on their runqueue in hard interrupt
> context. That easiliy can accumulate to hundreds of microseconds when
> you do a mass push of newly woken tasks.
> 
> Of course it avoids fiddling with the remote rq lock, but it becomes
> massivly non deterministic.

Agreed. I never suggested to use TTWU_QUEUE. I was just stating the
difference between that and my patches.

> 
> > Now this patch set, the # of IPIs is limited to the # of CPUs. If you
> > have 4 CPUs, you'll get a storm of 3 IPIs. That's a big difference.
> 
> Yeah, the big difference is that you offload the double lock to the
> IPI. So in the worst case you interrupt the most latency sensitive
> task running on the remote CPU. Not sure if I really like that
> "feature".
>  

First, the pulled CPU isn't necessarily running the most latency
sensitive task. It just happens to be running more than one RT task, and
the waiting RT task can migrate. The running task may be of the same
priority as the waiting task. And they both may be the lowest priority
RT tasks in the system, and a CPU just went idle.

Currently, what we have is a huge contention on both the pulled CPU rq
lock. We've measured over 500us latencies due to it. This hurts even the
CPU that has the overloaded task, as the contention is on its lock.

-- Steve


