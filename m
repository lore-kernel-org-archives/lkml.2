Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab0CWPGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:06:00 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42138 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436Ab0CWPF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:05:59 -0400
Date: Tue, 23 Mar 2010 20:35:44 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 7/10] Uprobes Implementation
Message-ID: <20100323150544.GA18323@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6> <20100320142617.11427.23852.sendpatchset@localhost6.localdomain6> <1269342115.5279.1620.camel@twins> <20100323122335.GB26762@linux.vnet.ibm.com> <1269352012.5109.22.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269352012.5109.22.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 02:46:52PM +0100, Peter Zijlstra wrote:
> On Tue, 2010-03-23 at 17:53 +0530, Srikar Dronamraju wrote:
 
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

Well, rewind back to 2006 to the first edition of uprobes; it had the
'global' tracing feature like what you indicate here, although Andrew
wouldn't want to be reminded of *how* that was done (hooking
readpages()) :-)

At the time, global tracing was vehemently vetoed in favour of a per-process
approach.

Now the question is, where the complexity needs to be.
 
> > > Also, like we discussed in person, I think we can do away with the
> > > handler_in_interrupt thing by letting the handler have an error return
> > > value and doing something like:
> > > 
> > > do_int3:
> > > 
> > >   uprobe = find_probe_point(addr);
> > > 
> > >   pagefault_disable();
> > >   err = uprobe->handler(uprobe, regs);
> > >   pagefault_enable();
> > > 
> > >   if (err == -EFAULT) {
> > >     /* set TIF flag and call the handler again from
> > >        task context */
> > >   }
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

With the TIF method, you get to the probed process' task context in 
do_notify_resume(), and have sufficient flexibility for non-perf users, 
like gdb, 'cos what uprobes provides now, is close to what Tom Tromey
asked for gdb's usage.

Ananth
