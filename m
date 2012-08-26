Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab2HZMxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 08:53:49 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:47386 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab2HZMxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 08:53:46 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApRZALMbOlBV5qoUPGdsb2JhbABFhRqFI7AtGQEBAQEeGQ0ngiEBBScvEwEPEAhJOQoUBgESiBG7SRSSBQObQI0P
X-IronPort-AV: E=Sophos;i="4.77,830,1336341600"; 
   d="scan'208";a="180869248"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 12/20] Input: MT - Add slot assignment by id
Date: Sun, 26 Aug 2012 14:57:30 +0200
Message-Id: <1345985858-445-13-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1345985858-445-1-git-send-email-rydberg@euromail.se>
References: <1345985858-445-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers produce their own tracking ids, which needs to be mapped
to slots. This patch provides that function.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input-mt.c | 30 ++++++++++++++++++++++++++++++
 include/linux/input/mt.h |  2 ++
 2 files changed, 32 insertions(+)

diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index effea9b..a485014 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -383,3 +383,33 @@ int input_mt_assign_slots(struct input_dev *dev, int *slots,
 	return 0;
 }
 EXPORT_SYMBOL(input_mt_assign_slots);
+
+/**
+ * input_mt_assign_slot_by_id() - return matching slot
+ * @dev: input device with allocated MT slots
+ * @id: the sought tracking id
+ *
+ * Returns the slot of the given tracking id, if it exists. Otherwise,
+ * the first unused slot is returned.
+ *
+ * If no available slot can be found, -1 is returned.
+ */
+int input_mt_assign_slot_by_id(struct input_dev *dev, int id)
+{
+	struct input_mt *mt = dev->mt;
+	struct input_mt_slot *s;
+
+	if (!mt)
+		return -1;
+
+	for (s = mt->slots; s != mt->slots + mt->num_slots; s++)
+		if (input_mt_get_value(s, ABS_MT_TRACKING_ID) == id)
+			return s - mt->slots;
+
+	for (s = mt->slots; s != mt->slots + mt->num_slots; s++)
+		if (!input_mt_is_active(s))
+			return s - mt->slots;
+
+	return -1;
+}
+EXPORT_SYMBOL(input_mt_assign_slot_by_id);
diff --git a/include/linux/input/mt.h b/include/linux/input/mt.h
index 10bb77c..54b640b 100644
--- a/include/linux/input/mt.h
+++ b/include/linux/input/mt.h
@@ -109,4 +109,6 @@ struct input_mt_pos {
 int input_mt_assign_slots(struct input_dev *dev, int *slots,
 			  const struct input_mt_pos *pos, int num_pos);
 
+int input_mt_assign_slot_by_id(struct input_dev *dev, int id);
+
 #endif
-- 
1.7.12

