Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab1FKN3S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 09:29:18 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:56460 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755535Ab1FKN3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 09:29:14 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] tea575x: allow multiple opens
Date: Sat, 11 Jun 2011 15:28:59 +0200
User-Agent: KMail/1.9.10
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106111529.04319.linux@rainbow-software.org>
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
