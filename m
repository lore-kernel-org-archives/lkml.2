Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934097Ab0KPJXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 04:23:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934022Ab0KPJXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 04:23:39 -0500
Date: Tue, 16 Nov 2010 10:23:06 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu,
        andi@firstfloor.org, lwoodman@redhat.com, hch@infradead.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv2 2/2] tracing,mm - add kernel pagefault tracepoint for
 x86 & x86_64
Message-ID: <20101116092306.GC1955@jolsa.brq.redhat.com>
References: <20101110164413.GA5360@nowhere>
 <1289466549-7602-3-git-send-email-jolsa@redhat.com>
 <20101115134325.GA5410@nowhere>
 <1289830760.12418.598.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289830760.12418.598.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 09:19:20AM -0500, Steven Rostedt wrote:
> On Mon, 2010-11-15 at 14:43 +0100, Frederic Weisbecker wrote:
> 
> 
> > dotraplinkage void __kprobes
> > do_page_fault(struct pt_regs *regs, unsigned long error_code)
> > {
> > 	unsigned long address;
> > 
> > 	/* Get the faulting address: */
> > 	address = read_cr2();
> > 
> > 	trace_mm_pagefault_start(address, error_code);
> > 	__do_page_fault(regs, address, error_code);
> > 	trace_mm_pagefault_end(address);
> > }
> > 
> > 
> > Would you be ok with that?
> > 
> > Last thing I worry about is that error_code that is very arch dependent.
> > If someone writes a script that depends on the x86 code, it won't work
> > elsewhere while it's fairly possible to have a generic tracepoint there.
> > 
> > So perhaps we rather need a generic enum field instead of the error_code,
> > to express the most interesting specific fault attributes. Than can
> > probably be added later though, once someone really needs it.
> > 
> > Hm?
> 
> Perhaps we should have:
> 
> 	trace_arch_mm_pagefault_start(address, error_code);
> 	__do_page_fault(regs, address, error_code);
> 	trace_mm_pagefault_end(address);
> 
> 
> Then we have a arch/x86/kernel/trace.c that can map trace_arch_...
> events to generic events. This file will hold the
> trace_mm_pagefault_start(), which is called by
> trace_arch_mm_pagefault_start(). Have a hook that when the
> trace_mm_pagefault_start() is enabled, we also enable
> trace_arch_mm_pagefault_start() that calls this tracepoint. The
> trace_mm_pagefault_start() will then translate the
> trace_arch_mm_pagfault_start() into the generic trace_mm_pagefault_start
> event with the generic error_code that all archs will use.
> 
> Reason being, we don't need to do any extra processing in the fast path
> when tracing is not enabled.
> 
> Also, I'm going to start working on the stable ABI today.
do you mean stable api for the hook you described above?
or should I come up with smth..

thanks,
jirka
