Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab2KVT3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:29:25 -0500
Received: from aserp1050.oracle.com ([141.146.126.70]:26014 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965209Ab2KVT3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:29:01 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org
Subject: [PATCH v4 31/31] ubifs: convert file ops from aio_read/write to read/write_iter
Date: Wed, 21 Nov 2012 16:41:11 -0600
Message-Id: <1353537671-26284-32-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: aserp1040.oracle.com [141.146.126.69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-mtd@lists.infradead.org
---
 fs/ubifs/file.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 5bc7781..cfe6210 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -44,7 +44,7 @@
  * 'ubifs_writepage()' we are only guaranteed that the page is locked.
  *
  * Similarly, @i_mutex is not always locked in 'ubifs_readpage()', e.g., the
- * read-ahead path does not lock it ("sys_read -> generic_file_aio_read ->
+ * read-ahead path does not lock it ("sys_read -> generic_file_read_iter ->
  * ondemand_readahead -> readpage"). In case of readahead, @I_SYNC flag is not
  * set as well. However, UBIFS disables readahead.
  */
@@ -1394,8 +1394,8 @@ static int update_mctime(struct ubifs_info *c, struct inode *inode)
 	return 0;
 }
 
-static ssize_t ubifs_aio_write(struct kiocb *iocb, const struct iovec *iov,
-			       unsigned long nr_segs, loff_t pos)
+static ssize_t ubifs_write_iter(struct kiocb *iocb, struct iov_iter *iter,
+				loff_t pos)
 {
 	int err;
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
@@ -1405,7 +1405,7 @@ static ssize_t ubifs_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	if (err)
 		return err;
 
-	return generic_file_aio_write(iocb, iov, nr_segs, pos);
+	return generic_file_write_iter(iocb, iter, pos);
 }
 
 static int ubifs_set_page_dirty(struct page *page)
@@ -1580,8 +1580,8 @@ const struct file_operations ubifs_file_operations = {
 	.llseek         = generic_file_llseek,
 	.read           = do_sync_read,
 	.write          = do_sync_write,
-	.aio_read       = generic_file_aio_read,
-	.aio_write      = ubifs_aio_write,
+	.read_iter       = generic_file_read_iter,
+	.write_iter      = ubifs_write_iter,
 	.mmap           = ubifs_file_mmap,
 	.fsync          = ubifs_fsync,
 	.unlocked_ioctl = ubifs_ioctl,
-- 
1.8.0

