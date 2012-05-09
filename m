Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab2EIFw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:52:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38738 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755586Ab2EIFwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:53 -0400
Message-Id: <20120509055031.123721131@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [ 011/167] [PATCH] xen/xenbus: Add quirk to deal with misconfigured backends.
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 3066616ce23aad5719c23a0f21f32676402cb44b upstream.

A rather annoying and common case is when booting a PVonHVM guest
and exposing the PV KBD and PV VFB - as broken toolstacks don't
always initialize the backends correctly.

Normally The HVM guest is using the VGA driver and the emulated
keyboard for this (though upstream version of QEMU implements
PV KBD, but still uses a VGA driver). We provide a very basic
two-stage wait mechanism - where we wait for 30 seconds for all
devices, and then for 270 for all them except the two mentioned.

That allows us to wait for the essential devices, like network
or disk for the full 6 minutes.

To trigger this, put this in your guest config:

vfb = [ 'vnc=1, vnclisten=0.0.0.0 ,vncunused=1']

instead of this:
vnc=1
vnclisten="0.0.0.0"

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
[v3: Split delay in non-essential (30 seconds) and essential
 devices per Ian and Stefano suggestion]
[v4: Added comments per Stefano suggestion]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/xen/xenbus/xenbus_probe_frontend.c |   69 +++++++++++++++++++++-------
 1 file changed, 53 insertions(+), 16 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe_frontend.c b/drivers/xen/xenbus/xenbus_probe_frontend.c
index f20c5f1..a31b54d 100644
--- a/drivers/xen/xenbus/xenbus_probe_frontend.c
+++ b/drivers/xen/xenbus/xenbus_probe_frontend.c
@@ -135,7 +135,7 @@ static int read_backend_details(struct xenbus_device *xendev)
 	return xenbus_read_otherend_details(xendev, "backend-id", "backend");
 }
 
-static int is_device_connecting(struct device *dev, void *data)
+static int is_device_connecting(struct device *dev, void *data, bool ignore_nonessential)
 {
 	struct xenbus_device *xendev = to_xenbus_device(dev);
 	struct device_driver *drv = data;
@@ -152,16 +152,41 @@ static int is_device_connecting(struct device *dev, void *data)
 	if (drv && (dev->driver != drv))
 		return 0;
 
+	if (ignore_nonessential) {
+		/* With older QEMU, for PVonHVM guests the guest config files
+		 * could contain: vfb = [ 'vnc=1, vnclisten=0.0.0.0']
+		 * which is nonsensical as there is no PV FB (there can be
+		 * a PVKB) running as HVM guest. */
+
+		if ((strncmp(xendev->nodename, "device/vkbd", 11) == 0))
+			return 0;
+
+		if ((strncmp(xendev->nodename, "device/vfb", 10) == 0))
+			return 0;
+	}
 	xendrv = to_xenbus_driver(dev->driver);
 	return (xendev->state < XenbusStateConnected ||
 		(xendev->state == XenbusStateConnected &&
 		 xendrv->is_ready && !xendrv->is_ready(xendev)));
 }
+static int essential_device_connecting(struct device *dev, void *data)
+{
+	return is_device_connecting(dev, data, true /* ignore PV[KBB+FB] */);
+}
+static int non_essential_device_connecting(struct device *dev, void *data)
+{
+	return is_device_connecting(dev, data, false);
+}
 
-static int exists_connecting_device(struct device_driver *drv)
+static int exists_essential_connecting_device(struct device_driver *drv)
 {
 	return bus_for_each_dev(&xenbus_frontend.bus, NULL, drv,
-				is_device_connecting);
+				essential_device_connecting);
+}
+static int exists_non_essential_connecting_device(struct device_driver *drv)
+{
+	return bus_for_each_dev(&xenbus_frontend.bus, NULL, drv,
+				non_essential_device_connecting);
 }
 
 static int print_device_status(struct device *dev, void *data)
@@ -192,6 +217,23 @@ static int print_device_status(struct device *dev, void *data)
 /* We only wait for device setup after most initcalls have run. */
 static int ready_to_wait_for_devices;
 
+static bool wait_loop(unsigned long start, unsigned int max_delay,
+		     unsigned int *seconds_waited)
+{
+	if (time_after(jiffies, start + (*seconds_waited+5)*HZ)) {
+		if (!*seconds_waited)
+			printk(KERN_WARNING "XENBUS: Waiting for "
+			       "devices to initialise: ");
+		*seconds_waited += 5;
+		printk("%us...", max_delay - *seconds_waited);
+		if (*seconds_waited == max_delay)
+			return true;
+	}
+
+	schedule_timeout_interruptible(HZ/10);
+
+	return false;
+}
 /*
  * On a 5-minute timeout, wait for all devices currently configured.  We need
  * to do this to guarantee that the filesystems and / or network devices
@@ -215,19 +257,14 @@ static void wait_for_devices(struct xenbus_driver *xendrv)
 	if (!ready_to_wait_for_devices || !xen_domain())
 		return;
 
-	while (exists_connecting_device(drv)) {
-		if (time_after(jiffies, start + (seconds_waited+5)*HZ)) {
-			if (!seconds_waited)
-				printk(KERN_WARNING "XENBUS: Waiting for "
-				       "devices to initialise: ");
-			seconds_waited += 5;
-			printk("%us...", 300 - seconds_waited);
-			if (seconds_waited == 300)
-				break;
-		}
-
-		schedule_timeout_interruptible(HZ/10);
-	}
+	while (exists_non_essential_connecting_device(drv))
+		if (wait_loop(start, 30, &seconds_waited))
+			break;
+
+	/* Skips PVKB and PVFB check.*/
+	while (exists_essential_connecting_device(drv))
+		if (wait_loop(start, 270, &seconds_waited))
+			break;
 
 	if (seconds_waited)
 		printk("\n");
-- 
1.7.10



