Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab2LRI0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 03:26:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:41415 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab2LRI0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 03:26:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,308,1355126400"; 
   d="scan'208";a="265991507"
Subject: [PATCH] spi: Add the flag indicate to registe new device as
 children of master or not.
From: Jun Chen <jun.d.chen@intel.com>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, jun.d.chen@intel.com,
        Bi Chao <chao.bi@intel.com>, spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Dec 2012 11:29:34 -0500
Message-ID: <1355848174.1435.25.camel@chenjun-workstation>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Because there are two aim when allocating the new device, one is for children of master,
other is for master. So this patch add one flag to indicate different purpose.

Signed-off-by: Bi Chao <chao.bi@intel.com>
Signed-off-by: Chen Jun <jun.d.chen@intel.com>
---
 drivers/spi/spi.c       |   16 +++++++++++-----
 include/linux/spi/spi.h |    3 ++-
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 718cc1f..06f69ce 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -300,6 +300,8 @@ static DEFINE_MUTEX(board_lock);
 /**
  * spi_alloc_device - Allocate a new SPI device
  * @master: Controller to which device is connected
+ * device_was_children_of_master is flag which the device is registed
+ * as the children of the bus
  * Context: can sleep
  *
  * Allows a driver to allocate and initialize a spi_device without
@@ -314,7 +316,8 @@ static DEFINE_MUTEX(board_lock);
  *
  * Returns a pointer to the new device, or NULL.
  */
-struct spi_device *spi_alloc_device(struct spi_master *master)
+struct spi_device *spi_alloc_device(struct spi_master *master,
+				bool device_was_children_of_master)
 {
 	struct spi_device	*spi;
 	struct device		*dev = master->dev.parent;
@@ -330,7 +333,10 @@ struct spi_device *spi_alloc_device(struct spi_master *master)
 	}
 
 	spi->master = master;
-	spi->dev.parent = &master->dev;
+	if (device_was_children_of_master == true)
+		spi->dev.parent = &master->dev;
+	else
+		spi->dev.parent = dev;
 	spi->dev.bus = &spi_bus_type;
 	spi->dev.release = spidev_release;
 	device_initialize(&spi->dev);
@@ -434,7 +440,7 @@ struct spi_device *spi_new_device(struct spi_master *master,
 	 * suggests syslogged diagnostics are best here (ugh).
 	 */
 
-	proxy = spi_alloc_device(master);
+	proxy = spi_alloc_device(master, false);
 	if (!proxy)
 		return NULL;
 
@@ -827,7 +833,7 @@ static void of_register_spi_devices(struct spi_master *master)
 
 	for_each_available_child_of_node(master->dev.of_node, nc) {
 		/* Alloc an spi_device */
-		spi = spi_alloc_device(master);
+		spi = spi_alloc_device(master, true);
 		if (!spi) {
 			dev_err(&master->dev, "spi_device alloc error for %s\n",
 				nc->full_name);
@@ -939,7 +945,7 @@ static acpi_status acpi_spi_add_device(acpi_handle handle, u32 level,
 	if (acpi_bus_get_status(adev) || !adev->status.present)
 		return AE_OK;
 
-	spi = spi_alloc_device(master);
+	spi = spi_alloc_device(master, false);
 	if (!spi) {
 		dev_err(&master->dev, "failed to allocate SPI device for %s\n",
 			dev_name(&adev->dev));
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index fa702ae..43d2f8e 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -838,7 +838,8 @@ spi_register_board_info(struct spi_board_info const *info, unsigned n)
  * be defined using the board info.
  */
 extern struct spi_device *
-spi_alloc_device(struct spi_master *master);
+spi_alloc_device(struct spi_master *master,
+				bool device_was_children_of_master);
 
 extern int
 spi_add_device(struct spi_device *spi);
-- 
1.7.4.1



