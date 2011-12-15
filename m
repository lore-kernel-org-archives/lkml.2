Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942Ab1LOSnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 13:43:43 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:58383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1LOSnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 13:43:41 -0500
Subject: Re: workqueue_set_max_active(wq, 0)?
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20111215183537.GA32002@google.com> (sfid-20111215_193615_022231_7F17D027)
References: <1323424482.3622.8.camel@jlt3.sipsolutions.net>
	 <20111209165702.GD12108@google.com>
	 <1323963492.23550.1.camel@jlt3.sipsolutions.net>
	 <20111215183537.GA32002@google.com> (sfid-20111215_193615_022231_7F17D027)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 19:43:40 +0100
Message-ID: <1323974620.1082.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > @@ -51,6 +51,7 @@ enum {
> >  	GCWQ_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
> >  	GCWQ_FREEZING		= 1 << 3,	/* freeze in progress */
> >  	GCWQ_HIGHPRI_PENDING	= 1 << 4,	/* highpri works on queue */
> > +	GCWQ_PAUSING		= 1 << 5,
> 
> Hmmm... confused.  Pausing is per-wq, why is this flag on gcwq?
> Shouldn't it be on workqueue_struct?

Hm, no idea :-)
I just copied FREEZING really without knowing what I was doing. I'm not
very familiar with this code (yet).

> > +void pause_workqueue(struct workqueue_struct *wq)
> > +{
> > +	unsigned int cpu;
> > +
> > +	for_each_cwq_cpu(cpu, wq) {
> > +		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
> > +		struct global_cwq *gcwq = cwq->gcwq;
> > +
> > +		spin_lock_irq(&gcwq->lock);
> > +
> > +		WARN_ON(gcwq->flags & GCWQ_PAUSING);
> > +		gcwq->flags |= GCWQ_PAUSING;
> > +
> > +		cwq->max_active = 0;
> > +
> > +		spin_unlock_irq(&gcwq->lock);
> > +	}
> > +
> > +	wait_event(wq->waitq, count_active(wq) == 0);
> > +}
> > +EXPORT_SYMBOL(pause_workqueue);
> 
> What if there are multiple callers of this function on the same wq?
> Maybe something like wq->pause_depth and also use it from freeze path?

Hm, good point. We can't abstract out all of it -- the freezer API
doesn't want to wait for it to finish -- but probably a bit of it.

How do you iterate workqueues? We'd have to do that for the freezer
part, unless we want to work on CWQs again.

Actually I'm not really sure I understand the differences between WQ,
CWQ and GCWQ...

> > +void resume_workqueue(struct workqueue_struct *wq)
> > +{
> > +	unsigned int cpu;
> > +
> > +	for_each_cwq_cpu(cpu, wq) {
> > +		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
> > +		struct global_cwq *gcwq = cwq->gcwq;
> > +
> > +		spin_lock_irq(&gcwq->lock);
> > +
> > +		WARN_ON(!(gcwq->flags & GCWQ_PAUSING));
> > +		gcwq->flags &= ~GCWQ_PAUSING;
> > +
> > +		cwq->max_active = wq->saved_max_active;
> > +
> > +		wake_up_worker(gcwq);
> > +		spin_unlock_irq(&gcwq->lock);
> > +	}
> > +}
> > +EXPORT_SYMBOL(resume_workqueue);
> 
> I don't think wake_up_worker() would be sufficient.
> cwq_activate_first_delayed() needs to be called to kick the delayed
> work items.

Hm, ok.

> I think it would be great if this can be abstracted out so that both
> the freezer and explicit pausing use the same facility.  They aren't
> that different after all.

I'll take a look tomorrow. If you want to beat me to it ... ;-)

johannes

