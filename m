Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239Ab2GKTCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:02:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758066Ab2GKTCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:02:18 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: aris@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] userns: Convert autofs4 to use kuid and kgid where appropriate
Date: Wed, 11 Jul 2012 15:01:22 -0400
Message-Id: <1342033282-24933-6-git-send-email-arozansk@redhat.com>
In-Reply-To: <1342033282-24933-1-git-send-email-arozansk@redhat.com>
References: <1342033282-24933-1-git-send-email-arozansk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aristeu Rozanski <aris@redhat.com>

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
---
 fs/autofs4/inode.c |   32 +++++++++++++++++++++++---------
 fs/autofs4/waitq.c |    4 ++--
 init/Kconfig       |    1 -
 3 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index d8dc002..f30b73a 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -37,8 +37,8 @@ struct autofs_info *autofs4_new_ino(struct autofs_sb_info *sbi)
 
 void autofs4_clean_ino(struct autofs_info *ino)
 {
-	ino->uid = 0;
-	ino->gid = 0;
+	ino->uid = from_kuid_munged(&init_user_ns, GLOBAL_ROOT_UID);
+	ino->gid = from_kgid_munged(&init_user_ns, GLOBAL_ROOT_GID);
 	ino->last_used = jiffies;
 }
 
@@ -80,10 +80,12 @@ static int autofs4_show_options(struct seq_file *m, struct dentry *root)
 		return 0;
 
 	seq_printf(m, ",fd=%d", sbi->pipefd);
-	if (root_inode->i_uid != 0)
-		seq_printf(m, ",uid=%u", root_inode->i_uid);
-	if (root_inode->i_gid != 0)
-		seq_printf(m, ",gid=%u", root_inode->i_gid);
+	if (!uid_eq(root_inode->i_uid, GLOBAL_ROOT_UID))
+		seq_printf(m, ",uid=%u", from_kuid_munged(current_user_ns(),
+							  root_inode->i_uid));
+	if (!gid_eq(root_inode->i_gid, GLOBAL_ROOT_GID))
+		seq_printf(m, ",gid=%u", from_kgid_munged(current_user_ns(),
+							  root_inode->i_gid));
 	seq_printf(m, ",pgrp=%d", sbi->oz_pgrp);
 	seq_printf(m, ",timeout=%lu", sbi->exp_timeout/HZ);
 	seq_printf(m, ",minproto=%d", sbi->min_proto);
@@ -127,12 +129,14 @@ static const match_table_t tokens = {
 	{Opt_err, NULL}
 };
 
-static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
+static int parse_options(char *options, int *pipefd, kuid_t *uid, kgid_t *gid,
 		pid_t *pgrp, unsigned int *type, int *minproto, int *maxproto)
 {
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
 	int option;
+	kuid_t kuid;
+	kgid_t kgid;
 
 	*uid = current_uid();
 	*gid = current_gid();
@@ -160,12 +164,22 @@ static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
 		case Opt_uid:
 			if (match_int(args, &option))
 				return 1;
-			*uid = option;
+			kuid = make_kuid(current_user_ns(), option);
+			if (!uid_valid(kuid)) {
+				printk(KERN_INFO "autofs: invalid uid\n");
+				return 1;
+			}
+			*uid = kuid;
 			break;
 		case Opt_gid:
 			if (match_int(args, &option))
 				return 1;
-			*gid = option;
+			kgid = make_kgid(current_user_ns(), option);
+			if (!gid_valid(kgid)) {
+				printk(KERN_INFO "autofs: invalid gid\n");
+				return 1;
+			}
+			*gid = kgid;
 			break;
 		case Opt_pgrp:
 			if (match_int(args, &option))
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 9c098db..30a16f0 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -439,8 +439,8 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 		memcpy(&wq->name, &qstr, sizeof(struct qstr));
 		wq->dev = autofs4_get_dev(sbi);
 		wq->ino = autofs4_get_ino(sbi);
-		wq->uid = current_uid();
-		wq->gid = current_gid();
+		wq->uid = from_kuid_munged(&init_user_ns, current_uid());
+		wq->gid = from_kgid_munged(&init_user_ns, current_gid());
 		wq->pid = current->pid;
 		wq->tgid = current->tgid;
 		wq->status = -EINTR; /* Status return if interrupted */
diff --git a/init/Kconfig b/init/Kconfig
index 2ab57ca..3f104e3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -909,7 +909,6 @@ config UIDGID_CONVERTED
 	depends on DEVTMPFS = n
 	depends on XENFS = n
 
-	depends on AUTOFS4_FS = n
 	depends on BEFS_FS = n
 	depends on BFS_FS = n
 	depends on BTRFS_FS = n
-- 
1.7.1

