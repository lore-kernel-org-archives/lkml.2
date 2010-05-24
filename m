Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab0EXX35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:29:57 -0400
Received: from kroah.org ([198.145.64.141]:59386 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409Ab0EXXXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:38 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:14 2010
Message-Id: <20100524231814.638054739@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stefan Weinhuber <wein@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [16/39] [S390] dasd: fix race between tasklet and dasd_sleep_on
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stefan Weinhuber <wein@de.ibm.com>

commit 1c1e093cbf6d3a7576ba0bd10363362a1c5c74ee upstream.

The various dasd_sleep_on functions use a global wait queue when
waiting for a cqr. The wait condition checks the status and devlist
fields of the cqr to determine if it is safe to continue. This
evaluation may return true, although the tasklet has not finished
processing of the cqr and the callback function has not been called
yet. When the callback is finally called, the data in the cqr may
already be invalid. The sleep_on wait condition needs a safe way to
determine if the tasklet has finished processing. Use the
callback_data field of the cqr to store a token, which is set by
the callback function itself.

Signed-off-by: Stefan Weinhuber <wein@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/s390/block/dasd.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -35,6 +35,9 @@
  */
 #define DASD_CHANQ_MAX_SIZE 4
 
+#define DASD_SLEEPON_START_TAG	(void *) 1
+#define DASD_SLEEPON_END_TAG	(void *) 2
+
 /*
  * SECTION: exported variables of dasd.c
  */
@@ -1460,7 +1463,10 @@ void dasd_add_request_tail(struct dasd_c
  */
 static void dasd_wakeup_cb(struct dasd_ccw_req *cqr, void *data)
 {
-	wake_up((wait_queue_head_t *) data);
+	spin_lock_irq(get_ccwdev_lock(cqr->startdev->cdev));
+	cqr->callback_data = DASD_SLEEPON_END_TAG;
+	spin_unlock_irq(get_ccwdev_lock(cqr->startdev->cdev));
+	wake_up(&generic_waitq);
 }
 
 static inline int _wait_for_wakeup(struct dasd_ccw_req *cqr)
@@ -1470,10 +1476,7 @@ static inline int _wait_for_wakeup(struc
 
 	device = cqr->startdev;
 	spin_lock_irq(get_ccwdev_lock(device->cdev));
-	rc = ((cqr->status == DASD_CQR_DONE ||
-	       cqr->status == DASD_CQR_NEED_ERP ||
-	       cqr->status == DASD_CQR_TERMINATED) &&
-	      list_empty(&cqr->devlist));
+	rc = (cqr->callback_data == DASD_SLEEPON_END_TAG);
 	spin_unlock_irq(get_ccwdev_lock(device->cdev));
 	return rc;
 }
@@ -1561,7 +1564,7 @@ static int _dasd_sleep_on(struct dasd_cc
 			wait_event(generic_waitq, !(device->stopped));
 
 		cqr->callback = dasd_wakeup_cb;
-		cqr->callback_data = (void *) &generic_waitq;
+		cqr->callback_data = DASD_SLEEPON_START_TAG;
 		dasd_add_request_tail(cqr);
 		if (interruptible) {
 			rc = wait_event_interruptible(
@@ -1640,7 +1643,7 @@ int dasd_sleep_on_immediatly(struct dasd
 	}
 
 	cqr->callback = dasd_wakeup_cb;
-	cqr->callback_data = (void *) &generic_waitq;
+	cqr->callback_data = DASD_SLEEPON_START_TAG;
 	cqr->status = DASD_CQR_QUEUED;
 	list_add(&cqr->devlist, &device->ccw_queue);
 


