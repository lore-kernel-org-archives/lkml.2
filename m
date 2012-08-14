Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab2HNNXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 09:23:10 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:12782
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911Ab2HNNXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 09:23:08 -0400
X-IronPort-AV: E=Sophos;i="4.77,766,1336341600"; 
   d="scan'208";a="153055648"
Date: Tue, 14 Aug 2012 15:23:06 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Julia Lawall <julia.lawall@lip6.fr>, Lars-Peter Clausen <lars@metafoo.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/media/video/mx2_emmaprp.c: use devm_kzalloc and
 devm_clk_get
In-Reply-To: <502A2057.3000401@redhat.com>
Message-ID: <alpine.DEB.2.02.1208141520430.1908@hadrien>
References: <1344104607-18805-1-git-send-email-Julia.Lawall@lip6.fr> <20120806142323.GO4352@mwanda> <20120806142650.GT4403@mwanda> <501FD69D.7070702@metafoo.de> <alpine.DEB.2.02.1208101558100.2011@hadrien> <50295A43.30305@redhat.com>
 <alpine.DEB.2.02.1208132219060.2355@localhost6.localdomain6> <5029AC92.2060408@redhat.com> <alpine.DEB.2.02.1208140819400.1973@localhost6.localdomain6> <502A2057.3000401@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Using devm_kzalloc simplifies the code and ensures that the use of
devm_request_irq is safe.  When kzalloc and kfree were used, the interrupt
could be triggered after the handler's data argument had been freed.

This also introduces some missing initializations of the return variable
ret, and uses devm_request_and_ioremap instead of the combination of
devm_request_mem_region and devm_ioremap.

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
This is the same patch I sent before.  I had no trouble applying it after
cloning the staging/for_v3.7 branch.

 drivers/media/video/mx2_emmaprp.c |   31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/media/video/mx2_emmaprp.c b/drivers/media/video/mx2_emmaprp.c
index 2810015..dab380a 100644
--- a/drivers/media/video/mx2_emmaprp.c
+++ b/drivers/media/video/mx2_emmaprp.c
@@ -896,7 +896,7 @@ static int emmaprp_probe(struct platform_device *pdev)
 	int irq_emma;
 	int ret;

-	pcdev = kzalloc(sizeof *pcdev, GFP_KERNEL);
+	pcdev = devm_kzalloc(&pdev->dev, sizeof(*pcdev), GFP_KERNEL);
 	if (!pcdev)
 		return -ENOMEM;

@@ -904,27 +904,24 @@ static int emmaprp_probe(struct platform_device *pdev)

 	pcdev->clk_emma_ipg = devm_clk_get(&pdev->dev, "ipg");
 	if (IS_ERR(pcdev->clk_emma_ipg)) {
-		ret = PTR_ERR(pcdev->clk_emma_ipg);
-		goto free_dev;
+		return PTR_ERR(pcdev->clk_emma_ipg);
 	}

 	pcdev->clk_emma_ahb = devm_clk_get(&pdev->dev, "ahb");
 	if (IS_ERR(pcdev->clk_emma_ipg)) {
-		ret = PTR_ERR(pcdev->clk_emma_ahb);
-		goto free_dev;
+		return PTR_ERR(pcdev->clk_emma_ahb);
 	}

 	irq_emma = platform_get_irq(pdev, 0);
 	res_emma = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (irq_emma < 0 || res_emma == NULL) {
 		dev_err(&pdev->dev, "Missing platform resources data\n");
-		ret = -ENODEV;
-		goto free_dev;
+		return -ENODEV;
 	}

 	ret = v4l2_device_register(&pdev->dev, &pcdev->v4l2_dev);
 	if (ret)
-		goto free_dev;
+		return ret;

 	mutex_init(&pcdev->dev_mutex);

@@ -946,21 +943,20 @@ static int emmaprp_probe(struct platform_device *pdev)

 	platform_set_drvdata(pdev, pcdev);

-	if (devm_request_mem_region(&pdev->dev, res_emma->start,
-	    resource_size(res_emma), MEM2MEM_NAME) == NULL)
-		goto rel_vdev;
-
-	pcdev->base_emma = devm_ioremap(&pdev->dev, res_emma->start,
-					resource_size(res_emma));
-	if (!pcdev->base_emma)
+	pcdev->base_emma = devm_request_and_ioremap(&pdev->dev, res_emma);
+	if (!pcdev->base_emma) {
+		ret = -ENXIO;
 		goto rel_vdev;
+	}

 	pcdev->irq_emma = irq_emma;
 	pcdev->res_emma = res_emma;

 	if (devm_request_irq(&pdev->dev, pcdev->irq_emma, emmaprp_irq,
-			     0, MEM2MEM_NAME, pcdev) < 0)
+			     0, MEM2MEM_NAME, pcdev) < 0) {
+		ret = -ENODEV;
 		goto rel_vdev;
+	}

 	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
 	if (IS_ERR(pcdev->alloc_ctx)) {
@@ -993,8 +989,6 @@ rel_vdev:
 	video_device_release(vfd);
 unreg_dev:
 	v4l2_device_unregister(&pcdev->v4l2_dev);
-free_dev:
-	kfree(pcdev);

 	return ret;
 }
@@ -1009,7 +1003,6 @@ static int emmaprp_remove(struct platform_device *pdev)
 	v4l2_m2m_release(pcdev->m2m_dev);
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 	v4l2_device_unregister(&pcdev->v4l2_dev);
-	kfree(pcdev);

 	return 0;
 }

