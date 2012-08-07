Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab2HGXTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:19:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56801 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964938Ab2HGWgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:36:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dariusz Majchrzak <dariusz.majchrzak@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 012/109] SCSI: fix hot unplug vs async scan race
Date: Tue,  7 Aug 2012 15:34:31 -0700
Message-Id: <20120807222044.158161519@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_scan.c  |    3 +++
 drivers/scsi/scsi_sysfs.c |   41 ++++++++++++++++++++++++++---------------
 2 files changed, 29 insertions(+), 15 deletions(-)

--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1714,6 +1714,9 @@ static void scsi_sysfs_add_devices(struc
 {
 	struct scsi_device *sdev;
 	shost_for_each_device(sdev, shost) {
+		/* target removed before the device could be added */
+		if (sdev->sdev_state == SDEV_DEL)
+			continue;
 		if (!scsi_host_scan_allowed(shost) ||
 		    scsi_sysfs_add_sdev(sdev) != 0)
 			__scsi_remove_device(sdev);
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1000,7 +1000,6 @@ static void __scsi_remove_target(struct
 	struct scsi_device *sdev;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	starget->reap_ref++;
  restart:
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->channel != starget->channel ||
@@ -1014,14 +1013,6 @@ static void __scsi_remove_target(struct
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
@@ -1034,14 +1025,34 @@ static int __remove_child (struct device
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
 


