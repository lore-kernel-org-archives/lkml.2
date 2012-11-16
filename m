Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab2KPQg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:36:58 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:33591 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab2KPQgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:36:55 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
        Serge Hallyn <serge@hallyn.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Fri, 16 Nov 2012 08:35:46 -0800
Message-Id: <1353083750-3621-7-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353083750-3621-1-git-send-email-ebiederm@xmission.com>
References: <8739097bkk.fsf@xmission.com>
 <1353083750-3621-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX180JtxWB/J4Tb/HERDOcSUD/yaB/gsEwBc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0117]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH 07/11] pidns: Wait in zap_pid_ns_processes until pid_ns->nr_hashed == 1
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Looking at pid_ns->nr_hashed is a bit simpler and it works for
disjoint process trees that an unshare or a join of a pid_namespace
may create.

Acked-by: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/exit.c          |   12 ------------
 kernel/pid.c           |   16 +++++++++++++---
 kernel/pid_namespace.c |   15 ++++-----------
 3 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 346616c..d7fe58d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -72,18 +72,6 @@ static void __unhash_process(struct task_struct *p, bool group_dead)
 		list_del_rcu(&p->tasks);
 		list_del_init(&p->sibling);
 		__this_cpu_dec(process_counts);
-		/*
-		 * If we are the last child process in a pid namespace to be
-		 * reaped, notify the reaper sleeping zap_pid_ns_processes().
-		 */
-		if (IS_ENABLED(CONFIG_PID_NS)) {
-			struct task_struct *parent = p->real_parent;
-
-			if ((task_active_pid_ns(parent)->child_reaper == parent) &&
-			    list_empty(&parent->children) &&
-			    (parent->flags & PF_EXITING))
-				wake_up_process(parent);
-		}
 	}
 	list_del_rcu(&p->thread_group);
 }
diff --git a/kernel/pid.c b/kernel/pid.c
index 9c21911..6e8da29 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -273,10 +273,20 @@ void free_pid(struct pid *pid)
 	spin_lock_irqsave(&pidmap_lock, flags);
 	for (i = 0; i <= pid->level; i++) {
 		struct upid *upid = pid->numbers + i;
+		struct pid_namespace *ns = upid->ns;
 		hlist_del_rcu(&upid->pid_chain);
-		if (--upid->ns->nr_hashed == 0) {
-			upid->ns->nr_hashed = -1;
-			schedule_work(&upid->ns->proc_work);
+		switch(--ns->nr_hashed) {
+		case 1:
+			/* When all that is left in the pid namespace
+			 * is the reaper wake up the reaper.  The reaper
+			 * may be sleeping in zap_pid_ns_processes().
+			 */
+			wake_up_process(ns->child_reaper);
+			break;
+		case 0:
+			ns->nr_hashed = -1;
+			schedule_work(&ns->proc_work);
+			break;
 		}
 	}
 	spin_unlock_irqrestore(&pidmap_lock, flags);
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index cc44db7..e106b18 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -216,22 +216,15 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 
 	/*
 	 * sys_wait4() above can't reap the TASK_DEAD children.
-	 * Make sure they all go away, see __unhash_process().
+	 * Make sure they all go away, see free_pid().
 	 */
 	for (;;) {
-		bool need_wait = false;
-
-		read_lock(&tasklist_lock);
-		if (!list_empty(&current->children)) {
-			__set_current_state(TASK_UNINTERRUPTIBLE);
-			need_wait = true;
-		}
-		read_unlock(&tasklist_lock);
-
-		if (!need_wait)
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (pid_ns->nr_hashed == 1)
 			break;
 		schedule();
 	}
+	__set_current_state(TASK_RUNNING);
 
 	if (pid_ns->reboot)
 		current->signal->group_exit_code = pid_ns->reboot;
-- 
1.7.5.4

