Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab0ERKa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 06:30:57 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:6931 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016Ab0ERK3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 06:29:44 -0400
X-IronPort-AV: E=Sophos;i="4.53,254,1272859200"; 
   d="scan'208";a="97477216"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 12/12] Initialize xenbus device structs with ENODEV as default state
Date: Tue, 18 May 2010 11:23:07 +0100
Message-Id: <1274178187-20602-12-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop>
References: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop>
X-OriginalArrivalTime: 18 May 2010 10:20:15.0450 (UTC) FILETIME=[B528C3A0:01CAF673]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Dutile <ddutile@redhat.com>

this way if xenbus isn't configured in a FV xen guest,
loading pv drivers (like netfront) won't crash the guest.

Signed-off-by: Don Dutile <ddutile@redhat.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/xenbus/xenbus_probe.c |   29 +++++++++++++++++++++++++----
 drivers/xen/xenbus/xenbus_probe.h |    1 +
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index f83e083..5e8dae6 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -188,6 +188,11 @@ static struct xen_bus_type xenbus_frontend = {
 	.levels = 2, 		/* device/type/<id> */
 	.get_bus_id = frontend_bus_id,
 	.probe = xenbus_probe_frontend,
+	/* 
+	 * to ensure loading pv-on-hvm drivers on FV guest
+	 * doesn't blow up trying to use uninit'd xenbus.
+	 */
+	.error = -ENODEV,
 	.bus = {
 		.name      = "xen",
 		.match     = xenbus_match,
@@ -352,6 +357,9 @@ int xenbus_register_driver_common(struct xenbus_driver *drv,
 				  struct module *owner,
 				  const char *mod_name)
 {
+	if (bus->error)
+		return bus->error;
+
 	drv->driver.name = drv->name;
 	drv->driver.bus = &bus->bus;
 	drv->driver.owner = owner;
@@ -484,8 +492,12 @@ int xenbus_probe_node(struct xen_bus_type *bus,
 	struct xenbus_device *xendev;
 	size_t stringlen;
 	char *tmpstring;
+	enum xenbus_state state;
+
+	if (bus->error)
+		return bus->error;
 
-	enum xenbus_state state = xenbus_read_driver_state(nodename);
+	state = xenbus_read_driver_state(nodename);
 
 	if (state != XenbusStateInitialising) {
 		/* Device is not new, so ignore it.  This can happen if a
@@ -593,6 +605,9 @@ int xenbus_probe_devices(struct xen_bus_type *bus)
 	char **dir;
 	unsigned int i, dir_n;
 
+	if (bus->error)
+		return bus->error;
+
 	dir = xenbus_directory(XBT_NIL, bus->root, "", &dir_n);
 	if (IS_ERR(dir))
 		return PTR_ERR(dir);
@@ -636,7 +651,7 @@ void xenbus_dev_changed(const char *node, struct xen_bus_type *bus)
 	char type[XEN_BUS_ID_SIZE];
 	const char *p, *root;
 
-	if (char_count(node, '/') < 2)
+	if (bus->error || char_count(node, '/') < 2)
 		return;
 
 	exists = xenbus_exists(XBT_NIL, node, "");
@@ -829,8 +844,8 @@ int xenbus_probe_init(void)
 	DPRINTK("");
 
 	/* Register ourselves with the kernel bus subsystem */
-	err = bus_register(&xenbus_frontend.bus);
-	if (err)
+	xenbus_frontend.error = bus_register(&xenbus_frontend.bus);
+	if (xenbus_frontend.error)
 		goto out_error;
 
 	err = xenbus_backend_bus_register();
@@ -923,6 +938,9 @@ static int is_device_connecting(struct device *dev, void *data)
 
 static int exists_connecting_device(struct device_driver *drv)
 {
+	if (xenbus_frontend.error)
+		return xenbus_frontend.error;
+
 	return bus_for_each_dev(&xenbus_frontend.bus, NULL, drv,
 				is_device_connecting);
 }
@@ -1002,6 +1020,9 @@ static void wait_for_devices(struct xenbus_driver *xendrv)
 #ifndef MODULE
 static int __init boot_wait_for_devices(void)
 {
+	if (!xenbus_frontend.error)
+		return xenbus_frontend.error;
+
 	ready_to_wait_for_devices = 1;
 	wait_for_devices(NULL);
 	return 0;
diff --git a/drivers/xen/xenbus/xenbus_probe.h b/drivers/xen/xenbus/xenbus_probe.h
index 6c5e318..15febe4 100644
--- a/drivers/xen/xenbus/xenbus_probe.h
+++ b/drivers/xen/xenbus/xenbus_probe.h
@@ -53,6 +53,7 @@ static inline void xenbus_backend_bus_unregister(void) {}
 struct xen_bus_type
 {
 	char *root;
+	int error;
 	unsigned int levels;
 	int (*get_bus_id)(char bus_id[XEN_BUS_ID_SIZE], const char *nodename);
 	int (*probe)(const char *type, const char *dir);
-- 
1.5.4.3

