Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab1HVUtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:49:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:47558 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736Ab1HVUtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:49:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="40723410"
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 7/7] LSEEK: BTRFS: Avoid i_mutex for SEEK_{CUR,SET,END}
Date: Mon, 22 Aug 2011 13:49:12 -0700
Message-Id: <1314046152-2175-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1314046152-2175-1-git-send-email-andi@firstfloor.org>
References: <1314046152-2175-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Don't need the i_mutex for those cases, only for SEEK_HOLE/DATA.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/btrfs/file.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 6107b94..35f5f13 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1805,18 +1805,13 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
 	struct inode *inode = file->f_mapping->host;
 	int ret;
 
+	if (origin != SEEK_DATA && origin != SEEK_HOLE)
+		return generic_file_llseek(file, offset, origin);
+
 	mutex_lock(&inode->i_mutex);
-	switch (origin) {
-	case SEEK_END:
-	case SEEK_CUR:
-		offset = generic_file_llseek(file, offset, origin);
-		goto out;
-	case SEEK_DATA:
-	case SEEK_HOLE:
-		ret = find_desired_extent(inode, &offset, origin);
-		if (ret)
-			goto error;
-	}
+	ret = find_desired_extent(inode, &offset, origin);
+	if (ret)
+		goto error;
 
 	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
 		ret = -EINVAL;
@@ -1832,7 +1827,6 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
 		file->f_pos = offset;
 		file->f_version = 0;
 	}
-out:
 	mutex_unlock(&inode->i_mutex);
 	return offset;
 error:
-- 
1.7.4.4

