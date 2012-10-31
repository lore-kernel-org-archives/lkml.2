Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965253Ab2J3SQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:16:50 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:59054 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934046Ab2J3SMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:12:43 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        spi-devel-general@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: [PATCH] spi: Export OF interfaces.
Date: Wed, 31 Oct 2012 17:57:33 +0200
Message-Id: <1351699053-4533-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export an interface that other in-kernel users can utilize.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/spi/spi.c       | 31 +++++++++++++++++++++++--------
 include/linux/spi/spi.h | 18 ++++++++++++++++++
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 84c2861..f8de2f2 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -801,14 +801,17 @@ err_init_queue:
 /*-------------------------------------------------------------------------*/
 
 #if defined(CONFIG_OF) && !defined(CONFIG_SPARC)
+
 /**
- * of_register_spi_devices() - Register child devices onto the SPI bus
+ * of_register_node_spi_devices() - Register child devices onto the SPI bus
  * @master:	Pointer to spi_master device
+ * @parent_node: Pointer to the device node containg the devices
  *
  * Registers an spi_device for each child node of master node which has a 'reg'
  * property.
  */
-static void of_register_spi_devices(struct spi_master *master)
+void of_register_node_spi_devices(struct spi_master *master,
+		struct device_node *parent_node)
 {
 	struct spi_device *spi;
 	struct device_node *nc;
@@ -816,10 +819,10 @@ static void of_register_spi_devices(struct spi_master *master)
 	int rc;
 	int len;
 
-	if (!master->dev.of_node)
+	if (!parent_node)
 		return;
 
-	for_each_child_of_node(master->dev.of_node, nc) {
+	for_each_child_of_node(parent_node, nc) {
 		/* Alloc an spi_device */
 		spi = spi_alloc_device(master);
 		if (!spi) {
@@ -884,8 +887,20 @@ static void of_register_spi_devices(struct spi_master *master)
 
 	}
 }
-#else
-static void of_register_spi_devices(struct spi_master *master) { }
+EXPORT_SYMBOL_GPL(of_register_node_spi_devices);
+
+/**
+ * of_register_spi_devices() - Register child devices onto the SPI bus
+ * @master:	Pointer to spi_master device
+ *
+ * Registers an spi_device for each child node of master node which has a 'reg'
+ * property.
+ */
+void of_register_spi_devices(struct spi_master *master)
+{
+	of_register_node_spi_devices(master, master->dev.of_node);
+}
+EXPORT_SYMBOL_GPL(of_register_spi_devices);
 #endif
 
 static void spi_master_release(struct device *dev)
@@ -896,12 +911,12 @@ static void spi_master_release(struct device *dev)
 	kfree(master);
 }
 
-static struct class spi_master_class = {
+struct class spi_master_class = {
 	.name		= "spi_master",
 	.owner		= THIS_MODULE,
 	.dev_release	= spi_master_release,
 };
-
+EXPORT_SYMBOL_GPL(spi_master_class);
 
 
 /**
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index fa702ae..618aa5e 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -30,6 +30,8 @@
  */
 extern struct bus_type spi_bus_type;
 
+extern struct class spi_master_class;
+
 /**
  * struct spi_device - Master side proxy for an SPI slave device
  * @dev: Driver model representation of the device.
@@ -856,4 +858,20 @@ spi_unregister_device(struct spi_device *spi)
 extern const struct spi_device_id *
 spi_get_device_id(const struct spi_device *sdev);
 
+#if defined(CONFIG_OF) && !defined(CONFIG_SPARC)
+
+void of_register_node_spi_devices(struct spi_master *master,
+		struct device_node *parent_node);
+
+void of_register_spi_devices(struct spi_master *master);
+
+#else
+
+static inline void of_register_node_spi_devices(struct spi_master *master,
+		struct device_node *parent_node) { }
+
+static inline void of_register_spi_devices(struct spi_master *master) { }
+
+#endif
+
 #endif /* __LINUX_SPI_H */
-- 
1.7.12

