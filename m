Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab2IXJL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:11:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52533 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab2IXJL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:11:27 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: mchehab@infradead.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
        fabio.estevam@freescale.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V2 2/14] drivers/media/platform/soc_camera/mx2_camera.c: fix error return code
Date: Mon, 24 Sep 2012 11:11:03 +0200
Message-Id: <1348477863-6728-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <Pine.LNX.4.64.1209232313500.31250@axis700.grange>
References: <Pine.LNX.4.64.1209232313500.31250@axis700.grange>
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
 drivers/media/platform/soc_camera/mx2_camera.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 256187f..01d7c11 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1800,12 +1800,14 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 
 		if (!res_emma || !irq_emma) {
 			dev_err(&pdev->dev, "no EMMA resources\n");
+			err = -ENODEV;
 			goto exit_free_irq;
 		}
 
 		pcdev->res_emma = res_emma;
 		pcdev->irq_emma = irq_emma;
-		if (mx27_camera_emma_init(pcdev))
+		err = mx27_camera_emma_init(pcdev);
+		if (err)
 			goto exit_free_irq;
 	}
 
-- 
1.7.11.4

