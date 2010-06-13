Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab0FMVLV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 17:11:21 -0400
Received: from r11na27.net.upc.cz ([94.113.108.27]:49721 "EHLO
	bimbo.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754380Ab0FMVLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 17:11:20 -0400
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jun 2010 17:11:20 EDT
From: Lubomir Rintel <lkundrak@v3.sk>
To: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Cc: Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] [fs/sysv] Fix NULL deref. when allocating new inode
Date: Sun, 13 Jun 2010 21:01:43 +0200
Message-Id: <1276455703-5981-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A call to sysv_write_inode() in sysv_new_inode() to its new interface
that replaced wait flag with writeback structure. This was broken by
a9185b41a4f84971b930c519f0c63bd450c4810d.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 fs/sysv/ialloc.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/sysv/ialloc.c b/fs/sysv/ialloc.c
index 241e976..f2764e2 100644
--- a/fs/sysv/ialloc.c
+++ b/fs/sysv/ialloc.c
@@ -25,6 +25,7 @@
 #include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/buffer_head.h>
+#include <linux/writeback.h>
 #include "sysv.h"
 
 /* We don't trust the value of
@@ -139,6 +140,9 @@ struct inode * sysv_new_inode(const struct inode * dir, mode_t mode)
 	struct inode *inode;
 	sysv_ino_t ino;
 	unsigned count;
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_NONE
+	};
 
 	inode = new_inode(sb);
 	if (!inode)
@@ -177,7 +181,7 @@ struct inode * sysv_new_inode(const struct inode * dir, mode_t mode)
 	mark_inode_dirty(inode);
 
 	inode->i_mode = mode;		/* for sysv_write_inode() */
-	sysv_write_inode(inode, 0);	/* ensure inode not allocated again */
+	sysv_write_inode(inode, &wbc);	/* ensure inode not allocated again */
 	mark_inode_dirty(inode);	/* cleared by sysv_write_inode() */
 	/* That's it. */
 	unlock_super(sb);
-- 
1.7.1

