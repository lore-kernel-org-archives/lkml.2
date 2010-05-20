Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab0ETOua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 10:50:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab0ETOu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 10:50:29 -0400
Date: Thu, 20 May 2010 10:50:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] cfq-iosched: Revert the logic of deep queues
Message-ID: <20100520145024.GB10298@redhat.com>
References: <20100519203336.GB3394@redhat.com> <AANLkTimL7SjlZW5qxylc2MdygYugTFgDVdMM-N-E0tk0@mail.gmail.com> <20100520131844.GA10298@redhat.com> <AANLkTinEaQtA-Kw-7CedvNyVL8w1ybDnvkjZZ8g8ORaN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinEaQtA-Kw-7CedvNyVL8w1ybDnvkjZZ8g8ORaN@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 04:01:55PM +0200, Corrado Zoccolo wrote:
> On Thu, May 20, 2010 at 3:18 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, May 20, 2010 at 01:51:49AM +0200, Corrado Zoccolo wrote:
> > Hi Corrado,
> >
> > Deep queues can happen often on high end storage. One case I can think of is
> > multiple kvm virt machines running and doing IO using AIO.
> >
> > I am not too keen on introducing a tunable at this point of time. Reason
> > being that somebody having a SATA disk and driving deep queue depths is
> > not very practical thing to do. At the same time we have fixed a theoritical
> > problem in the past. If somebody really runs into the issue of deep queue
> > starving other random IO, then we can fix it.
> >
> > Even if we have to fix it, I think instead of a tunable, a better solution
> > would be to expire the deep queue after one round of dispatch (after
> > having dispatched "quantum" number of requests from queue). That way no
> > single sync-noidle queue will starve other queues and they will get to
> > dispatch IO very nicely without intorducing any bottlenecks.
> 
> Can you implement this solution in the patch? It seems that this will
> solve both the performance issue as well as non-reintroducing the
> theoretical starvation problem.
> If we don't mind some more tree operations, the queue could be expired
> at every dispatch (if there are other queues in the service tree),
> instead of every quantum dispatches, to cycle through all no-idle
> queues more quickly and more fairly.

Alright. Following is a copile tested only patch. I have yet to do the
testing to make sure it works. But I think it should address your concern
of a deep queue starving other shallow sync-noidle queues.

Does this one look good?

Thanks
Vivek


Index: linux-2.6/block/cfq-iosched.c
===================================================================
--- linux-2.6.orig/block/cfq-iosched.c
+++ linux-2.6/block/cfq-iosched.c
@@ -313,7 +313,6 @@ enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_sync,		/* synchronous queue */
 	CFQ_CFQQ_FLAG_coop,		/* cfqq is shared */
 	CFQ_CFQQ_FLAG_split_coop,	/* shared cfqq will be splitted */
-	CFQ_CFQQ_FLAG_deep,		/* sync cfqq experienced large depth */
 	CFQ_CFQQ_FLAG_wait_busy,	/* Waiting for next request */
 };
 
@@ -342,7 +341,6 @@ CFQ_CFQQ_FNS(slice_new);
 CFQ_CFQQ_FNS(sync);
 CFQ_CFQQ_FNS(coop);
 CFQ_CFQQ_FNS(split_coop);
-CFQ_CFQQ_FNS(deep);
 CFQ_CFQQ_FNS(wait_busy);
 #undef CFQ_CFQQ_FNS
 
@@ -2377,6 +2375,17 @@ static int cfq_dispatch_requests(struct 
 	    cfq_class_idle(cfqq))) {
 		cfqq->slice_end = jiffies + 1;
 		cfq_slice_expired(cfqd, 0);
+	} else if (cfqq_type(cfqq) == SYNC_NOIDLE_WORKLOAD
+		  && cfqq->service_tree->count > 1
+		  && cfqq->slice_dispatch >= cfq_prio_to_maxrq(cfqd, cfqq)/2) {
+		/*
+		 * Expire a sync-noidle queue immediately if it has already
+		 * dispatched many requests. This will make sure one deep
+		 * sync-noidle queue will not starve other shallow sync-noidle
+		 * queues.
+		 */
+		cfqq->slice_end = jiffies + 1;
+		cfq_slice_expired(cfqd, 0);
 	}
 
 	cfq_log_cfqq(cfqd, cfqq, "dispatched a request");
@@ -3036,11 +3045,8 @@ cfq_update_idle_window(struct cfq_data *
 
 	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
 
-	if (cfqq->queued[0] + cfqq->queued[1] >= 4)
-		cfq_mark_cfqq_deep(cfqq);
-
 	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
-	    (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
+	    CFQQ_SEEKY(cfqq))
 		enable_idle = 0;
 	else if (sample_valid(cic->ttime_samples)) {
 		if (cic->ttime_mean > cfqd->cfq_slice_idle)
@@ -3593,11 +3599,6 @@ static void cfq_idle_slice_timer(unsigne
 		 */
 		if (!RB_EMPTY_ROOT(&cfqq->sort_list))
 			goto out_kick;
-
-		/*
-		 * Queue depth flag is reset only when the idle didn't succeed
-		 */
-		cfq_clear_cfqq_deep(cfqq);
 	}
 expire:
 	cfq_slice_expired(cfqd, timed_out);
