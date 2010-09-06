Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab0IFSZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 14:25:45 -0400
Received: from mail.openrapids.net ([64.15.138.104]:46998 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752216Ab0IFSZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 14:25:41 -0400
Date: Mon, 6 Sep 2010 14:25:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
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
Message-ID: <20100906182538.GA16735@Krystal>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6> <20100825134224.5447.89998.sendpatchset@localhost6.localdomain6> <1283377414.2059.1729.camel@laptop> <20100903164219.GB1904@linux.vnet.ibm.com> <1283534349.2050.297.camel@laptop> <20100906174642.GG14891@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100906174642.GG14891@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:11:32 up 226 days, 20:48,  4 users,  load average: 0.06, 0.12,
	0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Srikar Dronamraju (srikar@linux.vnet.ibm.com) wrote:
> * Peter Zijlstra <peterz@infradead.org> [2010-09-03 19:19:09]:
> 
> > > 
> > > However I would have an issue with making inode based probing the
> > > default.
> > > 1. Making all probing based on inode can be a performance hog.
> > 
> > How so? You can add filters if you want.
> 
> The breakpoint exception and singlestep account for a substaintial time
> of the uprobes probe handling. With increasing number of breakpoint hits and
> singlesteps, wouldnt the overall load increase?
> 
> > 
> > > 2. Since unlike kernel space, every process has a different space, so
> > > why would we have to insert breakpoints in each of its process space if
> > > we are not interested in them.
> > 
> > You don't have to, but you can. The problem I have with this stuff is
> > that it makes the pid thing a primary interface, whereas it should be
> > one of many filter possibilities.
> 
> I think the otherway, 
> Why instrument a process and filter it out, if we are not interested in it.
> While instrumenting kernel, we dont have this flexibility. So
> having a pid based filter is the right thing to do for kernel
> based tracing.
> 
> If we can get the per process based tracing right, we can build
> higher lever stuff including the file based tracing easily.
> 
> All tools/debuggers in the past have all worked with process based
> tracing.
> 
> Tools like gdb can actually use the displaced singlestepping
> feature that uprobes provides. Some gdb developers have told on LKML
> earlier that they would be willing to use displaced singlestepping if
> the kernel provides an API that they can use.
> 
> Also about the security perspective when allowing normal users use
> perf to trace their applications. Using this model, we dont have to
> write extra filters to limit them. These filters might allow uprobe
> handlers on only tasks belonging to that user. However it still
> interrupts task of other users. And as I said earlier, breakpoint
> exception and singlestepping actually make a very very substantial part
> of the handling. The actual uprobe handler depending on what it does
> might actually be very minimal part of the uprobe probe handling.

I think we are both partially right in slightly different ways. I think Peter is
right in that the PID should not be mandatory (e.g. specifying a PID of 0 should
apply to all tasks), and you are also right in that being able to apply the
"filter" directly at the executable image level is vital for performance.

So how about this: we can provide both task and inode selection arguments. The
task selection argument can be 0 (apply to all tasks) or non-zero (one task
specifically). The inode argument would be mandatory.

Then, eventually, we can enhance the generic filtering facility so it can be
made aware of filtering shortcuts provided by the instrumentation (in this case,
uprobes would provide a per-tgid filtering shortcut).

Thoughts ?

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
