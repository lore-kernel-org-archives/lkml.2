Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab2EaTGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 15:06:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:39500 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395Ab2EaTGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 15:06:36 -0400
Message-ID: <1338491176.28384.114.camel@twins>
Subject: Re: [PATCH 1/5] ftrace: Synchronize variable setting with
 breakpoints
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Thu, 31 May 2012 21:06:16 +0200
In-Reply-To: <1338490218.13348.379.camel@gandalf.stny.rr.com>
References: <20120531012829.160060586@goodmis.org>
	 <20120531020440.476352979@goodmis.org> <1338462398.28384.52.camel@twins>
	 <1338473302.13348.336.camel@gandalf.stny.rr.com>
	 <1338486029.28384.93.camel@twins>
	 <1338486820.13348.366.camel@gandalf.stny.rr.com>
	 <1338487413.28384.103.camel@twins>
	 <1338490218.13348.379.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 14:50 -0400, Steven Rostedt wrote:

> > Well, the fail is before that, how could we grow two pieces of code
> > doing similar things in the first place? 
> 
> Again, ftrace is slightly different as it does 30,000 changes at once,
> on top of known nops. This was done through stop_machine(), thus any
> slowdown was a large hit to system performance. text_poke() took the way
> of mapping a page to do the change, and Mathieu didn't want to change
> that (IIRC). But now we want the two to be similar.

We could give text_poke a function argument to do the actual
modification, leaving all the magic centralized.

Also, why did Mathieu insist on keeping that kmap()?

> > I hardly ever use dyn-ftrace but I do use some text_poke() through
> > jump_labels.
> 
> You don't use function tracer? That's dyn-ftrace.

Not much no.. I do use trace_printk() and ftrace_dump_on_oops a lot
though.

> But still, we need to keep the record as small as possible because it is
> persistent throughout the life of the system running. Every location
> must be recorded, and maintain a state (flags).
> 
> Text_poke() mostly grew out of the jump-label work. But yes, there's
> still a lot that can be shared. The actual code modification may be.

Afaicr we didn't change text_poke() for the jump-label stuff, except in
trivial ways (added a #ifdef and exposed a function etc..).

> > I would still like to end up with one code base doing CMC with two
> > implementations depending on a Kconfig knob.
> 
> You mean keep stop_machine around?

Yeah, like have CONFIG_CMC_STOPMACHINE and CONFIG_CMC_FANCY for a little
while.

If we find a problem with the fancy approach going back is easy, once
its proven stable we could remove the stop-machine one.
