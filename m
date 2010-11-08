Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab0KHOKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 09:10:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53191 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab0KHOKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 09:10:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F87SYw2IBJf8JSqNMC1o6w8R3Epr0zWNoGraJlX8mz/hwOcyRxGEoKLDF1aAR3cbT1
         44YgjDR+UvS+typG9lnAJcQvf407j3kQmZymmol1gFBbdErzjbs8rP5lJiPu8OnIcu7j
         MofdDIvP4uaeeB7EWXW1BHqZtNcnryuupqheQ=
Date: Mon, 8 Nov 2010 15:10:40 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: dyntick-hpc and RCU
Message-ID: <20101108141035.GA5466@nowhere>
References: <20101104232148.GA28037@linux.vnet.ibm.com> <20101105052740.GB6698@nowhere> <20101105150435.GA2850@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101105150435.GA2850@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 08:04:36AM -0700, Paul E. McKenney wrote:
> On Fri, Nov 05, 2010 at 06:27:46AM +0100, Frederic Weisbecker wrote:
> > Yet another solution is to require users of bh and sched rcu flavours to
> > call a specific rcu_read_lock_sched()/bh, or something similar, that would
> > be only implemented in this new rcu config. We would only need to touch the
> > existing users and the future ones instead of adding an explicit call
> > to every implicit paths.
> 
> This approach would be a much nicer solution, and I do wish I had required
> this to start with.  Unfortunately, at that time, there was no preemptible
> RCU, CONFIG_PREEMPT, nor any RCU-bh, so there was no way to enforce this.
> Besides which, I was thinking in terms of maybe 100 occurrences of the RCU
> API in the kernel.  ;-)



Ok, I'll continue the discussion about this specific point in the
non-timer based rcu patch thread.



 
> > > 4.	Substitute an RCU implementation based on one of the
> > > 	user-level RCU implementations.  This has roughly the same
> > > 	advantages and disadvantages as does #3 above.
> > > 
> > > 5.	Don't tell RCU about dyntick-hpc mode, but instead make RCU
> > > 	push processing through via some processor that is kept out
> > > 	of dyntick-hpc mode.
> > 
> > I don't understand what you mean.
> > Do you mean that dyntick-hpc cpu would enqueue rcu callbacks to
> > another CPU? But how does that protect rcu critical sections
> > in our dyntick-hpc CPU?
> 
> There is a large range of possible solutions, but any solution will need
> to check for RCU read-side critical sections on the dyntick-hpc CPU.  I
> was thinking in terms of IPIing the dyntick-hpc CPUs, but very infrequently,
> say once per second.



Everytime we want to notify a quiescent state, right?
But I fear that forcing an IPI, even only once per second, breaks our
initial requirement.



> > >       This requires that the rcutree RCU
> > > 	priority boosting be pushed further along so that RCU grace period
> > > 	and callback processing is done in kthread context, permitting
> > > 	remote forcing of grace periods.
> > 
> > 
> > 
> > I should have a look at the rcu priority boosting to understand what you
> > mean here.
> 
> The only thing that you really need to know about it is that I will be
> moving the current softirq processing to kthread context.  The key point
> here is that we can wake up a kthread on some other CPU.


Ok.



> > >       The RCU_JIFFIES_TILL_FORCE_QS
> > > 	macro is promoted to a config variable, retaining its value
> > > 	of 3 in absence of dyntick-hpc, but getting value of HZ
> > > 	(or thereabouts) for dyntick-hpc builds.  In dyntick-hpc
> > > 	builds, force_quiescent_state() would push grace periods
> > > 	for CPUs lacking a scheduling-clock interrupt.
> > > 
> > > 	+	Relatively small changes to RCU, some of which is
> > > 		coming with RCU priority boosting anyway.
> > > 
> > > 	+	No need to inform RCU of user/kernel transitions.
> > > 
> > > 	+	No need to turn scheduling-clock interrupts on
> > > 		at each user/kernel transition.
> > > 
> > > 	-	Some IPIs to dyntick-hpc CPUs remain, but these
> > > 		are down in the every-second-or-so frequency,
> > > 		so hopefully are not a real problem.
> > 
> > 
> > Hmm, I hope we could avoid that, ideally the task in userspace shouldn't be
> > interrupted at all.
> 
> Yep.  But if we do need to interrupt it, let's do it as infrequently as
> we can!



If we have no other solution yeah, but I'm not sure that's a right way
to go.



> > I wonder if we shouldn't go back to #3 eventually.
> 
> And there are variants of #3 that permit preemption of RCU read-side
> critical sections.


Ok.



> > At that time yeah.
> > 
> > But now I don't know, I really need to dig deeper into it and really
> > understand how #5 works before picking that orientation :)
> 
> This is probably true for all of us for all of the options.  ;-)


Hehe ;-)

