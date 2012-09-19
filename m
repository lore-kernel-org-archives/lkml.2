Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab2ISPaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:30:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:32823 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2ISPaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:30:10 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: raven@themaw.net
Cc: autofs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, sukadev@linux.vnet.ibm.com,
        serge.hallyn@canonical.com, ebiederm@xmission.com, mszeredi@suse.cz,
        Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 1/2] Replace pid_t in autofs4 with struct pid reference.
Date: Wed, 19 Sep 2012 17:29:35 +0200
Message-Id: <1348068576-21363-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348068576-21363-1-git-send-email-miklos@szeredi.hu>
References: <1348068576-21363-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Make autofs4 container-friendly by caching struct pid reference rather
than pid.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/autofs4/autofs_i.h  |    4 ++--
 fs/autofs4/dev-ioctl.c |    3 ++-
 fs/autofs4/inode.c     |   22 +++++++++++++++-------
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 908e184..8457a1f 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -104,7 +104,7 @@ struct autofs_sb_info {
 	u32 magic;
 	int pipefd;
 	struct file *pipe;
-	pid_t oz_pgrp;
+	struct pid *oz_pgrp;
 	int catatonic;
 	int version;
 	int sub_version;
@@ -139,7 +139,7 @@ static inline struct autofs_info *autofs4_dentry_ino(struct dentry *dentry)
    filesystem without "magic".) */
 
 static inline int autofs4_oz_mode(struct autofs_sb_info *sbi) {
-	return sbi->catatonic || task_pgrp_nr(current) == sbi->oz_pgrp;
+	return sbi->catatonic || task_pgrp(current) == sbi->oz_pgrp;
 }
 
 /* Does a dentry have some pending activity? */
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index abf645c..423346d 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -381,7 +381,8 @@ static int autofs_dev_ioctl_setpipefd(struct file *fp,
 			fput(pipe);
 			goto out;
 		}
-		sbi->oz_pgrp = task_pgrp_nr(current);
+		put_pid(sbi->oz_pgrp);
+		sbi->oz_pgrp = get_pid(task_pgrp(current));
 		sbi->pipefd = pipefd;
 		sbi->pipe = pipe;
 		sbi->catatonic = 0;
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 8a4fed8..a2b4f4d 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -62,6 +62,8 @@ void autofs4_kill_sb(struct super_block *sb)
 	/* Free wait queues, close pipe */
 	autofs4_catatonic_mode(sbi);
 
+	put_pid(sbi->oz_pgrp);
+
 	sb->s_fs_info = NULL;
 	kfree(sbi);
 
@@ -83,7 +85,7 @@ static int autofs4_show_options(struct seq_file *m, struct dentry *root)
 		seq_printf(m, ",uid=%u", root_inode->i_uid);
 	if (root_inode->i_gid != 0)
 		seq_printf(m, ",gid=%u", root_inode->i_gid);
-	seq_printf(m, ",pgrp=%d", sbi->oz_pgrp);
+	seq_printf(m, ",pgrp=%d", pid_nr(sbi->oz_pgrp));
 	seq_printf(m, ",timeout=%lu", sbi->exp_timeout/HZ);
 	seq_printf(m, ",minproto=%d", sbi->min_proto);
 	seq_printf(m, ",maxproto=%d", sbi->max_proto);
@@ -127,7 +129,8 @@ static const match_table_t tokens = {
 };
 
 static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
-		pid_t *pgrp, unsigned int *type, int *minproto, int *maxproto)
+			 struct pid **pgrp, unsigned int *type, int *minproto,
+			 int *maxproto)
 {
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
@@ -135,7 +138,6 @@ static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
 
 	*uid = current_uid();
 	*gid = current_gid();
-	*pgrp = task_pgrp_nr(current);
 
 	*minproto = AUTOFS_MIN_PROTO_VERSION;
 	*maxproto = AUTOFS_MAX_PROTO_VERSION;
@@ -169,7 +171,12 @@ static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
 		case Opt_pgrp:
 			if (match_int(args, &option))
 				return 1;
-			*pgrp = option;
+			put_pid(*pgrp);
+			*pgrp = find_get_pid(option);
+			if (!*pgrp) {
+				pr_warn("autofs: could not find process group %d\n", option);
+				return 1;
+			}
 			break;
 		case Opt_minproto:
 			if (match_int(args, &option))
@@ -217,7 +224,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	sbi->pipe = NULL;
 	sbi->catatonic = 1;
 	sbi->exp_timeout = 0;
-	sbi->oz_pgrp = task_pgrp_nr(current);
+	sbi->oz_pgrp = get_pid(task_pgrp(current));
 	sbi->sb = s;
 	sbi->version = 0;
 	sbi->sub_version = 0;
@@ -283,9 +290,9 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 		sbi->version = sbi->max_proto;
 	sbi->sub_version = AUTOFS_PROTO_SUBVERSION;
 
-	DPRINTK("pipe fd = %d, pgrp = %u", pipefd, sbi->oz_pgrp);
+	DPRINTK("pipe fd = %d, pgrp = %u", pipefd, pid_nr(sbi->oz_pgrp));
 	pipe = fget(pipefd);
-	
+
 	if (!pipe) {
 		printk("autofs: could not open pipe file descriptor\n");
 		goto fail_dput;
@@ -315,6 +322,7 @@ fail_dput:
 fail_ino:
 	kfree(ino);
 fail_free:
+	put_pid(sbi->oz_pgrp);
 	kfree(sbi);
 	s->s_fs_info = NULL;
 fail_unlock:
-- 
1.7.7

