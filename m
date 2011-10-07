Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444Ab1JGSCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 14:02:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40091 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab1JGSCQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 14:02:16 -0400
Subject: Re: Linux 3.1-rc9
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Simon Kirby <sim@hostway.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 07 Oct 2011 20:01:55 +0200
In-Reply-To: <20111007174848.GA11011@hostway.ca>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
	 <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318010515.398.8.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 10:48 -0700, Simon Kirby wrote:

> Yes, they stopped locking up with d670ec13 reverted.

> > [ 1717.560005]  [<ffffffff8104b8d4>] task_sched_runtime+0x24/0x90
> > [ 1717.560005]  [<ffffffff8107c924>] thread_group_cputime+0x74/0xb0
> > [ 1717.560005]  [<ffffffff8107d126>] thread_group_cputimer+0xa6/0xf0
> > [ 1717.560005]  [<ffffffff8107d198>] cpu_timer_sample_group+0x28/0x90
> > [ 1717.560005]  [<ffffffff8107d3c3>] set_process_cpu_timer+0x33/0x110
> > [ 1717.560005]  [<ffffffff8107d4da>] update_rlimit_cpu+0x3a/0x60
> > [ 1717.560005]  [<ffffffff8106fe9e>] do_prlimit+0xfe/0x1f0
> > [ 1717.560005]  [<ffffffff8106ffd6>] sys_setrlimit+0x46/0x60
> > [ 1717.560005]  [<ffffffff816be292>] system_call_fastpath+0x16/0x1b


OK so that cputimer stuff is horrid and the worst part is that I cannot
seem to trigger this. You guys must have some weird userspace stuff that
I simply don't have.

I tried running some LTP tests, and it was suggested I find some glibc
tests as well, but I haven't got that far yet.

Now the problem isn't new, but the referenced patch does make it _MUCH_
more likely.

Both Thomas and I have tried to come up with solutions, but the only
thing that stands a chance of working, other than using atomic64_t, is
giving task_cputime::cputime.sum_exec_runtime its own lock.

Clearly this is all very ugly and I'm really hesitant of even posting
this, but here goes...

---
 include/linux/sched.h     |    3 +++
 kernel/posix-cpu-timers.c |    6 +++++-
 kernel/sched_stats.h      |    4 ++--
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f3c5273..fbbe5eb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -504,6 +504,7 @@ struct task_cputime {
  * @running:		non-zero when there are timers running and
  * 			@cputime receives updates.
  * @lock:		lock for fields in this struct.
+ * @runtime_lock:	lock for cputime.sum_exec_runtime
  *
  * This structure contains the version of task_cputime, above, that is
  * used for thread group CPU timer calculations.
@@ -512,6 +513,7 @@ struct thread_group_cputimer {
 	struct task_cputime cputime;
 	int running;
 	raw_spinlock_t lock;
+	raw_spinlock_t runtime_lock;
 };
 
 #include <linux/rwsem.h>
@@ -2571,6 +2573,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
 static inline void thread_group_cputime_init(struct signal_struct *sig)
 {
 	raw_spin_lock_init(&sig->cputimer.lock);
+	raw_spin_lock_init(&sig->cputimer.runtime_lock);
 }
 
 /*
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index d20586b..bf760b4 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -284,9 +284,13 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 		 * it.
 		 */
 		thread_group_cputime(tsk, &sum);
+		raw_spin_lock(&cputimer->runtime_lock);
 		update_gt_cputime(&cputimer->cputime, &sum);
-	}
+	} else
+		raw_spin_lock(&cputimer->runtime_lock);
+
 	*times = cputimer->cputime;
+	raw_spin_unlock(&cputimer->runtime_lock);
 	raw_spin_unlock_irqrestore(&cputimer->lock, flags);
 }
 
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 87f9e36..f9751c1 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -330,7 +330,7 @@ static inline void account_group_exec_runtime(struct task_struct *tsk,
 	if (!cputimer->running)
 		return;
 
-	raw_spin_lock(&cputimer->lock);
+	raw_spin_lock(&cputimer->runtime_lock);
 	cputimer->cputime.sum_exec_runtime += ns;
-	raw_spin_unlock(&cputimer->lock);
+	raw_spin_unlock(&cputimer->runtime_lock);
 }

