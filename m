Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061Ab0GWOPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 10:15:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:32986 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab0GWOPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 10:15:20 -0400
X-Authority-Analysis: v=1.1 cv=nxp4sGnGskpld68D65f6QeagdS7Y+3TTkvBhhEd/T4I= c=1 sm=0 a=0EwOLGvg4BAA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=vS_hR9bgzJcY9hskoLwA:9 a=gRkQgVofFFQGFZ-nGJjLRGVKvvgA:4 a=PUjeQqilurYA:10 a=g8jOU-JIg06Qago3:21 a=FdvZzvEZ9IAAE4Je:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [tip:x86/irq] x86: Always use irq stacks
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <20100714154746.GA2074@lst.de>
References: <20100628121554.GA6605@lst.de>
	 <tip-7974891db234467eaf1fec613ec0129cb4ac2332@git.kernel.org>
	 <20100630074434.GA25509@elte.hu> <20100630075212.GA24658@lst.de>
	 <20100630075818.GB25509@elte.hu> <20100630080453.GA14371@elte.hu>
	 <20100708204251.GA13569@elte.hu> <20100708205302.GA23961@lst.de>
	 <20100714151215.GA31825@lst.de>
	 <alpine.LFD.2.00.1007141719130.3321@localhost.localdomain>
	 <20100714154746.GA2074@lst.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 23 Jul 2010 10:15:16 -0400
Message-ID: <1279894516.3319.44.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-14 at 17:47 +0200, Christoph Hellwig wrote:

> > So you're saying, that the problem appears when
> > CONFIG_FUNCTION_GRAPH_TRACER is enabled w/o being used and that it
> > exists prior to your patches with irq stacks and 8k stack size, but
> > works with 4k stacks. That's definitely more than odd.
> 
> No, the problem does not show up with 8k stack size without irqstacks,
> and does not show up with 4k stacks with irq stacks, but does show up
> with 8k stacks with irqstacks as long as CONFIG_FUNCTION_GRAPH_TRACER is
> enabled. Just disabling it in Ingo's example config makes it work,
> and enabling it in my usual test configs makes the boot fail with
> similar messages to the one Ingo sees.

Examining the difference between 32bit and 64bit (where it only triggers
for 32bit) I found this:

In arch/x86/kernel/dumpstack_64.c:

        tinfo = task_thread_info(task);
[...]
                       bp = ops->walk_stack(tinfo, stack, bp, ops,
                                             data, estack_end, &graph);


Note: tinfo here that is passed to walk_stack() is the actual thread
info structure for the task.

In arch/x86/kernel/dumpstack_32.c:

                context = (struct thread_info *)
                        ((unsigned long)stack & (~(THREAD_SIZE - 1)));
                bp = ops->walk_stack(context, stack, bp, ops, data, NULL, &graph);

Note: here, context (which ends up being tinfo) is just a bitmasking of
the current stack. If the stack is the irqstack, then what is passed to
walk_stack() is not the actual thread info structure.

Note, if THREAD_SIZE is 8k and irqstacks are 4K then context is totally
wrong here.

Now for the reason that function graph noticed this:

static const struct stacktrace_ops print_trace_ops = {
        .warning                = print_trace_warning,
        .warning_symbol         = print_trace_warning_symbol,
        .stack                  = print_trace_stack,
        .address                = print_trace_address,
        .walk_stack             = print_context_stack,
};

Where walk_stack is print_context_stack:

tinfo is pretty much ignored in print_context_stack, but when function
graph is enabled we have:

                print_ftrace_graph_addr(addr, data, ops, tinfo, graph);

Which actually plays with the tinfo structure. If tinfo is corrupted
here, then we get the bug.

-- Steve



