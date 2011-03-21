Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1CUW1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 18:27:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35836 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab1CUW1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 18:27:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wvWs2l2pJUBx8XwHIUkXxrd3T/QdZMYHLx646RPQjERJccKL4cfFGm6cNaPJxKwGMq
         wAHFRrq6pczskH6qEmtzSmf9uAGG0JAgDX6MOccqWB04OLqmq8PRbCc0U6DzwNVHnYvD
         F67ojMywtCLqCUE/M3cQ4deK+Jk49fWRpWVqQ=
Subject: [RFC] posix-timers: RCU conversion
From: Eric Dumazet <eric.dumazet@gmail.com>
To: ben@iagu.net
Cc: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        Richard Cochran <richard.cochran@omicron.at>
In-Reply-To: <AANLkTinn7OKKKvBYe7KWsrReuYDdma5+8gHJHXdCacDY@mail.gmail.com>
References: <AANLkTikZZ4MXZjx_+6u-vKVSgxULQo2BkQKRO6K_vzFy@mail.gmail.com>
	 <20110318123031.GB6066@8bytes.org>
	 <AANLkTin2k1ZSLa0NG6pKBvHYnKEV21t8pEqzeJWNn_rR@mail.gmail.com>
	 <4D871F6C.40207@redhat.com>
	 <AANLkTintxnKRQ4rD4Wo8_MHU4yJVzYaRhR=GjnDMGwNj@mail.gmail.com>
	 <AANLkTin8ZoUAVR2ajoV6cBFiUSe_Dof0_k60dcAGW3r-@mail.gmail.com>
	 <4D875842.9050308@redhat.com>
	 <AANLkTikWQS281kTtJ32-qo5U+w_BAak7qUwVhUQgOxxv@mail.gmail.com>
	 <4D8773AA.8030408@redhat.com>
	 <AANLkTin3Si1EAa=Va6f45vW-tYQ1Yk8dETXpHJHHHkxe@mail.gmail.com>
	 <1300726498.2884.493.camel@edumazet-laptop> <4D8784A9.8040303@redhat.com>
	 <1300727545.2884.513.camel@edumazet-laptop>
	 <AANLkTinn7OKKKvBYe7KWsrReuYDdma5+8gHJHXdCacDY@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 23:27:09 +0100
Message-ID: <1300746429.2837.20.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 21 mars 2011 à 23:57 +0545, Ben Nagy a écrit :
> On Mon, Mar 21, 2011 at 10:57 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Le lundi 21 mars 2011 à 19:02 +0200, Avi Kivity a écrit :
> >
> >> Any ideas on how to fix it?  We could pre-allocate IDs and batch them in
> >> per-cpu caches, but it seems like a lot of work.
> >>
> >
> > Hmm, I dont know what syscalls kvm do, but even a timer_gettime() has to
> > lock this idr_lock.
> >
> > Sounds crazy, and should be fixed in kernel code, not kvm ;)
> 
> Hi,
> 
> I'll need to work out a way I can make the perf.data available
> (~100M), but here's the summary
> 
> http://paste.ubuntu.com/583425/
> 
> And here's the summary of the summary
> 
> # Overhead          Command         Shared Object
>                 Symbol
> # ........  ...............  ....................
> ..........................................
> #
>     71.86%              kvm  [kernel.kallsyms]     [k] __ticket_spin_lock
>                         |
>                         --- __ticket_spin_lock
>                            |
>                            |--54.19%-- default_spin_lock_flags
>                            |          _raw_spin_lock_irqsave
>                            |          |
>                            |           --54.14%-- __lock_timer
>                            |                     |
>                            |                     |--31.92%-- sys_timer_gettime
>                            |                     |          system_call_fastpath
>                            |                     |
>                            |                      --22.22%-- sys_timer_settime
>                            |                                system_call_fastpath
>                            |
>                            |--15.66%-- _raw_spin_lock
> [...]
> 
> Which I guess seems to match what Eric just said.
> 
> I'll post a link to the full data tomorrow. Many thanks for the help
> so far. If it's a kernel scaling limit then I guess we just wait until
> the kernel gets better. :S I'll check it out with a linux guest
> tomorrow anyway.

Here is a quick & dirty patch to lower idr_lock use. You could try it
eventually ;)

Thanks

[RFC] posix-timers: RCU conversion

Ben Nagy reported a scalability problem with KVM/QEMU that hit very hard
a single spinlock (idr_lock) in posix-timers code.

Even on a 16 cpu machine (2x4x2), a single test can show 98% of cpu time
used in ticket_spin_lock

Switching to RCU should be quite easy, IDR being already RCU ready.

idr_lock should be locked only before an insert/delete, not a find.

Reported-by: Ben Nagy <ben@iagu.net>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 include/linux/posix-timers.h |    1 +
 kernel/posix-timers.c        |   26 ++++++++++++++------------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index d51243a..5dc27ca 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -81,6 +81,7 @@ struct k_itimer {
 			unsigned long expires;
 		} mmtimer;
 	} it;
+	struct rcu_head rcu;
 };
 
 struct k_clock {
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 4c01249..e2a823a 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -491,6 +491,11 @@ static struct k_itimer * alloc_posix_timer(void)
 	return tmr;
 }
 
+static void k_itimer_rcu_free(struct rcu_head *head)
+{
+	kmem_cache_free(posix_timers_cache, container_of(head, struct k_itimer, rcu));
+}
+
 #define IT_ID_SET	1
 #define IT_ID_NOT_SET	0
 static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
@@ -499,11 +504,12 @@ static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 		unsigned long flags;
 		spin_lock_irqsave(&idr_lock, flags);
 		idr_remove(&posix_timers_id, tmr->it_id);
+		tmr->it_id = -1;
 		spin_unlock_irqrestore(&idr_lock, flags);
 	}
 	put_pid(tmr->it_pid);
 	sigqueue_free(tmr->sigq);
-	kmem_cache_free(posix_timers_cache, tmr);
+	call_rcu(&tmr->rcu, k_itimer_rcu_free);
 }
 
 static struct k_clock *clockid_to_kclock(const clockid_t id)
@@ -631,22 +637,18 @@ out:
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
-		if (timr->it_signal == current->signal) {
-			spin_unlock(&idr_lock);
+		spin_lock_irqsave(&timr->it_lock, *flags);
+		if (timr->it_id == (int)timer_id && timr->it_signal == current->signal) {
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


