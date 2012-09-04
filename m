Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab2IDVf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:35:57 -0400
Received: from mail-yw0-f52.google.com ([209.85.213.52]:47781 "EHLO
	mail-yw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932683Ab2IDVfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:35:42 -0400
From: Fabio Estevam <festevam@gmail.com>
To: herbert@gondor.hengli.com.au
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v3 1/2] hw_random: mxc-rnga: Adapt clocks to new i.mx clock framework
Date: Tue,  4 Sep 2012 18:35:21 -0300
Message-Id: <1346794522-25289-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Adapt clocks to the new i.mx clock framework and fix the following warning:

------------[ cut here ]------------
WARNING: at drivers/clk/clk.c:511 __clk_enable+0x9c/0xac()
Modules linked in:
Backtrace:
[<800124c8>] (dump_backtrace+0x0/0x10c) from [<804172dc>] (dump_stack+0x18/0x1c)
 r7:00000009 r6:000001ff r5:8032cb50 r4:00000000
[<804172c4>] (dump_stack+0x0/0x1c) from [<80021834>] (warn_slowpath_common+0x54)
[<800217e0>] (warn_slowpath_common+0x0/0x6c) from [<80021870>] (warn_slowpath_n)
 r9:80581cac r8:8700a9c0 r7:805ab070 r6:80000013 r5:806133d4
r4:8700a9c0
[<8002184c>] (warn_slowpath_null+0x0/0x2c) from [<8032cb50>] (__clk_enable+0x9c)
[<8032cab4>] (__clk_enable+0x0/0xac) from [<8032cb88>] (clk_enable+0x28/0x44)
 r5:806133d4 r4:8700a9c0
[<8032cb60>] (clk_enable+0x0/0x44) from [<80560f14>] (mxc_rnga_probe+0x68/0x164)
 r7:805ab070 r6:8706ec00 r5:80611314 r4:00000000
[<80560eac>] (mxc_rnga_probe+0x0/0x164) from [<8025914c>] (platform_drv_probe+0)
[<8025912c>] (platform_drv_probe+0x0/0x24) from [<80257c7c>] (driver_probe_devi)
[<80257bfc>] (driver_probe_device+0x0/0x204) from [<80257e94>] (__driver_attach)
 r9:80581cac r8:0000008e r7:00000000 r6:8706ec3c r5:805ab070
r4:8706ec08
[<80257e00>] (__driver_attach+0x0/0x98) from [<8025642c>] (bus_for_each_dev+0x6)
 r7:00000000 r6:80257e00 r5:87035e98 r4:805ab070
[<802563c4>] (bus_for_each_dev+0x0/0x94) from [<80257adc>] (driver_attach+0x20/)
 r7:00000000 r6:873f2380 r5:805ab338 r4:805ab070
[<80257abc>] (driver_attach+0x0/0x28) from [<80256d50>] (bus_add_driver+0x18c/0)
[<80256bc4>] (bus_add_driver+0x0/0x268) from [<802584c4>] (driver_register+0x80)
[<80258444>] (driver_register+0x0/0x134) from [<802594f4>] (platform_driver_reg)
 r7:00000000 r6:805c2e00 r5:00000007 r4:805ab05c
[<802594a8>] (platform_driver_register+0x0/0x60) from [<80259528>] (platform_dr)
[<80259508>] (platform_driver_probe+0x0/0xa4) from [<80560ea0>] (mod_init+0x18/)
 r7:00000000 r6:805c2e00 r5:00000007 r4:87034000
[<80560e88>] (mod_init+0x0/0x24) from [<800086b4>] (do_one_initcall+0x40/0x194)
[<80008674>] (do_one_initcall+0x0/0x194) from [<8053d3f4>] (kernel_init+0xfc/0x)
[<8053d2f8>] (kernel_init+0x0/0x1cc) from [<80027190>] (do_exit+0x0/0x7ec)
---[ end trace 4198eed02050f461 ]---

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v2:
- Added Ack and Cc maintainer (Herbert)
Changes since v1:
- Converted a missing 'clk_disable' to 'clk_disable_unprepare
 drivers/char/hw_random/mxc-rnga.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
index 85074de..62c7efe 100644
--- a/drivers/char/hw_random/mxc-rnga.c
+++ b/drivers/char/hw_random/mxc-rnga.c
@@ -152,14 +152,14 @@ static int __init mxc_rnga_probe(struct platform_device *pdev)
 	if (rng_dev)
 		return -EBUSY;
 
-	clk = clk_get(&pdev->dev, "rng");
+	clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "Could not get rng_clk!\n");
 		err = PTR_ERR(clk);
 		goto out;
 	}
 
-	clk_enable(clk);
+	clk_prepare_enable(clk);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
@@ -201,7 +201,7 @@ err_ioremap:
 	release_mem_region(res->start, resource_size(res));
 
 err_region:
-	clk_disable(clk);
+	clk_disable_unprepare(clk);
 	clk_put(clk);
 
 out:
@@ -212,7 +212,7 @@ static int __exit mxc_rnga_remove(struct platform_device *pdev)
 {
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	void __iomem *rng_base = (void __iomem *)mxc_rnga.priv;
-	struct clk *clk = clk_get(&pdev->dev, "rng");
+	struct clk *clk = clk_get(&pdev->dev, NULL);
 
 	hwrng_unregister(&mxc_rnga);
 
@@ -220,7 +220,7 @@ static int __exit mxc_rnga_remove(struct platform_device *pdev)
 
 	release_mem_region(res->start, resource_size(res));
 
-	clk_disable(clk);
+	clk_disable_unprepare(clk);
 	clk_put(clk);
 
 	return 0;
-- 
1.7.9.5

