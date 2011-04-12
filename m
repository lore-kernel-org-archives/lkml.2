Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1DLM6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 08:58:51 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:58293 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab1DLM6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 08:58:49 -0400
X-ASG-Debug-ID: 1302613127-01de284cf8133d70001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DA44C86.3090305@fusionio.com>
Date: Tue, 12 Apr 2011 14:58:46 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: "hch@infradead.org" <hch@infradead.org>, NeilBrown <neilb@suse.de>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <20110411212635.7959de70@notabene.brown> <4DA2E7F0.9010904@fusionio.com> <20110411220505.1028816e@notabene.brown> <4DA2F00E.6010907@fusionio.com> <20110411223623.4278fad1@notabene.brown> <4DA2F8AD.1060605@fusionio.com> <20110412011255.GA29236@infradead.org> <4DA40F0E.1070903@fusionio.com> <20110412122248.GC31057@dastard> <4DA4456F.3070301@fusionio.com> <20110412124134.GD31057@dastard>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <20110412124134.GD31057@dastard>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1302613127
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.60639
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-12 14:41, Dave Chinner wrote:
> On Tue, Apr 12, 2011 at 02:28:31PM +0200, Jens Axboe wrote:
>> On 2011-04-12 14:22, Dave Chinner wrote:
>>> On Tue, Apr 12, 2011 at 10:36:30AM +0200, Jens Axboe wrote:
>>>> On 2011-04-12 03:12, hch@infradead.org wrote:
>>>>> On Mon, Apr 11, 2011 at 02:48:45PM +0200, Jens Axboe wrote:
>>>>>> Great, once you do that and XFS kills the blk_flush_plug() calls too,
>>>>>> then we can remove that export and make it internal only.
>>>>>
>>>>> Linus pulled the tree, so they are gone now.  Btw, there's still some
>>>>> bits in the area that confuse me:
>>>>
>>>> Great!
>>>>
>>>>>  - what's the point of the queue_sync_plugs?  It has a lot of comment
>>>>>    that seem to pre-data the onstack plugging, but except for that
>>>>>    it's trivial wrapper around blk_flush_plug, with an argument
>>>>>    that is not used.
>>>>
>>>> There's really no point to it anymore. It's existance was due to the
>>>> older revision that had to track write requests for serializaing around
>>>> a barrier. I'll kill it, since we don't do that anymore.
>>>>
>>>>>  - is there a good reason for the existance of __blk_flush_plug?  You'd
>>>>>    get one additional instruction in the inlined version of
>>>>>    blk_flush_plug when opencoding, but avoid the need for chained
>>>>>    function calls.
>>>>>  - Why is having a plug in blk_flush_plug marked unlikely?  Note that
>>>>>    unlikely is the static branch prediction hint to mark the case
>>>>>    extremly unlikely and is even used for hot/cold partitioning.  But
>>>>>    when we call it we usually check beforehand if we actually have
>>>>>    plugs, so it's actually likely to happen.
>>>>
>>>> The existance and out-of-line is for the scheduler() hook. It should be
>>>> an unlikely event to schedule with a plug held, normally the plug should
>>>> have been explicitly unplugged before that happens.
>>>
>>> Though if it does, haven't you just added a significant amount of
>>> depth to the worst case stack usage? I'm seeing this sort of thing
>>> from io_schedule():
>>>
>>>         Depth    Size   Location    (40 entries)
>>>         -----    ----   --------
>>>   0)     4256      16   mempool_alloc_slab+0x15/0x20
>>>   1)     4240     144   mempool_alloc+0x63/0x160
>>>   2)     4096      16   scsi_sg_alloc+0x4c/0x60
>>>   3)     4080     112   __sg_alloc_table+0x66/0x140
>>>   4)     3968      32   scsi_init_sgtable+0x33/0x90
>>>   5)     3936      48   scsi_init_io+0x31/0xc0
>>>   6)     3888      32   scsi_setup_fs_cmnd+0x79/0xe0
>>>   7)     3856     112   sd_prep_fn+0x150/0xa90
>>>   8)     3744      48   blk_peek_request+0x6a/0x1f0
>>>   9)     3696      96   scsi_request_fn+0x60/0x510
>>>  10)     3600      32   __blk_run_queue+0x57/0x100
>>>  11)     3568      80   flush_plug_list+0x133/0x1d0
>>>  12)     3488      32   __blk_flush_plug+0x24/0x50
>>>  13)     3456      32   io_schedule+0x79/0x80
>>>
>>> (This is from a page fault on ext3 that is doing page cache
>>> readahead and blocking on a locked buffer.)
>>>
>>> I've seen traces where mempool_alloc_slab enters direct reclaim
>>> which adds another 1.5k of stack usage to this path. So I'm
>>> extremely concerned that you've just reduced the stack available to
>>> every thread by at least 2.5k of space...
>>
>> Yeah, that does not look great. If this turns out to be problematic, we
>> can turn the queue runs from the unlikely case into out-of-line from
>> kblockd.
>>
>> But this really isn't that new, you could enter the IO dispatch path
>> when doing IO already (when submitting it). So we better be able to
>> handle that.
> 
> The problem I see is that IO is submitted when there's plenty of
> stack available whould have previously been fine. However now it
> hits the plug, and then later on after the thread consumes a lot
> more stack it, say, waits for a completion. We then schedule, it
> unplugs the queue and we add the IO stack to a place where there
> isn't much space available.
>
> So effectively we are moving the places where stack is consumed
> about, and it's complete unpredictable where that stack is going to
> land now.

Isn't that example fairly contrived? If we ended up doing the IO
dispatch before, then the only difference now is the stack usage of
schedule() itself. Apart from that, as far as I can tell, there should
not be much difference.

 
>> If it's a problem from the schedule()/io_schedule() path, then
>> lets ensure that those are truly unlikely events so we can punt
>> them to kblockd.
> 
> Rather than wait for an explosion to be reported before doing this,
> why not just punt unplugs to kblockd unconditionally?

Supposedly it's faster to do it inline rather than punt the dispatch.
But that may actually not be true, if you have multiple plugs going (and
thus multiple contenders for the queue lock on dispatch). So lets play
it safe and punt to kblockd, we can always revisit this later.

diff --git a/block/blk-core.c b/block/blk-core.c
index c6eaa1f..36b1a75 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2665,7 +2665,7 @@ static int plug_rq_cmp(void *priv, struct list_head *a, struct list_head *b)
 static void queue_unplugged(struct request_queue *q, unsigned int depth)
 {
 	trace_block_unplug_io(q, depth);
-	__blk_run_queue(q, false);
+	__blk_run_queue(q, true);
 
 	if (q->unplugged_fn)
 		q->unplugged_fn(q);


-- 
Jens Axboe

