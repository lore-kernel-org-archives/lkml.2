Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab2HOTvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:51:25 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62984 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613Ab2HOTvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:21 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ming Lei <tom.leiming@gmail.com>, Ming Lei <ming.lei@canonical.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 093/165] uvcvideo: Set alternate setting 0 on resume if the bus has been reset
Date: Wed, 15 Aug 2012 15:47:17 -0400
Message-ID: <1345060109-9187-94-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d59a7b1dbce8b972ec2dc9fcaaae0bfa23687423 upstream.

If the bus has been reset on resume, set the alternate setting to 0.
This should be the default value, but some devices crash or otherwise
misbehave if they don't receive a SET_INTERFACE request before any other
video control request.

Microdia's 0c45:6437 camera has been found to require this change or it
will stop sending video data after resume.

uvc_video.c]

Signed-off-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/media/video/uvc/uvc_driver.c |  2 +-
 drivers/media/video/uvc/uvc_video.c  | 10 +++++++++-
 drivers/media/video/uvc/uvcvideo.h   |  2 +-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 838b56f..590b817 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -1885,7 +1885,7 @@ static int __uvc_resume(struct usb_interface *intf, int reset)
 
 	list_for_each_entry(stream, &dev->streams, list) {
 		if (stream->intf == intf)
-			return uvc_video_resume(stream);
+			return uvc_video_resume(stream, reset);
 	}
 
 	uvc_trace(UVC_TRACE_SUSPEND, "Resume: video streaming USB interface "
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 687c970..a96f9ea 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -1056,10 +1056,18 @@ int uvc_video_suspend(struct uvc_streaming *stream)
  * buffers, making sure userspace applications are notified of the problem
  * instead of waiting forever.
  */
-int uvc_video_resume(struct uvc_streaming *stream)
+int uvc_video_resume(struct uvc_streaming *stream, int reset)
 {
 	int ret;
 
+	/* If the bus has been reset on resume, set the alternate setting to 0.
+	 * This should be the default value, but some devices crash or otherwise
+	 * misbehave if they don't receive a SET_INTERFACE request before any
+	 * other video control request.
+	 */
+	if (reset)
+		usb_set_interface(stream->dev->udev, stream->intfnum, 0);
+
 	stream->frozen = 0;
 
 	ret = uvc_commit_video(stream, &stream->ctrl);
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index d1f8840..1180ec7 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -596,7 +596,7 @@ extern const struct v4l2_file_operations uvc_fops;
 /* Video */
 extern int uvc_video_init(struct uvc_streaming *stream);
 extern int uvc_video_suspend(struct uvc_streaming *stream);
-extern int uvc_video_resume(struct uvc_streaming *stream);
+extern int uvc_video_resume(struct uvc_streaming *stream, int reset);
 extern int uvc_video_enable(struct uvc_streaming *stream, int enable);
 extern int uvc_probe_video(struct uvc_streaming *stream,
 		struct uvc_streaming_control *probe);
-- 
1.7.12.rc2

