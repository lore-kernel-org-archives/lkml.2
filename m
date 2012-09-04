Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab2IDQOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:14:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51844 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335Ab2IDQOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:14:53 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] drivers/media/platform/s5p-tv/sdo_drv.c: fix error return code
Date: Tue,  4 Sep 2012 18:14:28 +0200
Message-Id: <1346775269-12191-4-git-send-email-peter.senna@gmail.com>
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
 drivers/media/platform/s5p-tv/sdo_drv.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index ad68bbe..58cf56d 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -369,6 +369,7 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 	sdev->fout_vpll = clk_get(dev, "fout_vpll");
 	if (IS_ERR_OR_NULL(sdev->fout_vpll)) {
 		dev_err(dev, "failed to get clock 'fout_vpll'\n");
+		ret = -ENODEV;
 		goto fail_dacphy;
 	}
 	dev_info(dev, "fout_vpll.rate = %lu\n", clk_get_rate(sclk_vpll));
@@ -377,11 +378,13 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 	sdev->vdac = devm_regulator_get(dev, "vdd33a_dac");
 	if (IS_ERR_OR_NULL(sdev->vdac)) {
 		dev_err(dev, "failed to get regulator 'vdac'\n");
+		ret = -ENODEV;
 		goto fail_fout_vpll;
 	}
 	sdev->vdet = devm_regulator_get(dev, "vdet");
 	if (IS_ERR_OR_NULL(sdev->vdet)) {
 		dev_err(dev, "failed to get regulator 'vdet'\n");
+		ret = -ENODEV;
 		goto fail_fout_vpll;
 	}
 

