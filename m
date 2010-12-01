Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab0LAS7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:59:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab0LAS7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:59:05 -0500
Date: Wed, 1 Dec 2010 19:51:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch v2 4/4] taskstats: Export "cdata_wait" CPU times with
	taskstats
Message-ID: <20101201185128.GA7656@redhat.com>
References: <20101129164237.522034198@linux.vnet.ibm.com> <20101129164435.903722027@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129164435.903722027@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29, Michael Holzheu wrote:
>
> * I left the struct signal locking in the patch, because I think
>   that in order to get consistent data this is necessary.

OK, I guess you mean that we want to read utime/stime "atomically",
and thus we need ->siglock to prevent the race with __exit_signal().

> @@ -30,6 +30,7 @@ void bacct_add_tsk(struct taskstats *sta
>  {
>  	const struct cred *tcred;
>  	struct timespec uptime, ts;
> +	unsigned long flags;
>  	u64 ac_etime;
>
>  	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
> @@ -71,6 +72,12 @@ void bacct_add_tsk(struct taskstats *sta
>  	stats->ac_majflt = tsk->maj_flt;
>
>  	strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm));
> +	if (thread_group_leader(tsk) && lock_task_sighand(tsk, &flags)) {
> +		struct cdata *cd = &tsk->signal->cdata_wait;
> +		stats->ac_cutime = cputime_to_usecs(cd->utime);
> +		stats->ac_cstime = cputime_to_usecs(cd->stime);

perhaps we need a small comment to explain ->siglock...

But in fact I don't really understand this anyway. This is called
before we reparent our children. This means that ac_cutime/ac_cstime
can be changed after that (multithreading, or full_cdata_enabled).

Say, taskstats_exit()->fill_stats()->bacct_add_tsk(). Every thread
does this, including the group_leader. But, it is possible that
group_leader exits first, before other threads. IOW, what
stats->ac_cXtime actually mean?


Nevermind, the whole series looks correct to me. Although I still
can't find the time to read it ;) But at first glance this version
addresses all concerns we discussed before.

Oleg.

