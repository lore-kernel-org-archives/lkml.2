Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab2EaU01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:26:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:41069 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306Ab2EaU00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:26:26 -0400
Message-ID: <1338495969.28384.119.camel@twins>
Subject: Re: [PATCH 1/5] ftrace: Synchronize variable setting with
 breakpoints
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, acme <acme@ghostprotocols.net>
Date: Thu, 31 May 2012 22:26:09 +0200
In-Reply-To: <1338495006.13348.418.camel@gandalf.stny.rr.com>
References: <20120531012829.160060586@goodmis.org>
	 <20120531020440.476352979@goodmis.org> <1338462398.28384.52.camel@twins>
	 <1338473302.13348.336.camel@gandalf.stny.rr.com>
	 <1338486029.28384.93.camel@twins>
	 <1338486820.13348.366.camel@gandalf.stny.rr.com>
	 <1338487413.28384.103.camel@twins>
	 <1338490218.13348.379.camel@gandalf.stny.rr.com>
	 <1338491176.28384.114.camel@twins> <20120531195529.GA22976@Krystal>
	 <1338495006.13348.418.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 16:10 -0400, Steven Rostedt wrote:
> On Thu, 2012-05-31 at 15:55 -0400, Mathieu Desnoyers wrote:
> 
> > > Also, why did Mathieu insist on keeping that kmap()?
> > 
> > Not sure about the entire context here, but the goal of using kmap() is
> > to allow modification of text in configurations where the kernel text
> > is read-only: the kmap does a temporary shadow RW mapping that allows
> > modification of the text. Presumably that Ftrace's 30k changes are done
> > before the kernel text mapping is set to read-only ? If this is the
> > case, then it is similar to text_poke_early, which don't use the kmap
> > since it happens before kernel text gets write-protected. But text_poke
> > has to deal with RO pages.
> 
> No this is also when ftrace is enabled at runtime. The trick that ftrace
> does is to temporarially  convert the kernel text from ro to rw, and
> then back to ro when done. You can argue that this degrades the security
> of the system, but tracing every function in the kernel does too ;-)
> That's why it's a root only utility.

Right, but when you loose stop-machine you could simply do 30k
kmap_atomic/kunmap_atomic's consecutively since you're not holding
anybody up.

> Hmm, this brings up another question. By default, perf does not allow
> users to profile trace_events correct? IOW, perf does not let
> unprivileged users call text_poke()? I just tried it and got the:
> 
> $ ~/bin/perf record -e sched:sched_switch sleep 1
> Permission error - are you root?
> Consider tweaking /proc/sys/kernel/perf_event_paranoid:
>  -1 - Not paranoid at all
>   0 - Disallow raw tracepoint access for unpriv
>   1 - Disallow cpu events for unpriv
>   2 - Disallow kernel profiling for unpriv

It would, except tools/perf does stupid, its unconditionally adding
PERF_SAMPLE_RAW (even for non-sampling events), which is the bit that
requires privs.

