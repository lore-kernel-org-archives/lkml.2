Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab1IFTRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 15:17:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:50081 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab1IFTRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:17:02 -0400
Date: Tue, 6 Sep 2011 21:16:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] posix-timers: turn it_signal into it_valid flag
In-Reply-To: <20110906184926.GA25997@redhat.com>
Message-ID: <alpine.LFD.2.02.1109062110090.2723@ionos>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org> <1314661157-22173-4-git-send-email-andi@firstfloor.org> <alpine.LFD.2.02.1109021135270.2723@ionos> <20110904165658.GA23948@redhat.com> <20110904202907.GA3404@redhat.com>
 <20110906031411.GA24024@alboin.amr.corp.intel.com> <20110906145124.GA15390@redhat.com> <1315323596.2899.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.LFD.2.02.1109061823100.2723@ionos> <20110906184926.GA25997@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-80234300-1315336614=:2723"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-80234300-1315336614=:2723
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 6 Sep 2011, Oleg Nesterov wrote:
> On 09/06, Thomas Gleixner wrote:
> >
> > On Tue, 6 Sep 2011, Eric Dumazet wrote:
> >
> > > Le mardi 06 septembre 2011 à 16:51 +0200, Oleg Nesterov a écrit :
> > > > On 09/05, Andi Kleen wrote:
> > > > >
> > > > > > I forgot everything I knew about ->it_requeue_pending logic, but it
> > > > > > seems to me that do_schedule_next_timer()->lock_timer() can find and
> > > > > > lock successfully the wrong timer. Another thread can do timer_delete()
> > > > > > and then re-create the timer with the same id.
> > > > >
> > > > > Do you mean after my patches or even before?
> > > >
> > > > Ah, sorry for confusion.
> > > >
> > > > Before. And after. IOW, I think this has nothing to do with your patches.
> > > >
> > >
> > > Hmm, you mean following patch is needed ?
> > >
> > > Before release of timer id to idr pool, we should make sure
> > > do_schedule_next_timer() wont be called, or it could find another timer
> > > reusing the just released id.
> >
> > I don't see how that makes it sure. If the signal is queued, then it
> > stays queued and the put_pid() has no effect either.
> 
> Yes.
> 
> But "If the signal is queued" is simple, in this case we could, say,
> do "tmr->sigq->info.si_tid = -1" to ensure lock_timer()->find_idr()
> can't succeed after dequeue_signal().
> 
> The problem is, it can be already dequeued.

Right, but we can solve this by moving the whole detach code into rcu.

Subject: posix-timer-fix-detach-race.patch
From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 06 Sep 2011 21:08:06 +0200

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/posix-timers.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/posix-timers.c
===================================================================
--- linux-2.6.orig/kernel/posix-timers.c
+++ linux-2.6/kernel/posix-timers.c
@@ -495,22 +495,30 @@ static void k_itimer_rcu_free(struct rcu
 {
 	struct k_itimer *tmr = container_of(head, struct k_itimer, it.rcu);
 
+	put_pid(tmr->it_pid);
+	sigqueue_free(tmr->sigq);
 	kmem_cache_free(posix_timers_cache, tmr);
 }
 
+static void k_itimer_rcu_free_idr(struct rcu_head *head)
+{
+	struct k_itimer *tmr = container_of(head, struct k_itimer, it.rcu);
+	unsigned long flags;
+
+	spin_lock_irqsave(&idr_lock, flags);
+	idr_remove(&posix_timers_id, tmr->it_id);
+	spin_unlock_irqrestore(&idr_lock, flags);
+	k_itimer_rcu_free(head);
+}
+
 #define IT_ID_SET	1
 #define IT_ID_NOT_SET	0
 static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 {
-	if (it_id_set) {
-		unsigned long flags;
-		spin_lock_irqsave(&idr_lock, flags);
-		idr_remove(&posix_timers_id, tmr->it_id);
-		spin_unlock_irqrestore(&idr_lock, flags);
-	}
-	put_pid(tmr->it_pid);
-	sigqueue_free(tmr->sigq);
-	call_rcu(&tmr->it.rcu, k_itimer_rcu_free);
+	if (it_id_set)
+		call_rcu(&tmr->it.rcu, k_itimer_rcu_free_idr);
+	else
+		call_rcu(&tmr->it.rcu, k_itimer_rcu_free);
 }
 
 static struct k_clock *clockid_to_kclock(const clockid_t id)
--8323328-80234300-1315336614=:2723--
