Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab2HCQbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:31:53 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51242 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2HCQbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:31:51 -0400
Date: Fri, 3 Aug 2012 18:31:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20120803163145.GA1549@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

   HEAD: 6f7b0a2a5c0fb03be7c25bd1745baa50582348ef futex: Forbid uaddr == uaddr2 in futex_wait_requeue_pi()

Various futex fixes for bugs Darren Hart found via his 
testsuite.

 Thanks,

	Ingo

------------------>
Darren Hart (3):
      futex: Test for pi_mutex on fault in futex_wait_requeue_pi()
      futex: Fix bug in WARN_ON for NULL q.pi_state
      futex: Forbid uaddr == uaddr2 in futex_wait_requeue_pi()


 kernel/futex.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index e2b0fb9..3717e7b 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2231,11 +2231,11 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
  * @uaddr2:	the pi futex we will take prior to returning to user-space
  *
  * The caller will wait on uaddr and will be requeued by futex_requeue() to
- * uaddr2 which must be PI aware.  Normal wakeup will wake on uaddr2 and
- * complete the acquisition of the rt_mutex prior to returning to userspace.
- * This ensures the rt_mutex maintains an owner when it has waiters; without
- * one, the pi logic wouldn't know which task to boost/deboost, if there was a
- * need to.
+ * uaddr2 which must be PI aware and unique from uaddr.  Normal wakeup will wake
+ * on uaddr2 and complete the acquisition of the rt_mutex prior to returning to
+ * userspace.  This ensures the rt_mutex maintains an owner when it has waiters;
+ * without one, the pi logic would not know which task to boost/deboost, if
+ * there was a need to.
  *
  * We call schedule in futex_wait_queue_me() when we enqueue and return there
  * via the following:
@@ -2272,6 +2272,9 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	struct futex_q q = futex_q_init;
 	int res, ret;
 
+	if (uaddr == uaddr2)
+		return -EINVAL;
+
 	if (!bitset)
 		return -EINVAL;
 
@@ -2343,7 +2346,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 		 * signal.  futex_unlock_pi() will not destroy the lock_ptr nor
 		 * the pi_state.
 		 */
-		WARN_ON(!&q.pi_state);
+		WARN_ON(!q.pi_state);
 		pi_mutex = &q.pi_state->pi_mutex;
 		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
 		debug_rt_mutex_free_waiter(&rt_waiter);
@@ -2370,7 +2373,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	 * fault, unlock the rt_mutex and return the fault to userspace.
 	 */
 	if (ret == -EFAULT) {
-		if (rt_mutex_owner(pi_mutex) == current)
+		if (pi_mutex && rt_mutex_owner(pi_mutex) == current)
 			rt_mutex_unlock(pi_mutex);
 	} else if (ret == -EINTR) {
 		/*
