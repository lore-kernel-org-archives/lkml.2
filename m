Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2IKHkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 03:40:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52834 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2IKHk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 03:40:29 -0400
From: Prabhakar Lad <prabhakar.lad@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>, <linux-doc@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Landley <rob@landley.net>
Subject: [PATCH v2] media: v4l2-ctrl: add a helper function to modify the menu
Date: Tue, 11 Sep 2012 13:09:02 +0530
Message-ID: <1347349142-2230-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

Add a helper function to modify the menu, max and default value
to set.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Rob Landley <rob@landley.net>
---
Changes for v2:
1: Fixed review comments from Hans, to have return type as
   void, add WARN_ON() for fail conditions, allow this fucntion
   to modify the menu of custom controls.

 Documentation/video4linux/v4l2-controls.txt |   30 +++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c        |   17 +++++++++++++++
 include/media/v4l2-ctrls.h                  |   11 +++++++++
 3 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index 43da22b..160368a 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -367,6 +367,36 @@ it to 0 means that all menu items are supported.
 You set this mask either through the v4l2_ctrl_config struct for a custom
 control, or by calling v4l2_ctrl_new_std_menu().
 
+Changing the menu:
+There are situations when menu items may be device specific, in such cases the
+framework provides the helper function to change the menu.
+
+void v4l2_ctrl_modify_menu(struct v4l2_ctrl *ctrl, const char * const *qmenu,
+	s32 max, u32 menu_skip_mask, s32 def);
+
+A good example is the test pattern generation, the capture/display/sensors have
+the capability to generate test patterns. This test patterns are hardware
+specific, In such case the menu will vary from device to device.
+
+This helper, function is used to modify the menu, max, mask and the default
+value to set.
+
+Example for usage:
+	static const char * const test_pattern[] = {
+		"Disabled",
+		"Vertical Bars",
+		"Vertical Bars",
+		"Solid Black",
+		"Solid White",
+		NULL
+	};
+	struct v4l2_ctrl *test_pattern_ctrl =
+		v4l2_ctrl_new_std_menu(&foo->ctrl_handler, &foo_ctrl_ops,
+			V4L2_CID_TEST_PATTERN, V4L2_TEST_PATTERN_DISABLED, 0,
+			V4L2_TEST_PATTERN_DISABLED);
+
+	v4l2_ctrl_modify_menu(test_pattern_ctrl, test_pattern, 5, 0x3, 1);
+
 
 Custom Controls
 ===============
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index d731422..d89b460 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2666,3 +2666,20 @@ unsigned int v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait)
 	return 0;
 }
 EXPORT_SYMBOL(v4l2_ctrl_poll);
+
+/* Helper function for modifying the menu */
+void v4l2_ctrl_modify_menu(struct v4l2_ctrl *ctrl, const char * const *qmenu,
+			   s32 max, u32 menu_skip_mask, s32 def)
+{
+	if (WARN_ON(ctrl->type != V4L2_CTRL_TYPE_MENU || qmenu == NULL))
+		return;
+
+	if (WARN_ON(def < 0 || def > max))
+		return;
+
+	ctrl->qmenu = qmenu;
+	ctrl->maximum = max;
+	ctrl->menu_skip_mask = menu_skip_mask;
+	ctrl->cur.val = ctrl->val = ctrl->default_value = def;
+}
+EXPORT_SYMBOL(v4l2_ctrl_modify_menu);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 776605f..0c91b4e 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -488,6 +488,17 @@ static inline void v4l2_ctrl_unlock(struct v4l2_ctrl *ctrl)
 	mutex_unlock(ctrl->handler->lock);
 }
 
+/**
+ * v4l2_ctrl_modify_menu() - This function is used to modify the menu.
+ * @ctrl:		The control of which menu should be changed.
+ * @qmenu:		The new menu to which control will point to.
+ * @max:		Maximum value of the control.
+ * @menu_skip_mask:	The control's skip mask for menu controls.
+ * @def:		The default value for control to be set.
+ */
+void v4l2_ctrl_modify_menu(struct v4l2_ctrl *ctrl, const char * const *qmenu,
+			   s32 max, u32 menu_skip_mask, s32 def);
+
 /** v4l2_ctrl_g_ctrl() - Helper function to get the control's value from within a driver.
   * @ctrl:	The control.
   *
-- 
1.7.0.4

