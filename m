Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab2LCR5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:57:13 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42278 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab2LCR5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:57:10 -0500
From: yangsheng <sickamd@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: stable@vger.kernel.org, adilger@dilger.ca, yangsheng <sickamd@gmail.com>
Subject: [PATCH] Update atime from future.
Date: Tue,  4 Dec 2012 01:56:39 +0800
Message-Id: <1354557399-6202-1-git-send-email-sickamd@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relatime should update the inode atime if it is more than a day in the
future.  The original problem seen was a tarball that had a bad atime,
but could also happen if someone fat-fingers a "touch".  The future
atime will never be fixed.  Before the relatime patch, the future atime
would be updated back to the current time on the next access.

Only update the atime if it is more than one day in the future.  That
avoids thrashing the atime if the clocks on clients of a network fs are
only slightly out of sync, but still allows fixing bogus atimes.

Signed-off-by: yangsheng <sickamd@gmail.com>
Reviewed-by: adilger@dilger.ca
---
 fs/inode.c | 10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 14084b7..5c4379a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1465,6 +1465,7 @@ sector_t bmap(struct inode *inode, sector_t block)
 }
 EXPORT_SYMBOL(bmap);
 
+#define RELATIME_MARGIN (24*60*60)
 /*
  * With relative atime, only update atime if the previous atime is
  * earlier than either the ctime or mtime or if at least a day has
@@ -1488,10 +1489,17 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
 		return 1;
 
 	/*
+	 * Is the previous atime value in future? If yes,
+	 * update atime:
+	 */
+	if ((long)(now.tv_sec - inode->i_atime.tv_sec) < -RELATIME_MARGIN)
+		return 1;
+
+	/*
 	 * Is the previous atime value older than a day? If yes,
 	 * update atime:
 	 */
-	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= 24*60*60)
+	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= RELATIME_MARGIN)
 		return 1;
 	/*
 	 * Good, we can skip the atime update:
-- 
1.7.11.7

