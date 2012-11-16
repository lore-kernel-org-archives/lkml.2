Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2KPQhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:37:35 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49152 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab2KPQhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:37:32 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
        Serge Hallyn <serge@hallyn.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Fri, 16 Nov 2012 08:35:49 -0800
Message-Id: <1353083750-3621-10-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353083750-3621-1-git-send-email-ebiederm@xmission.com>
References: <8739097bkk.fsf@xmission.com>
 <1353083750-3621-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+tEBpq2ERfSSjWnXwj+QAa829p3a/mE5A=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1552]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XMMoneyMeta_00 Subject Contains Money Spam
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH 10/11] pidns: Consolidate initialzation of special init task state
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Instead of setting child_reaper and SIGNAL_UNKILLABLE one way
for the system init process, and another way for pid namespace
init processes test pid->nr == 1 and use the same code for both.

For the global init this results in SIGNAL_UNKILLABLE being set
much earlier in the initialization process.

This is a small cleanup and it paves the way for allowing unshare and
enter of the pid namespace as that path like our global init also will
not set CLONE_NEWPID.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 init/main.c   |    1 -
 kernel/fork.c |    6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/init/main.c b/init/main.c
index 9cf77ab..317750a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -810,7 +810,6 @@ static int __ref kernel_init(void *unused)
 	system_state = SYSTEM_RUNNING;
 	numa_default_policy();
 
-	current->signal->flags |= SIGNAL_UNKILLABLE;
 	flush_delayed_fput();
 
 	if (ramdisk_execute_command) {
diff --git a/kernel/fork.c b/kernel/fork.c
index 666dc8b..0f2bbce 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1039,8 +1039,6 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	atomic_set(&sig->live, 1);
 	atomic_set(&sig->sigcnt, 1);
 	init_waitqueue_head(&sig->wait_chldexit);
-	if (clone_flags & CLONE_NEWPID)
-		sig->flags |= SIGNAL_UNKILLABLE;
 	sig->curr_target = tsk;
 	init_sigpending(&sig->shared_pending);
 	INIT_LIST_HEAD(&sig->posix_timers);
@@ -1441,8 +1439,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		ptrace_init_task(p, (clone_flags & CLONE_PTRACE) || trace);
 
 		if (thread_group_leader(p)) {
-			if (is_child_reaper(pid))
+			if (is_child_reaper(pid)) {
 				ns_of_pid(pid)->child_reaper = p;
+				p->signal->flags |= SIGNAL_UNKILLABLE;
+			}
 
 			p->signal->leader_pid = pid;
 			p->signal->tty = tty_kref_get(current->signal->tty);
-- 
1.7.5.4

