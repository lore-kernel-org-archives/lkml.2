Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab0IPWpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:45:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:60708 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab0IPWpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:45:15 -0400
From: Jan Kara <jack@suse.cz>
To: Jens@suse.cz, "Axboe <axboe"@kernel.dk
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] char: Mark /dev/zero and /dev/kmem as not capable of writeback
Date: Fri, 17 Sep 2010 00:44:10 +0200
Message-Id: <1284677051-28564-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1284677051-28564-1-git-send-email-jack@suse.cz>
References: <1284677051-28564-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These devices don't do any writeback but their device inodes still can get
dirty so mark bdi appropriately so that bdi code does the right thing and files
inodes to lists of bdi carrying the device inodes.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/char/mem.c |    3 ++-
 fs/char_dev.c      |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index a398ecd..1f528fa 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -788,10 +788,11 @@ static const struct file_operations zero_fops = {
 /*
  * capabilities for /dev/zero
  * - permits private mappings, "copies" are taken of the source of zeros
+ * - no writeback happens
  */
 static struct backing_dev_info zero_bdi = {
 	.name		= "char/mem",
-	.capabilities	= BDI_CAP_MAP_COPY,
+	.capabilities	= BDI_CAP_MAP_COPY | BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 
 static const struct file_operations full_fops = {
diff --git a/fs/char_dev.c b/fs/char_dev.c
index f80a4f2..143d393 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -40,7 +40,9 @@ struct backing_dev_info directly_mappable_cdev_bdi = {
 #endif
 		/* permit direct mmap, for read, write or exec */
 		BDI_CAP_MAP_DIRECT |
-		BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP),
+		BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP |
+		/* no writeback happens */
+		BDI_CAP_NO_ACCT_AND_WRITEBACK),
 };
 
 static struct kobj_map *cdev_map;
-- 
1.6.4.2

