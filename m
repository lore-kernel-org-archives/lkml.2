Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab0KOOTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 09:19:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59499 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab0KOOTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 09:19:24 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=5z8Dt6at09oA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=e0p6dR7DhRP2gHkMM_AA:9 a=cOjMyQCn9MaVC-njH7xpeRIKaZIA:4 a=PUjeQqilurYA:10 a=DnqNQldVG0r2cIW5:21 a=xlYMbfIQ3dOpSSTA:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCHv2 2/2] tracing,mm - add kernel pagefault tracepoint for
 x86 & x86_64
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu, andi@firstfloor.org,
        lwoodman@redhat.com, hch@infradead.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20101115134325.GA5410@nowhere>
References: <20101110164413.GA5360@nowhere>
	 <1289466549-7602-3-git-send-email-jolsa@redhat.com>
	 <20101115134325.GA5410@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 15 Nov 2010 09:19:20 -0500
Message-ID: <1289830760.12418.598.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 14:43 +0100, Frederic Weisbecker wrote:


> dotraplinkage void __kprobes
> do_page_fault(struct pt_regs *regs, unsigned long error_code)
> {
> 	unsigned long address;
> 
> 	/* Get the faulting address: */
> 	address = read_cr2();
> 
> 	trace_mm_pagefault_start(address, error_code);
> 	__do_page_fault(regs, address, error_code);
> 	trace_mm_pagefault_end(address);
> }
> 
> 
> Would you be ok with that?
> 
> Last thing I worry about is that error_code that is very arch dependent.
> If someone writes a script that depends on the x86 code, it won't work
> elsewhere while it's fairly possible to have a generic tracepoint there.
> 
> So perhaps we rather need a generic enum field instead of the error_code,
> to express the most interesting specific fault attributes. Than can
> probably be added later though, once someone really needs it.
> 
> Hm?

Perhaps we should have:

	trace_arch_mm_pagefault_start(address, error_code);
	__do_page_fault(regs, address, error_code);
	trace_mm_pagefault_end(address);


Then we have a arch/x86/kernel/trace.c that can map trace_arch_...
events to generic events. This file will hold the
trace_mm_pagefault_start(), which is called by
trace_arch_mm_pagefault_start(). Have a hook that when the
trace_mm_pagefault_start() is enabled, we also enable
trace_arch_mm_pagefault_start() that calls this tracepoint. The
trace_mm_pagefault_start() will then translate the
trace_arch_mm_pagfault_start() into the generic trace_mm_pagefault_start
event with the generic error_code that all archs will use.

Reason being, we don't need to do any extra processing in the fast path
when tracing is not enabled.

Also, I'm going to start working on the stable ABI today.

-- Steve


