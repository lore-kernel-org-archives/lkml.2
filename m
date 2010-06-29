Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab0F2PHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:07:47 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34691 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756248Ab0F2PHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:07:45 -0400
Date: Tue, 29 Jun 2010 08:06:32 -0700
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
       Dhaval Giani <dhaval.giani@gmail.com>, Serge Hallyn <serge@hallyn.com>,
       Steve Grubb <sgrubb@redhat.com>, Christoph Hellwig <hch@lst.de>,
       linux-fsdevel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] pass buffer sizes when using get_task_comm()
Message-ID: <20100629150632.GE4175@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch redefines get_task_comm so that it takes the explicit
length of the destination buffer to try and reduce the chance that it
will be misused by callers (presently nothing was incorrectly calling
get_task_comm with destination buffers small enough to make the existing
unsafe use strncpy an actual buffer overflow).

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 drivers/char/tty_audit.c |    2 +-
 fs/exec.c                |    5 ++---
 fs/proc/array.c          |    4 ++--
 include/linux/sched.h    |    2 +-
 kernel/auditsc.c         |    2 +-
 kernel/capability.c      |    4 ++--
 kernel/fork.c            |    2 +-
 kernel/sys.c             |    2 +-
 8 files changed, 11 insertions(+), 12 deletions(-)

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
index e19de6a..2019cf9 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -934,11 +934,10 @@ static void flush_old_files(struct files_struct * files)
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
