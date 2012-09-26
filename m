Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2IZGfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 02:35:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42598 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab2IZGfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 02:35:32 -0400
From: Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        VGER <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [PATCH v2] media: mt9p031/mt9t001/mt9v032: use V4L2_CID_TEST_PATTERN for test pattern control
Date: Wed, 26 Sep 2012 12:05:10 +0530
Message-Id: <1348641310-11470-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Jean Delvare <khali@linux-fr.org>
---
 Changes for v2:
 1: Fixed review comments pointed by Laurent.

 drivers/media/i2c/mt9p031.c |   19 +++++--------------
 drivers/media/i2c/mt9t001.c |   23 +++++++++++++++--------
 drivers/media/i2c/mt9v032.c |   34 ++++++++++++++++++++++++----------
 3 files changed, 44 insertions(+), 32 deletions(-)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 2c0f407..e328332 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -574,7 +574,6 @@ static int mt9p031_set_crop(struct v4l2_subdev *subdev,
  * V4L2 subdev control operations
  */
 
-#define V4L2_CID_TEST_PATTERN		(V4L2_CID_USER_BASE | 0x1001)
 #define V4L2_CID_BLC_AUTO		(V4L2_CID_USER_BASE | 0x1002)
 #define V4L2_CID_BLC_TARGET_LEVEL	(V4L2_CID_USER_BASE | 0x1003)
 #define V4L2_CID_BLC_ANALOG_OFFSET	(V4L2_CID_USER_BASE | 0x1004)
@@ -740,18 +739,6 @@ static const char * const mt9p031_test_pattern_menu[] = {
 static const struct v4l2_ctrl_config mt9p031_ctrls[] = {
 	{
 		.ops		= &mt9p031_ctrl_ops,
-		.id		= V4L2_CID_TEST_PATTERN,
-		.type		= V4L2_CTRL_TYPE_MENU,
-		.name		= "Test Pattern",
-		.min		= 0,
-		.max		= ARRAY_SIZE(mt9p031_test_pattern_menu) - 1,
-		.step		= 0,
-		.def		= 0,
-		.flags		= 0,
-		.menu_skip_mask	= 0,
-		.qmenu		= mt9p031_test_pattern_menu,
-	}, {
-		.ops		= &mt9p031_ctrl_ops,
 		.id		= V4L2_CID_BLC_AUTO,
 		.type		= V4L2_CTRL_TYPE_BOOLEAN,
 		.name		= "BLC, Auto",
@@ -950,7 +937,7 @@ static int mt9p031_probe(struct i2c_client *client,
 	mt9p031->model = did->driver_data;
 	mt9p031->reset = -1;
 
-	v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 5);
+	v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 6);
 
 	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
 			  V4L2_CID_EXPOSURE, MT9P031_SHUTTER_WIDTH_MIN,
@@ -966,6 +953,10 @@ static int mt9p031_probe(struct i2c_client *client,
 	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
 			  V4L2_CID_PIXEL_RATE, pdata->target_freq,
 			  pdata->target_freq, 1, pdata->target_freq);
+	v4l2_ctrl_new_std_menu_items(&mt9p031->ctrls, &mt9p031_ctrl_ops,
+			  V4L2_CID_TEST_PATTERN,
+			  ARRAY_SIZE(mt9p031_test_pattern_menu) - 1, 0,
+			  0, mt9p031_test_pattern_menu);
 
 	for (i = 0; i < ARRAY_SIZE(mt9p031_ctrls); ++i)
 		v4l2_ctrl_new_custom(&mt9p031->ctrls, &mt9p031_ctrls[i], NULL);
diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
index 6d343ad..23f4e0a 100644
--- a/drivers/media/i2c/mt9t001.c
+++ b/drivers/media/i2c/mt9t001.c
@@ -371,7 +371,7 @@ static int mt9t001_set_crop(struct v4l2_subdev *subdev,
  * V4L2 subdev control operations
  */
 
-#define V4L2_CID_TEST_PATTERN		(V4L2_CID_USER_BASE | 0x1001)
+#define V4L2_CID_TEST_PATTERN_COLOR	(V4L2_CID_USER_BASE | 0x1001)
 #define V4L2_CID_BLACK_LEVEL_AUTO	(V4L2_CID_USER_BASE | 0x1002)
 #define V4L2_CID_BLACK_LEVEL_OFFSET	(V4L2_CID_USER_BASE | 0x1003)
 #define V4L2_CID_BLACK_LEVEL_CALIBRATE	(V4L2_CID_USER_BASE | 0x1004)
@@ -485,14 +485,12 @@ static int mt9t001_s_ctrl(struct v4l2_ctrl *ctrl)
 
 		return mt9t001_write(client, MT9T001_SHUTTER_WIDTH_HIGH,
 				     ctrl->val >> 16);
-
 	case V4L2_CID_TEST_PATTERN:
-		ret = mt9t001_set_output_control(mt9t001,
+		return mt9t001_set_output_control(mt9t001,
 			ctrl->val ? 0 : MT9T001_OUTPUT_CONTROL_TEST_DATA,
 			ctrl->val ? MT9T001_OUTPUT_CONTROL_TEST_DATA : 0);
-		if (ret < 0)
-			return ret;
 
+	case V4L2_CID_TEST_PATTERN_COLOR:
 		return mt9t001_write(client, MT9T001_TEST_DATA, ctrl->val << 2);
 
 	case V4L2_CID_BLACK_LEVEL_AUTO:
@@ -533,12 +531,17 @@ static struct v4l2_ctrl_ops mt9t001_ctrl_ops = {
 	.s_ctrl = mt9t001_s_ctrl,
 };
 
+static const char * const mt9t001_test_pattern_menu[] = {
+	"Disabled",
+	"Enabled",
+};
+
 static const struct v4l2_ctrl_config mt9t001_ctrls[] = {
 	{
 		.ops		= &mt9t001_ctrl_ops,
-		.id		= V4L2_CID_TEST_PATTERN,
+		.id		= V4L2_CID_TEST_PATTERN_COLOR,
 		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Test pattern",
+		.name		= "Test Pattern Color",
 		.min		= 0,
 		.max		= 1023,
 		.step		= 1,
@@ -741,7 +744,7 @@ static int mt9t001_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	v4l2_ctrl_handler_init(&mt9t001->ctrls, ARRAY_SIZE(mt9t001_ctrls) +
-						ARRAY_SIZE(mt9t001_gains) + 3);
+						ARRAY_SIZE(mt9t001_gains) + 4);
 
 	v4l2_ctrl_new_std(&mt9t001->ctrls, &mt9t001_ctrl_ops,
 			  V4L2_CID_EXPOSURE, MT9T001_SHUTTER_WIDTH_MIN,
@@ -752,6 +755,10 @@ static int mt9t001_probe(struct i2c_client *client,
 	v4l2_ctrl_new_std(&mt9t001->ctrls, &mt9t001_ctrl_ops,
 			  V4L2_CID_PIXEL_RATE, pdata->ext_clk, pdata->ext_clk,
 			  1, pdata->ext_clk);
+	v4l2_ctrl_new_std_menu_items(&mt9t001->ctrls, &mt9t001_ctrl_ops,
+			V4L2_CID_TEST_PATTERN,
+			ARRAY_SIZE(mt9t001_test_pattern_menu) - 1, 0,
+			0, mt9t001_test_pattern_menu);
 
 	for (i = 0; i < ARRAY_SIZE(mt9t001_ctrls); ++i)
 		v4l2_ctrl_new_custom(&mt9t001->ctrls, &mt9t001_ctrls[i], NULL);
diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index e217740..988ecce 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -500,7 +500,7 @@ static int mt9v032_set_crop(struct v4l2_subdev *subdev,
  * V4L2 subdev control operations
  */
 
-#define V4L2_CID_TEST_PATTERN		(V4L2_CID_USER_BASE | 0x1001)
+#define V4L2_CID_TEST_PATTERN_COLOR	(V4L2_CID_USER_BASE | 0x1001)
 
 static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
 {
@@ -562,13 +562,15 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
 			     | MT9V032_TEST_PATTERN_ENABLE;
 			break;
 		default:
-			data = (ctrl->val << MT9V032_TEST_PATTERN_DATA_SHIFT)
-			     | MT9V032_TEST_PATTERN_USE_DATA
-			     | MT9V032_TEST_PATTERN_ENABLE
-			     | MT9V032_TEST_PATTERN_FLIP;
+			data =  MT9V032_TEST_PATTERN_USE_DATA |
+				MT9V032_TEST_PATTERN_ENABLE |
+				MT9V032_TEST_PATTERN_FLIP;
 			break;
 		}
+		return mt9v032_write(client, MT9V032_TEST_PATTERN, data);
 
+	case V4L2_CID_TEST_PATTERN_COLOR:
+		data = ctrl->val << MT9V032_TEST_PATTERN_DATA_SHIFT;
 		return mt9v032_write(client, MT9V032_TEST_PATTERN, data);
 	}
 
@@ -579,16 +581,24 @@ static struct v4l2_ctrl_ops mt9v032_ctrl_ops = {
 	.s_ctrl = mt9v032_s_ctrl,
 };
 
+static const char * const mt9v032_test_pattern_menu[] = {
+	"Disabled",
+	"Gray Vertical Shade",
+	"Gray Horizontal Shade",
+	"Gray Diagonal Shade",
+	"Plain",
+};
+
 static const struct v4l2_ctrl_config mt9v032_ctrls[] = {
 	{
 		.ops		= &mt9v032_ctrl_ops,
-		.id		= V4L2_CID_TEST_PATTERN,
+		.id		= V4L2_CID_TEST_PATTERN_COLOR,
 		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Test pattern",
-		.min		= 0,
+		.name		= "Test Pattern Color",
+		.min		= 4,
 		.max		= 1023,
 		.step		= 1,
-		.def		= 0,
+		.def		= 4,
 		.flags		= 0,
 	}
 };
@@ -741,7 +751,7 @@ static int mt9v032_probe(struct i2c_client *client,
 	mutex_init(&mt9v032->power_lock);
 	mt9v032->pdata = pdata;
 
-	v4l2_ctrl_handler_init(&mt9v032->ctrls, ARRAY_SIZE(mt9v032_ctrls) + 8);
+	v4l2_ctrl_handler_init(&mt9v032->ctrls, ARRAY_SIZE(mt9v032_ctrls) + 9);
 
 	v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
 			  V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
@@ -763,6 +773,10 @@ static int mt9v032_probe(struct i2c_client *client,
 			  V4L2_CID_VBLANK, MT9V032_VERTICAL_BLANKING_MIN,
 			  MT9V032_VERTICAL_BLANKING_MAX, 1,
 			  MT9V032_VERTICAL_BLANKING_DEF);
+	v4l2_ctrl_new_std_menu_items(&mt9v032->ctrls, &mt9v032_ctrl_ops,
+			V4L2_CID_TEST_PATTERN,
+			ARRAY_SIZE(mt9v032_test_pattern_menu) - 1, 0,
+			0, mt9v032_test_pattern_menu);
 
 	mt9v032->pixel_rate =
 		v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
-- 
1.7.4.1

