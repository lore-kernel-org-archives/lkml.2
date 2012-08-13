Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab2HMQ4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:56:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33582 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab2HMQ4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:56:04 -0400
Date: Mon, 13 Aug 2012 09:55:28 -0700
From: tip-bot for Will Deacon <will.deacon@arm.com>
Message-ID: <tip-6e9lrw2avczr0617fzl5vqb8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, will.deacon@arm.com, chris.mason@fusionio.com,
        stable@vger.kernel.org, arnd@arndb.de, nico@linaro.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, a.p.zijlstra@chello.nl, chris.mason@fusionio.com,
        stable@vger.kernel.org, arnd@arndb.de, nico@linaro.org,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] mutex:
  Place lock in contended state after fastpath_lock failure
Git-Commit-ID: 0bce9c46bf3b15f485d82d7e81dabed6ebcc24b1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 13 Aug 2012 09:55:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0bce9c46bf3b15f485d82d7e81dabed6ebcc24b1
Gitweb:     http://git.kernel.org/tip/0bce9c46bf3b15f485d82d7e81dabed6ebcc24b1
Author:     Will Deacon <will.deacon@arm.com>
AuthorDate: Fri, 10 Aug 2012 15:22:09 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 13 Aug 2012 18:46:54 +0200

mutex: Place lock in contended state after fastpath_lock failure

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

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@vger.kernel.org>
Reviewed-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-6e9lrw2avczr0617fzl5vqb8@git.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
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
 
