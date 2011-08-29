Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab1H2RsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:48:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023Ab1H2RsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:48:08 -0400
Date: Mon, 29 Aug 2011 19:44:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 09/16] freezer: make freezing indicate freeze condition
	in effect
Message-ID: <20110829174440.GA12498@redhat.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-10-git-send-email-tj@kernel.org> <20110828175601.GB27032@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110828175601.GB27032@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28, Oleg Nesterov wrote:
>
> > @@ -44,7 +48,7 @@ bool __refrigerator(bool check_kthr_stop)
> >
> >  	for (;;) {
> >  		set_current_state(TASK_UNINTERRUPTIBLE);
> > -		if (!frozen(current) ||
> > +		if (!freezing(current) ||
> >  		    (check_kthr_stop && kthread_should_stop()))
> >  			break;
> >  		was_frozen = true;
> > @@ -54,6 +58,11 @@ bool __refrigerator(bool check_kthr_stop)
> >  	/* Remove the accounting blocker */
> >  	current->flags &= ~PF_FREEZING;
> >
> > +	/* leave FROZEN */
> > +	spin_lock_irq(&freezer_lock);
> > +	current->flags &= ~PF_FROZEN;
> > +	spin_unlock_irq(&freezer_lock);
>
> What if freezing() is true again when we are going to clear
> PF_FROZEN?

And another problem, afaics....

So. With this change frozen(p) == T even after __thaw_task().
PF_FROZEN will be cleared eventually, but we can't know when.

IOW, we can't trust frozen() unless freezing() == T.

This means update_if_frozen() can hit BUG_ON(nfrozen > 0) if
the caller is freezer_write().

Oleg.

