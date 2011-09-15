Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935369Ab1IOXIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:08:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:26360 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935302Ab1IOXHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:07:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48921897"
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 7/7] LSEEK: BTRFS: Avoid i_mutex for SEEK_{CUR,SET,END}
Date: Thu, 15 Sep 2011 16:06:53 -0700
Message-Id: <1316128013-21980-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
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
index 62f56d4..ae7f37e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1809,18 +1809,13 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
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
@@ -1836,7 +1831,6 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
 		file->f_pos = offset;
 		file->f_version = 0;
 	}
-out:
 	mutex_unlock(&inode->i_mutex);
 	return offset;
 error:
-- 
1.7.4.4

