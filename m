Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab2IRMIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:08:17 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33307 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361Ab2IRMIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:08:12 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 02/10] drivers/video/sunxvr1000.c: fix error return code
Date: Tue, 18 Sep 2012 14:07:52 +0200
Message-Id: <1347970080-25175-2-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347970080-25175-1-git-send-email-peter.senna@gmail.com>
References: <1347970080-25175-1-git-send-email-peter.senna@gmail.com>
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
 drivers/video/sunxvr1000.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/sunxvr1000.c b/drivers/video/sunxvr1000.c
index b7f27ac..729a507 100644
--- a/drivers/video/sunxvr1000.c
+++ b/drivers/video/sunxvr1000.c
@@ -141,8 +141,10 @@ static int __devinit gfb_probe(struct platform_device *op)
 
 	gp->fb_base = of_ioremap(&op->resource[6], 0,
 				 gp->fb_size, "gfb fb");
-	if (!gp->fb_base)
+	if (!gp->fb_base) {
+		err = -ENOMEM;
 		goto err_release_fb;
+	}
 
 	err = gfb_set_fbinfo(gp);
 	if (err)
-- 
1.7.11.4

