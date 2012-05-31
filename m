Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786Ab2EaTze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 15:55:34 -0400
Received: from mail.openrapids.net ([64.15.138.104]:57449 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755261Ab2EaTzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 15:55:33 -0400
Date: Thu, 31 May 2012 15:55:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/5] ftrace: Synchronize variable setting with
	breakpoints
Message-ID: <20120531195529.GA22976@Krystal>
References: <20120531012829.160060586@goodmis.org> <20120531020440.476352979@goodmis.org> <1338462398.28384.52.camel@twins> <1338473302.13348.336.camel@gandalf.stny.rr.com> <1338486029.28384.93.camel@twins> <1338486820.13348.366.camel@gandalf.stny.rr.com> <1338487413.28384.103.camel@twins> <1338490218.13348.379.camel@gandalf.stny.rr.com> <1338491176.28384.114.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338491176.28384.114.camel@twins>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2012-05-31 at 14:50 -0400, Steven Rostedt wrote:
> 
> > > Well, the fail is before that, how could we grow two pieces of code
> > > doing similar things in the first place? 
> > 
> > Again, ftrace is slightly different as it does 30,000 changes at once,
> > on top of known nops. This was done through stop_machine(), thus any
> > slowdown was a large hit to system performance. text_poke() took the way
> > of mapping a page to do the change, and Mathieu didn't want to change
> > that (IIRC). But now we want the two to be similar.
> 
> We could give text_poke a function argument to do the actual
> modification, leaving all the magic centralized.
> 
> Also, why did Mathieu insist on keeping that kmap()?

Not sure about the entire context here, but the goal of using kmap() is
to allow modification of text in configurations where the kernel text
is read-only: the kmap does a temporary shadow RW mapping that allows
modification of the text. Presumably that Ftrace's 30k changes are done
before the kernel text mapping is set to read-only ? If this is the
case, then it is similar to text_poke_early, which don't use the kmap
since it happens before kernel text gets write-protected. But text_poke
has to deal with RO pages.

Hopefully my answer makes sense in the context of your discussion.

Thanks,

Mathieu

> 
> > > I hardly ever use dyn-ftrace but I do use some text_poke() through
> > > jump_labels.
> > 
> > You don't use function tracer? That's dyn-ftrace.
> 
> Not much no.. I do use trace_printk() and ftrace_dump_on_oops a lot
> though.
> 
> > But still, we need to keep the record as small as possible because it is
> > persistent throughout the life of the system running. Every location
> > must be recorded, and maintain a state (flags).
> > 
> > Text_poke() mostly grew out of the jump-label work. But yes, there's
> > still a lot that can be shared. The actual code modification may be.
> 
> Afaicr we didn't change text_poke() for the jump-label stuff, except in
> trivial ways (added a #ifdef and exposed a function etc..).
> 
> > > I would still like to end up with one code base doing CMC with two
> > > implementations depending on a Kconfig knob.
> > 
> > You mean keep stop_machine around?
> 
> Yeah, like have CONFIG_CMC_STOPMACHINE and CONFIG_CMC_FANCY for a little
> while.
> 
> If we find a problem with the fancy approach going back is easy, once
> its proven stable we could remove the stop-machine one.

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
