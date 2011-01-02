Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab1ABHvG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:51:06 -0500
Received: from mail.windriver.com ([147.11.1.11]:35778 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab1ABHXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:42 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jan Kara <jack@suse.cz>,
        Jens Axboe <jaxboe@fusionio.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 131/260] char: Mark /dev/zero and /dev/kmem as not capable of writeback
Date: Sun,  2 Jan 2011 02:17:07 -0500
Message-Id: <1293952756-15010-132-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:33.0462 (UTC) FILETIME=[D2B74160:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 371d217ee1ff8b418b8f73fb2a34990f951ec2d4 upstream.

These devices don't do any writeback but their device inodes still can get
dirty so mark bdi appropriately so that bdi code does the right thing and files
inodes to lists of bdi carrying the device inodes.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/mem.c |    3 ++-
 fs/char_dev.c      |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index f54dab8..16a4443 100644
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
index d6db933..be7613e 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -39,7 +39,9 @@ struct backing_dev_info directly_mappable_cdev_bdi = {
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
1.7.3.3

