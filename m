Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab2GBRIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 13:08:23 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:55265 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab2GBRIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 13:08:21 -0400
Date: Mon, 2 Jul 2012 19:08:15 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@c4eb
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] driver core: move uevent call to driver_register
Message-ID: <alpine.LFD.2.02.1207021900100.1784@c4eb>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
x-cbid: 12070217-8372-0000-0000-0000030F63F8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Device driver attribute groups are created after userspace is notified
via an add event. Fix this by moving the kobject_uevent call to
driver_register after the attribute groups are added.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
---
 drivers/base/bus.c    |    1 -
 drivers/base/driver.c |    3 +++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -743,7 +743,6 @@ int bus_add_driver(struct device_driver 
 		}
 	}
 
-	kobject_uevent(&priv->kobj, KOBJ_ADD);
 	return 0;
 
 out_unregister:
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -187,6 +187,9 @@ int driver_register(struct device_driver
 	ret = driver_add_groups(drv, drv->groups);
 	if (ret)
 		bus_remove_driver(drv);
+
+	kobject_uevent(&drv->p->kobj, KOBJ_ADD);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(driver_register);

