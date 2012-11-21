Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab2KUSXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 13:23:24 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54036 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab2KUSXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 13:23:13 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] of: use platform_device_add
Date: Wed, 21 Nov 2012 18:15:59 +0000
Message-Id: <1353521759-28263-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows platform_device_add a chance to call insert_resource on all
of the resources from OF. At a minimum this fills in proc/iomem and
presumably makes resource tracking and conflict detection work better.
However, it has the side effect of moving all OF generated platform
devices from /sys/devices to /sys/devices/platform/. It /shouldn't/
break userspace because userspace is not supposed to depend on the full
path (because userspace always does what it is supposed to, right?).

It also has a backup call to of_device_add() when running on PowerPC to
catch any devices that have overlapping regions. It will complain about
them, but it will not fail to register the device.

Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Greg, do you mind taking a look at this? The reason the OF code hasn't been
calling platform_device_add() directly to this point is:
a) there are some trees with resource overlays
b) I want the devices in /sys/devices not /sys/devices/platform.

I could easily add exceptions to platform_device_add() for both those cases, but
I don't like adding DT exceptions to the common code. However, I still need to
support the platforms that unfortunately have overlapping resources. This patch
does that by still calling the old path if platform_device_add() fails, but it
isn't nice either because of_device_add() has to duplicate
platform_device_add(). Blech. Plus the exception only applies for PowerPC.

So, how do you feel about having a 'relaxed' mode for platform_device_add()
which means it won't fail if resources overlap and maybe won't do the silly
platform_bus parent thing. Thoughts?

g.

 drivers/of/platform.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index b80891b..3d7ba40 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -203,6 +203,7 @@ struct platform_device *of_platform_device_create_pdata(
 					struct device *parent)
 {
 	struct platform_device *dev;
+	int rc;
 
 	if (!of_device_is_available(np))
 		return NULL;
@@ -214,16 +215,39 @@ struct platform_device *of_platform_device_create_pdata(
 #if defined(CONFIG_MICROBLAZE)
 	dev->archdata.dma_mask = 0xffffffffUL;
 #endif
+	dev->name = dev_name(&dev->dev);
 	dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-	dev->dev.bus = &platform_bus_type;
 	dev->dev.platform_data = platform_data;
+	dev->dev.id = PLATFORM_DEVID_NONE;
+	/* device_add will assume that this device is on the same node as
+	 * the parent. If there is no parent defined, set the node
+	 * explicitly */
+	if (!parent)
+		set_dev_node(&dev->dev, of_node_to_nid(np));
 
 	/* We do not fill the DMA ops for platform devices by default.
 	 * This is currently the responsibility of the platform code
 	 * to do such, possibly using a device notifier
 	 */
 
-	if (of_device_add(dev) != 0) {
+	rc = platform_device_add(dev);
+#ifdef CONFIG_POWERPC
+	/*
+	 * This POWERPC block isn't pretty, but the commit that adds it is a
+	 * little risky. There are possibly some powerpc platforms that have
+	 * overlapping resources in the device tree. If so, then I want to find
+	 * them, but I don't want to break support in the process. So, if
+	 * platform_device_add() fails, then register the device anyway, but
+	 * complain about it. Hopefully we can find and fix and problem
+	 * platforms before removing this code.
+	 */
+	if (rc == -EBUSY) {
+		dev_warn(&dev->dev, "WARNING: resource overlap in DT node %s\n",
+			np->full_name);
+		rc = of_device_add(dev);
+	}
+#endif
+	if (rc) {
 		platform_device_put(dev);
 		return NULL;
 	}
-- 
1.7.10.4

