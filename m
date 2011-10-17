Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab1JQRzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:55:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:60937 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1JQRzG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 13:55:06 -0400
Subject: Re: Linux 3.1-rc9
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 17 Oct 2011 19:54:50 +0200
In-Reply-To: <CA+55aFxaGKEyhXdHXNxvPrPQ-SGSpbXdfoeXrxfjPx3VXsgvtg@mail.gmail.com>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
	 <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca>
	 <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca>
	 <1318060551.8395.0.camel@twins> <20111012213555.GC24461@hostway.ca>
	 <20111013232521.GA5654@hostway.ca>
	 <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
	 <1318847658.6594.40.camel@twins>
	 <CA+55aFxaGKEyhXdHXNxvPrPQ-SGSpbXdfoeXrxfjPx3VXsgvtg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318874090.4172.84.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 07:57 -0700, Linus Torvalds wrote:

> So seeing this, I'm not confident that atomic64 works at all, after all.

I could of course propose this... but I really won't since I'm half
retching by now.. ;-)


---
 include/linux/sched.h     |    7 +++++--
 kernel/posix-cpu-timers.c |    8 +++++---
 kernel/sched_stats.h      |    4 +---
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 41d0237..94bf16f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -474,7 +474,10 @@ struct cpu_itimer {
 struct task_cputime {
 	cputime_t utime;
 	cputime_t stime;
-	unsigned long long sum_exec_runtime;
+	union {
+		unsigned long long sum_exec_runtime;
+		atomic64_t _sum_exec_runtime;
+	};
 };
 /* Alternate field names when used to cache expirations. */
 #define prof_exp	stime
@@ -485,7 +488,7 @@ struct task_cputime {
 	(struct task_cputime) {					\
 		.utime = cputime_zero,				\
 		.stime = cputime_zero,				\
-		.sum_exec_runtime = 0,				\
+		{ .sum_exec_runtime = 0, },			\
 	}
 
 /*
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index c8008dd..4808c0d 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -264,8 +264,8 @@ static void update_gt_cputime(struct task_cputime *a, struct task_cputime *b)
 	if (cputime_gt(b->stime, a->stime))
 		a->stime = b->stime;
 
-	if (b->sum_exec_runtime > a->sum_exec_runtime)
-		a->sum_exec_runtime = b->sum_exec_runtime;
+	if (b->sum_exec_runtime > atomic64_read(&a->_sum_exec_runtime))
+		atomic64_set(&a->_sum_exec_runtime, b->sum_exec_runtime);
 }
 
 void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
@@ -287,6 +287,8 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 		update_gt_cputime(&cputimer->cputime, &sum);
 	}
 	*times = cputimer->cputime;
+	times->sum_exec_runtime = 
+		atomic64_read(&cputimer->cputime._sum_exec_runtime);
 	spin_unlock_irqrestore(&cputimer->lock, flags);
 }
 
@@ -1279,7 +1281,7 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 		struct task_cputime task_sample = {
 			.utime = tsk->utime,
 			.stime = tsk->stime,
-			.sum_exec_runtime = tsk->se.sum_exec_runtime
+			{ .sum_exec_runtime = tsk->se.sum_exec_runtime, },
 		};
 
 		if (task_cputime_expired(&task_sample, &tsk->cputime_expires))
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 331e01b..65dcb76 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -330,7 +330,5 @@ static inline void account_group_exec_runtime(struct task_struct *tsk,
 	if (!cputimer->running)
 		return;
 
-	spin_lock(&cputimer->lock);
-	cputimer->cputime.sum_exec_runtime += ns;
-	spin_unlock(&cputimer->lock);
+	atomic64_add(ns, &cputimer->cputime._sum_exec_runtime);
 }

