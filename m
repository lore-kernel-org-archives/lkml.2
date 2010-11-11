Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab0KKOrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:47:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:37245 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab0KKOrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:47:06 -0500
Subject: Re: [RFC][PATCH 06/22] sched: SCHED_DEADLINE handles spacial
 kthreads
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1288333876.8661.147.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333876.8661.147.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 15:46:58 +0100
Message-ID: <1289486818.2084.135.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 08:31 +0200, Raistlin wrote:
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index d4d918a..9c4c967 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -853,13 +853,9 @@ static int __cpuinit cpu_callback(struct notifier_block *nfb,
>                              cpumask_any(cpu_online_mask));
>         case CPU_DEAD:
>         case CPU_DEAD_FROZEN: {
> -               static struct sched_param param = {
> -                       .sched_priority = MAX_RT_PRIO-1
> -               };
> -
>                 p = per_cpu(ksoftirqd, hotcpu);
>                 per_cpu(ksoftirqd, hotcpu) = NULL;
> -               sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
> +               setscheduler_dl_special(p);
>                 kthread_stop(p);
>                 takeover_tasklets(hotcpu);
>                 break;

So this comes from 1c6b4aa94576, which is something I wouldn't have
bothered merging in the first place, if you pin a cpu with RT tasks like
that you get to keep the pieces, hotplug isn't the only thing that will
go wonky.

Anyway, if you leave the code as is you'll be fine, it'll me above any
FIFO task, but still below deadline tasks and the stop task, neither of
which should be hogging the system like that anyway.

> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 94ca779..2b7f259 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -307,10 +307,9 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>   */
>  static int watchdog(void *unused)
>  {
> -       static struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
>         struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
>  
> -       sched_setscheduler(current, SCHED_FIFO, &param);
> +       setscheduler_dl_special(current);
>  
>         /* initialize timestamp */
>         __touch_watchdog(); 

I'd be inclined to drop this too, if people get watchdog timeouts it
means the system is really over-commited on deadline tasks and the
watchdog FIFO thread didn't get around to running, something which I
think we both agree shouldn't be happening.
