Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab0CWNrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:47:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35336 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab0CWNrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:47:37 -0400
Subject: Re: [PATCH v1 7/10] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20100323122335.GB26762@linux.vnet.ibm.com>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
	 <20100320142617.11427.23852.sendpatchset@localhost6.localdomain6>
	 <1269342115.5279.1620.camel@twins>
	 <20100323122335.GB26762@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Mar 2010 14:46:52 +0100
Message-ID: <1269352012.5109.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 17:53 +0530, Srikar Dronamraju wrote:
> Hi Peter,
> 
> > On Sat, 2010-03-20 at 19:56 +0530, Srikar Dronamraju wrote:
> > > +struct uprobe {
> > > +       /*
> > > +        * The pid of the probed process.  Currently, this can be the
> > > +        * thread ID (task->pid) of any active thread in the process.
> > > +        */
> > > +       pid_t pid;
> > > +
> > > +       /* Location of the probepoint */
> > > +       unsigned long vaddr;
> > > +
> > > +       /* Handler to run when the probepoint is hit */
> > > +       void (*handler)(struct uprobe*, struct pt_regs*);
> > > +
> > > +       /* true if handler runs in interrupt context*/
> > > +       bool handler_in_interrupt;
> > > +}; 
> > 
> > I would still prefer to see something like:
> > 
> >  vma:offset, instead of tid:vaddr
> >  
> > You want to probe a symbol in a DSO, filtering per-task comes after that
> > if desired.
> > 

> do you mean the user should be specifying 357c200000:74b80 to denote
> 000000357c274b80? or /lib64/libc.so.6:74b80
> And we trace all the process which have mapped this address?

Well userspace would simply specify something like: /lib/libc.so:malloc,
we'd probably communicate that to the kernel using a filedesc and
offset.

And yes, all processes that share that DSO, consumers can install
filters.

> > Also, like we discussed in person, I think we can do away with the
> > handler_in_interrupt thing by letting the handler have an error return
> > value and doing something like:
> > 
> > do_int3:
> > 
> >   uprobe = find_probe_point(addr);
> > 
> >   pagefault_disable();
> >   err = uprobe->handler(uprobe, regs);
> >   pagefault_enable();
> > 
> >   if (err == -EFAULT) {
> >     /* set TIF flag and call the handler again from
> >        task context */
> >   }
> > 
> > This should allow the handler to optimistically access memory from the
> > trap handler, but in case it does need to fault pages in we'll call it
> > from task context.
> 
> Okay but what if the handler is coded to sleep.

Don't do that ;-)

What reason would you have to sleep from a int3 anyway? You want to log
bits and get on with life, right? The only interesting case is faulting
when some memory references you want are not currently available, and
that can be done as suggested.

> > Everybody else simply places callbacks in kernel/fork.c and
> > kernel/exit.c, but as it is I don't think you want per-task state like
> > this.
> > 
> > One thing I would like to see is a slot per task, that has a number of
> > advantages over the current patch-set in that it doesn't have one page
> > limit in number of probe sites, nor do you need to insert vmas into each
> > and every address space that happens to have your DSO mapped.
> > 
> 
> where are the per task slots stored?
> or Are you looking at a XOL vma area per DSO?

The per task slot (note the singular, each task needs only ever have a
single slot since a task can only ever hit one trap at a time) would
live in the task TLS or task stack.

> > Also, I would simply kill the user_bkpt stuff and merge it into uprobes,
> > we don't have a kernel_bkpt thing either, only kprobes.
> > 
> 
> We had uprobes as one single layer. However it was suggested that
> breaking it up into two layers was useful because it would help code
> reuse. Esp it was felt that a generic user_bkpt layer would be far more
> useful than being used for just uprobes.
> Here are links where these discussion happened.

I'm so not going to read ancient emails on a funky list. What re-use?
uprobe should be the only interface to this, there's no second interface
to kprobes either is there?
