Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab1ITOBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:01:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33732 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab1ITOBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:01:42 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=6qbAnu_Q0HoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=P6AM5y5nkYuoI9OYo8QA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 2/5] mm: Switch mod_state() to __this_cpu_read()
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Lameter <cl@gentwo.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <htejun@gmail.com>
In-Reply-To: <alpine.LFD.2.02.1109201334590.2723@ionos>
References: <20110919212040.745370781@goodmis.org>
	 <20110919212640.688732950@goodmis.org>
	 <alpine.DEB.2.00.1109191657150.19059@router.home>
	 <alpine.LFD.2.02.1109201334590.2723@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 20 Sep 2011 10:01:38 -0400
Message-ID: <1316527298.29966.49.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 15:49 +0200, Thomas Gleixner wrote:

> The best thing is to remove the this_cpu_* hackery alltogether and
> just keep the __this_cpu_* versions (along with proper debugging) and
> git rid of the silly underscores.

I think renaming all the __this_cpu_*() to this_cpu_*() and then
removing all the current this_cpu_*() usages is the best thing.

That is, make it mandatory that all this_cpu_*() users are with preempt
disabled.

> 
> > I think it would make more sence if __this_cpu_read() could be made to
> > trigger a warning if used in context where preemption could be off.
> 
> It should have had such a warning in the first place and the warning
> needs to yell about preemptible (i.e. unprotected) context and not the
> other way round.
> 
> But instead of just slapping smp_processor_id() checks into those
> functions we should add a more sensible debug interface like:
> 
>   debug_check_percpu_access()

Sure, I'd do something like that in the this_cpu_*() code. But since
smp_processor_id() already had the bug triggering. I just did the easy
approach as more of a proof of concept (hence the RFC in the patch set).


> 
> and the per cpu sections which require protection over a series (1
> .. N) of this_cpu_* operations want to have
> 
>   this_cpu_start()
>   this_cpu_end()
> 
> or similar annotations around them.

I agree about the concept but hate the naming.

On IRC, Peter suggested a local_lock_t type. Give a named protection
area. I like this approach as we can add debugging infrastructure to
this concept.

	local_lock_t my_vars;

	local_lock(my_vars);
	var = this_cpu_read();
	/* play with var */
	local_unlock(my_vars);

Peter even suggested for those locations that disable interrupts for
this work we could document that with:

	local_lock_irqsave(my_vars, flags);
	[...]
	local_unlock_irqrestore(my_vars, flags);

This documents nicely the area of the protected variables. The
local_lock() could simply turn into a preempt_disable(), but we could
add hooks into lockdep or something to perform other checks. Even have
sparse or coccinelle find usages of var outside of local_lock(), and
report them.

As the kernel gets more complex, especially with the focus on scaling to
huge number of CPUs, and moving towards per_cpu data handling, having
debugging capabilities of this sort is critical.

> 
> This allows us to do proper analysis of this_cpu usage and makes the
> code understandable.

Totally agree!

-- Steve


