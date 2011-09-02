Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab1IBJTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 05:19:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:58002 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933106Ab1IBJT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 05:19:28 -0400
Date: Fri, 2 Sep 2011 11:19:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        eric.dumazet@gmail.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/4] posix-timers: move global timer id management to
 signal_struct v2
In-Reply-To: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.LFD.2.02.1109021104140.2723@ionos>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011, Andi Kleen wrote:

Hint: Ccing maintainers of affected code might help to get code
      reviewed and eventually merged.

> diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> index d14e058..564248d 100644
> --- a/include/linux/init_task.h
> +++ b/include/linux/init_task.h
> @@ -10,6 +10,7 @@
>  #include <linux/pid_namespace.h>
>  #include <linux/user_namespace.h>
>  #include <linux/securebits.h>
> +#include <linux/idr.h>

New line please.

>  #include <net/net_namespace.h>
>  
>  #ifdef CONFIG_SMP
> @@ -37,6 +38,7 @@ extern struct fs_struct init_fs;
>  		.list = LIST_HEAD_INIT(sig.shared_pending.list),	\
>  		.signal =  {{0}}},					\
>  	.posix_timers	 = LIST_HEAD_INIT(sig.posix_timers),		\
> +	.idr_lock	 = __SPIN_LOCK_UNLOCKED(idr_lock),		\

  sig.idr_lock

Also is there a requirement, that this is a spinlock? AFAICT it's all
process context and slowpath, so we can make it a mutex.

>  	.cpu_timers	= INIT_CPU_TIMERS(sig.cpu_timers),		\
>  	.rlim		= INIT_RLIMITS,					\
>  	.cputimer	= { 						\
> @@ -46,6 +48,7 @@ extern struct fs_struct init_fs;
>  	},								\
>  	.cred_guard_mutex =						\
>  		 __MUTEX_INITIALIZER(sig.cred_guard_mutex),		\
> +	.posix_timers_id = IDR_INIT(posix_timer_id),			\

  sig.posix_timer_id

>  	INIT_THREADGROUP_FORK_LOCK(sig)					\
>  }
  
> @@ -541,6 +539,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
>  	int error, new_timer_id;
>  	sigevent_t event;
>  	int it_id_set = IT_ID_NOT_SET;
> +	struct signal_struct *s = current->signal;

  *sig please, cryptic variable names are a PITA.

Thanks,

	tglx
