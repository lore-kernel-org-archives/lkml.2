Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935319Ab1IOXHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:07:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:26360 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935256Ab1IOXHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:07:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="48948728"
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/7] BTRFS: Fix lseek return value for error
Date: Thu, 15 Sep 2011 16:06:47 -0700
Message-Id: <1316128013-21980-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Introduced by 9a4327ca1f45f82edad7dc0a4e52ce9316e0950c

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/btrfs/file.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 3c3abff..7ec0a24 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1818,19 +1818,17 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
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
 
 	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
 		ret = -EINVAL;
-		goto out;
+		goto error;
 	}
 	if (offset > inode->i_sb->s_maxbytes) {
 		ret = -EINVAL;
-		goto out;
+		goto error;
 	}
 
 	/* Special lock needed here? */
@@ -1841,6 +1839,9 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
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

