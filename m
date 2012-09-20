Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab2ITLmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:42:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51839 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab2ITLm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:42:28 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Thu, 20 Sep 2012 04:41:42 -0700
Message-Id: <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <877grox6ql.fsf@xmission.com>
References: <877grox6ql.fsf@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19BN3+0cd757Up00zbx9cBIvhOgbFrtmWA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4695]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 01/25] userns: Convert fat to use kuid/kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/fat/fat.h   |    4 ++--
 fs/fat/file.c  |    6 +++---
 fs/fat/inode.c |   18 ++++++++++++------
 init/Kconfig   |    1 -
 4 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 2deeeb8..7d8e0dc 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -23,8 +23,8 @@
 #define FAT_ERRORS_RO		3      /* remount r/o on error */
 
 struct fat_mount_options {
-	uid_t fs_uid;
-	gid_t fs_gid;
+	kuid_t fs_uid;
+	kgid_t fs_gid;
 	unsigned short fs_fmask;
 	unsigned short fs_dmask;
 	unsigned short codepage;  /* Codepage for shortname conversions */
diff --git a/fs/fat/file.c b/fs/fat/file.c
index e007b8b..a62e0ec 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -352,7 +352,7 @@ static int fat_allow_set_time(struct msdos_sb_info *sbi, struct inode *inode)
 {
 	umode_t allow_utime = sbi->options.allow_utime;
 
-	if (current_fsuid() != inode->i_uid) {
+	if (!uid_eq(current_fsuid(), inode->i_uid)) {
 		if (in_group_p(inode->i_gid))
 			allow_utime >>= 3;
 		if (allow_utime & MAY_WRITE)
@@ -407,9 +407,9 @@ int fat_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
 	if (((attr->ia_valid & ATTR_UID) &&
-	     (attr->ia_uid != sbi->options.fs_uid)) ||
+	     (!uid_eq(attr->ia_uid, sbi->options.fs_uid))) ||
 	    ((attr->ia_valid & ATTR_GID) &&
-	     (attr->ia_gid != sbi->options.fs_gid)) ||
+	     (!gid_eq(attr->ia_gid, sbi->options.fs_gid))) ||
 	    ((attr->ia_valid & ATTR_MODE) &&
 	     (attr->ia_mode & ~FAT_VALID_MODE)))
 		error = -EPERM;
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 05e897f..47d9eb0 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -791,10 +791,12 @@ static int fat_show_options(struct seq_file *m, struct dentry *root)
 	struct fat_mount_options *opts = &sbi->options;
 	int isvfat = opts->isvfat;
 
-	if (opts->fs_uid != 0)
-		seq_printf(m, ",uid=%u", opts->fs_uid);
-	if (opts->fs_gid != 0)
-		seq_printf(m, ",gid=%u", opts->fs_gid);
+	if (!uid_eq(opts->fs_uid, GLOBAL_ROOT_UID))
+		seq_printf(m, ",uid=%u",
+				from_kuid_munged(&init_user_ns, opts->fs_uid));
+	if (!gid_eq(opts->fs_gid, GLOBAL_ROOT_GID))
+		seq_printf(m, ",gid=%u",
+				from_kgid_munged(&init_user_ns, opts->fs_gid));
 	seq_printf(m, ",fmask=%04o", opts->fs_fmask);
 	seq_printf(m, ",dmask=%04o", opts->fs_dmask);
 	if (opts->allow_utime)
@@ -1037,12 +1039,16 @@ static int parse_options(struct super_block *sb, char *options, int is_vfat,
 		case Opt_uid:
 			if (match_int(&args[0], &option))
 				return 0;
-			opts->fs_uid = option;
+			opts->fs_uid = make_kuid(current_user_ns(), option);
+			if (!uid_valid(opts->fs_uid))
+				return 0;
 			break;
 		case Opt_gid:
 			if (match_int(&args[0], &option))
 				return 0;
-			opts->fs_gid = option;
+			opts->fs_gid = make_kgid(current_user_ns(), option);
+			if (!gid_valid(opts->fs_gid))
+				return 0;
 			break;
 		case Opt_umask:
 			if (match_octal(&args[0], &option))
diff --git a/init/Kconfig b/init/Kconfig
index 296d48b..60bdff2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -952,7 +952,6 @@ config UIDGID_CONVERTED
 	depends on ECRYPT_FS = n
 	depends on EFS_FS = n
 	depends on EXOFS_FS = n
-	depends on FAT_FS = n
 	depends on FUSE_FS = n
 	depends on GFS2_FS = n
 	depends on HFS_FS = n
-- 
1.7.5.4

