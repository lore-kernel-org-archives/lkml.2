Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538Ab0EUQ7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:59:55 -0400
Received: from kroah.org ([198.145.64.141]:39118 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934245Ab0EUQyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:23 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Hugh Daschbach <hdasch@broadcom.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/38] Driver core: Protect device shutdown from hot unplug events.
Date: Fri, 21 May 2010 09:53:46 -0700
Message-Id: <1274460848-11377-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Daschbach <hdasch@broadcom.com>

While device_shutdown() walks through devices_kset to shutdown all
devices, device unplug events may race to shutdown individual devices.
Specifically, sd_shutdown(), on behalf of fc_starget_delete(), has
been observed deleting devices during device_shutdown()'s list
traversal.  So we factor out list_for_each_entry_safe_reverse(...) in
favor of while (!list_empty(...)).

Signed-off-by: Hugh Daschbach <hdasch@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 4c5be85..356dd01 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1734,10 +1734,25 @@ EXPORT_SYMBOL_GPL(device_move);
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
@@ -1745,6 +1760,10 @@ void device_shutdown(void)
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
1.7.0.3

