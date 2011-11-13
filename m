Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1KMSUj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 13:20:39 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33334 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab1KMSUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 13:20:38 -0500
Date: Sun, 13 Nov 2011 19:20:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCH 03/10] threadgroup: extend threadgroup_lock() to cover
 exit and exec
Message-ID: <20111113182029.GC9446@somewhere>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320191193-8110-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 04:46:26PM -0700, Tejun Heo wrote:
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index aa47d0f..6fb546e 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2377,13 +2377,37 @@ static inline void threadgroup_change_done(struct task_struct *tsk)
>  {
>  	up_read(&tsk->signal->group_rwsem);
>  }
> +
> +/**
> + * threadgroup_lock - lock threadgroup
> + * @tsk: member task of the threadgroup to lock
> + *
> + * Lock the threadgroup @tsk belongs to.  No new task is allowed to enter
> + * and member tasks aren't allowed to exit (as indicated by PF_EXITING) or
> + * perform exec.  This is useful for cases where the threadgroup needs to
> + * stay stable across blockable operations.
> + *
> + * fork and exit explicitly call threadgroup_change_{begin|end}() for
> + * synchronization.  exec is already synchronized with cread_guard_mutex
> + * which we grab here.
> + */
>  static inline void threadgroup_lock(struct task_struct *tsk)
>  {
> +	/* exec uses exit for de-threading, grab cred_guard_mutex first */
> +	mutex_lock(&tsk->signal->cred_guard_mutex);

May be worth explaining what in exec is synchronized through this. ie the leader.

>  	down_write(&tsk->signal->group_rwsem);
>  }
> +
> +/**
> + * threadgroup_unlock - unlock threadgroup
> + * @tsk: member task of the threadgroup to unlock
> + *
> + * Reverse threadgroup_lock().
> + */
>  static inline void threadgroup_unlock(struct task_struct *tsk)
>  {
>  	up_write(&tsk->signal->group_rwsem);
> +	mutex_unlock(&tsk->signal->cred_guard_mutex);
>  }
>  #else
>  static inline void threadgroup_change_begin(struct task_struct *tsk) {}
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 2913b35..3565f00 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -938,6 +938,12 @@ NORET_TYPE void do_exit(long code)
>  		schedule();
>  	}
>  
> +	/*
> +	 * @tsk's threadgroup is going through changes - lock out users
> +	 * which expect stable threadgroup.
> +	 */
> +	threadgroup_change_begin(tsk);

Why so early? You actually want to synchronize against cgroup_exit(). Or
am I missing something?

Yeah there may be a problem with reading PF_EXITING inside the lock if it
is updated outside the lock, may be we need a pair of memory barriers. But
other than that, this should be enough to lock around cgroup_exit().
