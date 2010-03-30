Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab0C3XMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:12:42 -0400
Received: from kroah.org ([198.145.64.141]:49083 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756492Ab0C3XMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:40 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:41 2010
Message-Id: <20100330225841.291902026@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Brandon Philips <bphilips@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [53/89] V4L/DVB (13155): uvcvideo: Add a module parameter to set the streaming control timeout
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

commit b232a012adfea9f535702e8296ea6b76e691f436 upstream

The default streaming control timeout was found by Ondrej Zary to be too low
for some Logitech webcams. With kernel 2.6.22 and newer they would timeout
during initialization unles the audio function was initialized before the
video function.

Add a module parameter to set the streaming control timeout and increase the
default value from 1000ms to 3000ms to fix the above problem.

Thanks to Ondrej Zary for investigating the issue and providing an initial
patch.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Brandon Philips <bphilips@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_driver.c |    3 +++
 drivers/media/video/uvc/uvc_video.c  |    4 ++--
 drivers/media/video/uvc/uvcvideo.h   |    3 ++-
 3 files changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -46,6 +46,7 @@
 unsigned int uvc_no_drop_param;
 static unsigned int uvc_quirks_param;
 unsigned int uvc_trace_param;
+unsigned int uvc_timeout_param = UVC_CTRL_STREAMING_TIMEOUT;
 
 /* ------------------------------------------------------------------------
  * Video formats
@@ -2034,6 +2035,8 @@ module_param_named(quirks, uvc_quirks_pa
 MODULE_PARM_DESC(quirks, "Forced device quirks");
 module_param_named(trace, uvc_trace_param, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(trace, "Trace level bitmask");
+module_param_named(timeout, uvc_timeout_param, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(timeout, "Streaming control requests timeout");
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -130,7 +130,7 @@ static int uvc_get_video_ctrl(struct uvc
 
 	ret = __uvc_query_ctrl(video->dev, query, 0, video->streaming->intfnum,
 		probe ? VS_PROBE_CONTROL : VS_COMMIT_CONTROL, data, size,
-		UVC_CTRL_STREAMING_TIMEOUT);
+		uvc_timeout_param);
 
 	if ((query == GET_MIN || query == GET_MAX) && ret == 2) {
 		/* Some cameras, mostly based on Bison Electronics chipsets,
@@ -235,7 +235,7 @@ static int uvc_set_video_ctrl(struct uvc
 	ret = __uvc_query_ctrl(video->dev, SET_CUR, 0,
 		video->streaming->intfnum,
 		probe ? VS_PROBE_CONTROL : VS_COMMIT_CONTROL, data, size,
-		UVC_CTRL_STREAMING_TIMEOUT);
+		uvc_timeout_param);
 	if (ret != size) {
 		uvc_printk(KERN_ERR, "Failed to set UVC %s control : "
 			"%d (exp. %u).\n", probe ? "probe" : "commit",
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -304,7 +304,7 @@ struct uvc_xu_control {
 #define UVC_MAX_STATUS_SIZE	16
 
 #define UVC_CTRL_CONTROL_TIMEOUT	300
-#define UVC_CTRL_STREAMING_TIMEOUT	1000
+#define UVC_CTRL_STREAMING_TIMEOUT	3000
 
 /* Devices quirks */
 #define UVC_QUIRK_STATUS_INTERVAL	0x00000001
@@ -695,6 +695,7 @@ struct uvc_driver {
 
 extern unsigned int uvc_no_drop_param;
 extern unsigned int uvc_trace_param;
+extern unsigned int uvc_timeout_param;
 
 #define uvc_trace(flag, msg...) \
 	do { \


