Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab2JCMlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:41:13 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52490 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2JCMlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:41:06 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: kernel-janitors@vger.kernel.org, Donghwa Lee <dh09.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drivers/video/exynos/exynos_mipi_dsi.c: fix error return code
Date: Wed,  3 Oct 2012 14:40:44 +0200
Message-Id: <1349268044-32616-2-git-send-email-peter.senna@gmail.com>
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
 drivers/video/exynos/exynos_mipi_dsi.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/exynos/exynos_mipi_dsi.c b/drivers/video/exynos/exynos_mipi_dsi.c
index c4f25de..07d70a3 100644
--- a/drivers/video/exynos/exynos_mipi_dsi.c
+++ b/drivers/video/exynos/exynos_mipi_dsi.c
@@ -375,6 +375,7 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
 	dsim->clock = clk_get(&pdev->dev, "dsim0");
 	if (IS_ERR(dsim->clock)) {
 		dev_err(&pdev->dev, "failed to get dsim clock source\n");
+		ret = -ENODEV;
 		goto err_clock_get;
 	}
 
@@ -383,6 +384,7 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "failed to get io memory region\n");
+		ret = -ENODEV;
 		goto err_platform_get;
 	}
 
@@ -407,6 +409,7 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
 	dsim_ddi = exynos_mipi_dsi_bind_lcd_ddi(dsim, dsim_pd->lcd_panel_name);
 	if (!dsim_ddi) {
 		dev_err(&pdev->dev, "mipi_dsim_ddi object not found.\n");
+		ret = -EINVAL;
 		goto err_bind;
 	}
 

