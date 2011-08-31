Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab1HaIx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 04:53:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45453 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab1HaIx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 04:53:57 -0400
Subject: Re: [PATCH 1/4] posix-timers: move global timer id management to
 signal_struct v2
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 10:53:57 +0200
Message-ID: <1314780837.2801.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 29 août 2011 à 16:39 -0700, Andi Kleen a écrit :
> From: Andi Kleen <ak@linux.intel.com>
> 
> Move the global posix timer ids IDR to signal_struct. This removes
> a minor global scalability bottleneck and also allows to finally limit
> the number of process timers in a sane way (see next patch)
> 
> I put it into signal_struct following the other posix timer per process
> structures.
> 
> v2: Now with locking again (thanks Eric)
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  include/linux/init_task.h |    3 +++
>  include/linux/sched.h     |    4 ++++
>  kernel/fork.c             |    2 ++
>  kernel/posix-timers.c     |   23 ++++++++++++-----------
>  4 files changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> index d14e058..564248d 100644
> --- a/include/linux/init_task.h
> +++ b/include/linux/init_task.h
> @@ -10,6 +10,7 @@
>  #include <linux/pid_namespace.h>
>  #include <linux/user_namespace.h>
>  #include <linux/securebits.h>
> +#include <linux/idr.h>
>  #include <net/net_namespace.h>
>  
>  #ifdef CONFIG_SMP
> @@ -37,6 +38,7 @@ extern struct fs_struct init_fs;
>  		.list = LIST_HEAD_INIT(sig.shared_pending.list),	\
>  		.signal =  {{0}}},					\
>  	.posix_timers	 = LIST_HEAD_INIT(sig.posix_timers),		\
> +	.idr_lock	 = __SPIN_LOCK_UNLOCKED(idr_lock),		\
>  	.cpu_timers	= INIT_CPU_TIMERS(sig.cpu_timers),		\
>  	.rlim		= INIT_RLIMITS,					\
>  	.cputimer	= { 						\
> @@ -46,6 +48,7 @@ extern struct fs_struct init_fs;
>  	},								\
>  	.cred_guard_mutex =						\
>  		 __MUTEX_INITIALIZER(sig.cred_guard_mutex),		\
> +	.posix_timers_id = IDR_INIT(posix_timer_id),			\
>  	INIT_THREADGROUP_FORK_LOCK(sig)					\
>  }
>  
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 4ac2c05..87fa2fc 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -62,6 +62,7 @@ struct sched_param {
>  #include <linux/errno.h>
>  #include <linux/nodemask.h>
>  #include <linux/mm_types.h>
> +#include <linux/idr.h>
>  
>  #include <asm/system.h>
>  #include <asm/page.h>
> @@ -652,6 +653,9 @@ struct signal_struct {
>  	struct mutex cred_guard_mutex;	/* guard against foreign influences on
>  					 * credential calculations
>  					 * (notably. ptrace) */
> +
> +	struct idr posix_timers_id;
> +	spinlock_t idr_lock;		/* Protect posix_timers_id writes */
>  };
>  
>  /* Context switch must be unlocked if interrupts are to be enabled */
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 8e6b6f4..1054cfd 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -943,6 +943,8 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
>  	INIT_LIST_HEAD(&sig->cpu_timers[0]);
>  	INIT_LIST_HEAD(&sig->cpu_timers[1]);
>  	INIT_LIST_HEAD(&sig->cpu_timers[2]);
> +
> +	idr_init(&sig->posix_timers_id);

I might miss something, but dont you also need to 

	spin_lock_init(&sig->idr_lock);

Maybe you should try with LOCKDEP on ;)



