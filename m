Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab0ICGF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 02:05:58 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:63552 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0ICGF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 02:05:56 -0400
Message-ID: <4C808FF4.4010901@ct.jp.nec.com>
Date: Fri, 03 Sep 2010 15:04:36 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: jaxboe@fusionio.com, snitzer@redhat.com, j-nomura@ce.jp.nec.com,
        jamie@shareable.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/5] dm: relax ordering of bio-based flush implementation
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-4-git-send-email-tj@kernel.org>
In-Reply-To: <1283162296-13650-4-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 08/30/2010 06:58 PM +0900, Tejun Heo wrote:
> Unlike REQ_HARDBARRIER, REQ_FLUSH/FUA doesn't mandate any ordering
> against other bio's.  This patch relaxes ordering around flushes.
...
> * When dec_pending() detects that a flush has completed, it checks
>   whether the original bio has data.  If so, the bio is queued to the
>   deferred list w/ REQ_FLUSH cleared; otherwise, it's completed.
...
> @@ -529,16 +523,10 @@ static void end_io_acct(struct dm_io *io)
>   */
>  static void queue_io(struct mapped_device *md, struct bio *bio)
>  {
> -	down_write(&md->io_lock);
> -
>  	spin_lock_irq(&md->deferred_lock);
>  	bio_list_add(&md->deferred, bio);
>  	spin_unlock_irq(&md->deferred_lock);
> -
> -	if (!test_and_set_bit(DMF_QUEUE_IO_TO_THREAD, &md->flags))
> -		queue_work(md->wq, &md->work);
> -
> -	up_write(&md->io_lock);
> +	queue_work(md->wq, &md->work);
...
> @@ -638,26 +624,22 @@ static void dec_pending(struct dm_io *io, int error)
...
> -		} else {
> -			end_io_acct(io);
> -			free_io(md, io);
> -
> -			if (io_error != DM_ENDIO_REQUEUE) {
> -				trace_block_bio_complete(md->queue, bio);
> -
> -				bio_endio(bio, io_error);
> -			}
> +			bio->bi_rw &= ~REQ_FLUSH;
> +			queue_io(md, bio);

dec_pending() is a function which is called during I/O completion
where the caller may be disabling interrupts.
So if you use queue_io() inside dec_pending(), the spin_lock must be
taken/released with irqsave/irqrestore like the patch below.

BTW, lockdep detects the issue and a warning like below is displayed.
It may break the underlying drivers.

=================================
[ INFO: inconsistent lock state ]
2.6.36-rc2+ #2
---------------------------------
inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
kworker/0:1/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
 (&(&q->__queue_lock)->rlock){?.-...}, at: [<ffffffff811be844>] blk_end_bidi_request+0x44/0x80
{IN-HARDIRQ-W} state was registered at:
  [<ffffffff81080266>] __lock_acquire+0x8c6/0xb30
  [<ffffffff81080570>] lock_acquire+0xa0/0x120
  [<ffffffff8138953e>] _raw_spin_lock_irqsave+0x4e/0x70
  [<ffffffffa00e095a>] ata_qc_schedule_eh+0x5a/0xa0 [libata]
  [<ffffffffa00d37e7>] ata_qc_complete+0x147/0x1f0 [libata]
  [<ffffffffa00e3af2>] ata_hsm_qc_complete+0xc2/0x140 [libata]
  [<ffffffffa00e3d45>] ata_sff_hsm_move+0x1d5/0x700 [libata]
  [<ffffffffa00e4323>] __ata_sff_port_intr+0xb3/0x100 [libata]
  [<ffffffffa00e4bff>] ata_bmdma_port_intr+0x3f/0x120 [libata]
  [<ffffffffa00e2735>] ata_bmdma_interrupt+0x195/0x1e0 [libata]
  [<ffffffff810a6b14>] handle_IRQ_event+0x54/0x170
  [<ffffffff810a8fb8>] handle_edge_irq+0xc8/0x170
  [<ffffffff8100561b>] handle_irq+0x4b/0xa0
  [<ffffffff8139169f>] do_IRQ+0x6f/0xf0
  [<ffffffff8138a093>] ret_from_intr+0x0/0x16
  [<ffffffff81389ca3>] _raw_spin_unlock+0x23/0x40
  [<ffffffff81133ea2>] sys_dup3+0x122/0x1a0
  [<ffffffff81133f43>] sys_dup2+0x23/0xb0
  [<ffffffff81002eb2>] system_call_fastpath+0x16/0x1b
irq event stamp: 14660913
hardirqs last  enabled at (14660912): [<ffffffff81389c65>] _raw_spin_unlock_irqrestore+0x65/0x80
hardirqs last disabled at (14660913): [<ffffffff8138951e>] _raw_spin_lock_irqsave+0x2e/0x70
softirqs last  enabled at (14660874): [<ffffffff810530ae>] __do_softirq+0x14e/0x210
softirqs last disabled at (14660879): [<ffffffff81003d9c>] call_softirq+0x1c/0x50

other info that might help us debug this:
1 lock held by kworker/0:1/0:
 #0:  (&(&q->__queue_lock)->rlock){?.-...}, at: [<ffffffff811be844>] blk_end_bidi_request+0x44/0x80

stack backtrace:
Pid: 0, comm: kworker/0:1 Not tainted 2.6.36-rc2+ #2
Call Trace:
 <IRQ>  [<ffffffff8107c386>] print_usage_bug+0x1a6/0x1f0
 [<ffffffff8107ca31>] mark_lock+0x661/0x690
 [<ffffffff8107de90>] ? check_usage_backwards+0x0/0xf0
 [<ffffffff8107cac0>] mark_held_locks+0x60/0x80
 [<ffffffff81389bf0>] ? _raw_spin_unlock_irq+0x30/0x40
 [<ffffffff8107cb63>] trace_hardirqs_on_caller+0x83/0x1a0
 [<ffffffff8107cc8d>] trace_hardirqs_on+0xd/0x10
 [<ffffffff81389bf0>] _raw_spin_unlock_irq+0x30/0x40
 [<ffffffffa0292e0e>] ? queue_io+0x2e/0x90 [dm_mod]
 [<ffffffffa0292e37>] queue_io+0x57/0x90 [dm_mod]
 [<ffffffffa02932fa>] dec_pending+0x22a/0x320 [dm_mod]
 [<ffffffffa0293125>] ? dec_pending+0x55/0x320 [dm_mod]
 [<ffffffffa029366d>] clone_endio+0xad/0xc0 [dm_mod]
 [<ffffffff81150d1d>] bio_endio+0x1d/0x40
 [<ffffffff811bd181>] req_bio_endio+0x81/0xf0
 [<ffffffff811bd42d>] blk_update_request+0x23d/0x460
 [<ffffffff811bd306>] ? blk_update_request+0x116/0x460
 [<ffffffff811bd677>] blk_update_bidi_request+0x27/0x80
 [<ffffffff811be490>] __blk_end_bidi_request+0x20/0x50
 [<ffffffff811be4df>] __blk_end_request_all+0x1f/0x40
 [<ffffffff811c3b40>] blk_flush_complete_seq+0x140/0x1a0
 [<ffffffff811c3c79>] pre_flush_end_io+0x39/0x50
 [<ffffffff811be265>] blk_finish_request+0x85/0x290
 [<ffffffff811be852>] blk_end_bidi_request+0x52/0x80
 [<ffffffff811bfa3f>] blk_end_request_all+0x1f/0x40
 [<ffffffffa02941bd>] dm_softirq_done+0xad/0x120 [dm_mod]
 [<ffffffff811c6646>] blk_done_softirq+0x86/0xa0
 [<ffffffff81053036>] __do_softirq+0xd6/0x210
 [<ffffffff81003d9c>] call_softirq+0x1c/0x50
 [<ffffffff81005705>] do_softirq+0x95/0xd0
 [<ffffffff81052f4d>] irq_exit+0x4d/0x60
 [<ffffffff813916a8>] do_IRQ+0x78/0xf0
 [<ffffffff8138a093>] ret_from_intr+0x0/0x16
 <EOI>  [<ffffffff8100b639>] ? mwait_idle+0x79/0xe0
 [<ffffffff8100b630>] ? mwait_idle+0x70/0xe0
 [<ffffffff81001c36>] cpu_idle+0x66/0xe0
 [<ffffffff81380e91>] ? start_secondary+0x181/0x1f0
 [<ffffffff81380e9f>] start_secondary+0x18f/0x1f0

Thanks,
Kiyoshi Ueda


Now queue_io() is called from dec_pending(), which may be called with
interrupts disabled.
So queue_io() must not enable interrupts unconditionally and must
save/restore the current interrupts status.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: misc/drivers/md/dm.c
===================================================================
--- misc.orig/drivers/md/dm.c
+++ misc/drivers/md/dm.c
@@ -512,9 +512,11 @@ static void end_io_acct(struct dm_io *io
  */
 static void queue_io(struct mapped_device *md, struct bio *bio)
 {
-	spin_lock_irq(&md->deferred_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&md->deferred_lock, flags);
 	bio_list_add(&md->deferred, bio);
-	spin_unlock_irq(&md->deferred_lock);
+	spin_unlock_irqrestore(&md->deferred_lock, flags);
 	queue_work(md->wq, &md->work);
 }
 
