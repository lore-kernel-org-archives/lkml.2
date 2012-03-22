Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030775Ab2CVDEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 23:04:22 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17272 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758841Ab2CVDES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 23:04:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian.Campbell@citrix.com, JBeulich@novell.com, linux-kernel@vger.kernel.org,
        stefano.stabellini@eu.citrix.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/xenbus: Add quirk to deal with misconfigured backends.
Date: Wed, 21 Mar 2012 22:59:49 -0400
Message-Id: <1332385189-29029-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F6A96A9.001F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A rather annoying and common case is when booting a PVonHVM guest
and exposing the PV KBD and PV VFB - as both of those do not
make any sense. The HVM guest is using the VGA driver and the emulated
keyboard for this. So we provide a very basic quirk framework
(can be expanded in the future) to not wait for 6 minutes for those devices
to initialize - they never wont.

To trigger this, put this in your guest config:

vfb = [ 'vnc=1, vnclisten=0.0.0.0 ,vncunused=1']

instead of this:
vnc=1
vnclisten="0.0.0.0"

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xenbus/xenbus_probe_frontend.c |   30 ++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe_frontend.c b/drivers/xen/xenbus/xenbus_probe_frontend.c
index f20c5f1..80325cf 100644
--- a/drivers/xen/xenbus/xenbus_probe_frontend.c
+++ b/drivers/xen/xenbus/xenbus_probe_frontend.c
@@ -134,7 +134,31 @@ static int read_backend_details(struct xenbus_device *xendev)
 {
 	return xenbus_read_otherend_details(xendev, "backend-id", "backend");
 }
+static bool skip_if_quirk(struct device *dev, void *data)
+{
+	struct xenbus_device *xendev = to_xenbus_device(dev);
+	struct device_driver *drv = data;
+
+	/* Is this operation limited to a particular driver? */
+	if (drv && (dev->driver != drv))
+		return false;
+
+	if (xen_pv_domain())
+		return false;
+
+	/* With older QEMU, for PVonHVM guests the guest config files could
+	 * contain: vfb = [ 'vnc=1, vnclisten=0.0.0.0 ,vncunused=1']
+	 * which is nonsensical as there is no PV FB (or PV KBD) when
+	 * running as HVM guest. */
 
+	if ((strncmp(xendev->nodename, "device/vkbd", 11) == 0))
+		return true;
+
+	if ((strncmp(xendev->nodename, "device/vfb", 10) == 0))
+		return true;
+
+	return false;
+}
 static int is_device_connecting(struct device *dev, void *data)
 {
 	struct xenbus_device *xendev = to_xenbus_device(dev);
@@ -153,6 +177,12 @@ static int is_device_connecting(struct device *dev, void *data)
 		return 0;
 
 	xendrv = to_xenbus_driver(dev->driver);
+
+	if (skip_if_quirk(dev, data)) {
+		printk(KERN_INFO "XENBUS: (quirk) Skipping : %s\n",
+		       xendev->nodename);
+		return 0;
+	}
 	return (xendev->state < XenbusStateConnected ||
 		(xendev->state == XenbusStateConnected &&
 		 xendrv->is_ready && !xendrv->is_ready(xendev)));
-- 
1.7.7.5

