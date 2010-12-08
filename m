Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab0LHA7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:59:03 -0500
Received: from kroah.org ([198.145.64.141]:48289 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758Ab0LHA7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:00 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:21 2010
Message-Id: <20101208005721.832585091@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [004/289] block: take care not to overflow when calculating total iov length
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jens Axboe <jaxboe@fusionio.com>

commit 9f864c80913467312c7b8690e41fb5ebd1b50e92 upstream.

Reported-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/scsi_ioctl.c |   34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -321,33 +321,47 @@ static int sg_io(struct request_queue *q
 	if (hdr->iovec_count) {
 		const int size = sizeof(struct sg_iovec) * hdr->iovec_count;
 		size_t iov_data_len;
-		struct sg_iovec *iov;
+		struct sg_iovec *sg_iov;
+		struct iovec *iov;
+		int i;
 
-		iov = kmalloc(size, GFP_KERNEL);
-		if (!iov) {
+		sg_iov = kmalloc(size, GFP_KERNEL);
+		if (!sg_iov) {
 			ret = -ENOMEM;
 			goto out;
 		}
 
-		if (copy_from_user(iov, hdr->dxferp, size)) {
-			kfree(iov);
+		if (copy_from_user(sg_iov, hdr->dxferp, size)) {
+			kfree(sg_iov);
 			ret = -EFAULT;
 			goto out;
 		}
 
+		/*
+		 * Sum up the vecs, making sure they don't overflow
+		 */
+		iov = (struct iovec *) sg_iov;
+		iov_data_len = 0;
+		for (i = 0; i < hdr->iovec_count; i++) {
+			if (iov_data_len + iov[i].iov_len < iov_data_len) {
+				kfree(sg_iov);
+				ret = -EINVAL;
+				goto out;
+			}
+			iov_data_len += iov[i].iov_len;
+		}
+
 		/* SG_IO howto says that the shorter of the two wins */
-		iov_data_len = iov_length((struct iovec *)iov,
-					  hdr->iovec_count);
 		if (hdr->dxfer_len < iov_data_len) {
-			hdr->iovec_count = iov_shorten((struct iovec *)iov,
+			hdr->iovec_count = iov_shorten(iov,
 						       hdr->iovec_count,
 						       hdr->dxfer_len);
 			iov_data_len = hdr->dxfer_len;
 		}
 
-		ret = blk_rq_map_user_iov(q, rq, NULL, iov, hdr->iovec_count,
+		ret = blk_rq_map_user_iov(q, rq, NULL, sg_iov, hdr->iovec_count,
 					  iov_data_len, GFP_KERNEL);
-		kfree(iov);
+		kfree(sg_iov);
 	} else if (hdr->dxfer_len)
 		ret = blk_rq_map_user(q, rq, NULL, hdr->dxferp, hdr->dxfer_len,
 				      GFP_KERNEL);


