Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab0HDNVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 09:21:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757820Ab0HDNU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 09:20:58 -0400
Date: Wed, 4 Aug 2010 15:17:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 2/2] CRED: Fix __task_cred()'s lockdep check and banner
	comment
Message-ID: <20100804131749.GA2139@redhat.com>
References: <20100729114549.29508.44899.stgit@warthog.procyon.org.uk> <20100729114555.29508.4525.stgit@warthog.procyon.org.uk> <20100802204000.GH2405@linux.vnet.ibm.com> <201008030055.o730tgXK091413@www262.sakura.ne.jp> <30552.1280828047@redhat.com> <AANLkTikwM0+cxJqgQ+N_svzyyc+FKreO8XPr8oYNh6OU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikwM0+cxJqgQ+N_svzyyc+FKreO8XPr8oYNh6OU@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Linus Torvalds wrote:
>
> On Tue, Aug 3, 2010 at 2:34 AM, David Howells <dhowells@redhat.com> wrote:
> >
> > A previous patch:
> >
> >        commit 8f92054e7ca1d3a3ae50fb42d2253ac8730d9b2a
> >        Author: David Howells <dhowells@redhat.com>
> >        Date:   Thu Jul 29 12:45:55 2010 +0100
> >        Subject: CRED: Fix __task_cred()'s lockdep check and banner comment

I am not sure I understand this patch.

__task_cred() checks rcu_read_lock_held() || task_is_dead(), and
task_is_dead(task) is ((task)->exit_state != 0).

OK, task_is_dead() is valid for, say, wait_task_zombie(). But
wait_task_stopped() calls __task_cred(p) without rcu lock and p is alive.
The code is correct, this thread can do nothing until we drop ->siglock.

> > fixed the lockdep checks on __task_cred().  This has shown up a place in the
> > signalling code where a lock should be held - namely that
> > check_kill_permission() requires its callers to hold the RCU lock.
>
> It's not just check_kill_permission(), is it? I thought we could do
> the "for_each_process()" loops with just RCU, rather than holding the
> whole tasklist_lock?

Yes, for_each_process() is rcu-safe by itself.

> So I _think_ that getting the RCU read-lock would
> make it possible to get rid of the tasklist_lock in there too? At
> least in kill_something_info().

As for kill_something_info(), I think yes. I even sent (iirc) the
protoptype patch a long ago. We can't just remove tasklist, we should
avoid the races fork/exit/exec in the kill(-1, SIG) case.

The same for kill_pgrp/__kill_pgrp_info(). We need tasklist to ensure
that nobody in this group can escape the signal. This seems solveable
too, it was even discussed a bit.

> > It's may be that it would be better to add RCU read lock calls in
> > group_send_sig_info() only, around the call to check_kill_permission().

I must admit, at first glance changing check_kill_permission() to take
rcu lock looks better to me.

> On the
> > other hand, some of the callers are either holding the RCU read lock already,
> > or have disabled interrupts,

Hmm. So, local_irq_disable() "officially" blocks rcu? It does in practice
(unless I missed the new version of RCU), but, say,  posix_timer_event()
takes rcu_read_lock() exactly because I thought we shouldn't assume that
irqs_disabled() acts as rcu_read_lock() ?

There are other examples of rcu_read_lock() under local_irq_disable().

> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -773,6 +773,7 @@ static void forget_original_parent(struct task_struct *father)
> >
> >        exit_ptrace(father);
> >
> > +       rcu_read_lock();
> >        write_lock_irq(&tasklist_lock);
> >        reaper = find_new_reaper(father);

No, this doesn't look right. find_new_reaper() can drop tasklist and sleep.

Besides, this patch conflicts with the change in -mm tree. And imho this
looks a bit as "action at a distance".

Oleg.

