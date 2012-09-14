Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab2INDPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 23:15:54 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56463 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab2INDPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 23:15:53 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6834"; a="236534419"
From: Vikram Mulukutla <markivx@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vikram Mulukutla <markivx@codeaurora.org>, linux-kernel@vger.kernel.org,
        sboyd@codeaurora.org
Subject: [PATCH] lib: spinlock_debug: Avoid livelock in do_raw_spin_lock
Date: Thu, 13 Sep 2012 20:15:26 -0700
Message-Id: <1347592526-7592-1-git-send-email-markivx@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic in do_raw_spin_lock attempts to acquire a spinlock
by invoking arch_spin_trylock in a loop with a delay between
each attempt. Now consider the following situation in a 2
CPU system:

1. CPU-0 continually acquires and releases a spinlock in a
   tight loop; it stays in this loop until some condition X
   is satisfied. X can only be satisfied by another CPU.

2. CPU-1 tries to acquire the same spinlock, in an attempt
   to satisfy the aforementioned condition X. However, it
   never sees the unlocked value of the lock because the
   debug spinlock code uses trylock instead of just lock;
   it checks at all the wrong moments - whenever CPU-0 has
   locked the lock.

Now in the absence of debug spinlocks, the architecture specific
spinlock code can correctly allow CPU-1 to wait in a "queue"
(e.g., ticket spinlocks), ensuring that it acquires the lock at
some point. However, with the debug spinlock code, livelock
can easily occur due to the use of try_lock, which obviously
cannot put the CPU in that "queue". This queueing mechanism is
implemented in both x86 and ARM spinlock code.

Note that the situation mentioned above is not hypothetical.
A real problem was encountered where CPU-0 was running
hrtimer_cancel with interrupts disabled, and CPU-1 was attempting
to run the hrtimer that CPU-0 was trying to cancel.

Address this by actually attempting arch_spin_lock once it is
suspected that there is a spinlock lockup. If we're in a
situation that is described above, the arch_spin_lock should
succeed; otherwise other timeout mechanisms (e.g., watchdog)
should alert the system of a lockup. Therefore, if there is
a genuine system problem and the spinlock can't be acquired,
the end result (irrespective of this change being present)
is the same. If there is a livelock caused by the debug code,
this change will allow the lock to be acquired, depending on
the implementation of the lower level arch specific spinlock
code.

Signed-off-by: Vikram Mulukutla <markivx@codeaurora.org>
---
 lib/spinlock_debug.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
index eb10578..94624e1 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -107,23 +107,27 @@ static void __spin_lock_debug(raw_spinlock_t *lock)
 {
 	u64 i;
 	u64 loops = loops_per_jiffy * HZ;
-	int print_once = 1;
 
-	for (;;) {
-		for (i = 0; i < loops; i++) {
-			if (arch_spin_trylock(&lock->raw_lock))
-				return;
-			__delay(1);
-		}
-		/* lockup suspected: */
-		if (print_once) {
-			print_once = 0;
-			spin_dump(lock, "lockup suspected");
+	for (i = 0; i < loops; i++) {
+		if (arch_spin_trylock(&lock->raw_lock))
+			return;
+		__delay(1);
+	}
+	/* lockup suspected: */
+	spin_dump(lock, "lockup suspected");
 #ifdef CONFIG_SMP
-			trigger_all_cpu_backtrace();
+	trigger_all_cpu_backtrace();
 #endif
-		}
-	}
+
+	/*
+	 * In case the trylock above was causing a livelock, give the lower
+	 * level arch specific lock code a chance to acquire the lock. We have
+	 * already printed a warning/backtrace at this point. The non-debug arch
+	 * specific code might actually succeed in acquiring the lock. If it is
+	 * not successful, the end-result is the same - there is no forward
+	 * progress.
+	 */
+	arch_spin_lock(&lock->raw_lock);
 }
 
 void do_raw_spin_lock(raw_spinlock_t *lock)
-- 
1.7.8.3

The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

