Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030881Ab2ERC6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:58:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40591 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030735Ab2ERCwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:50 -0400
Message-Id: <20120518023300.972513351@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nicholas Bellinger <nab@linux-iscsi.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [ 49/53] target: Fix bug in handling of FILEIO + block_device resize ops
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit cd9323fd68aee3c1c6b5b21e5746c9d1b586fb58 upstream.

This patch fixes a bug in the handling of FILEIO w/ underlying block_device
resize operations where the original fd_dev->fd_dev_size was incorrectly being
used in fd_get_blocks() for READ_CAPACITY response payloads.

This patch avoids using fd_dev->fd_dev_size for FILEIO devices with
an underlying block_device, and instead changes fd_get_blocks() to
get the sector count directly from i_size_read() as recommended by hch.

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_file.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 7ed58e2..f286955 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -169,6 +169,7 @@ static struct se_device *fd_create_virtdevice(
 	inode = file->f_mapping->host;
 	if (S_ISBLK(inode->i_mode)) {
 		struct request_queue *q;
+		unsigned long long dev_size;
 		/*
 		 * Setup the local scope queue_limits from struct request_queue->limits
 		 * to pass into transport_add_device_to_core_hba() as struct se_dev_limits.
@@ -183,13 +184,12 @@ static struct se_device *fd_create_virtdevice(
 		 * one (1) logical sector from underlying struct block_device
 		 */
 		fd_dev->fd_block_size = bdev_logical_block_size(inode->i_bdev);
-		fd_dev->fd_dev_size = (i_size_read(file->f_mapping->host) -
+		dev_size = (i_size_read(file->f_mapping->host) -
 				       fd_dev->fd_block_size);
 
 		pr_debug("FILEIO: Using size: %llu bytes from struct"
 			" block_device blocks: %llu logical_block_size: %d\n",
-			fd_dev->fd_dev_size,
-			div_u64(fd_dev->fd_dev_size, fd_dev->fd_block_size),
+			dev_size, div_u64(dev_size, fd_dev->fd_block_size),
 			fd_dev->fd_block_size);
 	} else {
 		if (!(fd_dev->fbd_flags & FBDF_HAS_SIZE)) {
@@ -605,10 +605,20 @@ static u32 fd_get_device_type(struct se_device *dev)
 static sector_t fd_get_blocks(struct se_device *dev)
 {
 	struct fd_dev *fd_dev = dev->dev_ptr;
-	unsigned long long blocks_long = div_u64(fd_dev->fd_dev_size,
-			dev->se_sub_dev->se_dev_attrib.block_size);
+	struct file *f = fd_dev->fd_file;
+	struct inode *i = f->f_mapping->host;
+	unsigned long long dev_size;
+	/*
+	 * When using a file that references an underlying struct block_device,
+	 * ensure dev_size is always based on the current inode size in order
+	 * to handle underlying block_device resize operations.
+	 */
+	if (S_ISBLK(i->i_mode))
+		dev_size = (i_size_read(i) - fd_dev->fd_block_size);
+	else
+		dev_size = fd_dev->fd_dev_size;
 
-	return blocks_long;
+	return div_u64(dev_size, dev->se_sub_dev->se_dev_attrib.block_size);
 }
 
 static struct se_subsystem_api fileio_template = {
-- 
1.7.10



