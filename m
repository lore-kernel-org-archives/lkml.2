Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423660Ab2LFO5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 09:57:10 -0500
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:40313 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423634Ab2LFO5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 09:57:07 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnZKABOywFBV5qjOPGdsb2JhbABEhUuFI7M6FwMBAQEBODSCHgEBBAEnExwjBQsIAw44FCUKGhOICgrCOhSMJRyDRmEDlgKFe41BgWMj
X-IronPort-AV: E=Sophos;i="4.84,230,1355094000"; 
   d="scan'208";a="462729732"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 6 Dec 2012 15:59:11 +0100
To: Benson Leung <bleung@chromium.org>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, djkurtz@chromium.org, olofj@chromium.org,
        dudl@cypress.com
Subject: Re: [PATCH v2 1/1] Input: add driver for Cypress APA I2C Trackpad
Message-ID: <20121206145911.GA9882@polaris.bitmath.org>
References: <1341959357-14691-1-git-send-email-bleung@chromium.org>
 <1354754899-26701-1-git-send-email-bleung@chromium.org>
 <1354754899-26701-2-git-send-email-bleung@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354754899-26701-2-git-send-email-bleung@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benson,

> This patch introduces a driver for Cypress All Points Addressable
> I2C Trackpad, including the ones in 2012 Samsung Chromebooks.
> 
> This device is compatible with MT protocol type B, providing identifiable
> contacts.
> 
> Signed-off-by: Dudley Du <dudl@cypress.com>
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> Signed-off-by: Benson Leung <bleung@chromium.org>
> ---
>  Version history :
> v2 : * Removed firmware update.
>      * Removed sysfs properties related to firmware update and power mode.
>      * Folded cyapa_detect into cyapa_probe.
>      * Added support for middle and right mechanical buttons, if they exist.
>      * Rearranged disable_irq/enable_irq in suspend and resume to prevent
>          a power mode change from colliding with a read of tracking data.
>      * Made cyapa_get_state more reliable.
>      * Use IRQF_ONESHOT for threaded irq
>      * Simplified cyapa_set_power_mode.
>      * Removed extra kernel-doc style comments
>      * Removed dev_dbg messages.
>      * Cleaned up unused includes.
>      * Cleaned up unused #defines
> v1 : Initial
> ---
>  drivers/input/mouse/Kconfig  |   12 +
>  drivers/input/mouse/Makefile |    1 +
>  drivers/input/mouse/cyapa.c  |  838 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 851 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/input/mouse/cyapa.c

Looking good overall. The patch does not compile in 3.7, and it is
possible to further simplify the MT handling. The patch below takes
care of those changes. If it still works for you with this applied, we
should be fine.

Thanks,
Henrik

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 08cf1ce..762fe9c 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -545,7 +545,6 @@ static irqreturn_t cyapa_irq(int irq, void *dev_id)
 	int i;
 	int ret;
 	int num_fingers;
-	unsigned int mask;
 
 	if (device_may_wakeup(dev))
 		pm_wakeup_event(dev, 0);
@@ -560,14 +559,12 @@ static irqreturn_t cyapa_irq(int irq, void *dev_id)
 		goto irqhandled;
 	}
 
-	mask = 0;
 	num_fingers = (data.finger_btn >> 4) & 0x0f;
 	for (i = 0; i < num_fingers; i++) {
 		const struct cyapa_touch *touch = &data.touches[i];
 		/* Note: touch->id range is 1 to 15; slots are 0 to 14. */
 		int slot = touch->id - 1;
 
-		mask |= (1 << slot);
 		input_mt_slot(input, slot);
 		input_mt_report_slot_state(input, MT_TOOL_FINGER, true);
 		input_report_abs(input, ABS_MT_POSITION_X,
@@ -577,15 +574,8 @@ static irqreturn_t cyapa_irq(int irq, void *dev_id)
 		input_report_abs(input, ABS_MT_PRESSURE, touch->pressure);
 	}
 
-	/* Invalidate all unreported slots */
-	for (i = 0; i < CYAPA_MAX_MT_SLOTS; i++) {
-		if (mask & (1 << i))
-			continue;
-		input_mt_slot(input, i);
-		input_mt_report_slot_state(input, MT_TOOL_FINGER, false);
-	}
+	input_mt_sync_frame(input);
 
-	input_mt_report_pointer_emulation(input, true);
 	if (cyapa->btn_capability & CAPABILITY_LEFT_BTN_MASK) {
 		input_report_key(input, BTN_LEFT,
 				 !!(data.finger_btn & OP_DATA_LEFT_BTN));
@@ -610,6 +600,9 @@ static int cyapa_create_input_dev(struct cyapa *cyapa)
 	int ret;
 	struct input_dev *input;
 
+	if (!cyapa->physical_size_x || !cyapa->physical_size_y)
+		return -EINVAL;
+
 	input = cyapa->input = input_allocate_device();
 	if (!input) {
 		dev_err(dev, "allocate memory for input device failed\n");
@@ -625,47 +618,17 @@ static int cyapa_create_input_dev(struct cyapa *cyapa)
 
 	input_set_drvdata(input, cyapa);
 
-	__set_bit(EV_ABS, input->evbit);
-
-	/*
-	 * set and report not-MT axes to support synaptics X Driver.
-	 * When multi-fingers on trackpad, only the first finger touch
-	 * will be reported as X/Y axes values.
-	 */
-	input_set_abs_params(input, ABS_X, 0, cyapa->max_abs_x, 0, 0);
-	input_set_abs_params(input, ABS_Y, 0, cyapa->max_abs_y, 0, 0);
-	input_set_abs_params(input, ABS_PRESSURE, 0, 255, 0, 0);
-
 	/* finger position */
 	input_set_abs_params(input, ABS_MT_POSITION_X, 0, cyapa->max_abs_x, 0,
 			     0);
 	input_set_abs_params(input, ABS_MT_POSITION_Y, 0, cyapa->max_abs_y, 0,
 			     0);
 	input_set_abs_params(input, ABS_MT_PRESSURE, 0, 255, 0, 0);
-	ret = input_mt_init_slots(input, CYAPA_MAX_MT_SLOTS);
-	if (ret < 0) {
-		dev_err(dev, "allocate memory for MT slots failed, %d\n", ret);
-		goto err_free_device;
-	}
-
-	if (cyapa->physical_size_x && cyapa->physical_size_y) {
-		input_abs_set_res(input, ABS_X,
-			cyapa->max_abs_x / cyapa->physical_size_x);
-		input_abs_set_res(input, ABS_Y,
-			cyapa->max_abs_y / cyapa->physical_size_y);
-		input_abs_set_res(input, ABS_MT_POSITION_X,
-			cyapa->max_abs_x / cyapa->physical_size_x);
-		input_abs_set_res(input, ABS_MT_POSITION_Y,
-			cyapa->max_abs_y / cyapa->physical_size_y);
-	}
 
-	__set_bit(EV_KEY, input->evbit);
-	__set_bit(BTN_TOUCH, input->keybit);
-	__set_bit(BTN_TOOL_FINGER, input->keybit);
-	__set_bit(BTN_TOOL_DOUBLETAP, input->keybit);
-	__set_bit(BTN_TOOL_TRIPLETAP, input->keybit);
-	__set_bit(BTN_TOOL_QUADTAP, input->keybit);
-	__set_bit(BTN_TOOL_QUINTTAP, input->keybit);
+	input_abs_set_res(input, ABS_MT_POSITION_X,
+			  cyapa->max_abs_x / cyapa->physical_size_x);
+	input_abs_set_res(input, ABS_MT_POSITION_Y,
+			  cyapa->max_abs_y / cyapa->physical_size_y);
 
 	if (cyapa->btn_capability & CAPABILITY_LEFT_BTN_MASK)
 		__set_bit(BTN_LEFT, input->keybit);
@@ -674,9 +637,16 @@ static int cyapa_create_input_dev(struct cyapa *cyapa)
 	if (cyapa->btn_capability & CAPABILITY_RIGHT_BTN_MASK)
 		__set_bit(BTN_RIGHT, input->keybit);
 
-	__set_bit(INPUT_PROP_POINTER, input->propbit);
 	__set_bit(INPUT_PROP_BUTTONPAD, input->propbit);
 
+	/* handle pointer emulation and unused slots in core */
+	ret = input_mt_init_slots(input, CYAPA_MAX_MT_SLOTS,
+				  INPUT_MT_POINTER | INPUT_MT_DROP_UNUSED);
+	if (ret) {
+		dev_err(dev, "allocate memory for MT slots failed, %d\n", ret);
+		goto err_free_device;
+	}
+
 	/* Register the device in input subsystem */
 	ret = input_register_device(input);
 	if (ret) {
