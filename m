Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab2IDQQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:16:21 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50446 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab2IDQOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:14:52 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] drivers/media/platform/s5p-tv/mixer_video.c: fix error return code
Date: Tue,  4 Sep 2012 18:14:27 +0200
Message-Id: <1346775269-12191-3-git-send-email-peter.senna@gmail.com>
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
 drivers/media/platform/s5p-tv/mixer_video.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index a9c6be3..f139fed 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -83,6 +83,7 @@ int __devinit mxr_acquire_video(struct mxr_device *mdev,
 	mdev->alloc_ctx = vb2_dma_contig_init_ctx(mdev->dev);
 	if (IS_ERR_OR_NULL(mdev->alloc_ctx)) {
 		mxr_err(mdev, "could not acquire vb2 allocator\n");
+		ret = -ENODEV;
 		goto fail_v4l2_dev;
 	}
 
@@ -764,8 +765,10 @@ static int mxr_video_open(struct file *file)
 	}
 
 	/* leaving if layer is already initialized */
-	if (!v4l2_fh_is_singular_file(file))
+	if (!v4l2_fh_is_singular_file(file)) {
+		ret = -EBUSY; /* Not sure if EBUSY is the best for here */
 		goto unlock;
+	}
 
 	/* FIXME: should power be enabled on open? */
 	ret = mxr_power_get(mdev);

