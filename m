Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1L0OQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:16:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53680 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754363Ab1L0OQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:16:19 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jingoo Han <jg1.han@samsung.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/6] video: s3c-fb: Disable runtime PM in error paths from probe
Date: Tue, 27 Dec 2011 14:16:09 +0000
Message-Id: <1324995372-3410-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1324995372-3410-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20111227141550.GA3331@opensource.wolfsonmicro.com>
 <1324995372-3410-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/video/s3c-fb.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
index be4c218..2e0eef0 100644
--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -1464,7 +1464,7 @@ static int __devinit s3c_fb_probe(struct platform_device *pdev)
 			dev_err(dev, "failed to create window %d\n", win);
 			for (; win >= 0; win--)
 				s3c_fb_release_win(sfb, sfb->windows[win]);
-			goto err_irq;
+			goto err_pm_runtime;
 		}
 	}
 
@@ -1473,7 +1473,8 @@ static int __devinit s3c_fb_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_irq:
+err_pm_runtime:
+	pm_runtime_put_sync(sfb->dev);
 	free_irq(sfb->irq_no, sfb);
 
 err_ioremap:
@@ -1483,6 +1484,8 @@ err_req_region:
 	release_mem_region(sfb->regs_res->start, resource_size(sfb->regs_res));
 
 err_lcd_clk:
+	pm_runtime_disable(sfb->dev);
+
 	if (!sfb->variant.has_clksel) {
 		clk_disable(sfb->lcd_clk);
 		clk_put(sfb->lcd_clk);
-- 
1.7.7.3

