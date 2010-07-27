Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab0G0RGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:06:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab0G0RGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:06:18 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/3] bdi: Use parent filesystem BDI for inodes not capable of writeback
Date: Tue, 27 Jul 2010 19:04:59 +0200
Message-Id: <1280250301-17603-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1280250301-17603-1-git-send-email-jack@suse.cz>
References: <1280250301-17603-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If inode->i_mapping->backing_dev_info is not capable of writeback
but the inode gets dirty (because inode itself has changed), use
inode lists of a bdi of a filesystem holding the device inode.
Forking the flusher thread just to do the writeout of a single
inode would be silly and generally bdi needn't be prepared to do
any writeback.

This is part of fixing a bug
https://bugzilla.kernel.org/show_bug.cgi?id=16312.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index d5be169..00865aa 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -28,8 +28,6 @@
 #include <linux/buffer_head.h>
 #include "internal.h"
 
-#define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
-
 /*
  * We don't actually have pdflush, but this one is exported though /proc...
  */
@@ -50,6 +48,21 @@ struct wb_writeback_work {
 	struct completion *done;	/* set if the caller waits */
 };
 
+static struct backing_dev_info *inode_to_bdi(struct inode *inode)
+{
+	struct backing_dev_info *bdi = inode->i_mapping->backing_dev_info;
+
+	/*
+	 * This is a hack but it solves a problem with device inode
+	 * for e.g. /dev/zero getting dirty (via touch or so) and confusing
+	 * writeback code. In such cases we return the "parent" filesystem's
+	 * bdi.
+	 */
+	if (bdi_cap_writeback_dirty(bdi))
+		return bdi;
+	return inode->i_sb->s_bdi;
+}
+
 /**
  * writeback_in_progress - determine whether there is writeback in progress
  * @bdi: the device's backing_dev_info structure.
-- 
1.6.4.2

