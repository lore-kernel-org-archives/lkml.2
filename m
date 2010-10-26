Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0JZBLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:11:51 -0400
Received: from bunsen.bytemark.co.uk ([80.68.81.6]:34115 "EHLO
	bunsen.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab0JZBLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:11:49 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, "Emilio G. Cota" <cota@braap.org>
Subject: [PATCH 04/30] staging/vme: allow non-dynamic allocation of bus numbers
Date: Mon, 25 Oct 2010 21:10:50 -0400
Message-Id: <1288055476-19438-5-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1288055476-19438-1-git-send-email-cota@braap.org>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

In a configuration with several bridges, each bridge is
assigned a certain bus number depending on the order in which
vme_register_bridge is called. This can complicate multi-bridge
installations because the eventual bus numbers will depend
on the order the bridges were loaded.

The appended allows bridges to register with a bus number of
their choice, while keeping the previous 'first come, first
served' behaviour as the default.

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/bridges/vme_ca91cx42.c |    1 +
 drivers/staging/vme/bridges/vme_tsi148.c   |    1 +
 drivers/staging/vme/vme.c                  |   46 +++++++++++++++++++++-------
 drivers/staging/vme/vme.h                  |    1 +
 4 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index 1f2089f..14e10a6 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -1600,6 +1600,7 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	ca91cx42_bridge->driver_priv = ca91cx42_device;
+	ca91cx42_bridge->num = -1;
 
 	/* Enable the device */
 	retval = pci_enable_device(pdev);
diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index 1cba1fa..e341122 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -2247,6 +2247,7 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	tsi148_bridge->driver_priv = tsi148_device;
+	tsi148_bridge->num = -1;
 
 	/* Enable the device */
 	retval = pci_enable_device(pdev);
diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index 47e9d5c..9fa0609 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -1307,20 +1307,42 @@ EXPORT_SYMBOL(vme_slot_get);
 
 /* - Bridge Registration --------------------------------------------------- */
 
-static int vme_alloc_bus_num(void)
+/* call with vme_bus_num_mtx held */
+static int __vme_alloc_bus_num(int *bus)
 {
-	int i;
-
-	mutex_lock(&vme_bus_num_mtx);
-	for (i = 0; i < sizeof(vme_bus_numbers) * 8; i++) {
-		if (((vme_bus_numbers >> i) & 0x1) == 0) {
-			vme_bus_numbers |= (0x1 << i);
-			break;
+	int index;
+
+	if (*bus == -1) {
+		/* try to find a free bus number */
+		for (index = 0; index < VME_MAX_BRIDGES; index++) {
+			if (~vme_bus_numbers & 1 << index) {
+				*bus = index;
+				break;
+			}
+		}
+		if (index == VME_MAX_BRIDGES) {
+			pr_warn("vme: No bus numbers left\n");
+			return -ENODEV;
+		}
+	} else {
+		/* check if the given bus number is already in use */
+		if (vme_bus_numbers & (1 << *bus)) {
+			pr_warn("vme: bus number %d already in use\n", *bus);
+			return -EBUSY;
 		}
 	}
-	mutex_unlock(&vme_bus_num_mtx);
+	vme_bus_numbers |= 1 << *bus;
+	return 0;
+}
+
+static int vme_alloc_bus_num(int *bus)
+{
+	int ret;
 
-	return i;
+	mutex_lock(&vme_bus_num_mtx);
+	ret = __vme_alloc_bus_num(bus);
+	mutex_unlock(&vme_bus_num_mtx);
+	return ret;
 }
 
 static void vme_free_bus_num(int bus)
@@ -1336,7 +1358,9 @@ int vme_register_bridge(struct vme_bridge *bridge)
 	int retval;
 	int i;
 
-	bridge->num = vme_alloc_bus_num();
+	retval = vme_alloc_bus_num(&bridge->num);
+	if (retval)
+		return retval;
 
 	/* This creates 32 vme "slot" devices. This equates to a slot for each
 	 * ID available in a system conforming to the ANSI/VITA 1-1994
diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
index 48768ca..5cdfa52 100644
--- a/drivers/staging/vme/vme.h
+++ b/drivers/staging/vme/vme.h
@@ -88,6 +88,7 @@ struct vme_resource {
 
 extern struct bus_type vme_bus_type;
 
+#define VME_MAX_BRIDGES		32
 #define VME_SLOT_CURRENT	-1
 #define VME_SLOT_ALL		-2
 
-- 
1.7.1

