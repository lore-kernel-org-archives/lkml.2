Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708Ab2FHFjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:39:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59962 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab2FHFjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:39:08 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org
Subject: [PATCH] driver core: fix shutdown races with probe/remove(v1)
Date: Fri,  8 Jun 2012 13:38:49 +0800
Message-Id: <1339133929-30679-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firstly, .shutdown callback may touch a uninitialized hardware
if dev->driver is set and .probe is not completed.

Secondly, device_shutdown() may dereference a null pointer to cause
oops when dev->driver is cleared after it is checked in
device_shutdown().

So just hold device lock and its parent lock if it has to fix the
races.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 346be8b..cbc8bd2 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1820,6 +1820,11 @@ void device_shutdown(void)
 		list_del_init(&dev->kobj.entry);
 		spin_unlock(&devices_kset->list_lock);
 
+		/*hold lock[s] to avoid races with .probe/.release*/
+		if (dev->parent)
+			device_lock(dev->parent);
+		device_lock(dev);
+
 		/* Don't allow any more runtime suspends */
 		pm_runtime_get_noresume(dev);
 		pm_runtime_barrier(dev);
@@ -1831,6 +1836,9 @@ void device_shutdown(void)
 			dev_dbg(dev, "shutdown\n");
 			dev->driver->shutdown(dev);
 		}
+		device_unlock(dev);
+		if (dev->parent)
+			device_unlock(dev->parent);
 		put_device(dev);
 
 		spin_lock(&devices_kset->list_lock);
-- 
1.7.9.5

