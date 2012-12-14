Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab2LNDQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 22:16:00 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47660 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab2LNDP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 22:15:59 -0500
Date: Fri, 14 Dec 2012 11:15:51 +0800
From: Shaohua Li <shli@kernel.org>
To: axboe@kernel.dk
Cc: neilb@suse.de, linux-kernel@vger.kernel.org
Subject: [patch 2/2]block: add plug for blkdev_issue_discard
Message-ID: <20121214031551.GB30345@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last post of this patch appears lost, so I resend this.

Now discard merge works, add plug for blkdev_issue_discard. This will help
discard request merge especially for raid0 case. In raid0, a big discard
request is split to small requests, and if correct plug is added, such small
requests can be merged in low layer.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 block/blk-lib.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/block/blk-lib.c
===================================================================
--- linux.orig/block/blk-lib.c	2012-12-14 10:03:22.305422686 +0800
+++ linux/block/blk-lib.c	2012-12-14 10:08:50.577295672 +0800
@@ -48,6 +48,7 @@ int blkdev_issue_discard(struct block_de
 	struct bio_batch bb;
 	struct bio *bio;
 	int ret = 0;
+	struct blk_plug plug;
 
 	if (!q)
 		return -ENXIO;
@@ -82,6 +83,7 @@ int blkdev_issue_discard(struct block_de
 	bb.flags = 1 << BIO_UPTODATE;
 	bb.wait = &wait;
 
+	blk_start_plug(&plug);
 	while (nr_sects) {
 		unsigned int req_sects;
 		sector_t end_sect, tmp;
@@ -120,6 +122,7 @@ int blkdev_issue_discard(struct block_de
 		atomic_inc(&bb.done);
 		submit_bio(type, bio);
 	}
+	blk_finish_plug(&plug);
 
 	/* Wait for bios in-flight */
 	if (!atomic_dec_and_test(&bb.done))
