Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab0FWSMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 14:12:20 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37068 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab0FWSMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 14:12:18 -0400
Date: Wed, 23 Jun 2010 11:11:29 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] sanitize task->comm to avoid leaking escape codes
Message-ID: <20100623181129.GM5876@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Through get_task_comm() and many direct uses of task->comm in the kernel,
it is possible for escape codes and other non-printables to leak into
dmesg, syslog, etc.  In the worst case, these strings could be used to
attack administrators using vulnerable terminal emulators, and at least
cause confusion through the injection of \r characters.

This patch sanitizes task->comm to only contain printable characters
when it is set.  Additionally, it redefines get_task_comm so that it
cannot be misused by callers (presently nothing was incorrectly calling
get_task_comm's unsafe use of strncpy).

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 fs/exec.c             |   17 +++++++++++++----
 include/linux/sched.h |    3 ++-
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 85092e3..aa84f66 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -935,17 +935,18 @@ static void flush_old_files(struct files_struct * files)
 	spin_unlock(&files->file_lock);
 }
 
-char *get_task_comm(char *buf, struct task_struct *tsk)
+char *get_task_comm_size(char *buf, size_t len, struct task_struct *tsk)
 {
-	/* buf must be at least sizeof(tsk->comm) in size */
 	task_lock(tsk);
-	strncpy(buf, tsk->comm, sizeof(tsk->comm));
+	strlcpy(buf, tsk->comm, len);
 	task_unlock(tsk);
 	return buf;
 }
 
 void set_task_comm(struct task_struct *tsk, char *buf)
 {
+	size_t i;
+
 	task_lock(tsk);
 
 	/*
@@ -956,7 +957,15 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 	 */
 	memset(tsk->comm, 0, TASK_COMM_LEN);
 	wmb();
-	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
+
+	/* sanitize non-printable characters */
+	for (i = 0; buf[i] && i < (sizeof(tsk->comm) - 1); i++) {
+		if (!isprint(buf[i]))
+			tsk->comm[i] = '?';
+		else
+			tsk->comm[i] = buf[i];
+	}
+
 	task_unlock(tsk);
 	perf_event_comm(tsk);
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f118809..0ba69dc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2117,7 +2117,8 @@ extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned lon
 struct task_struct *fork_idle(int);
 
 extern void set_task_comm(struct task_struct *tsk, char *from);
-extern char *get_task_comm(char *to, struct task_struct *tsk);
+#define get_task_comm(buf, task) get_task_comm_size(buf, sizeof(buf), task)
+extern char *get_task_comm_size(char *to, size_t len, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
 extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
-- 
1.7.1


-- 
Kees Cook
Ubuntu Security Team
