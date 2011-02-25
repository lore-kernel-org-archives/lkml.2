Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab1BYS2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:28:20 -0500
Received: from mxout1.idt.com ([157.165.5.25]:43352 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932097Ab1BYS2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:28:18 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH -mm V2] rapidio: Add new sysfs attributes
Date: Fri, 25 Feb 2011 13:26:24 -0500
Message-Id: <1298658385-9842-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new sysfs attributes.

1. Routing information required to to reach the RIO device:
destid - device destination ID (real for for endpoint, route for switch)
hopcount - hopcount for maintenance requests (switches only)

2. device linking information:
lprev - name of device that precedes the given device in the enumeration
        or discovery order (displayed along with of the port to which it
        is attached).
lnext - names of devices (with corresponding port numbers) that are
        attached to the given device as next in the enumeration or
        discovery order (switches only)

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
---
 Documentation/rapidio/sysfs.txt |   17 +++++++++++++--
 drivers/rapidio/rio-sysfs.c     |   41 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/Documentation/rapidio/sysfs.txt b/Documentation/rapidio/sysfs.txt
index d6d986e..97f71ce 100755
--- a/Documentation/rapidio/sysfs.txt
+++ b/Documentation/rapidio/sysfs.txt
@@ -36,6 +36,10 @@ device_rev - returns the device revision level
    asm_did - returns identifier for the assembly containing the device
    asm_rev - returns revision level of the assembly containing the device
    asm_vid - returns vendor identifier of the assembly containing the device
+   destid  - returns device destination ID assigned by the enumeration routine
+             (see 4.1 for switch specific details)
+   lprev   - returns name of previous device (switch) on the path to the device
+             that that owns this attribute
 
 In addition to the files listed above, each device has a binary attribute file
 that allows read/write access to the device configuration registers using
@@ -66,9 +70,16 @@ set by the switch initialization routine during enumeration or discovery process
 
 4.1 Common Switch Attributes
 
- routes - reports switch routing information in "destID port" format. This
-          attribute reports only valid routing table entries, one line for
-          each entry.
+   routes - reports switch routing information in "destID port" format. This
+            attribute reports only valid routing table entries, one line for
+            each entry.
+   destid - device destination ID that defines a route to the switch
+ hopcount - number of hops on the path to the switch
+    lnext - returns names of devices linked to the switch except one of a device
+            linked to the ingress port (reported as "lprev"). This is an array
+            names with number of lines equal to number of ports in switch. If
+            a switch port has no attached device, returns "null" instead of
+            a device name.
 
 4.2 Device-specific Switch Attributes
 
diff --git a/drivers/rapidio/rio-sysfs.c b/drivers/rapidio/rio-sysfs.c
index c04dbc7..4dbe360 100644
--- a/drivers/rapidio/rio-sysfs.c
+++ b/drivers/rapidio/rio-sysfs.c
@@ -34,6 +34,8 @@ rio_config_attr(device_rev, "0x%08x\n");
 rio_config_attr(asm_did, "0x%04x\n");
 rio_config_attr(asm_vid, "0x%04x\n");
 rio_config_attr(asm_rev, "0x%04x\n");
+rio_config_attr(destid, "0x%04x\n");
+rio_config_attr(hopcount, "0x%02x\n");
 
 static ssize_t routes_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -53,6 +55,35 @@ static ssize_t routes_show(struct device *dev, struct device_attribute *attr, ch
 	return (str - buf);
 }
 
+static ssize_t lprev_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	struct rio_dev *rdev = to_rio_dev(dev);
+
+	return sprintf(buf, "%s\n",
+			(rdev->prev) ? rio_name(rdev->prev) : "root");
+}
+
+static ssize_t lnext_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	struct rio_dev *rdev = to_rio_dev(dev);
+	char *str = buf;
+	int i;
+
+	if (rdev->pef & RIO_PEF_SWITCH) {
+		for (i = 0; i < RIO_GET_TOTAL_PORTS(rdev->swpinfo); i++) {
+			if (rdev->rswitch->nextdev[i])
+				str += sprintf(str, "%s\n",
+					rio_name(rdev->rswitch->nextdev[i]));
+			else
+				str += sprintf(str, "null\n");
+		}
+	}
+
+	return str - buf;
+}
+
 struct device_attribute rio_dev_attrs[] = {
 	__ATTR_RO(did),
 	__ATTR_RO(vid),
@@ -60,10 +91,14 @@ struct device_attribute rio_dev_attrs[] = {
 	__ATTR_RO(asm_did),
 	__ATTR_RO(asm_vid),
 	__ATTR_RO(asm_rev),
+	__ATTR_RO(lprev),
+	__ATTR_RO(destid),
 	__ATTR_NULL,
 };
 
 static DEVICE_ATTR(routes, S_IRUGO, routes_show, NULL);
+static DEVICE_ATTR(lnext, S_IRUGO, lnext_show, NULL);
+static DEVICE_ATTR(hopcount, S_IRUGO, hopcount_show, NULL);
 
 static ssize_t
 rio_read_config(struct file *filp, struct kobject *kobj,
@@ -219,7 +254,9 @@ int rio_create_sysfs_dev_files(struct rio_dev *rdev)
 	err = device_create_bin_file(&rdev->dev, &rio_config_attr);
 
 	if (!err && (rdev->pef & RIO_PEF_SWITCH)) {
-		err = device_create_file(&rdev->dev, &dev_attr_routes);
+		err |= device_create_file(&rdev->dev, &dev_attr_routes);
+		err |= device_create_file(&rdev->dev, &dev_attr_lnext);
+		err |= device_create_file(&rdev->dev, &dev_attr_hopcount);
 		if (!err && rdev->rswitch->sw_sysfs)
 			err = rdev->rswitch->sw_sysfs(rdev, RIO_SW_SYSFS_CREATE);
 	}
@@ -242,6 +279,8 @@ void rio_remove_sysfs_dev_files(struct rio_dev *rdev)
 	device_remove_bin_file(&rdev->dev, &rio_config_attr);
 	if (rdev->pef & RIO_PEF_SWITCH) {
 		device_remove_file(&rdev->dev, &dev_attr_routes);
+		device_remove_file(&rdev->dev, &dev_attr_lnext);
+		device_remove_file(&rdev->dev, &dev_attr_hopcount);
 		if (rdev->rswitch->sw_sysfs)
 			rdev->rswitch->sw_sysfs(rdev, RIO_SW_SYSFS_REMOVE);
 	}
-- 
1.7.3.1

