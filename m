Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab1FESW6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 14:22:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33833 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab1FESW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 14:22:57 -0400
Date: Sun, 5 Jun 2011 19:22:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: shaggy@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] lmLogOpen() broken failure exit
Message-ID: <20110605182256.GG11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Callers of lmLogOpen() expect it to return -E... on failure exits, which
is what it returns, except for the case of blkdev_get_by_dev() failure.
It that case lmLogOpen() return the error with the wrong sign...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 278e3fb..583636f 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1123,7 +1123,7 @@ int lmLogOpen(struct super_block *sb)
 	bdev = blkdev_get_by_dev(sbi->logdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL,
 				 log);
 	if (IS_ERR(bdev)) {
-		rc = -PTR_ERR(bdev);
+		rc = PTR_ERR(bdev);
 		goto free;
 	}
 
