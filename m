Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab0EROh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 10:37:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105Ab0EROhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 10:37:25 -0400
Date: Tue, 18 May 2010 09:46:41 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Alasdair Kergon <agk@redhat.com>
Subject: Re: [RFC PATCH 2/2] dm: only initialize full request_queue for
 request-based device
Message-ID: <20100518134639.GA27582@redhat.com>
References: <1273532139-23043-2-git-send-email-snitzer@redhat.com>
 <4BE8DBB0.5060701@ct.jp.nec.com>
 <20100511131502.GA25211@redhat.com>
 <4BEA659F.9050206@ct.jp.nec.com>
 <20100513035750.GA25523@redhat.com>
 <4BED049C.5040409@ct.jp.nec.com>
 <20100514140852.GA10373@redhat.com>
 <4BF10BF1.3040108@ct.jp.nec.com>
 <20100517172737.GA24591@redhat.com>
 <4BF25091.3000507@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF25091.3000507@ct.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18 2010 at  4:32am -0400,
Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:

> Hi Mike,
> 
> On 05/18/2010 02:27 AM +0900, Mike Snitzer wrote:
> > Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> >> As far as I understand, the current model of device-mapper is:
> >>   - a table (precisely, a target) has various attributes,
> >>     bio-based/request-based is one of such attributes
> >>   - a table and its attributes are bound to the block device on resume
> >> If we want to fix a problem, I think we should either work based on
> >> this model or change the model.
> >>
> >> Your patch makes that loading table affects the block device, so you
> >> are changing the model.
> >>
> >> If you change the model, it should be done carefully.
> >> For example, the current model allows most of the table loading code
> >> to run without exclusive lock on the device because it doesn't affect
> >> the device itself.  If you change this model, table loading needs to
> >> be serialized with appropriate locking.
> > 
> > Nice catch, yes md->queue needs protection (see patch below).
> 
> Not enough. (See drivers/md/dm-ioctl.c:table_load().)
> Table load sequence is:
>   1. populate table
>   2. set the table to ->new_map of the hash_cell for the mapped_device
>      in protection by _hash_lock.
> 
> Since your fix only serializes the step 1, concurrent table loading
> could end up with inconsistent status; e.g. request-based table is
> bound to the mapped_device while the queue is initialized as bio-based.
> With your new model, those 2 steps above must be atomic.

Ah, yes.. I looked at the possibility of serializing the entirety of
table_load but determined that would be too excessive (would reduce
parallelism of table_load).  But I clearly missed the fact that there
could be a race to the _hash_lock protected critical section in
table_load() -- leading to queue inconsistency.

I'll post v5 of the overall patch which will revert the mapped_device
'queue_lock' serialization that I proposed in v4.  v5 will contain
the following patch to localize all table load related queue
manipulation to the _hash_lock protected critical section in
table_load().  So it sets the queue up _after_ the table's type is
established with dm_table_set_type().

Thanks again for your review; I'll work to be more meticulous in the
future!

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index d7500e1..bfb283c 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1180,6 +1180,14 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 		goto out;
 	}
 
+	r = dm_table_setup_md_queue(t);
+	if (r) {
+		DMWARN("unable to setup device queue for this table");
+		dm_table_destroy(t);
+		up_write(&_hash_lock);
+		goto out;
+	}
+
 	if (hc->new_map)
 		dm_table_destroy(hc->new_map);
 	hc->new_map = t;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index dec8295..990cf17 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -803,7 +803,6 @@ int dm_table_set_type(struct dm_table *t)
 	if (bio_based) {
 		/* We must use this table as bio-based */
 		t->type = DM_TYPE_BIO_BASED;
-		dm_clear_request_based_queue(t->md);
 		return 0;
 	}
 
@@ -830,11 +829,6 @@ int dm_table_set_type(struct dm_table *t)
 		return -EINVAL;
 	}
 
-	if (!dm_init_request_based_queue(t->md)) {
-		DMWARN("Cannot initialize queue for Request-based dm");
-		return -EINVAL;
-	}
-
 	t->type = DM_TYPE_REQUEST_BASED;
 
 	return 0;
@@ -850,6 +844,23 @@ bool dm_table_request_based(struct dm_table *t)
 	return dm_table_get_type(t) == DM_TYPE_REQUEST_BASED;
 }
 
+/*
+ * Setup the DM device's queue based on table's type.
+ * Caller must serialize access to table's md.
+ */
+int dm_table_setup_md_queue(struct dm_table *t)
+{
+	if (dm_table_request_based(t)) {
+		if (!dm_init_request_based_queue(t->md)) {
+			DMWARN("Cannot initialize queue for Request-based dm");
+			return -EINVAL;
+		}
+	} else
+		dm_clear_request_based_queue(t->md);
+
+	return 0;
+}
+
 int dm_table_alloc_md_mempools(struct dm_table *t)
 {
 	unsigned type = dm_table_get_type(t);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 143082c..76b61ca 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1856,6 +1856,17 @@ static void dm_rq_barrier_work(struct work_struct *work);
 
 static void dm_init_md_queue(struct mapped_device *md)
 {
+	/*
+	 * Request-based dm devices cannot be stacked on top of bio-based dm
+	 * devices.  The type of this dm device has not been decided yet.
+	 * The type is decided at the first table loading time.
+	 * To prevent problematic device stacking, clear the queue flag
+	 * for request stacking support until then.
+	 *
+	 * This queue is new, so no concurrency on the queue_flags.
+	 */
+	queue_flag_clear_unlocked(QUEUE_FLAG_STACKABLE, md->queue);
+
 	md->queue->queuedata = md;
 	md->queue->backing_dev_info.congested_fn = dm_any_congested;
 	md->queue->backing_dev_info.congested_data = md;
@@ -1989,17 +2000,6 @@ int dm_init_request_based_queue(struct mapped_device *md)
 
 	elv_register_queue(md->queue);
 
-	/*
-	 * Request-based dm devices cannot be stacked on top of bio-based dm
-	 * devices.  The type of this dm device has not been decided yet.
-	 * The type is decided at the first table loading time.
-	 * To prevent problematic device stacking, clear the queue flag
-	 * for request stacking support until then.
-	 *
-	 * This queue is new, so no concurrency on the queue_flags.
-	 */
-	queue_flag_clear_unlocked(QUEUE_FLAG_STACKABLE, md->queue);
-
 	blk_queue_softirq_done(md->queue, dm_softirq_done);
 	blk_queue_prep_rq(md->queue, dm_prep_fn);
 	blk_queue_lld_busy(md->queue, dm_lld_busy);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 95aec64..b4ebb11 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -65,6 +65,7 @@ bool dm_table_request_based(struct dm_table *t);
 int dm_table_alloc_md_mempools(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
+int dm_table_setup_md_queue(struct dm_table *t);
 
 /*
  * To check the return value from dm_table_find_target().
