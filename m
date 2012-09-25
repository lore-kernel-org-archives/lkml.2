Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab2IYN0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:26:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab2IYN0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:26:04 -0400
From: Matthew Garrett <mjg@redhat.com>
To: abelay@mit.edu
Cc: bhelgaas@google.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/2] PNP: Add a release method to system resource driver
Date: Tue, 25 Sep 2012 09:25:43 -0400
Message-Id: <1348579544-1573-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This could conceivably be hotpluggable, and we may want to displace it
from devices under certain circustances, so add a release method to hand
back the resources.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/pnp/system.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/pnp/system.c b/drivers/pnp/system.c
index 49c1720..b0a50f2 100644
--- a/drivers/pnp/system.c
+++ b/drivers/pnp/system.c
@@ -52,7 +52,17 @@ static void reserve_range(struct pnp_dev *dev, struct resource *r, int port)
 		 res ? "has been" : "could not be");
 }
 
-static void reserve_resources_of_dev(struct pnp_dev *dev)
+static void free_range(struct pnp_dev *dev, struct resource *r, int port)
+{
+	resource_size_t start = r->start, end = r->end;
+
+	if (port)
+		release_region(start, end - start + 1);
+	else
+		release_mem_region(start, end - start + 1);
+}
+
+static void handle_resources_of_dev(struct pnp_dev *dev, bool free)
 {
 	struct resource *res;
 	int i;
@@ -75,29 +85,41 @@ static void reserve_resources_of_dev(struct pnp_dev *dev)
 		if (res->end < res->start)
 			continue;	/* invalid */
 
-		reserve_range(dev, res, 1);
+		if (free)
+			free_range(dev, res, 1);
+		else
+			reserve_range(dev, res, 1);
 	}
 
 	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
 		if (res->flags & IORESOURCE_DISABLED)
 			continue;
 
-		reserve_range(dev, res, 0);
+		if (free)
+			free_range(dev, res, 0);
+		else
+			reserve_range(dev, res, 0);
 	}
 }
 
 static int system_pnp_probe(struct pnp_dev *dev,
 			    const struct pnp_device_id *dev_id)
 {
-	reserve_resources_of_dev(dev);
+	handle_resources_of_dev(dev, false);
 	return 0;
 }
 
+static void system_pnp_remove(struct pnp_dev *dev)
+{
+	handle_resources_of_dev(dev, true);
+}
+
 static struct pnp_driver system_pnp_driver = {
 	.name     = "system",
 	.id_table = pnp_dev_table,
 	.flags    = PNP_DRIVER_RES_DO_NOT_CHANGE,
 	.probe    = system_pnp_probe,
+	.remove   = system_pnp_remove,
 };
 
 static int __init pnp_system_init(void)
-- 
1.7.11.4

