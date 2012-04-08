Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab2DHFN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:13:28 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51563 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab2DHFMb (ORCPT
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
Date: Sat,  7 Apr 2012 22:15:32 -0700
Message-Id: <1333862139-31737-36-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+WowpjAD+Vgedk5+014K2lHqFatMgAI4E=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 
X-Spam-Combo: ****;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 36/43] userns: Convert ext3 to use kuid/kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/ext3/balloc.c            |    5 +++--
 fs/ext3/ext3.h              |    8 ++++----
 fs/ext3/inode.c             |   32 ++++++++++++++++++++------------
 fs/ext3/super.c             |   35 +++++++++++++++++++++++++----------
 include/trace/events/ext3.h |    4 ++--
 5 files changed, 54 insertions(+), 30 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index baac1b1..25cd608 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1439,8 +1439,9 @@ static int ext3_has_free_blocks(struct ext3_sb_info *sbi, int use_reservation)
 	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
 	root_blocks = le32_to_cpu(sbi->s_es->s_r_blocks_count);
 	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
-		!use_reservation && sbi->s_resuid != current_fsuid() &&
-		(sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
+		!use_reservation && !uid_eq(sbi->s_resuid, current_fsuid()) &&
+		(gid_eq(sbi->s_resgid, GLOBAL_ROOT_GID) ||
+		 !in_group_p (sbi->s_resgid))) {
 		return 0;
 	}
 	return 1;
diff --git a/fs/ext3/ext3.h b/fs/ext3/ext3.h
index b6515fd..7977973 100644
--- a/fs/ext3/ext3.h
+++ b/fs/ext3/ext3.h
@@ -243,8 +243,8 @@ struct ext3_new_group_data {
  */
 struct ext3_mount_options {
 	unsigned long s_mount_opt;
-	uid_t s_resuid;
-	gid_t s_resgid;
+	kuid_t s_resuid;
+	kgid_t s_resgid;
 	unsigned long s_commit_interval;
 #ifdef CONFIG_QUOTA
 	int s_jquota_fmt;
@@ -637,8 +637,8 @@ struct ext3_sb_info {
 	struct buffer_head ** s_group_desc;
 	unsigned long  s_mount_opt;
 	ext3_fsblk_t s_sb_block;
-	uid_t s_resuid;
-	gid_t s_resgid;
+	kuid_t s_resuid;
+	kgid_t s_resgid;
 	unsigned short s_mount_state;
 	unsigned short s_pad;
 	int s_addr_per_block_bits;
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 10d7812..a09790a 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2891,6 +2891,8 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 	transaction_t *transaction;
 	long ret;
 	int block;
+	uid_t i_uid;
+	gid_t i_gid;
 
 	inode = iget_locked(sb, ino);
 	if (!inode)
@@ -2907,12 +2909,14 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 	bh = iloc.bh;
 	raw_inode = ext3_raw_inode(&iloc);
 	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
-	inode->i_uid = (uid_t)le16_to_cpu(raw_inode->i_uid_low);
-	inode->i_gid = (gid_t)le16_to_cpu(raw_inode->i_gid_low);
+	i_uid = (uid_t)le16_to_cpu(raw_inode->i_uid_low);
+	i_gid = (gid_t)le16_to_cpu(raw_inode->i_gid_low);
 	if(!(test_opt (inode->i_sb, NO_UID32))) {
-		inode->i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
-		inode->i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
+		i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
+		i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
 	}
+	i_uid_write(inode, i_uid);
+	i_gid_write(inode, i_gid);
 	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
 	inode->i_size = le32_to_cpu(raw_inode->i_size);
 	inode->i_atime.tv_sec = (signed)le32_to_cpu(raw_inode->i_atime);
@@ -3068,6 +3072,8 @@ static int ext3_do_update_inode(handle_t *handle,
 	struct ext3_inode_info *ei = EXT3_I(inode);
 	struct buffer_head *bh = iloc->bh;
 	int err = 0, rc, block;
+	uid_t i_uid;
+	gid_t i_gid;
 
 again:
 	/* we can't allow multiple procs in here at once, its a bit racey */
@@ -3080,27 +3086,29 @@ again:
 
 	ext3_get_inode_flags(ei);
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
+	i_uid = i_uid_read(inode);
+	i_gid = i_gid_read(inode);
 	if(!(test_opt(inode->i_sb, NO_UID32))) {
-		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(inode->i_uid));
-		raw_inode->i_gid_low = cpu_to_le16(low_16_bits(inode->i_gid));
+		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(i_uid));
+		raw_inode->i_gid_low = cpu_to_le16(low_16_bits(i_gid));
 /*
  * Fix up interoperability with old kernels. Otherwise, old inodes get
  * re-used with the upper 16 bits of the uid/gid intact
  */
 		if(!ei->i_dtime) {
 			raw_inode->i_uid_high =
-				cpu_to_le16(high_16_bits(inode->i_uid));
+				cpu_to_le16(high_16_bits(i_uid));
 			raw_inode->i_gid_high =
-				cpu_to_le16(high_16_bits(inode->i_gid));
+				cpu_to_le16(high_16_bits(i_gid));
 		} else {
 			raw_inode->i_uid_high = 0;
 			raw_inode->i_gid_high = 0;
 		}
 	} else {
 		raw_inode->i_uid_low =
-			cpu_to_le16(fs_high2lowuid(inode->i_uid));
+			cpu_to_le16(fs_high2lowuid(i_uid));
 		raw_inode->i_gid_low =
-			cpu_to_le16(fs_high2lowgid(inode->i_gid));
+			cpu_to_le16(fs_high2lowgid(i_gid));
 		raw_inode->i_uid_high = 0;
 		raw_inode->i_gid_high = 0;
 	}
@@ -3262,8 +3270,8 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if (is_quota_modification(inode, attr))
 		dquot_initialize(inode);
-	if ((ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
-		(ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid)) {
+	if ((ia_valid & ATTR_UID && !uid_eq(attr->ia_uid, inode->i_uid)) ||
+	    (ia_valid & ATTR_GID && !gid_eq(attr->ia_gid, inode->i_gid))) {
 		handle_t *handle;
 
 		/* (user+group)*(old+new) structure, inode write (sb,
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index cf0b592..94ef7e6 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -617,13 +617,15 @@ static int ext3_show_options(struct seq_file *seq, struct dentry *root)
 		seq_puts(seq, ",grpid");
 	if (!test_opt(sb, GRPID) && (def_mount_opts & EXT3_DEFM_BSDGROUPS))
 		seq_puts(seq, ",nogrpid");
-	if (sbi->s_resuid != EXT3_DEF_RESUID ||
+	if (!uid_eq(sbi->s_resuid, make_kuid(&init_user_ns, EXT3_DEF_RESUID)) ||
 	    le16_to_cpu(es->s_def_resuid) != EXT3_DEF_RESUID) {
-		seq_printf(seq, ",resuid=%u", sbi->s_resuid);
+		seq_printf(seq, ",resuid=%u",
+				from_kuid_munged(&init_user_ns, sbi->s_resuid));
 	}
-	if (sbi->s_resgid != EXT3_DEF_RESGID ||
+	if (!gid_eq(sbi->s_resgid, make_kgid(&init_user_ns, EXT3_DEF_RESGID)) ||
 	    le16_to_cpu(es->s_def_resgid) != EXT3_DEF_RESGID) {
-		seq_printf(seq, ",resgid=%u", sbi->s_resgid);
+		seq_printf(seq, ",resgid=%u",
+				from_kgid_munged(&init_user_ns, sbi->s_resgid));
 	}
 	if (test_opt(sb, ERRORS_RO)) {
 		int def_errors = le16_to_cpu(es->s_errors);
@@ -967,6 +969,8 @@ static int parse_options (char *options, struct super_block *sb,
 	substring_t args[MAX_OPT_ARGS];
 	int data_opt = 0;
 	int option;
+	kuid_t uid;
+	kgid_t gid;
 #ifdef CONFIG_QUOTA
 	int qfmt;
 #endif
@@ -1000,12 +1004,23 @@ static int parse_options (char *options, struct super_block *sb,
 		case Opt_resuid:
 			if (match_int(&args[0], &option))
 				return 0;
-			sbi->s_resuid = option;
+			uid = make_kuid(current_user_ns(), option);
+			if (!uid_valid(uid)) {
+				ext3_msg(sb, KERN_ERR, "Invalid uid value %d", option);
+				return -1;
+
+			}
+			sbi->s_resuid = uid;
 			break;
 		case Opt_resgid:
 			if (match_int(&args[0], &option))
 				return 0;
-			sbi->s_resgid = option;
+			gid = make_kgid(current_user_ns(), option);
+			if (!gid_valid(gid)) {
+				ext3_msg(sb, KERN_ERR, "Invalid gid value %d", option);
+				return -1;
+			}
+			sbi->s_resgid = gid;
 			break;
 		case Opt_sb:
 			/* handled by get_sb_block() instead of here */
@@ -1651,8 +1666,8 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	}
 	sb->s_fs_info = sbi;
 	sbi->s_mount_opt = 0;
-	sbi->s_resuid = EXT3_DEF_RESUID;
-	sbi->s_resgid = EXT3_DEF_RESGID;
+	sbi->s_resuid = make_kuid(&init_user_ns, EXT3_DEF_RESUID);
+	sbi->s_resgid = make_kgid(&init_user_ns, EXT3_DEF_RESGID);
 	sbi->s_sb_block = sb_block;
 
 	blocksize = sb_min_blocksize(sb, EXT3_MIN_BLOCK_SIZE);
@@ -1716,8 +1731,8 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	else
 		set_opt(sbi->s_mount_opt, ERRORS_RO);
 
-	sbi->s_resuid = le16_to_cpu(es->s_def_resuid);
-	sbi->s_resgid = le16_to_cpu(es->s_def_resgid);
+	sbi->s_resuid = make_kuid(&init_user_ns, le16_to_cpu(es->s_def_resuid));
+	sbi->s_resgid = make_kgid(&init_user_ns, le16_to_cpu(es->s_def_resgid));
 
 	/* enable barriers by default */
 	set_opt(sbi->s_mount_opt, BARRIER);
diff --git a/include/trace/events/ext3.h b/include/trace/events/ext3.h
index 7b53c05..15d11a3 100644
--- a/include/trace/events/ext3.h
+++ b/include/trace/events/ext3.h
@@ -24,8 +24,8 @@ TRACE_EVENT(ext3_free_inode,
 		__entry->dev	= inode->i_sb->s_dev;
 		__entry->ino	= inode->i_ino;
 		__entry->mode	= inode->i_mode;
-		__entry->uid	= inode->i_uid;
-		__entry->gid	= inode->i_gid;
+		__entry->uid	= i_uid_read(inode);
+		__entry->gid	= i_gid_read(inode);
 		__entry->blocks	= inode->i_blocks;
 	),
 
-- 
1.7.2.5

