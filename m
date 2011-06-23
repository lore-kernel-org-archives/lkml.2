Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933792Ab1FWRsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:48:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:35462 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933751Ab1FWRiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 216/247] uvcvideo: Fix uvc_fixup_video_ctrl() format search
Date: Thu, 23 Jun 2011 13:34:44 -0400
Message-Id: <1308850515-15242-157-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 38a66824d96de8aeeb915e6f46f0d3fe55828eb1 upstream.

The scheme used to index format in uvc_fixup_video_ctrl() is not robust:
format index is based on descriptor ordering, which does not necessarily
match bFormatIndex ordering.  Searching for first matching format will
prevent uvc_fixup_video_ctrl() from using the wrong format/frame to make
adjustments.

Signed-off-by: Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/media/video/uvc/uvc_video.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 821a996..687c970 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -65,15 +65,19 @@ int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
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
-- 
1.7.4.4

