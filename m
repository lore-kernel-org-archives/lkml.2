Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1IGG0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:26:14 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40076 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729Ab1IGGU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:59 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 42/55] rcu: Make rcu_torture_fqs() exit loops at end of test
Date: Tue,  6 Sep 2011 11:00:36 -0700
Message-Id: <1315332049-2604-42-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rcu_torture_fqs() function can prevent the rcutorture tests from
completing, resulting in a hang.  This commit therefore ensures that
rcu_torture_fqs() will exit its inner loops at the end of the test,
and also applies the newish ULONG_CMP_LT() macro to time comparisons.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 6648e00..eb739c0 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -741,7 +741,7 @@ static int rcu_torture_boost(void *arg)
 	do {
 		/* Wait for the next test interval. */
 		oldstarttime = boost_starttime;
-		while (jiffies - oldstarttime > ULONG_MAX / 2) {
+		while (ULONG_CMP_LT(jiffies, oldstarttime)) {
 			schedule_timeout_uninterruptible(1);
 			rcu_stutter_wait("rcu_torture_boost");
 			if (kthread_should_stop() ||
@@ -752,7 +752,7 @@ static int rcu_torture_boost(void *arg)
 		/* Do one boost-test interval. */
 		endtime = oldstarttime + test_boost_duration * HZ;
 		call_rcu_time = jiffies;
-		while (jiffies - endtime > ULONG_MAX / 2) {
+		while (ULONG_CMP_LT(jiffies, endtime)) {
 			/* If we don't have a callback in flight, post one. */
 			if (!rbi.inflight) {
 				smp_mb(); /* RCU core before ->inflight = 1. */
@@ -818,11 +818,13 @@ rcu_torture_fqs(void *arg)
 	VERBOSE_PRINTK_STRING("rcu_torture_fqs task started");
 	do {
 		fqs_resume_time = jiffies + fqs_stutter * HZ;
-		while (jiffies - fqs_resume_time > LONG_MAX) {
+		while (ULONG_CMP_LT(jiffies, fqs_resume_time) &&
+		       !kthread_should_stop()) {
 			schedule_timeout_interruptible(1);
 		}
 		fqs_burst_remaining = fqs_duration;
-		while (fqs_burst_remaining > 0) {
+		while (fqs_burst_remaining > 0 &&
+		       !kthread_should_stop()) {
 			cur_ops->fqs();
 			udelay(fqs_holdoff);
 			fqs_burst_remaining -= fqs_holdoff;
-- 
1.7.3.2

