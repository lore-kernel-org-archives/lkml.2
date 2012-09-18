Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab2IRSzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:55:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42588 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2IRSzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:55:07 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org, "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Landley <rob@landley.net>
Subject: [PATCH v4] media: v4l2-ctrl: add a helper function to add standard control with driver specific menu
Date: Wed, 19 Sep 2012 00:24:38 +0530
Message-Id: <1347994478-31784-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

Add helper function v4l2_ctrl_new_std_menu_items(), which adds
a standard menu control, with driver specific menu.

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
Changes for v4:
1: Rather then adding a function to modify the menu, added a helper
   function, that creates a new standard control with user specific
   menu.

Changes for v3:
1: Fixed style/grammer issues as pointed by Hans.
   Thanks Hans for providing the description.

Changes for v2:
1: Fixed review comments from Hans, to have return type as
   void, add WARN_ON() for fail conditions, allow this fucntion
   to modify the menu of custom controls.

 Documentation/video4linux/v4l2-controls.txt |   25 ++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c        |   28 +++++++++++++++++++++++++++
 include/media/v4l2-ctrls.h                  |   23 ++++++++++++++++++++++
 3 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index 43da22b..ad8e172 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -136,11 +136,25 @@ Or alternatively for integer menu controls, by calling v4l2_ctrl_new_int_menu:
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, s32 max, s32 def, const s64 *qmenu_int);
 
+Standard menu controls with driver specific menu are added by calling
+v4l2_ctrl_new_std_menu_items:
+
+	struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(
+		struct v4l2_ctrl_handler *hdl,
+		const struct v4l2_ctrl_ops *ops, u32 id, s32 max,
+		s32 skip_mask, s32 def, const char * const *qmenu_user);
+
 These functions are typically called right after the v4l2_ctrl_handler_init:
 
 	static const s64 exp_bias_qmenu[] = {
 	       -2, -1, 0, 1, 2
 	};
+	static const char * const test_pattern[] = {
+		"Disabled",
+		"Vertical Bars",
+		"Solid Black",
+		"Solid White",
+	};
 
 	v4l2_ctrl_handler_init(&foo->ctrl_handler, nr_of_controls);
 	v4l2_ctrl_new_std(&foo->ctrl_handler, &foo_ctrl_ops,
@@ -156,6 +170,9 @@ These functions are typically called right after the v4l2_ctrl_handler_init:
 			ARRAY_SIZE(exp_bias_qmenu) - 1,
 			ARRAY_SIZE(exp_bias_qmenu) / 2 - 1,
 			exp_bias_qmenu);
+	v4l2_ctrl_new_std_menu_items(&foo->ctrl_handler, &foo_ctrl_ops,
+			V4L2_CID_TEST_PATTERN, ARRAY_SIZE(test_pattern) - 1, 0,
+			0, test_pattern);
 	...
 	if (foo->ctrl_handler.error) {
 		int err = foo->ctrl_handler.error;
@@ -185,6 +202,14 @@ v4l2_ctrl_new_std_menu in that it doesn't have the mask argument and takes
 as the last argument an array of signed 64-bit integers that form an exact
 menu item list.
 
+The v4l2_ctrl_new_std_menu_items funtion is very similar as
+v4l2_ctrl_new_std_menu but takes a extra parameter qmenu_user, which is
+driver specific menu but yet a standard menu control.
+A good example for this control is the test pattern control for
+capture/display/sensors devices that have the capability to generate test
+patterns. These test patterns are hardware specific, so the contents of the
+menu will vary from device to device.
+
 Note that if something fails, the function will return NULL or an error and
 set ctrl_handler->error to the error code. If ctrl_handler->error was already
 set, then it will just return and do nothing. This is also true for
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index d731422..9ac1b75 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1649,6 +1649,34 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_std_menu);
 
+/* Helper function for standard menu controls with user defined menu */
+struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(struct v4l2_ctrl_handler *hdl,
+			const struct v4l2_ctrl_ops *ops, u32 id, s32 max,
+			s32 mask, s32 def, const char * const *qmenu_user)
+{
+	const char * const *qmenu = v4l2_ctrl_get_menu(id);
+	const char *name;
+	enum v4l2_ctrl_type type;
+	s32 min;
+	s32 step;
+	u32 flags;
+
+	if (!qmenu) {
+		handler_set_err(hdl, -EINVAL);
+		return NULL;
+	}
+
+	v4l2_ctrl_fill(id, &name, &type, &min, &max, &step, &def, &flags);
+	if (type != V4L2_CTRL_TYPE_MENU) {
+		handler_set_err(hdl, -EINVAL);
+		return NULL;
+	}
+	return v4l2_ctrl_new(hdl, ops, id, name, type,
+			     0, max, mask, def, flags, qmenu_user, NULL, NULL);
+
+}
+EXPORT_SYMBOL(v4l2_ctrl_new_std_menu_items);
+
 /* Helper function for standard integer menu controls */
 struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 776605f..e0dd392 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -351,6 +351,29 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, s32 max, s32 mask, s32 def);
 
+/** v4l2_ctrl_new_std_menu_items() - Create a new standard V4L2 menu control
+  * with driver specific menu.
+  * @hdl:	The control handler.
+  * @ops:	The control ops.
+  * @id:	The control ID.
+  * @max:	The control's maximum value.
+  * @mask:	The control's skip mask for menu controls. This makes it
+  *		easy to skip menu items that are not valid. If bit X is set,
+  *		then menu item X is skipped. Of course, this only works for
+  *		menus with <= 32 menu items. There are no menus that come
+  *		close to that number, so this is OK. Should we ever need more,
+  *		then this will have to be extended to a u64 or a bit array.
+  * @def:	The control's default value.
+  * @qmenu_user:The new menu.
+  *
+  * Same as v4l2_ctrl_new_std_menu().but @qmenu_user will be the menu to
+  * which the control will be pointing to.
+  *
+  */
+struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(struct v4l2_ctrl_handler *hdl,
+			const struct v4l2_ctrl_ops *ops, u32 id, s32 max,
+			s32 mask, s32 def, const char * const *qmenu_user);
+
 /** v4l2_ctrl_new_int_menu() - Create a new standard V4L2 integer menu control.
   * @hdl:	The control handler.
   * @ops:	The control ops.
-- 
1.7.0.4

