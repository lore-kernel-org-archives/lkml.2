Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2HaQtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:49:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab2HaQtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:49:16 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Ashish Sangwan <ashish.sangwan2@gmail.com>
Subject: [PATCH] udf: add writepages support for udf
Date: Fri, 31 Aug 2012 12:49:07 -0400
Message-Id: <1346431747-3581-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mpage_writepages() instead of multiple calls to udf_writepage()
to make performance higher.

*Write Speed with writepage() =
 RecSize     ReadSpeed    WriteSpeed  RanReadSpeed RanWriteSpeed
10485760    0.00MB/sec    8.56MB/sec    0.00MB/sec    8.20MB/sec
 1048576    0.00MB/sec    8.57MB/sec    0.00MB/sec    6.42MB/sec
  524288    0.00MB/sec    8.59MB/sec    0.00MB/sec    5.24MB/sec
  262144    0.00MB/sec    8.59MB/sec    0.00MB/sec    4.17MB/sec
  131072    0.00MB/sec    8.53MB/sec    0.00MB/sec    3.32MB/sec
   65536    0.00MB/sec    8.49MB/sec    0.00MB/sec    2.31MB/sec

*Write Speed with writepages()
RecSize     ReadSpeed    WriteSpeed  RanReadSpeed RanWriteSpeed
10485760    0.00MB/sec    9.88MB/sec    0.00MB/sec    9.60MB/sec
 1048576    0.00MB/sec    9.95MB/sec    0.00MB/sec    7.52MB/sec
  524288    0.00MB/sec    9.98MB/sec    0.00MB/sec    6.16MB/sec
  262144    0.00MB/sec    9.90MB/sec    0.00MB/sec    4.98MB/sec
  131072    0.00MB/sec    9.89MB/sec    0.00MB/sec    3.78MB/sec
   65536    0.00MB/sec    9.81MB/sec    0.00MB/sec    2.50MB/sec

There is about 1.4MB/sec speed improvement over 8.5MB/sec,
whcih comes out around 16% improvement.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Ashish Sangwan <ashish.sangwan2@gmail.com>
---
 fs/udf/inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index aa23346..1a0588e 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -100,6 +100,12 @@ static int udf_writepage(struct page *page, struct writeback_control *wbc)
 	return block_write_full_page(page, udf_get_block, wbc);
 }
 
+static int udf_writepages(struct address_space *mapping,
+			struct writeback_control *wbc)
+{
+	return mpage_writepages(mapping, wbc, udf_get_block);
+}
+
 static int udf_readpage(struct file *file, struct page *page)
 {
 	return mpage_readpage(page, udf_get_block);
@@ -145,6 +151,7 @@ const struct address_space_operations udf_aops = {
 	.readpage	= udf_readpage,
 	.readpages	= udf_readpages,
 	.writepage	= udf_writepage,
+	.writepages	= udf_writepages,
 	.write_begin		= udf_write_begin,
 	.write_end		= generic_write_end,
 	.bmap		= udf_bmap,
-- 
1.7.9.5

