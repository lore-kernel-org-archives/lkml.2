Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030981Ab2ERDAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:00:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60570 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030713Ab2ERDAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 23:00:08 -0400
From: koverstreet@google.com
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: [PATCH 02/13] dm: kill dm_rq_bio_destructor
Date: Thu, 17 May 2012 22:59:49 -0400
Message-Id: <f07bc0f57562d98078e0f4c507cae165aa159e7c.1337308722.git.koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.rc2
In-Reply-To: <cover.1337308722.git.koverstreet@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
In-Reply-To: <cover.1337308722.git.koverstreet@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <koverstreet@google.com>

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/md/dm.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2114ec1..3cc2169 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -701,6 +701,7 @@ static void end_clone_bio(struct bio *clone, int error)
 	struct bio *bio = info->orig;
 	unsigned int nr_bytes = info->orig->bi_size;
 
+	free_bio_info(info);
 	bio_put(clone);
 
 	if (tio->error)
@@ -1448,15 +1449,6 @@ void dm_dispatch_request(struct request *rq)
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
@@ -1471,7 +1463,6 @@ static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
 	info->tio = tio;
 	bio->bi_end_io = end_clone_bio;
 	bio->bi_private = info;
-	bio->bi_destructor = dm_rq_bio_destructor;
 
 	return 0;
 }
-- 
1.7.9.rc2

