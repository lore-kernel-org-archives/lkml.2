Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab1GANnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:43:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56219 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab1GANnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:43:46 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=J5aFgaVnb1wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=GSe24wna2t0XkE41U-MA:9 a=5TZvUucACyadFah7OwsA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC PATCH -tip ] [BUGFIX] x86: Remove preempt disabling from
 kprobes
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        yrl.pp-manager.tt@hitachi.com
In-Reply-To: <20110701131408.30886.45766.stgit@localhost.localdomain>
References: <4E0DC859.6050405@hitachi.com>
	 <20110701131408.30886.45766.stgit@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 01 Jul 2011 09:43:44 -0400
Message-ID: <1309527824.26417.149.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 22:14 +0900, Masami Hiramatsu wrote:
> Steven Rostedt reported that putting kprobe on the instruction which
> loads preempt_count causes the wrong result, as below.
> 
> Kprobes requires preemption to be disabled as it single steps the code
> it replaced with a breakpoint. But because the code that is single
> stepped could be reading the preempt count, the kprobe disabling of the
> preempt count can cause the wrong value to end up as a result. Here's an
> example:
> 
> If we add a kprobe on a inc_preempt_count() call:
> 
> 	[ preempt_count = 0 ]
> 
> 	ld preempt_count, %eax	<<--- trap
> 
> 		<trap>
> 		preempt_disable();
> 		[ preempt_count = 1]
> 		setup_singlestep();
> 		<trap return>
> 
> 	[ preempt_count = 1 ]
> 
> 	ld preempt_count, %eax
> 
> 	[ %eax = 1 ]
> 
> 		<trap>
> 		post_kprobe_handler()
> 			preempt_enable_no_resched();
> 			[ preempt_count = 0 ]
> 		<trap return>
> 
> 	[ %eax = 1 ]
> 
> 	add %eax,1
> 
> 	[ %eax = 2 ]
> 
> 	st %eax, preempt_count
> 
> 	[ preempt_count = 2 ]
> 
> 
> We just caused preempt count to increment twice when it should have only
> incremented once, and this screws everything else up.
> 
> To solve this, I've removed preempt disabling code from kprobes,
> since the breakpoint exception and kprobes single step routine
> disables interrupts, it doesn't need to disable preemption while
> single-stepping anymore.
> 
> This patch is for -tip tree, and it can be applied to linus tree too.

I applied it to v3.0-rc5. And not surprisingly it works. But the
question I have is, when we return from the trap, and NEED_RECHED is
set, will it schedule? My test placed the probe within the scheduler
where preemption is already disabled. Let me do this in places that has
preemption and interrupts enabled.

I'll also try a kernel mod that adds a probe handler that does a
udelay() loop, forcing the timer interrupt to be set on return of the
trap, and see what happens there.

-- Steve


