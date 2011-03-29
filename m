Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab1C2WYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:24:13 -0400
Received: from mail.perches.com ([173.55.12.10]:4381 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935Ab1C2WWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:22:37 -0400
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>, Mattia Dongili <malattia@linux.it>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 17/23] sony-laptop: Add and use #define pr_fmt
Date: Tue, 29 Mar 2011 15:21:48 -0700
Message-Id: <550169172fe0780402632f3c72ff5caf8fad7aa5.1301436234.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt.
Remove now unused #define DRV_PRX.
Neaten dprintk macro.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/sony-laptop.c |  104 +++++++++++++++++-------------------
 1 files changed, 49 insertions(+), 55 deletions(-)

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index e642f5f..61cbd77 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -42,6 +42,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -70,10 +72,10 @@
 #include <linux/miscdevice.h>
 #endif
 
-#define DRV_PFX			"sony-laptop: "
-#define dprintk(msg...)		do {	\
-	if (debug)			\
-		pr_warn(DRV_PFX msg);	\
+#define dprintk(fmt, ...)			\
+do {						\
+	if (debug)				\
+		pr_warn(fmt, ##__VA_ARGS__);	\
 } while (0)
 
 #define SONY_LAPTOP_DRIVER_VERSION	"0.6"
@@ -416,7 +418,7 @@ static int sony_laptop_setup_input(struct acpi_device *acpi_device)
 	error = kfifo_alloc(&sony_laptop_input.fifo,
 			    SONY_LAPTOP_BUF_SIZE, GFP_KERNEL);
 	if (error) {
-		pr_err(DRV_PFX "kfifo_alloc failed\n");
+		pr_err("kfifo_alloc failed\n");
 		goto err_dec_users;
 	}
 
@@ -700,7 +702,7 @@ static int acpi_callgetfunc(acpi_handle handle, char *name, int *result)
 		return 0;
 	}
 
-	pr_warn(DRV_PFX "acpi_callreadfunc failed\n");
+	pr_warn("acpi_callreadfunc failed\n");
 
 	return -1;
 }
@@ -726,8 +728,7 @@ static int acpi_callsetfunc(acpi_handle handle, char *name, int value,
 	if (status == AE_OK) {
 		if (result != NULL) {
 			if (out_obj.type != ACPI_TYPE_INTEGER) {
-				pr_warn(DRV_PFX "acpi_evaluate_object bad "
-				       "return type\n");
+				pr_warn("acpi_evaluate_object bad return type\n");
 				return -1;
 			}
 			*result = out_obj.integer.value;
@@ -735,7 +736,7 @@ static int acpi_callsetfunc(acpi_handle handle, char *name, int value,
 		return 0;
 	}
 
-	pr_warn(DRV_PFX "acpi_evaluate_object failed\n");
+	pr_warn("acpi_evaluate_object failed\n");
 
 	return -1;
 }
@@ -1083,10 +1084,8 @@ static void sony_nc_notify(struct acpi_device *device, u32 event)
 				}
 
 				if (!key_event->data)
-					pr_info(DRV_PFX
-							"Unknown event: 0x%x 0x%x\n",
-							key_handle,
-							ev);
+					pr_info("Unknown event: 0x%x 0x%x\n",
+						key_handle, ev);
 				else
 					sony_laptop_report_input_event(ev);
 			}
@@ -1107,7 +1106,7 @@ static acpi_status sony_walk_callback(acpi_handle handle, u32 level,
 	struct acpi_device_info *info;
 
 	if (ACPI_SUCCESS(acpi_get_object_info(handle, &info))) {
-		pr_warn(DRV_PFX "method: name: %4.4s, args %X\n",
+		pr_warn("method: name: %4.4s, args %X\n",
 			(char *)&info->name, info->param_count);
 
 		kfree(info);
@@ -1148,7 +1147,7 @@ static int sony_nc_resume(struct acpi_device *device)
 		ret = acpi_callsetfunc(sony_nc_acpi_handle, *item->acpiset,
 				       item->value, NULL);
 		if (ret < 0) {
-			pr_err(DRV_PFX "%s: %d\n", __func__, ret);
+			pr_err("%s: %d\n", __func__, ret);
 			break;
 		}
 	}
@@ -1312,12 +1311,12 @@ static void sony_nc_rfkill_setup(struct acpi_device *device)
 
 	device_enum = (union acpi_object *) buffer.pointer;
 	if (!device_enum) {
-		pr_err(DRV_PFX "No SN06 return object.");
+		pr_err("No SN06 return object\n");
 		goto out_no_enum;
 	}
 	if (device_enum->type != ACPI_TYPE_BUFFER) {
-		pr_err(DRV_PFX "Invalid SN06 return object 0x%.2x\n",
-				device_enum->type);
+		pr_err("Invalid SN06 return object 0x%.2x\n",
+		       device_enum->type);
 		goto out_no_enum;
 	}
 
@@ -1541,7 +1540,7 @@ static void sony_nc_backlight_setup(void)
 							  ops, &props);
 
 	if (IS_ERR(sony_backlight_device)) {
-		pr_warning(DRV_PFX "unable to register backlight device\n");
+		pr_warn("unable to register backlight device\n");
 		sony_backlight_device = NULL;
 	} else
 		sony_backlight_device->props.brightness =
@@ -1561,8 +1560,7 @@ static int sony_nc_add(struct acpi_device *device)
 	acpi_handle handle;
 	struct sony_nc_value *item;
 
-	pr_info(DRV_PFX "%s v%s.\n", SONY_NC_DRIVER_NAME,
-			SONY_LAPTOP_DRIVER_VERSION);
+	pr_info("%s v%s\n", SONY_NC_DRIVER_NAME, SONY_LAPTOP_DRIVER_VERSION);
 
 	sony_nc_acpi_device = device;
 	strcpy(acpi_device_class(device), "sony/hotkey");
@@ -1587,7 +1585,7 @@ static int sony_nc_add(struct acpi_device *device)
 				sony_nc_acpi_handle, 1, sony_walk_callback,
 				NULL, NULL, NULL);
 		if (ACPI_FAILURE(status)) {
-			pr_warn(DRV_PFX "unable to walk acpi resources\n");
+			pr_warn("unable to walk acpi resources\n");
 			result = -ENODEV;
 			goto outpresent;
 		}
@@ -1615,13 +1613,12 @@ static int sony_nc_add(struct acpi_device *device)
 	/* setup input devices and helper fifo */
 	result = sony_laptop_setup_input(device);
 	if (result) {
-		pr_err(DRV_PFX "Unable to create input devices.\n");
+		pr_err("Unable to create input devices\n");
 		goto outkbdbacklight;
 	}
 
 	if (acpi_video_backlight_support()) {
-		pr_info(DRV_PFX "brightness ignored, must be "
-		       "controlled by ACPI video driver\n");
+		pr_info("brightness ignored, must be controlled by ACPI video driver\n");
 	} else {
 		sony_nc_backlight_setup();
 	}
@@ -2144,9 +2141,9 @@ out:
 	if (pcidev)
 		pci_dev_put(pcidev);
 
-	pr_info(DRV_PFX "detected Type%d model\n",
-			dev->model == SONYPI_DEVICE_TYPE1 ? 1 :
-			dev->model == SONYPI_DEVICE_TYPE2 ? 2 : 3);
+	pr_info("detected Type%d model\n",
+		dev->model == SONYPI_DEVICE_TYPE1 ? 1 :
+		dev->model == SONYPI_DEVICE_TYPE2 ? 2 : 3);
 }
 
 /* camera tests and poweron/poweroff */
@@ -2192,7 +2189,7 @@ static int __sony_pic_camera_ready(void)
 static int __sony_pic_camera_off(void)
 {
 	if (!camera) {
-		pr_warn(DRV_PFX "camera control not enabled\n");
+		pr_warn("camera control not enabled\n");
 		return -ENODEV;
 	}
 
@@ -2212,7 +2209,7 @@ static int __sony_pic_camera_on(void)
 	int i, j, x;
 
 	if (!camera) {
-		pr_warn(DRV_PFX "camera control not enabled\n");
+		pr_warn("camera control not enabled\n");
 		return -ENODEV;
 	}
 
@@ -2235,7 +2232,7 @@ static int __sony_pic_camera_on(void)
 	}
 
 	if (j == 0) {
-		pr_warn(DRV_PFX "failed to power on camera\n");
+		pr_warn("failed to power on camera\n");
 		return -ENODEV;
 	}
 
@@ -2291,8 +2288,7 @@ int sony_pic_camera_command(int command, u8 value)
 				ITERATIONS_SHORT);
 		break;
 	default:
-		pr_err(DRV_PFX "sony_pic_camera_command invalid: %d\n",
-		       command);
+		pr_err("sony_pic_camera_command invalid: %d\n", command);
 		break;
 	}
 	mutex_unlock(&spic_dev.lock);
@@ -2698,7 +2694,7 @@ static int sonypi_compat_init(void)
 	error =
 	 kfifo_alloc(&sonypi_compat.fifo, SONY_LAPTOP_BUF_SIZE, GFP_KERNEL);
 	if (error) {
-		pr_err(DRV_PFX "kfifo_alloc failed\n");
+		pr_err("kfifo_alloc failed\n");
 		return error;
 	}
 
@@ -2708,12 +2704,12 @@ static int sonypi_compat_init(void)
 		sonypi_misc_device.minor = minor;
 	error = misc_register(&sonypi_misc_device);
 	if (error) {
-		pr_err(DRV_PFX "misc_register failed\n");
+		pr_err("misc_register failed\n");
 		goto err_free_kfifo;
 	}
 	if (minor == -1)
-		pr_info(DRV_PFX "device allocated minor is %d\n",
-		       sonypi_misc_device.minor);
+		pr_info("device allocated minor is %d\n",
+			sonypi_misc_device.minor);
 
 	return 0;
 
@@ -2772,8 +2768,8 @@ sony_pic_read_possible_resource(struct acpi_resource *resource, void *context)
 			}
 			for (i = 0; i < p->interrupt_count; i++) {
 				if (!p->interrupts[i]) {
-					pr_warn(DRV_PFX "Invalid IRQ %d\n",
-							p->interrupts[i]);
+					pr_warn("Invalid IRQ %d\n",
+						p->interrupts[i]);
 					continue;
 				}
 				interrupt = kzalloc(sizeof(*interrupt),
@@ -2811,14 +2807,14 @@ sony_pic_read_possible_resource(struct acpi_resource *resource, void *context)
 						ioport->io2.address_length);
 			}
 			else {
-				pr_err(DRV_PFX "Unknown SPIC Type, more than 2 IO Ports\n");
+				pr_err("Unknown SPIC Type, more than 2 IO Ports\n");
 				return AE_ERROR;
 			}
 			return AE_OK;
 		}
 	default:
 		dprintk("Resource %d isn't an IRQ nor an IO port\n",
-				resource->type);
+			resource->type);
 
 	case ACPI_RESOURCE_TYPE_END_TAG:
 		return AE_OK;
@@ -2839,7 +2835,7 @@ static int sony_pic_possible_resources(struct acpi_device *device)
 	dprintk("Evaluating _STA\n");
 	result = acpi_bus_get_status(device);
 	if (result) {
-		pr_warn(DRV_PFX "Unable to read status\n");
+		pr_warn("Unable to read status\n");
 		goto end;
 	}
 
@@ -2855,8 +2851,7 @@ static int sony_pic_possible_resources(struct acpi_device *device)
 	status = acpi_walk_resources(device->handle, METHOD_NAME__PRS,
 			sony_pic_read_possible_resource, &spic_dev);
 	if (ACPI_FAILURE(status)) {
-		pr_warn(DRV_PFX "Failure evaluating %s\n",
-				METHOD_NAME__PRS);
+		pr_warn("Failure evaluating %s\n", METHOD_NAME__PRS);
 		result = -ENODEV;
 	}
 end:
@@ -2969,7 +2964,7 @@ static int sony_pic_enable(struct acpi_device *device,
 
 	/* check for total failure */
 	if (ACPI_FAILURE(status)) {
-		pr_err(DRV_PFX "Error evaluating _SRS\n");
+		pr_err("Error evaluating _SRS\n");
 		result = -ENODEV;
 		goto end;
 	}
@@ -3061,7 +3056,7 @@ static int sony_pic_remove(struct acpi_device *device, int type)
 	struct sony_pic_irq *irq, *tmp_irq;
 
 	if (sony_pic_disable(device)) {
-		pr_err(DRV_PFX "Couldn't disable device.\n");
+		pr_err("Couldn't disable device\n");
 		return -ENXIO;
 	}
 
@@ -3101,8 +3096,7 @@ static int sony_pic_add(struct acpi_device *device)
 	struct sony_pic_ioport *io, *tmp_io;
 	struct sony_pic_irq *irq, *tmp_irq;
 
-	pr_info(DRV_PFX "%s v%s.\n", SONY_PIC_DRIVER_NAME,
-			SONY_LAPTOP_DRIVER_VERSION);
+	pr_info("%s v%s\n", SONY_PIC_DRIVER_NAME, SONY_LAPTOP_DRIVER_VERSION);
 
 	spic_dev.acpi_dev = device;
 	strcpy(acpi_device_class(device), "sony/hotkey");
@@ -3112,14 +3106,14 @@ static int sony_pic_add(struct acpi_device *device)
 	/* read _PRS resources */
 	result = sony_pic_possible_resources(device);
 	if (result) {
-		pr_err(DRV_PFX "Unable to read possible resources.\n");
+		pr_err("Unable to read possible resources\n");
 		goto err_free_resources;
 	}
 
 	/* setup input devices and helper fifo */
 	result = sony_laptop_setup_input(device);
 	if (result) {
-		pr_err(DRV_PFX "Unable to create input devices.\n");
+		pr_err("Unable to create input devices\n");
 		goto err_free_resources;
 	}
 
@@ -3160,7 +3154,7 @@ static int sony_pic_add(struct acpi_device *device)
 		}
 	}
 	if (!spic_dev.cur_ioport) {
-		pr_err(DRV_PFX "Failed to request_region.\n");
+		pr_err("Failed to request_region\n");
 		result = -ENODEV;
 		goto err_remove_compat;
 	}
@@ -3180,7 +3174,7 @@ static int sony_pic_add(struct acpi_device *device)
 		}
 	}
 	if (!spic_dev.cur_irq) {
-		pr_err(DRV_PFX "Failed to request_irq.\n");
+		pr_err("Failed to request_irq\n");
 		result = -ENODEV;
 		goto err_release_region;
 	}
@@ -3188,7 +3182,7 @@ static int sony_pic_add(struct acpi_device *device)
 	/* set resource status _SRS */
 	result = sony_pic_enable(device, spic_dev.cur_ioport, spic_dev.cur_irq);
 	if (result) {
-		pr_err(DRV_PFX "Couldn't enable device.\n");
+		pr_err("Couldn't enable device\n");
 		goto err_free_irq;
 	}
 
@@ -3297,7 +3291,7 @@ static int __init sony_laptop_init(void)
 	if (!no_spic && dmi_check_system(sonypi_dmi_table)) {
 		result = acpi_bus_register_driver(&sony_pic_driver);
 		if (result) {
-			pr_err(DRV_PFX "Unable to register SPIC driver.");
+			pr_err("Unable to register SPIC driver\n");
 			goto out;
 		}
 		spic_drv_registered = 1;
@@ -3305,7 +3299,7 @@ static int __init sony_laptop_init(void)
 
 	result = acpi_bus_register_driver(&sony_nc_driver);
 	if (result) {
-		pr_err(DRV_PFX "Unable to register SNC driver.");
+		pr_err("Unable to register SNC driver\n");
 		goto out_unregister_pic;
 	}
 
-- 
1.7.4.2.g597a6.dirty

