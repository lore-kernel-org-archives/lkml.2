Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab1KCCCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:02:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933889Ab1KCBiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:38:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:57 2011
Message-Id: <20111102221457.520831839@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ming Lei <ming.lei@canonical.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [081/107] [media] uvcvideo: Set alternate setting 0 on resume if the bus has been reset
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ming Lei <tom.leiming@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_driver.c |    2 +-
 drivers/media/video/uvc/uvc_video.c  |   10 +++++++++-
 drivers/media/video/uvc/uvcvideo.h   |    2 +-
 3 files changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -1889,7 +1889,7 @@ static int __uvc_resume(struct usb_inter
 
 	list_for_each_entry(stream, &dev->streams, list) {
 		if (stream->intf == intf)
-			return uvc_video_resume(stream);
+			return uvc_video_resume(stream, reset);
 	}
 
 	uvc_trace(UVC_TRACE_SUSPEND, "Resume: video streaming USB interface "
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -1024,10 +1024,18 @@ int uvc_video_suspend(struct uvc_streami
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
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -608,7 +608,7 @@ extern const struct v4l2_file_operations
 /* Video */
 extern int uvc_video_init(struct uvc_streaming *stream);
 extern int uvc_video_suspend(struct uvc_streaming *stream);
-extern int uvc_video_resume(struct uvc_streaming *stream);
+extern int uvc_video_resume(struct uvc_streaming *stream, int reset);
 extern int uvc_video_enable(struct uvc_streaming *stream, int enable);
 extern int uvc_probe_video(struct uvc_streaming *stream,
 		struct uvc_streaming_control *probe);


