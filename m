Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab0JUOxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:53:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:54989 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab0JUOxn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:53:43 -0400
Subject: Re: [PATCH 5/6] Account ksoftirq time as cpustat softirq
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <1287614941-32325-6-git-send-email-venki@google.com>
References: <1287614941-32325-1-git-send-email-venki@google.com>
	 <1287614941-32325-6-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Oct 2010 16:53:29 +0200
Message-ID: <1287672809.3488.142.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 15:49 -0700, Venkatesh Pallipadi wrote:
> @@ -1979,15 +1980,20 @@ void account_system_vtime(struct task_struct *curr)
>         delta = now - per_cpu(irq_start_time, cpu);
>         per_cpu(irq_start_time, cpu) = now;
>         /*
> -        * We do not account for softirq time from ksoftirqd here.
>          * We want to continue accounting softirq time to ksoftirqd thread
>          * in that case, so as not to confuse scheduler with a special task
>          * that do not consume any time, but still wants to run.
> +        * So, softirq time in ksoftirqd is accounted separately and used
> +        * for softirq time reporting in /proc/stat.
>          */
> -       if (in_irq())
> +       if (in_irq()) {
>                 per_cpu(cpu_hardirq_time, cpu) += delta;
> -       else if (in_serving_softirq() && !(is_ksoftirqd_context()))
> -               per_cpu(cpu_softirq_time, cpu) += delta;
> +       } else if (in_serving_softirq()) {
> +               if (is_ksoftirqd_context())
> +                       per_cpu(cpu_ksoftirqd_time, cpu) += delta;
> +               else
> +                       per_cpu(cpu_softirq_time, cpu) += delta;
> +       }
>  
>         local_irq_restore(flags);
>  }
> @@ -2025,7 +2031,9 @@ static int irqtime_account_si_update(void)
>         int ret = 0;
>  
>         local_irq_save(flags);
> -       latest_ns = __get_cpu_var(cpu_softirq_time);
> +       latest_ns = __get_cpu_var(cpu_softirq_time) +
> +                       __get_cpu_var(cpu_ksoftirqd_time); 

wouldn't something like:

	latest_ns = this_cpu_read(cpu_softirq_time) +
		this_softirq_task()->se.sum_exec_runtime;

be easier?


