Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab0CYMOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:14:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab0CYMOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:14:50 -0400
Date: Thu, 25 Mar 2010 13:12:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Balbir Singh <balbir@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Spencer Candland <spencer@bluehost.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 2/2] cputimers/proc:
	do_task_stat()->thread_group_times() is racy and O(n) under
	->siglock
Message-ID: <20100325121250.GA3664@redhat.com>
References: <20100324204554.GA31780@redhat.com> <1269464082.12097.3.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269464082.12097.3.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24, Peter Zijlstra wrote:
>
> On Wed, 2010-03-24 at 21:45 +0100, Oleg Nesterov wrote:
> > Nowadays ->siglock is overloaded, it would be really nice to change
> > do_task_stat() to walk through the list of threads lockless. And note
> > that we are doing while_each_thread() twice!
> >
> > while_each_thread() is rcu-safe, but thread_group_times() also needs
> > ->siglock to serialize the modifications of signal_struct->prev_Xtime
> > members.

First of all, let me reply to myself. I see that I wasn't clear at all.

This patch does the first step to remove one reason for ->siglock
(modification of ->prev_Xtime). But this is very minor, I guess we
could change thread_group_times() to take signal->cputimer->lock.

The goal was to call thread_group_cputime() lockless under rcu lock
(either directly, or via thread_group_times(), this doesn't matter)
to avoid while_each_thread() under ->siglock.

And in this case /proc/pid/stat can't report utime/stime atomically.
Whatever we do we can race with exit, so it doesn't make sense to
play with ->prev_Xtime.

> Right, so from what I remember the issue is that, yes top et al rely on
> that monotonicity,

Really?  So, do you think the change above will break user-space?

How sad :/

> but more importantly I think
> clock_gettime(CLOCK_PROCESS_CPUTIME_ID) should indeed use ->siglock to
> ensure it serializes against do_exit() so that either we iterate the
> thread or get the accumulated runtime from signal_struct but not both
> (or neither).

Oh. I forgot everything I knew about posix-cpu-timers... But, it seems,
posix_cpu_clock_get() calls thread_group_cputime() under tasklist and
thus can't race with exit.

Oleg.

