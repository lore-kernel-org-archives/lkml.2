Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab1FTTJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:09:45 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:50283 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755459Ab1FTTJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:09:43 -0400
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] [resend] tea575x: allow multiple opens
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Mon, 20 Jun 2011 21:09:25 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106202109.29164.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change locking to allow tea575x-radio device to be opened multiple times.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.39-rc2-/include/sound/tea575x-tuner.h	2011-06-11 15:21:50.000000000 +0200
+++ linux-2.6.39-rc2/include/sound/tea575x-tuner.h	2011-06-11 14:50:55.000000000 +0200
@@ -49,7 +49,7 @@ struct snd_tea575x {
 	bool tuned;			/* tuned to a station */
 	unsigned int val;		/* hw value */
 	unsigned long freq;		/* frequency */
-	unsigned long in_use;		/* set if the device is in use */
+	struct mutex mutex;
 	struct snd_tea575x_ops *ops;
 	void *private_data;
 	u8 card[32];
--- linux-2.6.39-rc2-/sound/i2c/other/tea575x-tuner.c	2011-06-11 15:21:50.000000000 +0200
+++ linux-2.6.39-rc2/sound/i2c/other/tea575x-tuner.c	2011-06-11 14:57:28.000000000 +0200
@@ -282,26 +282,9 @@ static int vidioc_s_input(struct file *f
 	return 0;
 }
 
-static int snd_tea575x_exclusive_open(struct file *file)
-{
-	struct snd_tea575x *tea = video_drvdata(file);
-
-	return test_and_set_bit(0, &tea->in_use) ? -EBUSY : 0;
-}
-
-static int snd_tea575x_exclusive_release(struct file *file)
-{
-	struct snd_tea575x *tea = video_drvdata(file);
-
-	clear_bit(0, &tea->in_use);
-	return 0;
-}
-
 static const struct v4l2_file_operations tea575x_fops = {
 	.owner		= THIS_MODULE,
-	.open           = snd_tea575x_exclusive_open,
-	.release        = snd_tea575x_exclusive_release,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops tea575x_ioctl_ops = {
@@ -340,13 +323,14 @@ int snd_tea575x_init(struct snd_tea575x
 	if (snd_tea575x_read(tea) != 0x55AA)
 		return -ENODEV;
 
-	tea->in_use = 0;
 	tea->val = TEA575X_BIT_BAND_FM | TEA575X_BIT_SEARCH_10_40;
 	tea->freq = 90500 * 16;		/* 90.5Mhz default */
 	snd_tea575x_set_freq(tea);
 
 	tea->vd = tea575x_radio;
 	video_set_drvdata(&tea->vd, tea);
+	mutex_init(&tea->mutex);
+	tea->vd.lock = &tea->mutex;
 
 	v4l2_ctrl_handler_init(&tea->ctrl_handler, 1);
 	tea->vd.ctrl_handler = &tea->ctrl_handler;


-- 
Ondrej Zary
