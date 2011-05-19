Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab1ESI1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 04:27:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:55984 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756736Ab1ESI1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 04:27:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,236,1304319600"; 
   d="scan'208";a="843268"
Subject: Re: Perfromance drop on SCSI hard disk
From: "Alex,Shi" <alex.shi@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "Li, Shaohua" <shaohua.li@intel.com>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4DD221BE.3040406@fusionio.com>
References: <1305009600.21534.587.camel@debian>
	 <4DCC4340.6000407@fusionio.com>  <1305247704.2373.32.camel@sli10-conroe>
	 <1305255717.2373.38.camel@sli10-conroe>
	 <1305533054.2375.45.camel@sli10-conroe>
	 <1305535071.21534.2122.camel@debian> <1305612565.21534.2177.camel@debian>
	 <4DD221BE.3040406@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 16:26:20 +0800
Message-ID: <1305793580.22968.155.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I will queue up the combined patch, it looks fine from here as well.
> 

When I have some time to study Jens and shaohua's patch today. I find a
simpler way to resolved the re-enter issue on starved_list. Following
Jens' idea, we can just put the starved_list device into kblockd if it
come from __scsi_queue_insert(). 
It can resolve the re-enter issue and recover performance totally, and
need not a work_struct in every scsi_device. The logic/code also looks a
bit simpler. 
What's your opinion of this? 


Signed-off-by: Alex Shi <alex.shi@intel.com>
---
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ec1803a..de7c569 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -74,6 +74,8 @@ struct kmem_cache *scsi_sdb_cache;
  */
 #define SCSI_QUEUE_DELAY	3
 
+static void scsi_run_queue_async(struct request_queue *q);
+
 /*
  * Function:	scsi_unprep_request()
  *
@@ -159,7 +161,7 @@ static int __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	blk_requeue_request(q, cmd->request);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	kblockd_schedule_work(q, &device->requeue_work);
+	scsi_run_queue_async(q);
 
 	return 0;
 }
@@ -395,7 +397,7 @@ static inline int scsi_host_is_busy(struct Scsi_Host *shost)
  * Notes:	The previous command was completely finished, start
  *		a new one if possible.
  */
-static void scsi_run_queue(struct request_queue *q)
+static void __scsi_run_queue(struct request_queue *q, bool async)
 {
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost;
@@ -435,30 +437,35 @@ static void scsi_run_queue(struct request_queue *q)
 				       &shost->starved_list);
 			continue;
 		}
-
-		spin_unlock(shost->host_lock);
-		spin_lock(sdev->request_queue->queue_lock);
-		__blk_run_queue(sdev->request_queue);
-		spin_unlock(sdev->request_queue->queue_lock);
-		spin_lock(shost->host_lock);
+		if (async)
+			blk_run_queue_async(sdev->request_queue);
+		else {
+			spin_unlock(shost->host_lock);
+			spin_lock(sdev->request_queue->queue_lock);
+			__blk_run_queue(sdev->request_queue);
+			spin_unlock(sdev->request_queue->queue_lock);
+			spin_lock(shost->host_lock);
+		}
 	}
 	/* put any unprocessed entries back */
 	list_splice(&starved_list, &shost->starved_list);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	blk_run_queue(q);
+	if (async)
+		blk_run_queue_async(q);
+	else
+		blk_run_queue(q);
 }
 
-void scsi_requeue_run_queue(struct work_struct *work)
+static void scsi_run_queue(struct request_queue *q)
 {
-	struct scsi_device *sdev;
-	struct request_queue *q;
-
-	sdev = container_of(work, struct scsi_device, requeue_work);
-	q = sdev->request_queue;
-	scsi_run_queue(q);
+	__scsi_run_queue(q, false);
 }
 
+static void scsi_run_queue_async(struct request_queue *q)
+{
+	__scsi_run_queue(q, true);
+}
 /*
  * Function:	scsi_requeue_command()
  *
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 58584dc..087821f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -242,7 +242,6 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	int display_failure_msg = 1, ret;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	extern void scsi_evt_thread(struct work_struct *work);
-	extern void scsi_requeue_run_queue(struct work_struct *work);
 
 	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
 		       GFP_ATOMIC);
@@ -265,7 +264,6 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	INIT_LIST_HEAD(&sdev->event_list);
 	spin_lock_init(&sdev->list_lock);
 	INIT_WORK(&sdev->event_work, scsi_evt_thread);
-	INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
 
 	sdev->sdev_gendev.parent = get_device(&starget->dev);
 	sdev->sdev_target = starget;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index dd82e02..2d3ec50 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -169,7 +169,6 @@ struct scsi_device {
 				sdev_dev;
 
 	struct execute_work	ew; /* used to get process context on put */
-	struct work_struct	requeue_work;
 
 	struct scsi_dh_data	*scsi_dh_data;
 	enum scsi_device_state sdev_state;


