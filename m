Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab2LMOKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:10:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44722 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932853Ab2LMOKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:10:15 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Darren Hart <dvhart@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 150/241] futex: avoid wake_futex() for a PI futex_q
Date: Thu, 13 Dec 2012 11:58:35 -0200
Message-Id: <1355407206-17100-151-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darren Hart <dvhart@linux.intel.com>

commit aa10990e028cac3d5e255711fb9fb47e00700e35 upstream.

Dave Jones reported a bug with futex_lock_pi() that his trinity test
exposed.  Sometime between queue_me() and taking the q.lock_ptr, the
lock_ptr became NULL, resulting in a crash.

While futex_wake() is careful to not call wake_futex() on futex_q's with
a pi_state or an rt_waiter (which are either waiting for a
futex_unlock_pi() or a PI futex_requeue()), futex_wake_op() and
futex_requeue() do not perform the same test.

Update futex_wake_op() and futex_requeue() to test for q.pi_state and
q.rt_waiter and abort with -EINVAL if detected.  To ensure any future
breakage is caught, add a WARN() to wake_futex() if the same condition
is true.

This fix has seen 3 hours of testing with "trinity -c futex" on an
x86_64 VM with 4 CPUS.

[akpm@linux-foundation.org: tidy up the WARN()]
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Reported-by: Dave Jones <davej@redat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Kacur <jkacur@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/futex.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 20ef219..19eb089 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -843,6 +843,9 @@ static void wake_futex(struct futex_q *q)
 {
 	struct task_struct *p = q->task;
 
+	if (WARN(q->pi_state || q->rt_waiter, "refusing to wake PI futex\n"))
+		return;
+
 	/*
 	 * We set q->lock_ptr = NULL _before_ we wake up the task. If
 	 * a non-futex wake up happens on another CPU then the task
@@ -1078,6 +1081,10 @@ retry_private:
 
 	plist_for_each_entry_safe(this, next, head, list) {
 		if (match_futex (&this->key, &key1)) {
+			if (this->pi_state || this->rt_waiter) {
+				ret = -EINVAL;
+				goto out_unlock;
+			}
 			wake_futex(this);
 			if (++ret >= nr_wake)
 				break;
@@ -1090,6 +1097,10 @@ retry_private:
 		op_ret = 0;
 		plist_for_each_entry_safe(this, next, head, list) {
 			if (match_futex (&this->key, &key2)) {
+				if (this->pi_state || this->rt_waiter) {
+					ret = -EINVAL;
+					goto out_unlock;
+				}
 				wake_futex(this);
 				if (++op_ret >= nr_wake2)
 					break;
@@ -1098,6 +1109,7 @@ retry_private:
 		ret += op_ret;
 	}
 
+out_unlock:
 	double_unlock_hb(hb1, hb2);
 out_put_keys:
 	put_futex_key(&key2);
@@ -1387,9 +1399,13 @@ retry_private:
 		/*
 		 * FUTEX_WAIT_REQEUE_PI and FUTEX_CMP_REQUEUE_PI should always
 		 * be paired with each other and no other futex ops.
+		 *
+		 * We should never be requeueing a futex_q with a pi_state,
+		 * which is awaiting a futex_unlock_pi().
 		 */
 		if ((requeue_pi && !this->rt_waiter) ||
-		    (!requeue_pi && this->rt_waiter)) {
+		    (!requeue_pi && this->rt_waiter) ||
+		    this->pi_state) {
 			ret = -EINVAL;
 			break;
 		}
-- 
1.7.9.5

