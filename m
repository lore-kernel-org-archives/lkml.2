Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0JZBMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:12:16 -0400
Received: from bunsen.bytemark.co.uk ([80.68.81.6]:41018 "EHLO
	bunsen.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab0JZBMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:12:13 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, "Emilio G. Cota" <cota@braap.org>
Subject: [PATCH 21/30] staging/vme: keep a list of registered buses (bridges)
Date: Mon, 25 Oct 2010 21:11:07 -0400
Message-Id: <1288055476-19438-22-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1288055476-19438-1-git-send-email-cota@braap.org>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

This paves the way for upcoming changes.

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/vme.c        |   25 ++++++++++++++++---------
 drivers/staging/vme/vme_bridge.h |    1 +
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index 357748e..10a6435 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -34,8 +34,12 @@
 #include "vme.h"
 #include "vme_bridge.h"
 
-/* Bitmask and mutex to keep track of bridge numbers */
+/*
+ * List of registered buses (bridges) and available bus numbers, both protected
+ * by the same mutex.
+ */
 static unsigned int vme_bus_numbers;
+static LIST_HEAD(vme_buses_list);
 static DEFINE_MUTEX(vme_buses_lock);
 
 static void __exit vme_exit(void);
@@ -1308,8 +1312,9 @@ EXPORT_SYMBOL(vme_slot_get);
 /* - Bridge Registration --------------------------------------------------- */
 
 /* call with vme_buses_lock held */
-static int __vme_alloc_bus_num(int *bus)
+static int __vme_register_bus(struct vme_bridge *bridge)
 {
+	int *bus = &bridge->num;
 	int index;
 
 	if (*bus == -1) {
@@ -1331,24 +1336,26 @@ static int __vme_alloc_bus_num(int *bus)
 			return -EBUSY;
 		}
 	}
+	list_add_tail(&bridge->buses_list, &vme_buses_list);
 	vme_bus_numbers |= 1 << *bus;
 	return 0;
 }
 
-static int vme_alloc_bus_num(int *bus)
+static int vme_register_bus(struct vme_bridge *bridge)
 {
 	int ret;
 
 	mutex_lock(&vme_buses_lock);
-	ret = __vme_alloc_bus_num(bus);
+	ret = __vme_register_bus(bridge);
 	mutex_unlock(&vme_buses_lock);
 	return ret;
 }
 
-static void vme_free_bus_num(int bus)
+static void vme_unregister_bus(struct vme_bridge *bridge)
 {
 	mutex_lock(&vme_buses_lock);
-	vme_bus_numbers &= ~(0x1 << bus);
+	vme_bus_numbers &= ~(0x1 << bridge->num);
+	list_del(&bridge->buses_list);
 	mutex_unlock(&vme_buses_lock);
 }
 
@@ -1363,7 +1370,7 @@ int vme_register_bridge(struct vme_bridge *bridge)
 	int retval;
 	int i;
 
-	retval = vme_alloc_bus_num(&bridge->num);
+	retval = vme_register_bus(bridge);
 	if (retval)
 		return retval;
 
@@ -1399,7 +1406,7 @@ err_reg:
 		dev = &bridge->dev[i];
 		device_unregister(dev);
 	}
-	vme_free_bus_num(bridge->num);
+	vme_unregister_bus(bridge);
 	return retval;
 }
 EXPORT_SYMBOL(vme_register_bridge);
@@ -1414,7 +1421,7 @@ void vme_unregister_bridge(struct vme_bridge *bridge)
 		dev = &bridge->dev[i];
 		device_unregister(dev);
 	}
-	vme_free_bus_num(bridge->num);
+	vme_unregister_bus(bridge);
 }
 EXPORT_SYMBOL(vme_unregister_bridge);
 
diff --git a/drivers/staging/vme/vme_bridge.h b/drivers/staging/vme/vme_bridge.h
index 4c6ec31..3bb1d7b 100644
--- a/drivers/staging/vme/vme_bridge.h
+++ b/drivers/staging/vme/vme_bridge.h
@@ -113,6 +113,7 @@ struct vme_bridge {
 
 	/* Bridge Info - XXX Move to private structure? */
 	struct device *parent;	/* Generic device struct (pdev->dev for PCI) */
+	struct list_head buses_list;
 	void *driver_priv;	/* Private pointer for the bridge driver */
 
 	struct device dev[VME_SLOTS_MAX];	/* Device registered with
-- 
1.7.1

