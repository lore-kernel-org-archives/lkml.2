Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab0FWVwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 17:52:54 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:37301 "EHLO
	mail.pripojeni.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752188Ab0FWVwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 17:52:49 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
       adobriyan@gmail.com, nhorman@tuxdriver.com,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 06/12] rlimits: allow setrlimit to non-current tasks
Date: Wed, 23 Jun 2010 23:52:07 +0200
Message-Id: <1277329933-8139-6-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277329933-8139-1-git-send-email-jslaby@suse.cz>
References: <1277329933-8139-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Add locking to allow setrlimit accept task parameter other than
current.

Namely, lock tasklist_lock for read and check whether the task
structure has sighand non-null. Do all the signal processing under
that lock still held.

There are some points:
1) security_task_setrlimit is now called with that lock held. This is
   not new, many security_* functions are called with this lock held
   already so it doesn't harm (all this security_* stuff does almost
   the same).
2) task->sighand->siglock (in update_rlimit_cpu) is nested in
   tasklist_lock. This dependence is already existing.
3) tsk->alloc_lock is nested in tasklist_lock. This is OK too, already
   existing dependence.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sys.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index b5b96e3..9dbcbbc 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1272,6 +1272,7 @@ SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,
 
 #endif
 
+/* make sure you are allowed to change @tsk limits before calling this */
 int do_setrlimit(struct task_struct *tsk, unsigned int resource,
 		struct rlimit *new_rlim)
 {
@@ -1285,9 +1286,16 @@ int do_setrlimit(struct task_struct *tsk, unsigned int resource,
 	if (resource == RLIMIT_NOFILE && new_rlim->rlim_max > sysctl_nr_open)
 		return -EPERM;
 
+	/* protect tsk->signal and tsk->sighand from disappearing */
+	read_lock(&tasklist_lock);
+	if (!tsk->sighand) {
+		retval = -ESRCH;
+		goto out;
+	}
+
 	retval = security_task_setrlimit(tsk->group_leader, resource, new_rlim);
 	if (retval)
-		return retval;
+		goto out;
 
 	if (resource == RLIMIT_CPU && new_rlim->rlim_cur == 0) {
 		/*
@@ -1322,6 +1330,7 @@ int do_setrlimit(struct task_struct *tsk, unsigned int resource,
 
 	update_rlimit_cpu(tsk, new_rlim->rlim_cur);
 out:
+	read_unlock(&tasklist_lock);
 	return retval;
 }
 
-- 
1.7.1


