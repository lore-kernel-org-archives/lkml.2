Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab2EVWFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:05:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758062Ab2EVWFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:05:51 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        USB list <linux-usb@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] device-core: Ensure drvdata = NULL when no driver is bound
Date: Wed, 23 May 2012 00:09:34 +0200
Message-Id: <1337724574-2193-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) drvdata is for a driver to store a pointer to driver specific data
2) If no driver is bound, there is no driver specific data associated with
   the device
3) Thus logically drvdata should be NULL if no driver is bound.

But many drivers don't clear drvdata on device_release, or set drvdata
early on in probe and leave it set on probe error. Both of which results
in a dangling pointer in drvdata.

This patch enforce for drvdata to be NULL after device_release or on probe
failure.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/base/dd.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 1b1cbb5..9a1e970 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -283,6 +283,7 @@ probe_failed:
 	devres_release_all(dev);
 	driver_sysfs_remove(dev);
 	dev->driver = NULL;
+	dev_set_drvdata(dev, NULL);
 
 	if (ret == -EPROBE_DEFER) {
 		/* Driver requested deferred probing */
@@ -487,6 +488,7 @@ static void __device_release_driver(struct device *dev)
 			drv->remove(dev);
 		devres_release_all(dev);
 		dev->driver = NULL;
+		dev_set_drvdata(dev, NULL);
 		klist_remove(&dev->p->knode_driver);
 		if (dev->bus)
 			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
-- 
1.7.10

