Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934183Ab2J3SQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:16:07 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:59056 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934079Ab2J3SMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:12:44 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: [PATCH] i2c: Export capability to probe devices
Date: Wed, 31 Oct 2012 17:57:20 +0200
Message-Id: <1351699040-4445-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probe devices for a node other that the adapter node.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/of/of_i2c.c    | 14 ++++++++++----
 include/linux/of_i2c.h |  3 +++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
index 3550f3b..7f36b05 100644
--- a/drivers/of/of_i2c.c
+++ b/drivers/of/of_i2c.c
@@ -18,18 +18,18 @@
 #include <linux/of_irq.h>
 #include <linux/module.h>
 
-void of_i2c_register_devices(struct i2c_adapter *adap)
+void of_i2c_register_node_devices(struct i2c_adapter *adap,
+		struct device_node *parent_node)
 {
 	void *result;
 	struct device_node *node;
 
-	/* Only register child devices if the adapter has a node pointer set */
-	if (!adap->dev.of_node)
+	if (!parent_node)
 		return;
 
 	dev_dbg(&adap->dev, "of_i2c: walking child nodes\n");
 
-	for_each_child_of_node(adap->dev.of_node, node) {
+	for_each_child_of_node(parent_node, node) {
 		struct i2c_board_info info = {};
 		struct dev_archdata dev_ad = {};
 		const __be32 *addr;
@@ -76,6 +76,12 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
 		}
 	}
 }
+EXPORT_SYMBOL(of_i2c_register_node_devices);
+
+void of_i2c_register_devices(struct i2c_adapter *adap)
+{
+	of_i2c_register_node_devices(adap, adap->dev.of_node);
+}
 EXPORT_SYMBOL(of_i2c_register_devices);
 
 static int of_dev_node_match(struct device *dev, void *data)
diff --git a/include/linux/of_i2c.h b/include/linux/of_i2c.h
index 1cb775f..d2f8ebb6 100644
--- a/include/linux/of_i2c.h
+++ b/include/linux/of_i2c.h
@@ -15,6 +15,9 @@
 #if defined(CONFIG_OF_I2C) || defined(CONFIG_OF_I2C_MODULE)
 #include <linux/i2c.h>
 
+extern void of_i2c_register_node_devices(struct i2c_adapter *adap,
+		struct device_node *parent_node);
+
 extern void of_i2c_register_devices(struct i2c_adapter *adap);
 
 /* must call put_device() when done with returned i2c_client device */
-- 
1.7.12

