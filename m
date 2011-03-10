Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab1CJUX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 15:23:28 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:18717 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab1CJUX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 15:23:27 -0500
Subject: [PATCH] cciss: export resettable host attribute
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Thu, 10 Mar 2011 14:23:26 -0600
Message-ID: <20110310202326.30581.9475.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This attribute, requested by Redhat, allows kexec-tools to know
whether the controller can honor the reset_devices kernel parameter
and actually reset the controller.  For kdump to work properly it
is necessary that the reset_devices parameter be honored.  This
attribute enables kexec-tools to warn the user if they attempt to
designate a non-resettable controller as the dump device.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 .../ABI/testing/sysfs-bus-pci-devices-cciss        |   12 ++++++
 drivers/block/cciss.c                              |   39 ++++++++++++++++++++
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss b/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
index 4f29e5f..f5bb0a3 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
+++ b/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
@@ -59,3 +59,15 @@ Kernel Version: 2.6.31
 Contact:	iss_storagedev@hp.com
 Description:	Displays the usage count (number of opens) of logical drive Y
 		of controller X.
+
+Where:		/sys/bus/pci/devices/<dev>/ccissX/resettable
+Date:		February 2011
+Kernel Version:	2.6.38
+Contact:	iss_storagedev@hp.com
+Description:	Value of 1 indicates the controller can honor the reset_devices
+		kernel parameter.  Value of 0 indicates reset_devices cannot be
+		honored.  This is to allow, for example, kexec tools to be able
+		to warn the user if they designate an unresettable device as
+		a dump device, as kdump requires resetting the device in order
+		to work reliably.
+
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 8e52e63..f6a9fdb 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -560,6 +560,44 @@ static void __devinit cciss_procinit(ctlr_info_t *h)
 #define to_hba(n) container_of(n, struct ctlr_info, dev)
 #define to_drv(n) container_of(n, drive_info_struct, dev)
 
+/* List of controllers which cannot be reset on kexec with reset_devices */
+static u32 unresettable_controller[] = {
+	0x324a103C, /* Smart Array P712m */
+	0x324b103C, /* SmartArray P711m */
+	0x3223103C, /* Smart Array P800 */
+	0x3234103C, /* Smart Array P400 */
+	0x3235103C, /* Smart Array P400i */
+	0x3211103C, /* Smart Array E200i */
+	0x3212103C, /* Smart Array E200 */
+	0x3213103C, /* Smart Array E200i */
+	0x3214103C, /* Smart Array E200i */
+	0x3215103C, /* Smart Array E200i */
+	0x3237103C, /* Smart Array E500 */
+	0x323D103C, /* Smart Array P700m */
+	0x409C0E11, /* Smart Array 6400 */
+	0x409D0E11, /* Smart Array 6400 EM */
+};
+
+static int ctlr_is_resettable(struct ctlr_info *h)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(unresettable_controller); i++)
+		if (unresettable_controller[i] == h->board_id)
+			return 0;
+	return 1;
+}
+
+static ssize_t host_show_resettable(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct ctlr_info *h = to_hba(dev);
+
+	return snprintf(buf, 20, "%d\n", ctlr_is_resettable(h));
+}
+static DEVICE_ATTR(resettable, S_IRUGO, host_show_resettable, NULL);
+
 static ssize_t host_store_rescan(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
@@ -745,6 +783,7 @@ static DEVICE_ATTR(usage_count, S_IRUGO, cciss_show_usage_count, NULL);
 
 static struct attribute *cciss_host_attrs[] = {
 	&dev_attr_rescan.attr,
+	&dev_attr_resettable.attr,
 	NULL
 };
 

