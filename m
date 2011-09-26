Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1IZJbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:31:34 -0400
Received: from cernmx31.cern.ch ([137.138.144.179]:43831 "EHLO
	CERNMX31.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1IZJbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:31:07 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <gregkh@suse.de>
CC: <martyn.welch@ge.com>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 3/4] staging: vme: get rid of struct vme_device_id and slots
Date: Mon, 26 Sep 2011 11:27:17 +0200
Message-ID: <1317029238-13357-4-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317029238-13357-1-git-send-email-manohar.vanga@cern.ch>
References: <1317029238-13357-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, the device-driver matching mechanism depended on the
vme_device_id structure due to the need for a bind table per driver.
This method of matching is no longer used so this patch merges the
fields of struct vme_device_id into struct vme_dev. Since this also
renders the slot field meaningless, it has also been removed in this
patch.

Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/staging/vme/devices/vme_user.c |    2 +-
 drivers/staging/vme/vme.c              |    8 +++-----
 drivers/staging/vme/vme.h              |   14 +-------------
 drivers/staging/vme/vme_api.txt        |   27 +++++++++++----------------
 4 files changed, 16 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index c658ce9..9518dda 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -668,7 +668,7 @@ err_nocard:
 
 static int vme_user_match(struct vme_dev *vdev)
 {
-	if (vdev->id.num >= USER_BUS_MAX)
+	if (vdev->num >= USER_BUS_MAX)
 		return 0;
 	return 1;
 }
diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index 9cb6938..5715148 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -1377,16 +1377,14 @@ static int __vme_register_driver_bus(struct vme_driver *drv,
 			err = -ENOMEM;
 			goto err_devalloc;
 		}
-		vdev->id.num = i;
-		vdev->id.bus = bridge->num;
-		vdev->id.slot = i + 1;
+		vdev->num = i;
 		vdev->bridge = bridge;
 		vdev->dev.platform_data = drv;
 		vdev->dev.release = vme_dev_release;
 		vdev->dev.parent = bridge->parent;
 		vdev->dev.bus = &vme_bus_type;
-		dev_set_name(&vdev->dev, "%s.%u-%u", drv->name, vdev->id.bus,
-			vdev->id.num);
+		dev_set_name(&vdev->dev, "%s.%u-%u", drv->name, bridge->num,
+			vdev->num);
 
 		err = device_register(&vdev->dev);
 		if (err)
diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
index 95224d7..e3828ba 100644
--- a/drivers/staging/vme/vme.h
+++ b/drivers/staging/vme/vme.h
@@ -96,18 +96,6 @@ extern struct bus_type vme_bus_type;
 #define VME_SLOT_ALL		-2
 
 /**
- * VME device identifier structure
- * @num: The device ID (ranges from 0 to N-1 for N devices)
- * @bus: The bus ID of the bus the device is on
- * @slot: The slot this device is plugged into
- */
-struct vme_device_id {
-	int num;
-	int bus;
-	int slot;
-};
-
-/**
  * Structure representing a VME device
  * @id: The ID of the device (currently the bus and slot number)
  * @bridge: Pointer to the bridge device this device is on
@@ -116,7 +104,7 @@ struct vme_device_id {
  * @bridge_list: List of devices (per bridge)
  */
 struct vme_dev {
-	struct vme_device_id id;
+	int num;
 	struct vme_bridge *bridge;
 	struct device dev;
 	struct list_head drv_list;
diff --git a/drivers/staging/vme/vme_api.txt b/drivers/staging/vme/vme_api.txt
index 53abf7e..e8ff215 100644
--- a/drivers/staging/vme/vme_api.txt
+++ b/drivers/staging/vme/vme_api.txt
@@ -51,23 +51,16 @@ probe routine is passed a 'struct vme_dev' pointer as an argument. The
 'struct vme_dev' structure looks like the following:
 
 	struct vme_dev {
-		struct vme_device_id id;
+		int num;
 		struct vme_bridge *bridge;
 		struct device dev;
+		struct list_head drv_list;
+		struct list_head bridge_list;
 	};
 
-The 'bridge' field contains a pointer to the bridge device. The 'id' field
-contains information useful for the probe function:
-
-	struct vme_device_id {
-		int bus;
-		int slot;
-		int num;
-	};
-
-Here, 'bus' is the number of the bus the device being probed is on. 'slot'
-refers to the specific slot on the VME bus. The 'num' field refers to the
-sequential device ID for this specific driver.
+Here, the 'num' field refers to the sequential device ID for this specific
+driver. The bridge number (or bus number) can be accessed using
+dev->bridge->num.
 
 A function is also provided to unregister the driver from the VME core and is
 usually called from the device driver's exit routine:
@@ -78,9 +71,11 @@ usually called from the device driver's exit routine:
 Resource management
 ===================
 
-Once a driver has registered with the VME core the provided probe routine will
-be called for each of the bus/slot combination that becomes valid as VME buses
-are themselves registered.  The probe routine is passed a pointer to the devices
+Once a driver has registered with the VME core the provided match routine will
+be called the number of times specified during the registration. If a match
+succeeds, a non-zero value should be returned. A zero return value indicates
+failure. For all successful matches, the probe routine of the corresponding
+driver is called. The probe routine is passed a pointer to the devices
 device structure. This pointer should be saved, it will be required for
 requesting VME resources.
 
-- 
1.7.4.1

