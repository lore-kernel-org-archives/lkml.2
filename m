Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab2FKFOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 01:14:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48027 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab2FKFOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 01:14:36 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org
Subject: [PATCH] driver core: fix shutdown races with probe/remove(v2)
Date: Mon, 11 Jun 2012 13:13:20 +0800
Message-Id: <1339391600-17815-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firstly, .shutdown callback may touch a uninitialized hardware
if dev->driver is set and .probe is not completed.

Secondly, device_shutdown() may dereference a null pointer to cause
oops when dev->driver is cleared after it is checked in
device_shutdown().

So just try to hold device lock and its parent lock(if it has) to
fix the races.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
v2:
	- take Alan's suggestion to use device_trylock to avoid
	hanging during shutdown by buggy device or driver
	- hold parent reference counter

 drivers/base/core.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 346be8b..f2fc989 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1796,6 +1796,16 @@ out:
 }
 EXPORT_SYMBOL_GPL(device_move);
 
+static int __try_lock(struct device *dev)
+{
+	int i = 0;
+
+	while (!device_trylock(dev) && i++ < 100)
+		msleep(10);
+
+	return i < 100;
+}
+
 /**
  * device_shutdown - call ->shutdown() on each device to shutdown.
  */
@@ -1810,8 +1820,11 @@ void device_shutdown(void)
 	 * devices offline, even as the system is shutting down.
 	 */
 	while (!list_empty(&devices_kset->list)) {
+		int nonlocked;
+
 		dev = list_entry(devices_kset->list.prev, struct device,
 				kobj.entry);
+		get_device(dev->parent);
 		get_device(dev);
 		/*
 		 * Make sure the device is off the kset list, in the
@@ -1820,6 +1833,18 @@ void device_shutdown(void)
 		list_del_init(&dev->kobj.entry);
 		spin_unlock(&devices_kset->list_lock);
 
+		/* hold lock to avoid race with .probe/.release */
+		if (dev->parent && !__try_lock(dev->parent))
+			nonlocked = 2;
+		else if (!__try_lock(dev))
+			nonlocked = 1;
+		else
+			nonlocked = 0;
+
+		if (nonlocked)
+			dev_err(dev, "can't hold %slock for shutdown\n",
+					nonlocked == 1 ? "" : "parent ");
+
 		/* Don't allow any more runtime suspends */
 		pm_runtime_get_noresume(dev);
 		pm_runtime_barrier(dev);
@@ -1831,7 +1856,14 @@ void device_shutdown(void)
 			dev_dbg(dev, "shutdown\n");
 			dev->driver->shutdown(dev);
 		}
+
+		if (!nonlocked)
+			device_unlock(dev);
+		if (dev->parent && nonlocked != 2)
+			device_unlock(dev->parent);
+
 		put_device(dev);
+		put_device(dev->parent);
 
 		spin_lock(&devices_kset->list_lock);
 	}
-- 
1.7.9.5

