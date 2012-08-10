Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab2HJOWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:22:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52782 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757430Ab2HJOWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:22:44 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <chris.mason@fusionio.com>, Ingo Molnar <mingo@elte.hu>,
        Nicolas Pitre <nico@fluxnic.net>, <stable@vger.kernel.org>
Subject: [PATCH] mutex: place lock in contended state after fastpath_lock failure
Date: Fri, 10 Aug 2012 15:22:09 +0100
Message-Id: <1344608529-2377-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM recently moved to asm-generic/mutex-xchg.h for its mutex
implementation after the previous implementation was found to be missing
some crucial memory barriers. However, this has revealed some problems
running hackbench on SMP platforms due to the way in which the
MUTEX_SPIN_ON_OWNER code operates.

The symptoms are that a bunch of hackbench tasks are left waiting on an
unlocked mutex and therefore never get woken up to claim it. This boils
down to the following sequence of events:

        Task A        Task B        Task C        Lock value
0                                                     1
1       lock()                                        0
2                     lock()                          0
3                     spin(A)                         0
4       unlock()                                      1
5                                   lock()            0
6                     cmpxchg(1,0)                    0
7                     contended()                    -1
8       lock()                                        0
9       spin(C)                                       0
10                                  unlock()          1
11      cmpxchg(1,0)                                  0
12      unlock()                                      1

At this point, the lock is unlocked, but Task B is in an uninterruptible
sleep with nobody to wake it up.

This patch fixes the problem by ensuring we put the lock into the
contended state if we fail to acquire it on the fastpath, ensuring that
any blocked waiters are woken up when the mutex is released.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---

Nico: Can I add your S-o-B to this please? Also, preliminary benchmarks
      are now showing a slight performance improvement on A15 if I use
      the -dec variant rather than -xchg. I'll follow up with a patch
      once I've got more numbers.

 include/asm-generic/mutex-xchg.h |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/mutex-xchg.h b/include/asm-generic/mutex-xchg.h
index 580a6d3..c04e0db 100644
--- a/include/asm-generic/mutex-xchg.h
+++ b/include/asm-generic/mutex-xchg.h
@@ -26,7 +26,13 @@ static inline void
 __mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_xchg(count, 0) != 1))
-		fail_fn(count);
+		/*
+		 * We failed to acquire the lock, so mark it contended
+		 * to ensure that any waiting tasks are woken up by the
+		 * unlock slow path.
+		 */
+		if (likely(atomic_xchg(count, -1) != 1))
+			fail_fn(count);
 }
 
 /**
@@ -43,7 +49,8 @@ static inline int
 __mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_xchg(count, 0) != 1))
-		return fail_fn(count);
+		if (likely(atomic_xchg(count, -1) != 1))
+			return fail_fn(count);
 	return 0;
 }
 
-- 
1.7.4.1

