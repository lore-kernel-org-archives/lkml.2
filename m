Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab2KBKq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 06:46:28 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:60098 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755185Ab2KBKq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 06:46:27 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: rob.herring@calxeda.com, grant.likely@secretlab.ca
Cc: srinivas.kandagatla@st.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: [RFC PATCH 3.7.0-rc2] dt/platform: insert resources correctly into resource tree
Date: Fri,  2 Nov 2012 10:46:19 +0000
Message-Id: <1351853179-27741-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch add new code to correctly add resources into platform device.
Issue with the existing code was the resources are added as flat entry
without creating any tree, this is very much different to what non-dt
platform code does.

With this patch the resources appear correctly as tree in /proc/iomem,
without this patch the resources in /proc/iomem appear as single entry.

i2c example in /proc/iomem:

With-patch:

fed41000-fed4110f : /soc/i2c-stm@fed41000
  fed41000-fed4110f : i2c

Without patch:
fed41000-fed4110f : i2c

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
Hi All, 
Recently I noticed that appearance of /proc/iomem ouput changed 
when I started using device trees and the reason for this was 
the of-plaform code was not adding resources in same way as 
non-dt platform code does.

Do you have any reason for not doing it the same way as non-dt platform code?

This patch is a fixup to that issue.

Comment?
thanks,
srini

 drivers/of/platform.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index b80891b..f43922c 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -203,6 +203,7 @@ struct platform_device *of_platform_device_create_pdata(
 					struct device *parent)
 {
 	struct platform_device *dev;
+	int i;
 
 	if (!of_device_is_available(np))
 		return NULL;
@@ -218,6 +219,28 @@ struct platform_device *of_platform_device_create_pdata(
 	dev->dev.bus = &platform_bus_type;
 	dev->dev.platform_data = platform_data;
 
+	for (i = 0; i < dev->num_resources; i++) {
+		struct resource *p, *r = &dev->resource[i];
+
+		if (r->name == NULL)
+			r->name = dev_name(&dev->dev);
+
+		p = r->parent;
+		if (!p) {
+			if (resource_type(r) == IORESOURCE_MEM)
+				p = &iomem_resource;
+			else if (resource_type(r) == IORESOURCE_IO)
+				p = &ioport_resource;
+		}
+
+		if (p && insert_resource(p, r)) {
+			pr_err("%s: failed to claim resource %d\n",
+			       dev_name(&dev->dev), i);
+			platform_device_put(dev);
+			return NULL;
+		}
+	}
+
 	/* We do not fill the DMA ops for platform devices by default.
 	 * This is currently the responsibility of the platform code
 	 * to do such, possibly using a device notifier
-- 
1.7.0.4

