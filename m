Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab1JCE5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 00:57:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34862 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab1JCE5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 00:57:31 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] isofs : add readpages support for isofs. Using mpage_readpages instead of multiple calls to isofs_readpage to reduce the CPU utilization and make performance higher.
Date: Mon,  3 Oct 2011 13:57:17 +0900
Message-Id: <1317617837-22108-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/isofs/inode.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index a5d0367..46844ff 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -20,6 +20,7 @@
 #include <linux/statfs.h>
 #include <linux/cdrom.h>
 #include <linux/parser.h>
+#include <linux/mpage.h>
 
 #include "isofs.h"
 #include "zisofs.h"
@@ -1148,7 +1149,13 @@ struct buffer_head *isofs_bread(struct inode *inode, sector_t block)
 
 static int isofs_readpage(struct file *file, struct page *page)
 {
-	return block_read_full_page(page,isofs_get_block);
+	return mpage_readpage(page, isofs_get_block);
+}
+
+static int isofs_readpages(struct file *file, struct address_space *mapping,
+			struct list_head *pages, unsigned nr_pages)
+{
+	return mpage_readpages(mapping, pages, nr_pages, isofs_get_block);
 }
 
 static sector_t _isofs_bmap(struct address_space *mapping, sector_t block)
@@ -1158,6 +1165,7 @@ static sector_t _isofs_bmap(struct address_space *mapping, sector_t block)
 
 static const struct address_space_operations isofs_aops = {
 	.readpage = isofs_readpage,
+	.readpages = isofs_readpages,
 	.bmap = _isofs_bmap
 };
 
-- 
1.7.4.4

