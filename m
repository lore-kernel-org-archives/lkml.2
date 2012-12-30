Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab2L3TD2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 14:03:28 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:36522 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab2L3TDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 14:03:24 -0500
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Dec 2012 14:03:24 EST
From: Alexander Lam <lambchop468@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>, Durgadoss R <durgadoss.r@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Lam <lambchop468@gmail.com>
Subject: [PATCH 1/1] thermal: Check cooling device's current state before declaring it inactive
Date: Sun, 30 Dec 2012 13:57:36 -0500
Message-Id: <1356893856-26249-1-git-send-email-lambchop468@gmail.com>
X-Mailer: git-send-email 1.8.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible for a cooling device to become active in between calls to
the thermal governor. An example of this is the acerhdf driver, which
can hand control of the cooling device over to the system firmware. Upon
returning control back to the thermal system, the cooling device might
be running again, so checking the current state of the cooling device is
required.

Signed-off-by: Alexander Lam <lambchop468@gmail.com>
---
 drivers/thermal/step_wise.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
index 0cd5e9f..0eeb709 100644
--- a/drivers/thermal/step_wise.c
+++ b/drivers/thermal/step_wise.c
@@ -94,16 +94,21 @@ static void update_instance_for_dethrottle(struct thermal_zone_device *tz,
 	unsigned long cur_state;
 
 	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
-		if (instance->trip != trip ||
-			instance->target == THERMAL_NO_TARGET)
+		if (instance->trip != trip)
 			continue;
 
 		cdev = instance->cdev;
 		cdev->ops->get_cur_state(cdev, &cur_state);
 
-		instance->target = cur_state > instance->lower ?
+		cur_state = cur_state > instance->lower ?
 			    (cur_state - 1) : THERMAL_NO_TARGET;
 
+		if (cur_state == THERMAL_NO_TARGET &&
+					instance->target == THERMAL_NO_TARGET)
+			continue;
+
+		instance->target = cur_state;
+
 		/* Deactivate a passive thermal instance */
 		if (instance->target == THERMAL_NO_TARGET)
 			update_passive_instance(tz, trip_type, -1);
-- 
1.8.0.2

