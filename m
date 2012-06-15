Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab2FOTyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 15:54:41 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:64667 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757440Ab2FOTyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 15:54:39 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2012 15:54:39 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAG6Zu0/O+Ip3/2dsb2JhbABEtBGBCIIVAQEEAScTGwEjBQsLRhQlJBOICQW6CY9iYgOVGokfhHqBWIMF
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="191509236"
Date: Fri, 15 Jun 2012 15:44:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 4/6] rcu: Fix bug in rcu_barrier() torture
 test
Message-ID: <20120615194454.GA6366@Krystal>
References: <20120615185725.GA25163@linux.vnet.ibm.com>
 <1339786674-25265-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339786674-25265-4-git-send-email-paulmck@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1339786674-25265-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Editor: vi
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
[...]
> @@ -1642,6 +1643,7 @@ void rcu_torture_barrier_cbf(struct rcu_head *rcu)
>  static int rcu_torture_barrier_cbs(void *arg)
>  {
>  	long myid = (long)arg;
> +	bool lastphase = 0;
>  	struct rcu_head rcu;
>  
>  	init_rcu_head_on_stack(&rcu);
> @@ -1649,9 +1651,11 @@ static int rcu_torture_barrier_cbs(void *arg)
>  	set_user_nice(current, 19);
>  	do {
>  		wait_event(barrier_cbs_wq[myid],
> -			   atomic_read(&barrier_cbs_count) == n_barrier_cbs ||
> +			   barrier_phase != lastphase ||
>  			   kthread_should_stop() ||
>  			   fullstop != FULLSTOP_DONTSTOP);
> +		lastphase = barrier_phase;
> +		smp_mb();

Hi Paul,

Documenting this barrier, and the barrier below, along with the variable
accesses they order, would appear to be a good idea, especially since
the bug this is correcting was caused by the lack of appropriate
smp_mb().

Thanks,

Mathieu

>  		if (kthread_should_stop() || fullstop != FULLSTOP_DONTSTOP)
>  			break;
>  		cur_ops->call(&rcu, rcu_torture_barrier_cbf);
> @@ -1676,7 +1680,8 @@ static int rcu_torture_barrier(void *arg)
>  	do {
>  		atomic_set(&barrier_cbs_invoked, 0);
>  		atomic_set(&barrier_cbs_count, n_barrier_cbs);
> -		/* wake_up() path contains the required barriers. */
> +		smp_mb();
> +		barrier_phase = !barrier_phase;
>  		for (i = 0; i < n_barrier_cbs; i++)
>  			wake_up(&barrier_cbs_wq[i]);
>  		wait_event(barrier_wq,
> -- 
> 1.7.8
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
