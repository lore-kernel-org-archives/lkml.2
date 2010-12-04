Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab0LDCGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 21:06:23 -0500
Received: from ns2.cypress.com ([157.95.67.5]:33559 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab0LDCGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 21:06:21 -0500
From: Kevin McNeely <kev@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Brown <davidb@codeaurora.org>, Trilok Soni <tsoni@codeaurora.org>,
        Kevin McNeely <kev@cypress.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>, Luotao Fu <l.fu@pengutronix.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [v2] touchscreen Cypress TTSP G3 MTDEV Core Driver
Date: Fri,  3 Dec 2010 18:06:21 -0800
Message-Id: <1291428384-26364-1-git-send-email-kev@cypress.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <Kevin McNeely <kev@cypress.com>
References: <Kevin McNeely <kev@cypress.com>
X-Brightmail-Tracker: AAAAAA==
MIME-Version: 1.0
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amended version of Cypress TTSP Gen3 Core Driver.
Core Driver includes platform data definition file,
core driver definition file, and core touchscreen
touch handling of device data. Generates
multi-touch input events.
Amendments include changes recommended by reviewers
of initial version.  Kconfig is for I2C and SPI modules
including the core.

Signed-off-by: Kevin McNeely <kev@cypress.com>
---
 drivers/input/touchscreen/Kconfig       |   24 ++-
 drivers/input/touchscreen/Makefile      |    2 +-
 drivers/input/touchscreen/cyttsp_core.c |  442 ++++++++++++++++---------------
 drivers/input/touchscreen/cyttsp_core.h |    5 +-
 include/linux/input/cyttsp.h            |   35 +--
 5 files changed, 263 insertions(+), 245 deletions(-)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index ee5a31b..14aa5d0 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -126,12 +126,34 @@ config TOUCHSCREEN_CY8CTMG110
 
 config TOUCHSCREEN_CYTTSP_CORE
 	bool "Cypress TTSP touchscreen core"
+	depends on TOUCHSCREEN_CYTTSP_I2C || TOUCHSCREEN_CYTTSP_SPI
+	help
+	  Always activated for Cypress TTSP touchscreen
+
+config TOUCHSCREEN_CYTTSP_I2C
+	tristate "Cypress TTSP i2c touchscreen"
+	depends on I2C
 	help
 	  Say Y here if you have a Cypress TTSP touchscreen
-	  connected to your system.
+	  connected to your system with an I2C interface.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cyttsp-i2c.
+
+config TOUCHSCREEN_CYTTSP_SPI
+	tristate "Cypress TTSP spi touchscreen"
+	depends on SPI_MASTER
+	help
+	  Say Y here if you have a Cypress TTSP touchscreen
+	  connected to your  with an SPI interface.
 
 	  If unsure, say N.
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called cyttsp-spi.
+
 config TOUCHSCREEN_DA9034
 	tristate "Touchscreen support for Dialog Semiconductor DA9034"
 	depends on PMIC_DA903X
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index f629af9..b6f1ba8 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -16,7 +16,7 @@ obj-$(CONFIG_TOUCHSCREEN_ATMEL_TSADCC)	+= atmel_tsadcc.o
 obj-$(CONFIG_TOUCHSCREEN_BITSY)		+= h3600_ts_input.o
 obj-$(CONFIG_TOUCHSCREEN_BU21013)       += bu21013_ts.o
 obj-$(CONFIG_TOUCHSCREEN_CY8CTMG110)	+= cy8ctmg110_ts.o
-obj-$(CONFIG_TOUCHSCREEN_CYTTSP_CORE)	+= cyttsp_core.o
+obj-$(CONFIG_TOUCHSCREEN_CYTTSP_CORE)   += cyttsp_core.o
 obj-$(CONFIG_TOUCHSCREEN_DA9034)	+= da9034-ts.o
 obj-$(CONFIG_TOUCHSCREEN_DYNAPRO)	+= dynapro.o
 obj-$(CONFIG_TOUCHSCREEN_HAMPSHIRE)	+= hampshire.o
diff --git a/drivers/input/touchscreen/cyttsp_core.c b/drivers/input/touchscreen/cyttsp_core.c
index 99fd316..72b9be9 100644
--- a/drivers/input/touchscreen/cyttsp_core.c
+++ b/drivers/input/touchscreen/cyttsp_core.c
@@ -70,12 +70,14 @@
 #define CY_SMALL_TOOL_WIDTH         10
 #define CY_LARGE_TOOL_WIDTH         255
 #define CY_REG_BASE                 0x00
-#define CY_REG_GEST_SET             0x1E
+#define CY_REG_ACT_DIST             0x1E
 #define CY_REG_ACT_INTRVL           0x1D
 #define CY_REG_TCH_TMOUT            (CY_REG_ACT_INTRVL+1)
 #define CY_REG_LP_INTRVL            (CY_REG_TCH_TMOUT+1)
 #define CY_MAXZ                     255
-#define CY_DELAY_SYSINFO            20 /* ms */
+#define CY_DELAY_DFLT               20 /* ms */
+#define CY_DELAY_MAX                (500/CY_DELAY_DFLT) /* half second */
+#define CY_ACT_DIST_DFLT            0xF8
 #define CY_HNDSHK_BIT               0x80
 /* device mode bits */
 #define CY_OPERATE_MODE             0x00
@@ -87,8 +89,8 @@
 
 /* Touch structure */
 struct cyttsp_touch {
-	u16 x __attribute__ ((packed));
-	u16 y __attribute__ ((packed));
+	u8 x[2];
+	u8 y[2];
 	u8 z;
 };
 
@@ -106,7 +108,7 @@ struct cyttsp_xydata {
 	u8 touch34_id;
 	struct cyttsp_touch tch4;
 	u8 tt_undef[3];
-	u8 gest_set;
+	u8 act_dist;
 	u8 tt_reserved;
 };
 
@@ -160,8 +162,7 @@ struct cyttsp_tch {
 };
 
 struct cyttsp_trk {
-	u8 tch;
-	u8 w;
+	bool tch;
 	u16 x;
 	u16 y;
 	u8 z;
@@ -173,16 +174,17 @@ struct cyttsp {
 	struct input_dev *input;
 	struct mutex mutex;
 	char phys[32];
-	struct bus_type *bus_type;
-	struct cyttsp_platform_data *platform_data;
+	const struct bus_type *bus_type;
+	const struct cyttsp_platform_data *platform_data;
+	struct cyttsp_bus_ops *bus_ops;
 	struct cyttsp_xydata xy_data;
 	struct cyttsp_bootloader_data bl_data;
 	struct cyttsp_sysinfo_data sysinfo_data;
 	struct cyttsp_trk prv_trk[CY_NUM_TRK_ID];
 	struct cyttsp_tch tch_map[CY_NUM_TCH_ID];
-	struct cyttsp_bus_ops *bus_ops;
 	struct timer_list to_timer;
-	bool bl_ready;
+	struct completion bl_ready;
+	enum cyttsp_powerstate power_state;
 };
 
 struct cyttsp_track_data {
@@ -237,14 +239,6 @@ static int ttsp_tch_ext(struct cyttsp *ts, void *buf)
 	return retval;
 }
 
-static irqreturn_t cyttsp_bl_ready_irq(int irq, void *handle)
-{
-	struct cyttsp *ts = handle;
-
-	ts->bl_ready = true;
-	return IRQ_HANDLED;
-}
-
 static int cyttsp_load_bl_regs(struct cyttsp *ts)
 {
 	int retval;
@@ -294,25 +288,10 @@ static int cyttsp_bl_app_valid(struct cyttsp *ts)
 
 }
 
-static bool cyttsp_wait_bl_ready(struct cyttsp *ts, int loop_delay, int max_try)
-{
-	int tries = 0;
-
-	ts->bl_ready = false;	/* wait for interrupt to set ready flag */
-
-	while (!ts->bl_ready && (tries++ < max_try))
-		msleep(loop_delay);
-
-	if (tries < max_try)
-		return true;
-	else
-		return false;
-}
-
 static int cyttsp_exit_bl_mode(struct cyttsp *ts)
 {
 	int retval;
-	int tries = 0;
+	int tries;
 	u8 bl_cmd[sizeof(bl_command)];
 
 	memcpy(bl_cmd, bl_command, sizeof(bl_command));
@@ -332,12 +311,17 @@ static int cyttsp_exit_bl_mode(struct cyttsp *ts)
 	if (retval < 0)
 		return retval;
 
+	/* wait for TTSP Device to complete switch to Operational mode */
+	tries = 0;
 	do {
-		msleep(500);
+		msleep(CY_DELAY_DFLT);
 		retval = cyttsp_load_bl_regs(ts);
-	} while (GET_BOOTLOADERMODE(ts->bl_data.bl_status) &&
-		tries++ < 10 &&
-		!(retval < 0));
+	} while (!((retval == 0) &&
+		!GET_BOOTLOADERMODE(ts->bl_data.bl_status)) &&
+		(tries++ < CY_DELAY_MAX));
+
+	dev_dbg(ts->dev, "%s: check bl ready tries=%d ret=%d stat=%02X\n",
+		__func__, tries, retval, ts->bl_data.bl_status);
 
 	if (retval < 0)
 		return retval;
@@ -350,6 +334,7 @@ static int cyttsp_exit_bl_mode(struct cyttsp *ts)
 static int cyttsp_set_operational_mode(struct cyttsp *ts)
 {
 	int retval;
+	int tries;
 	u8 cmd = CY_OPERATE_MODE;
 
 	retval = ttsp_write_block_data(ts, CY_REG_BASE, sizeof(cmd), &cmd);
@@ -358,7 +343,17 @@ static int cyttsp_set_operational_mode(struct cyttsp *ts)
 		return retval;
 
 	/* wait for TTSP Device to complete switch to Operational mode */
-	msleep(500);
+	tries = 0;
+	do {
+		msleep(CY_DELAY_DFLT);
+		retval = ttsp_read_block_data(ts, CY_REG_BASE,
+			sizeof(ts->xy_data), &(ts->xy_data));
+	} while (!((retval == 0) &&
+		(ts->xy_data.act_dist == CY_ACT_DIST_DFLT)) &&
+		(tries++ < CY_DELAY_MAX));
+
+	dev_dbg(ts->dev, "%s: check op ready tries=%d ret=%d dist=%02X\n",
+		__func__, tries, retval, ts->xy_data.act_dist);
 
 	return retval;
 }
@@ -366,6 +361,7 @@ static int cyttsp_set_operational_mode(struct cyttsp *ts)
 static int cyttsp_set_sysinfo_mode(struct cyttsp *ts)
 {
 	int retval;
+	int tries;
 	u8 cmd = CY_SYSINFO_MODE;
 
 	memset(&(ts->sysinfo_data), 0, sizeof(struct cyttsp_sysinfo_data));
@@ -375,11 +371,19 @@ static int cyttsp_set_sysinfo_mode(struct cyttsp *ts)
 	if (retval < 0)
 		return retval;
 
-	msleep(500);
-
 	/* read sysinfo registers */
-	retval = ttsp_read_block_data(ts, CY_REG_BASE,
-		sizeof(ts->sysinfo_data), &(ts->sysinfo_data));
+	tries = 0;
+	do {
+		msleep(CY_DELAY_DFLT);
+		retval = ttsp_read_block_data(ts, CY_REG_BASE,
+			sizeof(ts->sysinfo_data), &(ts->sysinfo_data));
+	} while (!((retval == 0) &&
+		!((ts->sysinfo_data.tts_verh == 0) &&
+		(ts->sysinfo_data.tts_verl == 0))) &&
+		(tries++ < CY_DELAY_MAX));
+
+	dev_dbg(ts->dev, "%s: check sysinfo ready tries=%d ret=%d\n",
+		__func__, tries, retval);
 
 	dev_info(ts->dev, "%s: tv=%02X%02X ai=0x%02X%02X "
 		"av=0x%02X%02X ci=0x%02X%02X%02X\n", "cyttsp",
@@ -396,9 +400,9 @@ static int cyttsp_set_sysinfo_regs(struct cyttsp *ts)
 {
 	int retval = 0;
 
-	if ((ts->platform_data->act_intrvl != CY_ACT_INTRVL_DFLT) ||
-		(ts->platform_data->tch_tmout != CY_TCH_TMOUT_DFLT) ||
-		(ts->platform_data->lp_intrvl != CY_LP_INTRVL_DFLT)) {
+	if (ts->platform_data->act_intrvl != CY_ACT_INTRVL_DFLT ||
+		ts->platform_data->tch_tmout != CY_TCH_TMOUT_DFLT ||
+		ts->platform_data->lp_intrvl != CY_LP_INTRVL_DFLT) {
 
 		u8 intrvl_ray[3];
 
@@ -411,7 +415,7 @@ static int cyttsp_set_sysinfo_regs(struct cyttsp *ts)
 				CY_REG_ACT_INTRVL,
 				sizeof(intrvl_ray), intrvl_ray);
 
-		msleep(CY_DELAY_SYSINFO);
+		msleep(CY_DELAY_DFLT);
 	}
 
 	return retval;
@@ -422,37 +426,36 @@ static int cyttsp_soft_reset(struct cyttsp *ts)
 	int retval;
 	u8 cmd = CY_SOFT_RESET_MODE;
 
-	/* enable bootloader interrupts */
-	retval = request_irq(ts->irq, cyttsp_bl_ready_irq,
-		IRQF_TRIGGER_FALLING, ts->platform_data->name, ts);
-	if (retval)
+	retval = ttsp_write_block_data(ts, CY_REG_BASE, sizeof(cmd), &cmd);
+	if (retval < 0)
 		return retval;
 
-	retval = ttsp_write_block_data(ts, CY_REG_BASE, sizeof(cmd), &cmd);
-	if (!retval) {
-		if (!cyttsp_wait_bl_ready(ts, 20, 100))
-			retval = -ENODEV;
-		else
-			retval = 0;
-	}
+	/* wait for interrupt to set ready completion */
+	INIT_COMPLETION(ts->bl_ready);
+
+	retval = wait_for_completion_interruptible_timeout(&ts->bl_ready,
+		msecs_to_jiffies(CY_DELAY_DFLT * CY_DELAY_MAX));
+
+	if (retval > 0)
+		retval = 0;
 
-	free_irq(ts->irq, ts);
 	return retval;
 }
 
-static int cyttsp_gesture_setup(struct cyttsp *ts)
+static int cyttsp_act_dist_setup(struct cyttsp *ts)
 {
 	int retval;
-	u8 gesture_setup;
+	u8 act_dist_setup;
 
 	/* Init gesture; active distance setup */
-	gesture_setup = ts->platform_data->gest_set;
-	retval = ttsp_write_block_data(ts, CY_REG_GEST_SET,
-		sizeof(gesture_setup), &gesture_setup);
+	act_dist_setup = ts->platform_data->act_dist;
+	retval = ttsp_write_block_data(ts, CY_REG_ACT_DIST,
+		sizeof(act_dist_setup), &act_dist_setup);
 
 	return retval;
 }
 
+/* map pointers to touch information to allow loop on get xy_data */
 static void cyttsp_init_tch_map(struct cyttsp *ts)
 {
 	ts->tch_map[0].tch = &ts->xy_data.tch1;
@@ -465,17 +468,6 @@ static void cyttsp_init_tch_map(struct cyttsp *ts)
 	ts->tch_map[3].id = &ts->xy_data.touch34_id;
 }
 
-static void cyttsp_init_prv_trks(struct cyttsp *ts)
-{
-	/* init the touch structures */
-	memset(ts->prv_trk, CY_NTCH, sizeof(ts->prv_trk));
-}
-
-static void cyttsp_init_cur_trks(struct cyttsp_track_data *t)
-{
-	memset(t->cur_trk, CY_NTCH, sizeof(t->cur_trk));
-}
-
 static int cyttsp_hndshk(struct cyttsp *ts, u8 hst_mode)
 {
 	int retval;
@@ -491,7 +483,7 @@ static int cyttsp_hndshk(struct cyttsp *ts, u8 hst_mode)
 	return retval;
 }
 
-static void handle_multi_touch(struct cyttsp_track_data *t, struct cyttsp *ts)
+static void handle_multi_touch(struct cyttsp_trk *cur_trk, struct cyttsp *ts)
 {
 	u8 id;
 	u8 cnt = 0;
@@ -500,35 +492,27 @@ static void handle_multi_touch(struct cyttsp_track_data *t, struct cyttsp *ts)
 	 * is missing from the current event
 	 */
 	for (id = 0; id < CY_NUM_TRK_ID; id++) {
-		if (t->cur_trk[id].tch) {
+		if (cur_trk[id].tch) {
 			/* put active current track data */
 			input_report_abs(ts->input,
-				ABS_MT_TRACKING_ID, id);
-			input_report_abs(ts->input,
-				ABS_MT_WIDTH_MAJOR, t->cur_trk[id].w);
+				ABS_MT_POSITION_X, cur_trk[id].x);
 			input_report_abs(ts->input,
-				ABS_MT_POSITION_X, t->cur_trk[id].x);
+				ABS_MT_POSITION_Y, cur_trk[id].y);
 			input_report_abs(ts->input,
-				ABS_MT_POSITION_Y, t->cur_trk[id].y);
-			input_report_abs(ts->input,
-				ABS_MT_TOUCH_MAJOR, t->cur_trk[id].z);
+				ABS_MT_TOUCH_MAJOR, cur_trk[id].z);
 			input_mt_sync(ts->input);
 
-			dev_dbg(ts->dev, "%s: MT1: X=%d Y=%d Z=%d\n",
-				__func__,
-				t->cur_trk[id].x,
-				t->cur_trk[id].y,
-				t->cur_trk[id].z);
-			/* save current track data into previous track data */
-			ts->prv_trk[id] = t->cur_trk[id];
+			dev_dbg(ts->dev, "%s: MT% 2d: X=%d Y=%d Z=%d\n",
+				__func__, id,
+				cur_trk[id].x,
+				cur_trk[id].y,
+				cur_trk[id].z);
+			/* save current touch xy_data as previous track data */
+			ts->prv_trk[id] = cur_trk[id];
 			cnt++;
 		} else if (ts->prv_trk[id].tch) {
 			/* put lift-off previous track data */
 			input_report_abs(ts->input,
-				ABS_MT_TRACKING_ID, id);
-			input_report_abs(ts->input,
-				ABS_MT_WIDTH_MAJOR, ts->prv_trk[id].w);
-			input_report_abs(ts->input,
 				ABS_MT_POSITION_X, ts->prv_trk[id].x);
 			input_report_abs(ts->input,
 				ABS_MT_POSITION_Y, ts->prv_trk[id].y);
@@ -536,11 +520,12 @@ static void handle_multi_touch(struct cyttsp_track_data *t, struct cyttsp *ts)
 				ABS_MT_TOUCH_MAJOR, CY_NTCH);
 			input_mt_sync(ts->input);
 
-			dev_dbg(ts->dev, "%s: MT1: X=%d Y=%d Z=%d lift-off\n",
-				__func__,
+			dev_dbg(ts->dev, "%s: MT% 2d: X=%d Y=%d Z=%d liftoff\n",
+				__func__, id,
 				ts->prv_trk[id].x,
 				ts->prv_trk[id].y,
 				CY_NTCH);
+			/* clear previous touch indication */
 			ts->prv_trk[id].tch = CY_NTCH;
 			cnt++;
 		}
@@ -551,27 +536,21 @@ static void handle_multi_touch(struct cyttsp_track_data *t, struct cyttsp *ts)
 		input_sync(ts->input);
 }
 
-static void cyttsp_get_xydata(struct cyttsp *ts,
-	struct cyttsp_track_data *t,
-	u8 id, u8 w, u16 x, u16 y, u8 z)
-{
-	struct cyttsp_trk *trk;
-
-	trk = &(t->cur_trk[id]);
-	trk->tch = CY_TCH;
-	trk->w = w;
-	trk->x = x;
-	trk->y = y;
-	trk->z = z;
-}
-
+/* read xy_data for all current touches */
 static int cyttsp_xy_worker(struct cyttsp *ts)
 {
 	u8 cur_tch = 0;
 	u8 tch;
-	struct cyttsp_track_data trk;
+	u8 id;
+	u8 *x;
+	u8 *y;
+	u8 z;
+	struct cyttsp_trk cur_trk[CY_NUM_TRK_ID];
 
-	/* get event data from CYTTSP device */
+	/* Get event data from CYTTSP device.
+	 * The event data includes all data
+	 * for all active touches.
+	 */
 	if (ttsp_read_block_data(ts,
 		CY_REG_BASE, sizeof(struct cyttsp_xydata), &ts->xy_data))
 		return 0;
@@ -585,9 +564,11 @@ static int cyttsp_xy_worker(struct cyttsp *ts)
 		if (cyttsp_hndshk(ts, ts->xy_data.hst_mode))
 			return 0;
 
+	/* determine number of currently active touches */
 	cur_tch = GET_NUM_TOUCHES(ts->xy_data.tt_stat);
 
-	if (ts->bus_ops->power_state == CY_IDLE_STATE)
+	/* check for any error conditions */
+	if (ts->power_state == CY_IDLE_STATE)
 		return 0;
 	else if (GET_BOOTLOADERMODE(ts->xy_data.tt_mode)) {
 		return -1;
@@ -605,44 +586,70 @@ static int cyttsp_xy_worker(struct cyttsp *ts)
 		dev_dbg(ts->dev, "%s: Invalid buffer detected\n", __func__);
 	}
 
-	/* process the touches */
-	cyttsp_init_cur_trks(&trk);
+	/* clear current touch tracking structures */
+	memset(cur_trk, CY_NTCH, sizeof(cur_trk));
 
+	/* extract xy_data for all currently reported touches */
 	for (tch = 0; tch < cur_tch; tch++) {
-		cyttsp_get_xydata(ts, &trk,
-			tch & 0x01 ?
+		id = tch & 0x01 ?
 			(*(ts->tch_map[tch].id) & 0x0F) :
-			(*(ts->tch_map[tch].id) & 0xF0) >> 4,
-			CY_SMALL_TOOL_WIDTH,
-			be16_to_cpu((ts->tch_map[tch].tch)->x),
-			be16_to_cpu((ts->tch_map[tch].tch)->y),
-			(ts->tch_map[tch].tch)->z);
+			(*(ts->tch_map[tch].id) & 0xF0) >> 4;
+		x = (u8 *)&((ts->tch_map[tch].tch)->x);
+		y = (u8 *)&((ts->tch_map[tch].tch)->y);
+		z = (ts->tch_map[tch].tch)->z;
+		cur_trk[id].tch = CY_TCH;
+		cur_trk[id].x = ((u16)x[0] << 8) + x[1];
+		cur_trk[id].y = ((u16)y[0] << 8) + y[1];
+		cur_trk[id].z = z;
 	}
 
-	handle_multi_touch(&trk, ts);
+	/* provide input event signaling for each active touch */
+	handle_multi_touch(cur_trk, ts);
 
 	return 0;
 }
 
+static void cyttsp_pr_state(struct cyttsp *ts)
+{
+	static char *cyttsp_powerstate_string[] = {
+		"IDLE",
+		"ACTIVE",
+		"LOW_PWR",
+		"SLEEP",
+		"BOOTLOADER",
+		"INVALID"
+	};
+
+	dev_info(ts->dev, "%s: %s\n", __func__,
+		ts->power_state < CY_INVALID_STATE ?
+		cyttsp_powerstate_string[ts->power_state] :
+		"INVALID");
+}
+
 static irqreturn_t cyttsp_irq(int irq, void *handle)
 {
 	struct cyttsp *ts = handle;
 	int retval;
 
-	retval = cyttsp_xy_worker(ts);
-
-	if (retval < 0) {
-		/* TTSP device has reset back to bootloader mode
-		 * Reset driver touch history and restore operational mode
-		 */
-		cyttsp_init_prv_trks(ts);
-		retval = cyttsp_exit_bl_mode(ts);
-		if (retval)
-			ts->bus_ops->power_state = CY_IDLE_STATE;
-		dev_info(ts->dev, "%s: %s\n",
-			__func__,
-			(ts->bus_ops->power_state == CY_ACTIVE_STATE) ?
-			"ACTIVE" : "IDLE");
+	if (ts->power_state == CY_BL_STATE)
+		complete(&ts->bl_ready);
+	else {
+		/* process the touches */
+		retval = cyttsp_xy_worker(ts);
+
+		if (retval < 0) {
+			/* TTSP device has reset back to bootloader mode
+			 * Reset driver touch history and restore
+			 * operational mode
+			 */
+			memset(ts->prv_trk, CY_NTCH, sizeof(ts->prv_trk));
+			retval = cyttsp_exit_bl_mode(ts);
+			if (retval)
+				ts->power_state = CY_IDLE_STATE;
+			else
+				ts->power_state = CY_ACTIVE_STATE;
+			cyttsp_pr_state(ts);
+		}
 	}
 	return IRQ_HANDLED;
 }
@@ -651,21 +658,35 @@ static int cyttsp_power_on(struct cyttsp *ts)
 {
 	int retval = 0;
 
-	ts->bus_ops->power_state = CY_IDLE_STATE;
+	if (!ts)
+		return -ENOMEM;
+
+	ts->power_state = CY_BL_STATE;
+
+	/* enable interrupts */
+	retval = request_threaded_irq(ts->irq, NULL, cyttsp_irq,
+		IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+		ts->platform_data->name, ts);
+	if (retval < 0)
+		goto bypass;
+
+	retval = cyttsp_soft_reset(ts);
+	if (retval < 0)
+		goto bypass;
 
 	retval = cyttsp_bl_app_valid(ts);
 	if (retval < 0)
 		goto bypass;
-	else if (retval > 0) {
-		retval = cyttsp_soft_reset(ts);
-		if (retval < 0)
-			goto bypass;
-	}
+	else if (retval > 0)
+		goto no_bl_bypass;
 
 	retval = cyttsp_exit_bl_mode(ts);
 	if (retval < 0)
 		goto bypass;
 
+	ts->power_state = CY_IDLE_STATE;
+
+no_bl_bypass:
 	retval = cyttsp_set_sysinfo_mode(ts);
 	if (retval < 0)
 		goto bypass;
@@ -678,24 +699,16 @@ static int cyttsp_power_on(struct cyttsp *ts)
 	if (retval < 0)
 		goto bypass;
 
-	/* enable touch interrupts */
-	retval = request_threaded_irq(ts->irq, NULL, cyttsp_irq,
-		IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-		ts->platform_data->name, ts);
+	/* init active distance */
+	retval = cyttsp_act_dist_setup(ts);
 	if (retval < 0)
 		goto bypass;
 
-	/* init gesture setup; required for active distance */
-	retval = cyttsp_gesture_setup(ts);
+	ts->power_state = CY_ACTIVE_STATE;
+	retval = 0;
 
 bypass:
-	if (!retval)
-		ts->bus_ops->power_state = CY_ACTIVE_STATE;
-
-	dev_info(ts->dev, "%s: %s\n",
-		__func__,
-		(ts->bus_ops->power_state == CY_ACTIVE_STATE) ?
-		"ACTIVE" : "IDLE");
+	cyttsp_pr_state(ts);
 	return retval;
 }
 
@@ -706,7 +719,7 @@ int cyttsp_resume(void *handle)
 	int retval = 0;
 	struct cyttsp_xydata xydata;
 
-	if (ts->platform_data->use_sleep && (ts->bus_ops->power_state !=
+	if (ts->platform_data->use_sleep && (ts->power_state !=
 		CY_ACTIVE_STATE)) {
 		if (ts->platform_data->wakeup) {
 			retval = ts->platform_data->wakeup();
@@ -722,7 +735,7 @@ int cyttsp_resume(void *handle)
 			retval = ttsp_read_block_data(ts, CY_REG_BASE,
 				sizeof(xydata), &xydata);
 			if (!(retval < 0) && !GET_HSTMODE(xydata.hst_mode))
-				ts->bus_ops->power_state = CY_ACTIVE_STATE;
+				ts->power_state = CY_ACTIVE_STATE;
 		}
 	}
 	dev_dbg(ts->dev, "%s: Wake Up %s\n", __func__,
@@ -738,51 +751,77 @@ int cyttsp_suspend(void *handle)
 	int retval = 0;
 
 	if (ts->platform_data->use_sleep &&
-		(ts->bus_ops->power_state == CY_ACTIVE_STATE)) {
+		(ts->power_state == CY_ACTIVE_STATE)) {
 		sleep_mode = CY_DEEP_SLEEP_MODE;
 		retval = ttsp_write_block_data(ts,
 			CY_REG_BASE, sizeof(sleep_mode), &sleep_mode);
 		if (!(retval < 0))
-			ts->bus_ops->power_state = CY_SLEEP_STATE;
+			ts->power_state = CY_SLEEP_STATE;
 	}
 	dev_dbg(ts->dev, "%s: Sleep Power state is %s\n", __func__,
-		(ts->bus_ops->power_state == CY_ACTIVE_STATE) ?
+		(ts->power_state == CY_ACTIVE_STATE) ?
 		"ACTIVE" :
-		((ts->bus_ops->power_state == CY_SLEEP_STATE) ?
+		((ts->power_state == CY_SLEEP_STATE) ?
 		"SLEEP" : "LOW POWER"));
 	return retval;
 }
 EXPORT_SYMBOL_GPL(cyttsp_suspend);
 #endif
 
-int cyttsp_core_init(struct cyttsp_bus_ops *bus_ops,
-	struct device *dev, void *handle)
+static int cyttsp_open(struct input_dev *dev)
+{
+	struct cyttsp *ts = input_get_drvdata(dev);
+
+	return cyttsp_power_on(ts);
+}
+
+void cyttsp_core_release(void *handle)
+{
+	struct cyttsp *ts = handle;
+
+	if (ts) {
+		mutex_destroy(&ts->mutex);
+		free_irq(ts->irq, ts);
+		input_unregister_device(ts->input);
+		if (ts->platform_data->exit)
+			ts->platform_data->exit();
+		kfree(ts);
+	}
+}
+EXPORT_SYMBOL_GPL(cyttsp_core_release);
+
+static void cyttsp_close(struct input_dev *dev)
+{
+	struct cyttsp *ts = input_get_drvdata(dev);
+
+	cyttsp_core_release(ts);
+}
+
+void *cyttsp_core_init(struct cyttsp_bus_ops *bus_ops, struct device *dev)
 {
 	struct input_dev *input_device;
-	struct cyttsp *ts;
-	int retval = 0;
+	struct cyttsp *ts = kzalloc(sizeof(*ts), GFP_KERNEL);
 
-	if ((dev == NULL) || (bus_ops == NULL))
+	if (!ts) {
+		dev_dbg(ts->dev, "%s: Error, kzalloc\n", __func__);
 		goto error_alloc_data;
+	}
 
-	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
-	if (ts == NULL) {
-		dev_dbg(ts->dev, "%s: Error, kzalloc\n", __func__);
-		retval = -ENOMEM;
+	if ((dev == NULL) || (bus_ops == NULL)) {
+		kfree(ts);
 		goto error_alloc_data;
 	}
+
 	mutex_init(&ts->mutex);
 	ts->dev = dev;
 	ts->platform_data = dev->platform_data;
 	ts->bus_ops = bus_ops;
-	ts->platform_data->dev = ts->dev;
+	init_completion(&ts->bl_ready);
 
 	if (ts->platform_data->init) {
-		retval = ts->platform_data->init(ts->platform_data, 1);
-		if (retval) {
+		if (ts->platform_data->init()) {
 			dev_dbg(ts->dev, "%s: Error, platform init failed!\n",
 				__func__);
-			retval = -EIO;
 			goto error_init;
 		}
 	}
@@ -791,28 +830,29 @@ int cyttsp_core_init(struct cyttsp_bus_ops *bus_ops,
 	if (ts->irq <= 0) {
 		dev_dbg(ts->dev, "%s: Error, failed to allocate irq\n",
 			__func__);
-			retval = -EIO;
 			goto error_init;
 	}
 
 	/* Create the input device and register it. */
 	input_device = input_allocate_device();
 	if (!input_device) {
-		retval = -ENOMEM;
 		dev_dbg(ts->dev, "%s: Error, failed to allocate input device\n",
 			__func__);
-			retval = -ENODEV;
 		goto error_input_allocate_device;
 	}
 
 	ts->input = input_device;
 	input_device->name = ts->platform_data->name;
+	snprintf(ts->phys, sizeof(ts->phys), "%s", dev_name(dev));
 	input_device->phys = ts->phys;
 	input_device->dev.parent = ts->dev;
 	ts->bus_type = bus_ops->dev->bus;
+	input_device->open = cyttsp_open;
+	input_device->close = cyttsp_close;
+	input_set_drvdata(input_device, ts);
 
 	cyttsp_init_tch_map(ts);
-	cyttsp_init_prv_trks(ts);
+	memset(ts->prv_trk, CY_NTCH, sizeof(ts->prv_trk));
 
 	__set_bit(EV_SYN, input_device->evbit);
 	__set_bit(EV_KEY, input_device->evbit);
@@ -824,61 +864,29 @@ int cyttsp_core_init(struct cyttsp_bus_ops *bus_ops,
 		0, ts->platform_data->maxy, 0, 0);
 	input_set_abs_params(input_device, ABS_MT_TOUCH_MAJOR,
 		0, CY_MAXZ, 0, 0);
-	input_set_abs_params(input_device, ABS_MT_WIDTH_MAJOR,
-		0, CY_LARGE_TOOL_WIDTH, 0, 0);
-	input_set_abs_params(input_device, ABS_MT_TRACKING_ID,
-		0, CY_NUM_TRK_ID, 0, 0);
 
-	retval = input_register_device(input_device);
-	if (retval) {
+	if (input_register_device(input_device)) {
 		dev_dbg(ts->dev, "%s: Error, failed to register input device\n",
 			__func__);
-			retval = -ENODEV;
 		goto error_input_register_device;
 	}
 
-	retval = cyttsp_power_on(ts);
-
-	if (retval < 0) {
-		dev_dbg(ts->dev, "%s: Error, power on failed!\n", __func__);
-		retval = -ENODEV;
-		goto error_power_on;
-	}
-
-	handle = ts;
 	goto no_error;
 
-error_power_on:
-	free_irq(ts->irq, ts);
 error_input_register_device:
 	input_unregister_device(input_device);
 error_input_allocate_device:
-	if (ts->platform_data->init)
-		ts->platform_data->init(ts->platform_data, 0);
+	if (ts->platform_data->exit)
+		ts->platform_data->exit();
 error_init:
 	mutex_destroy(&ts->mutex);
 	kfree(ts);
 error_alloc_data:
-	handle = NULL;
 no_error:
-	return retval;
+	return ts;
 }
 EXPORT_SYMBOL_GPL(cyttsp_core_init);
 
-/* registered in driver struct */
-void cyttsp_core_release(void *handle)
-{
-	struct cyttsp *ts = handle;
-
-	mutex_destroy(&ts->mutex);
-	free_irq(ts->irq, ts);
-	input_unregister_device(ts->input);
-	if (ts->platform_data->init)
-		ts->platform_data->init(ts->platform_data, 0);
-	kfree(ts);
-}
-EXPORT_SYMBOL_GPL(cyttsp_core_release);
-
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard touchscreen driver core");
 MODULE_AUTHOR("Cypress");
diff --git a/drivers/input/touchscreen/cyttsp_core.h b/drivers/input/touchscreen/cyttsp_core.h
index 43fe438..58ab186 100644
--- a/drivers/input/touchscreen/cyttsp_core.h
+++ b/drivers/input/touchscreen/cyttsp_core.h
@@ -30,6 +30,7 @@
 #define __CYTTSP_CORE_H__
 
 #include <linux/kernel.h>
+#include <linux/err.h>
 #include <linux/input/cyttsp.h>
 
 #define CY_NUM_RETRY                4 /* max number of retries for read ops */
@@ -40,11 +41,9 @@ struct cyttsp_bus_ops {
 	s32 (*read)(void *handle, u8 addr, u8 length, void *values);
 	s32 (*ext)(void *handle, void *values);
 	struct device *dev;
-	enum cyttsp_powerstate power_state;
 };
 
-int cyttsp_core_init(struct cyttsp_bus_ops *bus_ops,
-	struct device *dev, void *handle);
+void *cyttsp_core_init(struct cyttsp_bus_ops *bus_ops, struct device *dev);
 
 void cyttsp_core_release(void *handle);
 #ifdef CONFIG_PM
diff --git a/include/linux/input/cyttsp.h b/include/linux/input/cyttsp.h
index 5280252..e942183 100644
--- a/include/linux/input/cyttsp.h
+++ b/include/linux/input/cyttsp.h
@@ -30,46 +30,35 @@
 #define CY_SPI_NAME "cyttsp-spi"
 #define CY_I2C_NAME "cyttsp-i2c"
 /* Active Power state scanning/processing refresh interval */
-#define CY_ACT_INTRVL_DFLT 0x00
+#define CY_ACT_INTRVL_DFLT 0x00 /* ms */
 /* touch timeout for the Active power */
-#define CY_TCH_TMOUT_DFLT 0xFF
+#define CY_TCH_TMOUT_DFLT 0xFF /* ms */
 /* Low Power state scanning/processing refresh interval */
-#define CY_LP_INTRVL_DFLT 0x0A
-/*
- * Active distance in pixels for a gesture to be reported
- * if set to 0, then all gesture movements are reported
- * Valid range is 0 - 15
- */
-#define CY_ACT_DIST_DFLT 8
-#define CY_ACT_DIST CY_ACT_DIST_DFLT
-
-enum cyttsp_gest {
-	CY_GEST_GRP_NONE = 0,
-	CY_GEST_GRP1 =	0x10,
-	CY_GEST_GRP2 = 0x20,
-	CY_GEST_GRP3 = 0x40,
-	CY_GEST_GRP4 = 0x80,
-};
+#define CY_LP_INTRVL_DFLT 0x0A /* ms */
+/* Active distance in pixels for a gesture to be reported */
+#define CY_ACT_DIST_DFLT 0xF8 /* pixels */
 
 enum cyttsp_powerstate {
 	CY_IDLE_STATE,
 	CY_ACTIVE_STATE,
 	CY_LOW_PWR_STATE,
 	CY_SLEEP_STATE,
+	CY_BL_STATE,
+	CY_INVALID_STATE	/* always last in the list */
 };
 
 struct cyttsp_platform_data {
-	struct device *dev;
 	u32 maxx;
 	u32 maxy;
-	unsigned use_hndshk:1;
-	unsigned use_sleep:1;
-	u8 gest_set;	/* Active distance */
+	bool use_hndshk;
+	bool use_sleep;
+	u8 act_dist;	/* Active distance */
 	u8 act_intrvl;  /* Active refresh interval; ms */
 	u8 tch_tmout;   /* Active touch timeout; ms */
 	u8 lp_intrvl;   /* Low power refresh interval; ms */
 	int (*wakeup)(void);
-	int (*init)(struct cyttsp_platform_data *, int on_off);
+	int (*init)(void);
+	void (*exit)(void);
 	char *name;
 	s16 irq_gpio;
 	u8 *bl_keys;
-- 
1.7.2.1


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

