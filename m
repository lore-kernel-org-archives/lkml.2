Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab0I1W5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 18:57:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12353 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab0I1W5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 18:57:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wqQCcEkeHS3KfStMYdbASChl8hlzamgoFKUGHxvRmtgJVr3y2+16NVKkVZTtESQzwR
         uXvdbXUFBTnn6JUi3Qug==
MIME-Version: 1.0
In-Reply-To: <1285661878.2795.70.camel@marge.simson.net>
References: <AANLkTinmQOYQAOPkQsZNhJBJtCss3ZtHN_a6h4fpamtz@mail.gmail.com>
	<1285661878.2795.70.camel@marge.simson.net>
Date: Tue, 28 Sep 2010 15:57:15 -0700
Message-ID: <AANLkTikjH1J_nCxZympo9v_VZbptWHBNJ8xh=pFXLRrQ@mail.gmail.com>
Subject: Re: broken behavior in cfs when moving threads between cgroups
From: Dima Zavin <dmitriyz@google.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

Thanks for the reply.

> I don't really see the relevance of an entity's lag in it's previous
> group, so would tend toward entry at parity.
>
> Maybe the move _should_ be treated as a fork, for the same reason we do
> START_DEBIT, but if so, seems to me it's irrelevant whether the task is
> currently sleeping or not, it's going to run for the first time in it's
> new home just as any runnable task, and may do so very soon.  OTOH,
> frequent moves with that hefty START_DEBIT price tag could hurt very
> badly, and makes caring about previous lag seem pointless.
>
>        -Mike
>
> (untested)
>
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 9b5b4f8..4dc6b2f 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -3827,10 +3827,14 @@ static void set_curr_task_fair(struct rq *rq)
>  static void moved_group_fair(struct task_struct *p, int on_rq)
>  {
>        struct cfs_rq *cfs_rq = task_cfs_rq(p);
> +       struct sched_entity *se = &p->se;
> +       u64 vruntime = 0;
>
>        update_curr(cfs_rq);
>        if (!on_rq)
> -               place_entity(cfs_rq, &p->se, 1);
> +               vruntime = cfs_rq->min_vruntime;
> +
> +       se->vruntime = vruntime;
>  }
>  #endif

Hmm. Would we really want to give the sleeping task such a bump in the
new group? Why not just start it off at min_vruntime and let
place_entity do it's thing? Something like...

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a7be83c..4656231 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3622,10 +3622,15 @@ static void set_curr_task_fair(struct rq *rq)
 static void moved_group_fair(struct task_struct *p, int on_rq)
 {
        struct cfs_rq *cfs_rq = task_cfs_rq(p);
+       struct sched_entity *se = &p->se;

        update_curr(cfs_rq);
-       if (!on_rq)
+       if (on_rq) {
+               se->vruntime = 0;
+       } else {
+               se->vruntime = cfs_rq->min_vruntime;
                place_entity(cfs_rq, &p->se, 1);
+       }
 }
 #endif
