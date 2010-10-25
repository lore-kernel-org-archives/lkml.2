Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478Ab0JYTYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 15:24:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab0JYTY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 15:24:29 -0400
Date: Mon, 25 Oct 2010 15:24:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [GIT PULL] Revert of the IO stat fix
Message-ID: <20101025192419.GB14895@redhat.com>
References: <4CC49274.3030803@fusionio.com>
 <AANLkTik4qAzZPLO8HHBCM34_NLEEdPj04RyXPfeR-wSv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik4qAzZPLO8HHBCM34_NLEEdPj04RyXPfeR-wSv@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 01:35:33PM -0700, Linus Torvalds wrote:
> On Sun, Oct 24, 2010 at 1:09 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
> >
> > The fix for cross-partition merges screwing up disk stats turns out
> > to be problematic on various levels. Lets revert this one so we have
> > time to come up with a proper solution for this.
> 
> Hmm.. I think the reverted patch looks like it really is the right
> thing to do, so I hate reverting it this early. What were the problems
> with it?
> 
> Btw, one thing that seems to be missing in the original commit (which
> is not necessarily the reason for the trouble, of course), is that
> elv_rq_merge_ok() seems to not check the partition. As far as I can
> tell, we should have a
> 
>     if (req->part != bio->bi_bdev->bd_part)
>        return 0;

Ok, not allowing requests of different partitions to merge will atleast
solve part of the problem for Yasuaki Ishimatsu. (in-flight accounting
going out of sync due to request merging across partitions).

> 
> there, no? And you should _not_ set rq->part in "drive_stat_acct()",
> you should set it from bio->bi_bdev->bd_part when you create the
> request.

Not allowing request merging across partitions, I guess should remove
the need of storing this info in request and allow us to remove req->part
as introduced by commit 7681bfeeccff5efa9eb29bf09249a3c400b15327.

> 
> (And if it is NULL, just don't do partition accounting at all)
> 
> Hmm? What am I missing? What were the bugs?

I think atleast one of the bugs was that we don't know whether request
queue pointer obtained from disk->queue is still valid or not.

Looking at the backtrace of crash reported by Maxim Levitsky here.

http://lkml.org/lkml/2010/10/23/165

mspro_block_remove() calls blk_cleanup_queue() to put its reference on the
queue and which in turn would call kmem_cache_free(blk_requestq_cachep, q)
and free up the queue.

Now driver calls mspro_block_disk_release() and which in turn ends up
accessing request queue and trying to make sure there are no inflight
requests. But request queue might be gone by now and we might end up
accessing freed object.

So one of the quick solutions probably is to set disk->queue = NULL after
del_gendisk() and before blk_cleanup_queue(). IIUC, blk_cleanup_queue()
driver's reference to the request queue and driver should in-turn cleanup
the disk->queue, atleast in theory.

Later disk_replace_part_tbl() can do

q = disk->queue;

if (q)
	quiesce_elevator;

I am not sure if it is completely race free or not from the other call
path of disk_expand_part_tbl(). What kind of locking is there to make
sure once disk->queue is fetched, some other cpu does not do
blk_cleanup_queue().

Thanks
Vivek 
