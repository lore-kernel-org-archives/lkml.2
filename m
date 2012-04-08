Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab2DHFNZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:13:25 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51575 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab2DHFMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:31 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat,  7 Apr 2012 22:15:34 -0700
Message-Id: <1333862139-31737-38-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/Ih9BWiNR57mj/jzknwExQ6rv0xbODChc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 
X-Spam-Combo: ***;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 38/43] userns: Convert proc to use kuid/kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/array.c               |   10 ++++++++--
 fs/proc/base.c                |   16 ++++++++--------
 fs/proc/inode.c               |    4 ++--
 fs/proc/root.c                |    2 +-
 include/linux/pid_namespace.h |    2 +-
 include/linux/proc_fs.h       |    4 ++--
 6 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 36a0a91..dc4c5a7 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -191,8 +191,14 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		task_tgid_nr_ns(p, ns),
 		pid_nr_ns(pid, ns),
 		ppid, tpid,
-		cred->uid, cred->euid, cred->suid, cred->fsuid,
-		cred->gid, cred->egid, cred->sgid, cred->fsgid);
+		from_kuid_munged(user_ns, cred->uid),
+		from_kuid_munged(user_ns, cred->euid),
+		from_kuid_munged(user_ns, cred->suid),
+		from_kuid_munged(user_ns, cred->fsuid),
+		from_kgid_munged(user_ns, cred->gid),
+		from_kgid_munged(user_ns, cred->egid),
+		from_kgid_munged(user_ns, cred->sgid),
+		from_kgid_munged(user_ns, cred->fsgid));
 
 	task_lock(p);
 	if (p->files)
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2ee514c..c479049 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1562,8 +1562,8 @@ int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 	generic_fillattr(inode, stat);
 
 	rcu_read_lock();
-	stat->uid = 0;
-	stat->gid = 0;
+	stat->uid = GLOBAL_ROOT_UID;
+	stat->gid = GLOBAL_ROOT_GID;
 	task = pid_task(proc_pid(inode), PIDTYPE_PID);
 	if (task) {
 		if (!has_pid_permissions(pid, task, 2)) {
@@ -1623,8 +1623,8 @@ int pid_revalidate(struct dentry *dentry, struct nameidata *nd)
 			inode->i_gid = cred->egid;
 			rcu_read_unlock();
 		} else {
-			inode->i_uid = 0;
-			inode->i_gid = 0;
+			inode->i_uid = GLOBAL_ROOT_UID;
+			inode->i_gid = GLOBAL_ROOT_GID;
 		}
 		inode->i_mode &= ~(S_ISUID | S_ISGID);
 		security_task_to_inode(task, inode);
@@ -1811,8 +1811,8 @@ static int tid_fd_revalidate(struct dentry *dentry, struct nameidata *nd)
 					inode->i_gid = cred->egid;
 					rcu_read_unlock();
 				} else {
-					inode->i_uid = 0;
-					inode->i_gid = 0;
+					inode->i_uid = GLOBAL_ROOT_UID;
+					inode->i_gid = GLOBAL_ROOT_GID;
 				}
 				inode->i_mode &= ~(S_ISUID | S_ISGID);
 				security_task_to_inode(task, inode);
@@ -2061,8 +2061,8 @@ static int map_files_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 			inode->i_gid = cred->egid;
 			rcu_read_unlock();
 		} else {
-			inode->i_uid = 0;
-			inode->i_gid = 0;
+			inode->i_uid = GLOBAL_ROOT_UID;
+			inode->i_gid = GLOBAL_ROOT_GID;
 		}
 		security_task_to_inode(task, inode);
 		status = 1;
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 205c922..554ecc5 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -108,8 +108,8 @@ static int proc_show_options(struct seq_file *seq, struct dentry *root)
 	struct super_block *sb = root->d_sb;
 	struct pid_namespace *pid = sb->s_fs_info;
 
-	if (pid->pid_gid)
-		seq_printf(seq, ",gid=%lu", (unsigned long)pid->pid_gid);
+	if (!gid_eq(pid->pid_gid, GLOBAL_ROOT_GID))
+		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, pid->pid_gid));
 	if (pid->hide_pid != 0)
 		seq_printf(seq, ",hidepid=%u", pid->hide_pid);
 
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 46a15d8..df4e456 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -67,7 +67,7 @@ static int proc_parse_options(char *options, struct pid_namespace *pid)
 		case Opt_gid:
 			if (match_int(&args[0], &option))
 				return 0;
-			pid->pid_gid = option;
+			pid->pid_gid = make_kgid(current_user_ns(), option);
 			break;
 		case Opt_hidepid:
 			if (match_int(&args[0], &option))
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index b067bd8..00474b0 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -31,7 +31,7 @@ struct pid_namespace {
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct bsd_acct_struct *bacct;
 #endif
-	gid_t pid_gid;
+	kgid_t pid_gid;
 	int hide_pid;
 	int reboot;	/* group exit code if this pidns was rebooted */
 };
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 85c5073..3fd2e87 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -52,8 +52,8 @@ struct proc_dir_entry {
 	unsigned int low_ino;
 	umode_t mode;
 	nlink_t nlink;
-	uid_t uid;
-	gid_t gid;
+	kuid_t uid;
+	kgid_t gid;
 	loff_t size;
 	const struct inode_operations *proc_iops;
 	/*
-- 
1.7.2.5

