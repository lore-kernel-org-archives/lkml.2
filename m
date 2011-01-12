Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab1ALFnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 00:43:21 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47218 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab1ALFnS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 00:43:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BYsNd6VBZTr2Y1dTyffTUQIrMROLYQ8GqXnupdrFMq8C85AQcA6pKK2mfgnWlUD4km
         eztqqNyuN/fEstQx9hyXc5GgHIG4k1XeP/mNPlmGkP3gTVk+GruGxE8bhWwOIbb29VeH
         Y8HbSSrsn32plFNxEb/7t5D00WDLEOWYpgNnY=
MIME-Version: 1.0
In-Reply-To: <1294677746.8345.4.camel@marge.simson.net>
References: <20110110091622.GF2772@in.ibm.com>
	<1294655388.8197.22.camel@marge.simson.net>
	<1294657154.2016.459.camel@laptop>
	<1294677746.8345.4.camel@marge.simson.net>
Date: Wed, 12 Jan 2011 13:43:17 +0800
Message-ID: <AANLkTikO8kaWk=PL5F76pUc_ihV0w-vAU2NYvPcc1XUZ@mail.gmail.com>
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
From: Yong Zhang <yong.zhang0@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, bharata@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 12:42 AM, Mike Galbraith <efault@gmx.de> wrote:
> Index: linux-2.6/kernel/sched_autogroup.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_autogroup.c
> +++ linux-2.6/kernel/sched_autogroup.c
> @@ -73,6 +73,15 @@ static inline struct autogroup *autogrou
>        ag->id = atomic_inc_return(&autogroup_seq_nr);
>        ag->tg = tg;
>        tg->autogroup = ag;
> +#ifdef CONFIG_RT_GROUP_SCHED
> +       /*
> +        * HACK: autogroup RT tasks run in the root task group.
> +        * This fools __sched_setscheduler() into proceeding on
> +        * so we can move the task to the appropriate runqueue
> +        * upon scheduling policy change.
> +        */
> +       tg->rt_bandwidth.rt_runtime = RUNTIME_INF;
> +#endif
>
>        return ag;
>
> @@ -143,6 +152,15 @@ autogroup_move_group(struct task_struct
>        autogroup_kref_put(prev);
>  }
>
> +static inline void
> +autogroup_setscheduler(struct task_struct *p, int on_rq)
> +{
> +       if (p->sched_class->task_move_group)
> +               p->sched_class->task_move_group(p, on_rq);

This will be called even if we don't change the sched_class in
which case it is not necessary.

Thanks,
Yong

-- 
Only stand for myself
