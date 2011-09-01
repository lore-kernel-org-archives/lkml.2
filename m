Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab1IABoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 21:44:06 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57287 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756942Ab1IABoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 21:44:04 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] block: introduce __bio_endio()
References: <1314589660-2918-1-git-send-email-namhyung@gmail.com>
	<1314589660-2918-3-git-send-email-namhyung@gmail.com>
	<4E5D36C7.5020706@kernel.dk>
Date: Thu, 01 Sep 2011 10:43:53 +0900
In-Reply-To: <4E5D36C7.5020706@kernel.dk> (Jens Axboe's message of "Tue, 30
	Aug 2011 13:15:19 -0600")
Message-ID: <87vctdvxye.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 2011-08-28 21:47, Namhyung Kim wrote:
>> Currently, bio_endio() lacks its completion tracepoint in it,
>> so that the bio-based devices - except DM which inserted the
>> tracepoint explicitly - cannot send us such an event when using
>> blktrace. Adding the tracepoint in the function will fix this.
>> 
>> However, bio_endio() is also used for other ways like some
>> nested bio-handling path and request-based devices. Simply
>> adding will result in duplicated event for those cases. Thus
>> add new __bio_endio() function to do things as before but no
>> tracepoint. Similarly, __bio_io_error() helper was added too.
>
> Not crazy about this solution, it seems a little fragile. And it's hard
> to know what the difference between bio_endio() and __bio_endio() is
> without looking at the code.
>
> I think it would be cleaner to mark a bio as going inflight, so that we
> can check this flag on completion. If it's never been in flight, don't
> trigger a completion event trace for it.

OK. Sounds reasonable.

So, how about this:


diff --git a/block/blk-core.c b/block/blk-core.c
index 90e1ffdeb415..b70c086dc7c0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -164,6 +164,9 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 	if (unlikely(rq->cmd_flags & REQ_QUIET))
 		set_bit(BIO_QUIET, &bio->bi_flags);
 
+	/* completion event was already reported in blk_update_request */
+	clear_bit(BIO_IN_FLIGHT, &bio->bi_flags);
+
 	bio->bi_size -= nbytes;
 	bio->bi_sector += (nbytes >> 9);
 
@@ -1545,6 +1548,8 @@ static inline void __generic_make_request(struct bio *bio)
 
 		trace_block_bio_queue(q, bio);
 
+		set_bit(BIO_IN_FLIGHT, &bio->bi_flags);
+
 		ret = q->make_request_fn(q, bio);
 	} while (ret);
 
diff --git a/fs/bio.c b/fs/bio.c
index 9bfade8a609b..0176ca4935c1 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1447,6 +1447,15 @@ void bio_endio(struct bio *bio, int error)
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
+	if (test_bit(BIO_IN_FLIGHT, &bio->bi_flags)) {
+		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+
+		trace_block_bio_complete(q, bio, error);
+
+		/* prevent duplicated completion event report */
+		clear_bit(BIO_IN_FLIGHT, &bio->bi_flags);
+	}
+
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, error);
 }
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 32f0076e844b..daa81a7d1522 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -98,6 +98,7 @@ struct bio {
 #define BIO_FS_INTEGRITY 10	/* fs owns integrity data, not block layer */
 #define BIO_QUIET	11	/* Make BIO Quiet */
 #define BIO_MAPPED_INTEGRITY 12/* integrity metadata has been remapped */
+#define BIO_IN_FLIGHT	13	/* report I/O completion event */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
