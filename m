Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab1F3Qqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 12:46:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42685 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab1F3Qqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 12:46:30 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=EAdfuy46jrwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=wOPrychqn_hb7_mOn8AA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH] kprobes: Add separate preempt_disabling for
 kprobes
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110630161439.GA8508@somewhere>
References: <1309440213.26417.76.camel@gandalf.stny.rr.com>
	 <1309449117.26417.90.camel@gandalf.stny.rr.com>
	 <20110630161439.GA8508@somewhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 30 Jun 2011 12:46:27 -0400
Message-ID: <1309452387.26417.111.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 18:14 +0200, Frederic Weisbecker wrote:


> That's a bit sad we need to bloat preempt_schedule() with a new test, especially
> as kprobes should not add overhead in the off case and then I guess many distros
> enable kprobes by default, so it's probably not just enabled on some debug kernel.

A simple per_cpu var test is not that bad, and that's also why I put it
where I did. It only gets checked after all the other locations fail. I
doubt this really adds any measurable overhead. Note, most distro's
don't even enable CONFIG_PREEMPT so this isn't even touched by them.

> 
> Another idea could be to turn current_thread_info()->preempt_count into a local_t
> var which ensures a single incrementation is performed in a single instruction.

Not all archs support such a thing.

> 
> Well, in the hope that every arch can do something like:
> 
> inc (mem_addr)
> 
> IIRC, I believe arm can't... And the default local_inc is probably not helpful
> in our case...

Some archs (I believe) perform local_inc() slower than i++. In which
case, this solution will more likely slow things down even more than
what I proposed. As the impact will be on every preempt_disable and
enable.

And this would not even help for the place that I actually hit the crash
on. Which was in the scheduler. It wasn't the addition of the
preempt_count that caused my crash, it was just reading it.

	if (unlikely(in_atomic_preempt_off() && !prev->exit_state))
		__schedule_bug(prev);

The in_atomic_preempt_off() is what blew up on me.

#define in_atomic_preempt_off() \
		((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_CHECK_OFFSET)

What happened was that the reading of preempt_count was single stepped.
And that had preempt_count set to one more due to the preempt_disable()
in kprobes. Even if preempt_count was a local_t, this bug would have
still triggered, and my system would have crashed anyway. (every
schedule caused a printk to happen).


-- Steve


