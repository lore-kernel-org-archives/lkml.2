Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250Ab1EMMsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 08:48:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54310 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759234Ab1EMMsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 08:48:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bgdbjM7zY8obtzuC8c2L+Le9xepK+0tJu5CXhfro/+p7N0oJc5HShViG1lEtSIZS/v
         q7Hn9hMYjUOwKEhSAN7uqo1nWqTjoWaRCyoxrgOEBts33SgBzMOrQaBwFJ/MVWdmMZVE
         I5ajRfUjV1VZua1idAJavbNXtk0H5fjos5VqI=
Date: Fri, 13 May 2011 14:48:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] x86: Make the x86-64 stacktrace code safely
 callable from scheduler
Message-ID: <20110513124800.GA1840@nowhere>
References: <1305232326-9804-1-git-send-email-fweisbec@gmail.com>
 <1305232326-9804-3-git-send-email-fweisbec@gmail.com>
 <1305283706.22280.40.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305283706.22280.40.camel@frodo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 06:48:26AM -0400, Steven Rostedt wrote:
> On Thu, 2011-05-12 at 22:32 +0200, Frederic Weisbecker wrote:
> > Avoid potential scheduler recursion and deadlock from the
> > stacktrace code by avoiding rescheduling when we re-enable
> > preemption.
> 
> I'm curious to where you saw this deadlock? As I have the function stack
> tracer using preempt_disable_notrace and enable_notrace without any
> issues, and it traces all functions in the kernel[*]. I have no issue
> with using raw_local_irq_save/restore() if it is to protect the per_cpu
> variable from interrupt corruption, but I don't see the problem with
> recursion.
> 
> There's only one function I had to worry about with preempt disable, not
> the entire scheduler. That was the function preempt_schedule(). This
> function is called by preempt_enable() and that will cause an infinite
> loop if you have something in preempt_schedule() call preempt_enable().
> 
> Remember that ftrace_preempt_disable/enable() crap that I did to try to
> avoid the scheduler deadlock? I found it was complex and unnecessary
> because the scheduler itself was not an issue, it was only
> preempt_schedule(). I replaced all that crappy code with a single line
> that added notrace to preempt_schedule() and everything just worked.
> 
> Thus, if you disable interrupts to protect the cpu data, that's fine,
> and say so in the change log. I really like to know if you really saw
> this deadlock. Yes enabling preemption in the scheduler may recurse, but
> it will only do so once.
> 
> I still argue that interrupt enabling is slow. I've seen a large slow
> down of the code by switching stack tracer from preempt disable to irq
> disable. I used perf to see why, and it told me that disabling
> interrupts as fine, but enabling interrupts can cost you quite a bit.
> 
> -- Steve
> 
> [*] of course function tracing does not trace other notrace functions.
> 

I haven't observed any deadlock. trace events disable preemption and
other tracers do too (my changelog was buggy).

I just worried about potential other users, like a WARN_ON in the
scheduler or so.

My worry is the following scenario:

schedule() {
	acquire(rq)
							set_tsk_need_resched
	WARN_ON() {
		stack_trace() {
			preempt_enable() {
				preempt_schedule() {
					acquire(rq)
				}
			}
		}
	}
}

I don't know if it happens that one set TIF_NEED_RESCHED remotely,
or if TIF_NEED_RESCHED can be set when we hold the rq, and then we
can be followed by a WARN_ON, ...
So I preferred to be careful.
