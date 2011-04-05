Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1DEXQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 19:16:05 -0400
Received: from smtp-out.google.com ([74.125.121.67]:6258 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab1DEXQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 19:16:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=r64avOd/SbfLgDuvDiZaHCFh+/CFxrxfESpSuO/TKdqgpksnWH3rARKfUeTJ3M9ADh
         Ql9CGnAXbQYR+SEG6vLA==
MIME-Version: 1.0
In-Reply-To: <1302010100.2225.1333.camel@twins>
References: <20110323030326.789836913@google.com> <20110323030449.047028257@google.com>
 <1302010100.2225.1333.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Tue, 5 Apr 2011 16:15:27 -0700
Message-ID: <BANLkTikBqOitKTKHq_FKcqvxkypU1g+zAw@mail.gmail.com>
Subject: Re: [patch 04/15] sched: throttle cfs_rq entities which exceed their
 local quota
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 6:28 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Tue, 2011-03-22 at 20:03 -0700, Paul Turner wrote:
>
> > @@ -1249,6 +1257,9 @@ entity_tick(struct cfs_rq *cfs_rq, struc
> >        */
> >       update_curr(cfs_rq);
> >
> > +     /* check that entity's usage is still within quota (if enabled) */
> > +     check_cfs_rq_quota(cfs_rq);
> > +
> >       /*
> >        * Update share accounting for long-running entities.
> >        */
>
> You already have a hook in update_curr() to account quota, why not also
> use that to trigger the reschedule? request_cfs_rq_quota() already has
> the information we failed to replenish the local quota.
>
> Then when you've gotten rid of check_cfs_rq_quota() there isn't a second
> user of within_bandwidth() and you can fold:
>

This actually what it looked like originally, but I broke it apart to
avoid a spurious need_resched coming from the put_path.

Looking again I realize we actually arbitrarily
clear_tsk_need_resched() on prev out of schedule() now so this isn't a
concern.

>
> > @@ -1230,6 +1233,9 @@ static void put_prev_entity(struct cfs_r
> >       if (prev->on_rq)
> >               update_curr(cfs_rq);
> >
> > +     if (!within_bandwidth(cfs_rq))
> > +             throttle_cfs_rq(cfs_rq);
> > +
> >       check_spread(cfs_rq, prev);
> >       if (prev->on_rq) {
> >               update_stats_wait_start(cfs_rq, prev);
>
> Into a single hook.
>
> > @@ -1447,10 +1544,15 @@ static void dequeue_task_fair(struct rq
> >         for_each_sched_entity(se) {
> >                 cfs_rq = cfs_rq_of(se);
> >                 dequeue_entity(cfs_rq, se, flags);
> > -
> > +               /* end evaluation on throttled cfs_rq */
> > +               if (cfs_rq_throttled(cfs_rq)) {
> > +                       se = NULL;
> > +                       break;
> > +               }
> >                 /* Don't dequeue parent if it has other entities besides us */
> >                 if (cfs_rq->load.weight)
> >                         break;
> > +               check_cfs_rq_quota(cfs_rq);
> >                 flags |= DEQUEUE_SLEEP;
> >         }
>
> dequeue_entity() calls update_curr(), so again, by folding
> check_cfs_rq_quota() into your update_curr() hook this becomes simpler.
>

Yes I preferred it as a single hook out of update_curr, will put it
back that way :)

> > +static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
> > +{
> > +       struct task_group *tg;
> > +       struct sched_entity *se;
> > +
> > +       if (cfs_rq_throttled(cfs_rq))
> > +               return 1;
> > +
> > +       tg = cfs_rq->tg;
> > +       se = tg->se[cpu_of(rq_of(cfs_rq))];
> > +       if (!se)
> > +               return 0;
> > +
> > +       for_each_sched_entity(se) {
> > +               if (cfs_rq_throttled(cfs_rq_of(se)))
> > +                       return 1;
> > +       }
> > +
> > +       return 0;
> > +}
>
> You can actually call for_each_sched_entity() with se==NULL, saves a few lines.

True enough, although this is subsequently subverted by throttle_count
