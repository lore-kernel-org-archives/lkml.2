Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161175Ab2CSPRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:17:36 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43853 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758400Ab2CSPRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:17:35 -0400
Date: Mon, 19 Mar 2012 16:17:31 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/locking changes for v3.4
Message-ID: <20120319151731.GA3421@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-locking-for-linus

   HEAD: 81b40539e748b108d143a5e38526ab00a6a784b6 futex: Simplify return logic

 Thanks,

	Ingo

------------------>
Thomas Gleixner (2):
      futex: Cover all PI opcodes with cmpxchg enabled check
      futex: Simplify return logic


 kernel/futex.c |   51 +++++++++++++++++++++++----------------------------
 1 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index ea87f4d..2364c99 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2616,7 +2616,7 @@ void exit_robust_list(struct task_struct *curr)
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
-	int ret = -ENOSYS, cmd = op & FUTEX_CMD_MASK;
+	int cmd = op & FUTEX_CMD_MASK;
 	unsigned int flags = 0;
 
 	if (!(op & FUTEX_PRIVATE_FLAG))
@@ -2629,49 +2629,44 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 	}
 
 	switch (cmd) {
+	case FUTEX_LOCK_PI:
+	case FUTEX_UNLOCK_PI:
+	case FUTEX_TRYLOCK_PI:
+	case FUTEX_WAIT_REQUEUE_PI:
+	case FUTEX_CMP_REQUEUE_PI:
+		if (!futex_cmpxchg_enabled)
+			return -ENOSYS;
+	}
+
+	switch (cmd) {
 	case FUTEX_WAIT:
 		val3 = FUTEX_BITSET_MATCH_ANY;
 	case FUTEX_WAIT_BITSET:
-		ret = futex_wait(uaddr, flags, val, timeout, val3);
-		break;
+		return futex_wait(uaddr, flags, val, timeout, val3);
 	case FUTEX_WAKE:
 		val3 = FUTEX_BITSET_MATCH_ANY;
 	case FUTEX_WAKE_BITSET:
-		ret = futex_wake(uaddr, flags, val, val3);
-		break;
+		return futex_wake(uaddr, flags, val, val3);
 	case FUTEX_REQUEUE:
-		ret = futex_requeue(uaddr, flags, uaddr2, val, val2, NULL, 0);
-		break;
+		return futex_requeue(uaddr, flags, uaddr2, val, val2, NULL, 0);
 	case FUTEX_CMP_REQUEUE:
-		ret = futex_requeue(uaddr, flags, uaddr2, val, val2, &val3, 0);
-		break;
+		return futex_requeue(uaddr, flags, uaddr2, val, val2, &val3, 0);
 	case FUTEX_WAKE_OP:
-		ret = futex_wake_op(uaddr, flags, uaddr2, val, val2, val3);
-		break;
+		return futex_wake_op(uaddr, flags, uaddr2, val, val2, val3);
 	case FUTEX_LOCK_PI:
-		if (futex_cmpxchg_enabled)
-			ret = futex_lock_pi(uaddr, flags, val, timeout, 0);
-		break;
+		return futex_lock_pi(uaddr, flags, val, timeout, 0);
 	case FUTEX_UNLOCK_PI:
-		if (futex_cmpxchg_enabled)
-			ret = futex_unlock_pi(uaddr, flags);
-		break;
+		return futex_unlock_pi(uaddr, flags);
 	case FUTEX_TRYLOCK_PI:
-		if (futex_cmpxchg_enabled)
-			ret = futex_lock_pi(uaddr, flags, 0, timeout, 1);
-		break;
+		return futex_lock_pi(uaddr, flags, 0, timeout, 1);
 	case FUTEX_WAIT_REQUEUE_PI:
 		val3 = FUTEX_BITSET_MATCH_ANY;
-		ret = futex_wait_requeue_pi(uaddr, flags, val, timeout, val3,
-					    uaddr2);
-		break;
+		return futex_wait_requeue_pi(uaddr, flags, val, timeout, val3,
+					     uaddr2);
 	case FUTEX_CMP_REQUEUE_PI:
-		ret = futex_requeue(uaddr, flags, uaddr2, val, val2, &val3, 1);
-		break;
-	default:
-		ret = -ENOSYS;
+		return futex_requeue(uaddr, flags, uaddr2, val, val2, &val3, 1);
 	}
-	return ret;
+	return -ENOSYS;
 }
 
 
