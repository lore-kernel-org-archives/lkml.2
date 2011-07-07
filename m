Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab1GGGRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 02:17:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:50278 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab1GGGRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 02:17:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,491,1304319600"; 
   d="scan'208";a="22492952"
Subject: Re: [PATCH 2/3]CFQ: add think time check for service tree
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <20110706150143.GC27302@redhat.com>
References: <1309757794.15392.238.camel@sli10-conroe>
	 <20110705141041.GB24348@redhat.com>
	 <1309917465.15392.245.camel@sli10-conroe>
	 <20110706150143.GC27302@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jul 2011 14:17:18 +0800
Message-ID: <1310019438.15392.258.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-06 at 23:01 +0800, Vivek Goyal wrote:
> On Wed, Jul 06, 2011 at 09:57:45AM +0800, Shaohua Li wrote:
> [..]
> > [test1]
> > rw=randread
> > ioengine=libaio
> > size=500m
> > directory=/mnt
> > filename=file1
> > thinktime=9000
> > 
> > [test2]
> > rw=read
> > ioengine=libaio
> > size=1G
> > directory=/mnt
> > filename=file2
> > 
> > 	patched		base
> > test1	41k/s		33k/s
> > test2	15868k/s	15789k/s
> > total	15902k/s	15817k/s
> 
> Because we are not idling, throughput of randread workload has gone down.
> Can you make sure it does not go down in case of launching firefox in
> the presence of buffered writers. I want to make sure we got thinktime
> logic right and we don't end up not idling even when thinktimes are
> low.
I tried think time 2ms and no think time. But the test result isn't
quite stable, I can't completely make sure there is no difference. Most
time the test result is similar but sometimes there is relatively big
diverge with/without my patch.

> [..]
> >  static void
> > @@ -3570,7 +3587,13 @@ static void cfq_completed_request(struct
> >  	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
> >  
> >  	if (sync) {
> > +		struct cfq_rb_root *service_tree;
> > +
> >  		RQ_CIC(rq)->ttime.last_end_request = now;
> > +
> > +		service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
> > +			cfqq_type(cfqq));
> 
> I think we could do.
> 
> if (cfq_cfqq_on_rr(cfqq)
> 	service_tree = cfqq->service_tree;
> else
> 	service_tree = service_tree_for();
ok.

Subject: CFQ: add think time check for service tree

Currently when the last queue of a service tree has no request, we don't
expire the queue to hope request from the service tree comes soon, so the
service tree doesn't miss its share. But if the think time is big, the
assumption isn't correct and we just waste bandwidth. In such case, we
don't do idle.

[global]
runtime=10
direct=1

[test1]
rw=randread
ioengine=libaio
size=500m
directory=/mnt
filename=file1
thinktime=9000

[test2]
rw=read
ioengine=libaio
size=1G
directory=/mnt
filename=file2

	patched		base
test1	41k/s		33k/s
test2	15868k/s	15789k/s
total	15902k/s	15817k/s

A slightly better

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 block/cfq-iosched.c |   34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2011-07-07 09:07:22.000000000 +0800
+++ linux/block/cfq-iosched.c	2011-07-07 09:08:55.000000000 +0800
@@ -87,9 +87,10 @@ struct cfq_rb_root {
 	unsigned count;
 	unsigned total_weight;
 	u64 min_vdisktime;
+	struct cfq_ttime ttime;
 };
-#define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, .left = NULL, \
-			.count = 0, .min_vdisktime = 0, }
+#define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, \
+			.ttime = {.last_end_request = jiffies,},}
 
 /*
  * Per process-grouping structure
@@ -393,6 +394,18 @@ CFQ_CFQQ_FNS(wait_busy);
 			j++, st = i < IDLE_WORKLOAD ? \
 			&cfqg->service_trees[i][j]: NULL) \
 
+static inline bool cfq_io_thinktime_big(struct cfq_data *cfqd,
+	struct cfq_ttime *ttime, bool group_idle)
+{
+	unsigned long slice;
+	if (!sample_valid(ttime->ttime_samples))
+		return false;
+	if (group_idle)
+		slice = cfqd->cfq_group_idle;
+	else
+		slice = cfqd->cfq_slice_idle;
+	return ttime->ttime_mean > slice;
+}
 
 static inline bool iops_mode(struct cfq_data *cfqd)
 {
@@ -1969,7 +1982,8 @@ static bool cfq_should_idle(struct cfq_d
 	 * Otherwise, we do only if they are the last ones
 	 * in their service tree.
 	 */
-	if (service_tree->count == 1 && cfq_cfqq_sync(cfqq))
+	if (service_tree->count == 1 && cfq_cfqq_sync(cfqq) &&
+	   !cfq_io_thinktime_big(cfqd, &service_tree->ttime, false))
 		return true;
 	cfq_log_cfqq(cfqd, cfqq, "Not idling. st->count:%d",
 			service_tree->count);
@@ -3231,8 +3245,11 @@ static void
 cfq_update_io_thinktime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	struct cfq_io_context *cic)
 {
-	if (cfq_cfqq_sync(cfqq))
+	if (cfq_cfqq_sync(cfqq)) {
 		__cfq_update_io_thinktime(&cic->ttime, cfqd->cfq_slice_idle);
+		__cfq_update_io_thinktime(&cfqq->service_tree->ttime,
+			cfqd->cfq_slice_idle);
+	}
 }
 
 static void
@@ -3570,7 +3587,16 @@ static void cfq_completed_request(struct
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
 
 	if (sync) {
+		struct cfq_rb_root *service_tree;
+
 		RQ_CIC(rq)->ttime.last_end_request = now;
+
+		if (cfq_cfqq_on_rr(cfqq))
+			service_tree = cfqq->service_tree;
+		else
+			service_tree = service_tree_for(cfqq->cfqg,
+				cfqq_prio(cfqq), cfqq_type(cfqq));
+		service_tree->ttime.last_end_request = now;
 		if (!time_after(rq->start_time + cfqd->cfq_fifo_expire[1], now))
 			cfqd->last_delayed_sync = now;
 	}



