Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab1LIRBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:01:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab1LIRBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:01:08 -0500
Date: Fri, 9 Dec 2011 17:55:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Vagin <avagin@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v2
Message-ID: <20111209165536.GA25268@redhat.com>
References: <20111206181026.GO29781@moon> <20111207185343.GA3209@redhat.com> <20111207190340.GP21678@moon> <20111208163535.GA25023@redhat.com> <20111208212853.GO21678@moon> <20111208135430.00730308.akpm@linux-foundation.org> <20111209153009.GA20865@redhat.com> <20111209154930.GT21678@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111209154930.GT21678@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09, Cyrill Gorcunov wrote:
>
> On Fri, Dec 09, 2011 at 04:30:09PM +0100, Oleg Nesterov wrote:
> ...
> > >
> > > It is a potential problem, from the lock-hold point of view and
> > > also it can cause large scheduling latencies.  What's involved in
> > > making ->children an rcu-protected list?
> >
> > At first glance, this doesn't look trivial... forget_original_parent()
> > abuses ->sibling.
> >
>
> But wait, forget_original_parent may move task out of the original
> list and put it in dead_children list, right? Then release_task
> may call delayed_put_task_struct under as call_rcu which should
> wait until we finish reading in our rcu section, isn't it?
>
> Even if we get inconsistent picture of children (ie we get pid
> of shildren which just getting dead) I think it's fine.

The problen is (one of the problems, in fact), list_move() changes
->next.

To simplify, let's talk about children_seq_start() your patch adds.
Suppose that we make ->children/sibling "rcu-safe" (we replace
__unhash_process()->list_del_init() with list_del_rcu, and so on).

Now, children_seq_start() does:

	rcu_read_lock();

	list_for_each(child, task->children)
		...;

Suppose that this task exits and reparents the child we are looking at.
Once reparent_leader() moves it into another list, list_for_each()
can never stop.

In short. forget_original_parent() changes the _head_ of the list,
in some sense.

> > But yes, it is not really nice to hold tasklist_lock here. May be
> > we can change this code so that every iteration records the reported
> > task_struct and then tries to continue. This means we should verify
> > that ->real_parent is still the same under tasklist, but at least
> > this way we do not hold it throughout.
> >
>
> And if real_parent is changed,

... or if list_empty(->sibling) == T

> I should simply skip such task and
> continue, right?

I think you should restart in this (hopefully unlikely) case. Yes, this
means the potentional data loss, but I guess we can't avoid this in any
case. For example, with the current patch children_seq_start() can miss
the _live_ thread if the already reported process was reaped.

> > Personally I'd even prefer /proc/pid/children/ directory (like
> > /proc/pid/task), but I guess this needs much more complications.
> >
>
> I fear so. Oleg, if it possible I would like to bring in as minimum
> code as I can ;)

Yes, yes, I agree.

Oleg.

