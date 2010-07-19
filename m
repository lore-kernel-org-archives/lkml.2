Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab0GSLfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 07:35:40 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:29152 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760611Ab0GSLfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 07:35:25 -0400
X-IronPort-AV: E=Sophos;i="4.55,226,1278280800"; 
   d="scan'208";a="55778624"
From: Tomasz Buchert <tomasz.buchert@inria.fr>
To: linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Tomasz Buchert <tomasz.buchert@inria.fr>,
        Lucas Nussbaum <lucas.nussbaum@loria.fr>
Subject: [PATCH 3/4] posix-cpu-timers: Wider access to the thread clocks
Date: Mon, 19 Jul 2010 13:34:48 +0200
Message-Id: <1279539289-27628-4-git-send-email-tomasz.buchert@inria.fr>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1279539289-27628-3-git-send-email-tomasz.buchert@inria.fr>
References: <1279539289-27628-1-git-send-email-tomasz.buchert@inria.fr>
 <1279539289-27628-2-git-send-email-tomasz.buchert@inria.fr>
 <1279539289-27628-3-git-send-email-tomasz.buchert@inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per-thread clocks are so far accessible only within
the same thread group. This patch makes it possible to get
this information for any thread of the same user and for
a user with CAP_SYS_ADMIN capability.

same_thread_group is not used anymore because if the thread is in
the same thread group as 'current' then they will have the same
owner anyway.

Signed-off-by: Tomasz Buchert <tomasz.buchert@inria.fr>
Signed-off-by: Lucas Nussbaum <lucas.nussbaum@loria.fr>
---
 kernel/posix-cpu-timers.c |   34 +++++++++++++++++++++++++++-------
 1 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 7495593..3c13f74 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -25,6 +25,26 @@ void update_rlimit_cpu(unsigned long rlim_new)
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
+/* RCU lock needed */
+static int thread_clock_allowed(struct task_struct *p)
+{
+	const struct cred *cred, *pcred;
+
+	if (unlikely(capable(CAP_SYS_ADMIN)))
+		return 1;
+	cred = current_cred();
+	pcred = __task_cred(p);
+
+	return (cred->euid == pcred->euid ||
+		cred->euid == pcred->uid);
+}
+
+/* RCU read lock needed */
+static inline int process_clock_allowed(struct task_struct *p)
+{
+	return thread_group_leader(p);
+}
+
 static int check_task_clock(const clockid_t which_clock)
 {
 	int error = 0;
@@ -37,7 +57,7 @@ static int check_task_clock(const clockid_t which_clock)
 	rcu_read_lock();
 	p = find_task_by_vpid(pid);
 	if (!p || !(CLOCK_PERTHREAD(which_clock) ?
-		   same_thread_group(p, current) : thread_group_leader(p))) {
+		   thread_clock_allowed(p) : process_clock_allowed(p))) {
 		error = -EINVAL;
 	}
 	rcu_read_unlock();
@@ -68,9 +88,9 @@ static int get_start_time(clockid_t which_clock, struct timespec *start)
 		find_task_by_vpid(CLOCK_PID(which_clock));
 	if (p && (
 		(CLOCK_PERTHREAD(which_clock) &&
-			same_thread_group(p, current)) ||
+			thread_clock_allowed(p)) ||
 		(!CLOCK_PERTHREAD(which_clock) &&
-			thread_group_leader(p) && p->sighand))) {
+			process_clock_allowed(p) && p->sighand))) {
 		*start = p->start_time;
 		return 0;
 	}
@@ -529,13 +549,13 @@ int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 		p = find_task_by_vpid(pid);
 		if (p) {
 			if (CLOCK_PERTHREAD(which_clock)) {
-				if (same_thread_group(p, current)) {
+				if (thread_clock_allowed(p)) {
 					error = cpu_clock_sample(which_clock,
 								 p, &rtn);
 				}
 			} else {
 				read_lock(&tasklist_lock);
-				if (thread_group_leader(p) && p->sighand) {
+				if (process_clock_allowed(p) && p->sighand) {
 					error =
 					    cpu_clock_sample_group(which_clock,
 							           p, &rtn);
@@ -575,7 +595,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
 			p = current;
 		} else {
 			p = find_task_by_vpid(pid);
-			if (p && !same_thread_group(p, current))
+			if (p && !thread_clock_allowed(p))
 				p = NULL;
 		}
 	} else {
@@ -583,7 +603,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
 			p = current->group_leader;
 		} else {
 			p = find_task_by_vpid(pid);
-			if (p && !thread_group_leader(p))
+			if (p && !process_clock_allowed(p))
 				p = NULL;
 		}
 	}
-- 
1.6.3.3

