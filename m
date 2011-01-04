Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab1ADI5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:57:30 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53017 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1ADI52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:57:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=U6UOpPuEYGVr6sDrWVtebf6DMBVDqiBVs23P0/h4jG1KcWhPasizgl02OfCvJNkWNg
         yStXWoTWX0Q16QlczIHW8duvqrmMFKDwSzyfjLl4MfDK1Ao7waSrTUEacGXMMKtlxcg1
         RHfN3WJ1WUrzzQtS1fHvPEt70BatToB4rW7qU=
From: yangsheng <sickamd@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: adilger@dilger.ca, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, swhiteho@redhat.com,
        yangsheng <sickamd@gmail.com>, sickadm@gmail.com
Subject: [PATCH resend] Update atime from future.
Date: Tue,  4 Jan 2011 16:56:58 +0800
Message-Id: <1294131418-3835-1-git-send-email-sickamd@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If atime has been wrong set to future, then it cannot
be updated back to current time.

CC: swhiteho@redhat.com
Signed-off-by: sickadm@gmail.com
Reviewed-by: adilger@dilger.ca
---
 fs/inode.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index da85e56..9cf7375 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1446,6 +1446,8 @@ sector_t bmap(struct inode *inode, sector_t block)
 }
 EXPORT_SYMBOL(bmap);
 
+#define RELATIME_MARGIN (24 * 60 * 60)
+
 /*
  * With relative atime, only update atime if the previous atime is
  * earlier than either the ctime or mtime or if at least a day has
@@ -1469,10 +1471,16 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
 		return 1;
 
 	/*
-	 * Is the previous atime value older than a day? If yes,
+	 * Is the previous atime value in future? If yes,
+	 * update atime:
+	 */
+	if ((long)(now.tv_sec - inode->i_atime.tv_sec) < -RELATIME_MARGIN)
+		return 1;
+	/*
+	 * Is the previous atime value old than a day? If yes,
 	 * update atime:
 	 */
-	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= 24*60*60)
+	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= RELATIME_MARGIN)
 		return 1;
 	/*
 	 * Good, we can skip the atime update:
-- 
1.7.2.3

