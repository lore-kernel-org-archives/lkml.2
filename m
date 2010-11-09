Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab0KIC6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 21:58:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:21194 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725Ab0KIC63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 21:58:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,173,1288594800"; 
   d="scan'208";a="675594087"
Subject: Re: [patch 2/3]cfq-iosched: schedule dispatch for noidle queue
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        "czoccolo@gmail.com" <czoccolo@gmail.com>
In-Reply-To: <20101109023919.GB29847@redhat.com>
References: <1289182038.23014.190.camel@sli10-conroe>
	 <20101108142842.GC16767@redhat.com>
	 <1289266267.23014.196.camel@sli10-conroe>
	 <20101109021540.GA29210@redhat.com>
	 <1289269716.23014.208.camel@sli10-conroe>
	 <20101109023919.GB29847@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 10:58:16 +0800
Message-ID: <1289271496.23014.213.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 10:39 +0800, Vivek Goyal wrote:
> On Tue, Nov 09, 2010 at 10:28:36AM +0800, Shaohua Li wrote:
> 
> [..]
> > > > > Why do we have to wait for all requests to finish in device? Will driver
> > > > > most likely not ask for next request when 1-2 requests have completed
> > > > > and at that time we should expire the queue if queue is no more marked
> > > > > as "noidle"?
> > > > The issue is a queue is idle just because it's the last queue of the
> > > > service tree. Then a new queue is added and the idled queue should not
> > > > idle now. we should preempt the idled queue soon. does this make sense
> > > > to you?
> > > 
> > > If that's the case then you should just modify should_preempt() so that
> > > addition of a new queue could preempt an empty queue which has now become
> > > noidle.
> > > 
> > > You have also modified cfq_completed_request() function, which will wake
> > > up the worker thread and then try to dispatch a request. IMHO, in practice
> > > driver asks for new request almost immediately and you don't gain much
> > > by this additional wakeup.
> > > 
> > > So my point being, that we increased the code complexity for no visible
> > > performance improvement also increased thread wakeups resulting in more
> > > cpu consumption.
> > Ah, you are right, we only need modify should_preempt. Updated the patch as below.
> > 
> 
> Thanks. Jens has already applied the patches on for-2.6.38/core branch of
> block tree. I think you shall have to generate an incremental patch
> which revert the bits introduced in cfq_completed_request().
Jens, how to handle this? if you want to an incremental patch, here it
is.

Subject: cfq-iosched: don't schedule a dispatch for a non-idle queue

Vivek suggests we don't need schedule a dispatch when an idle queue
becomes nonidle. And he is right, cfq_should_preempt already covers
the logic.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 block/cfq-iosched.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2010-11-09 10:48:08.000000000 +0800
+++ linux/block/cfq-iosched.c	2010-11-09 10:48:44.000000000 +0800
@@ -3512,25 +3512,8 @@ static void cfq_completed_request(struct
 		}
 	}
 
-	if (!cfqd->rq_in_driver) {
+	if (!cfqd->rq_in_driver)
 		cfq_schedule_dispatch(cfqd);
-		return;
-	}
-	/*
-	 * A queue is idle at cfq_dispatch_requests(), but it gets noidle
-	 * later. We schedule a dispatch if the queue has no requests,
-	 * otherwise the disk is actually in idle till all requests
-	 * are finished even cfq_arm_slice_timer doesn't make the queue idle
-	 * */
-	cfqq = cfqd->active_queue;
-	if (!cfqq)
-		return;
-
-	if (RB_EMPTY_ROOT(&cfqq->sort_list) && !cfq_should_idle(cfqd, cfqq) &&
-	    (!cfqd->cfq_group_idle || cfqq->cfqg->nr_cfqq > 1)) {
-		cfq_del_timer(cfqd, cfqq);
-		cfq_schedule_dispatch(cfqd);
-	}
 }
 
 /*


