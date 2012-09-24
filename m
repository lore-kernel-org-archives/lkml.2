Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab2IXKok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:44:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50917 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab2IXKoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:44:38 -0400
From: Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        VGER <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v2] media: davinci: vpif: display: separate out subdev from output
Date: Mon, 24 Sep 2012 16:14:11 +0530
Message-Id: <1348483451-20668-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

vpif_display relied on a 1-1 mapping of output and subdev. This is not
necessarily the case. Separate the two. So there is a list of subdevs
and a list of outputs. Each output refers to a subdev and has routing
information. An output does not have to have a subdev.

The initial output for each channel is set to the fist output.

Currently missing is support for associating multiple subdevs with
an output.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sekhar Nori <nsekhar@ti.com>
---
 This patch is dependent on the patch series from Hans
 (http://www.mail-archive.com/linux-media@vger.kernel.org/msg52270.html)

 Changes for V2:
 1: Changed v4l2_device_call_until_err() call to v4l2_subdev_call() for
    s_routing, since this call is for specific subdev, pointed out by Hans.

 arch/arm/mach-davinci/board-da850-evm.c       |   29 +++++-
 arch/arm/mach-davinci/board-dm646x-evm.c      |   39 ++++++-
 drivers/media/platform/davinci/vpif_display.c |  136 ++++++++++++++++++++-----
 include/media/davinci/vpif_types.h            |   20 +++-
 4 files changed, 183 insertions(+), 41 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 3081ea4..23a7012 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -46,6 +46,7 @@
 #include <mach/spi.h>
 
 #include <media/tvp514x.h>
+#include <media/adv7343.h>
 
 #define DA850_EVM_PHY_ID		"davinci_mdio-0:00"
 #define DA850_LCD_PWR_PIN		GPIO_TO_PIN(2, 8)
@@ -1257,16 +1258,34 @@ static struct vpif_subdev_info da850_vpif_subdev[] = {
 	},
 };
 
-static const char const *vpif_output[] = {
-		"Composite",
-		"S-Video",
+static const struct vpif_output da850_ch0_outputs[] = {
+	{
+		.output = {
+			.index = 0,
+			.name = "Composite",
+			.type = V4L2_OUTPUT_TYPE_ANALOG,
+		},
+		.subdev_name = "adv7343",
+		.output_route = ADV7343_COMPOSITE_ID,
+	},
+	{
+		.output = {
+			.index = 1,
+			.name = "S-Video",
+			.type = V4L2_OUTPUT_TYPE_ANALOG,
+		},
+		.subdev_name = "adv7343",
+		.output_route = ADV7343_SVIDEO_ID,
+	},
 };
 
 static struct vpif_display_config da850_vpif_display_config = {
 	.subdevinfo   = da850_vpif_subdev,
 	.subdev_count = ARRAY_SIZE(da850_vpif_subdev),
-	.output       = vpif_output,
-	.output_count = ARRAY_SIZE(vpif_output),
+	.chan_config[0] = {
+		.outputs = da850_ch0_outputs,
+		.output_count = ARRAY_SIZE(da850_ch0_outputs),
+	},
 	.card_name    = "DA850/OMAP-L138 Video Display",
 };
 
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index ad249c7..c206768 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -26,6 +26,7 @@
 #include <linux/i2c/pcf857x.h>
 
 #include <media/tvp514x.h>
+#include <media/adv7343.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
@@ -496,18 +497,44 @@ static struct vpif_subdev_info dm646x_vpif_subdev[] = {
 	},
 };
 
-static const char *output[] = {
-	"Composite",
-	"Component",
-	"S-Video",
+static const struct vpif_output dm6467_ch0_outputs[] = {
+	{
+		.output = {
+			.index = 0,
+			.name = "Composite",
+			.type = V4L2_OUTPUT_TYPE_ANALOG,
+		},
+		.subdev_name = "adv7343",
+		.output_route = ADV7343_COMPOSITE_ID,
+	},
+	{
+		.output = {
+			.index = 1,
+			.name = "Component",
+			.type = V4L2_OUTPUT_TYPE_ANALOG,
+		},
+		.subdev_name = "adv7343",
+		.output_route = ADV7343_COMPONENT_ID,
+	},
+	{
+		.output = {
+			.index = 2,
+			.name = "S-Video",
+			.type = V4L2_OUTPUT_TYPE_ANALOG,
+		},
+		.subdev_name = "adv7343",
+		.output_route = ADV7343_SVIDEO_ID,
+	},
 };
 
 static struct vpif_display_config dm646x_vpif_display_config = {
 	.set_clock	= set_vpif_clock,
 	.subdevinfo	= dm646x_vpif_subdev,
 	.subdev_count	= ARRAY_SIZE(dm646x_vpif_subdev),
-	.output		= output,
-	.output_count	= ARRAY_SIZE(output),
+	.chan_config[0] = {
+		.outputs = dm6467_ch0_outputs,
+		.output_count = ARRAY_SIZE(dm6467_ch0_outputs),
+	},
 	.card_name	= "DM646x EVM",
 };
 
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 8d1ce09..f68780f 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -308,7 +308,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 		channel2_intr_assert();
 		channel2_intr_enable(1);
 		enable_channel2(1);
-		if (vpif_config_data->ch2_clip_en)
+		if (vpif_config_data->chan_config[VPIF_CHANNEL2_VIDEO].clip_en)
 			channel2_clipping_enable(1);
 	}
 
@@ -317,7 +317,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 		channel3_intr_assert();
 		channel3_intr_enable(1);
 		enable_channel3(1);
-		if (vpif_config_data->ch3_clip_en)
+		if (vpif_config_data->chan_config[VPIF_CHANNEL3_VIDEO].clip_en)
 			channel3_clipping_enable(1);
 	}
 
@@ -1174,14 +1174,16 @@ static int vpif_streamoff(struct file *file, void *priv,
 	if (buftype == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		/* disable channel */
 		if (VPIF_CHANNEL2_VIDEO == ch->channel_id) {
-			if (vpif_config_data->ch2_clip_en)
+			if (vpif_config_data->
+				chan_config[VPIF_CHANNEL2_VIDEO].clip_en)
 				channel2_clipping_enable(0);
 			enable_channel2(0);
 			channel2_intr_enable(0);
 		}
 		if ((VPIF_CHANNEL3_VIDEO == ch->channel_id) ||
 					(2 == common->started)) {
-			if (vpif_config_data->ch3_clip_en)
+			if (vpif_config_data->
+				chan_config[VPIF_CHANNEL3_VIDEO].clip_en)
 				channel3_clipping_enable(0);
 			enable_channel3(0);
 			channel3_intr_enable(0);
@@ -1214,41 +1216,118 @@ static int vpif_enum_output(struct file *file, void *fh,
 {
 
 	struct vpif_display_config *config = vpif_dev->platform_data;
+	struct vpif_display_chan_config *chan_cfg;
+	struct vpif_fh *vpif_handler = fh;
+	struct channel_obj *ch = vpif_handler->channel;
 
-	if (output->index >= config->output_count) {
+	chan_cfg = &config->chan_config[ch->channel_id];
+	if (output->index >= chan_cfg->output_count) {
 		vpif_dbg(1, debug, "Invalid output index\n");
 		return -EINVAL;
 	}
 
-	strcpy(output->name, config->output[output->index]);
-	output->type = V4L2_OUTPUT_TYPE_ANALOG;
+	memcpy(output, &chan_cfg->outputs[output->index].output,
+		sizeof(*output));
 	output->std = VPIF_V4L2_STD;
 
 	return 0;
 }
 
+/**
+ * vpif_output_to_subdev() - Maps output to sub device
+ * @vpif_cfg - global config ptr
+ * @chan_cfg - channel config ptr
+ * @index - Given output index from application
+ *
+ * lookup the sub device information for a given output index.
+ * we report all the output to application. output table also
+ * has sub device name for the each output
+ */
+static int
+vpif_output_to_subdev(struct vpif_display_config *vpif_cfg,
+		      struct vpif_display_chan_config *chan_cfg, int index)
+{
+	struct vpif_subdev_info *subdev_info;
+	const char *subdev_name;
+	int i;
+
+	vpif_dbg(2, debug, "vpif_output_to_subdev\n");
+
+	if (chan_cfg->outputs == NULL)
+		return -1;
+
+	subdev_name = chan_cfg->outputs[index].subdev_name;
+	if (subdev_name == NULL)
+		return -1;
+
+	/* loop through the sub device list to get the sub device info */
+	for (i = 0; i < vpif_cfg->subdev_count; i++) {
+		subdev_info = &vpif_cfg->subdevinfo[i];
+		if (!strcmp(subdev_info->name, subdev_name))
+			return i;
+	}
+	return -1;
+}
+
+/**
+ * vpif_set_output() - Select an output
+ * @vpif_cfg - global config ptr
+ * @ch - channel
+ * @index - Given output index from application
+ *
+ * Select the given output.
+ */
+static int vpif_set_output(struct vpif_display_config *vpif_cfg,
+		      struct channel_obj *ch, int index)
+{
+	struct vpif_display_chan_config *chan_cfg =
+		&vpif_cfg->chan_config[ch->channel_id];
+	struct vpif_subdev_info *subdev_info = NULL;
+	struct v4l2_subdev *sd = NULL;
+	u32 input = 0, output = 0;
+	int sd_index;
+	int ret;
+
+	sd_index = vpif_output_to_subdev(vpif_cfg, chan_cfg, index);
+	if (sd_index >= 0) {
+		sd = vpif_obj.sd[sd_index];
+		subdev_info = &vpif_cfg->subdevinfo[sd_index];
+	}
+
+	if (sd) {
+		input = chan_cfg->outputs[index].input_route;
+		output = chan_cfg->outputs[index].output_route;
+		ret = v4l2_subdev_call(sd, video, s_routing, input, output, 0);
+		if (ret < 0) {
+			vpif_err("Failed to set output\n");
+			return ret;
+		}
+
+	}
+	ch->output_idx = index;
+	ch->sd = sd;
+	return 0;
+}
+
 static int vpif_s_output(struct file *file, void *priv, unsigned int i)
 {
+	struct vpif_display_config *config = vpif_dev->platform_data;
+	struct vpif_display_chan_config *chan_cfg;
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	int ret = 0;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+
+	if (i >= chan_cfg->output_count)
+		return -EINVAL;
 
 	if (common->started) {
 		vpif_err("Streaming in progress\n");
 		return -EBUSY;
 	}
 
-	ret = v4l2_device_call_until_err(&vpif_obj.v4l2_dev, 1, video,
-							s_routing, 0, i, 0);
-
-	if (ret < 0)
-		vpif_err("Failed to set output standard\n");
-
-	ch->output_idx = i;
-	if (vpif_obj.sd[i])
-		ch->sd = vpif_obj.sd[i];
-	return ret;
+	return vpif_set_output(config, ch, i);
 }
 
 static int vpif_g_output(struct file *file, void *priv, unsigned int *i)
@@ -1291,9 +1370,12 @@ vpif_enum_dv_timings(struct file *file, void *priv,
 {
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
+	int ret;
 
-	return v4l2_subdev_call(vpif_obj.sd[ch->output_idx],
-			video, enum_dv_timings, timings);
+	ret = v4l2_subdev_call(ch->sd, video, enum_dv_timings, timings);
+	if (ret == -ENOIOCTLCMD && ret == -ENODEV)
+		return -EINVAL;
+	return ret;
 }
 
 /**
@@ -1320,12 +1402,9 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 
 	/* Configure subdevice timings, if any */
 	ret = v4l2_subdev_call(ch->sd, video, s_dv_timings, timings);
-	if (ret == -ENOIOCTLCMD) {
-		vpif_dbg(2, debug, "Custom DV timings not supported by "
-				"subdevice\n");
-		return -ENODATA;
-	}
-	if (ret < 0 && ret != -ENODEV) {
+	if (ret == -ENOIOCTLCMD || ret == -ENODEV)
+		ret = 0;
+	if (ret < 0) {
 		vpif_dbg(2, debug, "Error setting custom DV timings\n");
 		return ret;
 	}
@@ -1754,6 +1833,11 @@ static __init int vpif_probe(struct platform_device *pdev)
 		ch->video_dev->lock = &common->lock;
 		video_set_drvdata(ch->video_dev, ch);
 
+		/* select output 0 */
+		err = vpif_set_output(config, ch, 0);
+		if (err)
+			goto probe_out;
+
 		/* register video device */
 		vpif_dbg(1, debug, "channel=%x,channel->video_dev=%x\n",
 				(int)ch, (int)&ch->video_dev);
diff --git a/include/media/davinci/vpif_types.h b/include/media/davinci/vpif_types.h
index 65e8fe1..4b297eb 100644
--- a/include/media/davinci/vpif_types.h
+++ b/include/media/davinci/vpif_types.h
@@ -20,6 +20,7 @@
 #include <linux/i2c.h>
 
 #define VPIF_CAPTURE_MAX_CHANNELS	2
+#define VPIF_DISPLAY_MAX_CHANNELS	2
 
 enum vpif_if_type {
 	VPIF_IF_BT656,
@@ -39,15 +40,26 @@ struct vpif_subdev_info {
 	struct i2c_board_info board_info;
 };
 
+struct vpif_output {
+	struct v4l2_output output;
+	const char *subdev_name;
+	u32 input_route;
+	u32 output_route;
+};
+
+struct vpif_display_chan_config {
+	struct vpif_interface vpif_if;
+	const struct vpif_output *outputs;
+	int output_count;
+	bool clip_en;
+};
+
 struct vpif_display_config {
 	int (*set_clock)(int, int);
 	struct vpif_subdev_info *subdevinfo;
 	int subdev_count;
-	const char **output;
-	int output_count;
+	struct vpif_display_chan_config chan_config[VPIF_DISPLAY_MAX_CHANNELS];
 	const char *card_name;
-	bool ch2_clip_en;
-	bool ch3_clip_en;
 };
 
 struct vpif_input {
-- 
1.7.4.1

