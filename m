Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3AFJKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 04:10:37 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:61700 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab3AFJKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 04:10:31 -0500
Date: Sun, 6 Jan 2013 01:10:26 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Shawn Nematbakhsh <shawnn@chromium.org>
Cc: jj@chaosbits.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] atkbd: Fix multi-char scancode handling on reconnect.
Message-ID: <20130106091026.GA17618@core.coreip.homeip.net>
References: <1356057191-24664-1-git-send-email-shawnn@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356057191-24664-1-git-send-email-shawnn@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

On Thu, Dec 20, 2012 at 06:33:11PM -0800, Shawn Nematbakhsh wrote:
> On resume from suspend there is a possibility for multi-byte scancodes
> to be handled incorrectly. atkbd_reconnect disables the processing of
> scancodes in software by calling atkbd_disable, but the keyboard may
> still be active because no disconnect command was sent. Later, software
> handling is re-enabled. If a multi-byte scancode sent from the keyboard
> straddles the re-enable, only the latter byte(s) will be handled.
> 
> In practice, this leads to cases where multi-byte break codes (ex. "e0
> 4d" - break code for right-arrow) are misread as make codes ("4d" - make
> code for numeric 6), leading to one or more unwanted, untyped characters
> being interpreted.
> 
> The solution implemented here involves sending command f5 (reset
> disable) to the keyboard prior to disabling software handling of codes.
> Later, the command to re-enable the keyboard is sent only after we are
> prepared to handle scancodes.

The core tries to avoid disturbing devices that are not keyboards, so I
believe we should check the device ID first and if it is keyboard, then
do the reset. We should also reset the internal state (emul and xl_bit)
when re-enabling the device.

Does the version of the patch below work for you?

Thanks.

-- 
Dmitry

Input: atkbd - fix multi-byte scancode handling on reconnect

From: Shawn Nematbakhsh <shawnn@chromium.org>

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
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/keyboard/atkbd.c |   72 ++++++++++++++++++++++++++++------------
 1 file changed, 51 insertions(+), 21 deletions(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 33d0fcd..2626773 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -676,6 +676,39 @@ static inline void atkbd_disable(struct atkbd *atkbd)
 	serio_continue_rx(atkbd->ps2dev.serio);
 }
 
+static int atkbd_activate(struct atkbd *atkbd)
+{
+	struct ps2dev *ps2dev = &atkbd->ps2dev;
+
+/*
+ * Enable the keyboard to receive keystrokes.
+ */
+
+	if (ps2_command(ps2dev, NULL, ATKBD_CMD_ENABLE)) {
+		dev_err(&ps2dev->serio->dev,
+			"Failed to enable keyboard on %s\n",
+			ps2dev->serio->phys);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * atkbd_deactivate() resets and disables the keyboard from sending
+ * keystrokes.
+ */
+
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
 /*
  * atkbd_probe() probes for an AT keyboard on a serio port.
  */
@@ -731,6 +764,12 @@ static int atkbd_probe(struct atkbd *atkbd)
 		return -1;
 	}
 
+/*
+ * Make sure nothing is coming from the keyboard and disturbs our
+ * internal state.
+ */
+	atkbd_deactivate(atkbd);
+
 	return 0;
 }
 
@@ -825,24 +864,6 @@ static int atkbd_reset_state(struct atkbd *atkbd)
 	return 0;
 }
 
-static int atkbd_activate(struct atkbd *atkbd)
-{
-	struct ps2dev *ps2dev = &atkbd->ps2dev;
-
-/*
- * Enable the keyboard to receive keystrokes.
- */
-
-	if (ps2_command(ps2dev, NULL, ATKBD_CMD_ENABLE)) {
-		dev_err(&ps2dev->serio->dev,
-			"Failed to enable keyboard on %s\n",
-			ps2dev->serio->phys);
-		return -1;
-	}
-
-	return 0;
-}
-
 /*
  * atkbd_cleanup() restores the keyboard state so that BIOS is happy after a
  * reboot.
@@ -1150,7 +1171,6 @@ static int atkbd_connect(struct serio *serio, struct serio_driver *drv)
 
 		atkbd->set = atkbd_select_set(atkbd, atkbd_set, atkbd_extra);
 		atkbd_reset_state(atkbd);
-		atkbd_activate(atkbd);
 
 	} else {
 		atkbd->set = 2;
@@ -1165,6 +1185,8 @@ static int atkbd_connect(struct serio *serio, struct serio_driver *drv)
 		goto fail3;
 
 	atkbd_enable(atkbd);
+	if (serio->write)
+		atkbd_activate(atkbd);
 
 	err = input_register_device(atkbd->dev);
 	if (err)
@@ -1208,8 +1230,6 @@ static int atkbd_reconnect(struct serio *serio)
 		if (atkbd->set != atkbd_select_set(atkbd, atkbd->set, atkbd->extra))
 			goto out;
 
-		atkbd_activate(atkbd);
-
 		/*
 		 * Restore LED state and repeat rate. While input core
 		 * will do this for us at resume time reconnect may happen
@@ -1223,7 +1243,17 @@ static int atkbd_reconnect(struct serio *serio)
 
 	}
 
+	/*
+	 * Reset our state machine in case reconnect happened in the middle
+	 * of multi-byte scancode.
+	 */
+	atkbd->xl_bit = 0;
+	atkbd->emul = 0;
+
 	atkbd_enable(atkbd);
+	if (atkbd->write)
+		atkbd_activate(atkbd);
+
 	retval = 0;
 
  out:
