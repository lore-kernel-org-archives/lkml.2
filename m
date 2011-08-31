Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab1HaKJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 06:09:45 -0400
Received: from cernmx31.cern.ch ([137.138.144.179]:3402 "EHLO CERNMX31.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab1HaKJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 06:09:12 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <gregkh@suse.de>
CC: <martyn.welch@ge.com>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 1/3] staging: vme: change static device array to pointers
Date: Wed, 31 Aug 2011 12:05:44 +0200
Message-ID: <1314785146-19163-2-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314785146-19163-1-git-send-email-manohar.vanga@cern.ch>
References: <1314785146-19163-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the static array of 'struct device''s in struct vme_bridge
to instead use an array of pointers. This is in accordance with the
requirement that all kobjects be dynamically allocated (see
Documentation/kobject.txt) and never be statically allocated.

Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/staging/vme/vme.c        |   21 +++++++++++++++++----
 drivers/staging/vme/vme_bridge.h |    2 +-
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index feb2d00..810fe1f 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -1338,6 +1338,11 @@ static void vme_remove_bus(struct vme_bridge *bridge)
 	mutex_unlock(&vme_buses_lock);
 }
 
+static void vme_dev_release(struct device *dev)
+{
+	kfree(dev);
+}
+
 int vme_register_bridge(struct vme_bridge *bridge)
 {
 	struct device *dev;
@@ -1353,11 +1358,17 @@ int vme_register_bridge(struct vme_bridge *bridge)
 	 * specification.
 	 */
 	for (i = 0; i < VME_SLOTS_MAX; i++) {
-		dev = &bridge->dev[i];
+		bridge->dev[i] = kzalloc(sizeof(struct device), GFP_KERNEL);
+		if (!bridge->dev[i]) {
+			retval = -ENOMEM;
+			goto err_devalloc;
+		}
+		dev = bridge->dev[i];
 		memset(dev, 0, sizeof(struct device));
 
 		dev->parent = bridge->parent;
 		dev->bus = &vme_bus_type;
+		dev->release = vme_dev_release;
 		/*
 		 * We save a pointer to the bridge in platform_data so that we
 		 * can get to it later. We keep driver_data for use by the
@@ -1374,8 +1385,10 @@ int vme_register_bridge(struct vme_bridge *bridge)
 	return retval;
 
 err_reg:
+	kfree(dev);
+err_devalloc:
 	while (--i >= 0) {
-		dev = &bridge->dev[i];
+		dev = bridge->dev[i];
 		device_unregister(dev);
 	}
 	vme_remove_bus(bridge);
@@ -1390,7 +1403,7 @@ void vme_unregister_bridge(struct vme_bridge *bridge)
 
 
 	for (i = 0; i < VME_SLOTS_MAX; i++) {
-		dev = &bridge->dev[i];
+		dev = bridge->dev[i];
 		device_unregister(dev);
 	}
 	vme_remove_bus(bridge);
@@ -1427,7 +1440,7 @@ static int vme_calc_slot(struct device *dev)
 	/* Determine slot number */
 	num = 0;
 	while (num < VME_SLOTS_MAX) {
-		if (&bridge->dev[num] == dev)
+		if (bridge->dev[num] == dev)
 			break;
 
 		num++;
diff --git a/drivers/staging/vme/vme_bridge.h b/drivers/staging/vme/vme_bridge.h
index 8959670..4b8566e 100644
--- a/drivers/staging/vme/vme_bridge.h
+++ b/drivers/staging/vme/vme_bridge.h
@@ -114,7 +114,7 @@ struct vme_bridge {
 	void *driver_priv;	/* Private pointer for the bridge driver */
 	struct list_head bus_list; /* list of VME buses */
 
-	struct device dev[VME_SLOTS_MAX];	/* Device registered with
+	struct device *dev[VME_SLOTS_MAX];	/* Device registered with
 						 * device model on VME bus
 						 */
 
-- 
1.7.4.1

