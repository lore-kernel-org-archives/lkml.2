Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab0IPWpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:45:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364Ab0IPWpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:45:15 -0400
From: Jan Kara <jack@suse.cz>
To: Jens@suse.cz, "Axboe <axboe"@kernel.dk
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 3/3] bdi: Fix warnings in __mark_inode_dirty for /dev/zero and friends
Date: Fri, 17 Sep 2010 00:44:11 +0200
Message-Id: <1284677051-28564-4-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1284677051-28564-1-git-send-email-jack@suse.cz>
References: <1284677051-28564-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inodes of devices such as /dev/zero can get dirty for example via utime(2)
syscall or due to atime update. Backing device of such inodes (zero_bdi, etc.)
is however unable to handle dirty inodes and thus __mark_inode_dirty complains.
In fact, inode should be rather dirtied against backing device of the
filesystem holding it. This is generally a good rule except for filesystems
such as 'bdev' or 'mtd_inodefs'. Inodes in these pseudofilesystems are
referenced from ordinary filesystem inodes and carry mapping with real data of
the device. Thus for these inodes we have to use
inode->i_mapping->backing_dev_info as we did so far. We distinguish these
filesystems by checking whether sb->s_bdi points to a non-trivial backing
device or not.

Example: Assume we have an ext3 filesystem on /dev/sda1 mounted on /. There's a
device inode A described by a path "/dev/sdb" on this filesystem. This inode
will be dirtied against backing device "8:0" after this patch. bdev filesystem
contains block device inode B coupled with our inode A. When someone modifies a
page of /dev/sdb, it's B that gets dirtied and the dirtying happens against the
backing device "8:16". Thus both inodes get filed to a correct bdi list.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 49fd41a..7dad208 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -52,8 +52,6 @@ struct wb_writeback_work {
 #define CREATE_TRACE_POINTS
 #include <trace/events/writeback.h>
 
-#define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
-
 /*
  * We don't actually have pdflush, but this one is exported though /proc...
  */
@@ -71,6 +69,27 @@ int writeback_in_progress(struct backing_dev_info *bdi)
 	return test_bit(BDI_writeback_running, &bdi->state);
 }
 
+static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct backing_dev_info *bdi = inode->i_mapping->backing_dev_info;
+
+	/*
+	 * For inodes on standard filesystems, we use superblock's bdi. For
+	 * inodes on virtual filesystems, we want to use inode mapping's bdi
+	 * because they can possibly point to something useful (think about
+	 * block_dev filesystem).
+	 */
+	if (sb->s_bdi && sb->s_bdi != &noop_backing_dev_info) {
+		/* Some device inodes could play dirty tricks. Catch them... */
+		WARN(bdi != sb->s_bdi && bdi_cap_writeback_dirty(bdi),
+			"Dirtiable inode bdi %s != sb bdi %s\n",
+			bdi->name, sb->s_bdi->name);
+		return sb->s_bdi;
+	}
+	return bdi;
+}
+
 /* Wakeup flusher thread or forker thread to fork it. Requires bdi->wb_lock. */
 static void _bdi_wakeup_flusher(struct backing_dev_info *bdi)
 {
-- 
1.6.4.2

