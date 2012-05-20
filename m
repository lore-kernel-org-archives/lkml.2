Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2ETUpO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 16:45:14 -0400
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:35681 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753531Ab2ETUpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 16:45:02 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-04.arcor-online.net 1B3EBAA41E
Subject: [PATCH 2/4] HID: roccat: Moved functionality to roccat-common
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.orglinux-doc, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 May 2012 22:44:59 +0200
Message-ID: <1337546699.19878.29.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduced code duplication by moving functions from individual drivers
to roccat-common module.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-common.c   |   58 ++++++++++++++++++++++++
 drivers/hid/hid-roccat-common.h   |   12 +++++
 drivers/hid/hid-roccat-isku.c     |   50 ++-------------------
 drivers/hid/hid-roccat-isku.h     |    7 ---
 drivers/hid/hid-roccat-koneplus.c |   88 ++++++------------------------------
 drivers/hid/hid-roccat-koneplus.h |   22 ---------
 drivers/hid/hid-roccat-kovaplus.c |   63 ++++----------------------
 drivers/hid/hid-roccat-kovaplus.h |   15 ------
 drivers/hid/hid-roccat-pyra.c     |   51 ++++-----------------
 drivers/hid/hid-roccat-pyra.h     |   12 -----
 drivers/hid/hid-roccat-savu.c     |   47 +-------------------
 drivers/hid/hid-roccat-savu.h     |   18 --------
 12 files changed, 111 insertions(+), 332 deletions(-)

diff --git a/drivers/hid/hid-roccat-common.c b/drivers/hid/hid-roccat-common.c
index a6d9399..291414e 100644
--- a/drivers/hid/hid-roccat-common.c
+++ b/drivers/hid/hid-roccat-common.c
@@ -64,6 +64,64 @@ int roccat_common_send(struct usb_device *usb_dev, uint report_id,
 }
 EXPORT_SYMBOL_GPL(roccat_common_send);
 
+enum roccat_common_control_states {
+	ROCCAT_COMMON_CONTROL_STATUS_OVERLOAD = 0,
+	ROCCAT_COMMON_CONTROL_STATUS_OK = 1,
+	ROCCAT_COMMON_CONTROL_STATUS_INVALID = 2,
+	ROCCAT_COMMON_CONTROL_STATUS_WAIT = 3,
+};
+
+static int roccat_common_receive_control_status(struct usb_device *usb_dev)
+{
+	int retval;
+	struct roccat_common_control control;
+
+	do {
+		msleep(50);
+		retval = roccat_common_receive(usb_dev,
+				ROCCAT_COMMON_COMMAND_CONTROL,
+				&control, sizeof(struct roccat_common_control));
+
+		if (retval)
+			return retval;
+
+		switch (control.value) {
+		case ROCCAT_COMMON_CONTROL_STATUS_OK:
+			return 0;
+		case ROCCAT_COMMON_CONTROL_STATUS_WAIT:
+			msleep(500);
+			continue;
+		case ROCCAT_COMMON_CONTROL_STATUS_INVALID:
+
+		case ROCCAT_COMMON_CONTROL_STATUS_OVERLOAD:
+			/* seems to be critical - replug necessary */
+			return -EINVAL;
+		default:
+			dev_err(&usb_dev->dev,
+					"roccat_common_receive_control_status: "
+					"unknown response value 0x%x\n",
+					control.value);
+			return -EINVAL;
+		}
+
+	} while (1);
+}
+
+int roccat_common_send_with_status(struct usb_device *usb_dev,
+		uint command, void const *buf, uint size)
+{
+	int retval;
+
+	retval = roccat_common_send(usb_dev, command, buf, size);
+	if (retval)
+		return retval;
+
+	msleep(100);
+
+	return roccat_common_receive_control_status(usb_dev);
+}
+EXPORT_SYMBOL_GPL(roccat_common_send_with_status);
+
 MODULE_AUTHOR("Stefan Achatz");
 MODULE_DESCRIPTION("USB Roccat common driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/hid/hid-roccat-common.h b/drivers/hid/hid-roccat-common.h
index 9a5bc61..86bce05 100644
--- a/drivers/hid/hid-roccat-common.h
+++ b/drivers/hid/hid-roccat-common.h
@@ -15,9 +15,21 @@
 #include <linux/usb.h>
 #include <linux/types.h>
 
+enum roccat_common_commands {
+	ROCCAT_COMMON_COMMAND_CONTROL = 0x4,
+};
+
+struct roccat_common_control {
+	uint8_t command;
+	uint8_t value;
+	uint8_t request; /* always 0 on requesting write check */
+} __packed;
+
 int roccat_common_receive(struct usb_device *usb_dev, uint report_id,
 		void *data, uint size);
 int roccat_common_send(struct usb_device *usb_dev, uint report_id,
 		void const *data, uint size);
+int roccat_common_send_with_status(struct usb_device *usb_dev,
+		uint command, void const *buf, uint size);
 
 #endif
diff --git a/drivers/hid/hid-roccat-isku.c b/drivers/hid/hid-roccat-isku.c
index 0e4a0ab..20e7f84 100644
--- a/drivers/hid/hid-roccat-isku.c
+++ b/drivers/hid/hid-roccat-isku.c
@@ -39,50 +39,6 @@ static int isku_receive(struct usb_device *usb_dev, uint command,
 	return roccat_common_receive(usb_dev, command, buf, size);
 }
 
-static int isku_receive_control_status(struct usb_device *usb_dev)
-{
-	int retval;
-	struct isku_control control;
-
-	do {
-		msleep(50);
-		retval = isku_receive(usb_dev, ISKU_COMMAND_CONTROL,
-				&control, sizeof(struct isku_control));
-
-		if (retval)
-			return retval;
-
-		switch (control.value) {
-		case ISKU_CONTROL_VALUE_STATUS_OK:
-			return 0;
-		case ISKU_CONTROL_VALUE_STATUS_WAIT:
-			continue;
-		case ISKU_CONTROL_VALUE_STATUS_INVALID:
-		/* seems to be critical - replug necessary */
-		case ISKU_CONTROL_VALUE_STATUS_OVERLOAD:
-			return -EINVAL;
-		default:
-			hid_err(usb_dev, "isku_receive_control_status: "
-					"unknown response value 0x%x\n",
-					control.value);
-			return -EINVAL;
-		}
-
-	} while (1);
-}
-
-static int isku_send(struct usb_device *usb_dev, uint command,
-		void const *buf, uint size)
-{
-	int retval;
-
-	retval = roccat_common_send(usb_dev, command, buf, size);
-	if (retval)
-		return retval;
-
-	return isku_receive_control_status(usb_dev);
-}
-
 static int isku_get_actual_profile(struct usb_device *usb_dev)
 {
 	struct isku_actual_profile buf;
@@ -100,7 +56,8 @@ static int isku_set_actual_profile(struct usb_device *usb_dev, int new_profile)
 	buf.command = ISKU_COMMAND_ACTUAL_PROFILE;
 	buf.size = sizeof(struct isku_actual_profile);
 	buf.actual_profile = new_profile;
-	return isku_send(usb_dev, ISKU_COMMAND_ACTUAL_PROFILE, &buf,
+	return roccat_common_send_with_status(usb_dev,
+			ISKU_COMMAND_ACTUAL_PROFILE, &buf,
 			sizeof(struct isku_actual_profile));
 }
 
@@ -197,7 +154,8 @@ static ssize_t isku_sysfs_write(struct file *fp, struct kobject *kobj,
 		return -EINVAL;
 
 	mutex_lock(&isku->isku_lock);
-	retval = isku_send(usb_dev, command, (void *)buf, real_size);
+	retval = roccat_common_send_with_status(usb_dev, command,
+			(void *)buf, real_size);
 	mutex_unlock(&isku->isku_lock);
 
 	return retval ? retval : real_size;
diff --git a/drivers/hid/hid-roccat-isku.h b/drivers/hid/hid-roccat-isku.h
index 075f6ef..605b3ce 100644
--- a/drivers/hid/hid-roccat-isku.h
+++ b/drivers/hid/hid-roccat-isku.h
@@ -25,13 +25,6 @@ struct isku_control {
 	uint8_t request;
 } __packed;
 
-enum isku_control_values {
-	ISKU_CONTROL_VALUE_STATUS_OVERLOAD = 0,
-	ISKU_CONTROL_VALUE_STATUS_OK = 1,
-	ISKU_CONTROL_VALUE_STATUS_INVALID = 2,
-	ISKU_CONTROL_VALUE_STATUS_WAIT = 3,
-};
-
 struct isku_actual_profile {
 	uint8_t command; /* ISKU_COMMAND_ACTUAL_PROFILE */
 	uint8_t size; /* always 3 */
diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index 59e4777..01167a8 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -39,82 +39,20 @@ static void koneplus_profile_activated(struct koneplus_device *koneplus,
 static int koneplus_send_control(struct usb_device *usb_dev, uint value,
 		enum koneplus_control_requests request)
 {
-	struct koneplus_control control;
+	struct roccat_common_control control;
 
 	if ((request == KONEPLUS_CONTROL_REQUEST_PROFILE_SETTINGS ||
 			request == KONEPLUS_CONTROL_REQUEST_PROFILE_BUTTONS) &&
 			value > 4)
 		return -EINVAL;
 
-	control.command = KONEPLUS_COMMAND_CONTROL;
+	control.command = ROCCAT_COMMON_COMMAND_CONTROL;
 	control.value = value;
 	control.request = request;
 
-	return roccat_common_send(usb_dev, KONEPLUS_COMMAND_CONTROL,
-			&control, sizeof(struct koneplus_control));
-}
-
-static int koneplus_receive_control_status(struct usb_device *usb_dev)
-{
-	int retval;
-	struct koneplus_control control;
-
-	do {
-		retval = roccat_common_receive(usb_dev, KONEPLUS_COMMAND_CONTROL,
-				&control, sizeof(struct koneplus_control));
-
-		/* check if we get a completely wrong answer */
-		if (retval)
-			return retval;
-
-		if (control.value == KONEPLUS_CONTROL_REQUEST_STATUS_OK)
-			return 0;
-
-		/* indicates that hardware needs some more time to complete action */
-		if (control.value == KONEPLUS_CONTROL_REQUEST_STATUS_WAIT) {
-			msleep(500); /* windows driver uses 1000 */
-			continue;
-		}
-
-		/* seems to be critical - replug necessary */
-		if (control.value == KONEPLUS_CONTROL_REQUEST_STATUS_OVERLOAD)
-			return -EINVAL;
-
-		hid_err(usb_dev, "koneplus_receive_control_status: "
-				"unknown response value 0x%x\n", control.value);
-		return -EINVAL;
-	} while (1);
-}
-
-static int koneplus_send(struct usb_device *usb_dev, uint command,
-		void const *buf, uint size)
-{
-	int retval;
-
-	retval = roccat_common_send(usb_dev, command, buf, size);
-	if (retval)
-		return retval;
-
-	return koneplus_receive_control_status(usb_dev);
-}
-
-static int koneplus_select_profile(struct usb_device *usb_dev, uint number,
-		enum koneplus_control_requests request)
-{
-	int retval;
-
-	retval = koneplus_send_control(usb_dev, number, request);
-	if (retval)
-		return retval;
-
-	/* allow time to settle things - windows driver uses 500 */
-	msleep(100);
-
-	retval = koneplus_receive_control_status(usb_dev);
-	if (retval)
-		return retval;
-
-	return 0;
+	return roccat_common_send_with_status(usb_dev,
+			ROCCAT_COMMON_COMMAND_CONTROL,
+			&control, sizeof(struct roccat_common_control));
 }
 
 static int koneplus_get_info(struct usb_device *usb_dev,
@@ -129,7 +67,7 @@ static int koneplus_get_profile_settings(struct usb_device *usb_dev,
 {
 	int retval;
 
-	retval = koneplus_select_profile(usb_dev, number,
+	retval = koneplus_send_control(usb_dev, number,
 			KONEPLUS_CONTROL_REQUEST_PROFILE_SETTINGS);
 	if (retval)
 		return retval;
@@ -141,7 +79,8 @@ static int koneplus_get_profile_settings(struct usb_device *usb_dev,
 static int koneplus_set_profile_settings(struct usb_device *usb_dev,
 		struct koneplus_profile_settings const *settings)
 {
-	return koneplus_send(usb_dev, KONEPLUS_COMMAND_PROFILE_SETTINGS,
+	return roccat_common_send_with_status(usb_dev,
+			KONEPLUS_COMMAND_PROFILE_SETTINGS,
 			settings, sizeof(struct koneplus_profile_settings));
 }
 
@@ -150,7 +89,7 @@ static int koneplus_get_profile_buttons(struct usb_device *usb_dev,
 {
 	int retval;
 
-	retval = koneplus_select_profile(usb_dev, number,
+	retval = koneplus_send_control(usb_dev, number,
 			KONEPLUS_CONTROL_REQUEST_PROFILE_BUTTONS);
 	if (retval)
 		return retval;
@@ -162,7 +101,8 @@ static int koneplus_get_profile_buttons(struct usb_device *usb_dev,
 static int koneplus_set_profile_buttons(struct usb_device *usb_dev,
 		struct koneplus_profile_buttons const *buttons)
 {
-	return koneplus_send(usb_dev, KONEPLUS_COMMAND_PROFILE_BUTTONS,
+	return roccat_common_send_with_status(usb_dev,
+			KONEPLUS_COMMAND_PROFILE_BUTTONS,
 			buttons, sizeof(struct koneplus_profile_buttons));
 }
 
@@ -187,7 +127,8 @@ static int koneplus_set_actual_profile(struct usb_device *usb_dev,
 	buf.size = sizeof(struct koneplus_actual_profile);
 	buf.actual_profile = new_profile;
 
-	return koneplus_send(usb_dev, KONEPLUS_COMMAND_ACTUAL_PROFILE,
+	return roccat_common_send_with_status(usb_dev,
+			KONEPLUS_COMMAND_ACTUAL_PROFILE,
 			&buf, sizeof(struct koneplus_actual_profile));
 }
 
@@ -231,7 +172,8 @@ static ssize_t koneplus_sysfs_write(struct file *fp, struct kobject *kobj,
 		return -EINVAL;
 
 	mutex_lock(&koneplus->koneplus_lock);
-	retval = koneplus_send(usb_dev, command, buf, real_size);
+	retval = roccat_common_send_with_status(usb_dev, command,
+			buf, real_size);
 	mutex_unlock(&koneplus->koneplus_lock);
 
 	if (retval)
diff --git a/drivers/hid/hid-roccat-koneplus.h b/drivers/hid/hid-roccat-koneplus.h
index c03332a..7074b2a 100644
--- a/drivers/hid/hid-roccat-koneplus.h
+++ b/drivers/hid/hid-roccat-koneplus.h
@@ -20,32 +20,11 @@ struct koneplus_talk {
 	uint8_t data[14];
 } __packed;
 
-/*
- * case 1: writes request 80 and reads value 1
- *
- */
-struct koneplus_control {
-	uint8_t command; /* KONEPLUS_COMMAND_CONTROL */
-	/*
-	 * value is profile number in range 0-4 for requesting settings and buttons
-	 * 1 if status ok for requesting status
-	 */
-	uint8_t value;
-	uint8_t request;
-} __attribute__ ((__packed__));
-
 enum koneplus_control_requests {
-	KONEPLUS_CONTROL_REQUEST_STATUS = 0x00,
 	KONEPLUS_CONTROL_REQUEST_PROFILE_SETTINGS = 0x80,
 	KONEPLUS_CONTROL_REQUEST_PROFILE_BUTTONS = 0x90,
 };
 
-enum koneplus_control_values {
-	KONEPLUS_CONTROL_REQUEST_STATUS_OVERLOAD = 0,
-	KONEPLUS_CONTROL_REQUEST_STATUS_OK = 1,
-	KONEPLUS_CONTROL_REQUEST_STATUS_WAIT = 3,
-};
-
 struct koneplus_actual_profile {
 	uint8_t command; /* KONEPLUS_COMMAND_ACTUAL_PROFILE */
 	uint8_t size; /* always 3 */
@@ -137,7 +116,6 @@ struct koneplus_tcu_image {
 } __attribute__ ((__packed__));
 
 enum koneplus_commands {
-	KONEPLUS_COMMAND_CONTROL = 0x4,
 	KONEPLUS_COMMAND_ACTUAL_PROFILE = 0x5,
 	KONEPLUS_COMMAND_PROFILE_SETTINGS = 0x6,
 	KONEPLUS_COMMAND_PROFILE_BUTTONS = 0x7,
diff --git a/drivers/hid/hid-roccat-kovaplus.c b/drivers/hid/hid-roccat-kovaplus.c
index 112d934..c219cff 100644
--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -47,69 +47,23 @@ static int kovaplus_send_control(struct usb_device *usb_dev, uint value,
 		enum kovaplus_control_requests request)
 {
 	int retval;
-	struct kovaplus_control control;
+	struct roccat_common_control control;
 
 	if ((request == KOVAPLUS_CONTROL_REQUEST_PROFILE_SETTINGS ||
 			request == KOVAPLUS_CONTROL_REQUEST_PROFILE_BUTTONS) &&
 			value > 4)
 		return -EINVAL;
 
-	control.command = KOVAPLUS_COMMAND_CONTROL;
+	control.command = ROCCAT_COMMON_COMMAND_CONTROL;
 	control.value = value;
 	control.request = request;
 
-	retval = roccat_common_send(usb_dev, KOVAPLUS_COMMAND_CONTROL,
-			&control, sizeof(struct kovaplus_control));
+	retval = roccat_common_send(usb_dev, ROCCAT_COMMON_COMMAND_CONTROL,
+			&control, sizeof(struct roccat_common_control));
 
 	return retval;
 }
 
-static int kovaplus_receive_control_status(struct usb_device *usb_dev)
-{
-	int retval;
-	struct kovaplus_control control;
-
-	do {
-		retval = roccat_common_receive(usb_dev, KOVAPLUS_COMMAND_CONTROL,
-				&control, sizeof(struct kovaplus_control));
-
-		/* check if we get a completely wrong answer */
-		if (retval)
-			return retval;
-
-		if (control.value == KOVAPLUS_CONTROL_REQUEST_STATUS_OK)
-			return 0;
-
-		/* indicates that hardware needs some more time to complete action */
-		if (control.value == KOVAPLUS_CONTROL_REQUEST_STATUS_WAIT) {
-			msleep(500); /* windows driver uses 1000 */
-			continue;
-		}
-
-		/* seems to be critical - replug necessary */
-		if (control.value == KOVAPLUS_CONTROL_REQUEST_STATUS_OVERLOAD)
-			return -EINVAL;
-
-		hid_err(usb_dev, "roccat_common_receive_control_status: "
-				"unknown response value 0x%x\n", control.value);
-		return -EINVAL;
-	} while (1);
-}
-
-static int kovaplus_send(struct usb_device *usb_dev, uint command,
-		void const *buf, uint size)
-{
-	int retval;
-
-	retval = roccat_common_send(usb_dev, command, buf, size);
-	if (retval)
-		return retval;
-
-	msleep(100);
-
-	return kovaplus_receive_control_status(usb_dev);
-}
-
 static int kovaplus_select_profile(struct usb_device *usb_dev, uint number,
 		enum kovaplus_control_requests request)
 {
@@ -140,7 +94,8 @@ static int kovaplus_get_profile_settings(struct usb_device *usb_dev,
 static int kovaplus_set_profile_settings(struct usb_device *usb_dev,
 		struct kovaplus_profile_settings const *settings)
 {
-	return kovaplus_send(usb_dev, KOVAPLUS_COMMAND_PROFILE_SETTINGS,
+	return roccat_common_send_with_status(usb_dev,
+			KOVAPLUS_COMMAND_PROFILE_SETTINGS,
 			settings, sizeof(struct kovaplus_profile_settings));
 }
 
@@ -161,7 +116,8 @@ static int kovaplus_get_profile_buttons(struct usb_device *usb_dev,
 static int kovaplus_set_profile_buttons(struct usb_device *usb_dev,
 		struct kovaplus_profile_buttons const *buttons)
 {
-	return kovaplus_send(usb_dev, KOVAPLUS_COMMAND_PROFILE_BUTTONS,
+	return roccat_common_send_with_status(usb_dev,
+			KOVAPLUS_COMMAND_PROFILE_BUTTONS,
 			buttons, sizeof(struct kovaplus_profile_buttons));
 }
 
@@ -186,7 +142,8 @@ static int kovaplus_set_actual_profile(struct usb_device *usb_dev,
 	buf.size = sizeof(struct kovaplus_actual_profile);
 	buf.actual_profile = new_profile;
 
-	return kovaplus_send(usb_dev, KOVAPLUS_COMMAND_ACTUAL_PROFILE,
+	return roccat_common_send_with_status(usb_dev,
+			KOVAPLUS_COMMAND_ACTUAL_PROFILE,
 			&buf, sizeof(struct kovaplus_actual_profile));
 }
 
diff --git a/drivers/hid/hid-roccat-kovaplus.h b/drivers/hid/hid-roccat-kovaplus.h
index fb2aed4..f82daa1 100644
--- a/drivers/hid/hid-roccat-kovaplus.h
+++ b/drivers/hid/hid-roccat-kovaplus.h
@@ -14,27 +14,13 @@
 
 #include <linux/types.h>
 
-struct kovaplus_control {
-	uint8_t command; /* KOVAPLUS_COMMAND_CONTROL */
-	uint8_t value;
-	uint8_t request;
-} __packed;
-
 enum kovaplus_control_requests {
-	/* read after write; value = 1 */
-	KOVAPLUS_CONTROL_REQUEST_STATUS = 0x0,
 	/* write; value = profile number range 0-4 */
 	KOVAPLUS_CONTROL_REQUEST_PROFILE_SETTINGS = 0x10,
 	/* write; value = profile number range 0-4 */
 	KOVAPLUS_CONTROL_REQUEST_PROFILE_BUTTONS = 0x20,
 };
 
-enum kovaplus_control_values {
-	KOVAPLUS_CONTROL_REQUEST_STATUS_OVERLOAD = 0, /* supposed */
-	KOVAPLUS_CONTROL_REQUEST_STATUS_OK = 1,
-	KOVAPLUS_CONTROL_REQUEST_STATUS_WAIT = 3, /* supposed */
-};
-
 struct kovaplus_actual_profile {
 	uint8_t command; /* KOVAPLUS_COMMAND_ACTUAL_PROFILE */
 	uint8_t size; /* always 3 */
@@ -75,7 +61,6 @@ struct kovaplus_a {
 } __packed;
 
 enum kovaplus_commands {
-	KOVAPLUS_COMMAND_CONTROL = 0x4,
 	KOVAPLUS_COMMAND_ACTUAL_PROFILE = 0x5,
 	KOVAPLUS_COMMAND_PROFILE_SETTINGS = 0x6,
 	KOVAPLUS_COMMAND_PROFILE_BUTTONS = 0x7,
diff --git a/drivers/hid/hid-roccat-pyra.c b/drivers/hid/hid-roccat-pyra.c
index df05c1b..440cb1b 100644
--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -42,43 +42,19 @@ static void profile_activated(struct pyra_device *pyra,
 static int pyra_send_control(struct usb_device *usb_dev, int value,
 		enum pyra_control_requests request)
 {
-	struct pyra_control control;
+	struct roccat_common_control control;
 
 	if ((request == PYRA_CONTROL_REQUEST_PROFILE_SETTINGS ||
 			request == PYRA_CONTROL_REQUEST_PROFILE_BUTTONS) &&
 			(value < 0 || value > 4))
 		return -EINVAL;
 
-	control.command = PYRA_COMMAND_CONTROL;
+	control.command = ROCCAT_COMMON_COMMAND_CONTROL;
 	control.value = value;
 	control.request = request;
 
-	return roccat_common_send(usb_dev, PYRA_COMMAND_CONTROL,
-			&control, sizeof(struct pyra_control));
-}
-
-static int pyra_receive_control_status(struct usb_device *usb_dev)
-{
-	int retval;
-	struct pyra_control control;
-
-	do {
-		msleep(10);
-		retval = roccat_common_receive(usb_dev, PYRA_COMMAND_CONTROL,
-				&control, sizeof(struct pyra_control));
-
-		/* requested too early, try again */
-	} while (retval == -EPROTO);
-
-	if (!retval && control.command == PYRA_COMMAND_CONTROL &&
-			control.request == PYRA_CONTROL_REQUEST_STATUS &&
-			control.value == 1)
-		return 0;
-	else {
-		hid_err(usb_dev, "receive control status: unknown response 0x%x 0x%x\n",
-			control.request, control.value);
-		return retval ? retval : -EINVAL;
-	}
+	return roccat_common_send(usb_dev, ROCCAT_COMMON_COMMAND_CONTROL,
+			&control, sizeof(struct roccat_common_control));
 }
 
 static int pyra_get_profile_settings(struct usb_device *usb_dev,
@@ -118,34 +94,27 @@ static int pyra_get_info(struct usb_device *usb_dev, struct pyra_info *buf)
 			buf, sizeof(struct pyra_info));
 }
 
-static int pyra_send(struct usb_device *usb_dev, uint command,
-		void const *buf, uint size)
-{
-	int retval;
-	retval = roccat_common_send(usb_dev, command, buf, size);
-	if (retval)
-		return retval;
-	return pyra_receive_control_status(usb_dev);
-}
-
 static int pyra_set_profile_settings(struct usb_device *usb_dev,
 		struct pyra_profile_settings const *settings)
 {
-	return pyra_send(usb_dev, PYRA_COMMAND_PROFILE_SETTINGS, settings,
+	return roccat_common_send_with_status(usb_dev,
+			PYRA_COMMAND_PROFILE_SETTINGS, settings,
 			sizeof(struct pyra_profile_settings));
 }
 
 static int pyra_set_profile_buttons(struct usb_device *usb_dev,
 		struct pyra_profile_buttons const *buttons)
 {
-	return pyra_send(usb_dev, PYRA_COMMAND_PROFILE_BUTTONS, buttons,
+	return roccat_common_send_with_status(usb_dev,
+			PYRA_COMMAND_PROFILE_BUTTONS, buttons,
 			sizeof(struct pyra_profile_buttons));
 }
 
 static int pyra_set_settings(struct usb_device *usb_dev,
 		struct pyra_settings const *settings)
 {
-	return pyra_send(usb_dev, PYRA_COMMAND_SETTINGS, settings,
+	return roccat_common_send_with_status(usb_dev,
+			PYRA_COMMAND_SETTINGS, settings,
 			sizeof(struct pyra_settings));
 }
 
diff --git a/drivers/hid/hid-roccat-pyra.h b/drivers/hid/hid-roccat-pyra.h
index 0442d7f..eada783 100644
--- a/drivers/hid/hid-roccat-pyra.h
+++ b/drivers/hid/hid-roccat-pyra.h
@@ -20,18 +20,7 @@ struct pyra_b {
 	uint8_t unknown; /* 1 */
 } __attribute__ ((__packed__));
 
-struct pyra_control {
-	uint8_t command; /* PYRA_COMMAND_CONTROL */
-	/*
-	 * value is profile number for request_settings and request_buttons
-	 * 1 if status ok for request_status
-	 */
-	uint8_t value; /* Range 0-4 */
-	uint8_t request;
-} __attribute__ ((__packed__));
-
 enum pyra_control_requests {
-	PYRA_CONTROL_REQUEST_STATUS = 0x00,
 	PYRA_CONTROL_REQUEST_PROFILE_SETTINGS = 0x10,
 	PYRA_CONTROL_REQUEST_PROFILE_BUTTONS = 0x20
 };
@@ -75,7 +64,6 @@ struct pyra_info {
 } __attribute__ ((__packed__));
 
 enum pyra_commands {
-	PYRA_COMMAND_CONTROL = 0x4,
 	PYRA_COMMAND_SETTINGS = 0x5,
 	PYRA_COMMAND_PROFILE_SETTINGS = 0x6,
 	PYRA_COMMAND_PROFILE_BUTTONS = 0x7,
diff --git a/drivers/hid/hid-roccat-savu.c b/drivers/hid/hid-roccat-savu.c
index d6c82d5..19f9c47 100644
--- a/drivers/hid/hid-roccat-savu.c
+++ b/drivers/hid/hid-roccat-savu.c
@@ -27,50 +27,6 @@
 
 static struct class *savu_class;
 
-static int savu_receive_control_status(struct usb_device *usb_dev)
-{
-	int retval;
-	struct savu_control control;
-
-	do {
-		msleep(50);
-		retval = roccat_common_receive(usb_dev, SAVU_COMMAND_CONTROL,
-				&control, sizeof(struct savu_control));
-
-		if (retval)
-			return retval;
-
-		switch (control.value) {
-		case SAVU_CONTROL_REQUEST_WRITE_CHECK_OK:
-			return 0;
-		case SAVU_CONTROL_REQUEST_WRITE_CHECK_WAIT:
-			continue;
-		case SAVU_CONTROL_REQUEST_WRITE_CHECK_INVALID:
-		/* seems to be critical - replug necessary */
-		case SAVU_CONTROL_REQUEST_WRITE_CHECK_OVERLOAD:
-			return -EINVAL;
-		default:
-			hid_err(usb_dev, "savu_receive_control_status: "
-					"unknown response value 0x%x\n",
-					control.value);
-			return -EINVAL;
-		}
-
-	} while (1);
-}
-
-static int savu_send(struct usb_device *usb_dev, uint command,
-		void const *buf, uint size)
-{
-	int retval;
-
-	retval = roccat_common_send(usb_dev, command, buf, size);
-	if (retval)
-		return retval;
-
-	return savu_receive_control_status(usb_dev);
-}
-
 static ssize_t savu_sysfs_read(struct file *fp, struct kobject *kobj,
 		char *buf, loff_t off, size_t count,
 		size_t real_size, uint command)
@@ -108,7 +64,8 @@ static ssize_t savu_sysfs_write(struct file *fp, struct kobject *kobj,
 		return -EINVAL;
 
 	mutex_lock(&savu->savu_lock);
-	retval = savu_send(usb_dev, command, (void *)buf, real_size);
+	retval = roccat_common_send_with_status(usb_dev, command,
+			(void *)buf, real_size);
 	mutex_unlock(&savu->savu_lock);
 
 	return retval ? retval : real_size;
diff --git a/drivers/hid/hid-roccat-savu.h b/drivers/hid/hid-roccat-savu.h
index 97b43d5..b15a1bb 100644
--- a/drivers/hid/hid-roccat-savu.h
+++ b/drivers/hid/hid-roccat-savu.h
@@ -23,29 +23,11 @@ enum {
 	SAVU_SIZE_INFO = 0x08,
 };
 
-struct savu_control {
-	uint8_t command; /* SAVU_COMMAND_CONTROL */
-	/*
-	 * value is profile number in range 0-4 for requesting settings and buttons
-	 * 1 if status ok for requesting status
-	 */
-	uint8_t value;
-	uint8_t request;
-} __packed;
-
 enum savu_control_requests {
-	SAVU_CONTROL_REQUEST_WRITE_CHECK = 0x00,
 	SAVU_CONTROL_REQUEST_GENERAL = 0x80,
 	SAVU_CONTROL_REQUEST_BUTTONS = 0x90,
 };
 
-enum savu_control_values {
-	SAVU_CONTROL_REQUEST_WRITE_CHECK_OVERLOAD = 0,
-	SAVU_CONTROL_REQUEST_WRITE_CHECK_OK = 1,
-	SAVU_CONTROL_REQUEST_WRITE_CHECK_INVALID = 2,
-	SAVU_CONTROL_REQUEST_WRITE_CHECK_WAIT = 3,
-};
-
 enum savu_commands {
 	SAVU_COMMAND_CONTROL = 0x4,
 	SAVU_COMMAND_PROFILE = 0x5,
-- 
1.7.3.4



