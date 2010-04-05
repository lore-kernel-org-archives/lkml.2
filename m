Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab0DETHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 15:07:42 -0400
Received: from mail.perches.com ([173.55.12.10]:1378 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188Ab0DETFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 15:05:55 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Isely <isely@pobox.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] pvrusb2-v4l2: Rename dev_info to pdi
Date: Mon,  5 Apr 2010 12:05:39 -0700
Message-Id: <2044c4a5829aa21c3ec4bb90535289dd749bf4f1.1270493677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <20100304232928.2e45bdd1.akpm@linux-foundation.org>
References: <20100304232928.2e45bdd1.akpm@linux-foundation.org>
In-Reply-To: <cover.1270493677.git.joe@perches.com>
References: <cover.1270493677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a macro called dev_info that prints struct device specific
information.  Having variables with the same name can be confusing and
prevents conversion of the macro to a function.

Rename the existing dev_info variables to something else in preparation
to converting the dev_info macro to a function.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
index cc8ddb2..ba32c91 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -48,7 +48,7 @@ struct pvr2_v4l2_dev {
 
 struct pvr2_v4l2_fh {
 	struct pvr2_channel channel;
-	struct pvr2_v4l2_dev *dev_info;
+	struct pvr2_v4l2_dev *pdi;
 	enum v4l2_priority prio;
 	struct pvr2_ioread *rhp;
 	struct file *file;
@@ -161,7 +161,7 @@ static long pvr2_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 {
 	struct pvr2_v4l2_fh *fh = file->private_data;
 	struct pvr2_v4l2 *vp = fh->vhead;
-	struct pvr2_v4l2_dev *dev_info = fh->dev_info;
+	struct pvr2_v4l2_dev *pdi = fh->pdi;
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
 	long ret = -EINVAL;
 
@@ -563,14 +563,14 @@ static long pvr2_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	case VIDIOC_STREAMON:
 	{
-		if (!fh->dev_info->stream) {
+		if (!fh->pdi->stream) {
 			/* No stream defined for this node.  This means
 			   that we're not currently allowed to stream from
 			   this node. */
 			ret = -EPERM;
 			break;
 		}
-		ret = pvr2_hdw_set_stream_type(hdw,dev_info->config);
+		ret = pvr2_hdw_set_stream_type(hdw,pdi->config);
 		if (ret < 0) return ret;
 		ret = pvr2_hdw_set_streaming(hdw,!0);
 		break;
@@ -578,7 +578,7 @@ static long pvr2_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	case VIDIOC_STREAMOFF:
 	{
-		if (!fh->dev_info->stream) {
+		if (!fh->pdi->stream) {
 			/* No stream defined for this node.  This means
 			   that we're not currently allowed to stream from
 			   this node. */
@@ -1031,7 +1031,7 @@ static int pvr2_v4l2_open(struct file *file)
 	}
 
 	init_waitqueue_head(&fhp->wait_data);
-	fhp->dev_info = dip;
+	fhp->pdi = dip;
 
 	pvr2_trace(PVR2_TRACE_STRUCT,"Creating pvr_v4l2_fh id=%p",fhp);
 	pvr2_channel_init(&fhp->channel,vp->channel.mc_head);
@@ -1112,7 +1112,7 @@ static int pvr2_v4l2_iosetup(struct pvr2_v4l2_fh *fh)
 	struct pvr2_hdw *hdw;
 	if (fh->rhp) return 0;
 
-	if (!fh->dev_info->stream) {
+	if (!fh->pdi->stream) {
 		/* No stream defined for this node.  This means that we're
 		   not currently allowed to stream from this node. */
 		return -EPERM;
@@ -1121,21 +1121,21 @@ static int pvr2_v4l2_iosetup(struct pvr2_v4l2_fh *fh)
 	/* First read() attempt.  Try to claim the stream and start
 	   it... */
 	if ((ret = pvr2_channel_claim_stream(&fh->channel,
-					     fh->dev_info->stream)) != 0) {
+					     fh->pdi->stream)) != 0) {
 		/* Someone else must already have it */
 		return ret;
 	}
 
-	fh->rhp = pvr2_channel_create_mpeg_stream(fh->dev_info->stream);
+	fh->rhp = pvr2_channel_create_mpeg_stream(fh->pdi->stream);
 	if (!fh->rhp) {
 		pvr2_channel_claim_stream(&fh->channel,NULL);
 		return -ENOMEM;
 	}
 
 	hdw = fh->channel.mc_head->hdw;
-	sp = fh->dev_info->stream->stream;
+	sp = fh->pdi->stream->stream;
 	pvr2_stream_set_callback(sp,(pvr2_stream_callback)pvr2_v4l2_notify,fh);
-	pvr2_hdw_set_stream_type(hdw,fh->dev_info->config);
+	pvr2_hdw_set_stream_type(hdw,fh->pdi->config);
 	if ((ret = pvr2_hdw_set_streaming(hdw,!0)) < 0) return ret;
 	return pvr2_ioread_set_enabled(fh->rhp,!0);
 }
-- 
1.7.0.3.311.g6a6955

