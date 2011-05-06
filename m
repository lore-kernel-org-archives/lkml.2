Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab1EFAYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:24:35 -0400
Received: from kroah.org ([198.145.64.141]:36635 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089Ab1EFAY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:29 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:07 2011
Message-Id: <20110506002207.894747486@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        James Bottomley <James.Bottomley@suse.de>
Subject: [028/143] [SCSI] put stricter guards on queue dead checks
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 drivers/scsi/scsi_sysfs.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -318,14 +318,8 @@ static void scsi_device_dev_release_user
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
 
@@ -925,6 +919,12 @@ void __scsi_remove_device(struct scsi_de
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
 


