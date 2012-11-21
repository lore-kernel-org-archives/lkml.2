Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab2KUHlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:41:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:58515 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018Ab2KUHlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:41:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,291,1352102400"; 
   d="scan'208";a="250398574"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] futex: Avoid wake_futex for a PI futex_q
Date: Tue, 20 Nov 2012 23:36:45 -0800
Message-Id: <3b25c8ba053760892871713ff6e81660433f6734.1353483196.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones reported a bug with futex_lock_pi() that his trinity test
exposed. Sometime between queue_me() and taking the q.lock_ptr, the
lock_ptr became NULL, resulting in a crash.

While futex_wake() is careful to not call wake_futex() on futex_q's with
a pi_state or an rt_waiter (which are either waiting for a
futex_unlock_pi() or a PI futex_requeue()), futex_wake_op() and
futex_requeue() do not perform the same test.

Update futex_wake_op() and futex_requeue() to test for q.pi_state and
q.rt_waiter and abort with -EINVAL if detected. To ensure any future
breakage is caught, add a WARN() to wake_futex() if the same condition
is true.

This fix has seen 3 hours of testing with "trinity -c futex" on an
x86_64 VM with 4 CPUS.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Reported-by: Dave Jones <davej@redat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Kacur <jkacur@redhat.com>
Cc: stable@vger.kernel.org
---
 kernel/futex.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 3717e7b..5699b21 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -840,6 +840,11 @@ static void wake_futex(struct futex_q *q)
 {
 	struct task_struct *p = q->task;
 
+	if (q->pi_state || q->rt_waiter) {
+		WARN(1, "%s: refusing to wake PI futex\n", __FUNCTION__);
+		return;
+	}
+
 	/*
 	 * We set q->lock_ptr = NULL _before_ we wake up the task. If
 	 * a non-futex wake up happens on another CPU then the task
@@ -1075,6 +1080,10 @@ retry_private:
 
 	plist_for_each_entry_safe(this, next, head, list) {
 		if (match_futex (&this->key, &key1)) {
+			if (this->pi_state || this->rt_waiter) {
+				ret = -EINVAL;
+				goto out_unlock;
+			}
 			wake_futex(this);
 			if (++ret >= nr_wake)
 				break;
@@ -1087,6 +1096,10 @@ retry_private:
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
@@ -1095,6 +1108,7 @@ retry_private:
 		ret += op_ret;
 	}
 
+out_unlock:
 	double_unlock_hb(hb1, hb2);
 out_put_keys:
 	put_futex_key(&key2);
@@ -1384,9 +1398,13 @@ retry_private:
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
1.7.11.7

