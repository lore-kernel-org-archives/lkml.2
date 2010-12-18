Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab0LRA23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 19:28:29 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:25949 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756446Ab0LRA22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 19:28:28 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAN+OC03O+J1F/2dsb2JhbACkMnS+WoVKBIRlhhyHdg
X-IronPort-AV: E=Sophos;i="4.60,191,1291611600"; 
   d="scan'208";a="85767145"
From: Matthew Wilcox <willy@linux.intel.com>
To: Jens Axboe <jaxboe@fusionio.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Cc: Shane Michael Matthews <shane.matthews@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH] Add readpages support for block devices
Date: Fri, 17 Dec 2010 19:27:53 -0500
Message-Id: <1292632073-6196-1-git-send-email-willy@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shane Michael Matthews <shane.matthews@intel.com>

Using mpage_readpages instead of multiple calls to blkdev_readpage reduces
the CPU utilisation by 35% when using dd to clone a drive.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Shane Michael Matthews <shane.matthews@intel.com>
---
 fs/block_dev.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 4230252..55cf932 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -318,6 +318,12 @@ static int blkdev_readpage(struct file * file, struct page * page)
 	return block_read_full_page(page, blkdev_get_block);
 }
 
+static int blkdev_readpages(struct file *file, struct address_space *mapping,
+			struct list_head *pages, unsigned nr_pages)
+{
+	return mpage_readpages(mapping, pages, nr_pages, blkdev_get_block);
+}
+
 static int blkdev_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
@@ -1634,6 +1640,7 @@ static int blkdev_releasepage(struct page *page, gfp_t wait)
 
 static const struct address_space_operations def_blk_aops = {
 	.readpage	= blkdev_readpage,
+	.readpages	= blkdev_readpages,
 	.writepage	= blkdev_writepage,
 	.sync_page	= block_sync_page,
 	.write_begin	= blkdev_write_begin,
-- 
1.7.2.3

