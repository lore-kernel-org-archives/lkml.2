Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1A0Kf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:35:58 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:33431 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab1A0Kf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:35:57 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Ping Cheng <pingc@wacom.com>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Chris Bagwell <chris@cnpbagwell.com>,
        Rafi Rubin <rafi@seas.upenn.edu>, Stephane Chatty <chatty@lii-enac.fr>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 1/2] input: mt: Add method to extract the MT slot state
Date: Thu, 27 Jan 2011 11:35:46 +0100
Message-Id: <1296124547-3323-2-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296124547-3323-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1296124547-3323-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the function input_mt_get_abs_value(), which may be
used to extract the current state of the MT slots.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/input/input-mt.c |   32 ++++++++++++++++++++++++++++++++
 include/linux/input/mt.h |    1 +
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index c48c81f..5b95e38 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -168,3 +168,35 @@ void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count)
 	}
 }
 EXPORT_SYMBOL(input_mt_report_pointer_emulation);
+
+/**
+ * input_mt_get_absinfo - retrieve MT state variables from a device slot
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
+struct input_absinfo input_mt_get_absinfo(struct input_dev *dev, unsigned int code, int slot)
+{
+	unsigned int mtmap = code > ABS_MT_FIRST ? code - ABS_MT_FIRST : 0;
+	unsigned long flags;
+	struct input_absinfo retval;
+
+	spin_lock_irqsave(&dev->event_lock, flags);
+	if (!mtmap)
+		retval = dev->absinfo[code];
+	else if (slot >= 0 && slot < dev->mtsize) {
+		retval = dev->absinfo[code];
+		retval.value = dev->mt[slot].abs[mtmap];
+	} else
+		retval.value = 0;
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+
+	return retval;
+}
+EXPORT_SYMBOL(input_mt_get_absinfo);
diff --git a/include/linux/input/mt.h b/include/linux/input/mt.h
index b3ac06a..a71a27f 100644
--- a/include/linux/input/mt.h
+++ b/include/linux/input/mt.h
@@ -54,4 +54,5 @@ void input_mt_report_slot_state(struct input_dev *dev,
 void input_mt_report_finger_count(struct input_dev *dev, int count);
 void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count);
 
+struct input_absinfo input_mt_get_absinfo(struct input_dev *dev, unsigned int code, int slot);
 #endif
-- 
1.7.3.4

