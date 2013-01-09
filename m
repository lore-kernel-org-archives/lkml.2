Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab3AINmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 08:42:00 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:43184 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab3AINl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 08:41:58 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, Sekhar Nori <nsekhar@ti.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH RFC 1/3] davinci: vpif: capture: add V4L2-async support
Date: Wed,  9 Jan 2013 19:11:25 +0530
Message-Id: <1357738887-8701-2-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357738887-8701-1-git-send-email-prabhakar.lad@ti.com>
References: <1357738887-8701-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for asynchronous subdevice probing, using the v4l2-async API.
The legacy synchronous mode is still supported too, which allows to
gradually update drivers and platforms. The selected approach adds a
notifier for each struct soc_camera_device instance, i.e. for each video
device node, even when there are multiple such instances registered with a
single soc-camera host simultaneously.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/platform/davinci/vpif_capture.c |  171 ++++++++++++++++++-------
 drivers/media/platform/davinci/vpif_capture.h |    2 +
 include/media/davinci/vpif_types.h            |    2 +
 3 files changed, 128 insertions(+), 47 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 5892d2b..a8b6588 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -34,6 +34,8 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+
+#include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-chip-ident.h>
@@ -2054,6 +2056,96 @@ vpif_init_free_channel_objects:
 	return err;
 }
 
+int vpif_async_bound(struct v4l2_async_notifier *notifier,
+		    struct v4l2_async_subdev_list *asdl)
+{
+	int i = 0;
+
+	if (!asdl->subdev) {
+		v4l2_err(vpif_dev->driver,
+			 "%s(): Subdevice driver hasn't set subdev pointer!\n",
+			__func__);
+		return -EINVAL;
+	}
+	v4l2_info(&vpif_obj.v4l2_dev, "registered sub device %s\n",
+			 asdl->subdev->name);
+
+	for (i = 0; i < vpif_obj.config->subdev_count; i++)
+		if (!strcmp(vpif_obj.config->subdev_info[i].name,
+			asdl->subdev->name)) {
+			vpif_obj.sd[i] = asdl->subdev;
+			break;
+		}
+
+	if (i >= vpif_obj.config->subdev_count)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int vpif_probe_complete(void)
+{
+	struct common_obj *common;
+	struct channel_obj *ch;
+	int i, j, err, k;
+
+	for (j = 0; j < VPIF_CAPTURE_MAX_DEVICES; j++) {
+		ch = vpif_obj.dev[j];
+		ch->channel_id = j;
+		common = &(ch->common[VPIF_VIDEO_INDEX]);
+		spin_lock_init(&common->irqlock);
+		mutex_init(&common->lock);
+		ch->video_dev->lock = &common->lock;
+		/* Initialize prio member of channel object */
+		v4l2_prio_init(&ch->prio);
+		video_set_drvdata(ch->video_dev, ch);
+
+		/* select input 0 */
+		err = vpif_set_input(vpif_obj.config, ch, 0);
+		if (err)
+			goto probe_out;
+
+		err = video_register_device(ch->video_dev,
+					    VFL_TYPE_GRABBER, (j ? 1 : 0));
+		if (err)
+			goto probe_out;
+	}
+
+	v4l2_info(&vpif_obj.v4l2_dev, "VPIF capture driver initialized\n");
+	return 0;
+
+probe_out:
+	for (k = 0; k < j; k++) {
+		/* Get the pointer to the channel object */
+		ch = vpif_obj.dev[k];
+		/* Unregister video device */
+		video_unregister_device(ch->video_dev);
+	}
+	kfree(vpif_obj.sd);
+	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
+		ch = vpif_obj.dev[i];
+		/* Note: does nothing if ch->video_dev == NULL */
+		video_device_release(ch->video_dev);
+	}
+	v4l2_device_unregister(&vpif_obj.v4l2_dev);
+
+	return err;
+}
+
+int vpif_async_complete(struct v4l2_async_notifier *notifier)
+{
+	return vpif_probe_complete();
+}
+
+void vpif_async_unbind(struct v4l2_async_notifier *notifier,
+		    struct v4l2_async_subdev_list *asdl)
+{
+	/*FIXME: Do we need this callback ? */
+	v4l2_info(&vpif_obj.v4l2_dev, "unregistered sub device %s\n",
+			 asdl->subdev->name);
+	return;
+}
+
 /**
  * vpif_probe : This function probes the vpif capture driver
  * @pdev: platform device pointer
@@ -2064,12 +2156,10 @@ vpif_init_free_channel_objects:
 static __init int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
-	struct vpif_capture_config *config;
-	int i, j, k, err;
+	int i, j, err;
 	int res_idx = 0;
 	struct i2c_adapter *i2c_adap;
 	struct channel_obj *ch;
-	struct common_obj *common;
 	struct video_device *vfd;
 	struct resource *res;
 	int subdev_count;
@@ -2146,10 +2236,9 @@ static __init int vpif_probe(struct platform_device *pdev)
 		}
 	}
 
-	i2c_adap = i2c_get_adapter(1);
-	config = pdev->dev.platform_data;
+	vpif_obj.config = pdev->dev.platform_data;
 
-	subdev_count = config->subdev_count;
+	subdev_count = vpif_obj.config->subdev_count;
 	vpif_obj.sd = kzalloc(sizeof(struct v4l2_subdev *) * subdev_count,
 				GFP_KERNEL);
 	if (vpif_obj.sd == NULL) {
@@ -2158,53 +2247,41 @@ static __init int vpif_probe(struct platform_device *pdev)
 		goto vpif_sd_error;
 	}
 
-	for (i = 0; i < subdev_count; i++) {
-		subdevdata = &config->subdev_info[i];
-		vpif_obj.sd[i] =
-			v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
-						  i2c_adap,
-						  &subdevdata->board_info,
-						  NULL);
+	if (!vpif_obj.config->asd_sizes) {
+		i2c_adap = i2c_get_adapter(1);
+		for (i = 0; i < subdev_count; i++) {
+			subdevdata = &vpif_obj.config->subdev_info[i];
+			vpif_obj.sd[i] =
+				v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
+							i2c_adap,
+							&subdevdata->board_info,
+							NULL);
 
-		if (!vpif_obj.sd[i]) {
-			vpif_err("Error registering v4l2 subdevice\n");
-			goto probe_subdev_out;
+			if (!vpif_obj.sd[i]) {
+				vpif_err("Error registering v4l2 subdevice\n");
+				goto probe_subdev_out;
+			}
+			v4l2_info(&vpif_obj.v4l2_dev, "registered sub device %s\n",
+				subdevdata->name);
+		}
+		vpif_probe_complete();
+	} else {
+		vpif_obj.notifier.subdev = vpif_obj.config->asd;
+		vpif_obj.notifier.subdev_num = vpif_obj.config->asd_sizes[0];
+		vpif_obj.notifier.bound = vpif_async_bound;
+		vpif_obj.notifier.complete = vpif_async_complete;
+		vpif_obj.notifier.unbind = vpif_async_unbind;
+		err = v4l2_async_notifier_register(&vpif_obj.v4l2_dev,
+						   &vpif_obj.notifier);
+		if (err) {
+			vpif_err("Error registering async notifier\n");
+			err = -EINVAL;
+			goto vpif_sd_error;
 		}
-		v4l2_info(&vpif_obj.v4l2_dev, "registered sub device %s\n",
-			  subdevdata->name);
 	}
 
-	for (j = 0; j < VPIF_CAPTURE_MAX_DEVICES; j++) {
-		ch = vpif_obj.dev[j];
-		ch->channel_id = j;
-		common = &(ch->common[VPIF_VIDEO_INDEX]);
-		spin_lock_init(&common->irqlock);
-		mutex_init(&common->lock);
-		ch->video_dev->lock = &common->lock;
-		/* Initialize prio member of channel object */
-		v4l2_prio_init(&ch->prio);
-		video_set_drvdata(ch->video_dev, ch);
-
-		/* select input 0 */
-		err = vpif_set_input(config, ch, 0);
-		if (err)
-			goto probe_out;
-
-		err = video_register_device(ch->video_dev,
-					    VFL_TYPE_GRABBER, (j ? 1 : 0));
-		if (err)
-			goto probe_out;
-	}
-	v4l2_info(&vpif_obj.v4l2_dev, "VPIF capture driver initialized\n");
 	return 0;
 
-probe_out:
-	for (k = 0; k < j; k++) {
-		/* Get the pointer to the channel object */
-		ch = vpif_obj.dev[k];
-		/* Unregister video device */
-		video_unregister_device(ch->video_dev);
-	}
 probe_subdev_out:
 	/* free sub devices memory */
 	kfree(vpif_obj.sd);
diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
index 3d3c1e5..1be47ab 100644
--- a/drivers/media/platform/davinci/vpif_capture.h
+++ b/drivers/media/platform/davinci/vpif_capture.h
@@ -145,6 +145,8 @@ struct vpif_device {
 	struct v4l2_device v4l2_dev;
 	struct channel_obj *dev[VPIF_CAPTURE_NUM_CHANNELS];
 	struct v4l2_subdev **sd;
+	struct v4l2_async_notifier notifier;
+	struct vpif_capture_config *config;
 };
 
 struct vpif_config_params {
diff --git a/include/media/davinci/vpif_types.h b/include/media/davinci/vpif_types.h
index 3882e06..e08bcde 100644
--- a/include/media/davinci/vpif_types.h
+++ b/include/media/davinci/vpif_types.h
@@ -81,5 +81,7 @@ struct vpif_capture_config {
 	struct vpif_subdev_info *subdev_info;
 	int subdev_count;
 	const char *card_name;
+	struct v4l2_async_subdev **asd;	/* Flat array, arranged in groups */
+	int *asd_sizes;		/* 0-terminated array of asd group sizes */
 };
 #endif /* _VPIF_TYPES_H */
-- 
1.7.4.1

