Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab2IYLWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:22:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:57643 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2IYLWf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:22:35 -0400
Message-ID: <1348572145.3881.18.camel@twins>
Subject: Re: [PATCH 3/3] workqueue: Schedule work on non-idle cpu instead of
 current one
From: Peter Zijlstra <peterz@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, pjt@google.com, paul.mckenney@linaro.org,
        tglx@linutronix.de, tj@kernel.org, suresh.b.siddha@intel.com,
        venki@google.com, mingo@redhat.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Date: Tue, 25 Sep 2012 13:22:25 +0200
In-Reply-To: <3232b3192e2e373cc4aaf43359d454c5ad53cddb.1348568074.git.viresh.kumar@linaro.org>
References: <viresh.kumar@linaro.org>
	 <cover.1348568074.git.viresh.kumar@linaro.org>
	 <3232b3192e2e373cc4aaf43359d454c5ad53cddb.1348568074.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 16:06 +0530, Viresh Kumar wrote:
> @@ -1066,8 +1076,9 @@ int queue_work(struct workqueue_struct *wq,
> struct work_struct *work)
>  {
>         int ret;
>  
> -       ret = queue_work_on(get_cpu(), wq, work);
> -       put_cpu();
> +       preempt_disable();
> +       ret = queue_work_on(wq_select_cpu(), wq, work);
> +       preempt_enable();
>  
>         return ret;
>  }

Right, so the problem I see here is that wq_select_cpu() is horridly
expensive..

> @@ -1102,7 +1113,7 @@ static void delayed_work_timer_fn(unsigned long
> __data)
>         struct delayed_work *dwork = (struct delayed_work *)__data;
>         struct cpu_workqueue_struct *cwq = get_work_cwq(&dwork->work);
>  
> -       __queue_work(smp_processor_id(), cwq->wq, &dwork->work);
> +       __queue_work(wq_select_cpu(), cwq->wq, &dwork->work);
>  } 

Shouldn't timer migration have sorted this one?
