Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab0CXH6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 03:58:25 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:38222 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab0CXH6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 03:58:24 -0400
Date: Wed, 24 Mar 2010 13:28:15 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@redhat.com>, Tom Tromey <tromey@redhat.com>
Subject: Re: [PATCH v1 7/10] Uprobes Implementation
Message-ID: <20100324075815.GC26762@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
 <20100320142617.11427.23852.sendpatchset@localhost6.localdomain6>
 <1269342115.5279.1620.camel@twins>
 <20100323122335.GB26762@linux.vnet.ibm.com>
 <1269352012.5109.22.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1269352012.5109.22.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter, 

> > > I would still prefer to see something like:
> > > 
> > >  vma:offset, instead of tid:vaddr
> > >  
> > > You want to probe a symbol in a DSO, filtering per-task comes after that
> > > if desired.
> > > 
> 
> > do you mean the user should be specifying 357c200000:74b80 to denote
> > 000000357c274b80? or /lib64/libc.so.6:74b80
> > And we trace all the process which have mapped this address?
> 
> Well userspace would simply specify something like: /lib/libc.so:malloc,
> we'd probably communicate that to the kernel using a filedesc and
> offset.
> 
> And yes, all processes that share that DSO, consumers can install
> filters.
> 

I think perf would be using uprobes in one of the four ways.
- Trace a particular process.
- Trace a particular session.
- Trace all instances of an executable. 
- Trace all programs in the system.

If we use global approach, filtering would still be part of the handler.
So even if we want to probe just one process, we would still take hit
for all processes that map the DSO and hit that vaddr.
Other process could be hitting the probepoint more often while the
probed process could rarely be hitting the probepoint. This could
place significant overhead on the system.

Also with KSM, the page we are probing could be part of the stable tree
and mapped by different virtual machines. Can this lead to interruptting
work on an unrelated virtual machine? If yes, Is it okay to interrupt an
unrelated VM? If not, what measures need to be taken?

Currently perf can be used by priviledged users. However when perf gets
to trace user space programs, would it still be limited to priviledged
users. Do we have plans to allow users to trace their owned
applications thro perf?

> > > 
> > > This should allow the handler to optimistically access memory from the
> > > trap handler, but in case it does need to fault pages in we'll call it
> > > from task context.
> > 
> > Okay but what if the handler is coded to sleep.
> 
> Don't do that ;-)
> 
> What reason would you have to sleep from a int3 anyway? You want to log
> bits and get on with life, right? The only interesting case is faulting
> when some memory references you want are not currently available, and
> that can be done as suggested.
> 

Though one of the usp of uprobes is non disruptive tracing, applications
like debuggers who do disruptive tracing can benefit from uprobes. 

Debuggers could use uprobes as a feature to implement inserting/removing
breakpoints and get the out of line single-stepping. In an earlier
discussion http://lkml.org/lkml/2010/1/26/344 Tom Tromey did say that if
a facility was given, it could be used in gdb.

What I expect is the tracee to inform the tracer that it has hit the
breakpoint and "wait" for the tracer to give indication to continue.

Benefits could be 
- Debuggers can benefit from execution out of line and can debug
  multithread processes much better. 

- Two debbugers/tracers could trace the same process. One of the tracer
  could be strace, while the other one could be gdb.

- perf and debugger could be interested in the same vaddr for that
process and still continue to work. 
Lets say debugger and perf are interested in a particular function for
example malloc.
If perf uses uprobes and debuggers uses existing methods, then perf
measures of malloc may not be accurate as it misses those mallocs of the
process that's being debugged. However I agree that its a very very very
minute case.


> > > Everybody else simply places callbacks in kernel/fork.c and
> > > kernel/exit.c, but as it is I don't think you want per-task state like
> > > this.
> > > 
> > > One thing I would like to see is a slot per task, that has a number of
> > > advantages over the current patch-set in that it doesn't have one page
> > > limit in number of probe sites, nor do you need to insert vmas into each
> > > and every address space that happens to have your DSO mapped.
> > > 
> > 
> > where are the per task slots stored?
> > or Are you looking at a XOL vma area per DSO?
> 
> The per task slot (note the singular, each task needs only ever have a
> single slot since a task can only ever hit one trap at a time) would
> live in the task TLS or task stack.
> 

Do we need a buy-in from glibc folks to do this?
Also here is what Roland had once said about TLS.

"Next we come to the problem of where to store copied instructions for
stepping.  The idea of stealing a stack page for this is a non-starter.
For both security and robustness, it's never acceptable to introduce a
user mapping that is both writable and executable, even temporarily.  We
need to use an otherwise unused page in the address space, that will be
read/execute only for the user, we can write to it only from kernel
mode."


--
Thanks and Regards
Srikar
