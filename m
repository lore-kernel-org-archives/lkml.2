Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab1FAWi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:38:58 -0400
Received: from smtp-out.google.com ([74.125.121.67]:30696 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758928Ab1FAWi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=ULLN/88JD7kI2Mf1xHjcw4v8sXREKfxw2rdJUxv/uR6qckXKt/NVeI/msvCUYoEvJB
         j17f5FF8ZjxsWRfE9k6A==
MIME-Version: 1.0
In-Reply-To: <20110531235957.GB5256@somewhere.redhat.com>
References: <1304107962-18576-1-git-send-email-vnagarnaik@google.com>
 <1306877298-31713-1-git-send-email-vnagarnaik@google.com> <20110531235957.GB5256@somewhere.redhat.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Wed, 1 Jun 2011 15:38:24 -0700
Message-ID: <BANLkTi=YYCXHi5k82Q+sE6+134i97pjjAA@mail.gmail.com>
Subject: Re: [PATCH v2] trace: Add x86 irq vector entry/exit tracepoints
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Jiaying Zhang <jiayingz@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 5:00 PM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
>
> IIRC, Thomas suggested in the v1 to turn arch tracepoints into core ones when they
> stand for generic (ie: shared by all archs) event meaning.
>
> I don't know where the discussion went after that, but that still seems to
> me an important direction. Tracing irqs by their vector number should be reserved
> for pure arch meanings. Sharing common tracepoints for generic events amongst archs makes life
> easier for tools. Bonus when the tracepoint can be placed in the generic code.
>

I agree with you that the tracepoints should be as generic as possible
to have them traced across platforms, but I see these tracepoints as
specific to x86 platform. Since most of these vectors are x86 specific.
The only ones that you pointed out as generic were:

LOCAL_TIMER_VECTOR - The generic callbacks that I found are in:
kernel/time/tick-broadcast.c (tick_handle_periodic(),
tick_handle_periodic_broadcast(), tick_handle_oneshot_broadcast()).

RESCHEDULE_VECTOR - The callback is in kernel/sched.c (scheduler_ipi())

CALL_FUNCTION_VECTOR - The callback is in kernel/smp.c
(generic_smp_call_function_interrupt())
CALL_FUNCTION_SINGLE_VECTOR - The callback is in kernel/smp.c
(generic_smp_call_function_single_interrupt())

IRQ_WORK_VECTOR - kernel/irq_work.c (irq_work_run())

REBOOT_VECTOR - For x86, this does not enter any generic code. It is
also not traced. The definition was in there only as part of the
interrupt table.

So, as I see it, there are only 5 vectors that enter the generic
handling code of the kernel. The other vectors have platform specific
handlers or are just x86 specific IRQs.

This is the reason that I added the irq_vectors tracing class under the
arch-specific code. If other platforms want to use the same event class,
it can be initialized in their platform specific code for their use with
the appropriate tracepoints added.


Vaibhav Nagarnaik
