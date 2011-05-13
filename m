Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab1EMKse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 06:48:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53353 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab1EMKsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 06:48:33 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=gsWbSYZL9csA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=IlRtrzvXJsBKLpsI-xMA:9 a=QEXdDO2ut3YA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] x86: Make the x86-64 stacktrace code safely
 callable from scheduler
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1305232326-9804-3-git-send-email-fweisbec@gmail.com>
References: <1305232326-9804-1-git-send-email-fweisbec@gmail.com>
	 <1305232326-9804-3-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 06:48:26 -0400
Message-ID: <1305283706.22280.40.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 22:32 +0200, Frederic Weisbecker wrote:
> Avoid potential scheduler recursion and deadlock from the
> stacktrace code by avoiding rescheduling when we re-enable
> preemption.

I'm curious to where you saw this deadlock? As I have the function stack
tracer using preempt_disable_notrace and enable_notrace without any
issues, and it traces all functions in the kernel[*]. I have no issue
with using raw_local_irq_save/restore() if it is to protect the per_cpu
variable from interrupt corruption, but I don't see the problem with
recursion.

There's only one function I had to worry about with preempt disable, not
the entire scheduler. That was the function preempt_schedule(). This
function is called by preempt_enable() and that will cause an infinite
loop if you have something in preempt_schedule() call preempt_enable().

Remember that ftrace_preempt_disable/enable() crap that I did to try to
avoid the scheduler deadlock? I found it was complex and unnecessary
because the scheduler itself was not an issue, it was only
preempt_schedule(). I replaced all that crappy code with a single line
that added notrace to preempt_schedule() and everything just worked.

Thus, if you disable interrupts to protect the cpu data, that's fine,
and say so in the change log. I really like to know if you really saw
this deadlock. Yes enabling preemption in the scheduler may recurse, but
it will only do so once.

I still argue that interrupt enabling is slow. I've seen a large slow
down of the code by switching stack tracer from preempt disable to irq
disable. I used perf to see why, and it told me that disabling
interrupts as fine, but enabling interrupts can cost you quite a bit.

-- Steve

[*] of course function tracing does not trace other notrace functions.

