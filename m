Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab1FIS1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 14:27:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab1FIS1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 14:27:11 -0400
Date: Thu, 9 Jun 2011 14:27:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: CFQ: async queue blocks the whole system
Message-ID: <20110609182706.GG29913@redhat.com>
References: <1307616577-6101-1-git-send-email-tm@tao.ma>
 <20110609141451.GD29913@redhat.com>
 <4DF0DD0F.8090407@tao.ma>
 <20110609153738.GF29913@redhat.com>
 <4DF0EA55.10209@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF0EA55.10209@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 11:44:21PM +0800, Tao Ma wrote:

[..]
> > CFQ in general tries not to drive too deep a queue depth in an effort
> > to improve latencies. CFQ is generally recommened for slow SATA drives
> > and dispatching too many requests from a single queue can only serve to
> > increase the latency.
> ok, so do you mean that for a fast drive, cfq isn't recommended and
> deadline is always prefered? ;) We have a SAS with queue_depth=128, so
> it should be a fast drive I guess. :)

I think in general that has been true in my experience. SSDs are still
ok with CFQ because that sets nonrotational flag and cuts down on 
idling. But if it is a rotational media which can handle multiple
parallel requests at a time you might have better throughput results
with deadline.

[..]
> > Its latency vs throughput tradeoff.
> ok, so it seems that all these are designed, not a bug. Thanks for the
> clarification.
> 
> btw, reverting the patch doesn't work. I can still get the livelock.

Can you give following patch a try and see if it helps. On my system this
does allow CFQ to dispatch some writes once in a while.

thanks
Vivek

---
 block/cfq-iosched.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

Index: linux-2.6/block/cfq-iosched.c
===================================================================
--- linux-2.6.orig/block/cfq-iosched.c	2011-06-09 11:44:40.000000000 -0400
+++ linux-2.6/block/cfq-iosched.c	2011-06-09 14:04:01.036983301 -0400
@@ -303,6 +303,8 @@ struct cfq_data {
 
 	/* Number of groups which are on blkcg->blkg_list */
 	unsigned int nr_blkcg_linked_grps;
+
+	unsigned long last_async_dispatched;
 };
 
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
@@ -2063,6 +2065,10 @@ static void cfq_dispatch_insert(struct r
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
 	cfqq->nr_sectors += blk_rq_sectors(rq);
+
+	if (!cfq_cfqq_sync(cfqq))
+		cfqd->last_async_dispatched = jiffies;
+
 	cfq_blkiocg_update_dispatch_stats(&cfqq->cfqg->blkg, blk_rq_bytes(rq),
 					rq_data_dir(rq), rq_is_sync(rq));
 }
@@ -3315,8 +3321,25 @@ cfq_should_preempt(struct cfq_data *cfqd
 	 * if the new request is sync, but the currently running queue is
 	 * not, let the sync request have priority.
 	 */
-	if (rq_is_sync(rq) && !cfq_cfqq_sync(cfqq))
+	if (rq_is_sync(rq) && !cfq_cfqq_sync(cfqq)) {
+		unsigned long async_delay = 0;
+
+		async_delay = jiffies - cfqd->last_async_dispatched;
+
+		/*
+		 * CFQ is heavily loaded in favor of sync queues and that
+ 		 * can lead to starvation of async queues. If it has been
+ 		 * too long since last async request was dispatched, don't
+ 		 * preempt async queue
+ 		 *
+ 		 * Once we have per group async queues, this will need
+ 		 * modification.
+ 		 */
+		if (async_delay > 2 * HZ)
+			return false;
+
 		return true;
+	}
 
 	if (new_cfqq->cfqg != cfqq->cfqg)
 		return false;
