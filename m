Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab2EWN4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:56:34 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:30306 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752642Ab2EWNyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:54:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJHrvE9bdWOb/2dsb2JhbABDtDOBB4IWAQUnQBIQUVcGARKIErpLkE8DlRyPcIJs
X-IronPort-AV: E=Sophos;i="4.75,645,1330902000"; 
   d="scan'208";a="518630129"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] Staging ipack/bridges/tpci200: delete sysfs files
Date: Wed, 23 May 2012 15:54:40 +0200
Message-Id: <1337781287-28628-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337781287-28628-1-git-send-email-siglesias@igalia.com>
References: <1337781287-28628-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To perform the installation of a mezzanine it was needed to write on these
files, now it is not needed at all as the device model is properly implemented.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |  225 ++-----------------------------
 1 file changed, 12 insertions(+), 213 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index ad28707..75ed600 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -365,207 +365,9 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 	return ret;
 }
 
-#ifdef CONFIG_SYSFS
-
-static struct ipack_device *tpci200_slot_register(unsigned int tpci200_number,
-						  unsigned int slot_position)
-{
-	int found = 0;
-	struct ipack_device  *dev;
-	struct tpci200_board *tpci200;
-
-	list_for_each_entry(tpci200, &tpci200_list, list) {
-		if (tpci200->number == tpci200_number) {
-			found = 1;
-			break;
-		}
-	}
-
-	if (!found) {
-		pr_err("carrier board not found for the device\n");
-		return NULL;
-	}
-
-	if (slot_position >= TPCI200_NB_SLOT) {
-		pr_info("Slot [%d:%d] doesn't exist!\n", tpci200_number,
-			slot_position);
-		return NULL;
-	}
-
-	if (mutex_lock_interruptible(&tpci200->mutex))
-		return NULL;
-
-	if (tpci200->slots[slot_position].dev != NULL) {
-		pr_err("Slot [%d:%d] already installed !\n", tpci200_number,
-		       slot_position);
-		goto err_unlock;
-	}
-
-	/*
-	 * Give the same IRQ number as the slot number.
-	 * The TPCI200 has assigned his own two IRQ by PCI bus driver
-	 */
-	dev = ipack_device_register(tpci200->info->ipack_bus,
-				    slot_position, slot_position);
-	if (dev == NULL) {
-		pr_info("Slot [%d:%d] Unable to register an ipack device\n",
-			tpci200_number, slot_position);
-		goto err_unlock;
-	}
-
-	tpci200->slots[slot_position].dev = dev;
-	mutex_unlock(&tpci200->mutex);
-	return dev;
-
-err_unlock:
-	mutex_unlock(&tpci200->mutex);
-	return NULL;
-}
-
-static ssize_t tpci200_store_board(struct device *pdev, const char *buf,
-				   size_t count, int slot)
-{
-	struct tpci200_board *card = dev_get_drvdata(pdev);
-	struct ipack_device *dev = card->slots[slot].dev;
-
-	if (dev != NULL)
-		return -EBUSY;
-
-	dev = tpci200_slot_register(card->number, slot);
-	if (dev == NULL)
-		return -ENODEV;
-
-	return count;
-}
-
-static ssize_t tpci200_show_board(struct device *pdev, char *buf, int slot)
-{
-	struct tpci200_board *card = dev_get_drvdata(pdev);
-	struct ipack_device *dev = card->slots[slot].dev;
-
-	if (dev != NULL)
-		return snprintf(buf, PAGE_SIZE, "%s\n", dev_name(&dev->dev));
-	else
-		return snprintf(buf, PAGE_SIZE, "none\n");
-}
-
-static ssize_t tpci200_show_description(struct device *pdev,
-					struct device_attribute *attr,
-					char *buf)
-{
-	return snprintf(buf, PAGE_SIZE,
-			"TEWS tpci200 carrier PCI for Industry-pack mezzanines.\n");
-}
-
-static ssize_t tpci200_show_board_slot0(struct device *pdev,
-					struct device_attribute *attr,
-					char *buf)
-{
-	return tpci200_show_board(pdev, buf, 0);
-}
-
-static ssize_t tpci200_store_board_slot0(struct device *pdev,
-					 struct device_attribute *attr,
-					 const char *buf, size_t count)
-{
-	return tpci200_store_board(pdev, buf, count, 0);
-}
-
-static ssize_t tpci200_show_board_slot1(struct device *pdev,
-					struct device_attribute *attr,
-					char *buf)
-{
-	return tpci200_show_board(pdev, buf, 1);
-}
-
-static ssize_t tpci200_store_board_slot1(struct device *pdev,
-					 struct device_attribute *attr,
-					 const char *buf, size_t count)
-{
-	return tpci200_store_board(pdev, buf, count, 1);
-}
-
-static ssize_t tpci200_show_board_slot2(struct device *pdev,
-					struct device_attribute *attr,
-					char *buf)
-{
-	return tpci200_show_board(pdev, buf, 2);
-}
-
-static ssize_t tpci200_store_board_slot2(struct device *pdev,
-					 struct device_attribute *attr,
-					 const char *buf, size_t count)
-{
-	return tpci200_store_board(pdev, buf, count, 2);
-}
-
-
-static ssize_t tpci200_show_board_slot3(struct device *pdev,
-					struct device_attribute *attr,
-					char *buf)
-{
-	return tpci200_show_board(pdev, buf, 3);
-}
-
-static ssize_t tpci200_store_board_slot3(struct device *pdev,
-					 struct device_attribute *attr,
-					 const char *buf, size_t count)
-{
-	return tpci200_store_board(pdev, buf, count, 3);
-}
-
-/* Declaration of the device attributes for the TPCI200 */
-static DEVICE_ATTR(description, S_IRUGO,
-		   tpci200_show_description, NULL);
-static DEVICE_ATTR(board_slot0, S_IRUGO | S_IWUSR,
-		   tpci200_show_board_slot0, tpci200_store_board_slot0);
-static DEVICE_ATTR(board_slot1, S_IRUGO | S_IWUSR,
-		   tpci200_show_board_slot1, tpci200_store_board_slot1);
-static DEVICE_ATTR(board_slot2, S_IRUGO | S_IWUSR,
-		   tpci200_show_board_slot2, tpci200_store_board_slot2);
-static DEVICE_ATTR(board_slot3, S_IRUGO | S_IWUSR,
-		   tpci200_show_board_slot3, tpci200_store_board_slot3);
-
-static struct attribute *tpci200_attrs[] = {
-	&dev_attr_description.attr,
-	&dev_attr_board_slot0.attr,
-	&dev_attr_board_slot1.attr,
-	&dev_attr_board_slot2.attr,
-	&dev_attr_board_slot3.attr,
-	NULL,
-};
-
-static struct attribute_group tpci200_attr_group = {
-	.attrs = tpci200_attrs,
-};
-
-static int tpci200_create_sysfs_files(struct tpci200_board *card)
-{
-	return sysfs_create_group(&card->info->pdev->dev.kobj,
-				  &tpci200_attr_group);
-}
-
-static void tpci200_remove_sysfs_files(struct tpci200_board *card)
-{
-	sysfs_remove_group(&card->info->pdev->dev.kobj, &tpci200_attr_group);
-}
-
-#else
-
-static int tpci200_create_sysfs_files(struct tpci200_board *card)
-{
-	return 0;
-}
-
-static void tpci200_remove_sysfs_files(struct tpci200_board *card)
-{
-}
-
-#endif /* CONFIG_SYSFS */
-
 static int tpci200_register(struct tpci200_board *tpci200)
 {
-	int  i;
+	int i;
 	int res;
 	unsigned long ioidint_base;
 	unsigned long mem_base;
@@ -574,12 +376,6 @@ static int tpci200_register(struct tpci200_board *tpci200)
 	if (pci_enable_device(tpci200->info->pdev) < 0)
 		return -ENODEV;
 
-	if (tpci200_create_sysfs_files(tpci200) < 0) {
-		pr_err("failed creating sysfs files\n");
-		res = -EFAULT;
-		goto out_disable_pci;
-	}
-
 	/* Request IP interface register (Bar 2) */
 	res = pci_request_region(tpci200->info->pdev, TPCI200_IP_INTERFACE_BAR,
 				 "Carrier IP interface registers");
@@ -587,7 +383,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 		pr_err("(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 2 !",
 		       tpci200->info->pdev->bus->number,
 		       tpci200->info->pdev->devfn);
-		goto out_remove_sysfs;
+		goto out_disable_pci;
 	}
 
 	/* Request IO ID INT space (Bar 3) */
@@ -668,8 +464,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 		pr_err("(bn 0x%X, sn 0x%X) unable to register IRQ !",
 		       tpci200->info->pdev->bus->number,
 		       tpci200->info->pdev->devfn);
-		tpci200_unregister(tpci200);
-		goto out_err;
+		goto out_release_ioid_int_space;
 	}
 
 	return 0;
@@ -678,11 +473,8 @@ out_release_ioid_int_space:
 	pci_release_region(tpci200->info->pdev, TPCI200_IO_ID_INT_SPACES_BAR);
 out_release_ip_space:
 	pci_release_region(tpci200->info->pdev, TPCI200_IP_INTERFACE_BAR);
-out_remove_sysfs:
-	tpci200_remove_sysfs_files(tpci200);
 out_disable_pci:
 	pci_disable_device(tpci200->info->pdev);
-out_err:
 	return res;
 }
 
@@ -1038,7 +830,7 @@ out_err:
 static int tpci200_pciprobe(struct pci_dev *pdev,
 			    const struct pci_device_id *id)
 {
-	int ret;
+	int ret, i;
 	struct tpci200_board *tpci200;
 
 	tpci200 = kzalloc(sizeof(struct tpci200_board), GFP_KERNEL);
@@ -1081,13 +873,20 @@ static int tpci200_pciprobe(struct pci_dev *pdev,
 	dev_set_drvdata(&pdev->dev, tpci200);
 	/* add the registered device in an internal linked list */
 	list_add_tail(&tpci200->list, &tpci200_list);
+
+	/*
+	 * Give the same IRQ number as the slot number.
+	 * The TPCI200 has assigned his own two IRQ by PCI bus driver
+	 */
+	for (i = 0; i < TPCI200_NB_SLOT; i++)
+		tpci200->slots[i].dev =
+			ipack_device_register(tpci200->info->ipack_bus, i, i);
 	return ret;
 }
 
 static void __tpci200_pci_remove(struct tpci200_board *tpci200)
 {
 	tpci200_uninstall(tpci200);
-	tpci200_remove_sysfs_files(tpci200);
 	list_del(&tpci200->list);
 	ipack_bus_unregister(tpci200->info->ipack_bus);
 	kfree(tpci200->info);
-- 
1.7.10

