Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228Ab2IVBh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 21:37:56 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56136 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab2IVBfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 21:35:46 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Dave Kleikamp <shaggy@kernel.org>
Date: Fri, 21 Sep 2012 18:35:07 -0700
Message-Id: <1348277712-30055-6-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348277712-30055-1-git-send-email-ebiederm@xmission.com>
References: <877grmj115.fsf@xmission.com>
 <1348277712-30055-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX182RV71wIvtuvxcKyjxuLxfuNdGeL0eRgU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1842]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 06/11] userns: Convert jfs to use kuid/kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Dave Kleikamp <shaggy@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/jfs/file.c       |    4 ++--
 fs/jfs/jfs_imap.c   |   22 ++++++++++++----------
 fs/jfs/jfs_incore.h |    8 ++++----
 fs/jfs/super.c      |   22 +++++++++++++++-------
 init/Kconfig        |    1 -
 5 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/fs/jfs/file.c b/fs/jfs/file.c
index 844f946..9d3afd1 100644
--- a/fs/jfs/file.c
+++ b/fs/jfs/file.c
@@ -108,8 +108,8 @@ int jfs_setattr(struct dentry *dentry, struct iattr *iattr)
 
 	if (is_quota_modification(inode, iattr))
 		dquot_initialize(inode);
-	if ((iattr->ia_valid & ATTR_UID && iattr->ia_uid != inode->i_uid) ||
-	    (iattr->ia_valid & ATTR_GID && iattr->ia_gid != inode->i_gid)) {
+	if ((iattr->ia_valid & ATTR_UID && !uid_eq(iattr->ia_uid, inode->i_uid)) ||
+	    (iattr->ia_valid & ATTR_GID && !gid_eq(iattr->ia_gid, inode->i_gid))) {
 		rc = dquot_transfer(inode, iattr);
 		if (rc)
 			return rc;
diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index 1b6f15f..6ba4006 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -3078,15 +3078,15 @@ static int copy_from_dinode(struct dinode * dip, struct inode *ip)
 	}
 	set_nlink(ip, le32_to_cpu(dip->di_nlink));
 
-	jfs_ip->saved_uid = le32_to_cpu(dip->di_uid);
-	if (sbi->uid == -1)
+	jfs_ip->saved_uid = make_kuid(&init_user_ns, le32_to_cpu(dip->di_uid));
+	if (!uid_valid(sbi->uid))
 		ip->i_uid = jfs_ip->saved_uid;
 	else {
 		ip->i_uid = sbi->uid;
 	}
 
-	jfs_ip->saved_gid = le32_to_cpu(dip->di_gid);
-	if (sbi->gid == -1)
+	jfs_ip->saved_gid = make_kgid(&init_user_ns, le32_to_cpu(dip->di_gid));
+	if (!gid_valid(sbi->gid))
 		ip->i_gid = jfs_ip->saved_gid;
 	else {
 		ip->i_gid = sbi->gid;
@@ -3150,14 +3150,16 @@ static void copy_to_dinode(struct dinode * dip, struct inode *ip)
 	dip->di_size = cpu_to_le64(ip->i_size);
 	dip->di_nblocks = cpu_to_le64(PBLK2LBLK(ip->i_sb, ip->i_blocks));
 	dip->di_nlink = cpu_to_le32(ip->i_nlink);
-	if (sbi->uid == -1)
-		dip->di_uid = cpu_to_le32(ip->i_uid);
+	if (!uid_valid(sbi->uid))
+		dip->di_uid = cpu_to_le32(i_uid_read(ip));
 	else
-		dip->di_uid = cpu_to_le32(jfs_ip->saved_uid);
-	if (sbi->gid == -1)
-		dip->di_gid = cpu_to_le32(ip->i_gid);
+		dip->di_uid =cpu_to_le32(from_kuid(&init_user_ns,
+						   jfs_ip->saved_uid));
+	if (!gid_valid(sbi->gid))
+		dip->di_gid = cpu_to_le32(i_gid_read(ip));
 	else
-		dip->di_gid = cpu_to_le32(jfs_ip->saved_gid);
+		dip->di_gid = cpu_to_le32(from_kgid(&init_user_ns,
+						    jfs_ip->saved_gid));
 	jfs_get_inode_flags(jfs_ip);
 	/*
 	 * mode2 is only needed for storing the higher order bits.
diff --git a/fs/jfs/jfs_incore.h b/fs/jfs/jfs_incore.h
index 584a4a1..680605d 100644
--- a/fs/jfs/jfs_incore.h
+++ b/fs/jfs/jfs_incore.h
@@ -38,8 +38,8 @@
 struct jfs_inode_info {
 	int	fileset;	/* fileset number (always 16)*/
 	uint	mode2;		/* jfs-specific mode		*/
-	uint	saved_uid;	/* saved for uid mount option */
-	uint	saved_gid;	/* saved for gid mount option */
+	kuid_t	saved_uid;	/* saved for uid mount option */
+	kgid_t	saved_gid;	/* saved for gid mount option */
 	pxd_t	ixpxd;		/* inode extent descriptor	*/
 	dxd_t	acl;		/* dxd describing acl	*/
 	dxd_t	ea;		/* dxd describing ea	*/
@@ -192,8 +192,8 @@ struct jfs_sb_info {
 	uint		state;		/* mount/recovery state	*/
 	unsigned long	flag;		/* mount time flags */
 	uint		p_state;	/* state prior to going no integrity */
-	uint		uid;		/* uid to override on-disk uid */
-	uint		gid;		/* gid to override on-disk gid */
+	kuid_t		uid;		/* uid to override on-disk uid */
+	kgid_t		gid;		/* gid to override on-disk gid */
 	uint		umask;		/* umask to override on-disk umask */
 };
 
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index c55c745..706692f 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -321,13 +321,19 @@ static int parse_options(char *options, struct super_block *sb, s64 *newLVSize,
 		case Opt_uid:
 		{
 			char *uid = args[0].from;
-			sbi->uid = simple_strtoul(uid, &uid, 0);
+			uid_t val = simple_strtoul(uid, &uid, 0);
+			sbi->uid = make_kuid(current_user_ns(), val);
+			if (!uid_valid(sbi->uid))
+				goto cleanup;
 			break;
 		}
 		case Opt_gid:
 		{
 			char *gid = args[0].from;
-			sbi->gid = simple_strtoul(gid, &gid, 0);
+			gid_t val = simple_strtoul(gid, &gid, 0);
+			sbi->gid = make_kgid(current_user_ns(), val);
+			if (!gid_valid(sbi->gid))
+				goto cleanup;
 			break;
 		}
 		case Opt_umask:
@@ -443,7 +449,9 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_fs_info = sbi;
 	sb->s_max_links = JFS_LINK_MAX;
 	sbi->sb = sb;
-	sbi->uid = sbi->gid = sbi->umask = -1;
+	sbi->uid = INVALID_UID;
+	sbi->gid = INVALID_GID;
+	sbi->umask = -1;
 
 	/* initialize the mount flag and determine the default error handler */
 	flag = JFS_ERR_REMOUNT_RO;
@@ -617,10 +625,10 @@ static int jfs_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(root->d_sb);
 
-	if (sbi->uid != -1)
-		seq_printf(seq, ",uid=%d", sbi->uid);
-	if (sbi->gid != -1)
-		seq_printf(seq, ",gid=%d", sbi->gid);
+	if (uid_valid(sbi->uid))
+		seq_printf(seq, ",uid=%d", from_kuid(&init_user_ns, sbi->uid));
+	if (gid_valid(sbi->gid))
+		seq_printf(seq, ",gid=%d", from_kgid(&init_user_ns, sbi->gid));
 	if (sbi->umask != -1)
 		seq_printf(seq, ",umask=%03o", sbi->umask);
 	if (sbi->flag & JFS_NOINTEGRITY)
diff --git a/init/Kconfig b/init/Kconfig
index cf2d50b..20d4a1b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -935,7 +935,6 @@ config UIDGID_CONVERTED
 	depends on CODA_FS = n
 	depends on FUSE_FS = n
 	depends on GFS2_FS = n
-	depends on JFS_FS = n
 	depends on NCP_FS = n
 	depends on NFSD = n
 	depends on NFS_FS = n
-- 
1.7.5.4

