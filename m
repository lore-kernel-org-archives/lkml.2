Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab2I1Aw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 20:52:58 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:40752 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2I1Aw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 20:52:56 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Ming Lei <ming.lei@canonical.com>, <stable@vger.kernel.org>
Subject: [PATCH] driver core: fix possible missing of device probe
Date: Fri, 28 Sep 2012 08:52:43 +0800
Message-Id: <1348793563-19186-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inside bus_add_driver(), one device might be added into
the bus or probed which is triggered by deferred probe
just after completing of driver_attach() and before
'klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers)',
so the device won't be probed by this driver.

This patch moves the below line

	'klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers)'

before driver_attach() inside bus_add_driver().

So fixes the problem since the below way can guarantee that
no probe(dev) may be lost.

CPU0                            	CPU1
driver_register
	...
	write(bus->driver_list)
	smp_mb()
	read(bus->device_list)
	...
					device_add
						/* bus_add_device */
						write(bus->device_list)
						smp_mb()
						/* bus_probe_device*/
						read(bus->driver_list)

And the smp_mb() has been implicit by UNLOCK+LOCK
of 'klist' according to 'VARIETIES OF MEMORY BARRIER' part
of Documentation/memory-barriers.txt.

Reported-and-Tested-by: Russell King <linux@arm.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 181ed26..3b5bddb 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -714,12 +714,12 @@ int bus_add_driver(struct device_driver *drv)
 	if (error)
 		goto out_unregister;
 
+	klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers);
 	if (drv->bus->p->drivers_autoprobe) {
 		error = driver_attach(drv);
 		if (error)
 			goto out_unregister;
 	}
-	klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers);
 	module_add_driver(drv->owner, drv);
 
 	error = driver_create_file(drv, &driver_attr_uevent);
-- 
1.7.9.5

