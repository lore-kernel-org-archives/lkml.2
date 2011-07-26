Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab1GZK45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 06:56:57 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41951 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab1GZK4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 06:56:52 -0400
Date: Tue, 26 Jul 2011 13:56:03 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Roland Dreier <roland@purestorage.com>
Subject: Re: Preempt & smp_processor_id in __make_request
Message-ID: <20110726105603.GA3298@swordfish.minsk.epam.com>
References: <1311672726.2700.5.camel@menhir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311672726.2700.5.camel@menhir>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (07/26/11 10:32), Steven Whitehouse wrote:
> Jul 26 09:54:04 chywoon kernel: BUG: using smp_processor_id() in preemptible [00
> 000000] code: jbd2/dm-0-8/1546
> Jul 26 09:54:04 chywoon kernel: caller is __make_request+0x209/0x350
> Jul 26 09:54:04 chywoon kernel: Pid: 1546, comm: jbd2/dm-0-8 Tainted: G        W
>    3.0.0+ #252
> Jul 26 09:54:04 chywoon kernel: Call Trace:
> Jul 26 09:54:04 chywoon kernel: [<ffffffff813db897>] debug_smp_processor_id+0xe7
> /0x100
> Jul 26 09:54:04 chywoon kernel: [<ffffffff813b6f29>] __make_request+0x209/0x350
> Jul 26 09:54:04 chywoon kernel: [<ffffffff8154635e>] ? dm_request+0x2e/0x280
> Jul 26 09:54:04 chywoon kernel: [<ffffffff813b3ffb>] generic_make_request+0x27b/
> 0x550
> Jul 26 09:54:04 chywoon kernel: [<ffffffff8123ef7e>] ? jbd2_journal_file_buffer+
> 0x8e/0x130
> Jul 26 09:54:04 chywoon kernel: [<ffffffff813b432f>] submit_bio+0x5f/0xd0
> Jul 26 09:54:04 chywoon kernel: [<ffffffff811b14a6>] submit_bh+0xe6/0x120
> etc.
> 
> The (trivial) fix appears to be the following:
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index f8cb099..f925581 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1283,7 +1283,7 @@ get_rq:
>  
>  	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) ||
>  	    bio_flagged(bio, BIO_CPU_AFFINE))
> -		req->cpu = smp_processor_id();
> +		req->cpu = raw_smp_processor_id();
>  
>  	plug = current->plug;
>  	if (plug) {
> 
> However this fixes the symptoms, rather than the cause, so I'm not at
> all sure that this is the correct solution,
> 

Or we can switch back to get_cpu()/put_cpu() pair as it's been prior to
commit 5757a6d76cdf6dda2a492c09b985c015e86779b1
Author: Dan Williams <dan.j.williams@intel.com>

    block: strict rq_affinity
    
    Some systems benefit from completions always being steered to the strict
    requester cpu rather than the looser "per-socket" steering that
    blk_cpu_to_group() attempts by default. This is because the first
    CPU in the group mask ends up being completely overloaded with work,
    while the others (including the original submitter) has power left
    to spare.

that changed CPU affinity logic from using blk_cpu_to_group(get_cpu()) to 
smp_processor_id():

[  573.599424] BUG: using smp_processor_id() in preemptible [00000000]
[  573.599429] caller is __make_request+0x19c/0x344
[  573.599437] Call Trace:
[  573.599443]  [<ffffffff81249a5f>] debug_smp_processor_id+0xc7/0xe0
[  573.599449]  [<ffffffff812298bc>] __make_request+0x19c/0x344
[  573.599455]  [<ffffffff81227873>] generic_make_request+0x4b8/0x60f
[  573.599462]  [<ffffffff81227aa9>] submit_bio+0xdf/0xfe
[  573.599467]  [<ffffffff811352d1>] ? bio_alloc_bioset+0x47/0xbe
[  573.599473]  [<ffffffff81130886>] submit_bh+0xda/0xf9
[  573.599480]  [<ffffffff811efcc0>] jbd2_journal_commit_transaction+0xb8f/0x1963
[  573.599486]  [<ffffffff8104cb00>] ? lock_timer_base.isra.30+0x26/0x4b
[  573.599493]  [<ffffffff8104cc9c>] ? try_to_del_timer_sync+0x177/0x177
[  573.599499]  [<ffffffff811f46b0>] kjournald2+0xce/0x215
[  573.599505]  [<ffffffff8105d91a>] ? __init_waitqueue_head+0x46/0x46
[  573.599510]  [<ffffffff811f45e2>] ? commit_timeout+0xb/0xb
[  573.599516]  [<ffffffff8105d0ce>] kthread+0x9a/0xa2
[  573.599522]  [<ffffffff81487824>] kernel_thread_helper+0x4/0x10
[  573.599528]  [<ffffffff8102d4d1>] ? finish_task_switch+0x76/0xf0
[  573.599533]  [<ffffffff814805b8>] ? retint_restore_args+0x13/0x13
[  573.599540]  [<ffffffff8105d034>] ? __init_kthread_worker+0x53/0x53
[  573.599545]  [<ffffffff81487820>] ? gs_change+0x13/0x13


Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 block/blk-core.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f8cb099..7e98677 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1282,8 +1282,10 @@ get_rq:
 	init_request_from_bio(req, bio);
 
 	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) ||
-	    bio_flagged(bio, BIO_CPU_AFFINE))
-		req->cpu = smp_processor_id();
+	    bio_flagged(bio, BIO_CPU_AFFINE)) {
+		req->cpu = get_cpu();
+		put_cpu();
+	}
 
 	plug = current->plug;
 	if (plug) {


