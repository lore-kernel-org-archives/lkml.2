Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab1HTAHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 20:07:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:37683 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448Ab1HTAHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 20:07:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,253,1312182000"; 
   d="scan'208";a="40435939"
From: Andi Kleen <andi@firstfloor.org>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        josef@redhat.com, chris.mason@oracle.com
Subject: [PATCH] BTRFS: Free inode mutex on lseek error
Date: Fri, 19 Aug 2011 17:07:38 -0700
Message-Id: <1313798858-10938-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Introduced with b26751575a9aa55fd6dbf3febde3ff06dfadc44f

Cc: josef@redhat.com
Cc: chris.mason@oracle.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/btrfs/file.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 658d669..8791613 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1798,16 +1798,15 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
 	case SEEK_DATA:
 	case SEEK_HOLE:
 		ret = find_desired_extent(inode, &offset, origin);
-		if (ret) {
-			mutex_unlock(&inode->i_mutex);
-			return ret;
-		}
+		if (ret)
+			goto error;
 	}
 
+	ret = -EINVAL;
 	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET))
-		return -EINVAL;
+		goto error;
 	if (offset > inode->i_sb->s_maxbytes)
-		return -EINVAL;
+		goto error;
 
 	/* Special lock needed here? */
 	if (offset != file->f_pos) {
@@ -1817,6 +1816,9 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
 out:
 	mutex_unlock(&inode->i_mutex);
 	return offset;
+error:
+	mutex_unlock(&inode->i_mutex);
+	return ret;
 }
 
 const struct file_operations btrfs_file_operations = {
-- 
1.7.4.4

