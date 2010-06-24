Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab0FXTH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 15:07:56 -0400
Received: from smtp.outflux.net ([198.145.64.163]:45575 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab0FXTHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 15:07:54 -0400
Date: Thu, 24 Jun 2010 12:05:27 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Veaceslav Falico <vfalico@redhat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oleg Nesterov <oleg@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Stefani Seibold <stefani@seibold.net>,
       Thomas Gleixner <tglx@linutronix.de>, Eric Paris <eparis@redhat.com>,
       James Morris <jmorris@namei.org>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Steve Grubb <sgrubb@redhat.com>,
       Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2] sanitize task->comm to avoid leaking escape codes
Message-ID: <20100624190527.GD5917@outflux.net>
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
when it is set.  Additionally, it redefines get_task_comm so that it is
more obvious when misused by callers (presently nothing was incorrectly
calling get_task_comm's unsafe use of strncpy).

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
v2:
 - don't use a helper #define, just fix the arguments and callers
 - add missing ctype.h include that got lost during testing.
---
 drivers/char/tty_audit.c |    2 +-
 fs/exec.c                |   18 ++++++++++++++----
 fs/proc/array.c          |    4 ++--
 include/linux/sched.h    |    2 +-
 kernel/auditsc.c         |    2 +-
 kernel/capability.c      |    4 ++--
 kernel/fork.c            |    2 +-
 kernel/sys.c             |    2 +-
 8 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/char/tty_audit.c b/drivers/char/tty_audit.c
index 1b8ee59..b061fe8 100644
--- a/drivers/char/tty_audit.c
+++ b/drivers/char/tty_audit.c
@@ -75,7 +75,7 @@ static void tty_audit_log(const char *description, struct task_struct *tsk,
 				 "major=%d minor=%d comm=", description,
 				 tsk->pid, uid, loginuid, sessionid,
 				 major, minor);
-		get_task_comm(name, tsk);
+		get_task_comm(name, sizeof(name), tsk);
 		audit_log_untrustedstring(ab, name);
 		audit_log_format(ab, " data=");
 		audit_log_n_hex(ab, data, size);
diff --git a/fs/exec.c b/fs/exec.c
index e19de6a..e0e42b7 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -55,6 +55,7 @@
 #include <linux/fsnotify.h>
 #include <linux/fs_struct.h>
 #include <linux/pipe_fs_i.h>
+#include <linux/ctype.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -934,17 +935,18 @@ static void flush_old_files(struct files_struct * files)
 	spin_unlock(&files->file_lock);
 }
 
-char *get_task_comm(char *buf, struct task_struct *tsk)
+char *get_task_comm(char *buf, size_t len, struct task_struct *tsk)
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
@@ -955,7 +957,15 @@ void set_task_comm(struct task_struct *tsk, char *buf)
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
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 9b58d38..cdf55c9 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -93,7 +93,7 @@ static inline void task_name(struct seq_file *m, struct task_struct *p)
 	char *name;
 	char tcomm[sizeof(p->comm)];
 
-	get_task_comm(tcomm, p);
+	get_task_comm(tcomm, sizeof(tcomm), p);
 
 	seq_printf(m, "Name:\t");
 	end = m->buf + m->size;
@@ -393,7 +393,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		}
 	}
 
-	get_task_comm(tcomm, task);
+	get_task_comm(tcomm, sizeof(tcomm), task);
 
 	sigemptyset(&sigign);
 	sigemptyset(&sigcatch);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f118809..dbd538b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2117,7 +2117,7 @@ extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned lon
 struct task_struct *fork_idle(int);
 
 extern void set_task_comm(struct task_struct *tsk, char *from);
-extern char *get_task_comm(char *to, struct task_struct *tsk);
+extern char *get_task_comm(char *to, size_t len, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
 extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 3828ad5..ab8a134 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -956,7 +956,7 @@ static void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk
 
 	/* tsk == current */
 
-	get_task_comm(name, tsk);
+	get_task_comm(name, sizeof(name), tsk);
 	audit_log_format(ab, " comm=");
 	audit_log_untrustedstring(ab, name);
 
diff --git a/kernel/capability.c b/kernel/capability.c
index 2f05303..022fc03 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -51,7 +51,7 @@ static void warn_legacy_capability_use(void)
 
 		printk(KERN_INFO "warning: `%s' uses 32-bit capabilities"
 		       " (legacy support in use)\n",
-		       get_task_comm(name, current));
+		       get_task_comm(name, sizeof(name), current));
 		warned = 1;
 	}
 }
@@ -81,7 +81,7 @@ static void warn_deprecated_v2(void)
 
 		printk(KERN_INFO "warning: `%s' uses deprecated v2"
 		       " capabilities in a way that may be insecure.\n",
-		       get_task_comm(name, current));
+		       get_task_comm(name, sizeof(name), current));
 		warned = 1;
 	}
 }
diff --git a/kernel/fork.c b/kernel/fork.c
index b6cce14..8c23470 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1403,7 +1403,7 @@ long do_fork(unsigned long clone_flags,
 			count--;
 			printk(KERN_INFO "fork(): process `%s' used deprecated "
 					"clone flags 0x%lx\n",
-				get_task_comm(comm, current),
+				get_task_comm(comm, sizeof(comm), current),
 				clone_flags & CLONE_STOPPED);
 		}
 	}
diff --git a/kernel/sys.c b/kernel/sys.c
index e83ddbb..b1a215b 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1535,7 +1535,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			set_task_comm(me, comm);
 			return 0;
 		case PR_GET_NAME:
-			get_task_comm(comm, me);
+			get_task_comm(comm, sizeof(comm), me);
 			if (copy_to_user((char __user *)arg2, comm,
 					 sizeof(comm)))
 				return -EFAULT;
-- 
1.7.1


-- 
Kees Cook
Ubuntu Security Team
