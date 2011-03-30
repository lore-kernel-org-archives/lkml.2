Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965218Ab1C3VJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:09:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:41846 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965105Ab1C3VJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411278993"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: stephan.lachowsky@maxim-ic.com, mchehab@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [233/275] uvcvideo: Fix uvc_fixup_video_ctrl() format search
Message-Id: <20110330210759.0C4583E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/media/video/uvc/uvc_video.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

Index: linux-2.6.35.y/drivers/media/video/uvc/uvc_video.c
===================================================================
--- linux-2.6.35.y.orig/drivers/media/video/uvc/uvc_video.c	2011-03-29 22:50:21.561706709 -0700
+++ linux-2.6.35.y/drivers/media/video/uvc/uvc_video.c	2011-03-29 23:03:03.081221330 -0700
@@ -65,15 +65,19 @@
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
