Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab2KUURP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 15:17:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55093 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234Ab2KUURN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 15:17:13 -0500
Date: Wed, 21 Nov 2012 12:16:39 -0800
From: tip-bot for Darren Hart <dvhart@linux.intel.com>
Message-ID: <tip-0e8f7a5954be13d0c8dcbca3204a9e962498c46e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jkacur@redhat.com, dvhart@linux.intel.com, peterz@infradead.org,
        davej@redat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jkacur@redhat.com, dvhart@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, davej@redat.com
In-Reply-To: <3b25c8ba053760892871713ff6e81660433f6734.1353483196.git.dvhart@linux.intel.com>
References: <3b25c8ba053760892871713ff6e81660433f6734.1353483196.git.dvhart@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] futex: Avoid wake_futex for a PI futex_q
Git-Commit-ID: 0e8f7a5954be13d0c8dcbca3204a9e962498c46e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 12:16:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e8f7a5954be13d0c8dcbca3204a9e962498c46e
Gitweb:     http://git.kernel.org/tip/0e8f7a5954be13d0c8dcbca3204a9e962498c46e
Author:     Darren Hart <dvhart@linux.intel.com>
AuthorDate: Tue, 20 Nov 2012 23:36:45 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 21 Nov 2012 21:05:34 +0100

futex: Avoid wake_futex for a PI futex_q

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

Reported-by: Dave Jones <davej@redat.com>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: John Kacur <jkacur@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/3b25c8ba053760892871713ff6e81660433f6734.1353483196.git.dvhart@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
