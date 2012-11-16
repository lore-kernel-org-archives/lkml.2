Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab2KPQid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:38:33 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:33230 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab2KPQgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:36:19 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
        Serge Hallyn <serge@hallyn.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Fri, 16 Nov 2012 08:35:41 -0800
Message-Id: <1353083750-3621-2-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353083750-3621-1-git-send-email-ebiederm@xmission.com>
References: <8739097bkk.fsf@xmission.com>
 <1353083750-3621-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+UvLSDEYf/kUjBPkKu30xvSyM6Ok5WT74=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0006]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH 02/11] procfs: Don't cache a pid in the root inode.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Now that we have s_fs_info pointing to our pid namespace
the original reason for the proc root inode having a struct
pid is gone.

Caching a pid in the root inode has led to some complicated
code.  Now that we don't need the struct pid, just remove it.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/base.c |   11 +----------
 fs/proc/root.c |    8 --------
 2 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index cbe454e..6177fc2 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2714,19 +2714,12 @@ static int fake_filldir(void *buf, const char *name, int namelen,
 /* for the /proc/ directory itself, after non-process stuff has been done */
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
-	unsigned int nr;
-	struct task_struct *reaper;
 	struct tgid_iter iter;
 	struct pid_namespace *ns;
 	filldir_t __filldir;
 
 	if (filp->f_pos >= PID_MAX_LIMIT + TGID_OFFSET)
-		goto out_no_task;
-	nr = filp->f_pos - FIRST_PROCESS_ENTRY;
-
-	reaper = get_proc_task(filp->f_path.dentry->d_inode);
-	if (!reaper)
-		goto out_no_task;
+		goto out;
 
 	ns = filp->f_dentry->d_sb->s_fs_info;
 	iter.task = NULL;
@@ -2747,8 +2740,6 @@ int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	}
 	filp->f_pos = PID_MAX_LIMIT + TGID_OFFSET;
 out:
-	put_task_struct(reaper);
-out_no_task:
 	return 0;
 }
 
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 5da9849..13ef624 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -100,7 +100,6 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 	int err;
 	struct super_block *sb;
 	struct pid_namespace *ns;
-	struct proc_inode *ei;
 	char *options;
 
 	if (flags & MS_KERNMOUNT) {
@@ -130,13 +129,6 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 		sb->s_flags |= MS_ACTIVE;
 	}
 
-	ei = PROC_I(sb->s_root->d_inode);
-	if (!ei->pid) {
-		rcu_read_lock();
-		ei->pid = get_pid(find_pid_ns(1, ns));
-		rcu_read_unlock();
-	}
-
 	return dget(sb->s_root);
 }
 
-- 
1.7.5.4

