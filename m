Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab1AEPKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 10:10:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab1AEPKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 10:10:45 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jens Axboe <jens.axboe@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Alan.Brunelle@hp.com
Subject: Re: [RFC patch 1/5] trace event block fix unassigned field
References: <20110104231629.996422888@efficios.com>
	<20110104232419.097998611@efficios.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 05 Jan 2011 10:09:20 -0500
In-Reply-To: <20110104232419.097998611@efficios.com> (Mathieu Desnoyers's
	message of "Tue, 04 Jan 2011 18:16:30 -0500")
Message-ID: <x498vyzqten.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:

> The "error" field in block_bio_complete is not assigned, leaving the memory area
> uninitialized (keeping garbage data). Initialize it to 0.
>
> We should eventually remove this field when we find out if blktrace can live
> without it.

Well, I'm fairly sure blkparse has the ability to print this field out,
so we should probably just fill it in properly.  Something like the
following untested patch should do.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7cb1352..f4d83f2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -630,7 +630,7 @@ static void dec_pending(struct dm_io *io, int error)
 			queue_io(md, bio);
 		} else {
 			/* done with normal IO or empty flush */
-			trace_block_bio_complete(md->queue, bio);
+			trace_block_bio_complete(md->queue, bio, io_error);
 			bio_endio(bio, io_error);
 		}
 	}
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index d8ce278..8990a62 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -212,7 +212,7 @@ TRACE_EVENT(block_bio_bounce,
  */
 TRACE_EVENT(block_bio_complete,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio),
+	TP_PROTO(struct request_queue *q, struct bio *bio, int error),
 
 	TP_ARGS(q, bio),
 
@@ -228,6 +228,7 @@ TRACE_EVENT(block_bio_complete,
 		__entry->dev		= bio->bi_bdev->bd_dev;
 		__entry->sector		= bio->bi_sector;
 		__entry->nr_sector	= bio->bi_size >> 9;
+		__entry->error		= error;
 		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
 	),
 

