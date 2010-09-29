Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab0I2IMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 04:12:49 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45372 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752621Ab0I2IMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 04:12:48 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18rPrsndecrIu9sUy/AyMepmUjD2Tc8F6oywXt50k
	fVIHvfbwmaCbY4
Subject: Re: [PATCH 1/2] sched: normalize sleeper's vruntime during group
 change
From: Mike Galbraith <efault@gmx.de>
To: Dima Zavin <dima@android.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <1285742774-5013-1-git-send-email-dima@android.com>
References: <1285742774-5013-1-git-send-email-dima@android.com>
Content-Type: text/plain
Date: Wed, 29 Sep 2010 10:13:15 +0200
Message-Id: <1285747995.7844.42.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 23:46 -0700, Dima Zavin wrote:
> This adds a new callback, prep_move_task, to struct sched_class
> to give sched_fair the opportunity to adjust the task's vruntime
> just before setting its new group.
> 
> This allows us to properly normalize a sleeping task's vruntime
> when moving it between different cgroups.


> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index db3f674..008fe57 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -3827,10 +3827,23 @@ static void set_curr_task_fair(struct rq *rq)
>  static void moved_group_fair(struct task_struct *p, int on_rq)
>  {
>  	struct cfs_rq *cfs_rq = task_cfs_rq(p);
> +	struct sched_entity *se = &p->se;
>  
>  	update_curr(cfs_rq);
> -	if (!on_rq)
> +	if (!on_rq) {
> +		se->vruntime += cfs_rq->min_vruntime;
>  		place_entity(cfs_rq, &p->se, 1);
> +	}
> +}

I'm still missing the place_entity() rationale.  Why is a sleeping task
eligible for pain therapy that a runnable task is spared?  That state
can change a usec from now.

Nit: place_entity(cfs_rq, se, 1);

	-Mike

