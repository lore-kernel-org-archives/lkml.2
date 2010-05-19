Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab0ESSmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:42:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63899 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab0ESSmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 14:42:14 -0400
From: Will Drewry <wad@chromium.org>
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: agk@redhat.com, snitzer@redhat.com, Will Drewry <wad@chromium.org>
Subject: [PATCH v3 3/3] dm: lookup devices by path with name_to_dev_t
Date: Wed, 19 May 2010 13:38:24 -0500
Message-Id: <1274294304-30606-3-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274294304-30606-1-git-send-email-wad@chromium.org>
References: <1274294304-30606-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace major:minor parsing with name_to_dev_t.  This
maintains the current functionality (as the code was the same),
but adds support for the hexadecimal dev as well as device lookup
before the root filesystem is available.  The latter is the motivation
for this change.

It still falls back to lookup_bdev() for cases where the inode
on disk provides more information than the name (and the path exceeds
the length handled by name_to_dev_t).

Signed-off-by: Will Drewry <wad@chromium.org>
---
 drivers/md/dm-table.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index ef6a3ab..589e86a 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -11,6 +11,7 @@
 #include <linux/vmalloc.h>
 #include <linux/blkdev.h>
 #include <linux/namei.h>
+#include <linux/mount.h>
 #include <linux/ctype.h>
 #include <linux/string.h>
 #include <linux/slab.h>
@@ -434,17 +435,16 @@ static int __table_get_device(struct dm_table *t, struct dm_target *ti,
 	int r;
 	dev_t uninitialized_var(dev);
 	struct dm_dev_internal *dd;
-	unsigned int major, minor;
+	char base_path[32];  /* size from name_to_dev_t */
 
 	BUG_ON(!t);
 
-	if (sscanf(path, "%u:%u", &major, &minor) == 2) {
-		/* Extract the major/minor numbers */
-		dev = MKDEV(major, minor);
-		if (MAJOR(dev) != major || MINOR(dev) != minor)
-			return -EOVERFLOW;
-	} else {
-		/* convert the path to a device */
+	/* stage the shorter path for name_to_dev_t. */
+	strncpy(base_path, path, sizeof(base_path));
+
+	/* lookup by major:minor or registered device name */
+	if (!(dev = name_to_dev_t(base_path))) {
+		/* convert the path to a device by finding its inode */
 		struct block_device *bdev = lookup_bdev(path);
 
 		if (IS_ERR(bdev))
-- 
1.7.0.4

