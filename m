Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab1H2PdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:33:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:36921 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab1H2PdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:33:19 -0400
Subject: Re: [PATCH 13/32] nohz: Adaptive tick stop and restart on nohz
 cpuset
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Date: Mon, 29 Aug 2011 17:32:46 +0200
In-Reply-To: <1313423549-27093-14-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-14-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314631966.2816.93.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> +static void cpuset_nohz_restart_tick(void)
> +{
> +       __get_cpu_var(task_nohz_mode) = 0;
> +       tick_nohz_restart_sched_tick();
> +}
> +
> +void cpuset_update_nohz(void)
> +{
> +       if (!tick_nohz_adaptive_mode())
> +               return;
> +
> +       if (!cpuset_nohz_can_stop_tick())
> +               cpuset_nohz_restart_tick();
> +}
> +#endif
> +
>  static void
>  ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
>  {
> @@ -2560,6 +2592,8 @@ static void sched_ttwu_pending(void)
>                 ttwu_do_activate(rq, p, 0);
>         }
>  
> +       cpuset_update_nohz();
> +
>         raw_spin_unlock(&rq->lock);
>  }
>  
> @@ -2620,6 +2654,7 @@ static void ttwu_queue(struct task_struct *p, int cpu)
>  
>         raw_spin_lock(&rq->lock);
>         ttwu_do_activate(rq, p, 0);
> +       cpuset_update_nohz();
>         raw_spin_unlock(&rq->lock);
>  }

That really has nothing to do with cpusets, why doesn't that live in the
tick_nohz_* namespace? Something like tick_nohz_sched_wakeup() or so.
