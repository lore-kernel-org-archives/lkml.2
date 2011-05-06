Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab1EFAVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:21:11 -0400
Received: from kroah.org ([198.145.64.141]:32777 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab1EFANL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:11 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:07 2011
Message-Id: <20110506001207.541488993@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:10:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Snitzer <snitzer@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [patch 03/38] [SCSI] scsi_dh: fix reference counting in scsi_dh_activate error path
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 0b8393578c70bc1f09790eeae7d918f38da2e010 upstream.

Commit db422318cbca55168cf965f655471dbf8be82433 ([SCSI] scsi_dh:
propagate SCSI device deletion) introduced a regression where the device
reference is not dropped prior to scsi_dh_activate's early return from
the error path.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/device_handler/scsi_dh.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -437,12 +437,14 @@ int scsi_dh_activate(struct request_queu
 	unsigned long flags;
 	struct scsi_device *sdev;
 	struct scsi_device_handler *scsi_dh = NULL;
+	struct device *dev = NULL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	sdev = q->queuedata;
 	if (sdev && sdev->scsi_dh_data)
 		scsi_dh = sdev->scsi_dh_data->scsi_dh;
-	if (!scsi_dh || !get_device(&sdev->sdev_gendev) ||
+	dev = get_device(&sdev->sdev_gendev);
+	if (!scsi_dh || !dev ||
 	    sdev->sdev_state == SDEV_CANCEL ||
 	    sdev->sdev_state == SDEV_DEL)
 		err = SCSI_DH_NOSYS;
@@ -453,12 +455,13 @@ int scsi_dh_activate(struct request_queu
 	if (err) {
 		if (fn)
 			fn(data, err);
-		return err;
+		goto out;
 	}
 
 	if (scsi_dh->activate)
 		err = scsi_dh->activate(sdev, fn, data);
-	put_device(&sdev->sdev_gendev);
+out:
+	put_device(dev);
 	return err;
 }
 EXPORT_SYMBOL_GPL(scsi_dh_activate);


