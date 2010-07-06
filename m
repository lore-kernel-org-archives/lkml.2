Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab0GFEdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 00:33:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40869 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab0GFEdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 00:33:15 -0400
Date: Tue, 6 Jul 2010 14:33:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Subject: linux-next: manual merge of the device-mapper tree with the block
 tree
Message-Id: <20100706143313.1d4e2909.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alasdair,

Today's linux-next merge of the device-mapper tree got a conflict in
drivers/md/dm.c between commits 9add80db6089272d6bf13ef6b5dc7b3ddda1a887
("dm: stop using q->prepare_flush_fn") and
5e27e27e73b5bff903b3c30ffd5a0e17eb95c087 ("block: remove
q->prepare_flush_fn completely") from the block tree and commit
90c50ea6a71bcb1bdf1482007932cc7fb0902455
("dm-do-not-initialise-full-request-queue-when-bio-based") from the
device-mapper tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/md/dm.c
index d505a96,c49818a..0000000
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@@ -2116,6 -2165,73 +2154,72 @@@ int dm_create(int minor, struct mapped_
  	return 0;
  }
  
+ /*
+  * Functions to manage md->type.
+  * All are required to hold md->type_lock.
+  */
+ void dm_lock_md_type(struct mapped_device *md)
+ {
+ 	mutex_lock(&md->type_lock);
+ }
+ 
+ void dm_unlock_md_type(struct mapped_device *md)
+ {
+ 	mutex_unlock(&md->type_lock);
+ }
+ 
+ void dm_set_md_type(struct mapped_device *md, unsigned type)
+ {
+ 	md->type = type;
+ }
+ 
+ unsigned dm_get_md_type(struct mapped_device *md)
+ {
+ 	return md->type;
+ }
+ 
+ /*
+  * Fully initialize a request-based queue (->elevator, ->request_fn, etc).
+  */
+ static int dm_init_request_based_queue(struct mapped_device *md)
+ {
+ 	struct request_queue *q = NULL;
+ 
+ 	if (md->queue->elevator)
+ 		return 1;
+ 
+ 	/* Fully initialize the queue */
+ 	q = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
+ 	if (!q)
+ 		return 0;
+ 
+ 	md->queue = q;
+ 	md->saved_make_request_fn = md->queue->make_request_fn;
+ 	dm_init_md_queue(md);
+ 	blk_queue_softirq_done(md->queue, dm_softirq_done);
+ 	blk_queue_prep_rq(md->queue, dm_prep_fn);
+ 	blk_queue_lld_busy(md->queue, dm_lld_busy);
 -	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH,
 -			  dm_rq_prepare_flush);
++	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH);
+ 
+ 	elv_register_queue(md->queue);
+ 
+ 	return 1;
+ }
+ 
+ /*
+  * Setup the DM device's queue based on md's type
+  */
+ int dm_setup_md_queue(struct mapped_device *md)
+ {
+ 	if ((dm_get_md_type(md) == DM_TYPE_REQUEST_BASED) &&
+ 	    !dm_init_request_based_queue(md)) {
+ 		DMWARN("Cannot initialize queue for request-based mapped device");
+ 		return -EINVAL;
+ 	}
+ 
+ 	return 0;
+ }
+ 
  static struct mapped_device *dm_find_md(dev_t dev)
  {
  	struct mapped_device *md;
