Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab2LCOgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:36:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43719 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755365Ab2LCOgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:14 -0500
Message-Id: <20121203143159.298836370@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:33:09 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Darren Hart <dvhart@linux.intel.com>, Dave Jones <davej@redat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 83/89] futex: avoid wake_futex() for a PI futex_q
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


