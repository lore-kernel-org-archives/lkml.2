Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab0KJPyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:54:36 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59678 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437Ab0KJPye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:54:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j72vB5pEMvaVY/BjtylV39J7yAHHbQSEQLx4Q5B1TMmEdUxCOoOhph8wZEwJjZ4EZe
         sbLnmS3EWDXugDRu5+x8R1A7tzTCyK2V8yFWgszkmlCpeEXgSUdN8Wua5EZ4zAVf9eh6
         dDIhWo1wtwE1EXL+NTbRIzSZra7fZXvO8HNdg=
Date: Wed, 10 Nov 2010 16:54:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Joe Korty <joe.korty@ccur.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, houston.jim@comcast.net
Subject: Re: [PATCH] a local-timer-free version of RCU
Message-ID: <20101110155419.GC5750@nowhere>
References: <20101104232148.GA28037@linux.vnet.ibm.com> <20101105210059.GA27317@tsunami.ccur.com> <4CD912E9.1080907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD912E9.1080907@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 05:22:49PM +0800, Lai Jiangshan wrote:
> It is hardly acceptable when there are memory barriers or
> atomic operations in the fast paths of rcu_read_lock(),
> rcu_read_unlock().
> 
> We need some thing to drive the completion of GP
> (and the callbacks process). There is no free lunch,
> if the completion of GP is driven by rcu_read_unlock(),
> we very probably need memory barriers or atomic operations
> in the fast paths of rcu_read_lock(), rcu_read_unlock().
> 
> We need look for some periodic/continuous events of
> the kernel for GP-driven, schedule-tick and schedule() are
> most ideal events sources in the kernel I think.
> 
> schedule-tick and schedule() are not happened when NO_HZ
> and dyntick-hpc, so we need some approaches to fix it. I vote up
> for the #5 approach of Paul's.
> 
> Also, I propose an unmature idea here.
> 
> 	Don't tell RCU about dyntick-hpc mode, but instead
> 	stop the RCU function of a CPU when the first time RCU disturbs
> 	dyntick-hpc mode or NO_HZ mode.
> 
> 	rcu_read_lock()
> 		if the RCU function of this CPU is not started, start it and
> 		start a RCU timer.
> 		handle rcu_read_lock()
> 
> 	enter NO_HZ
> 		if interrupts are just happened very frequently, do nothing, else:
> 		stop the rcu function and the rcu timer of the current CPU.
> 
> 	exit interrupt:
> 		if this interrupt is just caused by RCU timer && it just disrurbs
> 		dyntick-hpc mode or NO_HZ mode(and will reenter these modes),
> 		stop the rcu function and stop the rcu timer of the current CPU.
> 
> 	schedule-tick:
> 		requeue the rcu timer before it causes an unneeded interrupt.
> 		handle rcu things.
> 
> 	+	Not big changes to RCU, use the same code to handle
> 		dyntick-hpc mode or NO_HZ mode, reuse some code of rcu_offline_cpu()
> 
> 	+	No need to inform RCU of user/kernel transitions.
> 
> 	+	No need to turn scheduling-clock interrupts on
> 		at each user/kernel transition.
> 
> 	-	carefully handle some critical region which also implies
> 		rcu critical region.
> 
> 	-	Introduce some unneeded interrupt, but it is very infrequency.



I like this idea.

I would just merge the concept of "rcu timer" into the sched tick,
as per Peter Zijlstra idea:

In this CPU isolation mode, we are going to do a kind of adapative
sched tick already: run the sched tick and if there was nothing to do
for some time and we are in userspace, deactivate it. If suddenly
a new task arrives on the CPU (which means there is now more than
one task running and we want preemption tick back), or if we have
timers enqueued, or so, reactivate it.

So I would simply merge your rcu idea into this, + the reactivation
on rcu_read_lock().

Someone see a bad thing in this idea?

