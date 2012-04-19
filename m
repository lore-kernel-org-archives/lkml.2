Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2DSMHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:07:24 -0400
Received: from smtp.nokia.com ([147.243.1.47]:17728 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007Ab2DSMGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:06:40 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linus.walleij@linaro.org, artem.bityutskiy@linux.intel.com,
        shubhrajyoti@ti.com
Subject: [PATCH 4/6] HSI: hsi: Rework hsi_event interface
Date: Thu, 19 Apr 2012 15:05:25 +0300
Message-Id: <1334837127-12931-5-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334837127-12931-1-git-send-email-carlos.chinea@nokia.com>
References: <1334837127-12931-1-git-send-email-carlos.chinea@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove custom hack and make use of the notifier chain interfaces for
delivering events from the ports to their associated clients.
Clients that want to receive port events need to register their callbacks
using hsi_register_port_event(). The callbacks can be called in interrupt
context. Use hsi_unregestier_port_event() to undo the registration.

Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
---
 drivers/hsi/hsi.c       |  101 +++++++++++++++++++++++++----------------------
 include/linux/hsi/hsi.h |   25 ++++++-----
 2 files changed, 68 insertions(+), 58 deletions(-)

diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi.c
index cec1f0c..2d58f93 100644
--- a/drivers/hsi/hsi.c
+++ b/drivers/hsi/hsi.c
@@ -21,12 +21,11 @@
  */
 #include <linux/hsi/hsi.h>
 #include <linux/compiler.h>
-#include <linux/rwsem.h>
 #include <linux/list.h>
-#include <linux/spinlock.h>
 #include <linux/kobject.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/notifier.h>
 #include "hsi_core.h"
 
 static ssize_t modalias_show(struct device *dev,
@@ -67,7 +66,6 @@ static void hsi_client_release(struct device *dev)
 static void hsi_new_client(struct hsi_port *port, struct hsi_board_info *info)
 {
 	struct hsi_client *cl;
-	unsigned long flags;
 
 	cl = kzalloc(sizeof(*cl), GFP_KERNEL);
 	if (!cl)
@@ -79,9 +77,6 @@ static void hsi_new_client(struct hsi_port *port, struct hsi_board_info *info)
 	cl->device.release = hsi_client_release;
 	dev_set_name(&cl->device, info->name);
 	cl->device.platform_data = info->platform_data;
-	spin_lock_irqsave(&port->clock, flags);
-	list_add_tail(&cl->link, &port->clients);
-	spin_unlock_irqrestore(&port->clock, flags);
 	if (info->archdata)
 		cl->device.archdata = *info->archdata;
 	if (device_register(&cl->device) < 0) {
@@ -106,13 +101,6 @@ static void hsi_scan_board_info(struct hsi_controller *hsi)
 
 static int hsi_remove_client(struct device *dev, void *data __maybe_unused)
 {
-	struct hsi_client *cl = to_hsi_client(dev);
-	struct hsi_port *port = to_hsi_port(dev->parent);
-	unsigned long flags;
-
-	spin_lock_irqsave(&port->clock, flags);
-	list_del(&cl->link);
-	spin_unlock_irqrestore(&port->clock, flags);
 	device_unregister(dev);
 
 	return 0;
@@ -271,8 +259,7 @@ struct hsi_controller *hsi_alloc_controller(unsigned int n_ports, gfp_t flags)
 		port[i]->stop_tx = hsi_dummy_cl;
 		port[i]->release = hsi_dummy_cl;
 		mutex_init(&port[i]->lock);
-		INIT_LIST_HEAD(&hsi->port[i]->clients);
-		spin_lock_init(&hsi->port[i]->clock);
+		ATOMIC_INIT_NOTIFIER_HEAD(&port[i]->n_head);
 		dev_set_name(&port[i]->device, "port%d", i);
 		hsi->port[i]->device.release = hsi_port_release;
 		device_initialize(&hsi->port[i]->device);
@@ -420,37 +407,67 @@ void hsi_release_port(struct hsi_client *cl)
 }
 EXPORT_SYMBOL_GPL(hsi_release_port);
 
-static int hsi_start_rx(struct hsi_client *cl, void *data __maybe_unused)
+static int hsi_event_notifier_call(struct notifier_block *nb,
+				unsigned long event, void *data __maybe_unused)
 {
-	if (cl->hsi_start_rx)
-		(*cl->hsi_start_rx)(cl);
+	struct hsi_client *cl = container_of(nb, struct hsi_client, nb);
+
+	(*cl->ehandler)(cl, event);
 
 	return 0;
 }
 
-static int hsi_stop_rx(struct hsi_client *cl, void *data __maybe_unused)
+/**
+ * hsi_register_port_event - Register a client to receive port events
+ * @cl: HSI client that wants to receive port events
+ * @cb: Event handler callback
+ *
+ * Clients should register a callback to be able to receive
+ * events from the ports. Registration should happen after
+ * claiming the port.
+ * The handler can be called in interrupt context.
+ *
+ * Returns -errno on error, or 0 on success.
+ */
+int hsi_register_port_event(struct hsi_client *cl,
+			void (*handler)(struct hsi_client *, unsigned long))
 {
-	if (cl->hsi_stop_rx)
-		(*cl->hsi_stop_rx)(cl);
+	struct hsi_port *port = hsi_get_port(cl);
 
-	return 0;
+	if (!handler || cl->ehandler)
+		return -EINVAL;
+	if (!hsi_port_claimed(cl))
+		return -EACCES;
+	cl->ehandler = handler;
+	cl->nb.notifier_call = hsi_event_notifier_call;
+
+	return atomic_notifier_chain_register(&port->n_head, &cl->nb);
 }
+EXPORT_SYMBOL_GPL(hsi_register_port_event);
 
-static int hsi_port_for_each_client(struct hsi_port *port, void *data,
-				int (*fn)(struct hsi_client *cl, void *data))
+/**
+ * hsi_unregister_port_event - Stop receiving port events for a client
+ * @cl: HSI client that wants to stop receiving port events
+ *
+ * Clients should call this function before releasing their associated
+ * port.
+ *
+ * Returns -errno on error, or 0 on success.
+ */
+int hsi_unregister_port_event(struct hsi_client *cl)
 {
-	struct hsi_client *cl;
+	struct hsi_port *port = hsi_get_port(cl);
+	int err;
 
-	spin_lock(&port->clock);
-	list_for_each_entry(cl, &port->clients, link) {
-		spin_unlock(&port->clock);
-		(*fn)(cl, data);
-		spin_lock(&port->clock);
-	}
-	spin_unlock(&port->clock);
+	WARN_ON(!hsi_port_claimed(cl));
 
-	return 0;
+	err = atomic_notifier_chain_unregister(&port->n_head, &cl->nb);
+	if (!err)
+		cl->ehandler = NULL;
+
+	return err;
 }
+EXPORT_SYMBOL_GPL(hsi_unregister_port_event);
 
 /**
  * hsi_event -Notifies clients about port events
@@ -464,22 +481,12 @@ static int hsi_port_for_each_client(struct hsi_port *port, void *data,
  * Events:
  * HSI_EVENT_START_RX - Incoming wake line high
  * HSI_EVENT_STOP_RX - Incoming wake line down
+ *
+ * Returns -errno on error, or 0 on success.
  */
-void hsi_event(struct hsi_port *port, unsigned int event)
+int hsi_event(struct hsi_port *port, unsigned long event)
 {
-	int (*fn)(struct hsi_client *cl, void *data);
-
-	switch (event) {
-	case HSI_EVENT_START_RX:
-		fn = hsi_start_rx;
-		break;
-	case HSI_EVENT_STOP_RX:
-		fn = hsi_stop_rx;
-		break;
-	default:
-		return;
-	}
-	hsi_port_for_each_client(port, NULL, fn);
+	return atomic_notifier_call_chain(&port->n_head, event, NULL);
 }
 EXPORT_SYMBOL_GPL(hsi_event);
 
diff --git a/include/linux/hsi/hsi.h b/include/linux/hsi/hsi.h
index 7f3b726..56fae86 100644
--- a/include/linux/hsi/hsi.h
+++ b/include/linux/hsi/hsi.h
@@ -26,9 +26,9 @@
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/scatterlist.h>
-#include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/notifier.h>
 
 /* HSI message ttype */
 #define HSI_MSG_READ	0
@@ -121,18 +121,18 @@ static inline int hsi_register_board_info(struct hsi_board_info const *info,
  * @device: Driver model representation of the device
  * @tx_cfg: HSI TX configuration
  * @rx_cfg: HSI RX configuration
- * @hsi_start_rx: Called after incoming wake line goes high
- * @hsi_stop_rx: Called after incoming wake line goes low
+ * @e_handler: Callback for handling port events (RX Wake High/Low)
+ * @pclaimed: Keeps tracks if the clients claimed its associated HSI port
+ * @nb: Notifier block for port events
  */
 struct hsi_client {
 	struct device		device;
 	struct hsi_config	tx_cfg;
 	struct hsi_config	rx_cfg;
-	void			(*hsi_start_rx)(struct hsi_client *cl);
-	void			(*hsi_stop_rx)(struct hsi_client *cl);
 	/* private: */
+	void			(*ehandler)(struct hsi_client *, unsigned long);
 	unsigned int		pclaimed:1;
-	struct list_head	link;
+	struct notifier_block	nb;
 };
 
 #define to_hsi_client(dev) container_of(dev, struct hsi_client, device)
@@ -147,6 +147,10 @@ static inline void *hsi_client_drvdata(struct hsi_client *cl)
 	return dev_get_drvdata(&cl->device);
 }
 
+int hsi_register_port_event(struct hsi_client *cl,
+			void (*handler)(struct hsi_client *, unsigned long));
+int hsi_unregister_port_event(struct hsi_client *cl);
+
 /**
  * struct hsi_client_driver - Driver associated to an HSI client
  * @driver: Driver model representation of the driver
@@ -214,8 +218,7 @@ void hsi_free_msg(struct hsi_msg *msg);
  * @start_tx: Callback to inform that a client wants to TX data
  * @stop_tx: Callback to inform that a client no longer wishes to TX data
  * @release: Callback to inform that a client no longer uses the port
- * @clients: List of hsi_clients using the port.
- * @clock: Lock to serialize access to the clients list.
+ * @n_head: Notifier chain for signaling port events to the clients.
  */
 struct hsi_port {
 	struct device			device;
@@ -231,14 +234,14 @@ struct hsi_port {
 	int				(*start_tx)(struct hsi_client *cl);
 	int				(*stop_tx)(struct hsi_client *cl);
 	int				(*release)(struct hsi_client *cl);
-	struct list_head		clients;
-	spinlock_t			clock;
+	/* private */
+	struct atomic_notifier_head	n_head;
 };
 
 #define to_hsi_port(dev) container_of(dev, struct hsi_port, device)
 #define hsi_get_port(cl) to_hsi_port((cl)->device.parent)
 
-void hsi_event(struct hsi_port *port, unsigned int event);
+int hsi_event(struct hsi_port *port, unsigned long event);
 int hsi_claim_port(struct hsi_client *cl, unsigned int share);
 void hsi_release_port(struct hsi_client *cl);
 
-- 
1.7.5.4

