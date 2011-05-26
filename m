Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab1EZAHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 20:07:48 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5907 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab1EZAGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 20:06:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 25 May 2011 17:06:40 -0700
From: <achew@nvidia.com>
To: <g.liakhovetski@gmx.de>, <mchehab@redhat.com>, <olof@lixom.net>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Chew <achew@nvidia.com>
Subject: [PATCH 5/5 v2] [media] ov9740: Add suspend/resume
Date: Wed, 25 May 2011 17:04:32 -0700
Message-ID: <1306368272-28279-5-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306368272-28279-1-git-send-email-achew@nvidia.com>
References: <1306368272-28279-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Chew <achew@nvidia.com>

On suspend, remember whether we are streaming or not, and at what frame format,
so that on resume, we can start streaming again.

Signed-off-by: Andrew Chew <achew@nvidia.com>
---
 drivers/media/video/ov9740.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
index 6c28ae8..4abe943 100644
--- a/drivers/media/video/ov9740.c
+++ b/drivers/media/video/ov9740.c
@@ -201,6 +201,10 @@ struct ov9740_priv {
 
 	bool				flag_vflip;
 	bool				flag_hflip;
+
+	/* For suspend/resume. */
+	struct v4l2_mbus_framefmt	current_mf;
+	int				current_enable;
 };
 
 static const struct ov9740_reg ov9740_defaults[] = {
@@ -551,6 +555,8 @@ static int ov9740_s_stream(struct v4l2_subdev *sd, int enable)
 					       0x00);
 	}
 
+	priv->current_enable = enable;
+
 	return ret;
 }
 
@@ -786,6 +792,7 @@ static int ov9740_s_fmt(struct v4l2_subdev *sd,
 			struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov9740_priv *priv = to_ov9740(sd);
 	enum v4l2_colorspace cspace;
 	enum v4l2_mbus_pixelcode code = mf->code;
 	int ret;
@@ -812,6 +819,8 @@ static int ov9740_s_fmt(struct v4l2_subdev *sd,
 	mf->code	= code;
 	mf->colorspace	= cspace;
 
+	memcpy(&priv->current_mf, mf, sizeof(struct v4l2_mbus_framefmt));
+
 	return ret;
 }
 
@@ -922,7 +931,37 @@ err:
 	return ret;
 }
 
+static int ov9740_suspend(struct soc_camera_device *icd, pm_message_t state)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct ov9740_priv *priv = to_ov9740(sd);
+
+	if (priv->current_enable) {
+		int current_enable = priv->current_enable;
+
+		ov9740_s_stream(sd, 0);
+		priv->current_enable = current_enable;
+	}
+
+	return 0;
+}
+
+static int ov9740_resume(struct soc_camera_device *icd)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct ov9740_priv *priv = to_ov9740(sd);
+
+	if (priv->current_enable) {
+		ov9740_s_fmt(sd, &priv->current_mf);
+		ov9740_s_stream(sd, priv->current_enable);
+	}
+
+	return 0;
+}
+
 static struct soc_camera_ops ov9740_ops = {
+	.suspend		= ov9740_suspend,
+	.resume			= ov9740_resume,
 	.set_bus_param		= ov9740_set_bus_param,
 	.query_bus_param	= ov9740_query_bus_param,
 	.controls		= ov9740_controls,
-- 
1.7.5.2

