Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab1EYLsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 07:48:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:60301 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab1EYLsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 07:48:54 -0400
Date: Wed, 25 May 2011 13:48:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] timer updates for 2.6.40
Message-ID: <alpine.LFD.2.02.1105251347080.3078@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Thanks,

	tglx

------------------>
Eric Dumazet (1):
      posix-timers: RCU conversion


 include/linux/posix-timers.h |    1 +
 kernel/posix-timers.c        |   25 ++++++++++++++-----------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 808227d..959c141 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -82,6 +82,7 @@ struct k_itimer {
 			unsigned long expires;
 		} mmtimer;
 		struct alarm alarmtimer;
+		struct rcu_head rcu;
 	} it;
 };
 
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index a1b5edf..4556182 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -491,6 +491,13 @@ static struct k_itimer * alloc_posix_timer(void)
 	return tmr;
 }
 
+static void k_itimer_rcu_free(struct rcu_head *head)
+{
+	struct k_itimer *tmr = container_of(head, struct k_itimer, it.rcu);
+
+	kmem_cache_free(posix_timers_cache, tmr);
+}
+
 #define IT_ID_SET	1
 #define IT_ID_NOT_SET	0
 static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
@@ -503,7 +510,7 @@ static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 	}
 	put_pid(tmr->it_pid);
 	sigqueue_free(tmr->sigq);
-	kmem_cache_free(posix_timers_cache, tmr);
+	call_rcu(&tmr->it.rcu, k_itimer_rcu_free);
 }
 
 static struct k_clock *clockid_to_kclock(const clockid_t id)
@@ -631,22 +638,18 @@ out:
 static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags)
 {
 	struct k_itimer *timr;
-	/*
-	 * Watch out here.  We do a irqsave on the idr_lock and pass the
-	 * flags part over to the timer lock.  Must not let interrupts in
-	 * while we are moving the lock.
-	 */
-	spin_lock_irqsave(&idr_lock, *flags);
+
+	rcu_read_lock();
 	timr = idr_find(&posix_timers_id, (int)timer_id);
 	if (timr) {
-		spin_lock(&timr->it_lock);
+		spin_lock_irqsave(&timr->it_lock, *flags);
 		if (timr->it_signal == current->signal) {
-			spin_unlock(&idr_lock);
+			rcu_read_unlock();
 			return timr;
 		}
-		spin_unlock(&timr->it_lock);
+		spin_unlock_irqrestore(&timr->it_lock, *flags);
 	}
-	spin_unlock_irqrestore(&idr_lock, *flags);
+	rcu_read_unlock();
 
 	return NULL;
 }
