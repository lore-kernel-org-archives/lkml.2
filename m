Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab2GaFA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 01:00:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48665 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755500Ab2GaEu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:29 -0400
Message-Id: <20120731044320.435459483@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:44:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Williams <dan.j.williams@intel.com>,
        Dariusz Majchrzak <dariusz.majchrzak@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 57/73] [SCSI] fix hot unplug vs async scan race
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 3b661a92e869ebe2358de8f4b3230ad84f7fce51 upstream.

The following crash results from cases where the end_device has been
removed before scsi_sysfs_add_sdev has had a chance to run.

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000098
 IP: [<ffffffff8115e100>] sysfs_create_dir+0x32/0xb6
 ...
 Call Trace:
  [<ffffffff8125e4a8>] kobject_add_internal+0x120/0x1e3
  [<ffffffff81075149>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff8125e641>] kobject_add_varg+0x41/0x50
  [<ffffffff8125e70b>] kobject_add+0x64/0x66
  [<ffffffff8131122b>] device_add+0x12d/0x63a
  [<ffffffff814b65ea>] ? _raw_spin_unlock_irqrestore+0x47/0x56
  [<ffffffff8107de15>] ? module_refcount+0x89/0xa0
  [<ffffffff8132f348>] scsi_sysfs_add_sdev+0x4e/0x28a
  [<ffffffff8132dcbb>] do_scan_async+0x9c/0x145

...teach scsi_sysfs_add_devices() to check for deleted devices() before
trying to add them, and teach scsi_remove_target() how to remove targets
that have not been added via device_add().

Reported-by: Dariusz Majchrzak <dariusz.majchrzak@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/scsi_scan.c  |    3 +++
 drivers/scsi/scsi_sysfs.c |   41 ++++++++++++++++++++++++++---------------
 2 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 2e5fe58..f55e5f1 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1717,6 +1717,9 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
 	shost_for_each_device(sdev, shost) {
+		/* target removed before the device could be added */
+		if (sdev->sdev_state == SDEV_DEL)
+			continue;
 		if (!scsi_host_scan_allowed(shost) ||
 		    scsi_sysfs_add_sdev(sdev) != 0)
 			__scsi_remove_device(sdev);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d19d7e9..093d4f6 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1005,7 +1005,6 @@ static void __scsi_remove_target(struct scsi_target *starget)
 	struct scsi_device *sdev;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	starget->reap_ref++;
  restart:
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->channel != starget->channel ||
@@ -1019,14 +1018,6 @@ static void __scsi_remove_target(struct scsi_target *starget)
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	scsi_target_reap(starget);
-}
-
-static int __remove_child (struct device * dev, void * data)
-{
-	if (scsi_is_target_device(dev))
-		__scsi_remove_target(to_scsi_target(dev));
-	return 0;
 }
 
 /**
@@ -1039,14 +1030,34 @@ static int __remove_child (struct device * dev, void * data)
  */
 void scsi_remove_target(struct device *dev)
 {
-	if (scsi_is_target_device(dev)) {
-		__scsi_remove_target(to_scsi_target(dev));
-		return;
+	struct Scsi_Host *shost = dev_to_shost(dev->parent);
+	struct scsi_target *starget, *found;
+	unsigned long flags;
+
+ restart:
+	found = NULL;
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_for_each_entry(starget, &shost->__targets, siblings) {
+		if (starget->state == STARGET_DEL)
+			continue;
+		if (starget->dev.parent == dev || &starget->dev == dev) {
+			found = starget;
+			found->reap_ref++;
+			break;
+		}
 	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	get_device(dev);
-	device_for_each_child(dev, NULL, __remove_child);
-	put_device(dev);
+	if (found) {
+		__scsi_remove_target(found);
+		scsi_target_reap(found);
+		/* in the case where @dev has multiple starget children,
+		 * continue removing.
+		 *
+		 * FIXME: does such a case exist?
+		 */
+		goto restart;
+	}
 }
 EXPORT_SYMBOL(scsi_remove_target);
 


