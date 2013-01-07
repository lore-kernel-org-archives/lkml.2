Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3AGBQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:16:29 -0500
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:53138 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753009Ab3AGBQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:16:27 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: Neil Zhang <zhangwm@marvell.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bitbucket@online.de" <bitbucket@online.de>
Date: Sun, 6 Jan 2013 17:16:15 -0800
Subject: RE: [PATCH] sched: remove redundant update_runtime notifier
Thread-Topic: [PATCH] sched: remove redundant update_runtime notifier
Thread-Index: Ac3k4jKW9PB1pJYuTAiY0kApohOEJgHkk0QA
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE1C739002E6@SC-VEXCH4.marvell.com>
References: <1356688826-23158-1-git-send-email-zhangwm@marvell.com>
In-Reply-To: <1356688826-23158-1-git-send-email-zhangwm@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r071GYDh024603

All,

> -----Original Message-----
> From: Neil Zhang [mailto:zhangwm@marvell.com]
> Sent: 2012Äê12ÔÂ28ÈÕ 18:00
> To: mingo@kernel.org; peterz@infradead.org
> Cc: linux-kernel@vger.kernel.org; Neil Zhang; bitbucket@online.de
> Subject: [PATCH] sched: remove redundant update_runtime notifier
> 
> migration_call() will do all the things that update_runtime() does.
> So it seems update_runtime() is a redundant notifier, remove it.
> 
> Furthermore, there is potential risk that the current code will catch BUG_ON
> at line 687 of rt.c when do cpu hotplug while there are realtime threads
> running because of enable runtime twice.
> 
> Cc: bitbucket@online.de
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  kernel/sched/core.c  |    3 ---
>  kernel/sched/rt.c    |   40 ----------------------------------------
>  kernel/sched/sched.h |    1 -
>  3 files changed, 0 insertions(+), 44 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c index
> 257002c..7b6a4d8 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6779,9 +6779,6 @@ void __init sched_init_smp(void)
>  	hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
>  	hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);
> 
> -	/* RT runtime code needs to handle some hotplug events */
> -	hotcpu_notifier(update_runtime, 0);
> -
>  	init_hrtick();
> 
>  	/* Move init over to a non-isolated CPU */ diff --git a/kernel/sched/rt.c
> b/kernel/sched/rt.c index 418feb0..1a499d2 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -697,15 +697,6 @@ balanced:
>  	}
>  }
> 
> -static void disable_runtime(struct rq *rq) -{
> -	unsigned long flags;
> -
> -	raw_spin_lock_irqsave(&rq->lock, flags);
> -	__disable_runtime(rq);
> -	raw_spin_unlock_irqrestore(&rq->lock, flags);
> -}
> -
>  static void __enable_runtime(struct rq *rq)  {
>  	rt_rq_iter_t iter;
> @@ -730,37 +721,6 @@ static void __enable_runtime(struct rq *rq)
>  	}
>  }
> 
> -static void enable_runtime(struct rq *rq) -{
> -	unsigned long flags;
> -
> -	raw_spin_lock_irqsave(&rq->lock, flags);
> -	__enable_runtime(rq);
> -	raw_spin_unlock_irqrestore(&rq->lock, flags);
> -}
> -
> -int update_runtime(struct notifier_block *nfb, unsigned long action, void
> *hcpu) -{
> -	int cpu = (int)(long)hcpu;
> -
> -	switch (action) {
> -	case CPU_DOWN_PREPARE:
> -	case CPU_DOWN_PREPARE_FROZEN:
> -		disable_runtime(cpu_rq(cpu));
> -		return NOTIFY_OK;
> -
> -	case CPU_DOWN_FAILED:
> -	case CPU_DOWN_FAILED_FROZEN:
> -	case CPU_ONLINE:
> -	case CPU_ONLINE_FROZEN:
> -		enable_runtime(cpu_rq(cpu));
> -		return NOTIFY_OK;
> -
> -	default:
> -		return NOTIFY_DONE;
> -	}
> -}
> -
>  static int balance_runtime(struct rt_rq *rt_rq)  {
>  	int more = 0;
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h index
> fc88644..16d18a1 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -890,7 +890,6 @@ extern void sysrq_sched_debug_show(void);
> extern void sched_init_granularity(void);  extern void
> update_max_interval(void);  extern void update_group_power(struct
> sched_domain *sd, int cpu); -extern int update_runtime(struct notifier_block
> *nfb, unsigned long action, void *hcpu);  extern void
> init_sched_rt_class(void);  extern void init_sched_fair_class(void);
> 
> --
> 1.7.4.1

Any comments about this patch?

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
