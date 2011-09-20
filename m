Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab1ITDG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 23:06:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62088 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab1ITDG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 23:06:27 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=3kNrfhY1ZosA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=hVxxsxV-_eDwbjYb3yIA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <alpine.DEB.2.00.1109191644190.19059@router.home>
References: <20110919212040.745370781@goodmis.org>
	 <alpine.DEB.2.00.1109191644190.19059@router.home>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 19 Sep 2011 23:06:17 -0400
Message-ID: <1316487977.29966.32.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Mathieu as I've been discussing this with him on IRC ]

On Mon, 2011-09-19 at 16:49 -0500, Christoph Lameter wrote:
> On Mon, 19 Sep 2011, Steven Rostedt wrote:
> 
> > I just found out that the this_cpu_*() functions do not perform the
> > test to see if the usage is in atomic or not. Thus, the blind
> > conversion of the per_cpu(*, smp_processor_id()) and the get_cpu_var()
> > code to this_cpu_*() introduce the regression to detect the hard
> > to find case where a per cpu variable is used in preempt code that
> > migrates and causes bugs.
> 
> this_cpu_* function can be used either way. There is no point in checking
> for atomic or not since the this_cpu_* implementations are required to
> take care of disabling preemption. Those operations are generally safe to
> use regardless of the context.
> 
> It can be replaced by __this_cpu_* only when we know that the context
> prevents races through disabling preemption.


Seems that this_cpu_*() and friends have been added as some new semantic
for slub and friends. The problem came when there was some stupid
campaign to convert all of the per_cpu(x, smp_processor_id()) and
__get_cpu_var() to this because it changed the semantic of those places.

If I knew of this change, I would have NACK'd most of them.

The smp_processor_id() and __get_cpu_var() checked to make sure that
preemption was disabled, and warned you if it was not. Because 99% of
the kernel that uses per_cpu variables EXPECTS TO BE ON THE SAME CPU
DURING THE USE OF THAT VARIABLE! The get_cpu_var() disabled preemption
for put_cpu_var() to enable them. But __get_cpu_var() checked to make
sure preemption is disabled.

Seems that this silly campaign ignored that fact. Now we have loads of
locations just waiting to become buggy if preemption is enabled. I think
I already found one area where this was the case in the memcg code. Two
per_cpu variables are read and compared, but those two variables may end
up being from two different CPUs. Do we care about that?

It is really confusing to know which version to use. I'm confused by the
this_cpu_*() compared with __this_cpu_*(). I'm guessing that most places
should use __this_cpu*(). But really this_cpu() should be the default,
and the places that can have it outside of preemption should have
another name. Maybe use the raw_this_cpu() or safe_this_cpu(), as there
is an irqsafe_this_cpu(). Maybe make a preemptsafe_cpu_*(). There should
only be a very few locations that are OK to have preemption enabled when
calling the this_cpu() code. Lets have those have the funny names and
not be the default "this_cpu_*()".

All this_cpu*() code, except the funny named ones, should make sure
preemption is disabled, otherwise give a nasty warning. As that is
usually a bug if you are using a per cpu variable and can migrate away.
The next reference to that value may be incorrect.


Note, just adding the checks to the __this_cpu_read/write() code,
produced a few bug reports:

max_sane_readahead()
alloc_zeroed_user_highpage()
tsk_fork_get_node()

all the above is from numa_node_id() using the __this_cpu_read() outside
of preempt disabled.

Note, most people would assume that using this_cpu_read/write() is the
correct thing to use when we expect that preemption is disabled. But it
is nice to have a check to know when it is not disabled and we are
incorrectly using these variables (just like smp_processor_id())

My suggestion is to nuke the __this_cpu*() functions and have them
called this_cpu*(). And change the locations that allow for preemption
enabled to be called preemptsafe_cpu_*() just like the irqsafe_cpu*()
are used.

Thoughts?

-- Steve


