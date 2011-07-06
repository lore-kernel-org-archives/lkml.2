Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1GFSEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:04:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361Ab1GFSEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:04:42 -0400
Date: Wed, 6 Jul 2011 15:04:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv3 16/17] [media] v4l2 core: return -ENOTTY if an ioctl
 doesn't exist
Message-ID: <20110706150403.5ddb7a30@pedra>
In-Reply-To: <cover.1309974026.git.mchehab@redhat.com>
References: <cover.1309974026.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, -EINVAL is used to return either when an IOCTL is not
implemented, or if the ioctl was not implemented.

Note: Drivers that don't use video_ioctl2, will need extra patches.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/v4l/gen-errors.xml b/Documentation/DocBook/media/v4l/gen-errors.xml
index dedcc90..8117c60 100644
--- a/Documentation/DocBook/media/v4l/gen-errors.xml
+++ b/Documentation/DocBook/media/v4l/gen-errors.xml
@@ -30,13 +30,6 @@
 	       ioctl requests for specific causes.</entry>
       </row>
       <row>
-	<entry>EINVAL or ENOTTY</entry>
-	<entry>The ioctl is not supported by the driver, actually meaning that
-	       the required functionality is not available, or the file
-	       descriptor is not for a media device. The usage of EINVAL is
-	       deprecated and will be fixed on a latter patch.</entry>
-      </row>
-      <row>
         <entry>ENODEV</entry>
 	<entry>Device not found or was removed.</entry>
       </row>
@@ -45,6 +38,12 @@
 	<entry>There's not enough memory to handle the desired operation.</entry>
       </row>
       <row>
+	<entry>ENOTTY</entry>
+	<entry>The ioctl is not supported by the driver, actually meaning that
+	       the required functionality is not available, or the file
+	       descriptor is not for a media device.</entry>
+      </row>
+      <row>
 	<entry>ENOSPC</entry>
 	<entry>On USB devices, the stream ioctl's can return this error, meaning
 	       that this request would overcommit the usb bandwidth reserved
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index c5ee398..43386a6 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -132,7 +132,9 @@ applications. -->
 	<date>2011-06-27</date>
 	<authorinitials>mcc, po</authorinitials>
 	<revremark>Documented that VIDIOC_QUERYCAP now returns a per-subsystem version instead of a per-driver one.</revremark>
+	<revremark>Standardize an error code for invalid ioctl.</revremark>
       </revision>
+
       <revision>
 	<revnumber>2.6.39</revnumber>
 	<date>2011-03-01</date>
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index f9aebac..4253276 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -543,12 +543,12 @@ static long __video_do_ioctl(struct file *file,
 	struct v4l2_fh *vfh = NULL;
 	struct v4l2_format f_copy;
 	int use_fh_prio = 0;
-	long ret = -EINVAL;
+	long ret = -ENOTTY;
 
 	if (ops == NULL) {
 		printk(KERN_WARNING "videodev: \"%s\" has no ioctl_ops.\n",
 				vfd->name);
-		return -EINVAL;
+		return ret;
 	}
 
 	if ((vfd->debug & V4L2_DEBUG_IOCTL) &&
-- 
1.7.1


