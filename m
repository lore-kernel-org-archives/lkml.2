Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1DEPSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:18:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55599 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab1DEPSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:18:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Jbh9kz1v7/DnZYVovcS1HM+SsfkOu+WlFfktqy459qMHq+BXhllkeAYXPTUk7n9OBa
         v8virsQx0z5L/oQmeis1TtgJ+CIcatNYhAo9e1Kpd55NaW7qnDM2iEx+OwYXzkTxGZFt
         cz81Ce26CpkLTvVXjACukfZWM9FbIr3Ap4SUo=
Subject: [PATCH v2] posix-timers: RCU conversion
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: john stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>, ben@iagu.net
In-Reply-To: <20110405144836.GA17490@redhat.com>
References: <4D8773AA.8030408@redhat.com>
	 <AANLkTin3Si1EAa=Va6f45vW-tYQ1Yk8dETXpHJHHHkxe@mail.gmail.com>
	 <1300726498.2884.493.camel@edumazet-laptop> <4D8784A9.8040303@redhat.com>
	 <1300727545.2884.513.camel@edumazet-laptop>
	 <AANLkTinn7OKKKvBYe7KWsrReuYDdma5+8gHJHXdCacDY@mail.gmail.com>
	 <1300746429.2837.20.camel@edumazet-laptop>
	 <1300777760.2837.38.camel@edumazet-laptop>
	 <1301849660.2837.211.camel@edumazet-laptop>
	 <1301940501.2319.25.camel@work-vm>  <20110405144836.GA17490@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 17:18:02 +0200
Message-ID: <1302016682.3171.19.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 05 avril 2011 à 16:48 +0200, Oleg Nesterov a écrit :

> Can't we move this rcu_head into the union above?
> 

Yes, you're right.


> 
> Not that I really think it makes sense to change the patch... but we
> could even use SLAB_DESTROY_BY_RCU, this is more effective. All we
> need is ctor which sets ->it_signal = NULL and initializes ->it_lock
> for lock_timer().
> 

I considered this, but this means SLUB cannot merge the
posix_timers_cache anymore.

This wastes more ram (each cpu has its own slab caches),
and considering posix-timers are seldom used...


> The question is, why do we use the global database for the timer ids.
> All timers live in signal_struct->posix_timers anyway, perhaps we could
> use a per-process array instead.
> 

This would add some overhead at process creation (to initialize the
'array' or whatever tree root).

It would help some workloads, (create/delete timers from lot of
different processes/cpus). I am not sure we really need this right now,
since we waited 2011 before even trying to optimize read side ;)

Thanks

[PATCH v2] posix-timers: RCU conversion

Ben Nagy reported a scalability problem with KVM/QEMU that hit very hard
a single spinlock (idr_lock) in posix-timers code, on its 48 core
machine.

Even on a 16 cpu machine (2x4x2), a single test can show 98% of cpu time
used in ticket_spin_lock, from lock_timer

Ref: http://www.spinics.net/lists/kvm/msg51526.html

Switching to RCU is quite easy, IDR being already RCU ready.

idr_lock should be locked only for an insert/delete, not a lookup.

Benchmark on a 2x4x2 machine, 16 processes calling timer_gettime().

Before :

real    1m18.669s
user    0m1.346s
sys     1m17.180s

After :

real    0m3.296s
user    0m1.366s
sys     0m1.926s

Reported-by: Ben Nagy <ben@iagu.net>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Tested-by: Ben Nagy <ben@iagu.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Richard Cochran <richard.cochran@omicron.at>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
V2 : rcu_head put in the 'it' union, as Oleg suggested.

 include/linux/posix-timers.h |    1 +
 kernel/posix-timers.c        |   25 ++++++++++++++-----------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index d51243a..ea0db16 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -80,6 +80,7 @@ struct k_itimer {
 			unsigned long incr;
 			unsigned long expires;
 		} mmtimer;
+		struct rcu_head rcu;
 	} it;
 };
 
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 4c01249..4a428b0 100644
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


