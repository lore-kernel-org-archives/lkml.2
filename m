Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab2JWT6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:58:16 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:34920 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781Ab2JWT6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:58:14 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Cc: Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 01/23] uvc: Replace memcpy with struct assignment
Date: Tue, 23 Oct 2012 16:57:04 -0300
Message-Id: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.4.4
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

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/usb/uvc/uvc_v4l2.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index f00db30..4fc8737 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -314,7 +314,7 @@ static int uvc_v4l2_set_format(struct uvc_streaming *stream,
 		goto done;
 	}
 
-	memcpy(&stream->ctrl, &probe, sizeof probe);
+	stream->ctrl = probe;
 	stream->cur_format = format;
 	stream->cur_frame = frame;
 
@@ -386,7 +386,7 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming *stream,
 		return -EBUSY;
 	}
 
-	memcpy(&probe, &stream->ctrl, sizeof probe);
+	probe = stream->ctrl;
 	probe.dwFrameInterval =
 		uvc_try_frame_interval(stream->cur_frame, interval);
 
@@ -397,7 +397,7 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming *stream,
 		return ret;
 	}
 
-	memcpy(&stream->ctrl, &probe, sizeof probe);
+	stream->ctrl = probe;
 	mutex_unlock(&stream->mutex);
 
 	/* Return the actual frame period. */
-- 
1.7.4.4

