Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab2CLDO0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 23:14:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64999 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2CLDNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 23:13:15 -0400
Message-Id: <20120312031305.946211513@fusionio.com>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 11:04:18 +0800
From: Shaohua Li <shli@fusionio.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, Shaohua Li <shli@fusionio.com>
Subject: [patch 6/7] blk: add plug for blkdev_issue_discard
References: <20120312030412.375458948@fusionio.com>
Content-Disposition: inline; filename=blk-discard-plug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In raid 0 case, a big discard request is divided into several small requests
in chunk_size unit. Such requests can be merged in low layer if we have
correct plug added. This should improve the performance a little bit.

raid 10 case doesn't matter, as we dispatch request in a separate thread
and there is plug there.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 block/blk-lib.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/block/blk-lib.c
===================================================================
--- linux.orig/block/blk-lib.c	2012-03-09 16:56:41.043790011 +0800
+++ linux/block/blk-lib.c	2012-03-12 10:21:38.716609525 +0800
@@ -47,6 +47,7 @@ int blkdev_issue_discard(struct block_de
 	struct bio_batch bb;
 	struct bio *bio;
 	int ret = 0;
+	struct blk_plug plug;
 
 	if (!q)
 		return -ENXIO;
@@ -78,6 +79,7 @@ int blkdev_issue_discard(struct block_de
 	bb.flags = 1 << BIO_UPTODATE;
 	bb.wait = &wait;
 
+	blk_start_plug(&plug);
 	while (nr_sects) {
 		bio = bio_alloc(gfp_mask, 1);
 		if (!bio) {
@@ -102,6 +104,7 @@ int blkdev_issue_discard(struct block_de
 		atomic_inc(&bb.done);
 		submit_bio(type, bio);
 	}
+	blk_finish_plug(&plug);
 
 	/* Wait for bios in-flight */
 	if (!atomic_dec_and_test(&bb.done))

