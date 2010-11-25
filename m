Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab0KYQ5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:57:31 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57857 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab0KYQ53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:57:29 -0500
Date: Thu, 25 Nov 2010 22:27:21 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 4/4] taskstats: Export "cdata_acct" with taskstats
Message-ID: <20101125165721.GE3298@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101119201108.269346583@linux.vnet.ibm.com>
 <20101119201144.871656307@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101119201144.871656307@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Holzheu <holzheu@linux.vnet.ibm.com> [2010-11-19 21:11:12]:

> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> With this patch the (full) cumulative CPU time is added to "struct taskstats".
> The CPU time is only returned for the thread group leader.
> 
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> ---
>  include/linux/taskstats.h |    7 ++++++-
>  kernel/tsacct.c           |    7 +++++++
>  2 files changed, 13 insertions(+), 1 deletion(-)
> 
> --- a/include/linux/taskstats.h
> +++ b/include/linux/taskstats.h
> @@ -33,7 +33,7 @@
>   */
> 
> 
> -#define TASKSTATS_VERSION	7
> +#define TASKSTATS_VERSION	8
>  #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
>  					 * in linux/sched.h */
> 
> @@ -163,6 +163,11 @@ struct taskstats {
>  	/* Delay waiting for memory reclaim */
>  	__u64	freepages_count;
>  	__u64	freepages_delay_total;
> +	/* version 7 ends here */
> +
> +	/* All cumulative CPU time of dead children */
> +	__u64	ac_cutime_acct;		/* User CPU time [usec] */
> +	__u64	ac_cstime_acct;		/* System CPU time [usec] */
>  };
> 
> 
> --- a/kernel/tsacct.c
> +++ b/kernel/tsacct.c
> @@ -31,6 +31,7 @@ void bacct_add_tsk(struct taskstats *sta
>  	const struct cred *tcred;
>  	struct timespec uptime, ts;
>  	u64 ac_etime;
> +	unsigned long flags;
> 
>  	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
> 
> @@ -71,6 +72,12 @@ void bacct_add_tsk(struct taskstats *sta
>  	stats->ac_majflt = tsk->maj_flt;
> 
>  	strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm));
> +	if (tsk->tgid == tsk->pid && lock_task_sighand(tsk, &flags)) {

I don't think referring to tgid and pid is a good idea in the context
of namespaces, thread_group_leader makes more sense like Oleg pointed
out.

> +		struct cdata *cd = &tsk->signal->cdata_acct;
> +		stats->ac_cutime_acct = cputime_to_usecs(cd->utime);
> +		stats->ac_cstime_acct = cputime_to_usecs(cd->stime);
> +		unlock_task_sighand(tsk, &flags);
> +	}
>  }
> 
> 
> 

-- 
	Three Cheers,
	Balbir
