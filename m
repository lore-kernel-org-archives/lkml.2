Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab2HMTty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 15:49:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab2HMTtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 15:49:52 -0400
Message-ID: <50295A43.30305@redhat.com>
Date: Mon, 13 Aug 2012 16:49:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/media/video/mx2_emmaprp.c: use devm_kzalloc and
 devm_clk_get
References: <1344104607-18805-1-git-send-email-Julia.Lawall@lip6.fr> <20120806142323.GO4352@mwanda> <20120806142650.GT4403@mwanda> <501FD69D.7070702@metafoo.de> <alpine.DEB.2.02.1208101558100.2011@hadrien>
In-Reply-To: <alpine.DEB.2.02.1208101558100.2011@hadrien>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 10-08-2012 10:59, Julia Lawall escreveu:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Using devm_kzalloc and devm_clk_get simplifies the code and ensures that
> the use of devm_request_irq is safe.  When kzalloc and kfree were used, the
> interrupt could be triggered after the handler's data argument had been
> freed.
> 
> Add missing return code initializations in the error handling code for
> devm_request_and_ioremap and devm_request_irq.
> 
> The problem of a free after a devm_request_irq was found using the
> following semantic match (http://coccinelle.lip6.fr/)

Hi Julia,

This patch doesn't apply anymore, likely due to this changeset:

commit 33eb46a7c2bdd10f9a761390ce1bf51169ff537a
Author: Javier Martin <javier.martin@vista-silicon.com>
Date:   Mon Jul 30 04:37:30 2012 -0300

    [media] media: i.MX27: Fix mx2_emmaprp mem2mem driver clocks
    
    This driver wasn't converted to the new clock framework
    (e038ed50a4a767add205094c035b6943e7b30140).
    
    Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/mx2_emmaprp.c b/drivers/media/video/mx2_emmaprp.c
index 5f8a6f5..728cac3 100644
--- a/drivers/media/video/mx2_emmaprp.c
+++ b/drivers/media/video/mx2_emmaprp.c
@@ -209,7 +209,7 @@ struct emmaprp_dev {
 
 	int			irq_emma;
 	void __iomem		*base_emma;
-	struct clk		*clk_emma;
+	struct clk		*clk_emma_ahb, *clk_emma_ipg;
 	struct resource		*res_emma;
 
 	struct v4l2_m2m_dev	*m2m_dev;
@@ -804,7 +804,8 @@ static int emmaprp_open(struct file *file)
 		return ret;
 	}
 
-	clk_enable(pcdev->clk_emma);
+	clk_prepare_enable(pcdev->clk_emma_ipg);
+	clk_prepare_enable(pcdev->clk_emma_ahb);
 	ctx->q_data[V4L2_M2M_SRC].fmt = &formats[1];
 	ctx->q_data[V4L2_M2M_DST].fmt = &formats[0];
 
@@ -820,7 +821,8 @@ static int emmaprp_release(struct file *file)
 
 	dprintk(pcdev, "Releasing instance %p\n", ctx);
 
-	clk_disable(pcdev->clk_emma);
+	clk_disable_unprepare(pcdev->clk_emma_ahb);
+	clk_disable_unprepare(pcdev->clk_emma_ipg);
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 	kfree(ctx);
 
@@ -880,9 +882,15 @@ static int emmaprp_probe(struct platform_device *pdev)
 
 	spin_lock_init(&pcdev->irqlock);
 
-	pcdev->clk_emma = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(pcdev->clk_emma)) {
-		ret = PTR_ERR(pcdev->clk_emma);
+	pcdev->clk_emma_ipg = devm_clk_get(&pdev->dev, "ipg");
+	if (IS_ERR(pcdev->clk_emma_ipg)) {
+		ret = PTR_ERR(pcdev->clk_emma_ipg);
+		goto free_dev;
+	}
+
+	pcdev->clk_emma_ahb = devm_clk_get(&pdev->dev, "ahb");
+	if (IS_ERR(pcdev->clk_emma_ipg)) {
+		ret = PTR_ERR(pcdev->clk_emma_ahb);
 		goto free_dev;
 	}
 
@@ -891,12 +899,12 @@ static int emmaprp_probe(struct platform_device *pdev)
 	if (irq_emma < 0 || res_emma == NULL) {
 		dev_err(&pdev->dev, "Missing platform resources data\n");
 		ret = -ENODEV;
-		goto free_clk;
+		goto free_dev;
 	}
 
 	ret = v4l2_device_register(&pdev->dev, &pcdev->v4l2_dev);
 	if (ret)
-		goto free_clk;
+		goto free_dev;
 
 	mutex_init(&pcdev->dev_mutex);
 
@@ -969,8 +977,6 @@ rel_vdev:
 	video_device_release(vfd);
 unreg_dev:
 	v4l2_device_unregister(&pcdev->v4l2_dev);
-free_clk:
-	clk_put(pcdev->clk_emma);
 free_dev:
 	kfree(pcdev);
 
@@ -987,7 +993,6 @@ static int emmaprp_remove(struct platform_device *pdev)
 	v4l2_m2m_release(pcdev->m2m_dev);
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 	v4l2_device_unregister(&pcdev->v4l2_dev);
-	clk_put(pcdev->clk_emma);
 	kfree(pcdev);
 
 	return 0;

