Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab1JNJIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:08:44 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:51724 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731Ab1JNJIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:08:42 -0400
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Anisse Astier <anisse@astier.eu>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Ross <andy.ross@windriver.com>,
        Corentin Chary <corentin.chary@gmail.com>
Subject: [PATCH 4/8] asus-laptop: Pegatron Lucid accelerometer
Date: Fri, 14 Oct 2011 11:13:38 +0200
Message-Id: <1318583622-23518-5-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1318583622-23518-1-git-send-email-corentincj@iksaif.net>
References: <1318583622-23518-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Ross <andy.ross@windriver.com>

Support the built-in accelerometer on the Lucid tablets as a standard
3-axis input device.

Signed-off-by: Andy Ross <andy.ross@windriver.com>
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/Kconfig       |    9 ++-
 drivers/platform/x86/asus-laptop.c |  129 +++++++++++++++++++++++++++++++++++-
 2 files changed, 133 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 4e5623e..0d4146c 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -69,10 +69,11 @@ config ASUS_LAPTOP
 	  This is a driver for Asus laptops, Lenovo SL and the Pegatron
 	  Lucid tablet. It may also support some MEDION, JVC or VICTOR
 	  laptops. It makes all the extra buttons generate standard
-	  ACPI events and input events. It also adds support for video
-	  output switching, LCD backlight control, Bluetooth and Wlan
-	  control, and most importantly, allows you to blink those
-	  fancy LEDs.
+	  ACPI events and input events, and on the Lucid the built-in
+	  accelerometer appears as an input device.  It also adds
+	  support for video output switching, LCD backlight control,
+	  Bluetooth and Wlan control, and most importantly, allows you
+	  to blink those fancy LEDs.
 
 	  For more information see <http://acpi4asus.sf.net>.
 
diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index e892a43..7fe5aa5 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -193,6 +193,14 @@ MODULE_PARM_DESC(als_status, "Set the ALS status on boot "
 #define PEGA_READ_ALS_H	0x02
 #define PEGA_READ_ALS_L	0x03
 
+#define PEGA_ACCEL_NAME "pega_accel"
+#define PEGA_ACCEL_DESC "Pegatron Lucid Tablet Accelerometer"
+#define METHOD_XLRX "XLRX"
+#define METHOD_XLRY "XLRY"
+#define METHOD_XLRZ "XLRZ"
+#define PEGA_ACC_CLAMP 512 /* 1G accel is reported as ~256, so clamp to 2G */
+#define PEGA_ACC_RETRIES 3
+
 /*
  * Define a specific led structure to keep the main structure clean
  */
@@ -218,6 +226,7 @@ struct asus_laptop {
 
 	struct input_dev *inputdev;
 	struct key_entry *keymap;
+	struct input_polled_dev *pega_accel_poll;
 
 	struct asus_led mled;
 	struct asus_led tled;
@@ -230,6 +239,10 @@ struct asus_laptop {
 	int wireless_status;
 	bool have_rsts;
 	bool is_pega_lucid;
+	bool pega_acc_live;
+	int pega_acc_x;
+	int pega_acc_y;
+	int pega_acc_z;
 
 	struct rfkill *gps_rfkill;
 
@@ -358,6 +371,113 @@ static int asus_pega_lucid_set(struct asus_laptop *asus, int unit, bool enable)
 	return write_acpi_int(asus->handle, method, unit);
 }
 
+static int pega_acc_axis(struct asus_laptop *asus, int curr, char *method)
+{
+	int i, delta;
+	unsigned long long val;
+	for (i = 0; i < PEGA_ACC_RETRIES; i++) {
+		acpi_evaluate_integer(asus->handle, method, NULL, &val);
+
+		/* The output is noisy.  From reading the ASL
+		 * dissassembly, timeout errors are returned with 1's
+		 * in the high word, and the lack of locking around
+		 * thei hi/lo byte reads means that a transition
+		 * between (for example) -1 and 0 could be read as
+		 * 0xff00 or 0x00ff. */
+		delta = abs(curr - (short)val);
+		if (delta < 128 && !(val & ~0xffff))
+			break;
+	}
+	return clamp_val((short)val, -PEGA_ACC_CLAMP, PEGA_ACC_CLAMP);
+}
+
+static void pega_accel_poll(struct input_polled_dev *ipd)
+{
+	struct device *parent = ipd->input->dev.parent;
+	struct asus_laptop *asus = dev_get_drvdata(parent);
+
+	/* In some cases, the very first call to poll causes a
+	 * recursive fault under the polldev worker.  This is
+	 * apparently related to very early userspace access to the
+	 * device, and perhaps a firmware bug. Fake the first report. */
+	if (!asus->pega_acc_live) {
+		asus->pega_acc_live = true;
+		input_report_abs(ipd->input, ABS_X, 0);
+		input_report_abs(ipd->input, ABS_Y, 0);
+		input_report_abs(ipd->input, ABS_Z, 0);
+		input_sync(ipd->input);
+		return;
+	}
+
+	asus->pega_acc_x = pega_acc_axis(asus, asus->pega_acc_x, METHOD_XLRX);
+	asus->pega_acc_y = pega_acc_axis(asus, asus->pega_acc_y, METHOD_XLRY);
+	asus->pega_acc_z = pega_acc_axis(asus, asus->pega_acc_z, METHOD_XLRZ);
+
+	/* Note transform, convert to "right/up/out" in the native
+	 * landscape orientation (i.e. the vector is the direction of
+	 * "real up" in the device's cartiesian coordinates). */
+	input_report_abs(ipd->input, ABS_X, -asus->pega_acc_x);
+	input_report_abs(ipd->input, ABS_Y, -asus->pega_acc_y);
+	input_report_abs(ipd->input, ABS_Z,  asus->pega_acc_z);
+	input_sync(ipd->input);
+}
+
+static void pega_accel_exit(struct asus_laptop *asus)
+{
+	if (asus->pega_accel_poll) {
+		input_unregister_polled_device(asus->pega_accel_poll);
+		input_free_polled_device(asus->pega_accel_poll);
+	}
+	asus->pega_accel_poll = NULL;
+}
+
+static int pega_accel_init(struct asus_laptop *asus)
+{
+	int err;
+	struct input_polled_dev *ipd;
+
+	if (!asus->is_pega_lucid)
+		return -ENODEV;
+
+	if (acpi_check_handle(asus->handle, METHOD_XLRX, NULL) ||
+	    acpi_check_handle(asus->handle, METHOD_XLRY, NULL) ||
+	    acpi_check_handle(asus->handle, METHOD_XLRZ, NULL))
+		return -ENODEV;
+
+	ipd = input_allocate_polled_device();
+	if (!ipd)
+		return -ENOMEM;
+
+	ipd->poll = pega_accel_poll;
+	ipd->poll_interval = 125;
+	ipd->poll_interval_min = 50;
+	ipd->poll_interval_max = 2000;
+
+	ipd->input->name = PEGA_ACCEL_DESC;
+	ipd->input->phys = PEGA_ACCEL_NAME "/input0";
+	ipd->input->dev.parent = &asus->platform_device->dev;
+	ipd->input->id.bustype = BUS_HOST;
+
+	set_bit(EV_ABS, ipd->input->evbit);
+	input_set_abs_params(ipd->input, ABS_X,
+			     -PEGA_ACC_CLAMP, PEGA_ACC_CLAMP, 0, 0);
+	input_set_abs_params(ipd->input, ABS_Y,
+			     -PEGA_ACC_CLAMP, PEGA_ACC_CLAMP, 0, 0);
+	input_set_abs_params(ipd->input, ABS_Z,
+			     -PEGA_ACC_CLAMP, PEGA_ACC_CLAMP, 0, 0);
+
+	err = input_register_polled_device(ipd);
+	if (err)
+		goto exit;
+
+	asus->pega_accel_poll = ipd;
+	return 0;
+
+exit:
+	input_free_polled_device(ipd);
+	return err;
+}
+
 /* Generic LED function */
 static int asus_led_set(struct asus_laptop *asus, const char *method,
 			 int value)
@@ -1348,7 +1468,7 @@ static struct platform_driver platform_driver = {
 	.driver = {
 		.name = ASUS_LAPTOP_FILE,
 		.owner = THIS_MODULE,
-	}
+	},
 };
 
 /*
@@ -1558,9 +1678,15 @@ static int __devinit asus_acpi_add(struct acpi_device *device)
 	if (result)
 		goto fail_rfkill;
 
+	result = pega_accel_init(asus);
+	if (result && result != -ENODEV)
+		goto fail_pega_accel;
+
 	asus_device_present = true;
 	return 0;
 
+fail_pega_accel:
+	asus_rfkill_exit(asus);
 fail_rfkill:
 	asus_led_exit(asus);
 fail_led:
@@ -1584,6 +1710,7 @@ static int asus_acpi_remove(struct acpi_device *device, int type)
 	asus_rfkill_exit(asus);
 	asus_led_exit(asus);
 	asus_input_exit(asus);
+	pega_accel_exit(asus);
 	asus_platform_exit(asus);
 
 	kfree(asus->name);
-- 
1.7.3.4

