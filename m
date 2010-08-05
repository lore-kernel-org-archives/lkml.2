Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081Ab0HESUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 14:20:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521Ab0HESUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 14:20:08 -0400
Date: Thu, 5 Aug 2010 20:16:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/2] CRED: Fix __task_cred()'s lockdep check and banner
	comment
Message-ID: <20100805181652.GA27671@redhat.com>
References: <20100729114549.29508.44899.stgit@warthog.procyon.org.uk> <20100729114555.29508.4525.stgit@warthog.procyon.org.uk> <20100802204000.GH2405@linux.vnet.ibm.com> <201008030055.o730tgXK091413@www262.sakura.ne.jp> <30552.1280828047@redhat.com> <AANLkTikwM0+cxJqgQ+N_svzyyc+FKreO8XPr8oYNh6OU@mail.gmail.com> <m1d3txzfuq.fsf@fess.ebiederm.org> <AANLkTikavQKkvmdY5=8jh8KSV7vit=WcmDHWjnZfVWnv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikavQKkvmdY5=8jh8KSV7vit=WcmDHWjnZfVWnv@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05, Linus Torvalds wrote:
>
> On Thu, Aug 5, 2010 at 12:19 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
> >
> > No.  When we send a signal to multiple processes it needs to be an
> > atomic operation so that kill -KILL -pgrp won't let processes escape.
> > It is what posix specifies, it is what real programs expect, and it
> > is the useful semantic in userspace.
>
> Ok. However, in that case, it's not really about the whole list
> traversal, it's a totally separate thing, and it's really sad that we
> end up using the (rather hot) tasklist_lock for something like that.
> With the dcache/inode locks basically going away, I think
> tasklist_lock ends up being one of the few hot locks left.
>
> Wouldn't it be much nicer to:
>  - make it clear that all the "real" signal locking can rely on RCU
>  - use a separate per-pgrp lock that ends up being the one that gives
> the signal _semantic_ meaning?
>
> That would automatically document why we get the lock too, which
> certainly isn't clear from the code as-is.
>
> The per-pgrp lock might be something as simple as a silly hash that
> just spreads out the process groups over some random number of simple
> spinlocks.

I still think we can avoid the new lock and rely on RCU in
kill_something_info() and kill_pgrp().

I am attaching my old email below. It talks about pgrp, however I
think kill_something_info() is almost the same thing.

Oleg.

On 12/07, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > On 12/05, Eric W. Biederman wrote:
> >>
> >> Atomically sending signal to every member of a process group, is the
> >> big fly in the ointment I am aware of.  Last time I looked I could
> >> not see how to convert it rcu.
> >
> > I am not sure, but iirc we can do this lockless (under rcu_lock).
> > We need to modify pid_link to use list_entry and attach_pid() should
> > add the new task to the end. Of course we need more changes, but
> > (again iirc) this is not too hard.
>
> The problem is that even adding to the end of the list, we could run
> into a deleted entry and not see the new end of the list.
>
> Suppose when we start iterating the list we have:
>
>   A -> B -> C -> D
>
> Then someone deletes some of the entries while we are iterating the list.
>
> A ->
>  B' -> C' -> D'
>
> We will continue on traversing through the deleted entries.
>
> Then someone adds a new entry to the end of the list.
>
> A-> N
>
> Since we are at B', C' or D' we will never see the new entry on the
> end of the list.

Yes, but who can add the new entry?

Let's forget about setpgrp/etc for the moment, I think we have "races"
with or without tasklist. Say, setpgrp() can add the new process to the
already "killed" pgrp.

Then, I think the only important case is SIGKILL/SIGSTOP (or other
signals which can't be blockes/ignored). We must kill/stop the entire
pgrp, we must not race with fork() and miss a child.

In this case I _think_ rcu_read_lock() is enough,

	rcu_read_lock()

	list_for_each_entry_rcu(task, pid->tasks[PIDTYPE_PGID)
		group_send_sig_info(sig, task);

	rcu_read_unlock();

except group_send_sig_info() can race with mt-exec, but this is simple
to fix.

If we send a signal (not necessary SIGKILL) to a process P, we must see
all childs which were forked by P, both send_signal() and copy_process()
take the same ->siglock, we must see the result of list_add_tail_rcu().
And, after we sent SIGKILL/SIGSTOP, it can't fork the new child.

If list_for_each_entry() does not see the exited process P, this means
we see the result of list_del_rcu(). But this also means we must the
the result of the previous list_add_rcu().

IOW, fork+exit means list_add_rcu() + wmb() + list_del_rcu(), if we
don't see the new entry on list, we must see the new one, right?

(I am ignoring the case when list_for_each_entry_rcu() sees a process
 P but lock_task_sighand(P) fails, I think this is the same as if we
 we missed P)

Now suppose a signal is blocked/ignored or has a handler. In this case
we can miss a child, but I think this is OK, we can pretend the new
child was forked after kill_pgrp() completes. Say, this child C was
forked by some process P. We can miss C only if it was forked after
we already sent the signal to P.

However. I do not pretend the reasoning above is "complete", and
perhaps I missed something else.

> Additionally we have the other possibility that if a child is forking
> we send the signal to the parent after the child forks away but before
> the child joins whichever list we are walking, and we complete our
> traversal without seeing the child.

Not sure I understand... But afaics this case is covered above.
->siglock should serialize this, copy_process() does attach_pid()
under this lock.

Oleg.

