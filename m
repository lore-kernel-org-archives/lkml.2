Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab1FNKm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 06:42:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42192 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab1FNKmw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 06:42:52 -0400
Subject: Re: [PATCH 6/7] KVM-GST: adjust scheduler cpu power
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
In-Reply-To: <1308007897-17013-7-git-send-email-glommer@redhat.com>
References: <1308007897-17013-1-git-send-email-glommer@redhat.com>
	 <1308007897-17013-7-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 14 Jun 2011 12:42:27 +0200
Message-ID: <1308048147.19856.14.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 19:31 -0400, Glauber Costa wrote:
> @@ -1981,12 +1987,29 @@ static void update_rq_clock_task(struct rq
> *rq, s64 delta)
>  
>         rq->prev_irq_time += irq_delta;
>         delta -= irq_delta;
> +#endif
> +#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
> +       if (static_branch((&paravirt_steal_rq_enabled))) {

Why is that a different variable from the touch_steal_time() one?

> +
> +               steal = paravirt_steal_clock(cpu_of(rq));
> +               steal -= rq->prev_steal_time_acc;
> +
> +               rq->prev_steal_time_acc += steal;

You have this addition in the wrong place, when you clip:

> +               if (steal > delta)
> +                       steal = delta;

you just lost your steal delta, so the addition to prev_steal_time_acc
needs to be after the clip.

> +               delta -= steal;
> +       }
> +#endif
> +
>         rq->clock_task += delta;
>  
> -       if (irq_delta && sched_feat(NONIRQ_POWER))
> -               sched_rt_avg_update(rq, irq_delta);
> +       if ((irq_delta + steal) && sched_feat(NONTASK_POWER))
> +               sched_rt_avg_update(rq, irq_delta + steal);
>  } 
