Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab2HLVku (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 17:40:50 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:52510 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab2HLVju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 17:39:50 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap1OAA8iKFBV5qoUPGdsb2JhbABEhRiFI68/GQEBAQE3NIIhAQUnLxMBDxAISTkKFAYBEogRtjoUkS8DmzaNBg
X-IronPort-AV: E=Sophos;i="4.77,756,1336341600"; 
   d="scan'208";a="173154354"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 11/19] Input: MT - Add slot assignment by id
Date: Sun, 12 Aug 2012 23:42:29 +0200
Message-Id: <1344807757-2217-12-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
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
index 36c93d7..1f3e110 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -387,3 +387,33 @@ int input_mt_assign_slots(struct input_dev *dev, int *slots,
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
1.7.11.4

