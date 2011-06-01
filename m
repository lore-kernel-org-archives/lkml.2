Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab1FAFOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 01:14:23 -0400
Received: from relay03.digicable.hu ([92.249.128.185]:55186 "EHLO
	relay03.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab1FAFOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 01:14:21 -0400
Message-ID: <4DE5CA9F.6010303@freemail.hu>
Date: Wed, 01 Jun 2011 07:14:07 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>,
        Kulikov Vasiliy <segooon@gmail.com>, Endre Kollar <taxy443@gmail.com>,
        Arjan Mels <arjan.mels@gmx.net>, Ilia Mirkin <imirkin@alum.mit.edu>,
        David Chang <dchang@novell.com>,
        Himanshu Chauhan <hschauhan@nulltrace.org>,
        Max Vozeler <max@vozeler.com>, Arnd Bergmann <arnd@arndb.de>,
        usbip-devel@lists.sourceforge.net, devel@driverdev.osuosl.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] usbip: handle length at sysfs show() functions
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 94.21.187.248
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The sysfs show() functions shall return the actual content length of
the result buffer. According to Documentation/filesystems/sysfs.txt:215
the scnprintf() function is preferred.

See also the article titled "snprintf() confusion" at
http://lwn.net/Articles/69419/ .

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index 6e99ec8..af5f107 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -80,7 +80,7 @@ static ssize_t show_status(struct device *dev, struct device_attribute *attr,
 	status = sdev->ud.status;
 	spin_unlock(&sdev->ud.lock);

-	return snprintf(buf, PAGE_SIZE, "%d\n", status);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", status);
 }
 static DEVICE_ATTR(usbip_status, S_IRUGO, show_status, NULL);

diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
index e9085d6..604e6bb 100644
--- a/drivers/staging/usbip/stub_main.c
+++ b/drivers/staging/usbip/stub_main.c
@@ -79,18 +79,22 @@ static ssize_t show_match_busid(struct device_driver *drv, char *buf)
 {
 	int i;
 	char *out = buf;
+	int count = 0;

 	spin_lock(&busid_table_lock);

 	for (i = 0; i < MAX_BUSID; i++)
-		if (busid_table[i].name[0])
-			out += sprintf(out, "%s ", busid_table[i].name);
+		if (busid_table[i].name[0]) {
+			count += scnprintf(out, PAGE_SIZE - count,
+					"%s ", busid_table[i].name);
+			out = buf + count;
+		}

 	spin_unlock(&busid_table_lock);

-	out += sprintf(out, "\n");
+	count += scnprintf(out, PAGE_SIZE - count, "\n");

-	return out - buf;
+	return count;
 }

 static int add_match_busid(char *busid)
diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index 433a3b6..127fdbb 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -43,7 +43,7 @@ EXPORT_SYMBOL_GPL(dev_attr_usbip_debug);
 static ssize_t show_flag(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
-	return sprintf(buf, "%lx\n", usbip_debug_flag);
+	return scnprintf(buf, PAGE_SIZE, "%lx\n", usbip_debug_flag);
 }

 static ssize_t store_flag(struct device *dev, struct device_attribute *attr,
diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
index d9736f9..1571882 100644
--- a/drivers/staging/usbip/vhci_sysfs.c
+++ b/drivers/staging/usbip/vhci_sysfs.c
@@ -27,10 +27,11 @@

 /* Sysfs entry to show port status */
 static ssize_t show_status(struct device *dev, struct device_attribute *attr,
-			   char *out)
+			   char *buf)
 {
-	char *s = out;
+	char *out = buf;
 	int i = 0;
+	int count;

 	BUG_ON(!the_controller || !out);

@@ -46,32 +47,43 @@ static ssize_t show_status(struct device *dev, struct device_attribute *attr,
 	 * up /proc/net/{tcp,tcp6}. Also, a userland program may remember a
 	 * port number and its peer IP address.
 	 */
-	out += sprintf(out, "prt sta spd bus dev socket           "
-		       "local_busid\n");
+	count = scnprintf(out, PAGE_SIZE,
+		"prt sta spd bus dev socket           local_busid\n");
+	out = buf + count;

 	for (i = 0; i < VHCI_NPORTS; i++) {
 		struct vhci_device *vdev = port_to_vdev(i);

 		spin_lock(&vdev->ud.lock);
-		out += sprintf(out, "%03u %03u ", i, vdev->ud.status);
+		count += scnprintf(out, PAGE_SIZE - count,
+			"%03u %03u ", i, vdev->ud.status);
+		out = buf + count;

 		if (vdev->ud.status == VDEV_ST_USED) {
-			out += sprintf(out, "%03u %08x ",
-				       vdev->speed, vdev->devid);
-			out += sprintf(out, "%16p ", vdev->ud.tcp_socket);
-			out += sprintf(out, "%s", dev_name(&vdev->udev->dev));
+			count += scnprintf(out, PAGE_SIZE - count,
+				"%03u %08x ", vdev->speed, vdev->devid);
+			out = buf + count;
+			count += scnprintf(out, PAGE_SIZE - count,
+				"%16p ", vdev->ud.tcp_socket);
+			out = buf + count;
+			count += scnprintf(out, PAGE_SIZE - count,
+				"%s", dev_name(&vdev->udev->dev));
+			out = buf + count;

 		} else {
-			out += sprintf(out, "000 000 000 0000000000000000 0-0");
+			count += scnprintf(out, PAGE_SIZE - count,
+				"000 000 000 0000000000000000 0-0");
+			out = buf + count;
 		}

-		out += sprintf(out, "\n");
+		count += scnprintf(out, PAGE_SIZE - count, "\n");
+		out = buf + count;
 		spin_unlock(&vdev->ud.lock);
 	}

 	spin_unlock(&the_controller->lock);

-	return out - s;
+	return count;
 }
 static DEVICE_ATTR(status, S_IRUGO, show_status, NULL);

