Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab0I2CxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 22:53:09 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:43116 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752170Ab0I2CxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 22:53:08 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX183kZYz5OE31VbWiaEgIEYapP5q2sukP8nc0+Czbo
	00BrigScqnj5r3
Subject: Re: broken behavior in cfs when moving threads between cgroups
From: Mike Galbraith <efault@gmx.de>
To: Dima Zavin <dmitriyz@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@google.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTikjH1J_nCxZympo9v_VZbptWHBNJ8xh=pFXLRrQ@mail.gmail.com>
References: <AANLkTinmQOYQAOPkQsZNhJBJtCss3ZtHN_a6h4fpamtz@mail.gmail.com>
	 <1285661878.2795.70.camel@marge.simson.net>
	 <AANLkTikjH1J_nCxZympo9v_VZbptWHBNJ8xh=pFXLRrQ@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 29 Sep 2010 04:53:32 +0200
Message-Id: <1285728812.7440.141.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 15:57 -0700, Dima Zavin wrote:

> Hmm. Would we really want to give the sleeping task such a bump in the
> new group? Why not just start it off at min_vruntime and let
> place_entity do it's thing? Something like...

No, I wouldn't want to give it anything, just enter at zero lag..

> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index a7be83c..4656231 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -3622,10 +3622,15 @@ static void set_curr_task_fair(struct rq *rq)
>  static void moved_group_fair(struct task_struct *p, int on_rq)
>  {
>         struct cfs_rq *cfs_rq = task_cfs_rq(p);
> +       struct sched_entity *se = &p->se;
> 
>         update_curr(cfs_rq);
> -       if (!on_rq)
> +       if (on_rq) {
> +               se->vruntime = 0;
> +       } else {
> +               se->vruntime = cfs_rq->min_vruntime;
>                 place_entity(cfs_rq, &p->se, 1);
> +       }
>  }
>  #endif

(Why penalize the sleeper?)

..but, as you noted, moving out then _back_ at forced 0 lag would result
in bogus vruntime deltas, so lag must be preserved.  The sleeper's
vruntime has to be set to relative before it's cfs_rq is changed, then
back to absolute in moved_group_fair() I suppose.

	-Mike

