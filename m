Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab2DSMGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:06:43 -0400
Received: from smtp.nokia.com ([147.243.1.47]:17732 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000Ab2DSMGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:06:39 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linus.walleij@linaro.org, artem.bityutskiy@linux.intel.com,
        shubhrajyoti@ti.com
Subject: [PATCH 1/6] HSI: hsi: Rework hsi_controller release
Date: Thu, 19 Apr 2012 15:05:22 +0300
Message-Id: <1334837127-12931-2-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334837127-12931-1-git-send-email-carlos.chinea@nokia.com>
References: <1334837127-12931-1-git-send-email-carlos.chinea@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the proper release mechanism for hsi_controller and
hsi_ports structures. Free the structures through their
associated device release callbacks.

Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
---
 drivers/hsi/hsi.c       |  108 ++++++++++++++++++++++++++++------------------
 include/linux/hsi/hsi.h |    6 +-
 2 files changed, 69 insertions(+), 45 deletions(-)

diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi.c
index 4e2d79b..c17d12c 100644
--- a/drivers/hsi/hsi.c
+++ b/drivers/hsi/hsi.c
@@ -140,12 +140,17 @@ static int hsi_remove_port(struct device *dev, void *data __maybe_unused)
 	return 0;
 }
 
-static void hsi_controller_release(struct device *dev __maybe_unused)
+static void hsi_controller_release(struct device *dev)
 {
+	struct hsi_controller *hsi = to_hsi_controller(dev);
+
+	kfree(hsi->port);
+	kfree(hsi);
 }
 
-static void hsi_port_release(struct device *dev __maybe_unused)
+static void hsi_port_release(struct device *dev)
 {
+	kfree(to_hsi_port(dev));
 }
 
 /**
@@ -172,18 +177,14 @@ int hsi_register_controller(struct hsi_controller *hsi)
 
 	hsi->device.type = &hsi_ctrl;
 	hsi->device.bus = &hsi_bus_type;
-	hsi->device.release = hsi_controller_release;
-	err = device_register(&hsi->device);
+	err = device_add(&hsi->device);
 	if (err < 0)
 		return err;
 	for (i = 0; i < hsi->num_ports; i++) {
-		hsi->port[i].device.parent = &hsi->device;
-		hsi->port[i].device.bus = &hsi_bus_type;
-		hsi->port[i].device.release = hsi_port_release;
-		hsi->port[i].device.type = &hsi_port;
-		INIT_LIST_HEAD(&hsi->port[i].clients);
-		spin_lock_init(&hsi->port[i].clock);
-		err = device_register(&hsi->port[i].device);
+		hsi->port[i]->device.parent = &hsi->device;
+		hsi->port[i]->device.bus = &hsi_bus_type;
+		hsi->port[i]->device.type = &hsi_port;
+		err = device_add(&hsi->port[i]->device);
 		if (err < 0)
 			goto out;
 	}
@@ -192,7 +193,9 @@ int hsi_register_controller(struct hsi_controller *hsi)
 
 	return 0;
 out:
-	hsi_unregister_controller(hsi);
+	while (i-- > 0)
+		device_del(&hsi->port[i]->device);
+	device_del(&hsi->device);
 
 	return err;
 }
@@ -223,6 +226,29 @@ static inline int hsi_dummy_cl(struct hsi_client *cl __maybe_unused)
 }
 
 /**
+ * hsi_put_controller - Free an HSI controller
+ *
+ * @hsi: Pointer to the HSI controller to freed
+ *
+ * HSI controller drivers should only use this function if they need
+ * to free their allocated hsi_controller structures before a successful
+ * call to hsi_register_controller. Other use is not allowed.
+ */
+void hsi_put_controller(struct hsi_controller *hsi)
+{
+	unsigned int i;
+
+	if (!hsi)
+		return;
+
+	for (i = 0; i < hsi->num_ports; i++)
+		if (hsi->port && hsi->port[i])
+			put_device(&hsi->port[i]->device);
+	put_device(&hsi->device);
+}
+EXPORT_SYMBOL_GPL(hsi_put_controller);
+
+/**
  * hsi_alloc_controller - Allocate an HSI controller and its ports
  * @n_ports: Number of ports on the HSI controller
  * @flags: Kernel allocation flags
@@ -232,55 +258,53 @@ static inline int hsi_dummy_cl(struct hsi_client *cl __maybe_unused)
 struct hsi_controller *hsi_alloc_controller(unsigned int n_ports, gfp_t flags)
 {
 	struct hsi_controller	*hsi;
-	struct hsi_port		*port;
+	struct hsi_port		**port;
 	unsigned int		i;
 
 	if (!n_ports)
 		return NULL;
 
-	port = kzalloc(sizeof(*port)*n_ports, flags);
-	if (!port)
-		return NULL;
 	hsi = kzalloc(sizeof(*hsi), flags);
 	if (!hsi)
-		goto out;
-	for (i = 0; i < n_ports; i++) {
-		dev_set_name(&port[i].device, "port%d", i);
-		port[i].num = i;
-		port[i].async = hsi_dummy_msg;
-		port[i].setup = hsi_dummy_cl;
-		port[i].flush = hsi_dummy_cl;
-		port[i].start_tx = hsi_dummy_cl;
-		port[i].stop_tx = hsi_dummy_cl;
-		port[i].release = hsi_dummy_cl;
-		mutex_init(&port[i].lock);
+		return NULL;
+	port = kzalloc(sizeof(*port)*n_ports, flags);
+	if (!port) {
+		kfree(hsi);
+		return NULL;
 	}
 	hsi->num_ports = n_ports;
 	hsi->port = port;
+	hsi->device.release = hsi_controller_release;
+	device_initialize(&hsi->device);
+
+	for (i = 0; i < n_ports; i++) {
+		port[i] = kzalloc(sizeof(**port), flags);
+		if (port[i] == NULL)
+			goto out;
+		port[i]->num = i;
+		port[i]->async = hsi_dummy_msg;
+		port[i]->setup = hsi_dummy_cl;
+		port[i]->flush = hsi_dummy_cl;
+		port[i]->start_tx = hsi_dummy_cl;
+		port[i]->stop_tx = hsi_dummy_cl;
+		port[i]->release = hsi_dummy_cl;
+		mutex_init(&port[i]->lock);
+		INIT_LIST_HEAD(&hsi->port[i]->clients);
+		spin_lock_init(&hsi->port[i]->clock);
+		dev_set_name(&port[i]->device, "port%d", i);
+		hsi->port[i]->device.release = hsi_port_release;
+		device_initialize(&hsi->port[i]->device);
+	}
 
 	return hsi;
 out:
-	kfree(port);
+	hsi_put_controller(hsi);
 
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(hsi_alloc_controller);
 
 /**
- * hsi_free_controller - Free an HSI controller
- * @hsi: Pointer to HSI controller
- */
-void hsi_free_controller(struct hsi_controller *hsi)
-{
-	if (!hsi)
-		return;
-
-	kfree(hsi->port);
-	kfree(hsi);
-}
-EXPORT_SYMBOL_GPL(hsi_free_controller);
-
-/**
  * hsi_free_msg - Free an HSI message
  * @msg: Pointer to the HSI message
  *
diff --git a/include/linux/hsi/hsi.h b/include/linux/hsi/hsi.h
index 4b17806..7f3b726 100644
--- a/include/linux/hsi/hsi.h
+++ b/include/linux/hsi/hsi.h
@@ -270,13 +270,13 @@ struct hsi_controller {
 	struct module		*owner;
 	unsigned int		id;
 	unsigned int		num_ports;
-	struct hsi_port		*port;
+	struct hsi_port		**port;
 };
 
 #define to_hsi_controller(dev) container_of(dev, struct hsi_controller, device)
 
 struct hsi_controller *hsi_alloc_controller(unsigned int n_ports, gfp_t flags);
-void hsi_free_controller(struct hsi_controller *hsi);
+void hsi_put_controller(struct hsi_controller *hsi);
 int hsi_register_controller(struct hsi_controller *hsi);
 void hsi_unregister_controller(struct hsi_controller *hsi);
 
@@ -294,7 +294,7 @@ static inline void *hsi_controller_drvdata(struct hsi_controller *hsi)
 static inline struct hsi_port *hsi_find_port_num(struct hsi_controller *hsi,
 							unsigned int num)
 {
-	return (num < hsi->num_ports) ? &hsi->port[num] : NULL;
+	return (num < hsi->num_ports) ? hsi->port[num] : NULL;
 }
 
 /*
-- 
1.7.5.4

