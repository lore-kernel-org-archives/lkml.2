Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab1ELU37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 16:29:59 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:38558 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932580Ab1ELU35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 16:29:57 -0400
X-ASG-Debug-ID: 1305232196-03d6a50f3672400001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DCC4340.6000407@fusionio.com>
Date: Thu, 12 May 2011 22:29:52 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "Alex,Shi" <alex.shi@intel.com>
CC: "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Perfromance drop on SCSI hard disk
References: <1305009600.21534.587.camel@debian>
X-ASG-Orig-Subj: Re: Perfromance drop on SCSI hard disk
In-Reply-To: <1305009600.21534.587.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1305232196
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.63549
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-10 08:40, Alex,Shi wrote:
> commit c21e6beba8835d09bb80e34961 removed the REENTER flag and changed
> scsi_run_queue() to punt all requests on starved_list devices to
> kblockd. Yes, like Jens mentioned, the performance on slow SCSI disk was
> hurt here.  :) (Intel SSD isn't effected here)
> 
> In our testing on 12 SAS disk JBD, the fio write with sync ioengine drop
> about 30~40% throughput, fio randread/randwrite with aio ioengine drop
> about 20%/50% throughput. and fio mmap testing was hurt also. 
> 
> With the following debug patch, the performance can be totally recovered
> in our testing. But without REENTER flag here, in some corner case, like
> a device is keeping blocked and then unblocked repeatedly,
> __blk_run_queue() may recursively call scsi_run_queue() and then cause
> kernel stack overflow. 
> I don't know details of block device driver, just wondering why on scsi
> need the REENTER flag here. :) 

This is a problem and we should do something about it for 2.6.39. I knew
that there would be cases where the async offload would cause a
performance degredation, but not to the extent that you are reporting.
Must be hitting the pathological case.

I can think of two scenarios where it could potentially recurse:

- request_fn enter, end up requeuing IO. Run queue at the end. Rinse,
  repeat.
- Running starved list from request_fn, two (or more) devices could
  alternately recurse.

The first case should be fairly easy to handle. The second one is
already handled by the local list splice.

Looking at the code, is this a real scenario? Only potential recurse I
see is:

scsi_request_fn()
        scsi_dispatch_cmd()
                scsi_queue_insert()
                        __scsi_queue_insert()
                                scsi_run_queue()

Why are we even re-running the queue immediately on a BUSY condition?
Should only be needed if we have zero pending commands from this
particular queue, and for that particular case async run is just fine
since it's a rare condition (or performance would suck already).

And it should only really be needed for the 'q' being passed in, not the
others. Something like the below.

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0bac91e..0b01c1f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -74,7 +74,7 @@ struct kmem_cache *scsi_sdb_cache;
  */
 #define SCSI_QUEUE_DELAY	3
 
-static void scsi_run_queue(struct request_queue *q);
+static void scsi_run_queue_async(struct request_queue *q);
 
 /*
  * Function:	scsi_unprep_request()
@@ -161,7 +161,7 @@ static int __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	blk_requeue_request(q, cmd->request);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	scsi_run_queue(q);
+	scsi_run_queue_async(q);
 
 	return 0;
 }
@@ -391,13 +391,14 @@ static inline int scsi_host_is_busy(struct Scsi_Host *shost)
  * Purpose:	Select a proper request queue to serve next
  *
  * Arguments:	q	- last request's queue
+ * 		async	- prevent potential request_fn recurse by running async
  *
  * Returns:     Nothing
  *
  * Notes:	The previous command was completely finished, start
  *		a new one if possible.
  */
-static void scsi_run_queue(struct request_queue *q)
+static void __scsi_run_queue(struct request_queue *q, bool async)
 {
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost;
@@ -438,13 +439,30 @@ static void scsi_run_queue(struct request_queue *q)
 			continue;
 		}
 
-		blk_run_queue_async(sdev->request_queue);
+		spin_unlock(shost->host_lock);
+		spin_lock(sdev->request_queue->queue_lock);
+		__blk_run_queue(sdev->request_queue);
+		spin_unlock(sdev->request_queue->queue_lock);
+		spin_lock(shost->host_lock);
 	}
 	/* put any unprocessed entries back */
 	list_splice(&starved_list, &shost->starved_list);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	blk_run_queue(q);
+	if (async)
+		blk_run_queue_async(q);
+	else
+		blk_run_queue(q);
+}
+
+static void scsi_run_queue(struct request_queue *q)
+{
+	__scsi_run_queue(q, false);
+}
+
+static void scsi_run_queue_async(struct request_queue *q)
+{
+	__scsi_run_queue(q, true);
 }
 
 /*

-- 
Jens Axboe

