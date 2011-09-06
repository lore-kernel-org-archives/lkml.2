Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab1IFRf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 13:35:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab1IFRfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 13:35:23 -0400
Date: Tue, 6 Sep 2011 18:27:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] posix-timers: turn it_signal into it_valid flag
Message-ID: <20110906162718.GA19030@redhat.com>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org> <1314661157-22173-4-git-send-email-andi@firstfloor.org> <alpine.LFD.2.02.1109021135270.2723@ionos> <20110904165658.GA23948@redhat.com> <20110904202907.GA3404@redhat.com> <20110906031411.GA24024@alboin.amr.corp.intel.com> <20110906145124.GA15390@redhat.com> <1315323596.2899.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1315323596.2899.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06, Eric Dumazet wrote:
>
> Le mardi 06 septembre 2011 à 16:51 +0200, Oleg Nesterov a écrit :
> > On 09/05, Andi Kleen wrote:
> > >
> > > > I forgot everything I knew about ->it_requeue_pending logic, but it
> > > > seems to me that do_schedule_next_timer()->lock_timer() can find and
> > > > lock successfully the wrong timer. Another thread can do timer_delete()
> > > > and then re-create the timer with the same id.
> > >
> > > Do you mean after my patches or even before?
> >
> > Ah, sorry for confusion.
> >
> > Before. And after. IOW, I think this has nothing to do with your patches.
> >
>
> Hmm, you mean following patch is needed ?
> 
> Before release of timer id to idr pool, we should make sure
> do_schedule_next_timer() wont be called, or it could find another timer
> reusing the just released id.
>
> diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
> index 4556182..4369747 100644
> --- a/kernel/posix-timers.c
> +++ b/kernel/posix-timers.c
> @@ -502,14 +502,14 @@ static void k_itimer_rcu_free(struct rcu_head *head)
>  #define IT_ID_NOT_SET	0
>  static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
>  {
> +	put_pid(tmr->it_pid);
> +	sigqueue_free(tmr->sigq);
>  	if (it_id_set) {
>  		unsigned long flags;
>  		spin_lock_irqsave(&idr_lock, flags);
>  		idr_remove(&posix_timers_id, tmr->it_id);
>  		spin_unlock_irqrestore(&idr_lock, flags);
>  	}
> -	put_pid(tmr->it_pid);
> -	sigqueue_free(tmr->sigq);

I don't think this can make any difference. We simply can't guarantee
do_schedule_next_timer() won't be called.

We could mark tmr->sigq as "invalid", but even this can't help. Suppose
that the task has already dequeued the __SI_TIMER signal, now it plays
withe the copy of tmr->sigq.

Oleg.

