Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965066Ab2DKXSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:18:37 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:40940 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965054Ab2DKXSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:18:35 -0400
Message-Id: <20120411231030.729016281@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 73/78] [media] uvcvideo: Fix race-related crash in uvc_video_clock_update()
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit ed0ee0ce0a3224dab5caa088a5f8b6df25924276 upstream.

The driver frees the clock samples buffer before stopping the video
buffers queue. If a DQBUF call arrives in-between,
uvc_video_clock_update() will be called with a NULL clock samples
buffer, leading to a crash. This occurs very frequently when using the
webcam with the flash browser plugin.

Move clock initialization/cleanup to uvc_video_enable() in order to free
the clock samples buffer after the queue is stopped. Make sure the clock
is reset at resume time to avoid miscalculating timestamps.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/uvc/uvc_video.c |   50 +++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 18 deletions(-)

--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -468,22 +468,30 @@ uvc_video_clock_decode(struct uvc_stream
 	spin_unlock_irqrestore(&stream->clock.lock, flags);
 }
 
-static int uvc_video_clock_init(struct uvc_streaming *stream)
+static void uvc_video_clock_reset(struct uvc_streaming *stream)
 {
 	struct uvc_clock *clock = &stream->clock;
 
-	spin_lock_init(&clock->lock);
 	clock->head = 0;
 	clock->count = 0;
-	clock->size = 32;
 	clock->last_sof = -1;
 	clock->sof_offset = -1;
+}
+
+static int uvc_video_clock_init(struct uvc_streaming *stream)
+{
+	struct uvc_clock *clock = &stream->clock;
+
+	spin_lock_init(&clock->lock);
+	clock->size = 32;
 
 	clock->samples = kmalloc(clock->size * sizeof(*clock->samples),
 				 GFP_KERNEL);
 	if (clock->samples == NULL)
 		return -ENOMEM;
 
+	uvc_video_clock_reset(stream);
+
 	return 0;
 }
 
@@ -1424,8 +1432,6 @@ static void uvc_uninit_video(struct uvc_
 
 	if (free_buffers)
 		uvc_free_urb_buffers(stream);
-
-	uvc_video_clock_cleanup(stream);
 }
 
 /*
@@ -1555,10 +1561,6 @@ static int uvc_init_video(struct uvc_str
 
 	uvc_video_stats_start(stream);
 
-	ret = uvc_video_clock_init(stream);
-	if (ret < 0)
-		return ret;
-
 	if (intf->num_altsetting > 1) {
 		struct usb_host_endpoint *best_ep = NULL;
 		unsigned int best_psize = 3 * 1024;
@@ -1683,6 +1685,8 @@ int uvc_video_resume(struct uvc_streamin
 
 	stream->frozen = 0;
 
+	uvc_video_clock_reset(stream);
+
 	ret = uvc_commit_video(stream, &stream->ctrl);
 	if (ret < 0) {
 		uvc_queue_enable(&stream->queue, 0);
@@ -1819,25 +1823,35 @@ int uvc_video_enable(struct uvc_streamin
 		uvc_uninit_video(stream, 1);
 		usb_set_interface(stream->dev->udev, stream->intfnum, 0);
 		uvc_queue_enable(&stream->queue, 0);
+		uvc_video_clock_cleanup(stream);
 		return 0;
 	}
 
-	ret = uvc_queue_enable(&stream->queue, 1);
+	ret = uvc_video_clock_init(stream);
 	if (ret < 0)
 		return ret;
 
+	ret = uvc_queue_enable(&stream->queue, 1);
+	if (ret < 0)
+		goto error_queue;
+
 	/* Commit the streaming parameters. */
 	ret = uvc_commit_video(stream, &stream->ctrl);
-	if (ret < 0) {
-		uvc_queue_enable(&stream->queue, 0);
-		return ret;
-	}
+	if (ret < 0)
+		goto error_commit;
 
 	ret = uvc_init_video(stream, GFP_KERNEL);
-	if (ret < 0) {
-		usb_set_interface(stream->dev->udev, stream->intfnum, 0);
-		uvc_queue_enable(&stream->queue, 0);
-	}
+	if (ret < 0)
+		goto error_video;
+
+	return 0;
+
+error_video:
+	usb_set_interface(stream->dev->udev, stream->intfnum, 0);
+error_commit:
+	uvc_queue_enable(&stream->queue, 0);
+error_queue:
+	uvc_video_clock_cleanup(stream);
 
 	return ret;
 }


