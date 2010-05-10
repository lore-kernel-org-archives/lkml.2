Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab0EJSCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 14:02:05 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:37114 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab0EJSBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 14:01:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: adobriyan@gmail.com, nhorman@tuxdriver.com, oleg@redhat.com,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH v3 05/11] rlimits: allow setrlimit to non-current tasks
Date: Mon, 10 May 2010 20:00:45 +0200
Message-Id: <1273514451-28894-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273514451-28894-1-git-send-email-jslaby@suse.cz>
References: <1273514451-28894-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Add locking to allow setrlimit accept task parameter other than
current.

Namely, lock tasklist_lock for read and check whether the task
structure has sighand non-null. Do all the signal processing under
that lock still held.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sys.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 7c76f84..eb21661 100644
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
 	retval = security_task_setrlimit(tsk, resource, new_rlim);
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


