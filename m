Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375Ab2JWT6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:58:52 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:61542 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488Ab2JWT6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:58:49 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Cc: Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Ezequiel Garcia <elezegarcia@gmail.com>, Mike Isely <isely@pobox.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 06/23] pvrusb2: Replace memcpy with struct assignment
Date: Tue, 23 Oct 2012 16:57:09 -0300
Message-Id: <1351022246-8201-6-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
References: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This kind of memcpy() is error-prone. Its replacement with a struct
assignment is prefered because it's type-safe and much easier to read.

Found by coccinelle. Hand patched and reviewed.
Tested by compilation only.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier struct_name;
struct struct_name to;
struct struct_name from;
expression E;
@@
-memcpy(&(to), &(from), E);
+to = from;
// </smpl>

Cc: Mike Isely <isely@pobox.com>
Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-encoder.c  |    3 +--
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c |    4 ++--
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c     |    2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-encoder.c b/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
index e046fda..f7702ae 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
@@ -422,8 +422,7 @@ int pvr2_encoder_adjust(struct pvr2_hdw *hdw)
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "Error from cx2341x module code=%d",ret);
 	} else {
-		memcpy(&hdw->enc_cur_state,&hdw->enc_ctl_state,
-		       sizeof(struct cx2341x_mpeg_params));
+		hdw->enc_cur_state = hdw->enc_ctl_state;
 		hdw->enc_cur_valid = !0;
 	}
 	return ret;
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
index 885ce11..9691156 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
@@ -649,8 +649,8 @@ void pvr2_i2c_core_init(struct pvr2_hdw *hdw)
 	}
 
 	// Configure the adapter and set up everything else related to it.
-	memcpy(&hdw->i2c_adap,&pvr2_i2c_adap_template,sizeof(hdw->i2c_adap));
-	memcpy(&hdw->i2c_algo,&pvr2_i2c_algo_template,sizeof(hdw->i2c_algo));
+	hdw->i2c_adap = pvr2_i2c_adap_template;
+	hdw->i2c_algo = pvr2_i2c_algo_template;
 	strlcpy(hdw->i2c_adap.name,hdw->name,sizeof(hdw->i2c_adap.name));
 	hdw->i2c_adap.dev.parent = &hdw->usb_dev->dev;
 	hdw->i2c_adap.algo = &hdw->i2c_algo;
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index db249ca..5b622ec 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -1339,7 +1339,7 @@ static void pvr2_v4l2_dev_init(struct pvr2_v4l2_dev *dip,
 		return;
 	}
 
-	memcpy(&dip->devbase,&vdev_template,sizeof(vdev_template));
+	dip->devbase = vdev_template;
 	dip->devbase.release = pvr2_video_device_release;
 	dip->devbase.ioctl_ops = &pvr2_ioctl_ops;
 	{
-- 
1.7.4.4

