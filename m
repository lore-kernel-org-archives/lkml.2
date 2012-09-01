Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab2IATpT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 15:45:19 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:36952 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab2IATmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 15:42:39 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnxPAG1kQlBV5qoUPGdsb2JhbABEhRyFI7BfGQEBAQEeGQ0ngiEBBScvEwEPEAhJOQoUBgESiBG6NxSSHAObR40R
X-IronPort-AV: E=Sophos;i="4.80,353,1344204000"; 
   d="scan'208";a="401145340"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH v3 10/20] Input: MT - Get slot by key
Date: Sat,  1 Sep 2012 21:47:05 +0200
Message-Id: <1346528835-363-11-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346528835-363-1-git-send-email-rydberg@euromail.se>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices use an internal key for tracking which cannot be directly
mapped to slots. This patch provides a key-to-slot mapping, which can
be used by drivers of such devices.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input-mt.c | 32 ++++++++++++++++++++++++++++++++
 include/linux/input/mt.h |  4 ++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index 2acf693..4c0e531 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -384,3 +384,35 @@ int input_mt_assign_slots(struct input_dev *dev, int *slots,
 	return 0;
 }
 EXPORT_SYMBOL(input_mt_assign_slots);
+
+/**
+ * input_mt_get_slot_by_key() - return slot matching key
+ * @dev: input device with allocated MT slots
+ * @key: the key of the sought slot
+ *
+ * Returns the slot of the given key, if it exists, otherwise
+ * set the key on the first unused slot and return.
+ *
+ * If no available slot can be found, -1 is returned.
+ */
+int input_mt_get_slot_by_key(struct input_dev *dev, int key)
+{
+	struct input_mt *mt = dev->mt;
+	struct input_mt_slot *s;
+
+	if (!mt)
+		return -1;
+
+	for (s = mt->slots; s != mt->slots + mt->num_slots; s++)
+		if (input_mt_is_active(s) && s->key == key)
+			return s - mt->slots;
+
+	for (s = mt->slots; s != mt->slots + mt->num_slots; s++)
+		if (!input_mt_is_active(s)) {
+			s->key = key;
+			return s - mt->slots;
+		}
+
+	return -1;
+}
+EXPORT_SYMBOL(input_mt_get_slot_by_key);
diff --git a/include/linux/input/mt.h b/include/linux/input/mt.h
index 10bb77c..bbdc694 100644
--- a/include/linux/input/mt.h
+++ b/include/linux/input/mt.h
@@ -24,10 +24,12 @@
  * struct input_mt_slot - represents the state of an input MT slot
  * @abs: holds current values of ABS_MT axes for this slot
  * @frame: last frame at which input_mt_report_slot_state() was called
+ * @key: optional driver designation of this slot
  */
 struct input_mt_slot {
 	int abs[ABS_MT_LAST - ABS_MT_FIRST + 1];
 	unsigned int frame;
+	unsigned int key;
 };
 
 /**
@@ -109,4 +111,6 @@ struct input_mt_pos {
 int input_mt_assign_slots(struct input_dev *dev, int *slots,
 			  const struct input_mt_pos *pos, int num_pos);
 
+int input_mt_get_slot_by_key(struct input_dev *dev, int key);
+
 #endif
-- 
1.7.12

