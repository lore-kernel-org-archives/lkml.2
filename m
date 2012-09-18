Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab2IRMJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:09:51 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34299 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932505Ab2IRMIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:08:14 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: nicolas.ferre@atmel.com
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 05/10] drivers/video/atmel_lcdfb.c: fix error return code
Date: Tue, 18 Sep 2012 14:07:55 +0200
Message-Id: <1347970080-25175-5-git-send-email-peter.senna@gmail.com>
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
 drivers/video/atmel_lcdfb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 1505539..94cac9f 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -931,8 +931,10 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
 		}
 
 		info->screen_base = ioremap(info->fix.smem_start, info->fix.smem_len);
-		if (!info->screen_base)
+		if (!info->screen_base) {
+			ret = -ENOMEM;
 			goto release_intmem;
+		}
 
 		/*
 		 * Don't clear the framebuffer -- someone may have set
@@ -960,6 +962,7 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
 	sinfo->mmio = ioremap(info->fix.mmio_start, info->fix.mmio_len);
 	if (!sinfo->mmio) {
 		dev_err(dev, "cannot map LCDC registers\n");
+		ret = -ENOMEM;
 		goto release_mem;
 	}
 
-- 
1.7.11.4

