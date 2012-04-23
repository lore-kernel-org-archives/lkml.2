Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab2DWUv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:51:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab2DWUv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:51:58 -0400
Date: Mon, 23 Apr 2012 22:50:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Subject: Re: [RFC 0/6] uprobes: kill uprobes_srcu/uprobe_srcu_id
Message-ID: <20120423205049.GA7831@redhat.com>
References: <20120415234401.GA32662@redhat.com> <1334571419.28150.30.camel@twins> <20120416214707.GA27639@redhat.com> <1334916861.2463.50.camel@laptop> <20120420183718.GA2236@redhat.com> <1335165240.28150.89.camel@twins> <20120423072445.GC8357@linux.vnet.ibm.com> <1335166842.28150.92.camel@twins> <20120423172957.GA29708@redhat.com> <1335208690.2463.84.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335208690.2463.84.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Peter Zijlstra wrote:
>
> On Mon, 2012-04-23 at 19:29 +0200, Oleg Nesterov wrote:
> >
> > I agree with Srikar this doesn't look simple to me. First of all,
> > currently it is not easy to find the tasks which use this ->mm.
> > OK, we can simply do for_each_process() under tasklist, but this is
> > not very nice.
> >
> > But again, to me this is not the main problem.
>
> CLONE_VM without CLONE_THREAD is the problem, right?

Not even CLONE_VM without CLONE_THREAD... And perhaps I overestimate
the problem, I dunno. Just it seems to me there are to many "details"
we should discuss to make the filtering reasonable.

> Can we get away with not supporting that, at least initially?

I dunno. But yes, in this case one of the problems goes away, no
need to find all mm users. We need to find at least one task which
uses this mm if we want to pass its task_struct to ->filter(),
perhaps we can rely on mm->owner.

> > But the whole idea of filtering is not clear to me. I mean, when/how
> > we should call the filter, and what should be the argument.
> > task_struct? Probably, but I am not sure.
>
> Well, the idea is really very simple: if for a probe an {mm,tasks} set
> has all negative filters we do not install the probe on that mm.

Sure, but this is not enough. Assuming you mean uprobe_register().
And note that in this case we have a single uprobe.

We already discussed fork()->dup_mmap() a bit. However mmap needs
to call the filter too. Otherwise, how can you probe, say, some
function in /bin/true (with filtering)? By the time uprobe_register()
is called nobody mmaps this file.

Now potentionally we have multiple uprobes, each should be consulted..
OK, if we ignore "CLONE_VM without CLONE_THREAD" this is not that
bad probably.

> The filters already take a uprobe_consumer and task_struct as argument.

Yes, and probably this makes sense for handler_chain(). Although otoh
I do not really understand what this filter buys us at this point.
And note that this task is current.

But if we call ->filter() from, say, uprobe_register(), should we call
it for each thread? This looks strange a bit. Perhaps we should do
this only once and pass the group_leader. And then we need more locking,
say to avoid the races with exec/exit. So may be we should simply pass
tgid for example, I dunno.

> > And we need to rework uprobe_register(). It can't simply return if
> > this (inode, offset) already has the consumer.
>
> Not quite sure what you mean. uprobe_register() doesn't have such a
> return value.

Yes, I wasn't clear.

Suppose we have a consumer which wants to probe, say, sys_getpid()
and its ->filter() only wants to trace the task T1. So _register()
installs the breakpoint into T1->mm.

Then comes another consumer which wants to trace the task T2, but
(inode, offset) is the same: sys_getpid() from libc.

Now. Currently the 2nd uprobes_register() does nothing. It finds
the old uprobe we already have and assumes that all we need is to
add the new consumer to uprobe->consumers list.

If we add the filtering, we need register_for_each_vma() in this
case too, but it would be nice to skip the mm_struct's which were
already "acked" by the previous consumers and thus already have
this breakpoint installed.

Or, somehow we need to know that this int3 in this mm was inserted
by this uprobe. Currently this doesn't really matter (afaics), but
it seems that the current -EXIST logic is not exactly correct.

And uprobe_register() probably needs the changes too. Suppose that
the first consumer does uprobe_unregister(). Currently this only
removes the consumer, but with the filtering we probably want to
cleanup T1->mm.

Oleg.

