Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab2GXRmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 13:42:40 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:32959 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab2GXRmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 13:42:39 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] driver core: free devres in device_release
Date: Wed, 25 Jul 2012 01:42:29 +0800
Message-Id: <1343151749-16571-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

device_del can happen anytime, so once it happens,
the devres of the device will be freed inside device_del, but
drivers can't know it has been deleted and may still add
resources into the device, so memory leak is caused.

This patch moves the devres_release_all to fix the problem.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/base/core.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index f338037..c8fe4a5 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -184,6 +184,17 @@ static void device_release(struct kobject *kobj)
 	struct device *dev = kobj_to_dev(kobj);
 	struct device_private *p = dev->p;
 
+	/*
+	 * Some platform devices are driven without driver attached
+	 * and managed resources may have been acquired.  Make sure
+	 * all resources are released.
+	 *
+	 * Drivers still can add resources into device after device
+	 * is deleted but alive, so release devres here to avoid
+	 * possible memory leak.
+	 */
+	devres_release_all(dev);
+
 	if (dev->release)
 		dev->release(dev);
 	else if (dev->type && dev->type->release)
@@ -1196,13 +1207,6 @@ void device_del(struct device *dev)
 	bus_remove_device(dev);
 	driver_deferred_probe_del(dev);
 
-	/*
-	 * Some platform devices are driven without driver attached
-	 * and managed resources may have been acquired.  Make sure
-	 * all resources are released.
-	 */
-	devres_release_all(dev);
-
 	/* Notify the platform of the removal, in case they
 	 * need to do anything...
 	 */
-- 
1.7.9.5

