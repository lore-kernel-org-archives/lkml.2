Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab1GKSVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:21:39 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49653 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab1GKSVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:21:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=ri1Eqs6ANNd2k4MUvV8hhZ2XNIglV+qacGsoJcVkkvq+HicPYYOt5+2IXEPhRmtEf
	YlNGx9CrgyNuQ5iol60Nw==
MIME-Version: 1.0
In-Reply-To: <20110711155404.GB4109@somewhere.redhat.com>
References: <1306877298-31713-1-git-send-email-vnagarnaik@google.com>
 <1308681903-12840-1-git-send-email-vnagarnaik@google.com> <20110707233453.GE21115@somewhere>
 <CAJL_eku7ezDhSOaOxN4ACFas1rnX=uaV184ZK3-0fE60Rmwh8g@mail.gmail.com> <20110711155404.GB4109@somewhere.redhat.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Mon, 11 Jul 2011 11:21:04 -0700
Message-ID: <CAL26m8+ca64BDrQUohxcZfUpZQgn7bNkup=Q92LaTmpvorm9fQ@mail.gmail.com>
Subject: Re: [PATCH v3] trace: Add x86 irq vector entry/exit tracepoints
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Sharp <dhsharp@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Jiaying Zhang <jiayingz@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 8:54 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Let me clarify what I proposed, we have that:
>
>        irq_enter() // trace_irq_enter();
>
>        trace_irq_vector_entry(foo);
>
>        // handle irq...
>
>        irq_exit() // trace_irq_exit()
>
> So either you're only interested in tracing raw irqs and you don't care
> about the nature of these and you only enable trace_irq_enter() and
> trace_irq_exit(). Or you're interested in the nature of these and you
> only enable trace_irq_vector_entry() and trace_irq_exit().
>
> In fact we could even drop the trace_irq_enter() thing because I'm
> not sure it's interesting.
>
> All in one it doesn't bring more overhead.
>
> What I'm more worried about actually is that in the case of trace_irq_handler_entry()
> and trace_irq_handler_exit(), it becomes a useless tracepoint. And if you enable it
> for other irq tracepoint symetric purposes, you'll have it there too and that's a bit
> odd.
>
> So perhaps we want to keep your way of doing this.
>

We proposed this patch as a way of tracing raw interrupts from the
platform, which is why it traces all the raw interrupts and does not use
any specific interrupt data in the events. So when someone wants to know
just the interrupts that are being triggered in the system, this
tracepoint can be used.

There can be more involved and detailed tracepoints for individual IRQs,
as you proposed to have trace_ipi_function(), etc.

> On Thu, Jul 07, 2011 at 05:54:02PM -0700, David Sharp wrote:
>> Here's our motivation: We use interrupt events, along with traps,
>> syscall, and sched_switch events to know when kernel code is running
>> instead of user code. So, being clear that we got all interrupts (and
>> which interrupt) is important.
>
> Ok I see your point then.
>
> But then have a generic single trace_irq_timer() (may be cut down in entry/exit if
> you want).
>
> But I don't think we really want to  into HRTIMER, PERIODIC, ONESHOT, BROADCAST
> vectors. That's sounds like the wrong place to provide these details.
>
> If we want higher level details, then we can enable hrtimer tracepoints, and/or we add some
> tracepoints in the timer subsystem to know with what we are dealing with.
>
> Does that make sense?
>

I added the details about the timer handler because it would be
difficult to understand exactly which generic event handlers the
platform LOCAL_TIMER_IRQ_VECTOR led to.

Once again, this is meant as a raw interrupt tracepoint which provides 2
things: an interrupt occurred and the nature of interrupt. As you
mentioned there are high level hrtimer tracepoints and there can be
similar highly detailed tracepoints for each IRQ as required with more
data about the interrupt, but I believe this is the wrong patch to put
them in.


Vaibhav Nagarnaik
