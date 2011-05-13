Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab1EMDCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 23:02:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:24905 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab1EMDCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 23:02:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,362,1301900400"; 
   d="scan'208";a="435362903"
Subject: Re: Perfromance drop on SCSI hard disk
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "Shi, Alex" <alex.shi@intel.com>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1305247704.2373.32.camel@sli10-conroe>
References: <1305009600.21534.587.camel@debian>
	 <4DCC4340.6000407@fusionio.com>  <1305247704.2373.32.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 11:01:57 +0800
Message-ID: <1305255717.2373.38.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 08:48 +0800, Shaohua Li wrote:
> On Fri, 2011-05-13 at 04:29 +0800, Jens Axboe wrote:
> > On 2011-05-10 08:40, Alex,Shi wrote:
> > > commit c21e6beba8835d09bb80e34961 removed the REENTER flag and changed
> > > scsi_run_queue() to punt all requests on starved_list devices to
> > > kblockd. Yes, like Jens mentioned, the performance on slow SCSI disk was
> > > hurt here.  :) (Intel SSD isn't effected here)
> > > 
> > > In our testing on 12 SAS disk JBD, the fio write with sync ioengine drop
> > > about 30~40% throughput, fio randread/randwrite with aio ioengine drop
> > > about 20%/50% throughput. and fio mmap testing was hurt also. 
> > > 
> > > With the following debug patch, the performance can be totally recovered
> > > in our testing. But without REENTER flag here, in some corner case, like
> > > a device is keeping blocked and then unblocked repeatedly,
> > > __blk_run_queue() may recursively call scsi_run_queue() and then cause
> > > kernel stack overflow. 
> > > I don't know details of block device driver, just wondering why on scsi
> > > need the REENTER flag here. :) 
> > 
> > This is a problem and we should do something about it for 2.6.39. I knew
> > that there would be cases where the async offload would cause a
> > performance degredation, but not to the extent that you are reporting.
> > Must be hitting the pathological case.
> async offload is expected to increase context switch. But the real root
> cause of the issue is fairness issue. Please see my previous email.
> 
> > I can think of two scenarios where it could potentially recurse:
> > 
> > - request_fn enter, end up requeuing IO. Run queue at the end. Rinse,
> >   repeat.
> > - Running starved list from request_fn, two (or more) devices could
> >   alternately recurse.
> > 
> > The first case should be fairly easy to handle. The second one is
> > already handled by the local list splice.
> this isn't true to me. if you unlock host_lock in scsi_run_queue, other
> cpus can add sdev to the starved device list again. In the recursive
> call of scsi_run_queue, the starved device list might not be empty. So
> the local list_splice doesn't help.
> 
> > 
> > Looking at the code, is this a real scenario? Only potential recurse I
> > see is:
> > 
> > scsi_request_fn()
> >         scsi_dispatch_cmd()
> >                 scsi_queue_insert()
> >                         __scsi_queue_insert()
> >                                 scsi_run_queue()
> > 
> > Why are we even re-running the queue immediately on a BUSY condition?
> > Should only be needed if we have zero pending commands from this
> > particular queue, and for that particular case async run is just fine
> > since it's a rare condition (or performance would suck already).
> > 
> > And it should only really be needed for the 'q' being passed in, not the
> > others. Something like the below.
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 0bac91e..0b01c1f 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -74,7 +74,7 @@ struct kmem_cache *scsi_sdb_cache;
> >   */
> >  #define SCSI_QUEUE_DELAY	3
> >  
> > -static void scsi_run_queue(struct request_queue *q);
> > +static void scsi_run_queue_async(struct request_queue *q);
> >  
> >  /*
> >   * Function:	scsi_unprep_request()
> > @@ -161,7 +161,7 @@ static int __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
> >  	blk_requeue_request(q, cmd->request);
> >  	spin_unlock_irqrestore(q->queue_lock, flags);
> >  
> > -	scsi_run_queue(q);
> > +	scsi_run_queue_async(q);
> so you could still recursivly run into starved list. Do you want to put
> the whole __scsi_run_queue into workqueue?
what I mean is current sdev (other devices too) can still be added into
starved list, so only does async execute for current q isn't enough,
we'd better put whole __scsi_run_queue into workqueue. something like
below on top of yours, untested. Not sure if there are other recursive
cases.

Index: linux/drivers/scsi/scsi_lib.c
===================================================================
--- linux.orig/drivers/scsi/scsi_lib.c	2011-05-13 10:32:28.000000000 +0800
+++ linux/drivers/scsi/scsi_lib.c	2011-05-13 10:52:51.000000000 +0800
@@ -74,8 +74,6 @@ struct kmem_cache *scsi_sdb_cache;
  */
 #define SCSI_QUEUE_DELAY	3
 
-static void scsi_run_queue_async(struct request_queue *q);
-
 /*
  * Function:	scsi_unprep_request()
  *
@@ -161,7 +159,7 @@ static int __scsi_queue_insert(struct sc
 	blk_requeue_request(q, cmd->request);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	scsi_run_queue_async(q);
+	kblockd_schedule_work(q, &device->requeue_work);
 
 	return 0;
 }
@@ -391,14 +389,13 @@ static inline int scsi_host_is_busy(stru
  * Purpose:	Select a proper request queue to serve next
  *
  * Arguments:	q	- last request's queue
- * 		async	- prevent potential request_fn recurse by running async
  *
  * Returns:     Nothing
  *
  * Notes:	The previous command was completely finished, start
  *		a new one if possible.
  */
-static void __scsi_run_queue(struct request_queue *q, bool async)
+static void scsi_run_queue(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost;
@@ -449,20 +446,17 @@ static void __scsi_run_queue(struct requ
 	list_splice(&starved_list, &shost->starved_list);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	if (async)
-		blk_run_queue_async(q);
-	else
-		blk_run_queue(q);
+	blk_run_queue(q);
 }
 
-static void scsi_run_queue(struct request_queue *q)
+void scsi_requeue_run_queue(struct work_struct *work)
 {
-	__scsi_run_queue(q, false);
-}
+	struct scsi_device *sdev;
+	struct request_queue *q;
 
-static void scsi_run_queue_async(struct request_queue *q)
-{
-	__scsi_run_queue(q, true);
+	sdev = container_of(work, struct scsi_device, requeue_work);
+	q = sdev->request_queue;
+	scsi_run_queue(q);
 }
 
 /*
Index: linux/drivers/scsi/scsi_scan.c
===================================================================
--- linux.orig/drivers/scsi/scsi_scan.c	2011-05-13 10:44:09.000000000 +0800
+++ linux/drivers/scsi/scsi_scan.c	2011-05-13 10:45:41.000000000 +0800
@@ -242,6 +242,7 @@ static struct scsi_device *scsi_alloc_sd
 	int display_failure_msg = 1, ret;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	extern void scsi_evt_thread(struct work_struct *work);
+	extern void scsi_requeue_run_queue(struct work_struct *work);
 
 	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
 		       GFP_ATOMIC);
@@ -264,6 +265,7 @@ static struct scsi_device *scsi_alloc_sd
 	INIT_LIST_HEAD(&sdev->event_list);
 	spin_lock_init(&sdev->list_lock);
 	INIT_WORK(&sdev->event_work, scsi_evt_thread);
+	INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
 
 	sdev->sdev_gendev.parent = get_device(&starget->dev);
 	sdev->sdev_target = starget;
Index: linux/include/scsi/scsi_device.h
===================================================================
--- linux.orig/include/scsi/scsi_device.h	2011-05-13 10:36:31.000000000 +0800
+++ linux/include/scsi/scsi_device.h	2011-05-13 10:40:46.000000000 +0800
@@ -169,6 +169,7 @@ struct scsi_device {
 				sdev_dev;
 
 	struct execute_work	ew; /* used to get process context on put */
+	struct work_struct	requeue_work;
 
 	struct scsi_dh_data	*scsi_dh_data;
 	enum scsi_device_state sdev_state;



