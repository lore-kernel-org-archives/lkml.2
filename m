Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab2KSPfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:35:34 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58446 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab2KSPfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:35:33 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v1] driver core: fix possible missing of device probe
Date: Mon, 19 Nov 2012 23:35:17 +0800
Message-Id: <1353339317-31272-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inside bus_add_driver(), one device might be added(device_add()) into
the bus or probed which is triggered by deferred probe
just after completing of driver_attach() and before
'klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers)',
so the device won't be probed by this driver.

This patch moves the below line

	'klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers)'

before driver_attach() inside bus_add_driver() to fix the
problem.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
v1:
	- remove memory barrier part of previous commit log because
	klist lock of 'bus->p->klist_drivers' is held during both
	adding driver into the list and iterating the driver list,
	so the new added driver can always be perceived immediately
	on other CPUs.
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

