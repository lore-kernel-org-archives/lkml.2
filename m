Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1HAKaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 06:30:23 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:44742 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab1HAK3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 06:29:37 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <gregkh@suse.de>
CC: <martyn.welch@ge.com>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 2/8] staging: vme: allow explicit assignment of bus numbers
Date: Mon, 1 Aug 2011 12:20:47 +0200
Message-ID: <1312194053-32310-3-git-send-email-manohar.vanga@cern.ch>
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

From: Emilio G. Cota <cota@braap.org>

In a configuration with several bridges, each bridge is
assigned a certain bus number depending on the order in which
bridge modules are loaded. This can complicate multi-bridge
installations because the bus numbers will depend on the load
order of the bridges.

This patch allows bridges to register with a bus number of
their choice, while keeping the previous 'first come, first
serve' behaviour as the default.

Module parameters have been added to the bridge drivers to
allow overriding of the auto-assignment during load time.

This patch also explicitly defines VME_MAX_BRIDGES as the,
size of vme_bus_numbers (unsigned int); something that was
implicit earlier in the code.

Signed-off-by: Emilio G. Cota <cota@braap.org>
Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/staging/vme/bridges/vme_ca91cx42.c |   20 ++++++++++++
 drivers/staging/vme/bridges/vme_tsi148.c   |   21 +++++++++++++
 drivers/staging/vme/vme.c                  |   46 ++++++++++++++++++++++-----
 drivers/staging/vme/vme.h                  |    2 +
 4 files changed, 80 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index 5122c13..c378819 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -41,6 +41,13 @@ static void __exit ca91cx42_exit(void);
 
 /* Module parameters */
 static int geoid;
+static int bus_ids[VME_MAX_BRIDGES];
+static int id_count;
+
+/* The number of registered buses */
+static int bus_count;
+/* Mutex for protecting ID access */
+static DEFINE_MUTEX(bus_id_mutex);
 
 static const char driver_name[] = "vme_ca91cx42";
 
@@ -1779,6 +1786,12 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ca91cx42_crcsr_init(ca91cx42_bridge, pdev))
 		dev_err(&pdev->dev, "CR/CSR configuration failed.\n");
 
+	mutex_lock(&bus_id_mutex);
+	if (bus_count >= id_count)
+		ca91cx42_bridge->num = -1;
+	else
+		ca91cx42_bridge->num = bus_ids[bus_count];
+
 	/* Need to save ca91cx42_bridge pointer locally in link list for use in
 	 * ca91cx42_remove()
 	 */
@@ -1788,11 +1801,15 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_reg;
 	}
 
+	bus_count++;
+	mutex_unlock(&bus_id_mutex);
+
 	pci_set_drvdata(pdev, ca91cx42_bridge);
 
 	return 0;
 
 err_reg:
+	mutex_unlock(&bus_id_mutex);
 	ca91cx42_crcsr_exit(ca91cx42_bridge, pdev);
 err_lm:
 	/* resources are stored in link list */
@@ -1930,5 +1947,8 @@ module_param(geoid, int, 0);
 MODULE_DESCRIPTION("VME driver for the Tundra Universe II VME bridge");
 MODULE_LICENSE("GPL");
 
+MODULE_PARM_DESC(bus_num, "Explicitly set bus number (override auto-assign)");
+module_param_array(bus_ids, int, &id_count, 0);
+
 module_init(ca91cx42_init);
 module_exit(ca91cx42_exit);
diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index 9c53951..e3f021e 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -44,6 +44,14 @@ static void __exit tsi148_exit(void);
 static int err_chk;
 static int geoid;
 
+static int bus_ids[VME_MAX_BRIDGES];
+static int id_count;
+
+/* The number of registered buses */
+static int bus_count;
+/* Mutex for protecting ID access */
+static DEFINE_MUTEX(bus_id_mutex);
+
 static const char driver_name[] = "vme_tsi148";
 
 static DEFINE_PCI_DEVICE_TABLE(tsi148_ids) = {
@@ -2462,12 +2470,21 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_crcsr;
 	}
 
+	mutex_lock(&bus_id_mutex);
+	if (bus_count >= id_count)
+		tsi148_bridge->num = -1;
+	else
+		tsi148_bridge->num = bus_ids[bus_count];
+
 	retval = vme_register_bridge(tsi148_bridge);
 	if (retval != 0) {
 		dev_err(&pdev->dev, "Chip Registration failed.\n");
 		goto err_reg;
 	}
 
+	bus_count++;
+	mutex_unlock(&bus_id_mutex);
+
 	pci_set_drvdata(pdev, tsi148_bridge);
 
 	/* Clear VME bus "board fail", and "power-up reset" lines */
@@ -2479,6 +2496,7 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_reg:
+	mutex_unlock(&bus_id_mutex);
 	tsi148_crcsr_exit(tsi148_bridge, pdev);
 err_crcsr:
 err_lm:
@@ -2633,6 +2651,9 @@ module_param(err_chk, bool, 0);
 MODULE_PARM_DESC(geoid, "Override geographical addressing");
 module_param(geoid, int, 0);
 
+MODULE_PARM_DESC(bus_ids, "Explicitly set bus number (override auto-assign)");
+module_param_array(bus_ids, int, &id_count, 0);
+
 MODULE_DESCRIPTION("VME driver for the Tundra Tempe VME bridge");
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index c078ce3..330a4ff 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -1303,20 +1303,44 @@ EXPORT_SYMBOL(vme_slot_get);
 
 /* - Bridge Registration --------------------------------------------------- */
 
-static int vme_alloc_bus_num(void)
+/* call with vme_bus_num_mtx held */
+static int __vme_alloc_bus_num(int bus_num)
 {
+	int num;
 	int i;
 
-	mutex_lock(&vme_bus_num_mtx);
-	for (i = 0; i < sizeof(vme_bus_numbers) * 8; i++) {
-		if (((vme_bus_numbers >> i) & 0x1) == 0) {
-			vme_bus_numbers |= (0x1 << i);
-			break;
+	if (bus_num == -1) {
+		/* try to find a free bus number */
+		for (i = 0; i < VME_MAX_BRIDGES; i++) {
+			if ((vme_bus_numbers & (1 << i)) == 0) {
+				num = i;
+				break;
+			}
+		}
+		if (i == VME_MAX_BRIDGES) {
+			pr_warn("vme: No bus numbers left\n");
+			return -ENODEV;
 		}
+	} else {
+		/* check if the given bus number is already in use */
+		if (vme_bus_numbers & (1 << bus_num)) {
+			pr_warn("vme: bus number %d already in use\n", bus_num);
+			return -EBUSY;
+		}
+		num = bus_num;
 	}
-	mutex_unlock(&vme_bus_num_mtx);
+	vme_bus_numbers |= 1 << num;
+	return num;
+}
 
-	return i;
+static int vme_alloc_bus_num(int bus_num)
+{
+	int num;
+
+	mutex_lock(&vme_bus_num_mtx);
+	num = __vme_alloc_bus_num(bus_num);
+	mutex_unlock(&vme_bus_num_mtx);
+	return num;
 }
 
 static void vme_free_bus_num(int bus)
@@ -1332,7 +1356,11 @@ int vme_register_bridge(struct vme_bridge *bridge)
 	int retval;
 	int i;
 
-	bridge->num = vme_alloc_bus_num();
+	retval = vme_alloc_bus_num(bridge->num);
+	if (retval < 0)
+		return retval;
+
+	bridge->num = retval;
 
 	/* This creates 32 vme "slot" devices. This equates to a slot for each
 	 * ID available in a system conforming to the ANSI/VITA 1-1994
diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
index 4155d8c..3ccb497 100644
--- a/drivers/staging/vme/vme.h
+++ b/drivers/staging/vme/vme.h
@@ -88,6 +88,8 @@ struct vme_resource {
 
 extern struct bus_type vme_bus_type;
 
+/* VME_MAX_BRIDGES comes from the type of vme_bus_numbers */
+#define VME_MAX_BRIDGES		(sizeof(unsigned int)*8)
 #define VME_SLOT_CURRENT	-1
 #define VME_SLOT_ALL		-2
 
-- 
1.7.4.1

