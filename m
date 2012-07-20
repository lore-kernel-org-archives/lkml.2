Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2GTHj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 03:39:26 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:50567 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752468Ab2GTHiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 03:38:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAAIKCVBbdWOb/2dsb2JhbABFhXSzSoEHgiEBBSMECwE0EhAlAiYCAlcGE4gRrAeTA4Egj3qBEgOVRJAJgmE
X-IronPort-AV: E=Sophos;i="4.77,621,1336341600"; 
   d="scan'208";a="546394753"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>
Subject: [PATCH 2/3] Staging ipack/bridges/tpci200: remove linked list of registered devices
Date: Fri, 20 Jul 2012 09:39:04 +0200
Message-Id: <1342769945-6999-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342769945-6999-1-git-send-email-siglesias@igalia.com>
References: <1342769945-6999-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The linked list of registered devices is not needed as the struct
tpci200_board is saved in private data field of the pci device.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   34 ++++++-------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index a7fb2cf..cee25c7 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -24,28 +24,20 @@ static int control_reg[] = {
 	TPCI200_CONTROL_D_REG
 };
 
-/* Linked list to save the registered devices */
-static LIST_HEAD(tpci200_list);
-
 static int tpci200_slot_unregister(struct ipack_device *dev);
 
 static struct tpci200_board *check_slot(struct ipack_device *dev)
 {
 	struct tpci200_board *tpci200;
-	int found = 0;
 
 	if (dev == NULL)
 		return NULL;
 
-	list_for_each_entry(tpci200, &tpci200_list, list) {
-		if (tpci200->number == dev->bus_nr) {
-			found = 1;
-			break;
-		}
-	}
 
-	if (!found) {
-		dev_err(&dev->dev, "Carrier not found\n");
+	tpci200 = dev_get_drvdata(dev->bus->parent);
+
+	if (tpci200 == NULL) {
+		dev_info(&dev->dev, "carrier board not found\n");
 		return NULL;
 	}
 
@@ -831,8 +823,6 @@ static int tpci200_pciprobe(struct pci_dev *pdev,
 	/* save the bus number given by ipack to logging purpose */
 	tpci200->number = tpci200->info->ipack_bus->bus_nr;
 	dev_set_drvdata(&pdev->dev, tpci200);
-	/* add the registered device in an internal linked list */
-	list_add_tail(&tpci200->list, &tpci200_list);
 
 	/*
 	 * Give the same IRQ number as the slot number.
@@ -847,7 +837,6 @@ static int tpci200_pciprobe(struct pci_dev *pdev,
 static void __tpci200_pci_remove(struct tpci200_board *tpci200)
 {
 	tpci200_uninstall(tpci200);
-	list_del(&tpci200->list);
 	ipack_bus_unregister(tpci200->info->ipack_bus);
 	kfree(tpci200->info);
 	kfree(tpci200);
@@ -855,15 +844,9 @@ static void __tpci200_pci_remove(struct tpci200_board *tpci200)
 
 static void __devexit tpci200_pci_remove(struct pci_dev *dev)
 {
-	struct tpci200_board *tpci200, *next;
+	struct tpci200_board *tpci200 = pci_get_drvdata(dev);
 
-	/* Search the registered device to uninstall it */
-	list_for_each_entry_safe(tpci200, next, &tpci200_list, list) {
-		if (tpci200->info->pdev == dev) {
-			__tpci200_pci_remove(tpci200);
-			break;
-		}
-	}
+	__tpci200_pci_remove(tpci200);
 }
 
 static DEFINE_PCI_DEVICE_TABLE(tpci200_idtable) = {
@@ -888,11 +871,6 @@ static int __init tpci200_drvr_init_module(void)
 
 static void __exit tpci200_drvr_exit_module(void)
 {
-	struct tpci200_board *tpci200, *next;
-
-	list_for_each_entry_safe(tpci200, next, &tpci200_list, list)
-		__tpci200_pci_remove(tpci200);
-
 	pci_unregister_driver(&tpci200_pci_drv);
 }
 
-- 
1.7.10.4

