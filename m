Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab1GFB5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 21:57:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:60690 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab1GFB5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 21:57:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,482,1304319600"; 
   d="scan'208";a="21919265"
Subject: Re: [PATCH 2/3]CFQ: add think time check for service tree
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <20110705141041.GB24348@redhat.com>
References: <1309757794.15392.238.camel@sli10-conroe>
	 <20110705141041.GB24348@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 09:57:45 +0800
Message-ID: <1309917465.15392.245.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-05 at 22:10 +0800, Vivek Goyal wrote:
> On Mon, Jul 04, 2011 at 01:36:34PM +0800, Shaohua Li wrote:
> > Subject: CFQ: add think time check for service tree
> > 
> > Currently when the last queue of a service tree has no request, we don't
> > expire the queue to hope request from the service tree comes soon, so the
> > service tree doesn't miss its share. But if the think time is big, the
> > assumption isn't correct and we just waste bandwidth. In such case, we
> > don't do idle.
> > 
> > [global]
> > runtime=10
> > direct=1
> > 
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
> > 
> > A slightly better
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > 
> > ---
> >  block/cfq-iosched.c |   26 ++++++++++++++++++++++----
> >  1 file changed, 22 insertions(+), 4 deletions(-)
> > 
> > Index: linux/block/cfq-iosched.c
> > ===================================================================
> > --- linux.orig/block/cfq-iosched.c	2011-07-01 13:43:34.000000000 +0800
> > +++ linux/block/cfq-iosched.c	2011-07-01 13:45:24.000000000 +0800
> > @@ -74,6 +74,8 @@ static DEFINE_IDA(cic_index_ida);
> >  
> >  #define sample_valid(samples)	((samples) > 80)
> >  #define rb_entry_cfqg(node)	rb_entry((node), struct cfq_group, rb_node)
> > +#define cfq_io_thinktime_big(ttime, slice) \
> > +	(sample_valid((ttime).ttime_samples) && (ttime).ttime_mean > (slice))
> >  
> 
> I think instead of a macro, a inline function to check this will be better.
> Also you don't have to pass slice_idle value as parameter as funciton
> can directly access it from cfqd.
> 
> >  /*
> >   * Most of our rbtree usage is for sorting with min extraction, so
> > @@ -87,9 +89,10 @@ struct cfq_rb_root {
> >  	unsigned count;
> >  	unsigned total_weight;
> >  	u64 min_vdisktime;
> > +	struct cfq_ttime ttime;
> >  };
> > -#define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, .left = NULL, \
> > -			.count = 0, .min_vdisktime = 0, }
> > +#define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, \
> > +			.ttime = {.last_end_request = jiffies,},}
> >  
> >  /*
> >   * Per process-grouping structure
> > @@ -1969,7 +1972,8 @@ static bool cfq_should_idle(struct cfq_d
> >  	 * Otherwise, we do only if they are the last ones
> >  	 * in their service tree.
> >  	 */
> > -	if (service_tree->count == 1 && cfq_cfqq_sync(cfqq))
> > +	if (service_tree->count == 1 && cfq_cfqq_sync(cfqq) &&
> > +	   !cfq_io_thinktime_big(service_tree->ttime, cfqd->cfq_slice_idle))
> >  		return true;
> >  	cfq_log_cfqq(cfqd, cfqq, "Not idling. st->count:%d",
> >  			service_tree->count);
> > @@ -3231,8 +3235,16 @@ static void
> >  cfq_update_io_thinktime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> >  	struct cfq_io_context *cic)
> >  {
> > -	if (cfq_cfqq_sync(cfqq))
> > +	struct cfq_rb_root *service_tree;
> > +	struct cfq_group *cfqg = cfqq->cfqg;
> > +
> > +	if (cfq_cfqq_sync(cfqq)) {
> >  		__cfq_update_io_thinktime(&cic->ttime, cfqd->cfq_slice_idle);
> > +		service_tree = service_tree_for(cfqg, cfqq_prio(cfqq),
> > +			cfqq_type(cfqq));
> 
> I think by now cfqq is already on the service tree and cfqq->service_tree
> should be set. So we should be able to just acess that instead of calling
> service_tree_for().
> 
> I have noticed that cfqq might be queued on one service tree but we can
> change the idling on queue and cfqq_type() can return a different value
> and different service tree. So trying to avoid use of service_tree_for()
> when cfqq is already on a service tree should be good.
> 
> > +		__cfq_update_io_thinktime(&service_tree->ttime,
> > +			cfqd->cfq_slice_idle);
> > +	}
> >  }
> >  
> >  static void
> > @@ -3570,7 +3582,13 @@ static void cfq_completed_request(struct
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
> Ditto.
Thanks for your time.
this one might not have service tree set because a queue might already
send out all its requests.
other suggested changes are made. Here is the updated patch.


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
 block/cfq-iosched.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2011-07-06 09:18:09.000000000 +0800
+++ linux/block/cfq-iosched.c	2011-07-06 09:39:52.000000000 +0800
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
@@ -3570,7 +3587,13 @@ static void cfq_completed_request(struct
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
 
 	if (sync) {
+		struct cfq_rb_root *service_tree;
+
 		RQ_CIC(rq)->ttime.last_end_request = now;
+
+		service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
+			cfqq_type(cfqq));
+		service_tree->ttime.last_end_request = now;
 		if (!time_after(rq->start_time + cfqd->cfq_fifo_expire[1], now))
 			cfqd->last_delayed_sync = now;
 	}


