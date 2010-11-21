Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab0KUPvP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 10:51:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab0KUPvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 10:51:14 -0500
Date: Sun, 21 Nov 2010 16:44:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] sched: automated per session task groups
Message-ID: <20101121154435.GA25966@redhat.com>
References: <20101121133744.GA10765@elte.hu> <20101121133919.GA10976@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101121133919.GA10976@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21, Ingo Molnar wrote:
>
> Btw., there's a small cleanup in the patch that i picked up (see below), and i also
> edited the commit log a bit - so you might want to pick up the version below.

I didn't read the patch in details, but a couple of nits...

> +static void
> +autogroup_move_group(struct task_struct *p, struct autogroup *ag)
> +{
> +	struct autogroup *prev;
> +	struct task_struct *t;
> +
> +	spin_lock(&p->sighand->siglock);

This needs spin_lock_irq(), ->siglock is irq-safe.

The same for other lockers, but:

> +static inline struct autogroup *autogroup_get(struct task_struct *p)
> +{
> +	struct autogroup *ag;
> +
> +	/* task may be moved after we unlock.. tough */
> +	spin_lock(&p->sighand->siglock);

This is called by fs/proc. In this case nothing protects us from
release_task(), we can hit ->siglock == NULL (or we can race with
exec which changes ->sighand in theory).

This needs lock_task_sighand() (it can fail). Perhaps something
else have the same problem...

If the task is current and it is not exiting, or it is the new
child (sched_autogroup_fork), then it is safe to use ->siglock
directly.

And a pure cosmetic nit,

> +void sched_autogroup_fork(struct signal_struct *sig)
> +{
> +     struct sighand_struct *sighand = current->sighand;
> +
> +     spin_lock(&sighand->siglock);
> +     sig->autogroup = autogroup_kref_get(current->signal->autogroup);
> +     spin_unlock(&sighand->siglock);
> +}

This looks a bit confusing. We do not need current->sighand->siglock
to set sig->autogroup. Nobody except us can see this new signal_struct,
and in any case current->sighand->siglock can't help.

It is needed for autogroup_kref_get(), but we already have autogroup_get().
I'd suggest

	void sched_autogroup_fork(struct signal_struct *sig)
	{
		sig->autogroup = autogroup_get(current);	
	}

Oleg.

