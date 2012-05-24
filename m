Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933990Ab2EXXdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 19:33:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54865 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758841Ab2EXXdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 19:33:10 -0400
Date: Thu, 24 May 2012 16:33:07 -0700
From: Kent Overstreet <koverstreet@google.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, yehuda@hq.newdream.net,
        mpatocka@redhat.com, vgoyal@redhat.com, bharrosh@panasas.com,
        tj@kernel.org, sage@newdream.net, agk@redhat.com,
        drbd-dev@lists.linbit.com
Subject: Re: [dm-devel] [PATCH v2 02/14] dm: kill dm_rq_bio_destructor
Message-ID: <20120524233307.GD22664@google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-3-git-send-email-koverstreet@google.com>
 <4FBD7E80.4020005@ce.jp.nec.com>
 <20120524003915.GA27443@google.com>
 <4FBD8BD9.8070708@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBD8BD9.8070708@ce.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 10:16:09AM +0900, Jun'ichi Nomura wrote:
> On 05/24/12 09:39, Kent Overstreet wrote:
> > On Thu, May 24, 2012 at 09:19:12AM +0900, Jun'ichi Nomura wrote:
> >> The destructor may also be called from blk_rq_unprep_clone(),
> >> which just puts bio.
> >> So this patch will introduce a memory leak.
> > 
> > Well, keeping around bi_destructor solely for that reason would be
> > pretty lousy. Can you come up with a better solution?
> 
> I don't have good one but here are some ideas:
>   a) Do bio_endio() rather than bio_put() in blk_rq_unprep_clone()
>      and let bi_end_io reap additional data.
>      It looks ugly.
>   b) Separate the constructor from blk_rq_prep_clone().
>      dm has to do rq_for_each_bio loop again for constructor.
>      Possible performance impact.
>   c) Open code blk_rq_prep/unprep_clone() in dm.
>      It exposes unnecessary block-internals to dm.
>   d) Pass destructor function to blk_rq_prep/unprep_clone()
>      for them to callback.

I hadn't looked at this closely enough before. But, when I did I came up
with an option e: get rid of the dm_rq_clone_bio_info allocation by
using bio_set's front_pad.


commit af696ef77e2ddc4e510f8213e14d754af41e5014
Author: Kent Overstreet <koverstreet@google.com>
Date:   Tue May 15 18:03:45 2012 -0700

    dm: Use bioset's front_pad for dm_rq_clone_bio_info
    
    Previously, dm_rq_clone_bio_info needed to be freed by the bio's
    destructor to avoid a memory leak in the blk_rq_prep_clone() error path.
    This gets rid of a memory allocation and means we can kill
    dm_rq_bio_destructor.

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 40b7735..4014696 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -92,6 +92,7 @@ struct dm_rq_target_io {
 struct dm_rq_clone_bio_info {
 	struct bio *orig;
 	struct dm_rq_target_io *tio;
+	struct bio clone;
 };
 
 union map_info *dm_get_mapinfo(struct bio *bio)
@@ -467,16 +468,6 @@ static void free_rq_tio(struct dm_rq_target_io *tio)
 	mempool_free(tio, tio->md->tio_pool);
 }
 
-static struct dm_rq_clone_bio_info *alloc_bio_info(struct mapped_device *md)
-{
-	return mempool_alloc(md->io_pool, GFP_ATOMIC);
-}
-
-static void free_bio_info(struct dm_rq_clone_bio_info *info)
-{
-	mempool_free(info, info->tio->md->io_pool);
-}
-
 static int md_in_flight(struct mapped_device *md)
 {
 	return atomic_read(&md->pending[READ]) +
@@ -1438,30 +1429,17 @@ void dm_dispatch_request(struct request *rq)
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
 	struct dm_rq_target_io *tio = data;
-	struct mapped_device *md = tio->md;
-	struct dm_rq_clone_bio_info *info = alloc_bio_info(md);
-
-	if (!info)
-		return -ENOMEM;
+	struct dm_rq_clone_bio_info *info =
+		container_of(bio, struct dm_rq_clone_bio_info, clone);
 
 	info->orig = bio_orig;
 	info->tio = tio;
 	bio->bi_end_io = end_clone_bio;
 	bio->bi_private = info;
-	bio->bi_destructor = dm_rq_bio_destructor;
 
 	return 0;
 }
@@ -2696,7 +2674,8 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity)
 	if (!pools->tio_pool)
 		goto free_io_pool_and_out;
 
-	pools->bs = bioset_create(pool_size, 0);
+	pools->bs = bioset_create(pool_size,
+				  offsetof(struct dm_rq_clone_bio_info, orig));
 	if (!pools->bs)
 		goto free_tio_pool_and_out;
 
