Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab2IUTSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:18:30 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:48816 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673Ab2IUTS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:18:28 -0400
From: Yufeng Shen <miletus@chromium.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Benson Leung <bleung@chromium.org>
Subject: [RFC/PATCH] Input: release MT fingers on device reset/disconnect
Date: Fri, 21 Sep 2012 15:18:25 -0400
Message-Id: <1348255105-24558-1-git-send-email-miletus@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are already releasing all pressed keys on device reset and
disconnect. This patch adds the finger release for multi-touch
device.

Different than the key release logic that only the pressed keys
are released, here all the possible fingers are released even
it is not recorded as touched down in the input_dev's internal
state. The motivation is that while releasing an alreay released
finger won't do harm to downstream, it is helpful in the case
when the downstream is out of sync with input_dev's internal
state, we are bringing them back to in sync by cleaning up both
input_dev and downstream's finger states.

Signed-off-by: Yufeng Shen <miletus@chromium.org>
---
 drivers/input/input.c |   34 ++++++++++++++++++++++++++++++++--
 1 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 768e46b..ebdc450 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -584,6 +584,34 @@ void input_close_device(struct input_handle *handle)
 EXPORT_SYMBOL(input_close_device);
 
 /*
+ * Simulate finger release events for all possible fingers. It has no harm
+ * to release an alreay released finger, but has the benefit that if the
+ * downstream finger states are out of sync with input_dev's finger states,
+ * we are helping to clean them up.
+ * The function must be called with dev->event_lock held.
+ */
+static void input_dev_release_mt(struct input_dev *dev)
+{
+	int i;
+
+	if (!dev->mt)
+		return;
+
+	if (!is_event_supported(EV_ABS, dev->evbit, EV_MAX) ||
+	    !is_event_supported(ABS_MT_SLOT, dev->absbit, ABS_MAX) ||
+	    !is_event_supported(ABS_MT_TRACKING_ID, dev->absbit, ABS_MAX))
+		return;
+
+	for (i = 0; i < dev->mtsize; i++) {
+		input_mt_set_value(&dev->mt[i], ABS_MT_TRACKING_ID, -1);
+		input_pass_event(dev, EV_ABS, ABS_MT_SLOT, i);
+		input_pass_event(dev, EV_ABS, ABS_MT_TRACKING_ID, -1);
+	}
+
+	input_pass_event(dev, EV_SYN, SYN_REPORT, 1);
+}
+
+/*
  * Simulate keyup events for all keys that are marked as pressed.
  * The function must be called with dev->event_lock held.
  */
@@ -627,6 +655,7 @@ static void input_disconnect_device(struct input_dev *dev)
 	 * reach any handlers.
 	 */
 	input_dev_release_keys(dev);
+	input_dev_release_mt(dev);
 
 	list_for_each_entry(handle, &dev->h_list, d_node)
 		handle->open = 0;
@@ -1569,7 +1598,7 @@ static void input_dev_toggle(struct input_dev *dev, bool activate)
  * @dev: input device whose state needs to be reset
  *
  * This function tries to reset the state of an opened input device and
- * bring internal state and state if the hardware in sync with each other.
+ * bring internal state and state of the hardware in sync with each other.
  * We mark all keys as released, restore LED state, repeat rate, etc.
  */
 void input_reset_device(struct input_dev *dev)
@@ -1581,10 +1610,11 @@ void input_reset_device(struct input_dev *dev)
 
 		/*
 		 * Keys that have been pressed at suspend time are unlikely
-		 * to be still pressed when we resume.
+		 * to be still pressed when we resume. Same logic for MT.
 		 */
 		spin_lock_irq(&dev->event_lock);
 		input_dev_release_keys(dev);
+		input_dev_release_mt(dev);
 		spin_unlock_irq(&dev->event_lock);
 	}
 
-- 
1.7.7.3

