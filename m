Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0KUQgJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 11:36:09 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:42502 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754336Ab0KUQgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 11:36:08 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/EgSl4mLjENYVtts2sBByKGytoFRdrQrOdgC+Vnm
	rZrbV1F4u8tRFx
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101121154435.GA25966@redhat.com>
References: <20101121133744.GA10765@elte.hu>
	 <20101121133919.GA10976@elte.hu>  <20101121154435.GA25966@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Nov 2010 09:35:49 -0700
Message-ID: <1290357349.4816.31.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-21 at 16:44 +0100, Oleg Nesterov wrote:
> On 11/21, Ingo Molnar wrote:
> >
> > Btw., there's a small cleanup in the patch that i picked up (see below), and i also
> > edited the commit log a bit - so you might want to pick up the version below.
> 
> I didn't read the patch in details, but a couple of nits...
> 
> > +static void
> > +autogroup_move_group(struct task_struct *p, struct autogroup *ag)
> > +{
> > +	struct autogroup *prev;
> > +	struct task_struct *t;
> > +
> > +	spin_lock(&p->sighand->siglock);
> 
> This needs spin_lock_irq(), ->siglock is irq-safe.

Ok.

> The same for other lockers, but:
> 
> > +static inline struct autogroup *autogroup_get(struct task_struct *p)
> > +{
> > +	struct autogroup *ag;
> > +
> > +	/* task may be moved after we unlock.. tough */
> > +	spin_lock(&p->sighand->siglock);
> 
> This is called by fs/proc. In this case nothing protects us from
> release_task(), we can hit ->siglock == NULL (or we can race with
> exec which changes ->sighand in theory).

Oh my.  Thanks.

(gad, signal_struct is sooo much harder to get right)

> This needs lock_task_sighand() (it can fail). Perhaps something
> else have the same problem...
> 
> If the task is current and it is not exiting, or it is the new
> child (sched_autogroup_fork), then it is safe to use ->siglock
> directly.

Ok,

> And a pure cosmetic nit,
> 
> > +void sched_autogroup_fork(struct signal_struct *sig)
> > +{
> > +     struct sighand_struct *sighand = current->sighand;
> > +
> > +     spin_lock(&sighand->siglock);
> > +     sig->autogroup = autogroup_kref_get(current->signal->autogroup);
> > +     spin_unlock(&sighand->siglock);
> > +}
> 
> This looks a bit confusing. We do not need current->sighand->siglock
> to set sig->autogroup. Nobody except us can see this new signal_struct,
> and in any case current->sighand->siglock can't help.
> 
> It is needed for autogroup_kref_get(), but we already have autogroup_get().
> I'd suggest
> 
> 	void sched_autogroup_fork(struct signal_struct *sig)
> 	{
> 		sig->autogroup = autogroup_get(current);	
> 	}

I'll do that.. once the thing is non-toxic to tip.

Thanks a lot Oleg.

	-Mike

