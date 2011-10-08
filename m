Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1JHH5Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 03:57:16 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:52266 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab1JHH5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 03:57:11 -0400
Subject: [PATCH 13/28] ext4: Create bitmap checksum helper functions
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
Date: Sat, 08 Oct 2011 00:55:09 -0700
Message-ID: <20111008075509.20506.61977.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11100807-3270-0000-0000-000000B57B7F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These helper functions will be used to calculate and verify the block and inode
bitmap checksums.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/bitmap.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)


diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
index fa3af81..43d9173 100644
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@ -29,3 +29,15 @@ unsigned int ext4_count_free(struct buffer_head *map, unsigned int numchars)
 
 #endif  /*  EXT4FS_DEBUG  */
 
+static __u32 ext4_bitmap_csum(struct super_block *sb, ext4_group_t group,
+			      struct buffer_head *bh, int sz)
+{
+	__u32 crc;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	group = cpu_to_le32(group);
+	crc = ext4_chksum(sbi, sbi->s_uuid_crc, (__u8 *)&group, sizeof(group));
+	crc = ext4_chksum(sbi, crc, (__u8 *)bh->b_data, sz);
+
+	return crc;
+}

