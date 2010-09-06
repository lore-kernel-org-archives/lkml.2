Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab0IFRw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 13:52:57 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53793 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab0IFRww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 13:52:52 -0400
Date: Mon, 6 Sep 2010 23:16:42 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCHv11 2.6.36-rc2-tip 5/15]  5: uprobes: Uprobes
 (un)registration and exception handling.
Message-ID: <20100906174642.GG14891@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
 <20100825134224.5447.89998.sendpatchset@localhost6.localdomain6>
 <1283377414.2059.1729.camel@laptop>
 <20100903164219.GB1904@linux.vnet.ibm.com>
 <1283534349.2050.297.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1283534349.2050.297.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-09-03 19:19:09]:

> > 
> > However I would have an issue with making inode based probing the
> > default.
> > 1. Making all probing based on inode can be a performance hog.
> 
> How so? You can add filters if you want.

The breakpoint exception and singlestep account for a substaintial time
of the uprobes probe handling. With increasing number of breakpoint hits and singlesteps, wouldnt the overall load increase?

> 
> > 2. Since unlike kernel space, every process has a different space, so
> > why would we have to insert breakpoints in each of its process space if
> > we are not interested in them.
> 
> You don't have to, but you can. The problem I have with this stuff is
> that it makes the pid thing a primary interface, whereas it should be
> one of many filter possibilities.

I think the otherway, 
Why instrument a process and filter it out, if we are not interested in it.
While instrumenting kernel, we dont have this flexibility. So
having a pid based filter is the right thing to do for kernel
based tracing.

If we can get the per process based tracing right, we can build
higher lever stuff including the file based tracing easily.

All tools/debuggers in the past have all worked with process based
tracing.

Tools like gdb can actually use the displaced singlestepping
feature that uprobes provides. Some gdb developers have told on LKML
earlier that they would be willing to use displaced singlestepping if
the kernel provides an API that they can use.

Also about the security perspective when allowing normal users use
perf to trace their applications. Using this model, we dont have to
write extra filters to limit them. These filters might allow uprobe
handlers on only tasks belonging to that user. However it still
interrupts task of other users. And as I said earlier, breakpoint
exception and singlestepping actually make a very very substantial part
of the handling. The actual uprobe handler depending on what it does
might actually be very minimal part of the uprobe probe handling.

> > > > +	 */
> > > > +	pid_t pid;
> > > 
> > > Would fail for pid namespaces I guess...
> > 
> > Can you explain a bit more?
> 
> What pid namespace will you interpret that number in?

Same namespace as the requestor. i.e whichever name space
register_uprobe/unregister_uprobe is called.

> > 
> > Unlike kernel probing, uprobes has a disadvantage.
> > Lets assume that the request for removing a probepoint when some of the
> > threads have actually hit the probe. Because the handlers in uprobes can
> > sleep, we cant remove the probepoint at the same time as the request for
> > the removing the probe. This is where refcount steps in and helps us to
> > decide when we can remove the probepoint. Even inoode based
> > tracing or file based tracing would need it.
> 
> Stick the refcount in the actual struct uprobe instead?

What if the called does something like this when one or more
threads are processing the breakpoint.
unregister_uprobe(u);
kfree(u);

In the current implementation, the probepoint structure might be
released much later after the uprobe structure is released.
Unlike uprobe struct, probepoint structure is allocated by uprobes
sub-system and it knows how to release it cleanly. However we dont have
any idea about when and how uprobe struct can be released.

> > 
> > state is needed so that we know at do_notify_resume time whether the
> > thread should singlestep or has already singlestep.
> > Do you see a way to determine in do_notify_resume if the thread is
> > singlestepping or not. I dont think the instruction pointer can
> > determine if we are about to singlestep or have already singlestepped.
> 
> The to singlestep or not would be implied by the IP pointing to the
> start of a slot or not, but yes, I guess that as long as you do
> singlestep you need some state.. sucks though. Boosted probes are much
> nicer, they don't need that extra arch storage either, they can simply
> push/pop the register.

Yes, I agree, we may not need the state after boosted probes.
I am not sure at this time if we can do boosted probes for all
instructions. I think we can discuss about boosted probes later.

> > > > +
> > > > +/* Guards lookup, creation, and deletion of uproc. */
> > > > +static DEFINE_MUTEX(uprobe_mutex);
> > > 
> > > uproc is per mm, why a global mutex?
> > 
> > yes, uproc is per mm but gets created when the first probe on that
> > process gets registered.
> > Do you have anyother lock that you have in mind?
> > I could have used the mmap_sem, but I am not sure if we should be taking
> > a write lock on the mmap_sem.  
> 
> No particular other lock in mind, you could cmpxchg the pointer if
> that's all you need it for. The problem is that if you want inode based
> probes without a filter this will become a rather hot lock on fork().
> 

I can certainly try cmpxchg(). 

> > 
> > We dropped running the handler in interrupt context based on comments to
> > my previous postings. It not only makes it complex at the time of
> > handling the probe but we didnt see a difference when we compare the
> > time it took to run the handler in task context to running the handler
> > in interrupt context. I had even posted the timing info when
> > register_uprobes was exported. 
> 
> Is that because of the singlestep overhead? With boosted probes I would
> think it'd be much faster to take 1 trap, deal with it and continue
> execution, than to frob tons of kernel code in between.
> 

The difference between running handlers in task context and running in
interrupt context is the extra do_notify_resume() that gets called from
task context. But we have more guarantees, flexibility and less
complexity with running the handler from do_notify_resume than
running the handler in interrupt context. Since do_notify_resume is the
only extra thing that gets called (on the way out of the
interrupt), the difference in the penalties between running the
handler in task context and running the handler in interrupt
context is negligible.

I would want to stick with running handlers in task context for now.
We could optimize this later on depending on further results and
uprobes maturing.

> 
> 
> A bit more about these filter thingies, add a method to struct uprobe,
> something like int uprobe::wants_probe(struct task_struct *p) and add a
> single bit to task_struct (there's a few bitfields with holes in there).
> 
> The on clone()/mmap() call the relevant wants_probe() methods, if one is
> true, set the task_struct::has_uprobe flag and install the probes.
> 
> If nothing in the process wants probing, you'll never install the probes
> and nothing ever triggers, of only one of many tasks in the process gets
> tagged, you'll have to look up the probe anyway to know where to
> continue, but you can avoid calling the handler.
> 

Yes, we can avoid calling the handler. but we still have the other
penalties of breakpoint hit, searching the probe, and
singlestepping. Just to clarify, I am not looking at probing per task
but probing per process. So the pid field in uprobe refers to the
tgid.

--
Thanks and Regards
Srikar

