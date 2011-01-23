Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614Ab1AWPQM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 10:16:12 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38406 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1AWPQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 10:16:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RQ5bcTk5iHZhmKVXZdTvW0R5KrH/xH/1UkJ7DXzwgIqjWBdLd7TeLSLJwhfDc1yE02
         umBNlQxJuaoCvgDRM0d0qyTS3sTzqnZmD/ylYtLrRNm5EPwfrlURK9Xp5WH+nZCR+JRM
         RmuCXVfeIomhjCx+EydRPzEyURkMykj9q+RSg=
MIME-Version: 1.0
In-Reply-To: <20110123150341.GA2643@zhy>
References: <4d39ce58.cc7e0e0a.5448.59e4@mx.google.com>
	<alpine.DEB.2.01.1101230243370.7903@trent.utfs.org>
	<20110123145429.GA2523@zhy>
	<20110123150341.GA2643@zhy>
Date: Sun, 23 Jan 2011 17:16:09 +0200
X-Google-Sender-Auth: YPbt3ujpmBdRKwsY5eJXP7IZ3Kk
Message-ID: <AANLkTinShA64ZVH91Rt-jQuX86gKCaezFn_D_m+820We@mail.gmail.com>
Subject: Re: [PATCH] sched: fix autogroup nice tune on UP
From: Pekka Enberg <penberg@kernel.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Witten <mfwitten@gmail.com>, linux-kernel@vger.kernel.org,
        Christian Kujau <christian@nerdbynature.de>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 5:03 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> And there is another issue on UP when FAIR_GROUP_SCHED
> enabled.
>
> ---
> From: Yong Zhang <yong.zhang0@gmail.com>
> Subject: [PATCH] sched: fix autogroup nice tune on UP
>
> When on UP with FAIR_GROUP_SCHED enabled, tune shares
> only affect tg->shares, but is not reflected on
> tg->se->load, the reason is update_cfs_shares()
> do nothing on SMP.

Typo here? You mean UP, right?

> So let sched_group_set_shares() update tg->se->load
> directly for UP && FAIR_GROUP_SCHED.
>
> This issue is found when enable autogroup, but also
> exists on cgroup.cpu on UP.
>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Mike Galbraith <efault@gmx.de>
> ---
>  kernel/sched.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 3ec2c6c..b8ed459 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8483,8 +8483,8 @@ static DEFINE_MUTEX(shares_mutex);
>
>  int sched_group_set_shares(struct task_group *tg, unsigned long shares)
>  {
> -       int i;
> -       unsigned long flags;
> +       int uninitialized_var(i);
> +       unsigned long uninitialized_var(flags);
>
>        /*
>         * We can't change the weight of the root cgroup.
> @@ -8502,6 +8502,7 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
>                goto done;
>
>        tg->shares = shares;
> +#ifdef CONFIG_SMP
>        for_each_possible_cpu(i) {
>                struct rq *rq = cpu_rq(i);
>                struct sched_entity *se;
> @@ -8513,6 +8514,9 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
>                        update_cfs_shares(group_cfs_rq(se), 0);
>                raw_spin_unlock_irqrestore(&rq->lock, flags);
>        }
> +#else
> +       update_load_set(&tg->se[0]->load, shares);
> +#endif

I'm not an expert on the scheduler but this looks like the wrong thing
to do. Shouldn't you fix update_cfs_shares() to work on UP properly?
