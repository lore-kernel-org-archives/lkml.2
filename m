Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab2LRQuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 11:50:11 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:49936 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab2LRQuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 11:50:09 -0500
MIME-Version: 1.0
In-Reply-To: <50D056A5.3040501@kernel.dk>
References: <50CF89EB.2030109@kernel.dk> <20121218092554.GA3823@gmail.com> <50D056A5.3040501@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Dec 2012 08:49:48 -0800
X-Google-Sender-Auth: -E8GhW4jDuk9AJK5HWLfBWEDeFc
Message-ID: <CA+55aFzhfknCd-JERhrDfkOhdm_eytoVBYA42ex2K+BghBaBKQ@mail.gmail.com>
Subject: Re: [boot crash] Re: [GIT PULL[ block drivers bits for 3.8
To: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>,
        Neil Brown <neilb@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 3:42 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
> Bah. Does the below fix it up for you?

Grr. This is still bullshit.

Doing this:

    alignment = sector << 9;

is fundamentally crap, because 'sector_t' may well be 32-bit
(non-large-block device case). And we're supposed (surprise surprise)
to be able to handle devices larger than 4GB in size.

So doing *any* of these calculations in bytes is pure and utter crap.
You need to do them in sectors. That's what "sector_t" means, and
that's damn well how everything should work. Anything that works in
bytes is simply pure crap. And don't talk to me about 64-bit math and
doing it in "u64" or "loff_t", that's just utterly moronic too.

Besides, "sector_div()" is only sensible when you're looking for the
remainder of a sector number. That's true in the first case (sector
really is a sector number - it's the starting sector of the
partition), but the source of alignment and granularity are actually
just "unsigned int" (and that's in bytes, not sectors), so using
sector_t afterwards is crazy too. You should have used just '%'.
Looking around, there are other places where this idiocy happens too
(blkdev_issue_discard() seems to think the granularity/alignments are
sector_t's too, for example).

Anyway, here's a patch to fix the crazy types and the bogus second
"sector_div()". It's whitespace-damaged, because not only have I not
tested it, I also think somebody needs to look at things in general.
The whole "discard_alignment" handling is extremely odd. I don't think
it should be called "alignment" at all - because it isn't. It's an
alignment *offset*. Look at the normal (non-discard) case, where it's
called "alignment_offset" like it should be.

So the math is confused, the types are confused, and the naming is
confused. Please, somebody check this out, because now *I* am
confused.

And btw, that whole commit happened too f*cking late too. When I get a
pull request, it should damn well have been tested already, and it
should have been developed *before* the merge window started. Not the
day before the pull request.

I'm grumpy, because all of this code is UTTER SH*T, and it was sent to me. Why?

                Linus

---
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index acb4f7bbbd32..c23cae25a0c0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1188,14 +1188,25 @@ static inline int
queue_discard_alignment(struct request_queue *q)

 static inline int queue_limit_discard_alignment(struct queue_limits
*lim, sector_t sector)
 {
-       sector_t alignment = sector << 9;
-       alignment = sector_div(alignment, lim->discard_granularity);
+       /* Why are these in bytes, not sectors? */
+       unsigned int alignment, granularity, offset;

        if (!lim->max_discard_sectors)
                return 0;

-       alignment = lim->discard_granularity + lim->discard_alignment
- alignment;
-       return sector_div(alignment, lim->discard_granularity);
+       alignment = lim->discard_alignment >> 9;
+       granularity = lim->discard_granularity >> 9;
+       if (!alignment || !granularity)
+               return 0;
+
+       /* Offset of the partition start in 'granularity' sectors */
+       offset = sector_div(sector, granularity);
+
+       /* And why do we do this modulus *again* in blkdev_issue_discard()? */
+       offset = (granularity + alignment - offset) % granularity;
+
+       /* Turn it back into bytes, gaah */
+       return offset << 9;
 }

 static inline int bdev_discard_alignment(struct block_device *bdev)
