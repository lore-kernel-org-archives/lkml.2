Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab1IMKoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:44:13 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:19495 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab1IMKoM convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:5:1>);
	Tue, 13 Sep 2011 06:44:12 -0400
Message-Id: <4E6F50170200007800055CF5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 13 Sep 2011 11:44:07 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, <hch@infradead.org>,
        "Jan Kara" <jack@suse.cz>, <linux-kernel@vger.kernel.org>
Subject: Re: Help with implementing some form of barriers in 3.0
	 kernels.
References: <20110907174832.GN32190@dumpdata.com>
In-Reply-To: <20110907174832.GN32190@dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.09.11 at 19:48, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> Hey Christoph,
> 
> I was wondering what you think is the proper way of implementing a
> backend to support the 'barrier' type requests? We have this issue were
> there are 2.6.36 type guests that still use barriers and we would like
> to support them properly. But in 3.0 there are no barriers - hence
> the question whether WRITE_fLUSH_FUA would be equal to WRITE_BARRIER?
> 
> Or is there some other things that we should take in consideration?
> 
> Thanks!

Below is what Jan Kara came up with for addressing this - what do
you think?

Jan

From: Jan Kara <jack@suse.cz>
Date: Sun, 11 Sep 2011 14:39:18 +0200
Subject: [PATCH] xen: Add support for old BARRIER requests to xenblk driver

Recent kernels do not support BARRIER operation but only FLUSH operation. But
older xenblk frontends still use the BARRIER operation to achieve data
integrity requirements. So add support for BARRIER operation into xenblk
backend so that all guests do not corrupt their filesystem on host crash.

Signed-off-by: Jan Kara <jack@suse.cz>

--- a/block/elevator.c
+++ b/block/elevator.c
@@ -619,6 +619,7 @@ void elv_drain_elevator(struct request_q
 		       q->elevator->elevator_type->elevator_name, q->nr_sorted);
 	}
 }
+EXPORT_SYMBOL(elv_drain_elevator);
 
 /*
  * Call with queue lock held, interrupts disabled
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -530,6 +530,7 @@ static int dispatch_rw_block_io(struct x
 	struct bio *biolist[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	int i, nbio = 0;
 	int operation;
+	bool drain = false;
 	struct blk_plug plug;
 
 	switch (req->operation) {
@@ -541,11 +542,12 @@ static int dispatch_rw_block_io(struct x
 		blkif->st_wr_req++;
 		operation = WRITE_ODIRECT;
 		break;
+	case BLKIF_OP_WRITE_BARRIER:
+		drain = true;
 	case BLKIF_OP_FLUSH_DISKCACHE:
 		blkif->st_f_req++;
 		operation = WRITE_FLUSH;
 		break;
-	case BLKIF_OP_WRITE_BARRIER:
 	default:
 		operation = 0; /* make gcc happy */
 		goto fail_response;
@@ -603,6 +605,17 @@ static int dispatch_rw_block_io(struct x
 		}
 	}
 
+	if (drain) {
+		struct request_queue *q = bdev_get_queue(preq.bdev);
+		unsigned long flags;
+
+		/* Emulate the original behavior of write barriers */
+		spin_lock_irqsave(q->queue_lock, flags);
+		elv_drain_elevator(q);
+		__blk_run_queue(q);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+	}
+
 	/*
 	 * If we have failed at this point, we need to undo the M2P override,
 	 * set gnttab_set_unmap_op on all of the grant references and perform



