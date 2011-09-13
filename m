Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab1IMD0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 23:26:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:33657 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab1IMD0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 23:26:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="47710428"
Subject: Re: [PATCH 1/1] CFQ: fix handling 'deep' cfqq
From: Shaohua Li <shaohua.li@intel.com>
To: Maxim Patlasov <maxim.patlasov@gmail.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CA+X1aCSPPoHjOyVpTgZ+NFySLiEK6hLM5boCVFaTTYBcQnYS1g@mail.gmail.com>
References: <1313768318-7960-1-git-send-email-maxim.patlasov@gmail.com>
	 <1313768318-7960-2-git-send-email-maxim.patlasov@gmail.com>
	 <CANejiEWadFK9GdXSwKgzNoj1Da_4QTUidTp-6FGkBtZwhbKvfw@mail.gmail.com>
	 <CA+X1aCRSADrUB+YVJ9j5u+VgGn=8fKw7A1eVVzPtODg+hK-B-w@mail.gmail.com>
	 <CANejiEX=S8tyPDhAjm84+9xBNt08Q0mjWHjqh-kFqL4H1ME-RA@mail.gmail.com>
	 <CA+X1aCSMb9CTpoHWv=UiMg-mHkB2ssmKRACtbDofWG=QSxXOdg@mail.gmail.com>
	 <CANejiEV7UfEHEMwokKwE+Pwqn_HRUT0_9wHakhOYj8r0roGYuw@mail.gmail.com>
	 <CA+X1aCR6Rptj_7bKf7O7TJ8a9z7AH0vXL90XAgY=+054WegsgQ@mail.gmail.com>
	 <CANejiEUTjZbxesiKFzGE4a9rs-GQfq1ekzaDAv34pMGrEQAUcg@mail.gmail.com>
	 <CA+X1aCQhUALGLrtjSzdHonQ1WdPgVMPa7kW2Yi0UFqBwD0Vv6w@mail.gmail.com>
	 <CA+X1aCSPPoHjOyVpTgZ+NFySLiEK6hLM5boCVFaTTYBcQnYS1g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 11:30:01 +0800
Message-ID: <1315884601.29510.87.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-12 at 21:09 +0800, Maxim Patlasov wrote:
Hi,
> 
> >> So the key problem here is how to detect if a device is fast. Doing
> >> the detection
> >> in the dispatch stage always can't give us correct result. A fast device really
> >> should be requests can be finished in short time. So I have something attached.
> >> In my environment, a hard disk is detected slow and a ssd is detected fast, but
> >> I haven't run any benchmark so far. How do you think about it?
> >
> > Thanks for the patch, I'll test it in several h/w configurations soon
> > and let you know about results.
> 
> 1. Single slow disk (ST3200826AS). Eight instances of aio-stress, cmd-line:
> 
> # aio-stress -a 4 -b 4 -c 1 -r 4 -O -o 0 -t 1 -d 1 -i 1 -s 16 f1_$I
> f2_$I f3_$I f4_$I
> 
> Aggreagate throughput:
> 
> Pristine 3.1.0-rc5 (CFQ): 3.77 MB/s
> Pristine 3.1.0-rc5 (noop): 2.63 MB/s
> Pristine 3.1.0-rc5 (CFQ, slice_idle=0): 2.81 MB/s
> 3.1.0-rc5 + my patch (CFQ): 5.76 MB/s
> 3.1.0-rc5 + your patch (CFQ): 5.61 MB/s
> 
> 2. Four modern disks (WD1003FBYX) assembled in RAID-0 (Adaptec
> AAC-RAID (rev 09) 256Mb RAM). Eight instances of aio-stress with
> think-time 1msec:
> 
> > --- aio-stress-orig.c	2011-08-16 17:00:04.000000000 -0400
> > +++ aio-stress.c	2011-08-18 14:49:31.000000000 -0400
> > @@ -884,6 +884,7 @@ static int run_active_list(struct thread
> >      }
> >      if (num_built) {
> >  	ret = run_built(t, num_built, t->iocbs);
> > +	usleep(1000);
> >  	if (ret < 0) {
> >  	    fprintf(stderr, "error %d on run_built\n", ret);
> >  	    exit(1);
> 
> Cmd-line:
> 
> # aio-stress -a 4 -b 4 -c 1 -r 4 -O -o 0 -t 1 -d 1 -i 1 f1_$I f2_$I f3_$I f4_$I
> 
> Aggreagate throughput:
> 
> Pristine 3.1.0-rc5 (CFQ): 63.67 MB/s
> Pristine 3.1.0-rc5 (noop): 100.8 MB/s
> Pristine 3.1.0-rc5 (CFQ, slice_idle=0): 105.63 MB/s
> 3.1.0-rc5 + my patch (CFQ): 105.59 MB/s
> 3.1.0-rc5 + your patch (CFQ): 14.36 MB/s
> 
> So, to meet needs of striped raids, it's not enough to measure service
> time of separate requests. We need somehow to measure whether given
> hdd/raid is able to service many requests simultaneously in an
> effective way.
Thanks for the testing. You are right, this method doesn't work for hard
raid. I missed each request in raid still has long finish time. I
changed the patch to detect fast device, the idea remains but the
algorithm is different. It detects my hard disk/ssd well, but I haven't
raid setup, so please help test.
I'm not satisfied with fast device detection in dispatch stage, even
slow device with NCQ can dispatch several requests in short time (so my
original implementation is wrong as you pointed out)
---
 block/cfq-iosched.c |   70 +++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 58 insertions(+), 12 deletions(-)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2011-09-09 16:50:19.000000000 +0800
+++ linux/block/cfq-iosched.c	2011-09-13 11:21:47.000000000 +0800
@@ -52,6 +52,7 @@ static const int cfq_hist_divisor = 4;
 #define CFQQ_CLOSE_THR		(sector_t)(8 * 1024)
 #define CFQQ_SECT_THR_NONROT	(sector_t)(2 * 32)
 #define CFQQ_SEEKY(cfqq)	(hweight32(cfqq->seek_history) > 32/8)
+#define CFQQ_STRICT_SEEKY(cfqq) (cfqq->seek_history == (u32)-1)
 
 #define RQ_CIC(rq)		\
 	((struct cfq_io_context *) (rq)->elevator_private[0])
@@ -75,6 +76,8 @@ static DEFINE_IDA(cic_index_ida);
 #define sample_valid(samples)	((samples) > 80)
 #define rb_entry_cfqg(node)	rb_entry((node), struct cfq_group, rb_node)
 
+#define CFQD_FAST(cfqd)		sample_valid((cfqd)->fast_device_samples)
+
 /*
  * Most of our rbtree usage is for sorting with min extraction, so
  * if we cache the leftmost node we don't have to walk down the tree
@@ -130,6 +133,9 @@ struct cfq_queue {
 	unsigned long slice_end;
 	long slice_resid;
 
+	unsigned long seeky_dispatch_start;
+	int seeky_dispatched;
+
 	/* pending metadata requests */
 	int meta_pending;
 	/* number of requests that are on the dispatch list or inside driver */
@@ -305,6 +311,8 @@ struct cfq_data {
 
 	/* Number of groups which are on blkcg->blkg_list */
 	unsigned int nr_blkcg_linked_grps;
+
+	int fast_device_samples;
 };
 
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
@@ -1723,6 +1731,9 @@ static void __cfq_set_active_queue(struc
 		cfq_mark_cfqq_slice_new(cfqq);
 
 		cfq_del_timer(cfqd, cfqq);
+
+		cfqq->seeky_dispatch_start = 0;
+		cfqq->seeky_dispatched = 0;
 	}
 
 	cfqd->active_queue = cfqq;
@@ -2062,6 +2073,48 @@ static void cfq_arm_slice_timer(struct c
 }
 
 /*
+ * Detect if a device is fast.
+ * We profile strictly seeky queue to check if a device is fast. CFQQ_SEEKY()
+ * isn't good here, because there might be sequential requests.
+ * In non-raid case, hard disk (slow device) usually finishes a request > 4ms;
+ * SSD (fast device) usually finishes a request < 1ms.
+ * in raid case, we consider raid as fast device, if the queue dispatches > 2
+ * requests to multiple disks, the average time of each request will < 4ms.
+ * >= 4ms >= 1 jiffy
+ * < 4ms == 0 jiffy
+ */
+static void cfq_fast_device_detect_start(struct cfq_data *cfqd,
+	struct cfq_queue *cfqq)
+{
+	if (CFQD_FAST(cfqd))
+		return;
+	if (cfqq->dispatched == 0 && CFQQ_STRICT_SEEKY(cfqq)) {
+		cfqq->seeky_dispatch_start = jiffies;
+		cfqq->seeky_dispatched = 1;
+		return;
+	}
+	if (cfqq->seeky_dispatch_start) {
+		if (!CFQQ_STRICT_SEEKY(cfqq)) {
+			cfqq->seeky_dispatch_start = 0;
+			cfqq->seeky_dispatched = 0;
+		} else
+			cfqq->seeky_dispatched++;
+	}
+}
+
+static void cfq_fast_device_detect_end(struct cfq_data *cfqd,
+	struct cfq_queue *cfqq)
+{
+	if (cfqq->seeky_dispatch_start && cfqq->dispatched == 0) {
+		if ((jiffies - cfqq->seeky_dispatch_start) /
+		   cfqq->seeky_dispatched <= 0)
+			cfqd->fast_device_samples ++;
+		cfqq->seeky_dispatch_start = 0;
+		cfqq->seeky_dispatched = 0;
+	}
+}
+
+/*
  * Move request from internal lists to the request queue dispatch list.
  */
 static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
@@ -2071,6 +2124,8 @@ static void cfq_dispatch_insert(struct r
 
 	cfq_log_cfqq(cfqd, cfqq, "dispatch_insert");
 
+	cfq_fast_device_detect_start(cfqd, cfqq);
+
 	cfqq->next_rq = cfq_find_next_rq(cfqd, cfqq, rq);
 	cfq_remove_request(rq);
 	cfqq->dispatched++;
@@ -2375,17 +2430,6 @@ static struct cfq_queue *cfq_select_queu
 		goto keep_queue;
 	}
 
-	/*
-	 * This is a deep seek queue, but the device is much faster than
-	 * the queue can deliver, don't idle
-	 **/
-	if (CFQQ_SEEKY(cfqq) && cfq_cfqq_idle_window(cfqq) &&
-	    (cfq_cfqq_slice_new(cfqq) ||
-	    (cfqq->slice_end - jiffies > jiffies - cfqq->slice_start))) {
-		cfq_clear_cfqq_deep(cfqq);
-		cfq_clear_cfqq_idle_window(cfqq);
-	}
-
 	if (cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
 		cfqq = NULL;
 		goto keep_queue;
@@ -3298,7 +3342,7 @@ cfq_update_idle_window(struct cfq_data *
 
 	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
 
-	if (cfqq->queued[0] + cfqq->queued[1] >= 4)
+	if (cfqq->queued[0] + cfqq->queued[1] >= 4 && !CFQD_FAST(cfqd))
 		cfq_mark_cfqq_deep(cfqq);
 
 	if (cfqq->next_rq && (cfqq->next_rq->cmd_flags & REQ_NOIDLE))
@@ -3598,6 +3642,8 @@ static void cfq_completed_request(struct
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
 
+	cfq_fast_device_detect_end(cfqd, cfqq);
+
 	if (sync) {
 		struct cfq_rb_root *service_tree;
 


