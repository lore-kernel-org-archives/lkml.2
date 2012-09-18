Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab2IRMJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:09:20 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63124 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab2IRMIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:08:15 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 07/10] drivers/video/bw2.c: fix error return code
Date: Tue, 18 Sep 2012 14:07:57 +0200
Message-Id: <1347970080-25175-7-git-send-email-peter.senna@gmail.com>
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
 drivers/video/bw2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/bw2.c b/drivers/video/bw2.c
index 7ba74cd..6bea9a9 100644
--- a/drivers/video/bw2.c
+++ b/drivers/video/bw2.c
@@ -319,8 +319,10 @@ static int __devinit bw2_probe(struct platform_device *op)
 
 	info->screen_base = of_ioremap(&op->resource[0], 0,
 				       info->fix.smem_len, "bw2 ram");
-	if (!info->screen_base)
+	if (!info->screen_base) {
+		err = -ENOMEM;
 		goto out_unmap_regs;
+	}
 
 	bw2_blank(FB_BLANK_UNBLANK, info);
 
-- 
1.7.11.4

