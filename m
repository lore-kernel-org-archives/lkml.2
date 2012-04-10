Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab2DJIEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:04:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38432 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab2DJIER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:04:17 -0400
Date: Tue, 10 Apr 2012 01:04:14 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: matrix-keypad - allocate keycodes with keypad
Message-ID: <20120410080413.GA19191@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of allocating and managing keymap separately from the keypad
structure stick it at the end as a variable-length array.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/keyboard/matrix_keypad.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index 8714d68..a4ff08c 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -27,7 +27,6 @@
 struct matrix_keypad {
 	const struct matrix_keypad_platform_data *pdata;
 	struct input_dev *input_dev;
-	unsigned short *keycodes;
 	unsigned int row_shift;
 
 	DECLARE_BITMAP(disabled_gpios, MATRIX_MAX_ROWS);
@@ -38,6 +37,8 @@ struct matrix_keypad {
 	bool scan_pending;
 	bool stopped;
 	bool gpio_all_disabled;
+
+	unsigned short keycodes[];
 };
 
 /*
@@ -381,8 +382,8 @@ static int __devinit matrix_keypad_probe(struct platform_device *pdev)
 	const struct matrix_keymap_data *keymap_data;
 	struct matrix_keypad *keypad;
 	struct input_dev *input_dev;
-	unsigned short *keycodes;
 	unsigned int row_shift;
+	size_t keymap_size;
 	int err;
 
 	pdata = pdev->dev.platform_data;
@@ -398,20 +399,18 @@ static int __devinit matrix_keypad_probe(struct platform_device *pdev)
 	}
 
 	row_shift = get_count_order(pdata->num_col_gpios);
-
-	keypad = kzalloc(sizeof(struct matrix_keypad), GFP_KERNEL);
-	keycodes = kzalloc((pdata->num_row_gpios << row_shift) *
-				sizeof(*keycodes),
-			   GFP_KERNEL);
+	keymap_size = (pdata->num_row_gpios << row_shift) *
+			sizeof(keypad->keycodes[0]);
+	keypad = kzalloc(sizeof(struct matrix_keypad) + keymap_size,
+			 GFP_KERNEL);
 	input_dev = input_allocate_device();
-	if (!keypad || !keycodes || !input_dev) {
+	if (!keypad || !input_dev) {
 		err = -ENOMEM;
 		goto err_free_mem;
 	}
 
 	keypad->input_dev = input_dev;
 	keypad->pdata = pdata;
-	keypad->keycodes = keycodes;
 	keypad->row_shift = row_shift;
 	keypad->stopped = true;
 	INIT_DELAYED_WORK(&keypad->work, matrix_keypad_scan);
@@ -426,8 +425,8 @@ static int __devinit matrix_keypad_probe(struct platform_device *pdev)
 	input_dev->open		= matrix_keypad_start;
 	input_dev->close	= matrix_keypad_stop;
 
-	input_dev->keycode	= keycodes;
-	input_dev->keycodesize	= sizeof(*keycodes);
+	input_dev->keycode	= keypad->keycodes;
+	input_dev->keycodesize	= sizeof(keypad->keycodes[0]);
 	input_dev->keycodemax	= pdata->num_row_gpios << row_shift;
 
 	matrix_keypad_build_keymap(keymap_data, row_shift,
@@ -451,7 +450,6 @@ static int __devinit matrix_keypad_probe(struct platform_device *pdev)
 
 err_free_mem:
 	input_free_device(input_dev);
-	kfree(keycodes);
 	kfree(keypad);
 	return err;
 }
@@ -479,7 +477,6 @@ static int __devexit matrix_keypad_remove(struct platform_device *pdev)
 
 	input_unregister_device(keypad->input_dev);
 	platform_set_drvdata(pdev, NULL);
-	kfree(keypad->keycodes);
 	kfree(keypad);
 
 	return 0;
-- 
1.7.7.6


-- 
Dmitry
