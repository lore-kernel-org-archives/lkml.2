Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab1K1TCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:02:48 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:32839 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab1K1TCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:02:47 -0500
From: =?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?= <jeff.dagenais@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?= <jeff.dagenais@gmail.com>
Subject: [PATCH] mfd: core - make sure children are cells during mfd_remove_devices
Date: Mon, 28 Nov 2011 14:01:31 -0500
Message-Id: <1322506891-17006-1-git-send-email-jeff.dagenais@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <2F9D884C-6B95-4F81-8445-8056676B28D8@sonatest.com>
References: <2F9D884C-6B95-4F81-8445-8056676B28D8@sonatest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MFD core assumes that all children of a parent MFD device are platform
devices and cells. This may not always be the case.

For example a PCI driver may register it's BAR0 with UIO (that creates a child
device) and also declare MFD cells which use resources of the PCI device. In
such a scenario, mfd_remove_devices would fall upon the UIO device, treat it
as a platform_device (which its not), then proceed to dereference the cell
pointer, which is then arbitrary memory.

This commit make mfd_remove_device use the bus_for_each_dev to find the true
platform devices under a given parent, and further checks if the cell pointer
is set to really make sure the given device is what we think it is.

Signed-off-by: Jean-François Dagenais <jeff.dagenais@gmail.com>
---
 drivers/mfd/mfd-core.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 0902523..e82f02e 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -180,15 +180,23 @@ int mfd_add_devices(struct device *parent, int id,
 }
 EXPORT_SYMBOL(mfd_add_devices);
 
+struct mfd_remove_devices_fn_data {
+	struct device *parent;
+	atomic_t *cnts;
+};
+
 static int mfd_remove_devices_fn(struct device *dev, void *c)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	const struct mfd_cell *cell = mfd_get_cell(pdev);
-	atomic_t **usage_count = c;
+	struct mfd_remove_devices_fn_data *rm_data = c;
+
+	if(rm_data->parent != dev->parent || !cell)
+		return 0;
 
 	/* find the base address of usage_count pointers (for freeing) */
-	if (!*usage_count || (cell->usage_count < *usage_count))
-		*usage_count = cell->usage_count;
+	if (!rm_data->cnts || (cell->usage_count < rm_data->cnts))
+		rm_data->cnts = cell->usage_count;
 
 	platform_device_unregister(pdev);
 	return 0;
@@ -196,10 +204,14 @@ static int mfd_remove_devices_fn(struct device *dev, void *c)
 
 void mfd_remove_devices(struct device *parent)
 {
-	atomic_t *cnts = NULL;
-
-	device_for_each_child(parent, &cnts, mfd_remove_devices_fn);
-	kfree(cnts);
+	struct mfd_remove_devices_fn_data fn_data = {
+		.parent = parent,
+		.cnts = NULL,
+	};
+
+	bus_for_each_dev(&platform_bus_type, NULL,
+	                 &fn_data, mfd_remove_devices_fn);
+	kfree(fn_data.cnts);
 }
 EXPORT_SYMBOL(mfd_remove_devices);
 
-- 
1.7.6

