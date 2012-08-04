Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab2HDSXd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 14:23:33 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:10436
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753780Ab2HDSXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 14:23:31 -0400
X-IronPort-AV: E=Sophos;i="4.77,713,1336341600"; 
   d="scan'208";a="152442042"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/media/video/mx2_emmaprp.c: use devm_kzalloc and devm_clk_get
Date: Sat,  4 Aug 2012 20:23:27 +0200
Message-Id: <1344104607-18805-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Using devm_kzalloc and devm_clk_get simplifies the code and ensures that
the use of devm_request_irq is safe.  When kzalloc and kfree were used, the
interrupt could be triggered after the handler's data argument had been
freed.

The problem of a free after a devm_request_irq was found using the
following semantic match (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression e1,e2,x,a,b,c,d;
identifier free;
position p1,p2;
@@

  devm_request_irq@p1(e1,e2,...,x)
  ... when any
      when != e2 = a
      when != x = b
  if (...) {
    ... when != e2 = c
        when != x = d
    free@p2(...,x,...);
    ...
    return ...;
  }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/video/mx2_emmaprp.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/media/video/mx2_emmaprp.c b/drivers/media/video/mx2_emmaprp.c
index 5f8a6f5..78c5dc9 100644
--- a/drivers/media/video/mx2_emmaprp.c
+++ b/drivers/media/video/mx2_emmaprp.c
@@ -874,29 +874,27 @@ static int emmaprp_probe(struct platform_device *pdev)
 	int irq_emma;
 	int ret;
 
-	pcdev = kzalloc(sizeof *pcdev, GFP_KERNEL);
+	pcdev = devm_kzalloc(&pdev->dev, sizeof(*pcdev), GFP_KERNEL);
 	if (!pcdev)
 		return -ENOMEM;
 
 	spin_lock_init(&pcdev->irqlock);
 
-	pcdev->clk_emma = clk_get(&pdev->dev, NULL);
+	pcdev->clk_emma = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(pcdev->clk_emma)) {
-		ret = PTR_ERR(pcdev->clk_emma);
-		goto free_dev;
+		return PTR_ERR(pcdev->clk_emma);
 	}
 
 	irq_emma = platform_get_irq(pdev, 0);
 	res_emma = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (irq_emma < 0 || res_emma == NULL) {
 		dev_err(&pdev->dev, "Missing platform resources data\n");
-		ret = -ENODEV;
-		goto free_clk;
+		return -ENODEV;
 	}
 
 	ret = v4l2_device_register(&pdev->dev, &pcdev->v4l2_dev);
 	if (ret)
-		goto free_clk;
+		return ret;
 
 	mutex_init(&pcdev->dev_mutex);
 
@@ -922,12 +920,7 @@ static int emmaprp_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, pcdev);
 
-	if (devm_request_mem_region(&pdev->dev, res_emma->start,
-	    resource_size(res_emma), MEM2MEM_NAME) == NULL)
-		goto rel_vdev;
-
-	pcdev->base_emma = devm_ioremap(&pdev->dev, res_emma->start,
-					resource_size(res_emma));
+	pcdev->base_emma = devm_request_and_ioremap(&pdev->dev, res_emma);
 	if (!pcdev->base_emma)
 		goto rel_vdev;
 
@@ -969,10 +962,6 @@ rel_vdev:
 	video_device_release(vfd);
 unreg_dev:
 	v4l2_device_unregister(&pcdev->v4l2_dev);
-free_clk:
-	clk_put(pcdev->clk_emma);
-free_dev:
-	kfree(pcdev);
 
 	return ret;
 }
@@ -987,8 +976,6 @@ static int emmaprp_remove(struct platform_device *pdev)
 	v4l2_m2m_release(pcdev->m2m_dev);
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 	v4l2_device_unregister(&pcdev->v4l2_dev);
-	clk_put(pcdev->clk_emma);
-	kfree(pcdev);
 
 	return 0;
 }

