Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab2ITCMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 22:12:51 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51808 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab2ITCLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 22:11:36 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 19 Sep 2012 18:52:14 -0700
Message-Id: <1348105949-25454-12-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
References: <871uhx1n71.fsf@xmission.com>
 <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/PsgVD3tPmYoLuCc8HVySvDoSeuo3ruX8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3709]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 12/27] userns: Convert audit to work with user namespaces enabled
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Explicitly format uids gids in audit messges in the initial user
  namespace. This is safe because auditd is restrected to be in
  the initial user namespace.

- Convert audit_sig_uid into a kuid_t.

- Enable building the audit code and user namespaces at the same time.

The net result is that the audit subsystem now uses kuid_t and kgid_t whenever
possible making it almost impossible to confuse a raw uid_t with a kuid_t
preventing bugs.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/tty/tty_audit.c |    5 ++-
 init/Kconfig            |    2 -
 kernel/audit.c          |    4 +-
 kernel/audit.h          |    2 +-
 kernel/auditsc.c        |   51 ++++++++++++++++++++++++++++------------------
 5 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/drivers/tty/tty_audit.c b/drivers/tty/tty_audit.c
index 5b59bd7..b0b39b8 100644
--- a/drivers/tty/tty_audit.c
+++ b/drivers/tty/tty_audit.c
@@ -69,11 +69,12 @@ static void tty_audit_log(const char *description, struct task_struct *tsk,
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_TTY);
 	if (ab) {
 		char name[sizeof(tsk->comm)];
-		uid_t uid = task_uid(tsk);
+		kuid_t uid = task_uid(tsk);
 
 		audit_log_format(ab, "%s pid=%u uid=%u auid=%u ses=%u "
 				 "major=%d minor=%d comm=", description,
-				 tsk->pid, uid,
+				 tsk->pid,
+				 from_kuid(&init_user_ns, uid),
 				 from_kuid(&init_user_ns, loginuid),
 				 sessionid,
 				 major, minor);
diff --git a/init/Kconfig b/init/Kconfig
index fd8696b..b5ecb4e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -927,8 +927,6 @@ config UIDGID_CONVERTED
 	# Features
 	depends on IMA = n
 	depends on EVM = n
-	depends on AUDIT = n
-	depends on AUDITSYSCALL = n
 	depends on TASKSTATS = n
 	depends on TRACING = n
 	depends on FS_POSIX_ACL = n
diff --git a/kernel/audit.c b/kernel/audit.c
index 44a4b13..511488a 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -105,7 +105,7 @@ static int	audit_backlog_wait_time = 60 * HZ;
 static int	audit_backlog_wait_overflow = 0;
 
 /* The identity of the user shutting down the audit system. */
-uid_t		audit_sig_uid = -1;
+kuid_t		audit_sig_uid = INVALID_UID;
 pid_t		audit_sig_pid = -1;
 u32		audit_sig_sid = 0;
 
@@ -853,7 +853,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				security_release_secctx(ctx, len);
 			return -ENOMEM;
 		}
-		sig_data->uid = audit_sig_uid;
+		sig_data->uid = from_kuid(&init_user_ns, audit_sig_uid);
 		sig_data->pid = audit_sig_pid;
 		if (audit_sig_sid) {
 			memcpy(sig_data->ctx, ctx, len);
diff --git a/kernel/audit.h b/kernel/audit.h
index 4b428bb..9eb3d79 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -146,7 +146,7 @@ extern void audit_kill_trees(struct list_head *);
 extern char *audit_unpack_string(void **, size_t *, size_t);
 
 extern pid_t audit_sig_pid;
-extern uid_t audit_sig_uid;
+extern kuid_t audit_sig_uid;
 extern u32 audit_sig_sid;
 
 #ifdef CONFIG_AUDITSYSCALL
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 26fdfc0..ff4798f 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -150,7 +150,7 @@ struct audit_aux_data_pids {
 	struct audit_aux_data	d;
 	pid_t			target_pid[AUDIT_AUX_PIDS];
 	kuid_t			target_auid[AUDIT_AUX_PIDS];
-	uid_t			target_uid[AUDIT_AUX_PIDS];
+	kuid_t			target_uid[AUDIT_AUX_PIDS];
 	unsigned int		target_sessionid[AUDIT_AUX_PIDS];
 	u32			target_sid[AUDIT_AUX_PIDS];
 	char 			target_comm[AUDIT_AUX_PIDS][TASK_COMM_LEN];
@@ -208,14 +208,14 @@ struct audit_context {
 	size_t sockaddr_len;
 				/* Save things to print about task_struct */
 	pid_t		    pid, ppid;
-	uid_t		    uid, euid, suid, fsuid;
-	gid_t		    gid, egid, sgid, fsgid;
+	kuid_t		    uid, euid, suid, fsuid;
+	kgid_t		    gid, egid, sgid, fsgid;
 	unsigned long	    personality;
 	int		    arch;
 
 	pid_t		    target_pid;
 	kuid_t		    target_auid;
-	uid_t		    target_uid;
+	kuid_t		    target_uid;
 	unsigned int	    target_sessionid;
 	u32		    target_sid;
 	char		    target_comm[TASK_COMM_LEN];
@@ -231,8 +231,8 @@ struct audit_context {
 			long args[6];
 		} socketcall;
 		struct {
-			uid_t			uid;
-			gid_t			gid;
+			kuid_t			uid;
+			kgid_t			gid;
 			umode_t			mode;
 			u32			osid;
 			int			has_perm;
@@ -1176,7 +1176,7 @@ static void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk
 }
 
 static int audit_log_pid_context(struct audit_context *context, pid_t pid,
-				 kuid_t auid, uid_t uid, unsigned int sessionid,
+				 kuid_t auid, kuid_t uid, unsigned int sessionid,
 				 u32 sid, char *comm)
 {
 	struct audit_buffer *ab;
@@ -1190,7 +1190,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 
 	audit_log_format(ab, "opid=%d oauid=%d ouid=%d oses=%d", pid,
 			 from_kuid(&init_user_ns, auid),
-			 uid, sessionid);
+			 from_kuid(&init_user_ns, uid), sessionid);
 	if (security_secid_to_secctx(sid, &ctx, &len)) {
 		audit_log_format(ab, " obj=(none)");
 		rc = 1;
@@ -1440,7 +1440,9 @@ static void show_special(struct audit_context *context, int *call_panic)
 		u32 osid = context->ipc.osid;
 
 		audit_log_format(ab, "ouid=%u ogid=%u mode=%#ho",
-			 context->ipc.uid, context->ipc.gid, context->ipc.mode);
+				 from_kuid(&init_user_ns, context->ipc.uid),
+				 from_kgid(&init_user_ns, context->ipc.gid),
+				 context->ipc.mode);
 		if (osid) {
 			char *ctx = NULL;
 			u32 len;
@@ -1553,8 +1555,8 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 				 MAJOR(n->dev),
 				 MINOR(n->dev),
 				 n->mode,
-				 n->uid,
-				 n->gid,
+				 from_kuid(&init_user_ns, n->uid),
+				 from_kgid(&init_user_ns, n->gid),
 				 MAJOR(n->rdev),
 				 MINOR(n->rdev));
 	}
@@ -1632,10 +1634,15 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 		  context->ppid,
 		  context->pid,
 		  from_kuid(&init_user_ns, tsk->loginuid),
-		  context->uid,
-		  context->gid,
-		  context->euid, context->suid, context->fsuid,
-		  context->egid, context->sgid, context->fsgid, tty,
+		  from_kuid(&init_user_ns, context->uid),
+		  from_kgid(&init_user_ns, context->gid),
+		  from_kuid(&init_user_ns, context->euid),
+		  from_kuid(&init_user_ns, context->suid),
+		  from_kuid(&init_user_ns, context->fsuid),
+		  from_kgid(&init_user_ns, context->egid),
+		  from_kgid(&init_user_ns, context->sgid),
+		  from_kgid(&init_user_ns, context->fsgid),
+		  tty,
 		  tsk->sessionid);
 
 
@@ -2315,7 +2322,8 @@ int audit_set_loginuid(kuid_t loginuid)
 			audit_log_format(ab, "login pid=%d uid=%u "
 				"old auid=%u new auid=%u"
 				" old ses=%u new ses=%u",
-				task->pid, task_uid(task),
+				task->pid,
+				from_kuid(&init_user_ns, task_uid(task)),
 				from_kuid(&init_user_ns, task->loginuid),
 				from_kuid(&init_user_ns, loginuid),
 				task->sessionid, sessionid);
@@ -2540,7 +2548,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 	struct audit_aux_data_pids *axp;
 	struct task_struct *tsk = current;
 	struct audit_context *ctx = tsk->audit_context;
-	uid_t uid = current_uid(), t_uid = task_uid(t);
+	kuid_t uid = current_uid(), t_uid = task_uid(t);
 
 	if (audit_pid && t->tgid == audit_pid) {
 		if (sig == SIGTERM || sig == SIGHUP || sig == SIGUSR1 || sig == SIGUSR2) {
@@ -2666,8 +2674,8 @@ void __audit_mmap_fd(int fd, int flags)
 
 static void audit_log_abend(struct audit_buffer *ab, char *reason, long signr)
 {
-	uid_t auid, uid;
-	gid_t gid;
+	kuid_t auid, uid;
+	kgid_t gid;
 	unsigned int sessionid;
 
 	auid = audit_get_loginuid(current);
@@ -2675,7 +2683,10 @@ static void audit_log_abend(struct audit_buffer *ab, char *reason, long signr)
 	current_uid_gid(&uid, &gid);
 
 	audit_log_format(ab, "auid=%u uid=%u gid=%u ses=%u",
-			 auid, uid, gid, sessionid);
+			 from_kuid(&init_user_ns, auid),
+			 from_kuid(&init_user_ns, uid),
+			 from_kgid(&init_user_ns, gid),
+			 sessionid);
 	audit_log_task_context(ab);
 	audit_log_format(ab, " pid=%d comm=", current->pid);
 	audit_log_untrustedstring(ab, current->comm);
-- 
1.7.5.4

