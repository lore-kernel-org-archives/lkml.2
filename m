Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab0CVRjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 13:39:15 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1997 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984Ab0CVRjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:39:14 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Hugh Daschbach" <hdasch@broadcom.com>
To: "Alan Stern" <stern@rowland.harvard.edu>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org
cc: "Bhanu Gollapudi" <bprakash@broadcom.com>,
       "Hugh Daschbach" <hdasch@broadcom.com>
Subject: [PATCH] Protect device shutdown from hot unplug events.
Date: Mon, 22 Mar 2010 10:36:37 -0700
Message-ID: <1269279397-9884-1-git-send-email-hdasch@broadcom.com>
X-Mailer: git-send-email 1.6.6
MIME-Version: 1.0
X-WSS-ID: 67B974A531G67495942-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While device_shutdown() walks through devices_kset to shutdown all
devices, device unplug events may race to shutdown individual devices.
Specifically, sd_shutdown(), on behalf of fc_starget_delete(), has
been observed deleting devices during device_shutdown()'s list
traversal.  So we factor out list_for_each_entry_safe_reverse(...) in
favor of while (!list_empty(...)).

Signed-off-by: Hugh Daschbach <hdasch@broadcom.com>
---
 drivers/base/core.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index ef55df3..ac4c09a 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1729,10 +1729,25 @@ EXPORT_SYMBOL_GPL(device_move);
  */
 void device_shutdown(void)
 {
-	struct device *dev, *devn;
+	struct device *dev;
+
+	spin_lock(&devices_kset->list_lock);
+	/* 
+	 * Walk the devices list backward, shutting down each in turn.
+	 * Beware that device unplug events may also start pulling
+	 * devices offline, even as the system is shutting down.
+	 */
+	while (!list_empty(&devices_kset->list)) {
+		dev = list_entry(devices_kset->list.prev, struct device,
+				kobj.entry);
+		get_device(dev);
+		/*
+		 * Make sure the device is off the kset list, in the
+		 * event that dev->*->shutdown() doesn't remove it.
+		 */
+		list_del_init(&dev->kobj.entry);
+		spin_unlock(&devices_kset->list_lock);
 
-	list_for_each_entry_safe_reverse(dev, devn, &devices_kset->list,
-				kobj.entry) {
 		if (dev->bus && dev->bus->shutdown) {
 			dev_dbg(dev, "shutdown\n");
 			dev->bus->shutdown(dev);
@@ -1740,6 +1755,10 @@ void device_shutdown(void)
 			dev_dbg(dev, "shutdown\n");
 			dev->driver->shutdown(dev);
 		}
+		put_device(dev);
+
+		spin_lock(&devices_kset->list_lock);
 	}
+	spin_unlock(&devices_kset->list_lock);
 	async_synchronize_full();
 }
-- 
1.7.0.rc0.48.gdace5


