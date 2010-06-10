Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab0FJFl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 01:41:27 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51045 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab0FJFlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 01:41:13 -0400
Subject: [PATCH v2 5/5] of/device: Add OF style matching helper function
To: dbrownell@users.sourceforge.net, avorontsov@ru.mvista.com
From: Grant Likely <grant.likely@secretlab.ca>
Cc: bgat@billgatliff.com, dbaryshkov@gmail.com, benh@kernel.crashing.org,
       devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org
Date: Wed, 09 Jun 2010 23:41:07 -0600
Message-ID: <20100610054107.16716.88401.stgit@angua>
In-Reply-To: <20100610053439.16716.53944.stgit@angua>
References: <20100610053439.16716.53944.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_driver_match_device() helper function.  This function can be used
by bus types to determine if a driver works with a device when using OF
style matching.  If CONFIG_OF is unselected, then it is a nop.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Michal Simek <monstr@monstr.eu>
CC: Grant Likely <grant.likely@secretlab.ca>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-kernel@vger.kernel.org
CC: microblaze-uclinux@itee.uq.edu.au
CC: linuxppc-dev@ozlabs.org
CC: devicetree-discuss@lists.ozlabs.org
---
 drivers/of/device.c       |    2 +-
 include/linux/of_device.h |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/of/device.c b/drivers/of/device.c
index c2a98f5..5282a20 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -20,7 +20,7 @@
 const struct of_device_id *of_match_device(const struct of_device_id *matches,
 					   const struct device *dev)
 {
-	if (!dev->of_node)
+	if ((!matches) || (!dev->of_node))
 		return NULL;
 	return of_match_node(matches, dev->of_node);
 }
diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index 238e92e..91d75fb 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -30,6 +30,17 @@
 extern const struct of_device_id *of_match_device(
 	const struct of_device_id *matches, const struct device *dev);
 
+/**
+ * of_driver_match_device - Tell if a driver's of_match_table matches a device.
+ * @drv: the device_driver structure to test
+ * @dev: the device structure to match against
+ */
+static inline int of_driver_match_device(const struct device *dev,
+					 const struct device_driver *drv)
+{
+	return of_match_device(drv->of_match_table, dev) != NULL;
+}
+
 extern struct of_device *of_dev_get(struct of_device *dev);
 extern void of_dev_put(struct of_device *dev);
 
@@ -48,6 +59,14 @@ extern ssize_t of_device_get_modalias(struct device *dev,
 extern int of_device_uevent(struct device *dev, struct kobj_uevent_env *env);
 
 
+#else /* CONFIG_OF_DEVICE */
+
+static inline int of_driver_match_device(struct device *dev,
+					 struct device_driver *drv)
+{
+	return 0;
+}
+
 #endif /* CONFIG_OF_DEVICE */
 
 #endif /* _LINUX_OF_DEVICE_H */

