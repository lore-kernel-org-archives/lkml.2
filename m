Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1ALGc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 01:32:58 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47576 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab1ALGc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 01:32:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ba1hxCwiprjCFTMT9EubiXQF2DUNY8S8LpVJxOqQ+WfWLNd0MzazyTXnClgtzJA1iT
         uxUUgtEXC5q5Jvuu37FcxA06sQRdBz5qHpqtou+En8koiuO00UabCA+xWRC5P3NkcEZw
         MLcQyB/KuRsPIhPiTde0YUM6hZNB4Qxlufz4E=
MIME-Version: 1.0
In-Reply-To: <1294810842.8370.7.camel@marge.simson.net>
References: <20110110091622.GF2772@in.ibm.com>
	<1294655388.8197.22.camel@marge.simson.net>
	<1294657154.2016.459.camel@laptop>
	<1294677746.8345.4.camel@marge.simson.net>
	<20110111171046.GL4772@in.ibm.com>
	<1294771686.8006.15.camel@marge.simson.net>
	<1294810842.8370.7.camel@marge.simson.net>
Date: Wed, 12 Jan 2011 14:32:54 +0800
Message-ID: <AANLkTimtwt+OGohMxGRC7L4Dm-h4wvCWYi-=13efqFtr@mail.gmail.com>
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
From: Yong Zhang <yong.zhang0@gmail.com>
To: Mike Galbraith <mgalbraith@suse.de>
Cc: bharata@linux.vnet.ibm.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 1:40 PM, Mike Galbraith <mgalbraith@suse.de> wrote:
> But it'd be better to not touch anything, just deflect RT tasks away
> from useless queues from the start.
>
> sched, autogroup: fix CONFIG_RT_GROUP_SCHED sched_setscheduler() failure.
>
> If CONFIG_RT_GROUP_SCHED is set, sched_setscheduler() fails due to autogroup
> not allocating rt_runtime.  Squirrel allocated but useless rt_se and rt_rq
> away for group destruction time, and deflect RT tasks to the root task group.
>
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Reported-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
>
> ---
>  kernel/sched_autogroup.c |   13 +++++++++++++
>  kernel/sched_autogroup.h |    4 ++++
>  2 files changed, 17 insertions(+)
>
> Index: linux-2.6/kernel/sched_autogroup.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_autogroup.c
> +++ linux-2.6/kernel/sched_autogroup.c
> @@ -27,6 +27,11 @@ static inline void autogroup_destroy(str
>  {
>        struct autogroup *ag = container_of(kref, struct autogroup, kref);
>
> +#ifdef CONFIG_RT_GROUP_SCHED
> +       ag->tg->rt_se = ag->rt_se;
> +       ag->tg->rt_rq = ag->rt_rq;
> +       ag->tg->rt_bandwidth.rt_runtime = 0;
> +#endif
>        sched_destroy_group(ag->tg);
>  }
>
> @@ -72,6 +77,14 @@ static inline struct autogroup *autogrou
>        init_rwsem(&ag->lock);
>        ag->id = atomic_inc_return(&autogroup_seq_nr);
>        ag->tg = tg;
> +#ifdef CONFIG_RT_GROUP_SCHED
> +       /* Sorry, we don't do RT, go away. */
> +       ag->rt_se = tg->rt_se;
> +       ag->rt_rq = tg->rt_rq;
> +       tg->rt_se = root_task_group.rt_se;
> +       tg->rt_rq = root_task_group.rt_rq;
> +       tg->rt_bandwidth.rt_runtime = root_task_group.rt_bandwidth.rt_runtime;

Setting rt_runtime both in this patch and the previous one will make tune
other's rt_runtime/rt_period trouble, I guess.

Thanks,
Yong

-- 
Only stand for myself
