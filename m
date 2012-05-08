Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab2EHPGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:06:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20265 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab2EHPGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:06:07 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5UZbrx23EwAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=KfHjPaQJPSIdSXIcD-UA:9 a=nArQ-szAwmq44xNZLnkA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336489566.14207.180.camel@gandalf.stny.rr.com>
Subject: Re: [RFC]Read kernel stack with trace-cmd
From: Steven Rostedt <rostedt@goodmis.org>
To: harryxiyou <harryxiyou@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org,
        Chen Lijun <cljcore@126.com>
Date: Tue, 08 May 2012 11:06:06 -0400
In-Reply-To: <CAD+1EGOKJWLLjXam2TA+iksbvwx47n6u1aHir7_SNfO9ECqRGg@mail.gmail.com>
References: <CAD+1EGN=QjPkkqNNybqRHkMs7a-qR_gWL7-dMxrcE92qrX0X2w@mail.gmail.com>
	 <1336399968.14207.141.camel@gandalf.stny.rr.com>
	 <CAD+1EGOKJWLLjXam2TA+iksbvwx47n6u1aHir7_SNfO9ECqRGg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 22:34 +0800, harryxiyou wrote:

> >
> > Have you tried it with -O stacktrace ?
> >
> > trace-cmd record -e all -O stacktrace
> >
> 
> After this cmd, i get following ones.
> 
> [...]
> => handle_IRQ_event (c019fc34)
> => handle_edge_irq (c01a1b84)
> => handle_irq (c01059ed)
> => do_IRQ (c058fa1c)
> => common_interrupt (c0103a30)
> => mod_timer (c015bd42)
> => i915_add_request (f850cef4)
> => i915_gem_do_execbuffer (f8510adc)
>             Xorg-1104  [001]  3106.003258: irq_handler_exit:

Isn't this what you asked for?

> irq=29 return=handled
>             Xorg-1104  [001]  3106.003259: kernel_stack:         <stack trace>
> => handle_edge_irq (c01a1b84)
> => handle_irq (c01059ed)
> => do_IRQ (c058fa1c)
> => common_interrupt (c0103a30)
> => mod_timer (c015bd42)
> => i915_add_request (f850cef4)
> => i915_gem_do_execbuffer (f8510adc)
> => i915_gem_execbuffer (f851123b)
>             Xorg-1104  [001]  3106.003272: kfree:
> call_site=f8510958 ptr=0xf5ab9380
>             Xorg-1104  [001]  3106.003273: kernel_stack:         <stack trace>
> => i915_gem_do_execbuffer (f8510958)
> => i915_gem_execbuffer (f851123b)
> => drm_ioctl (f81d57cd)
> => vfs_ioctl (c0216231)
> => do_vfs_ioctl (c0216519)
> => sys_ioctl (c0216817)
> [...]
>             Xorg-1104  [001]  3106.003348: sched_wakeup:         task
> trace-cmd:3028 [120] success=1 [001]
>             Xorg-1104  [001]  3106.003348: kernel_stack:         <stack trace>
> => wake_up_process (c0142bd4)
> => hrtimer_wakeup (c016acad)
> => __run_hrtimer (c016b14a)^Ctrace-cmd: Received SIGINT
>             Xorg-1104  [001]  3106.003348: kernel_stack:         <stack trace>
> => wake_up_process (c0142bd4)
> => hrtimer_wakeup (c016acad)
> => __run_hrtimer (c016b14a)
> => hrtimer_interrupt (c016b4e0)
> => smp_apic_timer_interrupt (c058fae7)
> => apic_timer_interrupt (c0103df1)
> => __module_text_address (c017cdf0)
> [...]
> => wake_up_process (c0142bd4)
> => hrtimer_wakeup (c016acad)
> => __run_hrtimer (c016b14a)^Ctrace-cmd: Received SIGINT
>             Xorg-1104  [001]  3106.003348: kernel_stack:         <stack trace>
> [...]
> 
> 
> Note: i can't stop the cmd './trace-cmd report' after
> './trace-cmd record -e all -O stacktrace' but enter 'CTRC+C'.
> 
> If it is a bug here? Any comments?

It should stop, but perhaps not immediately. Best to pipe it through
less:

trace-cmd report |less

I may, in the future, make trace-cmd report do its own paging, like git
does. But for now, I just use less.

The reason for the special ctrl-c is because of the python plugin. It
has some strange side effects. One is that it overrides ctrl-c, so I add
a handler to explicitly kill trace-cmd. But that still causes a delay
before the kill happens.

-- Steve


