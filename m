Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab2GZGMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 02:12:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50420 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2GZGMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 02:12:03 -0400
From: Benson Leung <bleung@chromium.org>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH] Input: gpio_keys - Report wakeup events if device may wakeup
Date: Wed, 25 Jul 2012 23:11:53 -0700
Message-Id: <1343283113-16952-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a button is configured to wake the system, report a pm wakeup event.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/keyboard/gpio_keys.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index cbb1add..15a80e2 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -328,9 +328,13 @@ static void gpio_keys_gpio_report_event(struct gpio_button_data *bdata)
 {
 	const struct gpio_keys_button *button = bdata->button;
 	struct input_dev *input = bdata->input;
+	struct device *dev = input->dev.parent;
 	unsigned int type = button->type ?: EV_KEY;
 	int state = (gpio_get_value_cansleep(button->gpio) ? 1 : 0) ^ button->active_low;
 
+	if (button->wakeup && device_may_wakeup(dev))
+		pm_wakeup_event(dev, 0);
+
 	if (type == EV_ABS) {
 		if (state)
 			input_event(input, type, button->code, button->value);
-- 
1.7.7.3

