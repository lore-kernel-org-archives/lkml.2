Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab2DLFLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 01:11:12 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51163 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab2DLFLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 01:11:08 -0400
Date: Wed, 11 Apr 2012 22:11:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sundar Iyer <sundar.iyer@stericsson.com>, werner <w.landgraf@ru.ru>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Input: tc3589x-keypad - remove unnecessary checks
Message-ID: <20120412051100.GA16902@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

settle_time and debounce_period are u8 and thus can not be greater than
TC3589x_MAX_DEBOUNCE_SETTLE which is 255.

There also no need to mask out nibbles form board->krow and board->kcol
as we validate that they are in correct range.

Reported-by: Werner <w.landgraf@ru.ru>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/keyboard/tc3589x-keypad.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/input/keyboard/tc3589x-keypad.c b/drivers/input/keyboard/tc3589x-keypad.c
index 5c5b8a0..22082c5 100644
--- a/drivers/input/keyboard/tc3589x-keypad.c
+++ b/drivers/input/keyboard/tc3589x-keypad.c
@@ -96,21 +96,15 @@ static int tc3589x_keypad_init_key_hardware(struct tc_keypad *keypad)
 {
 	int ret;
 	struct tc3589x *tc3589x = keypad->tc3589x;
-	u8 settle_time = keypad->board->settle_time;
-	u8 dbounce_period = keypad->board->debounce_period;
-	u8 rows = keypad->board->krow & 0xf;	/* mask out the nibble */
-	u8 column = keypad->board->kcol & 0xf;	/* mask out the nibble */
-
-	/* validate platform configurations */
-	if (keypad->board->kcol > TC3589x_MAX_KPCOL ||
-	    keypad->board->krow > TC3589x_MAX_KPROW ||
-	    keypad->board->debounce_period > TC3589x_MAX_DEBOUNCE_SETTLE ||
-	    keypad->board->settle_time > TC3589x_MAX_DEBOUNCE_SETTLE)
+	const struct tc3589x_keypad_platform_data *board = keypad->board;
+
+	/* validate platform configuration */
+	if (board->kcol > TC3589x_MAX_KPCOL || board->krow > TC3589x_MAX_KPROW)
 		return -EINVAL;
 
 	/* configure KBDSIZE 4 LSbits for cols and 4 MSbits for rows */
 	ret = tc3589x_reg_write(tc3589x, TC3589x_KBDSIZE,
-			(rows << KP_ROW_SHIFT) | column);
+			(board->krow << KP_ROW_SHIFT) | board->kcol);
 	if (ret < 0)
 		return ret;
 
@@ -124,12 +118,14 @@ static int tc3589x_keypad_init_key_hardware(struct tc_keypad *keypad)
 		return ret;
 
 	/* Configure settle time */
-	ret = tc3589x_reg_write(tc3589x, TC3589x_KBDSETTLE_REG, settle_time);
+	ret = tc3589x_reg_write(tc3589x, TC3589x_KBDSETTLE_REG,
+				board->settle_time);
 	if (ret < 0)
 		return ret;
 
 	/* Configure debounce time */
-	ret = tc3589x_reg_write(tc3589x, TC3589x_KBDBOUNCE, dbounce_period);
+	ret = tc3589x_reg_write(tc3589x, TC3589x_KBDBOUNCE,
+				board->debounce_period);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.7.6


-- 
Dmitry
