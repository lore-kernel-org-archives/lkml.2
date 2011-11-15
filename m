Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab1KOU2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:28:36 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36371 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932204Ab1KOU2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:28:34 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/9] rcu: Make RCU use the new is_idle_task() API
Date: Tue, 15 Nov 2011 12:28:01 -0800
Message-Id: <1321388885-11211-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111115202736.GA11030@linux.vnet.ibm.com>
References: <20111115202736.GA11030@linux.vnet.ibm.com>
x-cbid: 11111520-6078-0000-0000-0000046E0B0F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Change from direct comparison of ->pid with zero to is_idle_task().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny.c |    4 ++--
 kernel/rcutree.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 4e16ce3..e5bd949 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -64,7 +64,7 @@ static void rcu_idle_enter_common(long long oldval)
 		return;
 	}
 	RCU_TRACE(trace_rcu_dyntick("Start", oldval, rcu_dynticks_nesting));
-	if (current->pid != 0) {
+	if (!is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		RCU_TRACE(trace_rcu_dyntick("Error on entry: not idle task",
@@ -118,7 +118,7 @@ static void rcu_idle_exit_common(long long oldval)
 		return;
 	}
 	RCU_TRACE(trace_rcu_dyntick("End", oldval, rcu_dynticks_nesting));
-	if (current->pid != 0) {
+	if (!is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		RCU_TRACE(trace_rcu_dyntick("Error on exit: not idle task",
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 49e0783..7fb8b0e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -355,7 +355,7 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 		return;
 	}
 	trace_rcu_dyntick("Start", oldval, rdtp->dynticks_nesting);
-	if (current->pid != 0) {
+	if (!is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		trace_rcu_dyntick("Error on entry: not idle task",
@@ -449,7 +449,7 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 	smp_mb__after_atomic_inc();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 	trace_rcu_dyntick("End", oldval, rdtp->dynticks_nesting);
-	if (current->pid != 0) {
+	if (!is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		trace_rcu_dyntick("Error on exit: not idle task",
-- 
1.7.3.2

