Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab1CZAJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:09:40 -0400
Received: from kroah.org ([198.145.64.141]:35917 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933392Ab1CZAGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 20:06:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 17:04:58 2011
Message-Id: <20110326000458.360643131@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 17:03:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [24/35] [media] uvcvideo: Fix uvc_fixup_video_ctrl() format search
In-Reply-To: <20110326000509.GA29736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>

commit 38a66824d96de8aeeb915e6f46f0d3fe55828eb1 upstream.

The scheme used to index format in uvc_fixup_video_ctrl() is not robust:
format index is based on descriptor ordering, which does not necessarily
match bFormatIndex ordering.  Searching for first matching format will
prevent uvc_fixup_video_ctrl() from using the wrong format/frame to make
adjustments.

Signed-off-by: Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_video.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -64,15 +64,19 @@ int uvc_query_ctrl(struct uvc_device *de
 static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
 	struct uvc_streaming_control *ctrl)
 {
-	struct uvc_format *format;
+	struct uvc_format *format = NULL;
 	struct uvc_frame *frame = NULL;
 	unsigned int i;
 
-	if (ctrl->bFormatIndex <= 0 ||
-	    ctrl->bFormatIndex > stream->nformats)
-		return;
+	for (i = 0; i < stream->nformats; ++i) {
+		if (stream->format[i].index == ctrl->bFormatIndex) {
+			format = &stream->format[i];
+			break;
+		}
+	}
 
-	format = &stream->format[ctrl->bFormatIndex - 1];
+	if (format == NULL)
+		return;
 
 	for (i = 0; i < format->nframes; ++i) {
 		if (format->frame[i].bFrameIndex == ctrl->bFrameIndex) {


