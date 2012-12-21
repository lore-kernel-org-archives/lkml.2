Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab2LUCj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:39:56 -0500
Received: from mail-qa0-f74.google.com ([209.85.216.74]:40245 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab2LUCjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:39:49 -0500
From: Shawn Nematbakhsh <shawnn@chromium.org>
To: dmitry.torokhov@gmail.com
Cc: shawnn@chromium.org, jj@chaosbits.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] atkbd: Fix multi-char scancode handling on reconnect.
Date: Thu, 20 Dec 2012 18:33:11 -0800
Message-Id: <1356057191-24664-1-git-send-email-shawnn@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On resume from suspend there is a possibility for multi-byte scancodes
to be handled incorrectly. atkbd_reconnect disables the processing of
scancodes in software by calling atkbd_disable, but the keyboard may
still be active because no disconnect command was sent. Later, software
handling is re-enabled. If a multi-byte scancode sent from the keyboard
straddles the re-enable, only the latter byte(s) will be handled.

In practice, this leads to cases where multi-byte break codes (ex. "e0
4d" - break code for right-arrow) are misread as make codes ("4d" - make
code for numeric 6), leading to one or more unwanted, untyped characters
being interpreted.

The solution implemented here involves sending command f5 (reset
disable) to the keyboard prior to disabling software handling of codes.
Later, the command to re-enable the keyboard is sent only after we are
prepared to handle scancodes.

Signed-off-by: Shawn Nematbakhsh <shawnn@chromium.org>
---
Changes since v1:
- Removed unused return values from atkbd_deactivate.

 drivers/input/keyboard/atkbd.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index add5ffd..44dcf83 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -844,6 +844,20 @@ static int atkbd_activate(struct atkbd *atkbd)
 }
 
 /*
+ * atkbd_deactivate() resets and disables the keyboard from sending
+ * keystrokes.
+ */
+static void atkbd_deactivate(struct atkbd *atkbd)
+{
+	struct ps2dev *ps2dev = &atkbd->ps2dev;
+
+	if (ps2_command(ps2dev, NULL, ATKBD_CMD_RESET_DIS))
+		dev_err(&ps2dev->serio->dev,
+			"Failed to deactivate keyboard on %s\n",
+			ps2dev->serio->phys);
+}
+
+/*
  * atkbd_cleanup() restores the keyboard state so that BIOS is happy after a
  * reboot.
  */
@@ -1199,6 +1213,9 @@ static int atkbd_reconnect(struct serio *serio)
 
 	mutex_lock(&atkbd->mutex);
 
+	if (atkbd->write)
+		atkbd_deactivate(atkbd);
+
 	atkbd_disable(atkbd);
 
 	if (atkbd->write) {
@@ -1208,8 +1225,6 @@ static int atkbd_reconnect(struct serio *serio)
 		if (atkbd->set != atkbd_select_set(atkbd, atkbd->set, atkbd->extra))
 			goto out;
 
-		atkbd_activate(atkbd);
-
 		/*
 		 * Restore LED state and repeat rate. While input core
 		 * will do this for us at resume time reconnect may happen
@@ -1224,6 +1239,9 @@ static int atkbd_reconnect(struct serio *serio)
 	}
 
 	atkbd_enable(atkbd);
+	if (atkbd->write)
+		atkbd_activate(atkbd);
+
 	retval = 0;
 
  out:
-- 
1.7.7.3

