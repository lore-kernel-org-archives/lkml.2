Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab1ANVAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 16:00:22 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50558 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab1ANVAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 16:00:20 -0500
Date: Fri, 14 Jan 2011 13:00:17 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Shaohua Li <shli@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
        Neil Brown <neilb@suse.de>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
        Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org,
        Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v7.1] block: Coordinate flush requests
Message-ID: <20110114210017.GE27381@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20110113025646.GB27381@tux1.beaverton.ibm.com> <AANLkTi=hF8hwgtx+N-dBNRjoffX7nQmaehkE3PsFpSDq@mail.gmail.com> <20110113074603.GC27381@tux1.beaverton.ibm.com> <AANLkTi=pkM1-91cKULt=5L=cPpTUcR5qqFrbj7Bjtk36@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=pkM1-91cKULt=5L=cPpTUcR5qqFrbj7Bjtk36@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 09:00:22AM +0800, Shaohua Li wrote:
> 2011/1/13 Darrick J. Wong <djwong@us.ibm.com>:
> > On Thu, Jan 13, 2011 at 01:38:55PM +0800, Shaohua Li wrote:
> >> 2011/1/13 Darrick J. Wong <djwong@us.ibm.com>:
> >> > On certain types of storage hardware, flushing the write cache takes a
> >> > considerable amount of time.  Typically, these are simple storage systems with
> >> > write cache enabled and no battery to save that cache during a power failure.
> >> > When we encounter a system with many I/O threads that try to flush the cache,
> >> > performance is suboptimal because each of those threads issues its own flush
> >> > command to the drive instead of trying to coordinate the flushes, thereby
> >> > wasting execution time.
> >> >
> >> > Instead of each thread initiating its own flush, we now try to detect the
> >> > situation where multiple threads are issuing flush requests.  The first thread
> >> > to enter blkdev_issue_flush becomes the owner of the flush, and all threads
> >> > that enter blkdev_issue_flush before the flush finishes are queued up to wait
> >> > for the next flush.  When that first flush finishes, one of those sleeping
> >> > threads is woken up to perform the next flush and then wake up the other
> >> > threads which are asleep waiting for the second flush to finish.
> >> >
> >> > In the single-threaded case, the thread will simply issue the flush and exit.
> >> >
> >> > To test the performance of this latest patch, I created a spreadsheet
> >> > reflecting the performance numbers I obtained with the same ffsb fsync-happy
> >> > workload that I've been running all along:  http://tinyurl.com/6xqk5bs
> >> >
> >> > The second tab of the workbook provides easy comparisons of the performance
> >> > before and after adding flush coordination to the block layer.  Variations in
> >> > the runs were never more than about 5%, so the slight performance increases and
> >> > decreases are negligible.  It is expected that devices with low flush times
> >> > should not show much change, whether the low flush times are due to the lack of
> >> > write cache or the controller having a battery and thereby ignoring the flush
> >> > command.
> >> >
> >> > Notice that the elm3b231_ipr, elm3b231_bigfc, elm3b57, elm3c44_ssd,
> >> > elm3c44_sata_wc, and elm3c71_scsi profiles showed large performance increases
> >> > from flush coordination.  These 6 configurations all feature large write caches
> >> > without battery backups, and fairly high (or at least non-zero) average flush
> >> > times, as was discovered when I studied the v6 patch.
> >> >
> >> > Unfortunately, there is one very odd regression: elm3c44_sas.  This profile is
> >> > a couple of battery-backed RAID cabinets striped together with raid0 on md.  I
> >> > suspect that there is some sort of problematic interaction with md, because
> >> > running ffsb on the individual hardware arrays produces numbers similar to
> >> > elm3c71_extsas.  elm3c71_extsas uses the same type of hardware array as does
> >> > elm3c44_sas, in fact.
> >> >
> >> > FYI, the flush coordination patch shows performance improvements both with and
> >> > without Christoph's patch that issues pure flushes directly.  The spreadsheet
> >> > only captures the performance numbers collected without Christoph's patch.
> >> Hi,
> >> can you explain why there is improvement with your patch? If there are
> >> multiple flush, blk_do_flush already has queue for them (the
> >> ->pending_flushes list).
> >
> > With the current code, if we have n threads trying to issue flushes, the block
> > layer will issue n flushes one after the other.  I think the point of
> > Christoph's pure-flush patch is to skip the serialization step and allow
> > issuing of the n pure flushes in parallel.  The point of this patch is optimize
> > even more aggressively, such that as soon as the system becomes free to process
> > a pure flush (at time t), all the requests for a pure flush that were created
> > since the last time a pure flush was actually issued can be covered with a
> > single flush issued at time t.  In other words, this patch tries to reduce the
> > number of pure flushes issued.
> Thanks, but why just doing merge for pure flush? we can merge normal
> flush requests
> with a pure flush request too.
> 
> +               complete_all(&new_flush->ready);
> +               spin_unlock(&disk->flush_flag_lock);
> 
> -       bio_put(bio);
> +               complete_all(&flush->finish);
> this seems can't guarantee the second waiter runs after the first
> waiter, am I missing anything?

The first complete_all wakes up the thread that starts the next flush.  The
second complete_all wakes up the threads that were waiting to hear the results
of the flush issued by the current thread.  The second set of wakeups can
happen in parallel with that first wakeup since they're tied to different flush
contexts.

Maybe a simpler way to express that is that first waiter is the thread that is
woken up by the first complete_all.  That first waiter then executes the flush
and then executes the second complete_all, thereby waking up the second waiter.
That's how the second waiter only runs after the first waiter has finished the
flush.  After the point where either waiter can be running, the only tasks left
to do are to collect the flush return code and to clean up, and that part can
happen in any order.

> it appears we can easily implement this in blk_do_flush, I had
> something at my hand too, passed test but no data yet.

> Task1: ...FS.....C
> Task2: ....F......S...C
> Task3: ......F.........S..C
> F means a flush is queued, S means a flush is dispatched, C means the flush
> is completed. In above, when Task2's flush is completed, we actually can
> make Task3 flush complete, as Task2's flush is dispatched after Task3's flush
> is queued. With the same reason, we can't merge Task2 and Task3's flush with
> Task1's.

Conceptually this seems to make sense.  I gave your patch a spin with
fsync-happy ffsb.  It ran ok for about 15 minutes but then the machine locked
hard when I ran mkfs on a different device.  I'll try to reproduce it and
capture the machine state, and when I do I'll report back.

--D
> ---
>  block/blk-core.c       |    1 +
>  block/blk-flush.c      |   24 ++++++++++++++++++++++++
>  include/linux/blkdev.h |    2 ++
>  3 files changed, 27 insertions(+)
> 
> Index: linux/block/blk-core.c
> ===================================================================
> --- linux.orig/block/blk-core.c	2011-01-13 21:02:24.000000000 +0800
> +++ linux/block/blk-core.c	2011-01-13 21:43:03.000000000 +0800
> @@ -128,6 +128,7 @@ void blk_rq_init(struct request_queue *q
>  	rq->ref_count = 1;
>  	rq->start_time = jiffies;
>  	set_start_time_ns(rq);
> +	rq->next_batched_flush = NULL;
>  }
>  EXPORT_SYMBOL(blk_rq_init);
>  
> Index: linux/block/blk-flush.c
> ===================================================================
> --- linux.orig/block/blk-flush.c	2011-01-13 21:02:24.000000000 +0800
> +++ linux/block/blk-flush.c	2011-01-14 08:22:56.000000000 +0800
> @@ -42,8 +42,18 @@ static struct request *blk_flush_complet
>  		/* not complete yet, queue the next flush sequence */
>  		next_rq = queue_next_fseq(q);
>  	} else {
> +		struct request *tmp_rq = q->orig_flush_rq->next_batched_flush;
> +		struct request *tmp_rq2;
> +		sector_t error_sector = q->orig_flush_rq->bio->bi_sector;
> +
>  		/* complete this flush request */
>  		__blk_end_request_all(q->orig_flush_rq, q->flush_err);
> +		while (tmp_rq) {
> +			tmp_rq2 = tmp_rq->next_batched_flush;
> +			tmp_rq->bio->bi_sector = error_sector;
> +			__blk_end_request_all(tmp_rq, q->flush_err);
> +			tmp_rq = tmp_rq2;
> +		}
>  		q->orig_flush_rq = NULL;
>  		q->flush_seq = 0;
>  
> @@ -164,6 +174,20 @@ struct request *blk_do_flush(struct requ
>  	 * processing.
>  	 */
>  	if (q->flush_seq) {
> +		struct request *tmp_rq;
> +
> +		if ((rq->cmd_flags & REQ_FUA) || blk_rq_sectors(rq))
> +			goto add_list;
> +		list_for_each_entry(tmp_rq, &q->pending_flushes, queuelist) {
> +			if (tmp_rq->cmd_flags & REQ_FLUSH) {
> +				rq->next_batched_flush =
> +					tmp_rq->next_batched_flush;
> +				tmp_rq->next_batched_flush = rq;
> +				list_del_init(&rq->queuelist);
> +				return NULL;
> +			}
> +		}
> +add_list:
>  		list_move_tail(&rq->queuelist, &q->pending_flushes);
>  		return NULL;
>  	}
> Index: linux/include/linux/blkdev.h
> ===================================================================
> --- linux.orig/include/linux/blkdev.h	2011-01-13 21:02:24.000000000 +0800
> +++ linux/include/linux/blkdev.h	2011-01-13 21:43:03.000000000 +0800
> @@ -163,6 +163,8 @@ struct request {
>  
>  	/* for bidi */
>  	struct request *next_rq;
> +
> +	struct request *next_batched_flush;
>  };
>  
>  static inline unsigned short req_get_ioprio(struct request *req)

