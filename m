Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab1H2RQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:16:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454Ab1H2RQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:16:35 -0400
Date: Mon, 29 Aug 2011 19:12:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <paul@paulmenage.org>,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pm-freezer 3/4] freezer: check freezing() before
	leaving FROZEN state
Message-ID: <20110829171228.GA11339@redhat.com>
References: <20110829140418.GB18871@mtj.dyndns.org> <20110829140509.GC18871@mtj.dyndns.org> <20110829140549.GD18871@mtj.dyndns.org> <20110829163533.GB9973@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829163533.GB9973@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29, Oleg Nesterov wrote:
>
> On 08/29, Tejun Heo wrote:
> >
> > --- work.orig/kernel/freezer.c
> > +++ work/kernel/freezer.c
> > @@ -60,6 +60,7 @@ bool __refrigerator(bool check_kthr_stop
> >  	 */
> >  	spin_lock_irq(&freezer_lock);
> >  	current->flags |= PF_FROZEN;
> > +refreeze:
> >  	spin_unlock_irq(&freezer_lock);
> >
> >  	save = current->state;
> > @@ -78,8 +79,10 @@ bool __refrigerator(bool check_kthr_stop
> >  		schedule();
> >  	}
> >
> > -	/* leave FROZEN */
> > +	/* leave FROZEN after checking freezing() holding freezer_lock */
> >  	spin_lock_irq(&freezer_lock);
> > +	if (freezing(current))
> > +		goto refreeze;
>
> Looks like, you should move "save = current->state" up then.

Hmm. And afaics there is another problem. This can "livelock" if
check_kthr_stop && kthread_should_stop().

May be we should consolidate the freezer_lock's sections, something
like below?

Hmm. But I got lost a bit. Why do we need freezer_lock to set/clear
PF_FROZEN ? OK, the code below takes freezer_lock for freezing().
Is there any other reason?

Oleg.

bool __refrigerator(bool check_kthr_stop)
{
	/* Hmm, should we be allowed to suspend when there are realtime
	   processes around? */
	bool was_frozen = false;
	long save;

	save = current->state;
	pr_debug("%s entered refrigerator\n", current->comm);

	for (;;) {
		set_current_state(TASK_UNINTERRUPTIBLE);

		spin_lock_irq(&freezer_lock);
		current->flags |= PF_FROZEN;
		if (!freezing(current) ||
		    (check_kthr_stop && kthread_should_stop()))
			current->flags &= ~PF_FROZEN;
		spin_unlock_irq(&freezer_lock);

		if (!current->flags & PF_FROZEN)
			break;

		was_frozen = true;
		schedule();
	}

	spin_lock_irq(&current->sighand->siglock);
	recalc_sigpending(); /* We sent fake signal, clean it up */
	spin_unlock_irq(&current->sighand->siglock);

	pr_debug("%s left refrigerator\n", current->comm);
	/*
	 * Restore saved task state before returning.  The mb'd version
	 * needs to be used; otherwise, it might silently break
	 * synchronization which depends on ordered task state change.
	 */
	set_current_state(save);

	return was_frozen;
}

