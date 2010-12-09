Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab0LIXTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:19:22 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:39386 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754392Ab0LIXTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:19:20 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: mt: Identify pointer emulation contact
Date: Fri, 10 Dec 2010 00:19:05 +0100
Message-Id: <1291936745-4973-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PQplY-0001Bw-7b.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PQplY-0001Bw-7b 2122fc303cfc9691ecc69f7a275927c2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For MT applications, the tracking id provides a robust way to know
when a touch is new; essential information to determine when _not_ to
emit motion events, for instance.  Currently, ST applications do not
have the equivalent information, but instead rely on global properties
such as a change in number of fingers. Moreover, some MT applications
need to know which contact correponds to the pointer. This patch adds
the ABS_TRACKING_ID axis and emits it in
input_mt_report_pointer_emulation(), provided the proper absbit is
setup by the driver.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input-mt.c |    4 +++-
 include/linux/input.h    |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index afaf059..bcd2c22 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -105,7 +105,8 @@ EXPORT_SYMBOL(input_mt_report_slot_state);
  * @dev: input device with allocated MT slots
  *
  * Performs legacy pointer emulation via BTN_TOUCH, ABS_X, ABS_Y and
- * ABS_PRESSURE. Touchpad finger count is emulated using
+ * ABS_PRESSURE. If enabled, ABS_TRACKING_ID is emitted whenever the
+ * pointer contact changes. Touchpad finger count is emulated using
  * BTN_TOOL_FINGER, BTN_TOOL_DOUBLETAP, BTN_TOOL_TRIPLETAP and
  * BTN_TOOL_QUADTAP.
  *
@@ -146,6 +147,7 @@ void input_mt_report_pointer_emulation(struct input_dev *dev)
 		input_event(dev, EV_ABS, ABS_X, x);
 		input_event(dev, EV_ABS, ABS_Y, y);
 		input_event(dev, EV_ABS, ABS_PRESSURE, p);
+		input_event(dev, EV_ABS, ABS_TRACKING_ID, oldid);
 	} else {
 		input_event(dev, EV_ABS, ABS_PRESSURE, 0);
 	}
diff --git a/include/linux/input.h b/include/linux/input.h
index 65f7799..01dde9b 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -716,6 +716,7 @@ struct input_keymap_entry {
 #define ABS_TILT_X		0x1a
 #define ABS_TILT_Y		0x1b
 #define ABS_TOOL_WIDTH		0x1c
+#define ABS_TRACKING_ID		0x1d	/* ID of contact governing ABS_{X,Y} */
 
 #define ABS_VOLUME		0x20
 
-- 
1.7.1

