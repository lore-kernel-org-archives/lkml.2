Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3AHWez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:34:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab3AHWey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:34:54 -0500
Date: Tue, 8 Jan 2013 17:30:29 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: aquini@redhat.com, walken@google.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
Subject: [PATCH 3/5] x86,smp: auto tune spinlock backoff delay factor
Message-ID: <20130108173029.305d99c0@annuminas.surriel.com>
In-Reply-To: <20130108172632.1126898a@annuminas.surriel.com>
References: <20130108172632.1126898a@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many spinlocks are embedded in data structures; having many CPUs
pounce on the cache line the lock is in will slow down the lock
holder, and can cause system performance to fall off a cliff.

The paper "Non-scalable locks are dangerous" is a good reference:

	http://pdos.csail.mit.edu/papers/linux:lock.pdf

In the Linux kernel, spinlocks are optimized for the case of
there not being contention. After all, if there is contention,
the data structure can be improved to reduce or eliminate
lock contention.

Likewise, the spinlock API should remain simple, and the
common case of the lock not being contended should remain
as fast as ever.

However, since spinlock contention should be fairly uncommon,
we can add functionality into the spinlock slow path that keeps
system performance from falling off a cliff when there is lock
contention.

Proportional delay in ticket locks is delaying the time between
checking the ticket based on a delay factor, and the number of
CPUs ahead of us in the queue for this lock. Checking the lock
less often allows the lock holder to continue running, resulting
in better throughput and preventing performance from dropping
off a cliff.

Proportional spinlock delay with a high delay factor works well
when there is lots contention on a lock. Likewise, a smaller
delay factor works well when a lock is lightly contended.

Making the code auto-tune the delay factor results in a system
that performs well with both light and heavy lock contention.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
v3: use fixed-point math for the delay calculations, suggested by Michel Lespinasse

 arch/x86/kernel/smp.c |   43 +++++++++++++++++++++++++++++++++++++++----
 1 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index aa743e9..05f828b 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -113,13 +113,34 @@ static atomic_t stopping_cpu = ATOMIC_INIT(-1);
 static bool smp_no_nmi_ipi = false;
 
 /*
- * Wait on a congested ticket spinlock.
+ * Wait on a congested ticket spinlock. Many spinlocks are embedded in
+ * data structures; having many CPUs pounce on the cache line with the
+ * spinlock simultaneously can slow down the lock holder, and the system
+ * as a whole.
+ *
+ * To prevent total performance collapse in case of bad spinlock contention,
+ * perform proportional backoff. The per-cpu value of delay is automatically
+ * tuned to limit the number of times spinning CPUs poll the lock before
+ * obtaining it. This limits the amount of cross-CPU traffic required to obtain
+ * a spinlock, and keeps system performance from dropping off a cliff.
+ *
+ * There is a tradeoff. If we poll too often, the whole system is slowed
+ * down. If we sleep too long, the lock will go unused for a period of
+ * time. The solution is to go for a fast spin if we are at the head of
+ * the queue, to slowly increase the delay if we sleep for too short a
+ * time, and to decrease the delay if we slept for too long.
  */
+#define DELAY_SHIFT 8
+#define DELAY_FIXED_1 (1<<DELAY_SHIFT)
+#define MIN_SPINLOCK_DELAY (1 * DELAY_FIXED_1)
+#define MAX_SPINLOCK_DELAY (16000 * DELAY_FIXED_1)
+DEFINE_PER_CPU(unsigned, spinlock_delay) = { MIN_SPINLOCK_DELAY };
 void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 {
 	__ticket_t head = inc.head, ticket = inc.tail;
 	__ticket_t waiters_ahead;
-	unsigned loops;
+	unsigned delay = __this_cpu_read(spinlock_delay);
+	unsigned loops = 1;
 
 	for (;;) {
 		waiters_ahead = ticket - head - 1;
@@ -133,14 +154,28 @@ void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 			} while (ACCESS_ONCE(lock->tickets.head) != ticket);
 			break;
 		}
-		loops = 50 * waiters_ahead;
+
+		/* Aggressively increase delay, to minimize lock accesses. */
+		if (delay < MAX_SPINLOCK_DELAY)
+			delay += DELAY_FIXED_1 / 7;
+
+		loops = (delay * waiters_ahead) >> DELAY_SHIFT;
 		while (loops--)
 			cpu_relax();
 
 		head = ACCESS_ONCE(lock->tickets.head);
-		if (head == ticket)
+		if (head == ticket) {
+			/*
+			 * We overslept, and do not know by how.
+			 * Exponentially decay the value of delay,
+			 * to get it back to a good value quickly.
+			 */
+			if (delay >= 2 * DELAY_FIXED_1)
+				delay -= max(delay/32, DELAY_FIXED_1);
 			break;
+		}
 	}
+	__this_cpu_write(spinlock_delay, delay);
 }
 
 /*

