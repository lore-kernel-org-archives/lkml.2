Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab1FXWBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 18:01:05 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:55017 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab1FXWBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 18:01:00 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jun 2011 18:00:59 EDT
Date: Fri, 24 Jun 2011 23:51:46 +0200
From: Bastian Blank <waldi@debian.org>
To: xen-devel@lists.xensource.com, virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] xen: Populate xenbus device attributes
Message-ID: <20110624215146.GA4735@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	xen-devel@lists.xensource.com,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The xenbus bus type uses device_create_file to assign all used device
attributes. However it does not remove them when the device goes away.

This patch uses the dev_attrs field of the bus type to specify default
attributes for all devices.

Signed-off-by: Bastian Blank <waldi@debian.org>
---
 drivers/xen/xenbus/xenbus_probe.c          |   41 +++++++++------------------
 drivers/xen/xenbus/xenbus_probe.h          |    2 +
 drivers/xen/xenbus/xenbus_probe_backend.c  |    6 +---
 drivers/xen/xenbus/xenbus_probe_frontend.c |    6 +---
 4 files changed, 18 insertions(+), 37 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 7397695..2ed0b04 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -378,26 +378,31 @@ static void xenbus_dev_release(struct device *dev)
 		kfree(to_xenbus_device(dev));
 }
 
-static ssize_t xendev_show_nodename(struct device *dev,
-				    struct device_attribute *attr, char *buf)
+static ssize_t nodename_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
 {
 	return sprintf(buf, "%s\n", to_xenbus_device(dev)->nodename);
 }
-static DEVICE_ATTR(nodename, S_IRUSR | S_IRGRP | S_IROTH, xendev_show_nodename, NULL);
 
-static ssize_t xendev_show_devtype(struct device *dev,
-				   struct device_attribute *attr, char *buf)
+static ssize_t devtype_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
 {
 	return sprintf(buf, "%s\n", to_xenbus_device(dev)->devicetype);
 }
-static DEVICE_ATTR(devtype, S_IRUSR | S_IRGRP | S_IROTH, xendev_show_devtype, NULL);
 
-static ssize_t xendev_show_modalias(struct device *dev,
-				    struct device_attribute *attr, char *buf)
+static ssize_t modalias_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
 {
 	return sprintf(buf, "xen:%s\n", to_xenbus_device(dev)->devicetype);
 }
-static DEVICE_ATTR(modalias, S_IRUSR | S_IRGRP | S_IROTH, xendev_show_modalias, NULL);
+
+struct device_attribute xenbus_dev_attrs[] = {
+	__ATTR_RO(nodename),
+	__ATTR_RO(devtype),
+	__ATTR_RO(modalias),
+	__ATTR_NULL
+};
+EXPORT_SYMBOL_GPL(xenbus_dev_attrs);
 
 int xenbus_probe_node(struct xen_bus_type *bus,
 		      const char *type,
@@ -449,25 +454,7 @@ int xenbus_probe_node(struct xen_bus_type *bus,
 	if (err)
 		goto fail;
 
-	err = device_create_file(&xendev->dev, &dev_attr_nodename);
-	if (err)
-		goto fail_unregister;
-
-	err = device_create_file(&xendev->dev, &dev_attr_devtype);
-	if (err)
-		goto fail_remove_nodename;
-
-	err = device_create_file(&xendev->dev, &dev_attr_modalias);
-	if (err)
-		goto fail_remove_devtype;
-
 	return 0;
-fail_remove_devtype:
-	device_remove_file(&xendev->dev, &dev_attr_devtype);
-fail_remove_nodename:
-	device_remove_file(&xendev->dev, &dev_attr_nodename);
-fail_unregister:
-	device_unregister(&xendev->dev);
 fail:
 	kfree(xendev);
 	return err;
diff --git a/drivers/xen/xenbus/xenbus_probe.h b/drivers/xen/xenbus/xenbus_probe.h
index 888b990..b814935 100644
--- a/drivers/xen/xenbus/xenbus_probe.h
+++ b/drivers/xen/xenbus/xenbus_probe.h
@@ -48,6 +48,8 @@ struct xen_bus_type
 	struct bus_type bus;
 };
 
+extern struct device_attribute xenbus_dev_attrs[];
+
 extern int xenbus_match(struct device *_dev, struct device_driver *_drv);
 extern int xenbus_dev_probe(struct device *_dev);
 extern int xenbus_dev_remove(struct device *_dev);
diff --git a/drivers/xen/xenbus/xenbus_probe_backend.c b/drivers/xen/xenbus/xenbus_probe_backend.c
index 6cf467b..ec510e5 100644
--- a/drivers/xen/xenbus/xenbus_probe_backend.c
+++ b/drivers/xen/xenbus/xenbus_probe_backend.c
@@ -183,10 +183,6 @@ static void frontend_changed(struct xenbus_watch *watch,
 	xenbus_otherend_changed(watch, vec, len, 0);
 }
 
-static struct device_attribute xenbus_backend_dev_attrs[] = {
-	__ATTR_NULL
-};
-
 static struct xen_bus_type xenbus_backend = {
 	.root = "backend",
 	.levels = 3,		/* backend/type/<frontend>/<id> */
@@ -200,7 +196,7 @@ static struct xen_bus_type xenbus_backend = {
 		.probe		= xenbus_dev_probe,
 		.remove		= xenbus_dev_remove,
 		.shutdown	= xenbus_dev_shutdown,
-		.dev_attrs	= xenbus_backend_dev_attrs,
+		.dev_attrs	= xenbus_dev_attrs,
 	},
 };
 
diff --git a/drivers/xen/xenbus/xenbus_probe_frontend.c b/drivers/xen/xenbus/xenbus_probe_frontend.c
index b6a2690..ed2ba47 100644
--- a/drivers/xen/xenbus/xenbus_probe_frontend.c
+++ b/drivers/xen/xenbus/xenbus_probe_frontend.c
@@ -81,10 +81,6 @@ static void backend_changed(struct xenbus_watch *watch,
 	xenbus_otherend_changed(watch, vec, len, 1);
 }
 
-static struct device_attribute xenbus_frontend_dev_attrs[] = {
-	__ATTR_NULL
-};
-
 static const struct dev_pm_ops xenbus_pm_ops = {
 	.suspend	= xenbus_dev_suspend,
 	.resume		= xenbus_dev_resume,
@@ -106,7 +102,7 @@ static struct xen_bus_type xenbus_frontend = {
 		.probe		= xenbus_dev_probe,
 		.remove		= xenbus_dev_remove,
 		.shutdown	= xenbus_dev_shutdown,
-		.dev_attrs	= xenbus_frontend_dev_attrs,
+		.dev_attrs	= xenbus_dev_attrs,
 
 		.pm		= &xenbus_pm_ops,
 	},
-- 
1.7.5.4

