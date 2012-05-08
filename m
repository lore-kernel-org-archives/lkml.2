Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab2EHAOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 20:14:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23764 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975Ab2EHAOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 20:14:40 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=0in4RCm__d4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=W9BR7D7LZAPEpSNo0-IA:9 a=fdqQAz1bHelpB_4I3WQA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336436077.14207.162.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v7 1/3] trace: Make removal of ring buffer pages atomic
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org
Date: Mon, 07 May 2012 20:14:37 -0400
In-Reply-To: <CAL26m8LOiaiXPccVsf3avxN28bH6JomjmssfuODnOdpM21tTig@mail.gmail.com>
References: <1335388704-26790-1-git-send-email-vnagarnaik@google.com>
	 <1336096792-25373-1-git-send-email-vnagarnaik@google.com>
	 <1336422144.14207.155.camel@gandalf.stny.rr.com>
	 <CAL26m8LOiaiXPccVsf3avxN28bH6JomjmssfuODnOdpM21tTig@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 14:48 -0700, Vaibhav Nagarnaik wrote:

> The following seems to be the culprit. I am guessing you have a preempt
> kernel?

I'm one of the real-time Linux maintainers, what do you think ;-)

> 
> @@ -3662,8 +3808,12 @@ void ring_buffer_reset_cpu(struct ring_buffer
> *buffer, int cpu)
>        if (!cpumask_test_cpu(cpu, buffer->cpumask))
>                return;
> 
> +       atomic_inc(&buffer->resize_disabled);
>        atomic_inc(&cpu_buffer->record_disabled);
> 
> +       /* Make sure all commits have finished */
> +       synchronize_sched();
> +
>        raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
> 
> 
> I guess I can disable resizing in ring_buffer_record_disable(), that
> seems to be a reasonable assumption.
> 

Looking into this, the culprit is really the __tracing_reset():

static void __tracing_reset(struct ring_buffer *buffer, int cpu)
{
	ftrace_disable_cpu();
	ring_buffer_reset_cpu(buffer, cpu);
	ftrace_enable_cpu();
}


This function is useless. It's from the time the ring buffer was being
converted to lockless, but today it's no longer needed. The reset of the
ring buffer just needs to have the ring buffer disabled.

The bug is on my end ;-)

We can nuke the __tracing_reset() and just call ring_buffer_reset_cpu()
directly. We no longer need those "ftrace_disable/enable_cpu()s". The
comments for the ring_buffer_reset*() should state that the ring buffer
must be disabled before calling this.

Actually, your patch fixes this. As it makes the reset itself takes care
of the the ring buffer being disabled.

OK, you don't need to send another patch set (yet ;-), I'll fix the
ftrace side, and then apply your patches, and then see what else breaks.

-- Steve


