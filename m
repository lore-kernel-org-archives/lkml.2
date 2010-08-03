Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab0HCFmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 01:42:51 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44191 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab0HCFmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 01:42:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=xnc6DSqEVPW6nnXqv2LuS7G5EoNNmq//djGK3HzdCZtpF+FHVHEXf+4+2jIFS2osdk
         mCxSUUVUADNgV1edKK/F/WgO3c344d3gUyRBWmO9Yw9npVGeQ8MLcwgJ1r/fHUdjpDUY
         L+F7xG+y6fm3gJ7gEzkijvbqraDYwPkAnsevQ=
Subject: [PATCH 1/2] tc6387xb: fix resource reclaim
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Ian Molton <ian@mnementh.co.uk>
Content-Type: text/plain
Date: Tue, 03 Aug 2010 13:44:00 +0800
Message-Id: <1280814240.15753.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below fixes:
1. add a missing iounmap in tc6387xb_probe() error path
2. fix resource reclaim in tc6387xb_remove()

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/tc6387xb.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/tc6387xb.c b/drivers/mfd/tc6387xb.c
index 517f9bc..1bc71da 100644
--- a/drivers/mfd/tc6387xb.c
+++ b/drivers/mfd/tc6387xb.c
@@ -201,6 +201,7 @@ static int tc6387xb_probe(struct platform_device *dev)
 	if (!ret)
 		return 0;
 
+	iounmap(tc6387xb->scr);
 err_ioremap:
 	release_resource(&tc6387xb->rscr);
 err_resource:
@@ -213,12 +214,15 @@ err_no_irq:
 
 static int tc6387xb_remove(struct platform_device *dev)
 {
-	struct clk *clk32k = platform_get_drvdata(dev);
+	struct tc6387xb *tc6387xb = platform_get_drvdata(dev);
 
 	mfd_remove_devices(&dev->dev);
-	clk_disable(clk32k);
-	clk_put(clk32k);
+	iounmap(tc6387xb->scr);
+	release_resource(&tc6387xb->rscr);
+	clk_disable(tc6387xb->clk32k);
+	clk_put(tc6387xb->clk32k);
 	platform_set_drvdata(dev, NULL);
+	kfree(tc6387xb);
 
 	return 0;
 }
-- 
1.5.4.3



