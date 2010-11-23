Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab0KWHfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:35:06 -0500
Received: from mail.perches.com ([173.55.12.10]:1801 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab0KWHfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:35:04 -0500
Subject: [PATCH] hid: hidpidff: Use pr_<level>
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-usb@vger.kernel.o, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 23:35:01 -0800
Message-ID: <1290497701.28824.6.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prefixes were not standardized in this module.
Some used "hid-pidff:", others "hidpidff:".
Add pr_fmt(fmt) KBUILD_MODNAME ": " fmt to standardize prefix uses.
Convert to pr_<level>, strip leading prefix.
Use normal pr_debug not debug, add trailing "\n".
Coalesced long formats.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hid/usbhid/hid-pidff.c |  153 +++++++++++++++++----------------------
 1 files changed, 67 insertions(+), 86 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index ef381d7..4cdf84f 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -22,7 +22,7 @@
 
 /* #define DEBUG */
 
-#define debug(format, arg...) pr_debug("hid-pidff: " format "\n" , ## arg)
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/input.h>
 #include <linux/slab.h>
@@ -220,7 +220,7 @@ static int pidff_rescale_signed(int i, struct hid_field *field)
 static void pidff_set(struct pidff_usage *usage, u16 value)
 {
 	usage->value[0] = pidff_rescale(value, 0xffff, usage->field);
-	debug("calculated from %d to %d", value, usage->value[0]);
+	pr_debug("calculated from %d to %d\n", value, usage->value[0]);
 }
 
 static void pidff_set_signed(struct pidff_usage *usage, s16 value)
@@ -235,7 +235,7 @@ static void pidff_set_signed(struct pidff_usage *usage, s16 value)
 			usage->value[0] =
 			    pidff_rescale(value, 0x7fff, usage->field);
 	}
-	debug("calculated from %d to %d", value, usage->value[0]);
+	pr_debug("calculated from %d to %d\n", value, usage->value[0]);
 }
 
 /*
@@ -259,8 +259,9 @@ static void pidff_set_envelope_report(struct pidff_device *pidff,
 	pidff->set_envelope[PID_ATTACK_TIME].value[0] = envelope->attack_length;
 	pidff->set_envelope[PID_FADE_TIME].value[0] = envelope->fade_length;
 
-	debug("attack %u => %d", envelope->attack_level,
-	      pidff->set_envelope[PID_ATTACK_LEVEL].value[0]);
+	pr_debug("attack %u => %d\n",
+		 envelope->attack_level,
+		 pidff->set_envelope[PID_ATTACK_LEVEL].value[0]);
 
 	usbhid_submit_report(pidff->hid, pidff->reports[PID_SET_ENVELOPE],
 			  USB_DIR_OUT);
@@ -466,33 +467,33 @@ static int pidff_request_effect_upload(struct pidff_device *pidff, int efnum)
 	pidff->create_new_effect_type->value[0] = efnum;
 	usbhid_submit_report(pidff->hid, pidff->reports[PID_CREATE_NEW_EFFECT],
 			  USB_DIR_OUT);
-	debug("create_new_effect sent, type: %d", efnum);
+	pr_debug("create_new_effect sent, type: %d\n", efnum);
 
 	pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0] = 0;
 	pidff->block_load_status->value[0] = 0;
 	usbhid_wait_io(pidff->hid);
 
 	for (j = 0; j < 60; j++) {
-		debug("pid_block_load requested");
+		pr_debug("pid_block_load requested\n");
 		usbhid_submit_report(pidff->hid, pidff->reports[PID_BLOCK_LOAD],
 				  USB_DIR_IN);
 		usbhid_wait_io(pidff->hid);
 		if (pidff->block_load_status->value[0] ==
 		    pidff->status_id[PID_BLOCK_LOAD_SUCCESS]) {
-			debug("device reported free memory: %d bytes",
-			      pidff->block_load[PID_RAM_POOL_AVAILABLE].value ?
-				pidff->block_load[PID_RAM_POOL_AVAILABLE].value[0] : -1);
+			pr_debug("device reported free memory: %d bytes\n",
+				 pidff->block_load[PID_RAM_POOL_AVAILABLE].value ?
+				 pidff->block_load[PID_RAM_POOL_AVAILABLE].value[0] : -1);
 			return 0;
 		}
 		if (pidff->block_load_status->value[0] ==
 		    pidff->status_id[PID_BLOCK_LOAD_FULL]) {
-			debug("not enough memory free: %d bytes",
-			      pidff->block_load[PID_RAM_POOL_AVAILABLE].value ?
-				pidff->block_load[PID_RAM_POOL_AVAILABLE].value[0] : -1);
+			pr_debug("not enough memory free: %d bytes\n",
+				 pidff->block_load[PID_RAM_POOL_AVAILABLE].value ?
+				 pidff->block_load[PID_RAM_POOL_AVAILABLE].value[0] : -1);
 			return -ENOSPC;
 		}
 	}
-	printk(KERN_ERR "hid-pidff: pid_block_load failed 60 times\n");
+	pr_err("pid_block_load failed 60 times\n");
 	return -EIO;
 }
 
@@ -546,7 +547,8 @@ static int pidff_erase_effect(struct input_dev *dev, int effect_id)
 	struct pidff_device *pidff = dev->ff->private;
 	int pid_id = pidff->pid_id[effect_id];
 
-	debug("starting to erase %d/%d", effect_id, pidff->pid_id[effect_id]);
+	pr_debug("starting to erase %d/%d\n",
+		 effect_id, pidff->pid_id[effect_id]);
 	/* Wait for the queue to clear. We do not want a full fifo to
 	   prevent the effect removal. */
 	usbhid_wait_io(pidff->hid);
@@ -604,8 +606,7 @@ static int pidff_upload_effect(struct input_dev *dev, struct ff_effect *effect,
 				type_id = PID_SAW_DOWN;
 				break;
 			default:
-				printk(KERN_ERR
-				       "hid-pidff: invalid waveform\n");
+				pr_err("invalid waveform\n");
 				return -EINVAL;
 			}
 
@@ -696,7 +697,7 @@ static int pidff_upload_effect(struct input_dev *dev, struct ff_effect *effect,
 		break;
 
 	default:
-		printk(KERN_ERR "hid-pidff: invalid type\n");
+		pr_err("invalid type\n");
 		return -EINVAL;
 	}
 
@@ -704,7 +705,7 @@ static int pidff_upload_effect(struct input_dev *dev, struct ff_effect *effect,
 		pidff->pid_id[effect->id] =
 		    pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0];
 
-	debug("uploaded");
+	pr_debug("uploaded\n");
 
 	return 0;
 }
@@ -770,14 +771,14 @@ static int pidff_find_fields(struct pidff_usage *usage, const u8 *table,
 		for (i = 0; i < report->maxfield; i++) {
 			if (report->field[i]->maxusage !=
 			    report->field[i]->report_count) {
-				debug("maxusage and report_count do not match, "
-				      "skipping");
+				pr_debug("maxusage and report_count do not match, skipping\n");
 				continue;
 			}
 			for (j = 0; j < report->field[i]->maxusage; j++) {
 				if (report->field[i]->usage[j].hid ==
 				    (HID_UP_PID | table[k])) {
-					debug("found %d at %d->%d", k, i, j);
+					pr_debug("found %d at %d->%d\n",
+						 k, i, j);
 					usage[k].field = report->field[i];
 					usage[k].value =
 						&report->field[i]->value[j];
@@ -789,7 +790,7 @@ static int pidff_find_fields(struct pidff_usage *usage, const u8 *table,
 				break;
 		}
 		if (!found && strict) {
-			debug("failed to locate %d", k);
+			pr_debug("failed to locate %d\n", k);
 			return -1;
 		}
 	}
@@ -826,8 +827,8 @@ static void pidff_find_reports(struct hid_device *hid, int report_type,
 			continue;
 		ret = pidff_check_usage(report->field[0]->logical);
 		if (ret != -1) {
-			debug("found usage 0x%02x from field->logical",
-			      pidff_reports[ret]);
+			pr_debug("found usage 0x%02x from field->logical\n",
+				 pidff_reports[ret]);
 			pidff->reports[ret] = report;
 			continue;
 		}
@@ -845,8 +846,8 @@ static void pidff_find_reports(struct hid_device *hid, int report_type,
 			continue;
 		ret = pidff_check_usage(hid->collection[i - 1].usage);
 		if (ret != -1 && !pidff->reports[ret]) {
-			debug("found usage 0x%02x from collection array",
-			      pidff_reports[ret]);
+			pr_debug("found usage 0x%02x from collection array\n",
+				 pidff_reports[ret]);
 			pidff->reports[ret] = report;
 		}
 	}
@@ -861,7 +862,7 @@ static int pidff_reports_ok(struct pidff_device *pidff)
 
 	for (i = 0; i <= PID_REQUIRED_REPORTS; i++) {
 		if (!pidff->reports[i]) {
-			debug("%d missing", i);
+			pr_debug("%d missing\n", i);
 			return 0;
 		}
 	}
@@ -884,8 +885,7 @@ static struct hid_field *pidff_find_special_field(struct hid_report *report,
 			    report->field[i]->logical_minimum == 1)
 				return report->field[i];
 			else {
-				printk(KERN_ERR "hid-pidff: logical_minimum "
-					"is not 1 as it should be\n");
+				pr_err("logical_minimum is not 1 as it should be\n");
 				return NULL;
 			}
 		}
@@ -924,7 +924,7 @@ static int pidff_find_special_keys(int *keys, struct hid_field *fld,
  */
 static int pidff_find_special_fields(struct pidff_device *pidff)
 {
-	debug("finding special fields");
+	pr_debug("finding special fields\n");
 
 	pidff->create_new_effect_type =
 		pidff_find_special_field(pidff->reports[PID_CREATE_NEW_EFFECT],
@@ -945,32 +945,30 @@ static int pidff_find_special_fields(struct pidff_device *pidff)
 		pidff_find_special_field(pidff->reports[PID_EFFECT_OPERATION],
 					 0x78, 1);
 
-	debug("search done");
+	pr_debug("search done\n");
 
 	if (!pidff->create_new_effect_type || !pidff->set_effect_type) {
-		printk(KERN_ERR "hid-pidff: effect lists not found\n");
+		pr_err("effect lists not found\n");
 		return -1;
 	}
 
 	if (!pidff->effect_direction) {
-		printk(KERN_ERR "hid-pidff: direction field not found\n");
+		pr_err("direction field not found\n");
 		return -1;
 	}
 
 	if (!pidff->device_control) {
-		printk(KERN_ERR "hid-pidff: device control field not found\n");
+		pr_err("device control field not found\n");
 		return -1;
 	}
 
 	if (!pidff->block_load_status) {
-		printk(KERN_ERR
-		       "hid-pidff: block load status field not found\n");
+		pr_err("block load status field not found\n");
 		return -1;
 	}
 
 	if (!pidff->effect_operation_status) {
-		printk(KERN_ERR
-		       "hid-pidff: effect operation field not found\n");
+		pr_err("effect operation field not found\n");
 		return -1;
 	}
 
@@ -982,23 +980,21 @@ static int pidff_find_special_fields(struct pidff_device *pidff)
 
 	if (!PIDFF_FIND_SPECIAL_KEYS(type_id, create_new_effect_type,
 				     effect_types)) {
-		printk(KERN_ERR "hid-pidff: no effect types found\n");
+		pr_err("no effect types found\n");
 		return -1;
 	}
 
 	if (PIDFF_FIND_SPECIAL_KEYS(status_id, block_load_status,
 				    block_load_status) !=
 			sizeof(pidff_block_load_status)) {
-		printk(KERN_ERR
-		       "hidpidff: block load status identifiers not found\n");
+		pr_err("block load status identifiers not found\n");
 		return -1;
 	}
 
 	if (PIDFF_FIND_SPECIAL_KEYS(operation_id, effect_operation_status,
 				    effect_operation_status) !=
 			sizeof(pidff_effect_operation_status)) {
-		printk(KERN_ERR
-		       "hidpidff: effect operation identifiers not found\n");
+		pr_err("effect operation identifiers not found\n");
 		return -1;
 	}
 
@@ -1017,8 +1013,7 @@ static int pidff_find_effects(struct pidff_device *pidff,
 		int pidff_type = pidff->type_id[i];
 		if (pidff->set_effect_type->usage[pidff_type].hid !=
 		    pidff->create_new_effect_type->usage[pidff_type].hid) {
-			printk(KERN_ERR "hid-pidff: "
-			       "effect type number %d is invalid\n", i);
+			pr_err("effect type number %d is invalid\n", i);
 			return -1;
 		}
 	}
@@ -1073,27 +1068,23 @@ static int pidff_init_fields(struct pidff_device *pidff, struct input_dev *dev)
 	int envelope_ok = 0;
 
 	if (PIDFF_FIND_FIELDS(set_effect, PID_SET_EFFECT, 1)) {
-		printk(KERN_ERR
-		       "hid-pidff: unknown set_effect report layout\n");
+		pr_err("unknown set_effect report layout\n");
 		return -ENODEV;
 	}
 
 	PIDFF_FIND_FIELDS(block_load, PID_BLOCK_LOAD, 0);
 	if (!pidff->block_load[PID_EFFECT_BLOCK_INDEX].value) {
-		printk(KERN_ERR
-		       "hid-pidff: unknown pid_block_load report layout\n");
+		pr_err("unknown pid_block_load report layout\n");
 		return -ENODEV;
 	}
 
 	if (PIDFF_FIND_FIELDS(effect_operation, PID_EFFECT_OPERATION, 1)) {
-		printk(KERN_ERR
-		       "hid-pidff: unknown effect_operation report layout\n");
+		pr_err("unknown effect_operation report layout\n");
 		return -ENODEV;
 	}
 
 	if (PIDFF_FIND_FIELDS(block_free, PID_BLOCK_FREE, 1)) {
-		printk(KERN_ERR
-		       "hid-pidff: unknown pid_block_free report layout\n");
+		pr_err("unknown pid_block_free report layout\n");
 		return -ENODEV;
 	}
 
@@ -1105,27 +1096,23 @@ static int pidff_init_fields(struct pidff_device *pidff, struct input_dev *dev)
 
 	if (!envelope_ok) {
 		if (test_and_clear_bit(FF_CONSTANT, dev->ffbit))
-			printk(KERN_WARNING "hid-pidff: "
-			       "has constant effect but no envelope\n");
+			pr_warn("has constant effect but no envelope\n");
 		if (test_and_clear_bit(FF_RAMP, dev->ffbit))
-			printk(KERN_WARNING "hid-pidff: "
-				"has ramp effect but no envelope\n");
+			pr_warn("has ramp effect but no envelope\n");
 
 		if (test_and_clear_bit(FF_PERIODIC, dev->ffbit))
-			printk(KERN_WARNING "hid-pidff: "
-				"has periodic effect but no envelope\n");
+			pr_warn("has periodic effect but no envelope\n");
 	}
 
 	if (test_bit(FF_CONSTANT, dev->ffbit) &&
 	    PIDFF_FIND_FIELDS(set_constant, PID_SET_CONSTANT, 1)) {
-		printk(KERN_WARNING
-		       "hid-pidff: unknown constant effect layout\n");
+		pr_warn("unknown constant effect layout\n");
 		clear_bit(FF_CONSTANT, dev->ffbit);
 	}
 
 	if (test_bit(FF_RAMP, dev->ffbit) &&
 	    PIDFF_FIND_FIELDS(set_ramp, PID_SET_RAMP, 1)) {
-		printk(KERN_WARNING "hid-pidff: unknown ramp effect layout\n");
+		pr_warn("unknown ramp effect layout\n");
 		clear_bit(FF_RAMP, dev->ffbit);
 	}
 
@@ -1134,8 +1121,7 @@ static int pidff_init_fields(struct pidff_device *pidff, struct input_dev *dev)
 	     test_bit(FF_FRICTION, dev->ffbit) ||
 	     test_bit(FF_INERTIA, dev->ffbit)) &&
 	    PIDFF_FIND_FIELDS(set_condition, PID_SET_CONDITION, 1)) {
-		printk(KERN_WARNING
-		       "hid-pidff: unknown condition effect layout\n");
+		pr_warn("unknown condition effect layout\n");
 		clear_bit(FF_SPRING, dev->ffbit);
 		clear_bit(FF_DAMPER, dev->ffbit);
 		clear_bit(FF_FRICTION, dev->ffbit);
@@ -1144,8 +1130,7 @@ static int pidff_init_fields(struct pidff_device *pidff, struct input_dev *dev)
 
 	if (test_bit(FF_PERIODIC, dev->ffbit) &&
 	    PIDFF_FIND_FIELDS(set_periodic, PID_SET_PERIODIC, 1)) {
-		printk(KERN_WARNING
-		       "hid-pidff: unknown periodic effect layout\n");
+		pr_warn("unknown periodic effect layout\n");
 		clear_bit(FF_PERIODIC, dev->ffbit);
 	}
 
@@ -1184,12 +1169,11 @@ static void pidff_reset(struct pidff_device *pidff)
 	if (pidff->pool[PID_SIMULTANEOUS_MAX].value) {
 		while (pidff->pool[PID_SIMULTANEOUS_MAX].value[0] < 2) {
 			if (i++ > 20) {
-				printk(KERN_WARNING "hid-pidff: device reports "
-				       "%d simultaneous effects\n",
-				       pidff->pool[PID_SIMULTANEOUS_MAX].value[0]);
+				pr_warn("device reports %d simultaneous effects\n",
+					pidff->pool[PID_SIMULTANEOUS_MAX].value[0]);
 				break;
 			}
-			debug("pid_pool requested again");
+			pr_debug("pid_pool requested again\n");
 			usbhid_submit_report(hid, pidff->reports[PID_POOL],
 					  USB_DIR_IN);
 			usbhid_wait_io(hid);
@@ -1215,7 +1199,7 @@ static int pidff_check_autocenter(struct pidff_device *pidff,
 
 	error = pidff_request_effect_upload(pidff, 1);
 	if (error) {
-		printk(KERN_ERR "hid-pidff: upload request failed\n");
+		pr_err("upload request failed\n");
 		return error;
 	}
 
@@ -1224,8 +1208,7 @@ static int pidff_check_autocenter(struct pidff_device *pidff,
 		pidff_autocenter(pidff, 0xffff);
 		set_bit(FF_AUTOCENTER, dev->ffbit);
 	} else {
-		printk(KERN_NOTICE "hid-pidff: "
-		       "device has unknown autocenter control method\n");
+		pr_notice("device has unknown autocenter control method\n");
 	}
 
 	pidff_erase_pid(pidff,
@@ -1248,10 +1231,10 @@ int hid_pidff_init(struct hid_device *hid)
 	int max_effects;
 	int error;
 
-	debug("starting pid init");
+	pr_debug("starting pid init\n");
 
 	if (list_empty(&hid->report_enum[HID_OUTPUT_REPORT].report_list)) {
-		debug("not a PID device, no output report");
+		pr_debug("not a PID device, no output report\n");
 		return -ENODEV;
 	}
 
@@ -1265,7 +1248,7 @@ int hid_pidff_init(struct hid_device *hid)
 	pidff_find_reports(hid, HID_FEATURE_REPORT, pidff);
 
 	if (!pidff_reports_ok(pidff)) {
-		debug("reports not ok, aborting");
+		pr_debug("reports not ok, aborting\n");
 		error = -ENODEV;
 		goto fail;
 	}
@@ -1290,23 +1273,22 @@ int hid_pidff_init(struct hid_device *hid)
 	    pidff->block_load[PID_EFFECT_BLOCK_INDEX].field->logical_maximum -
 	    pidff->block_load[PID_EFFECT_BLOCK_INDEX].field->logical_minimum +
 	    1;
-	debug("max effects is %d", max_effects);
+	pr_debug("max effects is %d\n", max_effects);
 
 	if (max_effects > PID_EFFECTS_MAX)
 		max_effects = PID_EFFECTS_MAX;
 
 	if (pidff->pool[PID_SIMULTANEOUS_MAX].value)
-		debug("max simultaneous effects is %d",
-		      pidff->pool[PID_SIMULTANEOUS_MAX].value[0]);
+		pr_debug("max simultaneous effects is %d\n",
+			 pidff->pool[PID_SIMULTANEOUS_MAX].value[0]);
 
 	if (pidff->pool[PID_RAM_POOL_SIZE].value)
-		debug("device memory size is %d bytes",
-		      pidff->pool[PID_RAM_POOL_SIZE].value[0]);
+		pr_debug("device memory size is %d bytes\n",
+			 pidff->pool[PID_RAM_POOL_SIZE].value[0]);
 
 	if (pidff->pool[PID_DEVICE_MANAGED_POOL].value &&
 	    pidff->pool[PID_DEVICE_MANAGED_POOL].value[0] == 0) {
-		printk(KERN_NOTICE "hid-pidff: "
-		       "device does not support device managed pool\n");
+		pr_notice("device does not support device managed pool\n");
 		goto fail;
 	}
 
@@ -1322,8 +1304,7 @@ int hid_pidff_init(struct hid_device *hid)
 	ff->set_autocenter = pidff_set_autocenter;
 	ff->playback = pidff_playback;
 
-	printk(KERN_INFO "Force feedback for USB HID PID devices by "
-	       "Anssi Hannula <anssi.hannula@gmail.com>\n");
+	pr_info("Force feedback for USB HID PID devices by Anssi Hannula <anssi.hannula@gmail.com>\n");
 
 	return 0;
 


