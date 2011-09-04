Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab1IDRAX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 13:00:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab1IDRAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 13:00:19 -0400
Date: Sun, 4 Sep 2011 18:56:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, eric.dumazet@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] posix-timers: turn it_signal into it_valid flag
Message-ID: <20110904165658.GA23948@redhat.com>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org> <1314661157-22173-4-git-send-email-andi@firstfloor.org> <alpine.LFD.2.02.1109021135270.2723@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1109021135270.2723@ionos>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02, Thomas Gleixner wrote:
>
> On Mon, 29 Aug 2011, Andi Kleen wrote:
>
> > From: Andi Kleen <ak@linux.intel.com>
> >
> > Now that the timer IDR is per process we don't need to save
> > the signal_struct in the timer anymore. Still need this
> > as a flag for RCU, so turn it into a it_valid flag.
>
> That's wrong. it_signal is not necessary for RCU, it's necessary for
> protecting against a concurrent timer deletion.

The main reason for it_signal was the fact we use the global idr database,
we should check that the timer was created by us. But yes, another reason
was to check that the timer is "valid", we can race with create/delete.
See 27af4245.

> --- linux-2.6.orig/kernel/posix-timers.c
> +++ linux-2.6/kernel/posix-timers.c
> @@ -483,6 +483,7 @@ static struct k_itimer * alloc_posix_tim
>  	tmr = kmem_cache_zalloc(posix_timers_cache, GFP_KERNEL);
>  	if (!tmr)
>  		return tmr;
> +	INIT_LIST_HEAD(&tmr->list);
>  	if (unlikely(!(tmr->sigq = sigqueue_alloc()))) {
>  		kmem_cache_free(posix_timers_cache, tmr);
>  		return NULL;
> @@ -612,7 +613,6 @@ SYSCALL_DEFINE3(timer_create, const cloc
>  		goto out;
>
>  	spin_lock_irq(&current->sighand->siglock);
> -	new_timer->it_signal = current->signal;
>  	list_add(&new_timer->list, &current->signal->posix_timers);
>  	spin_unlock_irq(&current->sighand->siglock);
>
> @@ -643,7 +643,7 @@ static struct k_itimer *__lock_timer(tim
>  	timr = idr_find(&posix_timers_id, (int)timer_id);
>  	if (timr) {
>  		spin_lock_irqsave(&timr->it_lock, *flags);
> -		if (timr->it_signal == current->signal) {
> +		if (!list_empty(&timr->list)) {

looks correct at first glance....

The problem is, now that we have signal->posix_timers_id, we can kill
signal->posix_timers and k_itimer->list. Probably we can nullify
k_itimer->it_id to mark it as invalid before idr_remove. Although I
feel this all can be simplified even more.



And why do we need to add signal->idr_lock ? It is only used to
serialize idr_get/idr_remove. Probably we can use ->siglock for that,
posix timers use this lock anyway.

Also. I am not sure, but perhaps it make sense to turn
signal->posix_timers_id into the pointer to "struct idr" and allocate
idr on demand?

Oleg.

