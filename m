Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab1EWSup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:50:45 -0400
Received: from mail.avalus.com ([89.16.176.221]:46588 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556Ab1EWSun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:50:43 -0400
Date: Mon, 23 May 2011 19:50:39 +0100
From: Alex Bligh <alex@alex.org.uk>
Reply-To: Alex Bligh <alex@alex.org.uk>
To: Christoph Hellwig <hch@infradead.org>
cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>, Alex Bligh <alex@alex.org.uk>
Subject: Re: BUG: Failure to send REQ_FLUSH on unmount on ext3, ext4, and FS
 in general
Message-ID: <83DC08645AEEDEA52709C5C3@Ximines.local>
In-Reply-To: <20110523175204.GA21110@infradead.org>
References: <959E4E25EAEC544D31199E6F@nimrod.local>
 <20110523155550.GE4716@quack.suse.cz>
 <EC63F9E077B362A0FDCF3527@Ximines.local>
 <20110523172906.GH4716@quack.suse.cz>
 <16968FD306209AF92D4660B9@Ximines.local>
 <20110523175204.GA21110@infradead.org>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

--On 23 May 2011 13:52:04 -0400 Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, May 23, 2011 at 06:39:23PM +0100, Alex Bligh wrote:
>> I'm presuming that if just umount() were altered to do a REQ_FLUSH,
>> the potential presence of 2 sync()s would not be too offensive, as
>> unmount isn't exactly time critical, and as Christoph pointed out in
>> the other thread, a REQ_FLUSH when the write cache has recently been
>> emptied isn't going to take long.
>
> Umount actually is the only place where adding it generically makes
> sense.  It's not time-critical, and with kill_block_super we actually
> have a block specific place to put it, instead of having to hack
> it into the generic VFS, which is something we've been trying to avoid.

You mean like this (completely untested)?

diff --git a/fs/super.c b/fs/super.c
index 8a06881..a86201a 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -852,6 +852,7 @@ void kill_block_super(struct super_block *sb)
        bdev->bd_super = NULL;
        generic_shutdown_super(sb);
        sync_blockdev(bdev);
+       blkdev_issue_flush(bdev, GFP_KERNEL, NULL);
        WARN_ON_ONCE(!(mode & FMODE_EXCL));
        blkdev_put(bdev, mode | FMODE_EXCL);
 }


One thing I am puzzled by is that blkdev_fsync unconditionally
calls blkdev_issue_flush, but no amount of fsync(), sync() or
whatever generates any REQ_FLUSH traffic. The only explanation
I can guess at for that is that blkdev_issue_flush is a NOOP
if the driver doesn't have a make_request_function:

        /*
         * some block devices may not have their queue correctly set up here
         * (e.g. loop device without a backing file) and so issuing a flush
         * here will panic. Ensure there is a request function before 
issuing
         * the flush.
         */
        if (!q->make_request_fn)
                return -ENXIO;

According to Documentation/block/writeback_cache_control.txt, drivers
with a request_fn are still meant to get REQ_FLUSH etc. provided
they have done:

   blk_queue_flush(sdkp->disk->queue, REQ_FLUSH);

So should that read (again untested) as follows:

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 6c9b5e1..3a6d4bd 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -408,7 +408,8 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t 
gfp_mask,
         * here will panic. Ensure there is a request function before 
issuing
         * the flush.
         */
-       if (!q->make_request_fn)
+       if (!q->make_request_fn &&
+           !(q->request_fn && (q->flush_flags & REQ_FLUSH)))
                return -ENXIO;

        bio = bio_alloc(gfp_mask, 0);


>> Ah, fsdevel not here. OK. Partly I'd like to understand whether
>> sync() not flushing write caches on barrier-less file systems
>> is a good thing or a bad thing. I know barriers are better, but if
>> writing to (e.g.) FAT32, I'm betting there is little prospect of
>> barrier support.
>
> "Barrier" support it's gone.  It's really just the FUA and FLUSH
> flags these days.

Sorry - slack terminology on my part.

-- 
Alex Bligh
