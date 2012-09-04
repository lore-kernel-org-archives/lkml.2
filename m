Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab2IDMLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:11:04 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34012 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab2IDMLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:11:00 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] drivers/media/platform/davinci/vpfe_capture.c: fix error return code
Date: Tue,  4 Sep 2012 14:05:03 +0200
Message-Id: <1346760305-13060-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/media/platform/davinci/vpfe_capture.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 843b138..f99198c 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1131,11 +1131,11 @@ static int vpfe_s_input(struct file *file, void *priv, unsigned int index)
 		ret = -EBUSY;
 		goto unlock_out;
 	}
-
-	if (vpfe_get_subdev_input_index(vpfe_dev,
-					&subdev_index,
-					&inp_index,
-					index) < 0) {
+	ret = vpfe_get_subdev_input_index(vpfe_dev,
+					  &subdev_index,
+					  &inp_index,
+					  index);
+	if (ret < 0) {
 		v4l2_err(&vpfe_dev->v4l2_dev, "invalid input index\n");
 		goto unlock_out;
 	}
@@ -1748,8 +1748,9 @@ static long vpfe_param_handler(struct file *file, void *priv,
 					"Error setting parameters in CCDC\n");
 				goto unlock_out;
 			}
-			if (vpfe_get_ccdc_image_format(vpfe_dev,
-						       &vpfe_dev->fmt) < 0) {
+			ret = vpfe_get_ccdc_image_format(vpfe_dev,
+							 &vpfe_dev->fmt);
+			if (ret < 0) {
 				v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
 					"Invalid image format at CCDC\n");
 				goto unlock_out;

