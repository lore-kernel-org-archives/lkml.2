Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab2IVBfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 21:35:23 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56111 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447Ab2IVBfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 21:35:21 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Fri, 21 Sep 2012 18:35:02 -0700
Message-Id: <1348277712-30055-1-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <877grmj115.fsf@xmission.com>
References: <877grmj115.fsf@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/ADbjkLv9RBMprpT3Q+DAPxEVSxvSQgd8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0507]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 01/11] userns: Convert affs to use kuid/kgid wherwe appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/affs/affs.h  |    4 ++--
 fs/affs/inode.c |   20 ++++++++++----------
 fs/affs/super.c |   18 +++++++++++-------
 init/Kconfig    |    1 -
 4 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index 6e21641..3952121 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -88,8 +88,8 @@ struct affs_sb_info {
 	u32 s_root_block;		/* FFS root block number. */
 	int s_hashsize;			/* Size of hash table. */
 	unsigned long s_flags;		/* See below. */
-	uid_t s_uid;			/* uid to override */
-	gid_t s_gid;			/* gid to override */
+	kuid_t s_uid;			/* uid to override */
+	kgid_t s_gid;			/* gid to override */
 	umode_t s_mode;			/* mode to override */
 	struct buffer_head *s_root_bh;	/* Cached root block. */
 	struct mutex s_bmlock;		/* Protects bitmap access. */
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 8bc4a59..15c4842 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -80,17 +80,17 @@ struct inode *affs_iget(struct super_block *sb, unsigned long ino)
 	if (id == 0 || sbi->s_flags & SF_SETUID)
 		inode->i_uid = sbi->s_uid;
 	else if (id == 0xFFFF && sbi->s_flags & SF_MUFS)
-		inode->i_uid = 0;
+		i_uid_write(inode, 0);
 	else
-		inode->i_uid = id;
+		i_uid_write(inode, id);
 
 	id = be16_to_cpu(tail->gid);
 	if (id == 0 || sbi->s_flags & SF_SETGID)
 		inode->i_gid = sbi->s_gid;
 	else if (id == 0xFFFF && sbi->s_flags & SF_MUFS)
-		inode->i_gid = 0;
+		i_gid_write(inode, 0);
 	else
-		inode->i_gid = id;
+		i_gid_write(inode, id);
 
 	switch (be32_to_cpu(tail->stype)) {
 	case ST_ROOT:
@@ -193,13 +193,13 @@ affs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		tail->size = cpu_to_be32(inode->i_size);
 		secs_to_datestamp(inode->i_mtime.tv_sec,&tail->change);
 		if (!(inode->i_ino == AFFS_SB(sb)->s_root_block)) {
-			uid = inode->i_uid;
-			gid = inode->i_gid;
+			uid = i_uid_read(inode);
+			gid = i_gid_read(inode);
 			if (AFFS_SB(sb)->s_flags & SF_MUFS) {
-				if (inode->i_uid == 0 || inode->i_uid == 0xFFFF)
-					uid = inode->i_uid ^ ~0;
-				if (inode->i_gid == 0 || inode->i_gid == 0xFFFF)
-					gid = inode->i_gid ^ ~0;
+				if (uid == 0 || uid == 0xFFFF)
+					uid = uid ^ ~0;
+				if (gid == 0 || gid == 0xFFFF)
+					gid = gid ^ ~0;
 			}
 			if (!(AFFS_SB(sb)->s_flags & SF_SETUID))
 				tail->uid = cpu_to_be16(uid);
diff --git a/fs/affs/super.c b/fs/affs/super.c
index c70f1e5..966c8c0 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -188,7 +188,7 @@ static const match_table_t tokens = {
 };
 
 static int
-parse_options(char *options, uid_t *uid, gid_t *gid, int *mode, int *reserved, s32 *root,
+parse_options(char *options, kuid_t *uid, kgid_t *gid, int *mode, int *reserved, s32 *root,
 		int *blocksize, char **prefix, char *volume, unsigned long *mount_opts)
 {
 	char *p;
@@ -253,13 +253,17 @@ parse_options(char *options, uid_t *uid, gid_t *gid, int *mode, int *reserved, s
 		case Opt_setgid:
 			if (match_int(&args[0], &option))
 				return 0;
-			*gid = option;
+			*gid = make_kgid(current_user_ns(), option);
+			if (!gid_valid(*gid))
+				return 0;
 			*mount_opts |= SF_SETGID;
 			break;
 		case Opt_setuid:
 			if (match_int(&args[0], &option))
 				return 0;
-			*uid = option;
+			*uid = make_kuid(current_user_ns(), option);
+			if (!uid_valid(*uid))
+				return 0;
 			*mount_opts |= SF_SETUID;
 			break;
 		case Opt_verbose:
@@ -301,8 +305,8 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 	int			 num_bm;
 	int			 i, j;
 	s32			 key;
-	uid_t			 uid;
-	gid_t			 gid;
+	kuid_t			 uid;
+	kgid_t			 gid;
 	int			 reserved;
 	unsigned long		 mount_flags;
 	int			 tmp_flags;	/* fix remount prototype... */
@@ -527,8 +531,8 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct affs_sb_info	*sbi = AFFS_SB(sb);
 	int			 blocksize;
-	uid_t			 uid;
-	gid_t			 gid;
+	kuid_t			 uid;
+	kgid_t			 gid;
 	int			 mode;
 	int			 reserved;
 	int			 root_block;
diff --git a/init/Kconfig b/init/Kconfig
index 8691098..a358f4a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -928,7 +928,6 @@ config UIDGID_CONVERTED
 
 	# Filesystems
 	depends on 9P_FS = n
-	depends on AFFS_FS = n
 	depends on AFS_FS = n
 	depends on AUTOFS4_FS = n
 	depends on BFS_FS = n
-- 
1.7.5.4

