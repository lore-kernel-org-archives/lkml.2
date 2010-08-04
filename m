Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab0HDPLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 11:11:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab0HDPLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 11:11:14 -0400
Date: Wed, 4 Aug 2010 17:08:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 2/2] CRED: Fix __task_cred()'s lockdep check and banner
	comment
Message-ID: <20100804150805.GA5634@redhat.com>
References: <20100804131749.GA2139@redhat.com> <20100729114549.29508.44899.stgit@warthog.procyon.org.uk> <20100729114555.29508.4525.stgit@warthog.procyon.org.uk> <20100802204000.GH2405@linux.vnet.ibm.com> <201008030055.o730tgXK091413@www262.sakura.ne.jp> <30552.1280828047@redhat.com> <AANLkTikwM0+cxJqgQ+N_svzyyc+FKreO8XPr8oYNh6OU@mail.gmail.com> <23577.1280930470@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <23577.1280930470@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 08/03, Linus Torvalds wrote:
> > >
> > > On Tue, Aug 3, 2010 at 2:34 AM, David Howells <dhowells@redhat.com> wrote:
> > > >
> > > > A previous patch:
> > > >
> > > >        commit 8f92054e7ca1d3a3ae50fb42d2253ac8730d9b2a
> > > >        Author: David Howells <dhowells@redhat.com>
> > > >        Date:   Thu Jul 29 12:45:55 2010 +0100
> > > >        Subject: CRED: Fix __task_cred()'s lockdep check and banner comment
> >
> > I am not sure I understand this patch.
>
> You are talking about the 'previous patch'?
>
> > __task_cred() checks rcu_read_lock_held() || task_is_dead(), and
> > task_is_dead(task) is ((task)->exit_state != 0).
> >
> > OK, task_is_dead() is valid for, say, wait_task_zombie(). But
> > wait_task_stopped() calls __task_cred(p) without rcu lock and p is alive.
> > The code is correct, this thread can do nothing until we drop ->siglock.
>
> The problem is that we have to tell lockdep this.  Just checking in
> __task_cred() that siglock is held is insufficient.  That doesn't handle, say,
> sys_setuid() from changing the credentials, and effectively skips the check in
> places where it mustn't.
>
> Similarly, having interrupts disabled on the CPU we're running on doesn't help
> either, since it doesn't stop another CPU replacing those credentials.
>
> There are ways of dealing with wait_task_stopped():
>
>  (1) Place an rcu_read_lock()'d section around the call to __task_cred().

Sure, this solves the problem. But probably this needs a comment to
explain why do we take rcu lock.

OTOH, wait_task_continued() does need rcu_read_lock(), the task is running.

UNLESS we believe that local_irq_disable() makes rcu_read_lock() unnecessary,
see below.

>  (2) Make __task_cred()'s lockdep understand about the target task being
>      stopped whilst we hold its siglock.

May be... but we have so many special cases. Say, fill_psinfo()->__task_cred().
This is called under rcu lock, but it is not needed. The task is either
current or it sleeps in exit_mm().

I mean, perhaps it is better to either always require rcu_read_lock()
around __task_cred() even if it is not needed, or do not use
rcu_dereference_check() at all.

In any case, task_is_dead() doesn't help afaics, it is only useful for
wait_task_zombie().

> > I must admit, at first glance changing check_kill_permission() to take
> > rcu lock looks better to me.
>
> I think group_send_sig_info() would be better.  The only other caller of
> c_k_p() already has to hold the RCU read lock for other reasons.
>
> How about the attached patch then?

Agreed, the patch looks fine to me.

> > > > On the other hand, some of the callers are either holding the RCU read
> > > > lock already, or have disabled interrupts,
> >
> > Hmm. So, local_irq_disable() "officially" blocks rcu? It does in practice
> > (unless I missed the new version of RCU), but, say,  posix_timer_event()
> > takes rcu_read_lock() exactly because I thought we shouldn't assume that
> > irqs_disabled() acts as rcu_read_lock() ?
>
> This CPU can't be preempted if it can't be interrupted, I think.

Yes, please note "It does in practice" above.

My question is, should/can we rely on this fact? Or should we assume
that nothing except rcu_read_lock() implies rcu_read_lock() ?

Oleg.

