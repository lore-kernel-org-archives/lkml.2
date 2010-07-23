Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153Ab0GWOYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 10:24:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39950 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab0GWOYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 10:24:04 -0400
X-Authority-Analysis: v=1.1 cv=nxp4sGnGskpld68D65f6QeagdS7Y+3TTkvBhhEd/T4I= c=1 sm=0 a=0EwOLGvg4BAA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=PKmOw-T66aZdscb9HcsA:9 a=w9NUGCwQDX7f8xkjvBDsquSmUfIA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [tip:x86/irq] x86: Always use irq stacks
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <1279894516.3319.44.camel@gandalf.stny.rr.com>
References: <20100628121554.GA6605@lst.de>
	 <tip-7974891db234467eaf1fec613ec0129cb4ac2332@git.kernel.org>
	 <20100630074434.GA25509@elte.hu> <20100630075212.GA24658@lst.de>
	 <20100630075818.GB25509@elte.hu> <20100630080453.GA14371@elte.hu>
	 <20100708204251.GA13569@elte.hu> <20100708205302.GA23961@lst.de>
	 <20100714151215.GA31825@lst.de>
	 <alpine.LFD.2.00.1007141719130.3321@localhost.localdomain>
	 <20100714154746.GA2074@lst.de>
	 <1279894516.3319.44.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 23 Jul 2010 10:24:02 -0400
Message-ID: <1279895042.3319.48.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-23 at 10:15 -0400, Steven Rostedt wrote:
> On Wed, 2010-07-14 at 17:47 +0200, Christoph Hellwig wrote:

> In arch/x86/kernel/dumpstack_32.c:
> 
>                 context = (struct thread_info *)
>                         ((unsigned long)stack & (~(THREAD_SIZE - 1)));
>                 bp = ops->walk_stack(context, stack, bp, ops, data, NULL, &graph);
> 
> Note: here, context (which ends up being tinfo) is just a bitmasking of
> the current stack. If the stack is the irqstack, then what is passed to
> walk_stack() is not the actual thread info structure.
> 
> Note, if THREAD_SIZE is 8k and irqstacks are 4K then context is totally
> wrong here.

irqstacks are indeed 8k as well, but:

union irq_ctx {
        struct thread_info      tinfo;
        u32                     stack[THREAD_SIZE/sizeof(u32)];
} __attribute__((aligned(PAGE_SIZE)));


The stack is 8k, but it is aligned 4k. Which will have

   context = (struct thread_info *)
                  ((unsigned long)stack & (~(THREAD_SIZE - 1)));

not give the expected result.

So we should do:

} __attribute__((aligned(THREAD_SIZE)));

-- Steve


