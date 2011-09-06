Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1IFTaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 15:30:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab1IFTaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:30:20 -0400
Date: Tue, 6 Sep 2011 21:26:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] posix-timers: turn it_signal into it_valid flag
Message-ID: <20110906192626.GA27362@redhat.com>
References: <1314661157-22173-4-git-send-email-andi@firstfloor.org> <alpine.LFD.2.02.1109021135270.2723@ionos> <20110904165658.GA23948@redhat.com> <20110904202907.GA3404@redhat.com> <20110906031411.GA24024@alboin.amr.corp.intel.com> <20110906145124.GA15390@redhat.com> <1315323596.2899.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.LFD.2.02.1109061823100.2723@ionos> <20110906184926.GA25997@redhat.com> <alpine.LFD.2.02.1109062110090.2723@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1109062110090.2723@ionos>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06, Thomas Gleixner wrote:
>
> On Tue, 6 Sep 2011, Oleg Nesterov wrote:
> >
> > The problem is, it can be already dequeued.
>
> Right, but we can solve this by moving the whole detach code into rcu.

Hmm, I don't understand...

> --- linux-2.6.orig/kernel/posix-timers.c
> +++ linux-2.6/kernel/posix-timers.c
> @@ -495,22 +495,30 @@ static void k_itimer_rcu_free(struct rcu
>  {
>  	struct k_itimer *tmr = container_of(head, struct k_itimer, it.rcu);
>  
> +	put_pid(tmr->it_pid);
> +	sigqueue_free(tmr->sigq);
>  	kmem_cache_free(posix_timers_cache, tmr);

Why do we need to move put_pid/sigqueue_free ?

The caller of release_posix_timer() should cancel the timer, we can can
do this even before idr_remove() with or without this patch.

>  static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
>  {
> -	if (it_id_set) {
> -		unsigned long flags;
> -		spin_lock_irqsave(&idr_lock, flags);
> -		idr_remove(&posix_timers_id, tmr->it_id);
> -		spin_unlock_irqrestore(&idr_lock, flags);
> -	}
> -	put_pid(tmr->it_pid);
> -	sigqueue_free(tmr->sigq);
> -	call_rcu(&tmr->it.rcu, k_itimer_rcu_free);
> +	if (it_id_set)
> +		call_rcu(&tmr->it.rcu, k_itimer_rcu_free_idr);

But how this can help? Suppose that the task is preempted right
after dequeue_signal() drops ->siglock. We need rcu_read_lock()
before unlock then, no?

And. This breaks the accounting logic. I mean the patch from Andi
which adds the limits.

Oleg.

