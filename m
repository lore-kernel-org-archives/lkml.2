Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1ECSF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 14:05:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56153 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab1ECSF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 14:05:27 -0400
Date: Tue, 3 May 2011 14:05:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: merging discard request in the block layer
Message-ID: <20110503180526.GA2127@infradead.org>
References: <20110322194755.GA20122@infradead.org>
 <4D88FE5E.1010204@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D88FE5E.1010204@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I finally maged to debug this a bit further and can have found a cure
for the null pointer derefences I got on recent kernels.

The problem is that bio_has_data thinks discard requests have a payload
and thus tries to poke into it's pages when trying to merge requests.
Taking the REQ_DISCARD check in to bio_has_data fixes that.  I've also
tried to special case discard requests in bio_cur_bytes, but that
doesn't fix the botched requests messages yet.  I suspect the merging
code might need some additions to update the bio_size for discard
requests that it currently skips.

Index: xfs/block/blk-core.c
===================================================================
--- xfs.orig/block/blk-core.c	2011-05-03 19:45:51.980219652 +0200
+++ xfs/block/blk-core.c	2011-05-03 19:47:51.756237436 +0200
@@ -1645,7 +1645,7 @@ void submit_bio(int rw, struct bio *bio)
 	 * If it's a regular read/write or a barrier with data attached,
 	 * go through the normal accounting stuff before submission.
 	 */
-	if (bio_has_data(bio) && !(rw & REQ_DISCARD)) {
+	if (bio_has_data(bio)) {
 		if (rw & WRITE) {
 			count_vm_events(PGPGOUT, count);
 		} else {
Index: xfs/include/linux/bio.h
===================================================================
--- xfs.orig/include/linux/bio.h	2011-05-03 19:43:28.537663414 +0200
+++ xfs/include/linux/bio.h	2011-05-03 19:48:18.632758500 +0200
@@ -69,7 +69,7 @@
 
 static inline unsigned int bio_cur_bytes(struct bio *bio)
 {
-	if (bio->bi_vcnt)
+	if (bio->bi_vcnt && !(bio->bi_rw & REQ_DISCARD))
 		return bio_iovec(bio)->bv_len;
 	else /* dataless requests such as discard */
 		return bio->bi_size;
@@ -368,7 +368,7 @@ static inline char *__bio_kmap_irq(struc
  */
 static inline int bio_has_data(struct bio *bio)
 {
-	return bio && bio->bi_io_vec != NULL;
+	return bio && bio->bi_io_vec != NULL && !(bio->bi_rw & REQ_DISCARD);
 }
 
 /*
