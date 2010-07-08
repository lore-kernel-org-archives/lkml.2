Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab0GHMc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 08:32:59 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:58929 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755117Ab0GHMc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 08:32:58 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2010 08:32:57 EDT
X-IronPort-AV: E=Sophos;i="4.53,558,1272837600"; 
   d="scan'208";a="54704700"
From: Tomasz Buchert <tomasz.buchert@inria.fr>
To: linux-kernel@vger.kernel.org
Cc: Tomasz Buchert <tomasz.buchert@inria.fr>,
       Lucas Nussbaum <lucas.nussbaum@loria.fr>
Subject: [PATCH] posix-cpu-timers: Wider access to the thread CPU clocks
Date: Thu,  8 Jul 2010 14:22:32 +0200
Message-Id: <1278591752-9782-1-git-send-email-tomasz.buchert@inria.fr>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per-thread CPU clocks are so far accessible only within
the same thread group. This patch makes it possible to get
this information for any thread of the same user and for
a user with CAP_SYS_ADMIN capability.

same_thread_group is not used anymore because if the thread is in
the same thread group as 'current' then they will have the same
owner anyway.

Signed-off-by: Tomasz Buchert <tomasz.buchert@inria.fr>
Signed-off-by: Lucas Nussbaum <lucas.nussbaum@loria.fr>
---
 kernel/posix-cpu-timers.c |   33 ++++++++++++++++++++++++++-------
 1 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 9829646..db7fce5 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -25,6 +25,24 @@ void update_rlimit_cpu(unsigned long rlim_new)
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
+/*
+ * Check whether the CPU clock for task p is available to current.
+ * At least the RCU read lock must be held.
+ */
+static int clock_access_allowed(struct task_struct *p)
+{
+	const struct cred *cred, *pcred;
+
+	if (unlikely(capable(CAP_SYS_ADMIN)))
+		return 1;
+
+	cred = current_cred();
+	pcred = __task_cred(p);
+
+	return (cred->euid == pcred->euid ||
+		cred->euid == pcred->uid);
+}
+
 static int check_clock(const clockid_t which_clock)
 {
 	int error = 0;
@@ -40,7 +58,7 @@ static int check_clock(const clockid_t which_clock)
 	read_lock(&tasklist_lock);
 	p = find_task_by_vpid(pid);
 	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
-		   same_thread_group(p, current) : thread_group_leader(p))) {
+		   clock_access_allowed(p) : thread_group_leader(p))) {
 		error = -EINVAL;
 	}
 	read_unlock(&tasklist_lock);
@@ -357,16 +375,17 @@ int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 		p = find_task_by_vpid(pid);
 		if (p) {
 			if (CPUCLOCK_PERTHREAD(which_clock)) {
-				if (same_thread_group(p, current)) {
-					error = cpu_clock_sample(which_clock,
-								 p, &rtn);
+				if (clock_access_allowed(p)) {
+					error =
+						cpu_clock_sample(
+							which_clock, p, &rtn);
 				}
 			} else {
 				read_lock(&tasklist_lock);
 				if (thread_group_leader(p) && p->sighand) {
 					error =
-					    cpu_clock_sample_group(which_clock,
-							           p, &rtn);
+						cpu_clock_sample_group(
+							which_clock, p, &rtn);
 				}
 				read_unlock(&tasklist_lock);
 			}
@@ -403,7 +422,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
 			p = current;
 		} else {
 			p = find_task_by_vpid(pid);
-			if (p && !same_thread_group(p, current))
+			if (p && !clock_access_allowed(p))
 				p = NULL;
 		}
 	} else {
-- 
1.6.3.3

