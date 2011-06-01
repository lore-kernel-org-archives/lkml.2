Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab1FAXas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 19:30:48 -0400
Received: from smtp-out.google.com ([74.125.121.67]:42299 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758501Ab1FAXaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 19:30:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=gxeEZ17kbn13yFHj8UAPw52K2ZeY1nRfaIefbPA9z5+ewS5KbgtMhx8NPyTBqURfYM
         UoFezdIM/jzMcoiTO7ww==
MIME-Version: 1.0
In-Reply-To: <BANLkTi=YYCXHi5k82Q+sE6+134i97pjjAA@mail.gmail.com>
References: <1304107962-18576-1-git-send-email-vnagarnaik@google.com>
 <1306877298-31713-1-git-send-email-vnagarnaik@google.com> <20110531235957.GB5256@somewhere.redhat.com>
 <BANLkTi=YYCXHi5k82Q+sE6+134i97pjjAA@mail.gmail.com>
From: David Sharp <dhsharp@google.com>
Date: Wed, 1 Jun 2011 16:30:18 -0700
Message-ID: <BANLkTinT6ULRWwHAGYFpQSw-ptQiuzrkPtZuKVZHD8b5mh9hpA@mail.gmail.com>
Subject: Re: [PATCH v2] trace: Add x86 irq vector entry/exit tracepoints
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiaying Zhang <jiayingz@google.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 3:38 PM, Vaibhav Nagarnaik <vnagarnaik@google.com> wrote:
> On Tue, May 31, 2011 at 5:00 PM, Frederic Weisbecker
> <fweisbec@gmail.com> wrote:
>>
>> IIRC, Thomas suggested in the v1 to turn arch tracepoints into core ones when they
>> stand for generic (ie: shared by all archs) event meaning.
>>
>> I don't know where the discussion went after that, but that still seems to
>> me an important direction. Tracing irqs by their vector number should be reserved
>> for pure arch meanings. Sharing common tracepoints for generic events amongst archs makes life
>> easier for tools. Bonus when the tracepoint can be placed in the generic code.
>>
>
> I agree with you that the tracepoints should be as generic as possible
> to have them traced across platforms, but I see these tracepoints as
> specific to x86 platform. Since most of these vectors are x86 specific.
> The only ones that you pointed out as generic were:

I think what Vaibhav means is that this is "the one trace event for
all hard IRQs on the platform". A tracepoint for the cross-platform
irq handlers is also useful, but that is not the purpose of this
tracepoint. There's not actually much overlap between platforms for
IRQs, so each platform needs to do the work of covering all their
IRQs, and won't see much benefit from the generic tracepoints.

On Tue, May 31, 2011 at 5:00 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Tracing irqs by their vector number should be reserved for pure arch meanings.

exactly, and this tracepoint is for that "arch meaning".

I'd also add that having these tracepoints here makes it more obvious
that we will get all IRQ events, which is what is important to us.

>
> LOCAL_TIMER_VECTOR - The generic callbacks that I found are in:
> kernel/time/tick-broadcast.c (tick_handle_periodic(),
> tick_handle_periodic_broadcast(), tick_handle_oneshot_broadcast()).
>
> RESCHEDULE_VECTOR - The callback is in kernel/sched.c (scheduler_ipi())
>
> CALL_FUNCTION_VECTOR - The callback is in kernel/smp.c
> (generic_smp_call_function_interrupt())
> CALL_FUNCTION_SINGLE_VECTOR - The callback is in kernel/smp.c
> (generic_smp_call_function_single_interrupt())
>
> IRQ_WORK_VECTOR - kernel/irq_work.c (irq_work_run())
>
> REBOOT_VECTOR - For x86, this does not enter any generic code. It is
> also not traced. The definition was in there only as part of the
> interrupt table.
>
> So, as I see it, there are only 5 vectors that enter the generic
> handling code of the kernel. The other vectors have platform specific
> handlers or are just x86 specific IRQs.
>
> This is the reason that I added the irq_vectors tracing class under the
> arch-specific code. If other platforms want to use the same event class,
> it can be initialized in their platform specific code for their use with
> the appropriate tracepoints added.
>
>
> Vaibhav Nagarnaik
>
