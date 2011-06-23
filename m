Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964931Ab1FWXVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:21:17 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16518 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934556Ab1FWXUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:20:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 23 Jun 2011 16:20:00 -0700
From: <achew@nvidia.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
CC: <g.liakhovetski@gmx.de>, <mchehab@redhat.com>, <olof@lixom.net>,
        Andrew Chew <achew@nvidia.com>
Subject: [PATCH 6/6 v3] [media] ov9740: Add suspend/resume
Date: Thu, 23 Jun 2011 16:19:44 -0700
Message-ID: <1308871184-6307-6-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308871184-6307-1-git-send-email-achew@nvidia.com>
References: <1308871184-6307-1-git-send-email-achew@nvidia.com>
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
 drivers/media/video/ov9740.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
index cd63eaa..ede48f2 100644
--- a/drivers/media/video/ov9740.c
+++ b/drivers/media/video/ov9740.c
@@ -201,6 +201,10 @@ struct ov9740_priv {
 
 	bool				flag_vflip;
 	bool				flag_hflip;
+
+	/* For suspend/resume. */
+	struct v4l2_mbus_framefmt	current_mf;
+	bool				current_enable;
 };
 
 static const struct ov9740_reg ov9740_defaults[] = {
@@ -551,6 +555,8 @@ static int ov9740_s_stream(struct v4l2_subdev *sd, int enable)
 					       0x00);
 	}
 
+	priv->current_enable = enable;
+
 	return ret;
 }
 
@@ -702,6 +708,7 @@ static int ov9740_s_fmt(struct v4l2_subdev *sd,
 			struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov9740_priv *priv = to_ov9740(sd);
 	enum v4l2_colorspace cspace;
 	enum v4l2_mbus_pixelcode code = mf->code;
 	int ret;
@@ -728,6 +735,8 @@ static int ov9740_s_fmt(struct v4l2_subdev *sd,
 	mf->code	= code;
 	mf->colorspace	= cspace;
 
+	memcpy(&priv->current_mf, mf, sizeof(struct v4l2_mbus_framefmt));
+
 	return ret;
 }
 
@@ -829,6 +838,24 @@ static int ov9740_g_chip_ident(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int ov9740_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct ov9740_priv *priv = to_ov9740(sd);
+
+	if (!priv->current_enable)
+		return 0;
+
+	if (on) {
+		ov9740_s_fmt(sd, &priv->current_mf);
+		ov9740_s_stream(sd, priv->current_enable);
+	} else {
+		ov9740_s_stream(sd, 0);
+		priv->current_enable = true;
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int ov9740_get_register(struct v4l2_subdev *sd,
 			       struct v4l2_dbg_register *reg)
@@ -942,6 +969,7 @@ static struct v4l2_subdev_core_ops ov9740_core_ops = {
 	.g_ctrl			= ov9740_g_ctrl,
 	.s_ctrl			= ov9740_s_ctrl,
 	.g_chip_ident		= ov9740_g_chip_ident,
+	.s_power		= ov9740_s_power,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register		= ov9740_get_register,
 	.s_register		= ov9740_set_register,
-- 
1.7.5.4

