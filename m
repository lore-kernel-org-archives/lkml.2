Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab2EXBmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 21:42:03 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:35119 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab2EXBmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 21:42:00 -0400
Message-ID: <4FBD914A.5040406@ce.jp.nec.com>
Date: Thu, 24 May 2012 10:39:22 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: device-mapper development <dm-devel@redhat.com>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, tj@kernel.org,
        linux-bcache@vger.kernel.org, mpatocka@redhat.com, agk@redhat.com,
        bharrosh@panasas.com, linux-fsdevel@vger.kernel.org,
        yehuda@hq.newdream.net, drbd-dev@lists.linbit.com, vgoyal@redhat.com,
        sage@newdream.net
Subject: Re: [dm-devel] [PATCH v2 02/14] dm: kill dm_rq_bio_destructor
References: <1337817771-25038-1-git-send-email-koverstreet@google.com> <1337817771-25038-3-git-send-email-koverstreet@google.com> <4FBD7E80.4020005@ce.jp.nec.com> <20120524003915.GA27443@google.com> <4FBD8BD9.8070708@ce.jp.nec.com>
In-Reply-To: <4FBD8BD9.8070708@ce.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/12 10:16, Jun'ichi Nomura wrote:
> On 05/24/12 09:39, Kent Overstreet wrote:
>> On Thu, May 24, 2012 at 09:19:12AM +0900, Jun'ichi Nomura wrote:
>>> The destructor may also be called from blk_rq_unprep_clone(),
>>> which just puts bio.
>>> So this patch will introduce a memory leak.
>>
>> Well, keeping around bi_destructor solely for that reason would be
>> pretty lousy. Can you come up with a better solution?
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
> 
> Umm, is "d)" better?

I mean the patch like this:

Index: linux-3.4/block/blk-core.c
===================================================================
--- linux-3.4.orig/block/blk-core.c	2012-05-21 07:29:13.000000000 +0900
+++ linux-3.4/block/blk-core.c	2012-05-24 11:15:40.562817784 +0900
@@ -2596,17 +2596,20 @@
 /**
  * blk_rq_unprep_clone - Helper function to free all bios in a cloned request
  * @rq: the clone request to be cleaned up
+ * @bio_dtr: cleanup function to be called for each clone bio.
  *
  * Description:
  *     Free all bios in @rq for a cloned request.
  */
-void blk_rq_unprep_clone(struct request *rq)
+void blk_rq_unprep_clone(struct request *rq, void (*bio_dtr)(struct bio *))
 {
 	struct bio *bio;
 
 	while ((bio = rq->bio) != NULL) {
 		rq->bio = bio->bi_next;
 
+		if (bio_dtr)
+			bio_dtr(bio);
 		bio_put(bio);
 	}
 }
@@ -2636,6 +2639,7 @@
  * @gfp_mask: memory allocation mask for bio
  * @bio_ctr: setup function to be called for each clone bio.
  *           Returns %0 for success, non %0 for failure.
+ * @bio_dtr: cleanup function to be called for each clone bio.
  * @data: private data to be passed to @bio_ctr
  *
  * Description:
@@ -2650,7 +2654,7 @@
 int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 		      struct bio_set *bs, gfp_t gfp_mask,
 		      int (*bio_ctr)(struct bio *, struct bio *, void *),
-		      void *data)
+		      void (*bio_dtr)(struct bio *), void *data)
 {
 	struct bio *bio, *bio_src;
 
@@ -2687,7 +2691,7 @@
 free_and_out:
 	if (bio)
 		bio_free(bio, bs);
-	blk_rq_unprep_clone(rq);
+	blk_rq_unprep_clone(rq, bio_dtr);
 
 	return -ENOMEM;
 }
Index: linux-3.4/drivers/md/dm.c
===================================================================
--- linux-3.4.orig/drivers/md/dm.c	2012-05-24 11:12:52.000000000 +0900
+++ linux-3.4/drivers/md/dm.c	2012-05-24 11:24:06.325803254 +0900
@@ -701,6 +701,7 @@
 	struct bio *bio = info->orig;
 	unsigned int nr_bytes = info->orig->bi_size;
 
+	free_bio_info(info);
 	bio_put(clone);
 
 	if (tio->error)
@@ -763,11 +764,12 @@
 	dm_put(md);
 }
 
+static void dm_rq_bio_destructor(struct bio *bio);
 static void free_rq_clone(struct request *clone)
 {
 	struct dm_rq_target_io *tio = clone->end_io_data;
 
-	blk_rq_unprep_clone(clone);
+	blk_rq_unprep_clone(clone, dm_rq_bio_destructor);
 	free_rq_tio(tio);
 }
 
@@ -1461,10 +1463,8 @@
 static void dm_rq_bio_destructor(struct bio *bio)
 {
 	struct dm_rq_clone_bio_info *info = bio->bi_private;
-	struct mapped_device *md = info->tio->md;
 
 	free_bio_info(info);
-	bio_free(bio, md->bs);
 }
 
 static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
@@ -1481,7 +1481,6 @@
 	info->tio = tio;
 	bio->bi_end_io = end_clone_bio;
 	bio->bi_private = info;
-	bio->bi_destructor = dm_rq_bio_destructor;
 
 	return 0;
 }
@@ -1492,7 +1491,7 @@
 	int r;
 
 	r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_ATOMIC,
-			      dm_rq_bio_constructor, tio);
+			      dm_rq_bio_constructor, dm_rq_bio_destructor, tio);
 	if (r)
 		return r;
 
Index: linux-3.4/include/linux/blkdev.h
===================================================================
--- linux-3.4.orig/include/linux/blkdev.h	2012-05-21 07:29:13.000000000 +0900
+++ linux-3.4/include/linux/blkdev.h	2012-05-24 11:20:53.455808958 +0900
@@ -678,8 +678,8 @@
 extern int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 			     struct bio_set *bs, gfp_t gfp_mask,
 			     int (*bio_ctr)(struct bio *, struct bio *, void *),
-			     void *data);
-extern void blk_rq_unprep_clone(struct request *rq);
+			     void (*bio_dtr)(struct bio *), void *data);
+extern void blk_rq_unprep_clone(struct request *rq, void (*bio_dtr)(struct bio *));
 extern int blk_insert_cloned_request(struct request_queue *q,
 				     struct request *rq);
 extern void blk_delay_queue(struct request_queue *, unsigned long);
