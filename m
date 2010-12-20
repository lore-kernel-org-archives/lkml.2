Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab0LTP6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:58:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:41623 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034Ab0LTP6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:58:32 -0500
Subject: Re: [RFC PATCH 06/15] nohz_task: Keep the tick if rcu needs it
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <1292858662-5650-7-git-send-email-fweisbec@gmail.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292858662-5650-7-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Dec 2010 16:58:20 +0100
Message-ID: <1292860700.5021.14.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:

> @@ -1634,7 +1633,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
>   * by the current CPU, returning 1 if so.  This function is part of the
>   * RCU implementation; it is -not- an exported member of the RCU API.
>   */
> -static int rcu_pending(int cpu)
> +int rcu_pending(int cpu)

/me wonders about that comment.

>  {
>  	return __rcu_pending(&rcu_sched_state, &per_cpu(rcu_sched_data, cpu)) ||
>  	       __rcu_pending(&rcu_bh_state, &per_cpu(rcu_bh_data, cpu)) ||
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 6dbae46..45bd6e2 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2470,10 +2470,16 @@ static void nohz_task_cpu_update(void *unused)
>  int nohz_task_can_stop_tick(void)
>  {
>  	struct rq *rq = this_rq();
> +	int cpu;
>  
>  	if (rq->nr_running > 1)
>  		return 0;
>  
> +	cpu = smp_processor_id();
> +
> +	if (rcu_pending(cpu) || rcu_needs_cpu(cpu))
> +		return 0;

Arguable, rcu_needs_cpu() should imply rcu_pending(), because if there's
work still to be done, it needs the cpu, hmm?

>  	return 1;
>  }
>  

This patch also implies you broke stuff with #4 because it would put the
machine to sleep while RCU still had bits to do, not very nice.
