Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1ACPA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 10:00:58 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36423 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab1ACPA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 10:00:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RKvDk1smvJTQBEbm2TUuQOZFN1Mc5qzmcHb5fr4wk3B7isgwTdYDvOgBwEZ8JLBBeM
         B/Up75JRY2tqTpD2D4RSQUzPgjYF8itWPxM+p1C4j4Dfzm/WpdR0hpaDeX7PJo48k7F/
         eFmBlvAeGZbG0iJIaI2gRt2dPVN7kSax150KU=
Date: Mon, 3 Jan 2011 16:00:52 +0100
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED] workqueue: relax lockdep annotation on
 flush_work()
Message-ID: <20110103150052.GU18831@htj.dyndns.org>
References: <20101229125711.GL488@htj.dyndns.org>
 <1294047091.2016.38.camel@laptop>
 <20110103141735.GQ18831@htj.dyndns.org>
 <1294066490.2016.81.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294066490.2016.81.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 03, 2011 at 03:54:50PM +0100, Peter Zijlstra wrote:
> On Mon, 2011-01-03 at 15:17 +0100, Tejun Heo wrote:
> 
> > @@ -2384,8 +2384,18 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
> >  	insert_wq_barrier(cwq, barr, work, worker);
> >  	spin_unlock_irq(&gcwq->lock);
> >  
> > -	lock_map_acquire(&cwq->wq->lockdep_map);
> > +	/*
> > +	 * If @max_active is 1 or rescuer is in use, flushing another work
> > +	 * item on the same workqueue may lead to deadlock.  Make sure the
> > +	 * flusher is not running on the same workqueue by verifying write
> > +	 * access.
> > +	 */
> > +	if (cwq->wq->saved_max_active == 1 || cwq->wq->flags & WQ_RESCUER)
> > +		lock_map_acquire(&cwq->wq->lockdep_map);
> > +	else
> > +		lock_map_acquire_read(&cwq->wq->lockdep_map);
> >  	lock_map_release(&cwq->wq->lockdep_map);
> > +
> >  	return true;
> >  already_gone:
> >  	spin_unlock_irq(&gcwq->lock);
> 
> Ah, but this violates the rule that you must always use the most strict
> constraints. Code doesn't know if it will run in a rescue thread or not,
> hence it must assume it does.

Hmmm?  The code applies the most strict contraints.  If the workqueue
has a rescuer, flushing another work from the workqueue will always
trigger lockdep warning.  The rule is relaxed only for workqueues
which aren't used for memory reclaiming && support parallel execution.

Thanks.

-- 
tejun
