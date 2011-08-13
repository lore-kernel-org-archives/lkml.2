Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab1HMJKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 05:10:12 -0400
Received: from www17.your-server.de ([213.133.104.17]:58924 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1HMJKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 05:10:08 -0400
Subject: [PATCH] staging/easycap: Use memdup_user
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Tomas Winkler <tomas.winkler@intel.com>, devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 13 Aug 2011 11:09:26 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313226571.16820.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use kmemdup_user rather than duplicating its implementation
 This is a little bit restricted to reduce false positives

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/memdup_user.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff --git a/drivers/staging/easycap/easycap_ioctl.c b/drivers/staging/easycap/easycap_ioctl.c
index 0accab9..91262fb 100644
--- a/drivers/staging/easycap/easycap_ioctl.c
+++ b/drivers/staging/easycap/easycap_ioctl.c
@@ -1317,17 +1317,12 @@ long easycap_unlocked_ioctl(struct file *file,
 		struct v4l2_control *pv4l2_control;
 
 		JOM(8, "VIDIOC_G_CTRL\n");
-		pv4l2_control = kzalloc(sizeof(struct v4l2_control), GFP_KERNEL);
-		if (!pv4l2_control) {
-			SAM("ERROR: out of memory\n");
+		pv4l2_control = memdup_user((void __user *)arg,
+					    sizeof(struct v4l2_control));
+		if (IS_ERR(pv4l2_control)) {
+			SAM("ERROR: copy from user failed\n");
 			mutex_unlock(&easycapdc60_dongle[kd].mutex_video);
-			return -ENOMEM;
-		}
-		if (0 != copy_from_user(pv4l2_control, (void __user *)arg,
-				sizeof(struct v4l2_control))) {
-			kfree(pv4l2_control);
-			mutex_unlock(&easycapdc60_dongle[kd].mutex_video);
-			return -EFAULT;
+			return PTR_ERR(pv4l2_control);
 		}
 
 		switch (pv4l2_control->id) {
@@ -2356,17 +2351,12 @@ long easycap_unlocked_ioctl(struct file *file,
 		struct v4l2_streamparm *pv4l2_streamparm;
 
 		JOM(8, "VIDIOC_G_PARM\n");
-		pv4l2_streamparm = kzalloc(sizeof(struct v4l2_streamparm), GFP_KERNEL);
-		if (!pv4l2_streamparm) {
-			SAM("ERROR: out of memory\n");
-			mutex_unlock(&easycapdc60_dongle[kd].mutex_video);
-			return -ENOMEM;
-		}
-		if (copy_from_user(pv4l2_streamparm,
-			(void __user *)arg, sizeof(struct v4l2_streamparm))) {
-			kfree(pv4l2_streamparm);
+		pv4l2_streamparm = memdup_user((void __user *)arg,
+					       sizeof(struct v4l2_streamparm));
+		if (IS_ERR(pv4l2_streamparm)) {
+			SAM("ERROR: copy from user failed\n");
 			mutex_unlock(&easycapdc60_dongle[kd].mutex_video);
-			return -EFAULT;
+			return PTR_ERR(pv4l2_streamparm);
 		}
 
 		if (pv4l2_streamparm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {



