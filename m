Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab1CBGre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 01:47:34 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:50330 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751035Ab1CBGrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 01:47:33 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18UFYMASakUZTXlWg9+jxzbY9oYk6/GSPdCitX2KC
	xcF+a4Da2KAhTg
Subject: Re: [PATCH] sched: next buddy hint on sleep and preempt path
From: Mike Galbraith <efault@gmx.de>
To: Paul Turner <pjt@google.com>
Cc: Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>
In-Reply-To: <AANLkTinyAyXCH6sh9pOe36dCeTO_C8wbtmZriKanGtt3@mail.gmail.com>
References: <1299022433-17233-1-git-send-email-venki@google.com>
	 <AANLkTinyAyXCH6sh9pOe36dCeTO_C8wbtmZriKanGtt3@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 07:47:27 +0100
Message-ID: <1299048447.11469.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 21:43 -0800, Paul Turner wrote:
> On Tue, Mar 1, 2011 at 3:33 PM, Venkatesh Pallipadi <venki@google.com> wrote:

> >        for_each_sched_entity(se) {
> >                cfs_rq = cfs_rq_of(se);
> >                dequeue_entity(cfs_rq, se, flags);
> >
> >                /* Don't dequeue parent if it has other entities besides us */
> > -               if (cfs_rq->load.weight)
> > +               if (cfs_rq->load.weight) {
> > +                       /*
> > +                        * Bias pick_next to pick a task from this cfs_rq, as
> > +                        * p is sleeping when it is within its sched_slice.
> > +                        */
> > +                       if (task_flags & DEQUEUE_SLEEP && se->parent)
> > +                               set_next_buddy(se->parent);
> 
> re-using the last_buddy would seem like a more natural fit here; also
> doesn't have a clobber race with a wakeup

Hm, that would break last_buddy no?  A preempted task won't get the CPU
back after light preempting thread deactivates.  (it's disabled atm
unless heavily overloaded anyway, but..) 

This wants a tweak either way though.

static inline struct task_struct *task_of(struct sched_entity *se)
{
#ifdef CONFIG_SCHED_DEBUG
        WARN_ON_ONCE(!entity_is_task(se));
#endif
        return container_of(se, struct task_struct, se);
}

static void set_next_buddy(struct sched_entity *se)
{
        if (likely(task_of(se)->policy != SCHED_IDLE)) {
                for_each_sched_entity(se)
                        cfs_rq_of(se)->next = se;
        }
}

