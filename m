Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1KOBb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 20:31:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45377 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab1KOBbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 20:31:25 -0500
X-Authority-Analysis: v=2.0 cv=KcRQQHkD c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=Jr9ma08oM-4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=Hac048-KxPdvXAl8jKEA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: Oops while doing "echo function_graph > current_tracer"
From: Steven Rostedt <rostedt@goodmis.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20111114140745.GC3225@redhat.com>
References: <20111114140745.GC3225@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 20:31:22 -0500
Message-ID: <1321320682.5011.23.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-14 at 16:07 +0200, Gleb Natapov wrote:
> Hi Steven,
> 
> I get an oops with current linux.git when I am doing
> "echo function_graph > current_tracer" inside a kvm guest.
> Oopses do not contain much useful information and they are always
> different. Looks like stack corruption (at least this is what Oopses
> say when not triple faulting).
> 
> Attached is my guest kernel .config. I do not have the same problem on
> the host, but kernel config is different there.


Looking into this I see that this is an old bug. I guess this shows how
many people run function graph tracing from the guest. Or at least how
many with DEBUG_PREEMPT enabled too.

The problem is that kvm_clock_read() does a get_cpu_var(), which calls
preempt_disable() which calls add_preempt_count() which is then traced.
But this is outside the recursive protection in function_graph tracing,
and when add_preempt_count() is traced, kvm_clock_read() calls
add_preempt_count() and it gets traced again, and so on and causes a
recursive crash.

There's a few fixes we can do. For now, because this is an old bug, I
would just tell you to do this first:

echo add_preempt_count sub_preempt_count > /sys/kernel/debug/tracing/set_ftrace_notrace

But that is just a work around for you and not a complete fix.

I could just make add_preempt_count() notrace and be done with it, but
I've been reluctant to do this because there's been several times I've
actually wanted to see the add_preempt_count()s being traced.

I could also make a get_cpu_var_notrace() version that kvm_clock_read()
could use. This is the solution that I would most likely want to do as a
permanent one.

Then finally I could force the function_graph tracer to have recursion
protection and when it recurses, it just exits out nicely. I think I'll
add that with a WARN_ON_ONCE(). Without the warning, if a recursion
slips in, we'll have overhead of the recursion on top of the overhead of
the tracing making it worse than what it already is. Function graph
tracing is the most invasive tracer, and I want to speed it up if
possible (I already have ideas on doing so) and I do not want to make it
slower.

Thanks!

-- Steve


