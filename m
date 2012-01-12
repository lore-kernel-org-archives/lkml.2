Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab2ALVuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 16:50:07 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:54332 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738Ab2ALVti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 16:49:38 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: kernel-janitors@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] drivers/media/video/s5p-fimc/fimc-capture.c: adjust double test
Date: Thu, 12 Jan 2012 22:49:28 +0100
Message-Id: <1326404970-1084-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1326404970-1084-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1326404970-1084-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Rewrite a duplicated test to test the correct value

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E;
@@

(
* E
  || ... || E
|
* E
  && ... && E
)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
There is a height field, so it is my guess that that should be tested
instead of testing the width field again.

 drivers/media/video/s5p-fimc/fimc-capture.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 2cc3b91..13dd598 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -689,7 +689,7 @@ static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
 			mf->code = 0;
 			continue;
 		}
-		if (mf->width != tfmt->width || mf->width != tfmt->width) {
+		if (mf->width != tfmt->width || mf->height != tfmt->height) {
 			u32 fcc = ffmt->fourcc;
 			tfmt->width  = mf->width;
 			tfmt->height = mf->height;
@@ -698,7 +698,8 @@ static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
 					       NULL, &fcc, FIMC_SD_PAD_SOURCE);
 			if (ffmt && ffmt->mbus_code)
 				mf->code = ffmt->mbus_code;
-			if (mf->width != tfmt->width || mf->width != tfmt->width)
+			if (mf->width != tfmt->width ||
+			    mf->height != tfmt->height)
 				continue;
 			tfmt->code = mf->code;
 		}
@@ -706,7 +707,7 @@ static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
 			ret = v4l2_subdev_call(csis, pad, set_fmt, NULL, &sfmt);
 
 		if (mf->code == tfmt->code &&
-		    mf->width == tfmt->width && mf->width == tfmt->width)
+		    mf->width == tfmt->width && mf->height == tfmt->height)
 			break;
 	}
 

