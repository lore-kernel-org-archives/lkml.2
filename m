Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab1KBS2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:28:25 -0400
Received: from peace.netnation.com ([204.174.223.2]:49035 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab1KBS2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:28:24 -0400
Date: Wed, 2 Nov 2011 11:28:12 -0700
From: Simon Kirby <sim@hostway.ca>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111102182812.GE5971@hostway.ca>
References: <1318879396.4172.92.camel@twins> <alpine.LFD.2.02.1110172237030.3240@ionos> <alpine.LFD.2.02.1110181037120.3240@ionos> <1318928713.21167.4.camel@twins> <20111018182046.GF1309@hostway.ca> <alpine.LFD.2.02.1110182146440.3240@ionos> <20111024190203.GA24410@hostway.ca> <20111025202049.GB25043@hostway.ca> <20111031173246.GA10614@hostway.ca> <alpine.LFD.2.02.1111021725550.2829@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1111021725550.2829@ionos>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 05:40:53PM +0100, Thomas Gleixner wrote:

> On Mon, 31 Oct 2011, Simon Kirby wrote:
> 
> > One more, again a bit different. The last few lockups have looked like
> > this. Not sure why, but we're hitting this at a few a day now. Thomas,
> > this is without your patch, but as you said, that's right before a free
> > and should print a separate lockdep warning.
> > 
> > No "huh" lines until after the trace on this one. I'll move to 3.1 with
> 
> That means that the lockdep warning hit in the same net_rx cycle
> before the leak was detected by the softirq code.
> 
> > cherry-picked b0691c8e now.
> 
> Can you please add the debug patch below and try the following:
> 
> Enable CONFIG_FUNCTION_TRACER & CONFIG_FUNCTION_GRAPH_TRACER
> 
> # cd $DEBUGFSMOUNTPOINT/tracing
> # echo sk_clone >set_ftrace_filter
> # echo function >current_tracer
> # echo 1 >options/func_stack_trace
> 
> Now wait until it reproduces (which stops the trace) and read out
> 
> # cat trace >/tmp/trace.txt
> 
> Please provide the trace file along with the lockdep splat. That
> should tell us which callchain is responsible for the spinlock
> leakage.
> Thanks,
> 
> 	tglx
> 
> --------------->
>  kernel/softirq.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6/kernel/softirq.c
> ===================================================================
> --- linux-2.6.orig/kernel/softirq.c
> +++ linux-2.6/kernel/softirq.c
> @@ -238,6 +238,7 @@ restart:
>  			h->action(h);
>  			trace_softirq_exit(vec_nr);
>  			if (unlikely(prev_count != preempt_count())) {
> +				tracing_off();
>  				printk(KERN_ERR "huh, entered softirq %u %s %p"
>  				       "with preempt_count %08x,"
>  				       " exited with %08x?\n", vec_nr,

Ok, I'll try this. Hmm, all CPUs typically try to grab the lock fairly
quickly after it happens, which could make it difficult to cat the file.
I'll try ftrace_dump(DUMP_ALL); in there instead.

Simon-
