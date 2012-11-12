Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab2KLTQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 14:16:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:48691 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab2KLTQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 14:16:37 -0500
Date: Mon, 12 Nov 2012 20:16:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] Futex fix for 3.7
Message-ID: <alpine.LFD.2.02.1211122012530.10000@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

Single fix for a long standing futex race when taking over a futex
whose owner died. You can end up with two owners, which violates quite
some rules.

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      futex: Handle futex_pi OWNER_DIED take over correctly


 kernel/futex.c |   41 ++++++++++++++++++++++-------------------
 1 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 3717e7b..20ef219 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -716,7 +716,7 @@ static int futex_lock_pi_atomic(u32 __user *uaddr, struct futex_hash_bucket *hb,
 				struct futex_pi_state **ps,
 				struct task_struct *task, int set_waiters)
 {
-	int lock_taken, ret, ownerdied = 0;
+	int lock_taken, ret, force_take = 0;
 	u32 uval, newval, curval, vpid = task_pid_vnr(task);
 
 retry:
@@ -755,17 +755,15 @@ retry:
 	newval = curval | FUTEX_WAITERS;
 
 	/*
-	 * There are two cases, where a futex might have no owner (the
-	 * owner TID is 0): OWNER_DIED. We take over the futex in this
-	 * case. We also do an unconditional take over, when the owner
-	 * of the futex died.
-	 *
-	 * This is safe as we are protected by the hash bucket lock !
+	 * Should we force take the futex? See below.
 	 */
-	if (unlikely(ownerdied || !(curval & FUTEX_TID_MASK))) {
-		/* Keep the OWNER_DIED bit */
+	if (unlikely(force_take)) {
+		/*
+		 * Keep the OWNER_DIED and the WAITERS bit and set the
+		 * new TID value.
+		 */
 		newval = (curval & ~FUTEX_TID_MASK) | vpid;
-		ownerdied = 0;
+		force_take = 0;
 		lock_taken = 1;
 	}
 
@@ -775,7 +773,7 @@ retry:
 		goto retry;
 
 	/*
-	 * We took the lock due to owner died take over.
+	 * We took the lock due to forced take over.
 	 */
 	if (unlikely(lock_taken))
 		return 1;
@@ -790,20 +788,25 @@ retry:
 		switch (ret) {
 		case -ESRCH:
 			/*
-			 * No owner found for this futex. Check if the
-			 * OWNER_DIED bit is set to figure out whether
-			 * this is a robust futex or not.
+			 * We failed to find an owner for this
+			 * futex. So we have no pi_state to block
+			 * on. This can happen in two cases:
+			 *
+			 * 1) The owner died
+			 * 2) A stale FUTEX_WAITERS bit
+			 *
+			 * Re-read the futex value.
 			 */
 			if (get_futex_value_locked(&curval, uaddr))
 				return -EFAULT;
 
 			/*
-			 * We simply start over in case of a robust
-			 * futex. The code above will take the futex
-			 * and return happy.
+			 * If the owner died or we have a stale
+			 * WAITERS bit the owner TID in the user space
+			 * futex is 0.
 			 */
-			if (curval & FUTEX_OWNER_DIED) {
-				ownerdied = 1;
+			if (!(curval & FUTEX_TID_MASK)) {
+				force_take = 1;
 				goto retry;
 			}
 		default:
