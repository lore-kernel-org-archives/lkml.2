Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab1IFSrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:47:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:56576 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab1IFSrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:47:40 -0400
Date: Tue, 6 Sep 2011 20:47:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Oleg Nesterov <oleg@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] posix-timers: turn it_signal into it_valid flag
In-Reply-To: <1315323596.2899.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.LFD.2.02.1109061823100.2723@ionos>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org>  <1314661157-22173-4-git-send-email-andi@firstfloor.org>  <alpine.LFD.2.02.1109021135270.2723@ionos>  <20110904165658.GA23948@redhat.com> <20110904202907.GA3404@redhat.com> 
 <20110906031411.GA24024@alboin.amr.corp.intel.com>  <20110906145124.GA15390@redhat.com> <1315323596.2899.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1102671134-1315334851=:2723"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1102671134-1315334851=:2723
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 6 Sep 2011, Eric Dumazet wrote:

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

I don't see how that makes it sure. If the signal is queued, then it
stays queued and the put_pid() has no effect either.

Thanks,

	tglx

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
>  	call_rcu(&tmr->it.rcu, k_itimer_rcu_free);
>  }
>  
> 
> 
> 
> 
--8323328-1102671134-1315334851=:2723--
