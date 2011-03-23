Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1CWBET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 21:04:19 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59781 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab1CWBEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 21:04:16 -0400
From: Jeff Brown <jeffbrown@android.com>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jeff Brown <jeffbrown@google.com>,
        jeffbrown@android.com
Subject: [PATCH 1/4] input: Set default events per packet.
Date: Tue, 22 Mar 2011 18:04:01 -0700
Message-Id: <1300842244-42723-2-git-send-email-jeffbrown@android.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1300842244-42723-1-git-send-email-jeffbrown@android.com>
References: <1300842244-42723-1-git-send-email-jeffbrown@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Brown <jeffbrown@google.com>

Calculate a default based on the number of ABS axes, REL axes,
and MT slots for the device during input device registration.

Signed-off-by: jeffbrown@android.com
---
 drivers/input/input.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index d6e8bd8..c27292b 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1746,6 +1746,49 @@ void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int
 }
 EXPORT_SYMBOL(input_set_capability);
 
+static inline bool is_mt_axis(int axis)
+{
+	return axis == ABS_MT_SLOT ||
+		(axis >= ABS_MT_FIRST && axis <= ABS_MT_LAST);
+}
+
+static void input_set_default_events_per_packet(struct input_dev *dev)
+{
+	int mt_slots;
+	int i;
+	int events;
+
+	if (dev->hint_events_per_packet)
+		return;
+
+	if (dev->mtsize)
+		mt_slots = dev->mtsize;
+	else if (test_bit(ABS_MT_TRACKING_ID, dev->absbit))
+		mt_slots = dev->absinfo[ABS_MT_TRACKING_ID].maximum -
+			dev->absinfo[ABS_MT_TRACKING_ID].minimum + 1;
+	else if (test_bit(ABS_MT_POSITION_X, dev->absbit))
+		mt_slots = 2;
+	else
+		mt_slots = 0;
+
+	events = mt_slots + 1; /* count SYN_MT_REPORT and SYN_REPORT */
+
+	for (i = 0; i < ABS_CNT; i++) {
+		if (test_bit(i, dev->absbit)) {
+			if (is_mt_axis(i))
+				events += mt_slots;
+			else
+				events++;
+		}
+	}
+
+	for (i = 0; i < REL_CNT; i++)
+		if (test_bit(i, dev->relbit))
+			events++;
+
+	input_set_events_per_packet(dev, events);
+}
+
 #define INPUT_CLEANSE_BITMASK(dev, type, bits)				\
 	do {								\
 		if (!test_bit(EV_##type, dev->evbit))			\
@@ -1784,6 +1827,9 @@ int input_register_device(struct input_dev *dev)
 	const char *path;
 	int error;
 
+	/* Use a larger default input buffer for MT devices */
+	input_set_default_events_per_packet(dev);
+
 	/* Every input device generates EV_SYN/SYN_REPORT events. */
 	__set_bit(EV_SYN, dev->evbit);
 
-- 
1.7.0.4

