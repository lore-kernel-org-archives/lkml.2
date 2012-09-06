Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319Ab2IFPY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:24:56 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62900 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882Ab2IFPYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:24:20 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/14] drivers/media/platform/soc_camera/mx2_camera.c: fix error return code
Date: Thu,  6 Sep 2012 17:23:59 +0200
Message-Id: <1346945041-26676-12-git-send-email-peter.senna@gmail.com>
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
 drivers/media/platform/soc_camera/mx2_camera.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 256187f..f8884a7 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1800,13 +1800,16 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 
 		if (!res_emma || !irq_emma) {
 			dev_err(&pdev->dev, "no EMMA resources\n");
+			err = -ENODEV;
 			goto exit_free_irq;
 		}
 
 		pcdev->res_emma = res_emma;
 		pcdev->irq_emma = irq_emma;
-		if (mx27_camera_emma_init(pcdev))
+		if (mx27_camera_emma_init(pcdev)) {
+			err = -ENODEV;
 			goto exit_free_irq;
+		}
 	}
 
 	pcdev->soc_host.drv_name	= MX2_CAM_DRV_NAME,

