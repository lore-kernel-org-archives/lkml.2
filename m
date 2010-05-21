Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934411Ab0EURB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:01:56 -0400
Received: from kroah.org ([198.145.64.141]:39074 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934194Ab0EUQyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:14 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Stefani Seibold <stefani@seibold.net>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/38] driver-core: fix potential race condition in drivers/base/dd.c
Date: Fri, 21 May 2010 09:53:35 -0700
Message-Id: <1274460848-11377-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This patch fix a potential race condition in the driver_bound() function
in the file driver/base/dd.c.

The broadcast of the BUS_NOTIFY_BOUND_DRIVER notifier should be done
after adding the new device to the driver list. Otherwise notifier
listener will fail if they use functions like usb_find_interface().

The patch is against kernel 2.6.33. Please merge it.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/dd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index c89291f..503c262 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -40,11 +40,11 @@ static void driver_bound(struct device *dev)
 	pr_debug("driver: '%s': %s: bound to device '%s'\n", dev_name(dev),
 		 __func__, dev->driver->name);
 
+	klist_add_tail(&dev->p->knode_driver, &dev->driver->p->klist_devices);
+
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_BOUND_DRIVER, dev);
-
-	klist_add_tail(&dev->p->knode_driver, &dev->driver->p->klist_devices);
 }
 
 static int driver_sysfs_add(struct device *dev)
-- 
1.7.0.3

