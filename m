Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab2JQOfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:35:46 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:53991 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756179Ab2JQOfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:35:44 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-09.arcor-online.net 59AD81976BB
Subject: [PATCH] HID: roccat: Made tcu sysfs attr rw to allow readout of
 koneplus sensor register data
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Oct 2012 16:35:42 +0200
Message-ID: <1350484542.12102.2.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tcu sysfs attr was used to only control calibration process so far. Reverse
engineering the firmware revealed direct sensor register access. Allowing
readout of tcu permits usage of this feature.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-koneplus   |    6 +++---
 drivers/hid/hid-roccat-koneplus.c                  |   11 ++++++++++-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus b/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
index 65e6e5d..f9e2a61 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
@@ -104,9 +104,9 @@ What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-
 Date:		October 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	When written a calibration process for the tracking control unit
-		can be initiated/cancelled.
-		The data has to be 3 bytes long.
-		This file is writeonly.
+		can be initiated/cancelled. Also lets one read/write sensor
+		registers.
+		The data has to be 4 bytes long.
 Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/tcu_image
diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index f5602fe..c47540a 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -222,6 +222,14 @@ static ssize_t koneplus_sysfs_write_tcu(struct file *fp,
 			sizeof(struct koneplus_tcu), KONEPLUS_COMMAND_TCU);
 }
 
+static ssize_t koneplus_sysfs_read_tcu(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return koneplus_sysfs_read(fp, kobj, buf, off, count,
+			sizeof(struct koneplus_tcu), KONEPLUS_COMMAND_TCU);
+}
+
 static ssize_t koneplus_sysfs_read_tcu_image(struct file *fp,
 		struct kobject *kobj, struct bin_attribute *attr, char *buf,
 		loff_t off, size_t count)
@@ -426,8 +434,9 @@ static struct bin_attribute koneplus_bin_attributes[] = {
 		.write = koneplus_sysfs_write_sensor
 	},
 	{
-		.attr = { .name = "tcu", .mode = 0220 },
+		.attr = { .name = "tcu", .mode = 0660 },
 		.size = sizeof(struct koneplus_tcu),
+		.read = koneplus_sysfs_read_tcu,
 		.write = koneplus_sysfs_write_tcu
 	},
 	{
-- 
1.7.3.4



