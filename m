Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab0HPOY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:24:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:38779 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab0HPOY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:24:27 -0400
Message-ID: <4C694965.6040805@kernel.org>
Date: Mon, 16 Aug 2010 16:21:25 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>
CC: Christoph Hellwig <hch@lst.de>, Neil Brown <neilb@suse.de>
Subject: [PATCH block#for-2.6.36-post] block: fix incorrect bio/request flag
 conversion in md
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 Aug 2010 14:24:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 74450be1 (block: unify flags for struct bio and struct request)
incorrectly converted @do_sync in md raid1 and raid10 make_requst()
functions.

@do_sync is now supposed to carry the actual flag bit and directly
OR'd into bio->bi_rw but is still a bool and thus carries either 0 or
1 instead of the actual flag bit.  This makes REQ_SYNC ignored on
writes and flips the direction of READ_SYNCs to WRITEs.

Fix it by making @do_sync unsigned integers.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
---
 drivers/md/raid1.c  |    2 +-
 drivers/md/raid10.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: block/drivers/md/raid1.c
===================================================================
--- block.orig/drivers/md/raid1.c
+++ block/drivers/md/raid1.c
@@ -787,7 +787,7 @@ static int make_request(mddev_t *mddev,
 	struct bio_list bl;
 	struct page **behind_pages = NULL;
 	const int rw = bio_data_dir(bio);
-	const bool do_sync = (bio->bi_rw & REQ_SYNC);
+	const unsigned int do_sync = (bio->bi_rw & REQ_SYNC);
 	bool do_barriers;
 	mdk_rdev_t *blocked_rdev;

Index: block/drivers/md/raid10.c
===================================================================
--- block.orig/drivers/md/raid10.c
+++ block/drivers/md/raid10.c
@@ -799,7 +799,7 @@ static int make_request(mddev_t *mddev,
 	int i;
 	int chunk_sects = conf->chunk_mask + 1;
 	const int rw = bio_data_dir(bio);
-	const bool do_sync = (bio->bi_rw & REQ_SYNC);
+	const unsigned int do_sync = (bio->bi_rw & REQ_SYNC);
 	struct bio_list bl;
 	unsigned long flags;
 	mdk_rdev_t *blocked_rdev;
