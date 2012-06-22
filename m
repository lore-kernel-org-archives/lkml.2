Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761991Ab2FVKCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 06:02:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39022 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761964Ab2FVKCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 06:02:30 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] driver core: fix shutdown races with probe/remove(v3)
Date: Fri, 22 Jun 2012 18:01:40 +0800
Message-Id: <1340359301-7468-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firstly, .shutdown callback may touch a uninitialized hardware
if dev->driver is set and .probe is not completed.

Secondly, device_shutdown() may dereference a null pointer to cause
oops when dev->driver is cleared after it has been checked in
device_shutdown().

So just hold device lock and its parent lock(if it has) to
fix the races.

Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
v3:
	- add comments on holding parent's reference count
	- acquire device lock directly instead of using device_trylock
	as required by Greg

v2:
	- take Alan's suggestion to use device_trylock to avoid
	hanging during shutdown by buggy device or driver
	- hold parent reference counter

 drivers/base/core.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 846d12b..65849a9 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1812,6 +1812,13 @@ void device_shutdown(void)
 	while (!list_empty(&devices_kset->list)) {
 		dev = list_entry(devices_kset->list.prev, struct device,
 				kobj.entry);
+
+		/*
+		 * hold reference count of device's parent to
+		 * prevent it from being freed because parent's
+		 * lock is to be held
+		 */
+		get_device(dev->parent);
 		get_device(dev);
 		/*
 		 * Make sure the device is off the kset list, in the
@@ -1820,6 +1827,11 @@ void device_shutdown(void)
 		list_del_init(&dev->kobj.entry);
 		spin_unlock(&devices_kset->list_lock);
 
+		/* hold lock to avoid race with probe/release */
+		if (dev->parent)
+			device_lock(dev->parent);
+		device_lock(dev);
+
 		/* Don't allow any more runtime suspends */
 		pm_runtime_get_noresume(dev);
 		pm_runtime_barrier(dev);
@@ -1831,7 +1843,13 @@ void device_shutdown(void)
 			dev_dbg(dev, "shutdown\n");
 			dev->driver->shutdown(dev);
 		}
+
+		device_unlock(dev);
+		if (dev->parent)
+			device_unlock(dev->parent);
+
 		put_device(dev);
+		put_device(dev->parent);
 
 		spin_lock(&devices_kset->list_lock);
 	}
-- 
1.7.9.5

