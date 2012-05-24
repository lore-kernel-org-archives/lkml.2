Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab2EXADx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 20:03:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33321 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab2EXADX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 20:03:23 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        bharrosh@panasas.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: [PATCH v2 02/14] dm: kill dm_rq_bio_destructor
Date: Wed, 23 May 2012 17:02:39 -0700
Message-Id: <1337817771-25038-3-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
In-Reply-To: <1337817771-25038-1-git-send-email-koverstreet@google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/md/dm.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 40b7735..e6e7b19 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -696,6 +696,7 @@ static void end_clone_bio(struct bio *clone, int error)
 	struct bio *bio = info->orig;
 	unsigned int nr_bytes = info->orig->bi_size;
 
+	free_bio_info(info);
 	bio_put(clone);
 
 	if (tio->error)
@@ -1438,15 +1439,6 @@ void dm_dispatch_request(struct request *rq)
 }
 EXPORT_SYMBOL_GPL(dm_dispatch_request);
 
-static void dm_rq_bio_destructor(struct bio *bio)
-{
-	struct dm_rq_clone_bio_info *info = bio->bi_private;
-	struct mapped_device *md = info->tio->md;
-
-	free_bio_info(info);
-	bio_free(bio, md->bs);
-}
-
 static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
 				 void *data)
 {
@@ -1461,7 +1453,6 @@ static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
 	info->tio = tio;
 	bio->bi_end_io = end_clone_bio;
 	bio->bi_private = info;
-	bio->bi_destructor = dm_rq_bio_destructor;
 
 	return 0;
 }
-- 
1.7.9.3.327.g2980b

