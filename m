Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab1EJGko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 02:40:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:49496 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab1EJGkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 02:40:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,345,1301900400"; 
   d="scan'208";a="744896517"
Subject: Perfromance drop on SCSI hard disk
From: "Alex,Shi" <alex.shi@intel.com>
To: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com
Cc: "Li, Shaohua" <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 14:40:00 +0800
Message-ID: <1305009600.21534.587.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c21e6beba8835d09bb80e34961 removed the REENTER flag and changed
scsi_run_queue() to punt all requests on starved_list devices to
kblockd. Yes, like Jens mentioned, the performance on slow SCSI disk was
hurt here.  :) (Intel SSD isn't effected here)

In our testing on 12 SAS disk JBD, the fio write with sync ioengine drop
about 30~40% throughput, fio randread/randwrite with aio ioengine drop
about 20%/50% throughput. and fio mmap testing was hurt also. 

With the following debug patch, the performance can be totally recovered
in our testing. But without REENTER flag here, in some corner case, like
a device is keeping blocked and then unblocked repeatedly,
__blk_run_queue() may recursively call scsi_run_queue() and then cause
kernel stack overflow. 
I don't know details of block device driver, just wondering why on scsi
need the REENTER flag here. :) 

James, do you have some idea on this. 

Regards
Alex
======
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e9901b8..24e8589 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -432,8 +432,11 @@ static void scsi_run_queue(struct request_queue *q)
 				       &shost->starved_list);
 			continue;
 		}
-
-		blk_run_queue_async(sdev->request_queue);
+		spin_unlock(shost->host_lock);
+		spin_lock(sdev->request_queue->queue_lock);
+		__blk_run_queue(sdev->request_queue);
+		spin_unlock(sdev->request_queue->queue_lock);
+		spin_lock(shost->host_lock);
 	}
 	/* put any unprocessed entries back */
 	list_splice(&starved_list, &shost->starved_list);







