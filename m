Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab1HAKaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 06:30:07 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:44742 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab1HAK3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 06:29:36 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <gregkh@suse.de>
CC: <martyn.welch@ge.com>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 4/8] staging: vme: keep track of registered buses
Date: Mon, 1 Aug 2011 12:20:49 +0200
Message-ID: <1312194053-32310-5-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a list which keeps track of all registered VME
buses. This is required for adding refcounting later to bridge
modules, something that is not currently implemented.

This is based on the changes introduced by Emilio G. Cota in the
patch:

    https://lkml.org/lkml/2010/10/25/486

Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/staging/vme/vme.c        |   46 ++++++++++++++++++++-----------------
 drivers/staging/vme/vme_bridge.h |    1 +
 2 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index bbede97..11e28ca 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -34,9 +34,10 @@
 #include "vme.h"
 #include "vme_bridge.h"
 
-/* Bitmask and mutex to keep track of bridge numbers */
+/* Bitmask and list of registered buses both protected by common mutex */
 static unsigned int vme_bus_numbers;
-static DEFINE_MUTEX(vme_bus_num_mtx);
+static LIST_HEAD(vme_bus_list);
+static DEFINE_MUTEX(vme_buses_lock);
 
 static void __exit vme_exit(void);
 static int __init vme_init(void);
@@ -1305,11 +1306,12 @@ EXPORT_SYMBOL(vme_slot_get);
 
 /* - Bridge Registration --------------------------------------------------- */
 
-/* call with vme_bus_num_mtx held */
-static int __vme_alloc_bus_num(int bus_num)
+/* call with vme_buses_lock held */
+static int __vme_add_bus(struct vme_bridge *bridge)
 {
 	int num;
 	int i;
+	int bus_num = bridge->num;
 
 	if (bus_num == -1) {
 		/* try to find a free bus number */
@@ -1331,25 +1333,29 @@ static int __vme_alloc_bus_num(int bus_num)
 		}
 		num = bus_num;
 	}
+	bridge->num = num;
+	list_add_tail(&bridge->bus_list, &vme_bus_list);
 	vme_bus_numbers |= 1 << num;
-	return num;
+	return 0;
 }
 
-static int vme_alloc_bus_num(int bus_num)
+static int vme_add_bus(struct vme_bridge *bridge)
 {
-	int num;
+	int ret;
 
-	mutex_lock(&vme_bus_num_mtx);
-	num = __vme_alloc_bus_num(bus_num);
-	mutex_unlock(&vme_bus_num_mtx);
-	return num;
+	mutex_lock(&vme_buses_lock);
+	ret = __vme_add_bus(bridge);
+	mutex_unlock(&vme_buses_lock);
+
+	return ret;
 }
 
-static void vme_free_bus_num(int bus)
+static void vme_remove_bus(struct vme_bridge *bridge)
 {
-	mutex_lock(&vme_bus_num_mtx);
-	vme_bus_numbers &= ~(0x1 << bus);
-	mutex_unlock(&vme_bus_num_mtx);
+	mutex_lock(&vme_buses_lock);
+	vme_bus_numbers &= ~(1 << bridge->num);
+	list_del(&bridge->bus_list);
+	mutex_unlock(&vme_buses_lock);
 }
 
 int vme_register_bridge(struct vme_bridge *bridge)
@@ -1358,12 +1364,10 @@ int vme_register_bridge(struct vme_bridge *bridge)
 	int retval;
 	int i;
 
-	retval = vme_alloc_bus_num(bridge->num);
-	if (retval < 0)
+	retval = vme_add_bus(bridge);
+	if (retval)
 		return retval;
 
-	bridge->num = retval;
-
 	/* This creates 32 vme "slot" devices. This equates to a slot for each
 	 * ID available in a system conforming to the ANSI/VITA 1-1994
 	 * specification.
@@ -1394,7 +1398,7 @@ err_reg:
 		dev = &bridge->dev[i];
 		device_unregister(dev);
 	}
-	vme_free_bus_num(bridge->num);
+	vme_remove_bus(bridge);
 	return retval;
 }
 EXPORT_SYMBOL(vme_register_bridge);
@@ -1409,7 +1413,7 @@ void vme_unregister_bridge(struct vme_bridge *bridge)
 		dev = &bridge->dev[i];
 		device_unregister(dev);
 	}
-	vme_free_bus_num(bridge->num);
+	vme_remove_bus(bridge);
 }
 EXPORT_SYMBOL(vme_unregister_bridge);
 
diff --git a/drivers/staging/vme/vme_bridge.h b/drivers/staging/vme/vme_bridge.h
index a9084f0..8959670 100644
--- a/drivers/staging/vme/vme_bridge.h
+++ b/drivers/staging/vme/vme_bridge.h
@@ -112,6 +112,7 @@ struct vme_bridge {
 	/* Bridge Info - XXX Move to private structure? */
 	struct device *parent;	/* Parent device (eg. pdev->dev for PCI) */
 	void *driver_priv;	/* Private pointer for the bridge driver */
+	struct list_head bus_list; /* list of VME buses */
 
 	struct device dev[VME_SLOTS_MAX];	/* Device registered with
 						 * device model on VME bus
-- 
1.7.4.1

