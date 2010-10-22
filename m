Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab0JVHDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:03:12 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:36076 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab0JVHDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:03:11 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <greg@kroah.com>
Cc: Martyn Welch <martyn.welch@ge.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: [PATCH 28/30] staging/vme: convert vme_* users to vme_*_ng
Date: Fri, 22 Oct 2010 02:36:50 -0400
Message-Id: <1287729412-24356-29-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287729412-24356-1-git-send-email-cota@braap.org>
References: <1287729412-24356-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

Only vme_user.c is calling the old functions.

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/bridges/vme_ca91cx42.c |    7 +-
 drivers/staging/vme/bridges/vme_tsi148.c   |    5 +-
 drivers/staging/vme/devices/vme_user.c     |  100 ++++++++++++----------------
 drivers/staging/vme/vme.c                  |    6 +-
 4 files changed, 54 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index b91c130..0f7dd66 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -1599,6 +1599,7 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	ca91cx42_bridge->driver_priv = ca91cx42_device;
+	ca91cx42_bridge->owner = THIS_MODULE;
 	ca91cx42_bridge->num = -1;
 
 	/* Enable the device */
@@ -1772,7 +1773,7 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Need to save ca91cx42_bridge pointer locally in link list for use in
 	 * ca91cx42_remove()
 	 */
-	retval = vme_register_bridge(ca91cx42_bridge);
+	retval = vme_register_bridge_ng(ca91cx42_bridge);
 	if (retval != 0) {
 		dev_err(&pdev->dev, "Chip Registration failed.\n");
 		goto err_reg;
@@ -1782,7 +1783,7 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
-	vme_unregister_bridge(ca91cx42_bridge);
+	vme_unregister_bridge_ng(ca91cx42_bridge);
 err_reg:
 	ca91cx42_crcsr_exit(ca91cx42_bridge, pdev);
 err_lm:
@@ -1866,7 +1867,7 @@ static void ca91cx42_remove(struct pci_dev *pdev)
 	iowrite32(0x00F00000, bridge->base + VSI6_CTL);
 	iowrite32(0x00F00000, bridge->base + VSI7_CTL);
 
-	vme_unregister_bridge(ca91cx42_bridge);
+	vme_unregister_bridge_ng(ca91cx42_bridge);
 
 	ca91cx42_crcsr_exit(ca91cx42_bridge, pdev);
 
diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index 80a9829..b12d517 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -2248,6 +2248,7 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	tsi148_bridge->driver_priv = tsi148_device;
+	tsi148_bridge->owner = THIS_MODULE;
 	tsi148_bridge->num = -1;
 
 	/* Enable the device */
@@ -2463,7 +2464,7 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_crcsr;
 	}
 
-	retval = vme_register_bridge(tsi148_bridge);
+	retval = vme_register_bridge_ng(tsi148_bridge);
 	if (retval != 0) {
 		dev_err(&pdev->dev, "Chip Registration failed.\n");
 		goto err_reg;
@@ -2586,7 +2587,7 @@ static void tsi148_remove(struct pci_dev *pdev)
 
 	tsi148_irq_exit(tsi148_bridge, pdev);
 
-	vme_unregister_bridge(tsi148_bridge);
+	vme_unregister_bridge_ng(tsi148_bridge);
 
 	tsi148_crcsr_exit(tsi148_bridge, pdev);
 
diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 75f6472..030f5ee 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -116,7 +116,8 @@ static driver_stats_t statistics;
 
 static struct cdev *vme_user_cdev;		/* Character device */
 static struct class *vme_user_sysfs_class;	/* Sysfs class */
-static struct device *vme_user_bridge;		/* Pointer to the bridge device */
+static struct vme_bridge *bridges[USER_BUS_MAX];
+static int bus_registered;
 
 
 static const int type[VME_DEVS] = {	MASTER_MINOR,	MASTER_MINOR,
@@ -134,8 +135,9 @@ static ssize_t vme_user_write(struct file *, const char __user *, size_t, loff_t
 static loff_t vme_user_llseek(struct file *, loff_t, int);
 static long vme_user_unlocked_ioctl(struct file *, unsigned int, unsigned long);
 
-static int __devinit vme_user_probe(struct device *, int, int);
-static int __devexit vme_user_remove(struct device *, int, int);
+static int __devinit vme_user_match(struct device *, unsigned int, unsigned int);
+static int __devinit vme_user_probe(struct device *, unsigned int, unsigned int);
+static int __devexit vme_user_remove(struct device *, unsigned int, unsigned int);
 
 static struct file_operations vme_user_fops = {
 	.open = vme_user_open,
@@ -146,6 +148,16 @@ static struct file_operations vme_user_fops = {
 	.unlocked_ioctl = vme_user_unlocked_ioctl,
 };
 
+static int get_bus_index(unsigned int bus_id)
+{
+	int i;
+
+	for (i = 0; i < bus_num; i++) {
+		if (bus[i] == bus_id)
+			return i;
+	}
+	return -1;
+}
 
 /*
  * Reset all the statistic counters
@@ -590,8 +602,9 @@ static void buf_unalloc(int num)
 	}
 }
 
-static struct vme_driver vme_user_driver = {
+static struct vme_driver_ng vme_user_driver_ng = {
 	.name = driver_name,
+	.match = vme_user_match,
 	.probe = vme_user_probe,
 	.remove = __devexit_p(vme_user_remove),
 };
@@ -599,17 +612,12 @@ static struct vme_driver vme_user_driver = {
 
 static int __init vme_user_init(void)
 {
-	int retval = 0;
-	int i;
-	struct vme_device_id *ids;
-
 	printk(KERN_INFO "VME User Space Access Driver\n");
 
 	if (bus_num == 0) {
 		printk(KERN_ERR "%s: No cards, skipping registration\n",
 			driver_name);
-		retval = -ENODEV;
-		goto err_nocard;
+		return -ENODEV;
 	}
 
 	/* Let's start by supporting one bus, we can support more than one
@@ -621,41 +629,14 @@ static int __init vme_user_init(void)
 		bus_num = USER_BUS_MAX;
 	}
 
+	return vme_register_driver_ng(&vme_user_driver_ng, 1);
+}
 
-	/* Dynamically create the bind table based on module parameters */
-	ids = kmalloc(sizeof(struct vme_device_id) * (bus_num + 1), GFP_KERNEL);
-	if (ids == NULL) {
-		printk(KERN_ERR "%s: Unable to allocate ID table\n",
-			driver_name);
-		retval = -ENOMEM;
-		goto err_id;
-	}
-
-	memset(ids, 0, (sizeof(struct vme_device_id) * (bus_num + 1)));
-
-	for (i = 0; i < bus_num; i++) {
-		ids[i].bus = bus[i];
-		/*
-		 * We register the driver against the slot occupied by *this*
-		 * card, since it's really a low level way of controlling
-		 * the VME bridge
-		 */
-		ids[i].slot = VME_SLOT_CURRENT;
-	}
-
-	vme_user_driver.bind_table = ids;
-
-	retval = vme_register_driver(&vme_user_driver);
-	if (retval != 0)
-		goto err_reg;
-
-	return retval;
-
-err_reg:
-	kfree(ids);
-err_id:
-err_nocard:
-	return retval;
+/* NOTE: This only supports one device per bus */
+static int __devinit
+vme_user_match(struct device *devp, unsigned int bus_id, unsigned int id)
+{
+	return get_bus_index(bus_id) >= 0 && id == 0 ? 1 : 0;
 }
 
 /*
@@ -663,19 +644,25 @@ err_nocard:
  * as practical. We will therefore reserve the buffers and request the images
  * here so that we don't have to do it later.
  */
-static int __devinit vme_user_probe(struct device *dev, int cur_bus, int cur_slot)
+static int __devinit
+vme_user_probe(struct device *dev, unsigned int bus_id, unsigned int id)
 {
 	int i, err;
 	char name[12];
 
-	/* Save pointer to the bridge device */
-	if (vme_user_bridge != NULL) {
+	if (bus_registered) {
 		printk(KERN_ERR "%s: Driver can only be loaded for 1 device\n",
 			driver_name);
 		err = -EINVAL;
 		goto err_dev;
 	}
-	vme_user_bridge = dev;
+	bus_registered = 1;
+
+	bridges[0] = vme_get_bridge(bus_id);
+	if (bridges[0] == NULL) {
+		err = -ENODEV;
+		goto err_get_bridge;
+	}
 
 	/* Initialise descriptors */
 	for (i = 0; i < VME_DEVS; i++) {
@@ -716,8 +703,7 @@ static int __devinit vme_user_probe(struct device *dev, int cur_bus, int cur_slo
 		 * supporting A16 addressing, so we request A24 supported
 		 * by all windows.
 		 */
-		image[i].resource = vme_slave_request(vme_user_bridge,
-			VME_A24, VME_SCT);
+		image[i].resource = vme_slave_request_ng(bridges[0], VME_A24, VME_SCT);
 		if (image[i].resource == NULL) {
 			printk(KERN_WARNING "Unable to allocate slave "
 				"resource\n");
@@ -742,8 +728,7 @@ static int __devinit vme_user_probe(struct device *dev, int cur_bus, int cur_slo
 	 */
 	for (i = MASTER_MINOR; i < (MASTER_MAX + 1); i++) {
 		/* XXX Need to properly request attributes */
-		image[i].resource = vme_master_request(vme_user_bridge,
-			VME_A32, VME_SCT, VME_D32);
+		image[i].resource = vme_master_request_ng(bridges[0], VME_A32, VME_SCT, VME_D32);
 		if (image[i].resource == NULL) {
 			printk(KERN_WARNING "Unable to allocate master "
 				"resource\n");
@@ -834,11 +819,14 @@ err_class:
 err_char:
 	unregister_chrdev_region(MKDEV(VME_MAJOR, 0), VME_DEVS);
 err_region:
+	vme_put_bridge(bridges[0]);
+err_get_bridge:
+	bus_registered = 0;
 err_dev:
 	return err;
 }
 
-static int __devexit vme_user_remove(struct device *dev, int cur_bus, int cur_slot)
+static int __devexit vme_user_remove(struct device *dev, unsigned int bus_id, unsigned int id)
 {
 	int i;
 
@@ -863,14 +851,14 @@ static int __devexit vme_user_remove(struct device *dev, int cur_bus, int cur_sl
 	/* Unregiser the major and minor device numbers */
 	unregister_chrdev_region(MKDEV(VME_MAJOR, 0), VME_DEVS);
 
+	vme_put_bridge(bridges[0]);
+
 	return 0;
 }
 
 static void __exit vme_user_exit(void)
 {
-	vme_unregister_driver(&vme_user_driver);
-
-	kfree(vme_user_driver.bind_table);
+	vme_unregister_driver_ng(&vme_user_driver_ng);
 }
 
 
diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index 5ecfecc..88697aa 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -1812,9 +1812,9 @@ static int vme_bus_remove_ng(struct device *dev)
 
 struct bus_type vme_bus_type = {
 	.name = "vme",
-	.match = vme_bus_match,
-	.probe = vme_bus_probe,
-	.remove = vme_bus_remove,
+	.match = vme_bus_match_ng,
+	.probe = vme_bus_probe_ng,
+	.remove = vme_bus_remove_ng,
 };
 EXPORT_SYMBOL(vme_bus_type);
 
-- 
1.7.1

