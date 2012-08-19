Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab2HSRdm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 13:33:42 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:59767 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab2HSRdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 13:33:38 -0400
Date: Sun, 19 Aug 2012 19:32:54 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>, Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 3/6] HID: picoLCD: Add support for CIR
Message-ID: <20120819193254.6a48348d@neptune.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
References: <20120819192859.74136bb0@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement support for picoLCD's CIR header using RC_CORE for decoding
the IR event stream.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/hid-picolcd.h      |    5 ++-
 drivers/hid/hid-picolcd_cir.c  |   95 +++++++++++++++++++++++++++++++++++++++-
 drivers/hid/hid-picolcd_core.c |    3 +-
 3 files changed, 98 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-picolcd.h b/drivers/hid/hid-picolcd.h
index dc4c795..240eb1c 100644
--- a/drivers/hid/hid-picolcd.h
+++ b/drivers/hid/hid-picolcd.h
@@ -85,7 +85,9 @@ struct picolcd_data {
 	/* input stuff */
 	u8 pressed_keys[2];
 	struct input_dev *input_keys;
-	struct input_dev *input_cir;
+#ifdef CONFIG_HID_PICOLCD_CIR
+	struct rc_dev *rc_dev;
+#endif
 	unsigned short keycode[PICOLCD_KEYS];
 
 #ifdef CONFIG_HID_PICOLCD_FB
@@ -114,6 +116,7 @@ struct picolcd_data {
 	int status;
 #define PICOLCD_BOOTLOADER 1
 #define PICOLCD_FAILED 2
+#define PICOLCD_CIR_SHUN 4
 };
 
 #ifdef CONFIG_HID_PICOLCD_FB
diff --git a/drivers/hid/hid-picolcd_cir.c b/drivers/hid/hid-picolcd_cir.c
index dc632c3..f38af30 100644
--- a/drivers/hid/hid-picolcd_cir.c
+++ b/drivers/hid/hid-picolcd_cir.c
@@ -37,6 +37,7 @@
 #include <linux/completion.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
+#include <media/rc-core.h>
 
 #include "hid-picolcd.h"
 
@@ -44,18 +45,108 @@
 int picolcd_raw_cir(struct picolcd_data *data,
 		struct hid_report *report, u8 *raw_data, int size)
 {
-	/* Need understanding of CIR data format to implement ... */
+	unsigned long flags;
+	int i, w, sz;
+	DEFINE_IR_RAW_EVENT(rawir);
+
+	/* ignore if rc_dev is NULL or status is shunned */
+	spin_lock_irqsave(&data->lock, flags);
+	if (data->rc_dev && (data->status & PICOLCD_CIR_SHUN)) {
+		spin_unlock_irqrestore(&data->lock, flags);
+		return 1;
+	}
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	/* PicoLCD USB packets contain 16-bit intervals in network order,
+	 * with value negated for pulse. Intervals are in microseconds.
+	 *
+	 * Note: some userspace LIRC code for PicoLCD says negated values
+	 * for space - is it a matter of IR chip? (pulse for my TSOP2236)
+	 *
+	 * In addition, the first interval seems to be around 15000 + base
+	 * interval for non-first report of IR data - thus the quirk below
+	 * to get RC_CODE to understand Sony and JVC remotes I have at hand
+	 */
+	sz = size > 0 ? min((int)raw_data[0], size-1) : 0;
+	for (i = 0; i+1 < sz; i += 2) {
+		init_ir_raw_event(&rawir);
+		w = (raw_data[i] << 8) | (raw_data[i+1]);
+		rawir.pulse = !!(w & 0x8000);
+		rawir.duration = US_TO_NS(rawir.pulse ? (65536 - w) : w);
+		/* Quirk!! - see above */
+		if (i == 0 && rawir.duration > 15000000)
+			rawir.duration -= 15000000;
+		ir_raw_event_store(data->rc_dev, &rawir);
+	}
+	ir_raw_event_handle(data->rc_dev);
+
 	return 1;
 }
 
+static int picolcd_cir_open(struct rc_dev *dev)
+{
+	struct picolcd_data *data = dev->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->lock, flags);
+	data->status &= ~PICOLCD_CIR_SHUN;
+	spin_unlock_irqrestore(&data->lock, flags);
+	return 0;
+}
+
+static void picolcd_cir_close(struct rc_dev *dev)
+{
+	struct picolcd_data *data = dev->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->lock, flags);
+	data->status |= PICOLCD_CIR_SHUN;
+	spin_unlock_irqrestore(&data->lock, flags);
+}
+
 /* initialize CIR input device */
 int picolcd_init_cir(struct picolcd_data *data, struct hid_report *report)
 {
-	/* support not implemented yet */
+	struct rc_dev *rdev;
+	int ret = 0;
+
+	rdev = rc_allocate_device();
+	if (!rdev)
+		return -ENOMEM;
+
+	rdev->priv             = data;
+	rdev->driver_type      = RC_DRIVER_IR_RAW;
+	rdev->allowed_protos   = RC_TYPE_ALL;
+	rdev->open             = picolcd_cir_open;
+	rdev->close            = picolcd_cir_close;
+	rdev->input_name       = data->hdev->name;
+	rdev->input_phys       = data->hdev->phys;
+	rdev->input_id.bustype = data->hdev->bus;
+	rdev->input_id.vendor  = data->hdev->vendor;
+	rdev->input_id.product = data->hdev->product;
+	rdev->input_id.version = data->hdev->version;
+	rdev->dev.parent       = &data->hdev->dev;
+	rdev->driver_name      = PICOLCD_NAME;
+	rdev->map_name         = RC_MAP_RC6_MCE;
+	rdev->timeout          = MS_TO_NS(100);
+	rdev->rx_resolution    = US_TO_NS(1);
+
+	ret = rc_register_device(rdev);
+	if (ret)
+		goto err;
+	data->rc_dev = rdev;
 	return 0;
+
+err:
+	rc_free_device(rdev);
+	return ret;
 }
 
 void picolcd_exit_cir(struct picolcd_data *data)
 {
+	struct rc_dev *rdev = data->rc_dev;
+
+	data->rc_dev = NULL;
+	rc_unregister_device(rdev);
 }
 
diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
index 76ab173..580269b 100644
--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -356,8 +356,7 @@ static int picolcd_raw_event(struct hid_device *hdev,
 		if (data->input_keys)
 			ret = picolcd_raw_keypad(data, report, raw_data+1, size-1);
 	} else if (report->id == REPORT_IR_DATA) {
-		if (data->input_cir)
-			ret = picolcd_raw_cir(data, report, raw_data+1, size-1);
+		ret = picolcd_raw_cir(data, report, raw_data+1, size-1);
 	} else {
 		spin_lock_irqsave(&data->lock, flags);
 		/*
-- 
1.7.8.6

