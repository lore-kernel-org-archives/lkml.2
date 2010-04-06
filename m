Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab0DFKTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 06:19:41 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:63361 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab0DFKTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 06:19:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CDZQpH8faiNvgn/j3e4Qo4N+8SbuLAb81WPwcDNZQTMxl483cxYGskM9SW9B9qkf8v
         O3ZjU91bZKzqgH/9DiYw1Y6M6ro1nGke92vTWjFpp/5DcMlY83FoJghAmjlCwgF6SBun
         RUmzH7tWAXBqy177UEfVuyx0j4/XdG5rjqBrc=
Date: Tue, 6 Apr 2010 12:19:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Miller <davem@davemloft.net>, Steven Rostedt <rostedt@goodmis.org>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       acme@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: Random scheduler/unaligned accesses crashes with perf lock
	events on sparc 64
Message-ID: <20100406101925.GD5147@nowhere>
References: <20100405065701.GC5127@nowhere> <20100405.122233.188421941.davem@davemloft.net> <20100405194055.GA5265@nowhere> <20100406.025049.267615796.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406.025049.267615796.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 02:50:49AM -0700, David Miller wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Mon, 5 Apr 2010 21:40:58 +0200
> 
> > It happens without CONFIG_FUNCTION_TRACER as well (but it happens
> > when the function tracer runs). And I hadn't your
> > perf_arch_save_caller_regs() when I triggered this.
> 
> I figured out the problem, it's NMIs.  As soon as I disable all of the
> NMI watchdog code, the problem goes away.
> 
> This is because some parts of the NMI interrupt handling path are not
> marked with "notrace" and the various tracer code paths use
> local_irq_disable() (either directly or indirectly) which doesn't work
> with sparc64's NMI scheme.  These essentially turn NMIs back on in the
> NMI handler before the NMI condition has been cleared, and thus we can
> re-enter with another NMI interrupt.
> 
> We went through this for perf events, and we just made sure that
> local_irq_{enable,disable}() never occurs in any of the code paths in
> perf events that can be reached via the NMI interrupt handler.  (the
> only one we had was sched_clock() and that was easily fixed)
> 
> So, the first mcount hit we get is for rcu_nmi_enter() via
> nmi_enter().
> 
> I can see two ways to handle this:
> 
> 1) Pepper 'notrace' markers onto rcu_nmi_enter(), rcu_nmi_exit()
>    and whatever else I can see getting hit in the NMI interrupt
>    handler code paths.
> 
> 2) Add a hack to __raw_local_irq_save() that keeps it from writing
>    anything to the interrupt level register if we have NMI's disabled.
>    (this puts the cost on the entire kernel instead of just the NMI
>    paths).
> 
> #1 seems to be the intent on other platforms, the majority of the NMI
> code paths are protected with 'notrace' on x86, I bet nobody noticed
> that nmi_enter() when CONFIG_NO_HZ && !CONFIG_TINY_RCU ends up calling
> a function that does tracing.
> 
> The next one we'll hit is atomic_notifier_call_chain()  (amusingly
> notify_die() is marked 'notrace' but the one thing it calls isn't)
> 
> For example, the following are the generic notrace annotations I
> would need to get sparc64 ftrace functioning again. (Frederic I will
> send you the full patch with the sparc specific bits under seperate
> cover in so that you can test things...)
> 
> --------------------
> kernel: Add notrace annotations to common routines invoked via NMI.
> 
> This includes the atomic notifier call chain as well as the RCU
> specific NMI enter/exit handlers.



Ok, but this as a cause looks weird.
The function tracer handler disables interrupts. I don't remember exactly
why but we also have a no-preempt mode that only disables preemption instead:
(function_trace_call_preempt_only())

It means having such interrupt reentrancy is not a problem. In fact, the
function tracer is not reentrant:

	data = tr->data[cpu];
	disabled = atomic_inc_return(&data->disabled);

	if (likely(disabled == 1))
		trace_function(tr, ip, parent_ip, flags, pc);

	atomic_dec(&data->disabled);

we do this just to prevent from tracing recursion (in case we have
a traceable function in the inner function tracing path).

Nmis are just supposed to be fine with the function tracer.

