Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0EYLy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 07:54:59 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:42965 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754377Ab0EYLy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 07:54:57 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/2] input: mt: Add method to extract the MT slot state
Date: Tue, 25 May 2010 13:52:58 +0200
Message-Id: <1274788379-11026-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1274788379-11026-1-git-send-email-rydberg@euromail.se>
References: <1274788379-11026-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OGsh9-0000Ze-BQ.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1OGsh9-0000Ze-BQ 94a5a1a5f9a482975f51f8eac96f9886
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the function input_mt_get_abs_value(), which may be
used to extract the current state of the MT slots.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input.c |   31 +++++++++++++++++++++++++++++++
 include/linux/input.h |    2 ++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 9b6d474..24d1105 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -659,6 +659,37 @@ static int input_default_setkeycode(struct input_dev *dev,
 }
 
 /**
+ * input_mt_get_abs_value - retrieve MT state variables from a device slot
+ * @dev: input device which state is being queried
+ * @code: ABS code to retrieve
+ * @slot: slot to retrieve from
+ *
+ * Return the ABS state of the given MT slot. If code is not an MT
+ * event, the corresponding ABS event is returned.
+ *
+ * This function may be called by anyone interested in extracting the
+ * current MT state. Used by evdev handlers.
+ */
+int input_mt_get_abs_value(struct input_dev *dev, unsigned int code, int slot)
+{
+	unsigned int mtmap = input_mt_abs_map[code];
+	unsigned long flags;
+	int retval;
+
+	spin_lock_irqsave(&dev->event_lock, flags);
+	if (!mtmap)
+		retval = dev->abs[code];
+	else if (slot >= 0 && slot < dev->mtsize)
+		retval = dev->mt[slot].abs[mtmap - 1];
+	else
+		retval = 0;
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+
+	return retval;
+}
+EXPORT_SYMBOL(input_mt_get_abs_value);
+
+/**
  * input_get_keycode - retrieve keycode currently mapped to a given scancode
  * @dev: input device which keymap is being queried
  * @scancode: scancode (or its equivalent for device in question) for which
diff --git a/include/linux/input.h b/include/linux/input.h
index bea6958..03727d6 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1436,6 +1436,8 @@ static inline void input_mt_slot(struct input_dev *dev, int slot)
 	input_event(dev, EV_ABS, ABS_MT_SLOT, slot);
 }
 
+int input_mt_get_abs_value(struct input_dev *dev, unsigned int code, int slot);
+
 void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int code);
 
 static inline void input_set_abs_params(struct input_dev *dev, int axis, int min, int max, int fuzz, int flat)
-- 
1.6.3.3

