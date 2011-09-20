Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab1ITQbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:31:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46386 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1ITQbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:31:04 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=3kNrfhY1ZosA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=33N18mNCqiDixhp1MZwA:9 a=bhA8-SPaEazmHcfuLMMA:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <alpine.DEB.2.00.1109201108080.8056@router.home>
References: <20110919212040.745370781@goodmis.org>
	 <alpine.DEB.2.00.1109191644190.19059@router.home>
	 <1316487977.29966.32.camel@gandalf.stny.rr.com>
	 <27409.1316522696@turing-police.cc.vt.edu>
	 <alpine.DEB.2.00.1109200955190.8056@router.home>
	 <1316531987.29966.65.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1109201108080.8056@router.home>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 20 Sep 2011 12:31:00 -0400
Message-ID: <1316536260.29966.93.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 11:08 -0500, Christoph Lameter wrote:
> On Tue, 20 Sep 2011, Steven Rostedt wrote:
> 
> > On Tue, 2011-09-20 at 09:57 -0500, Christoph Lameter wrote:
> >
> > > this_cpu_xx functions are made for those locations that have
> > > preemption enabled. If you can use those function (classic case is a
> > > per cpu counter increment in the network subsystem) then you can avoid
> > > preempt disable/enable or get_cpu/put_cpu.
> >
> > If the variables are used for a very short time, then the latencies
> > introduced by a simple:
> >
> > 	var = get_cpu_var(my_var);
> > 	if (var)
> > 		do_something_quick();
> > 	put_cpu_var(my_var);
> >
> > Otherwise if that do_something_quick(); migrates, it may be doing
> > something it shouldn't be doing!
> 
> That is obviously a use case in which this_cpu_xx ops could not be used
> since we must stay on the same cpu. I think there is still a lot of
> confusion on your part. The example here shows it.

No, the problem is that you do not understand what I'm saying.

You are saying that you have other tricks to use per cpu data even
though that task that uses it can migrate to other cpus.

But the issue I have with this, is that this_cpu() is all about tricks.
The normal use case of per_cpu data is to disable preemption, use the
local variable and then enable preemption. That's the normal case and
should be what this_cpu_*() should be the default for.

But instead, you say this_cpu() is for data that doesn't care what CPU
it is at the time. It's really just as snapshot of the data. Which to me
seems to be a special use case that should not be the default. It is
confusing and hard to understand. Basically, you want __this_cpu_*() as
the normal case, which is ass backwards.

If your page allocator has special per_cpu tricks, then change the API
of it to something completely different to what the rest of the kernel
uses. Basic English shows to me that when I use "this_cpu_*()" I'm
getting a variable that is for the current CPU that the task is on, and
I should stay on that CPU. If you want something that is tricky, add
that to the name. Don't make everyone use this confusing "__this_cpu*()"
code which seems to be inconsistent in your own code too.

Have the "snapshot" version. This documents very nicely that the
variable that you read or modify is simply a one shot deal and not to
use it later. Don't use a common term like "this_cpu" and expect
everyone to understand that it should only be used for per cpu tricks.

I personally believe that we shouldn't even have a modification version
of the snapshot code. But perhaps it is fine for inc and dec and
cmpxchg. Put "snapshot" in the name to document that this is a hack to
make things work, and let all other users in the kernel use a name that
is not confusing.

-- Steve





