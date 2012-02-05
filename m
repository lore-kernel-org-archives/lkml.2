Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab2BEW0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:19 -0500
Received: from 1wt.eu ([62.212.114.60]:61801 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab2BEW0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:07 -0500
Message-Id: <20120205220949.707168395@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:09:55 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: James Bottomley <James.Bottomley@suse.de>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 06/91] put stricter guards on queue dead checks
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 1 files changed, 8 insertions(+), 8 deletions(-)

Index: longterm-2.6.27/drivers/scsi/scsi_sysfs.c
===================================================================
--- longterm-2.6.27.orig/drivers/scsi/scsi_sysfs.c	2012-02-05 22:34:34.876915660 +0100
+++ longterm-2.6.27/drivers/scsi/scsi_sysfs.c	2012-02-05 22:34:35.776914691 +0100
@@ -317,14 +317,8 @@
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
 
@@ -950,6 +944,12 @@
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
 


