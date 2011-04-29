Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293Ab1D2RJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:09:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50438 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab1D2RJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:09:27 -0400
Date: Fri, 29 Apr 2011 19:09:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <damm@opensource.se>
Subject: [PATCH 2/2] dmaengine: shdma: add runtime- and system-level power
 management
In-Reply-To: <Pine.LNX.4.64.1104291901200.17813@axis700.grange>
Message-ID: <Pine.LNX.4.64.1104291908090.17813@axis700.grange>
References: <Pine.LNX.4.64.1104291901200.17813@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:MwnemiBIMyL7P398YioUSJDmA0/BwaQTZePna1uTami
 Ppw44g7wv3c9KdHUR+EEwZdrXtOh+Pt2RtUISFBbX7unDmiYl/
 2HAc8EZSeLuavfCiPKLCoT6mI49+148GGutoTF+BRirzJP8uhh
 Fb1ekqKdttXso6KuyAFb3Cnvd/CFB8KrVNqMfDWj5SSTjzsNR3
 hs2uiBvoh2hm+mADHcSJUHsMMHOaMogc919BPv8fhY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends and fixes runtime power management in the shdma
driver to support powering down the DMA controller and adds support
for system-level suspend and resume.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/dma/shdma.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/shdma.h |    1 +
 2 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index d0f402b..dcc1b21 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -1254,6 +1254,8 @@ rst_err:
 	spin_unlock_irq(&sh_dmae_lock);
 
 	pm_runtime_put(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	if (dmars)
 		iounmap(shdev->dmars);
 emapdmars:
@@ -1313,12 +1315,78 @@ static void sh_dmae_shutdown(struct platform_device *pdev)
 	sh_dmae_ctl_stop(shdev);
 }
 
+static int sh_dmae_runtime_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int sh_dmae_runtime_resume(struct device *dev)
+{
+	struct sh_dmae_device *shdev = dev_get_drvdata(dev);
+
+	return sh_dmae_rst(shdev);
+}
+
+#ifdef CONFIG_PM
+static int sh_dmae_suspend(struct device *dev)
+{
+	struct sh_dmae_device *shdev = dev_get_drvdata(dev);
+	int i;
+
+	for (i = 0; i < shdev->pdata->channel_num; i++) {
+		struct sh_dmae_chan *sh_chan = shdev->chan[i];
+		if (sh_chan->descs_allocated)
+			sh_chan->pm_error = pm_runtime_put_sync(dev);
+	}
+
+	return 0;
+}
+
+static int sh_dmae_resume(struct device *dev)
+{
+	struct sh_dmae_device *shdev = dev_get_drvdata(dev);
+	int i;
+
+	for (i = 0; i < shdev->pdata->channel_num; i++) {
+		struct sh_dmae_chan *sh_chan = shdev->chan[i];
+		struct sh_dmae_slave *param = sh_chan->common.private;
+
+		if (!sh_chan->descs_allocated)
+			continue;
+
+		if (!sh_chan->pm_error)
+			pm_runtime_get_sync(dev);
+
+		if (param) {
+			const struct sh_dmae_slave_config *cfg = param->config;
+			dmae_set_dmars(sh_chan, cfg->mid_rid);
+			dmae_set_chcr(sh_chan, cfg->chcr);
+		} else {
+			dmae_init(sh_chan);
+		}
+	}
+
+	return 0;
+}
+#else
+#define sh_dmae_suspend NULL
+#define sh_dmae_resume NULL
+#endif
+
+const struct dev_pm_ops sh_dmae_pm = {
+	.suspend		= sh_dmae_suspend,
+	.resume			= sh_dmae_resume,
+	.runtime_suspend	= sh_dmae_runtime_suspend,
+	.runtime_resume		= sh_dmae_runtime_resume,
+};
+
 static struct platform_driver sh_dmae_driver = {
 	.remove		= __exit_p(sh_dmae_remove),
 	.shutdown	= sh_dmae_shutdown,
 	.driver = {
 		.owner	= THIS_MODULE,
 		.name	= "sh-dma-engine",
+		.pm	= &sh_dmae_pm,
 	},
 };
 
diff --git a/drivers/dma/shdma.h b/drivers/dma/shdma.h
index 52e4fb1..3f9d3cd 100644
--- a/drivers/dma/shdma.h
+++ b/drivers/dma/shdma.h
@@ -37,6 +37,7 @@ struct sh_dmae_chan {
 	int id;				/* Raw id of this channel */
 	u32 __iomem *base;
 	char dev_id[16];		/* unique name per DMAC of channel */
+	int pm_error;
 };
 
 struct sh_dmae_device {
-- 
1.7.2.5

