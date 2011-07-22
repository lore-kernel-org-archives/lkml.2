Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab1GVUBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 16:01:10 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:49796 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755164Ab1GVUBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 16:01:08 -0400
To: Joerg Heckenbach <joerg@heckenbach-aw.de>
Subject: [PATCH] [resend] usbvision: disable scaling for Nogatech MicroCam
Cc: Dwaine Garden <dwainegarden@rogers.com>, linux-media@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Hans Verkuil" <hverkuil@xs4all.nl>
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Fri, 22 Jul 2011 22:00:50 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107222200.55834.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scaling causes bad artifacts (horizontal lines) with compression at least
with Nogatech MicroCam so disable it (for this HW).

This also fixes messed up image with some programs (Cheese with 160x120,
Adobe Flash). HW seems to support only image widths that are multiple of 64
but the driver does not account that in vidioc_try_fmt_vid_cap(). Cheese
calls try_fmt with 160x120, succeeds and then assumes that it really gets
data in that resolution - but it gets 128x120 instead. Don't know if this
affects other usbvision devices, it would be great if someone could test it.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

diff -urp linux-2.6.39-rc2-/drivers/media/video/usbvision//usbvision-video.c linux-2.6.39-rc2/drivers/media/video/usbvision/usbvision-video.c
--- linux-2.6.39-rc2-/drivers/media/video/usbvision//usbvision-video.c	2011-07-16 16:42:35.000000000 +0200
+++ linux-2.6.39-rc2/drivers/media/video/usbvision/usbvision-video.c	2011-07-16 16:36:43.000000000 +0200
@@ -924,6 +924,11 @@ static int vidioc_try_fmt_vid_cap(struct
 	RESTRICT_TO_RANGE(vf->fmt.pix.width, MIN_FRAME_WIDTH, MAX_FRAME_WIDTH);
 	RESTRICT_TO_RANGE(vf->fmt.pix.height, MIN_FRAME_HEIGHT, MAX_FRAME_HEIGHT);
 
+	if (usbvision_device_data[usbvision->dev_model].codec == CODEC_WEBCAM) {
+		vf->fmt.pix.width = MAX_FRAME_WIDTH;
+		vf->fmt.pix.height = MAX_FRAME_HEIGHT;
+	}
+
 	vf->fmt.pix.bytesperline = vf->fmt.pix.width*
 		usbvision->palette.bytes_per_pixel;
 	vf->fmt.pix.sizeimage = vf->fmt.pix.bytesperline*vf->fmt.pix.height;
@@ -952,6 +957,11 @@ static int vidioc_s_fmt_vid_cap(struct f
 
 	usbvision->cur_frame = NULL;
 
+	if (usbvision_device_data[usbvision->dev_model].codec == CODEC_WEBCAM) {
+		vf->fmt.pix.width = MAX_FRAME_WIDTH;
+		vf->fmt.pix.height = MAX_FRAME_HEIGHT;
+	}
+
 	/* by now we are committed to the new data... */
 	usbvision_set_output(usbvision, vf->fmt.pix.width, vf->fmt.pix.height);
 

-- 
Ondrej Zary
