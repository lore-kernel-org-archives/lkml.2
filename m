Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab1IBKGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 06:06:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:37528 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933028Ab1IBKGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 06:06:23 -0400
Date: Fri, 2 Sep 2011 12:06:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, eric.dumazet@gmail.com,
        Andi Kleen <ak@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 4/4] posix-timers: turn it_signal into it_valid flag
In-Reply-To: <1314661157-22173-4-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.LFD.2.02.1109021135270.2723@ionos>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org> <1314661157-22173-4-git-send-email-andi@firstfloor.org>
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

> From: Andi Kleen <ak@linux.intel.com>
> 
> Now that the timer IDR is per process we don't need to save
> the signal_struct in the timer anymore. Still need this
> as a flag for RCU, so turn it into a it_valid flag.

That's wrong. it_signal is not necessary for RCU, it's necessary for
protecting against a concurrent timer deletion.
 
> Suggested by Eric Dumazet
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  include/linux/posix-timers.h |    2 +-
>  kernel/posix-timers.c        |    8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
> index 959c141..02c1f04 100644
> --- a/include/linux/posix-timers.h
> +++ b/include/linux/posix-timers.h
> @@ -63,7 +63,7 @@ struct k_itimer {
>  	int it_requeue_pending;		/* waiting to requeue this timer */
>  #define REQUEUE_PENDING 1
>  	int it_sigev_notify;		/* notify word of sigevent struct */
> -	struct signal_struct *it_signal;
> +	int it_valid;

What's the gain of this change? Nothing, AFAICT. But looking closer we
can get rid of it_signal completely.

Thanks,

	tglx

------------------>
Subject: posix-timers: Simplify deletion protection
From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 02 Sep 2011 11:59:14 +0200

k_itimer->it_signal is soleley used to protect a timer lookup against
a concurrent deletion. We can use k_itimer->list for the same purpose.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/posix-timers.h |    1 -
 kernel/posix-timers.c        |   20 +++++++++-----------
 2 files changed, 9 insertions(+), 12 deletions(-)

Index: linux-2.6/include/linux/posix-timers.h
===================================================================
--- linux-2.6.orig/include/linux/posix-timers.h
+++ linux-2.6/include/linux/posix-timers.h
@@ -63,7 +63,6 @@ struct k_itimer {
 	int it_requeue_pending;		/* waiting to requeue this timer */
 #define REQUEUE_PENDING 1
 	int it_sigev_notify;		/* notify word of sigevent struct */
-	struct signal_struct *it_signal;
 	union {
 		struct pid *it_pid;	/* pid of process to send signal to */
 		struct task_struct *it_process;	/* for clock_nanosleep */
Index: linux-2.6/kernel/posix-timers.c
===================================================================
--- linux-2.6.orig/kernel/posix-timers.c
+++ linux-2.6/kernel/posix-timers.c
@@ -483,6 +483,7 @@ static struct k_itimer * alloc_posix_tim
 	tmr = kmem_cache_zalloc(posix_timers_cache, GFP_KERNEL);
 	if (!tmr)
 		return tmr;
+	INIT_LIST_HEAD(&tmr->list);
 	if (unlikely(!(tmr->sigq = sigqueue_alloc()))) {
 		kmem_cache_free(posix_timers_cache, tmr);
 		return NULL;
@@ -612,7 +613,6 @@ SYSCALL_DEFINE3(timer_create, const cloc
 		goto out;
 
 	spin_lock_irq(&current->sighand->siglock);
-	new_timer->it_signal = current->signal;
 	list_add(&new_timer->list, &current->signal->posix_timers);
 	spin_unlock_irq(&current->sighand->siglock);
 
@@ -643,7 +643,7 @@ static struct k_itimer *__lock_timer(tim
 	timr = idr_find(&posix_timers_id, (int)timer_id);
 	if (timr) {
 		spin_lock_irqsave(&timr->it_lock, *flags);
-		if (timr->it_signal == current->signal) {
+		if (!list_empty(&timr->list)) {
 			rcu_read_unlock();
 			return timr;
 		}
@@ -895,13 +895,12 @@ retry_delete:
 	}
 
 	spin_lock(&current->sighand->siglock);
-	list_del(&timer->list);
-	spin_unlock(&current->sighand->siglock);
 	/*
-	 * This keeps any tasks waiting on the spin lock from thinking
-	 * they got something (see the lock code above).
+	 * We initialize the list to indicate deletion for
+	 * __lock_timer().
 	 */
-	timer->it_signal = NULL;
+	list_del_init(&timer->list);
+	spin_unlock(&current->sighand->siglock);
 
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
@@ -922,12 +921,11 @@ retry_delete:
 		unlock_timer(timer, flags);
 		goto retry_delete;
 	}
-	list_del(&timer->list);
 	/*
-	 * This keeps any tasks waiting on the spin lock from thinking
-	 * they got something (see the lock code above).
+	 * We initialize the list to indicate deletion for
+	 * __lock_timer().
 	 */
-	timer->it_signal = NULL;
+	list_del_init(&timer->list);
 
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
