Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab0CWPQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:16:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59519 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab0CWPQE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:16:04 -0400
Subject: Re: [PATCH v1 7/10] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <4BA8CE39.8050203@redhat.com>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
	 <20100320142617.11427.23852.sendpatchset@localhost6.localdomain6>
	 <1269342115.5279.1620.camel@twins>
	 <20100323122335.GB26762@linux.vnet.ibm.com>
	 <1269352012.5109.22.camel@twins>  <4BA8CE39.8050203@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Mar 2010 16:15:11 +0100
Message-ID: <1269357311.5109.81.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 10:20 -0400, Masami Hiramatsu wrote:

> > And yes, all processes that share that DSO, consumers can install
> > filters.
> 
> Hmm, for low-level interface, it will be good. If we provide
> a user interface(trace_uprobe.c), we'd better add pid filter
> for it.

ftrace already has pid filters.

> >>> Also, like we discussed in person, I think we can do away with the
> >>> handler_in_interrupt thing by letting the handler have an error return
> >>> value and doing something like:
> >>>
> >>> do_int3:
> >>>
> >>>   uprobe = find_probe_point(addr);
> >>>
> >>>   pagefault_disable();
> >>>   err = uprobe->handler(uprobe, regs);
> >>>   pagefault_enable();
> >>>
> >>>   if (err == -EFAULT) {
> >>>     /* set TIF flag and call the handler again from
> >>>        task context */
> >>>   }
> >>>
> >>> This should allow the handler to optimistically access memory from the
> >>> trap handler, but in case it does need to fault pages in we'll call it
> >>> from task context.
> >>
> >> Okay but what if the handler is coded to sleep.
> > 
> > Don't do that ;-)
> > 
> > What reason would you have to sleep from a int3 anyway? You want to log
> > bits and get on with life, right? The only interesting case is faulting
> > when some memory references you want are not currently available, and
> > that can be done as suggested.
> 
> Out of curiously, what does the task-context mean? ('current' is probed
> task in int3, isn't it?). I think, uprobe handler can cause page fault
> (and should sleep) if the page is swapped out.

Task context means the regular kernel task stack where we can schedule,
int3 has its own exception stack and we cannot schedule from that.

And yes, the fault thing is the one case where sleeping makes sense and
is dealt with in my proposal, you don't need two handlers for that, just
call it from trap context with pagefault_disable() and when it fails
with -EFAULT set a TIF flag to deal with it later when we're back in
task context.

There is a very good probability that the memory you want to reference
is mapped (because typically the program itself will want to access it
as well) so doing the optimistic access with pagefault_disabled() will
work most of the times and you only end up taking the slow path when it
does indeed fault.

> >>> Everybody else simply places callbacks in kernel/fork.c and
> >>> kernel/exit.c, but as it is I don't think you want per-task state like
> >>> this.
> >>>
> >>> One thing I would like to see is a slot per task, that has a number of
> >>> advantages over the current patch-set in that it doesn't have one page
> >>> limit in number of probe sites, nor do you need to insert vmas into each
> >>> and every address space that happens to have your DSO mapped.
> >>>
> >>
> >> where are the per task slots stored?
> >> or Are you looking at a XOL vma area per DSO?
> > 
> > The per task slot (note the singular, each task needs only ever have a
> > single slot since a task can only ever hit one trap at a time) would
> > live in the task TLS or task stack.
> 
> Hmm, I just worried about whether TLS/task stack can be executable
> (no one set NX bit).

You can remove the NX bit from that one page I guess.

> >>> Also, I would simply kill the user_bkpt stuff and merge it into uprobes,
> >>> we don't have a kernel_bkpt thing either, only kprobes.
> >>>
> >>
> >> We had uprobes as one single layer. However it was suggested that
> >> breaking it up into two layers was useful because it would help code
> >> reuse. Esp it was felt that a generic user_bkpt layer would be far more
> >> useful than being used for just uprobes.
> >> Here are links where these discussion happened.
> > 
> > I'm so not going to read ancient emails on a funky list. What re-use?
> > uprobe should be the only interface to this, there's no second interface
> > to kprobes either is there?
> 
> It will be good when we start working on 'ptrace2' :)
> Anyway, the patch order looks a bit odd, because user_bkpt uses XOL
> but XOL patch is introduced after user_bkpt patch...

But why would ptrace2 use a different interface? Also, why introduce
some abstraction layer now without having a user for it, you could
always restructure things and or add interfaces later when you have a
clear idea what it is you need.
