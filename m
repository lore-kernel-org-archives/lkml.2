Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab0EOJrE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 05:47:04 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:44228 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab0EOJq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 05:46:59 -0400
Date: Sat, 15 May 2010 11:46:54 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/4] drivers/media/video: Eliminate use after free
Message-ID: <Pine.LNX.4.64.1005151146370.15566@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The error value is saved in a new local variable err before freeing the
containing structure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@free@
expression E;
position p;
@@
kfree@p(E)

@@
expression free.E, subE<=free.E, E1;
position free.p;
@@

  kfree@p(E)
  ...
(
  subE = E1
|
* E
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/mem2mem_testdev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index baf211b..fb73f34 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -858,6 +858,7 @@ static int m2mtest_open(struct file *file)
 {
 	struct m2mtest_dev *dev = video_drvdata(file);
 	struct m2mtest_ctx *ctx = NULL;
+	int err;
 
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
 	if (!ctx)
@@ -871,8 +872,9 @@ static int m2mtest_open(struct file *file)
 
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(ctx, dev->m2m_dev, queue_init);
 	if (IS_ERR(ctx->m2m_ctx)) {
+		err = PTR_ERR(ctx->m2m_ctx);
 		kfree(ctx);
-		return PTR_ERR(ctx->m2m_ctx);
+		return err;
 	}
 
 	atomic_inc(&dev->num_inst);
