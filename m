Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab0LJUqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:46:04 -0500
Received: from mxout1.idt.com ([157.165.5.25]:39667 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229Ab0LJUp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:45:59 -0500
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Dec 2010 15:45:44 EST
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH -mm 4/4] RapidIO: Add new sysfs attributes
Date: Fri, 10 Dec 2010 15:38:18 -0500
Message-Id: <1292013498-31406-5-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1292013498-31406-1-git-send-email-alexandre.bounine@idt.com>
References: <1292013498-31406-1-git-send-email-alexandre.bounine@idt.com>
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
 drivers/rapidio/rio-sysfs.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/drivers/rapidio/rio-sysfs.c b/drivers/rapidio/rio-sysfs.c
index 76b4185..b8d9eaf 100644
--- a/drivers/rapidio/rio-sysfs.c
+++ b/drivers/rapidio/rio-sysfs.c
@@ -33,6 +33,8 @@ rio_config_attr(device_rev, "0x%08x\n");
 rio_config_attr(asm_did, "0x%04x\n");
 rio_config_attr(asm_vid, "0x%04x\n");
 rio_config_attr(asm_rev, "0x%04x\n");
+rio_config_attr(destid, "0x%04x\n");
+rio_config_attr(hopcount, "0x%02x\n");
 
 static ssize_t routes_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -52,6 +54,33 @@ static ssize_t routes_show(struct device *dev, struct device_attribute *attr, ch
 	return (str - buf);
 }
 
+static ssize_t lprev_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	struct rio_dev *rdev = to_rio_dev(dev);
+
+	return sprintf(buf, "%02d %s\n", RIO_GET_PORT_NUM(rdev->swpinfo),
+		       (rdev->prev) ? rio_name(rdev->prev) : "host");
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
+				str += sprintf(str, "%02d %s\n", i,
+					rio_name(rdev->rswitch->nextdev[i]));
+		}
+	}
+
+	return str - buf;
+}
+
 struct device_attribute rio_dev_attrs[] = {
 	__ATTR_RO(did),
 	__ATTR_RO(vid),
@@ -59,10 +88,14 @@ struct device_attribute rio_dev_attrs[] = {
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
@@ -218,7 +251,9 @@ int rio_create_sysfs_dev_files(struct rio_dev *rdev)
 	err = device_create_bin_file(&rdev->dev, &rio_config_attr);
 
 	if (!err && (rdev->pef & RIO_PEF_SWITCH)) {
-		err = device_create_file(&rdev->dev, &dev_attr_routes);
+		err |= device_create_file(&rdev->dev, &dev_attr_routes);
+		err |= device_create_file(&rdev->dev, &dev_attr_lnext);
+		err |= device_create_file(&rdev->dev, &dev_attr_hopcount);
 		if (!err && rdev->rswitch->sw_sysfs)
 			err = rdev->rswitch->sw_sysfs(rdev, RIO_SW_SYSFS_CREATE);
 	}
@@ -241,6 +276,8 @@ void rio_remove_sysfs_dev_files(struct rio_dev *rdev)
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

