Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab1IFPkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:40:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59390 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab1IFPj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:39:56 -0400
Subject: Re: [PATCH 4/4] posix-timers: turn it_signal into it_valid flag
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110906145124.GA15390@redhat.com>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
	 <1314661157-22173-4-git-send-email-andi@firstfloor.org>
	 <alpine.LFD.2.02.1109021135270.2723@ionos>
	 <20110904165658.GA23948@redhat.com> <20110904202907.GA3404@redhat.com>
	 <20110906031411.GA24024@alboin.amr.corp.intel.com>
	 <20110906145124.GA15390@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Sep 2011 17:39:56 +0200
Message-ID: <1315323596.2899.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 06 septembre 2011 à 16:51 +0200, Oleg Nesterov a écrit :
> On 09/05, Andi Kleen wrote:
> >
> > > I forgot everything I knew about ->it_requeue_pending logic, but it
> > > seems to me that do_schedule_next_timer()->lock_timer() can find and
> > > lock successfully the wrong timer. Another thread can do timer_delete()
> > > and then re-create the timer with the same id.
> >
> > Do you mean after my patches or even before?
> 
> Ah, sorry for confusion.
> 
> Before. And after. IOW, I think this has nothing to do with your patches.
> 

Hmm, you mean following patch is needed ?

Before release of timer id to idr pool, we should make sure
do_schedule_next_timer() wont be called, or it could find another timer
reusing the just released id.

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 4556182..4369747 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -502,14 +502,14 @@ static void k_itimer_rcu_free(struct rcu_head *head)
 #define IT_ID_NOT_SET	0
 static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 {
+	put_pid(tmr->it_pid);
+	sigqueue_free(tmr->sigq);
 	if (it_id_set) {
 		unsigned long flags;
 		spin_lock_irqsave(&idr_lock, flags);
 		idr_remove(&posix_timers_id, tmr->it_id);
 		spin_unlock_irqrestore(&idr_lock, flags);
 	}
-	put_pid(tmr->it_pid);
-	sigqueue_free(tmr->sigq);
 	call_rcu(&tmr->it.rcu, k_itimer_rcu_free);
 }
 



