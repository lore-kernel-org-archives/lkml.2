Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab1C3LXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 07:23:03 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58663 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819Ab1C3LXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 07:23:01 -0400
Message-ID: <4D931292.8050104@kernel.dk>
Date: Wed, 30 Mar 2011 13:22:58 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] block: eliminate ELEVATOR_INSERT_REQUEUE
References: <20110326042156.GB28458@redhat.com> <20110328082321.GC16530@htj.dyndns.org> <20110328221547.GA1118@redhat.com> <x49y63yvwum.fsf@segfault.boston.devel.redhat.com> <20110329175458.GE24485@redhat.com> <20110330074123.GA17523@htj.dyndns.org> <20110330075752.GC17523@htj.dyndns.org> <4D92E2CD.6000909@kernel.dk> <20110330080203.GD17523@htj.dyndns.org> <4D9302ED.4030807@kernel.dk> <20110330112126.GA3967@swordfish.minsk.epam.com>
In-Reply-To: <20110330112126.GA3967@swordfish.minsk.epam.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-30 13:21, Sergey Senozhatsky wrote:
> Hello,
> 
> On (03/30/11 12:16), Jens Axboe wrote:
>> How does this look? It's really two patches, but rolled up into one for
>> easier posting here.
>>
> 
> Nope, doesn't work for me. fsck.ext4 crashed the system.
> 
> __elv_add_request
> blk_flush_complete_seq
> blk_insert_flush
> __elv_add_request
> __make_request
> generic_make_request
> ?bio_alloc_bioset
> blkdev_issue_flush
> blkdev_fsync
> vfs_fsync
> [..]

Ah, this addon should behave better.

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 6a16fea..eba4a27 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -261,7 +261,7 @@ static bool blk_kick_flush(struct request_queue *q)
 	q->flush_rq.end_io = flush_end_io;
 
 	q->flush_pending_idx ^= 1;
-	__elv_add_request(q, &q->flush_rq, ELEVATOR_INSERT_FLUSH);
+	list_add_tail(&q->flush_rq.queuelist, &q->queue_head);
 	return true;
 }
 

-- 
Jens Axboe

