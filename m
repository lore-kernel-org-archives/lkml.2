Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab0I0Jdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 05:33:55 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:51213 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab0I0Jdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 05:33:54 -0400
Date: Mon, 27 Sep 2010 15:03:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 03/10] taskstats: Split fill_pid function
Message-ID: <20100927093341.GH11780@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1285249681.1837.28.camel@holzheu-laptop>
 <1285250467.1837.80.camel@holzheu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1285250467.1837.80.camel@holzheu-laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Holzheu <holzheu@linux.vnet.ibm.com> [2010-09-23 16:01:07]:

> Subject: [PATCH] taskstats: Split fill_pid function
> 
> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> Separate the finding of a task_struct by pid or tgid from filling the taskstats
> data. This makes the code more readable.
> 
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> ---
>  kernel/taskstats.c |   50 +++++++++++++++++++++-----------------------------
>  1 file changed, 21 insertions(+), 29 deletions(-)
> 
> --- a/kernel/taskstats.c
> +++ b/kernel/taskstats.c
> @@ -175,22 +175,8 @@ static void send_cpu_listeners(struct sk
>  	up_write(&listeners->sem);
>  }
> 
> -static int fill_pid(pid_t pid, struct task_struct *tsk,
> -		struct taskstats *stats)
> +static void fill_stats(struct task_struct *tsk, struct taskstats *stats)
>  {
> -	int rc = 0;
> -
> -	if (!tsk) {
> -		rcu_read_lock();
> -		tsk = find_task_by_vpid(pid);
> -		if (tsk)
> -			get_task_struct(tsk);
> -		rcu_read_unlock();
> -		if (!tsk)
> -			return -ESRCH;
> -	} else
> -		get_task_struct(tsk);
> -
>  	memset(stats, 0, sizeof(*stats));
>  	/*
>  	 * Each accounting subsystem adds calls to its functions to
> @@ -209,17 +195,27 @@ static int fill_pid(pid_t pid, struct ta
> 
>  	/* fill in extended acct fields */
>  	xacct_add_tsk(stats, tsk);
> +}
> 
> -	/* Define err: label here if needed */
> -	put_task_struct(tsk);
> -	return rc;
> +static int fill_stats_for_pid(pid_t pid, struct taskstats *stats)
> +{
> +	struct task_struct *tsk;
> 
> +	rcu_read_lock();
> +	tsk = find_task_by_vpid(pid);
> +	if (tsk)
> +		get_task_struct(tsk);
> +	rcu_read_unlock();
> +	if (!tsk)
> +		return -ESRCH;
> +	fill_stats(tsk, stats);
> +	put_task_struct(tsk);
> +	return 0;
>  }
> 
> -static int fill_tgid(pid_t tgid, struct task_struct *first,
> -		struct taskstats *stats)
> +static int fill_stats_for_tgid(pid_t tgid, struct taskstats *stats)
>  {
> -	struct task_struct *tsk;
> +	struct task_struct *tsk, *first;
>  	unsigned long flags;
>  	int rc = -ESRCH;
> 
> @@ -228,8 +224,7 @@ static int fill_tgid(pid_t tgid, struct 
>  	 * leaders who are already counted with the dead tasks
>  	 */
>  	rcu_read_lock();
> -	if (!first)
> -		first = find_task_by_vpid(tgid);
> +	first = find_task_by_vpid(tgid);
> 
>  	if (!first || !lock_task_sighand(first, &flags))
>  		goto out;
> @@ -268,7 +263,6 @@ out:
>  	return rc;
>  }
> 
> -
>  static void fill_tgid_exit(struct task_struct *tsk)
>  {
>  	unsigned long flags;
> @@ -477,7 +471,7 @@ static int cmd_attr_pid(struct genl_info
>  	if (!stats)
>  		goto err;
> 
> -	rc = fill_pid(pid, NULL, stats);
> +	rc = fill_stats_for_pid(pid, stats);
>  	if (rc < 0)
>  		goto err;
>  	return send_reply(rep_skb, info);
> @@ -507,7 +501,7 @@ static int cmd_attr_tgid(struct genl_inf
>  	if (!stats)
>  		goto err;
> 
> -	rc = fill_tgid(tgid, NULL, stats);
> +	rc = fill_stats_for_tgid(tgid, stats);
>  	if (rc < 0)
>  		goto err;
>  	return send_reply(rep_skb, info);
> @@ -593,9 +587,7 @@ void taskstats_exit(struct task_struct *
>  	if (!stats)
>  		goto err;
> 
> -	rc = fill_pid(-1, tsk, stats);
> -	if (rc < 0)
> -		goto err;
> +	fill_stats(tsk, stats);
> 
>  	/*
>  	 * Doesn't matter if tsk is the leader or the last group member leaving
> 
>

 
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
