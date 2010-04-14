Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab0DNCiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 22:38:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:54869 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab0DNCit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 22:38:49 -0400
Subject: Possible bug with mutex adaptative spinning
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 12:35:09 +1000
Message-ID: <1271212509.13059.135.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter !

I -may- have found a bug with mutex adaptative spinning. We hit it when
torture testing CPU unplug.

Basically, what happens is mutex_spin_on_owner() returns 1 if the owner
CPU is offline. That means that the caller (__mutex_lock_common()) will
spin until the mutex is released since there's a valid owner (so the
need_resched() test doesn't trigger). This will deadlock if this is the
only remaining CPU online.

In fact, it even deadlocks with more than 1 CPU online, for example, I
have a case where the 2 remaining online CPUs got into
__mutex_lock_common() at the same time, and so got into that spin loop
before any of them added itself to the wait_list, thus never hitting the
exist condition there.

I believe your test against nr_cpumask_bits is also a bit fragile for
similar reasons. IE. You have what looks like a valid owner but it seems
to be on an invalid CPU. It could be a freed thread_info, in which case
returning 1 is fine, but if it's anything else, kaboom. I think it's
better to be safe than sorry here and just go to sleep (ie return 0).

Same comment with the DEBUG_PAGE_ALLOC case. In fact, this (untested)
patch makes the function simpler and I don't think will have any
negative effect on performances. Let me know what you think:

---- cut here ----

[PATCH] mutex: Don't spin when the owner CPU is offline or other weird cases

The current code might spin forever if the CPU owning the mutex has been
offlined, and the last CPU in the system is trying to acquire it, since
mutex_spin_on_owner() will always return 1, telling the caller to spin
until the mutex has been released.

This patch changes mutex_spin_on_owner() to return 0 (don't spin) in any
case where we aren't sure about the owner struct validity or CPU number,
and if the said CPU is offline. There is no point going back &
re-evaluate spinning in corner cases like that, let's just go to sleep.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

diff --git a/kernel/sched.c b/kernel/sched.c
index a3dff1f..11b7f4a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3780,7 +3780,7 @@ int mutex_spin_on_owner(struct mutex *lock, struct
thread_info *owner)
 	 * the mutex owner just released it and exited.
 	 */
 	if (probe_kernel_address(&owner->cpu, cpu))
-		goto out;
+		return 0;
 #else
 	cpu = owner->cpu;
 #endif
@@ -3788,16 +3788,21 @@ int mutex_spin_on_owner(struct mutex *lock,
struct thread_info *owner)
 	/*
 	 * Even if the access succeeded (likely case),
 	 * the cpu field may no longer be valid.
+	 *
+	 * We stop spinning in this case since the owner may never
 	 */
 	if (cpu >= nr_cpumask_bits)
-		goto out;
+		return 0;
 
 	/*
 	 * We need to validate that we can do a
 	 * get_cpu() and that we have the percpu area.
+	 *
+	 * If the CPU is offline, the owner will never release it so
+	 * we must not spin
 	 */
 	if (!cpu_online(cpu))
-		goto out;
+		return 0;
 
 	rq = cpu_rq(cpu);
 
@@ -3816,7 +3821,6 @@ int mutex_spin_on_owner(struct mutex *lock, struct
thread_info *owner)
 
 		cpu_relax();
 	}
-out:
 	return 1;
 }
 #endif


