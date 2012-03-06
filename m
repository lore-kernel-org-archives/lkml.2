Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031246Ab2CFUuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 15:50:10 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50334 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031245Ab2CFUuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 15:50:06 -0500
Subject: [PATCH 03/23] ext4: Record the checksum algorithm in use in the
 superblock
To: Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Tso <tytso@mit.edu>,
        "Darrick J. Wong" <djwong@us.ibm.com>
From: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
        Martin K Petersen <martin.petersen@oracle.com>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
        Joel Becker <jlbec@evilplan.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
Date: Tue, 06 Mar 2012 12:48:14 -0800
Message-ID: <20120306204814.1663.69483.stgit@elm3b70.beaverton.ibm.com>
In-Reply-To: <20120306204750.1663.96751.stgit@elm3b70.beaverton.ibm.com>
References: <20120306204750.1663.96751.stgit@elm3b70.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030620-9360-0000-0000-0000044A1D7F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Record the type of checksum algorithm we're using for metadata in the
superblock, in case we ever want/need to change the algorithm.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/super.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)


diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 502c61f..38de050 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -111,6 +111,16 @@ static struct file_system_type ext3_fs_type = {
 #define IS_EXT3_SB(sb) (0)
 #endif
 
+static int ext4_verify_csum_type(struct super_block *sb,
+				 struct ext4_super_block *es)
+{
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+
+	return es->s_checksum_type == EXT4_CRC32C_CHKSUM;
+}
+
 void *ext4_kvmalloc(size_t size, gfp_t flags)
 {
 	void *ret;
@@ -3178,6 +3188,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto cantfind_ext4;
 	sbi->s_kbytes_written = le64_to_cpu(es->s_kbytes_written);
 
+	/* Check for a known checksum algorithm */
+	if (!ext4_verify_csum_type(sb, es)) {
+		ext4_msg(sb, KERN_ERR, "VFS: Found ext4 filesystem with "
+			 "unknown checksum algorithm.");
+		silent = 1;
+		goto cantfind_ext4;
+	}
+
 	/* Set defaults before we parse the mount options */
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
 	set_opt(sb, INIT_INODE_TABLE);

