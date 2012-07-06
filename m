Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab2GFIIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 04:08:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35584 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2GFIIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 04:08:18 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH 4/4] ideapad: add Lenovo IdeaPad Z570 support (part 3)
Date: Fri,  6 Jul 2012 16:08:11 +0800
Message-Id: <1341562091-7089-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341562023-6951-1-git-send-email-ike.pan@canonical.com>
References: <1341562023-6951-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxim Mikityanskiy <maxtram95@gmail.com>

The patch adds support for Lenovo IdeaPad Z570 laptop. It makes all special
keys working, adds possibility to control fan like Windows does, controls
Touchpad Disabled LED, toggles touchpad state via keyboard controller and
corrects touchpad behavior on resume from suspend. It is new, modified
version of patch. Now it does not depend on psmouse and does not need patching
of input subsystem.

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>

This is the part 3 for fan control

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 .../ABI/testing/sysfs-platform-ideapad-laptop      |   11 +++++
 drivers/platform/x86/ideapad-laptop.c              |   43 ++++++++++++++++++--
 2 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-platform-ideapad-laptop b/Documentation/ABI/testing/sysfs-platform-ideapad-laptop
index 814b013..b31e782 100644
--- a/Documentation/ABI/testing/sysfs-platform-ideapad-laptop
+++ b/Documentation/ABI/testing/sysfs-platform-ideapad-laptop
@@ -5,4 +5,15 @@ Contact:	"Ike Panhc <ike.pan@canonical.com>"
 Description:
 		Control the power of camera module. 1 means on, 0 means off.
 
+What:		/sys/devices/platform/ideapad/fan_mode
+Date:		June 2012
+KernelVersion:	3.6
+Contact:	"Maxim Mikityanskiy <maxtram95@gmail.com>"
+Description:
+		Change fan mode
+		There are four available modes:
+			* 0 -> Super Silent Mode
+			* 1 -> Standard Mode
+			* 2 -> Dust Cleaning
+			* 4 -> Efficient Thermal Dissipation Mode
 
diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index b577766..8231edf 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -64,8 +64,10 @@ enum {
 	VPCCMD_R_3G,
 	VPCCMD_W_3G,
 	VPCCMD_R_ODD, /* 0x21 */
-	VPCCMD_R_RF = 0x23,
+	VPCCMD_W_FAN,
+	VPCCMD_R_RF,
 	VPCCMD_W_RF,
+	VPCCMD_R_FAN = 0x2B,
 	VPCCMD_R_SPECIAL_BUTTONS = 0x31,
 	VPCCMD_W_BL_POWER = 0x33,
 };
@@ -358,14 +360,46 @@ static ssize_t store_ideapad_cam(struct device *dev,
 		return -EINVAL;
 	ret = write_ec_cmd(ideapad_handle, VPCCMD_W_CAMERA, state);
 	if (ret < 0)
-		return ret;
+		return -EIO;
 	return count;
 }
 
 static DEVICE_ATTR(camera_power, 0644, show_ideapad_cam, store_ideapad_cam);
 
+static ssize_t show_ideapad_fan(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	unsigned long result;
+
+	if (read_ec_data(ideapad_handle, VPCCMD_R_FAN, &result))
+		return sprintf(buf, "-1\n");
+	return sprintf(buf, "%lu\n", result);
+}
+
+static ssize_t store_ideapad_fan(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	int ret, state;
+
+	if (!count)
+		return 0;
+	if (sscanf(buf, "%i", &state) != 1)
+		return -EINVAL;
+	if (state < 0 || state > 4 || state == 3)
+		return -EINVAL;
+	ret = write_ec_cmd(ideapad_handle, VPCCMD_W_FAN, state);
+	if (ret < 0)
+		return -EIO;
+	return count;
+}
+
+static DEVICE_ATTR(fan_mode, 0644, show_ideapad_fan, store_ideapad_fan);
+
 static struct attribute *ideapad_attributes[] = {
 	&dev_attr_camera_power.attr,
+	&dev_attr_fan_mode.attr,
 	NULL
 };
 
@@ -379,7 +413,10 @@ static umode_t ideapad_is_visible(struct kobject *kobj,
 
 	if (attr == &dev_attr_camera_power.attr)
 		supported = test_bit(CFG_CAMERA_BIT, &(priv->cfg));
-	else
+	else if (attr == &dev_attr_fan_mode.attr) {
+		unsigned long value;
+		supported = !read_ec_data(ideapad_handle, VPCCMD_R_FAN, &value);
+	} else
 		supported = true;
 
 	return supported ? attr->mode : 0;
-- 
1.7.9.5

