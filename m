Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab2CMAXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:23:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:48063 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758643Ab2CMAXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:09 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, James Bottomley <James.Bottomley@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 106/196] put stricter guards on queue dead checks
Date: Mon, 12 Mar 2012 20:20:19 -0400
Message-Id: <1331598109-31424-61-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/scsi_sysfs.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 02be251..ed3b52f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -319,14 +319,8 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
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
 
@@ -964,6 +958,12 @@ void __scsi_remove_device(struct scsi_device *sdev)
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
 
-- 
1.7.9.3

