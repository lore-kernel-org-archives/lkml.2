Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab2KHJEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:04:08 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:42902 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab2KHJD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:03:57 -0500
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, david@fromorbit.com,
        cmm@us.ibm.com, swhiteho@redhat.com, dave@jikos.cz,
        darrick.wong@oracle.com, andi@firstfloor.org, northrup.james@gmail.com,
        gregkh@linuxfoundation.org, linuxram@linux.vnet.ibm.com,
        Zheng Liu <wenqing.lz@taobao.com>, Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: [PATCH v1 hot_track 17/18] ext4: add hot tracking support
Date: Thu,  8 Nov 2012 17:01:24 +0800
Message-Id: <1352365285-32419-18-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1352365285-32419-1-git-send-email-zwu.kernel@gmail.com>
References: <1352365285-32419-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110809-2398-0000-0000-00000D769103
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000295; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00189475; UDB=6.00042904; UTC=2012-11-08
 09:03:56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zheng Liu <wenqing.lz@taobao.com>

  Define a new mount option to add VFS hot
tracking support in order to use it in ext4.

CC: Zhi Yong Wu <zwu.kernel@gmail.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/ext4.h  |    3 +++
 fs/ext4/super.c |   13 ++++++++++++-
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3c20de1..f6cff1e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1298,6 +1298,9 @@ struct ext4_sb_info {
 
 	/* Precomputed FS UUID checksum for seeding other checksums */
 	__u32 s_csum_seed;
+
+	/* Enable hot tracking or not */
+	int s_hottrack_enable;
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 80928f7..ba9f376 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -864,6 +864,8 @@ static void ext4_put_super(struct super_block *sb)
 	ext4_ext_release(sb);
 	ext4_xattr_put_super(sb);
 
+	if (sbi->s_hottrack_enable)
+		hot_track_exit(sb);
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
@@ -1222,7 +1224,7 @@ enum {
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
 	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
-	Opt_max_dir_size_kb,
+	Opt_max_dir_size_kb, Opt_hottrack,
 };
 
 static const match_table_t tokens = {
@@ -1297,6 +1299,7 @@ static const match_table_t tokens = {
 	{Opt_init_itable, "init_itable"},
 	{Opt_noinit_itable, "noinit_itable"},
 	{Opt_max_dir_size_kb, "max_dir_size_kb=%u"},
+	{Opt_hottrack, "hot_track"},
 	{Opt_removed, "check=none"},	/* mount option from ext2/3 */
 	{Opt_removed, "nocheck"},	/* mount option from ext2/3 */
 	{Opt_removed, "reservation"},	/* mount option from ext2/3 */
@@ -1595,6 +1598,14 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 			sbi->s_li_wait_mult = arg;
 		} else if (token == Opt_max_dir_size_kb) {
 			sbi->s_max_dir_size_kb = arg;
+		} else if (token == Opt_hottrack) {
+			if (hot_track_init(sb)) {
+				ext4_msg(sb, KERN_ERR,
+					"EXT4-fs: hot tracking initialization"
+					" failed");
+				return -1;
+			}
+			sbi->s_hottrack_enable = 1;
 		} else if (token == Opt_stripe) {
 			sbi->s_stripe = arg;
 		} else if (m->flags & MOPT_DATAJ) {
-- 
1.7.6.5

