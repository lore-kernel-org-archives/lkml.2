Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab1G0Ajc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:39:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:18089 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab1G0AfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="32380349"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: James.Bottomley@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [20/98] put stricter guards on queue dead checks
Message-Id: <20110727003512.53DEF2403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: James Bottomley <James.Bottomley@suse.de>

commit 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b upstream.

SCSI uses request_queue->queuedata == NULL as a signal that the queue
is dying.  We set this state in the sdev release function.  However,
this allows a small window where we release the last reference but
haven't quite got to this stage yet and so something will try to take
a reference in scsi_request_fn and oops.  It's very rare, but we had a
report here, so we're pushing this as a bug fix

The actual fix is to set request_queue->queuedata to NULL in
scsi_remove_device() before we drop the reference.  This causes
correct automatic rejects from scsi_request_fn as people who hold
additional references try to submit work and prevents anything from
getting a new reference to the sdev that way.

Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/scsi_sysfs.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6.35.y/drivers/scsi/scsi_sysfs.c
===================================================================
--- linux-2.6.35.y.orig/drivers/scsi/scsi_sysfs.c
+++ linux-2.6.35.y/drivers/scsi/scsi_sysfs.c
@@ -319,14 +319,8 @@ static void scsi_device_dev_release_user
 		kfree(evt);
 	}
 
-	if (sdev->request_queue) {
-		sdev->request_queue->queuedata = NULL;
-		/* user context needed to free queue */
-		scsi_free_queue(sdev->request_queue);
-		/* temporary expedient, try to catch use of queue lock
-		 * after free of sdev */
-		sdev->request_queue = NULL;
-	}
+	/* NULL queue means the device can't be used */
+	sdev->request_queue = NULL;
 
 	scsi_target_reap(scsi_target(sdev));
 
@@ -961,6 +955,12 @@ void __scsi_remove_device(struct scsi_de
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
+
+	/* cause the request function to reject all I/O requests */
+	sdev->request_queue->queuedata = NULL;
+
+	/* Freeing the queue signals to block that we're done */
+	scsi_free_queue(sdev->request_queue);
 	put_device(dev);
 }
 
