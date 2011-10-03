Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab1JCFDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 01:03:19 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49734 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab1JCFDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 01:03:14 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 2/2 v2] udf : add readpages support for udf.
Date: Mon,  3 Oct 2011 14:02:59 +0900
Message-Id: <1317618179-22176-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using mpage_readpages instead of multiple calls to udf_readpage to reduce the CPU utilization and make performance higher.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/udf/inode.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 58665ce..81f9ce1 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -37,6 +37,7 @@
 #include <linux/writeback.h>
 #include <linux/slab.h>
 #include <linux/crc-itu-t.h>
+#include <linux/mpage.h>
 
 #include "udf_i.h"
 #include "udf_sb.h"
@@ -104,7 +105,13 @@ static int udf_writepage(struct page *page, struct writeback_control *wbc)
 
 static int udf_readpage(struct file *file, struct page *page)
 {
-	return block_read_full_page(page, udf_get_block);
+	return mpage_readpage(page, udf_get_block);
+}
+
+static int udf_readpages(struct file *file, struct address_space *mapping,
+			struct list_head *pages, unsigned nr_pages)
+{
+	return mpage_readpages(mapping, pages, nr_pages, udf_get_block);
 }
 
 static int udf_write_begin(struct file *file, struct address_space *mapping,
@@ -139,6 +146,7 @@ static sector_t udf_bmap(struct address_space *mapping, sector_t block)
 
 const struct address_space_operations udf_aops = {
 	.readpage	= udf_readpage,
+	.readpages	= udf_readpages,
 	.writepage	= udf_writepage,
 	.write_begin		= udf_write_begin,
 	.write_end		= generic_write_end,
-- 
1.7.4.4

