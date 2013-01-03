Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3ACF0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 00:26:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab3ACFZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 00:25:55 -0500
Date: Thu, 3 Jan 2013 00:23:41 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: aquini@redhat.com, walken@google.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, knoel@redhat.com
Subject: [RFC PATCH 3/5] x86,smp: auto tune spinlock backoff delay factor
Message-ID: <20130103002341.3cc4b7b4@annuminas.surriel.com>
In-Reply-To: <20130103001536.7fd1e952@annuminas.surriel.com>
References: <20130103001536.7fd1e952@annuminas.surriel.com>
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
 arch/x86/kernel/smp.c |   41 ++++++++++++++++++++++++++++++++++++++---
 1 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index aa743e9..f1ec7f7 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -113,12 +113,31 @@ static atomic_t stopping_cpu = ATOMIC_INIT(-1);
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
+#define MIN_SPINLOCK_DELAY 1
+#define MAX_SPINLOCK_DELAY 16000
+DEFINE_PER_CPU(int, spinlock_delay) = { MIN_SPINLOCK_DELAY };
 void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 {
 	__ticket_t head = inc.head, ticket = inc.tail;
 	__ticket_t waiters_ahead;
+	int delay = __this_cpu_read(spinlock_delay);
 	unsigned loops;
 
 	for (;;) {
@@ -133,14 +152,30 @@ void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 			} while (ACCESS_ONCE(lock->tickets.head) != ticket);
 			break;
 		}
-		loops = 50 * waiters_ahead;
+
+		/*
+		 * The lock is still busy; slowly increase the delay. If we
+		 * end up sleeping too long, the code below will reduce the
+		 * delay. Ideally we acquire the lock in the tight loop above.
+		 */
+		if (!(head % 7) && delay < MAX_SPINLOCK_DELAY)
+			delay++;
+
+		loops = delay * waiters_ahead;
 		while (loops--)
 			cpu_relax();
 
 		head = ACCESS_ONCE(lock->tickets.head);
-		if (head == ticket)
+		if (head == ticket) {
+			/*
+			 * We overslept and have no idea how long the lock
+			 * went idle. Reduce the delay as a precaution.
+			 */
+			delay -= delay/32 + 1;
 			break;
+		}
 	}
+	__this_cpu_write(spinlock_delay, delay);
 }
 
 /*
