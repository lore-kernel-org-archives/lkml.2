Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1AVBRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:17:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:45819 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab1AVBRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:17:43 -0500
From: Jens Axboe <jaxboe@fusionio.com>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: [PATCH 07/10] fs: make generic file read/write functions plug
Date: Sat, 22 Jan 2011 01:17:26 +0000
Message-Id: <1295659049-2688-8-git-send-email-jaxboe@fusionio.com>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 22 Jan 2011 01:17:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
---
 mm/filemap.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 380776c..f9a29c8 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1243,12 +1243,15 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 	unsigned long seg = 0;
 	size_t count;
 	loff_t *ppos = &iocb->ki_pos;
+	struct blk_plug plug;
 
 	count = 0;
 	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
 	if (retval)
 		return retval;
 
+	blk_start_plug(&plug);
+
 	/* coalesce the iovecs and go direct-to-BIO for O_DIRECT */
 	if (filp->f_flags & O_DIRECT) {
 		loff_t size;
@@ -1321,6 +1324,7 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 			break;
 	}
 out:
+	blk_finish_plug(&plug);
 	return retval;
 }
 EXPORT_SYMBOL(generic_file_aio_read);
@@ -2432,11 +2436,13 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
+	struct blk_plug plug;
 	ssize_t ret;
 
 	BUG_ON(iocb->ki_pos != pos);
 
 	mutex_lock(&inode->i_mutex);
+	blk_start_plug(&plug);
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
 
@@ -2447,6 +2453,7 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 		if (err < 0 && ret > 0)
 			ret = err;
 	}
+	blk_finish_plug(&plug);
 	return ret;
 }
 EXPORT_SYMBOL(generic_file_aio_write);
-- 
1.7.3.2.146.gca209

