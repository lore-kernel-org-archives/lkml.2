Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab0HNNnx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 09:43:53 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42353 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934746Ab0HNNns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 09:43:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=CCMT7qj4ONCPUhAcfZ/zrtab0O4Q50F8RHstij4H9rj/e9XTi95weCjfMnY6fuFkA8
         oCv64Zql6uVh/GbHIUDQ0xsTz2//C51JYLdcGZnz5+F/S2iKRf4Otn1jkq9L6bu+BagY
         EfUGcGrHeyMHXFdWFRPJoQXkx8yBbygfgPut8=
Subject: [PATCH] regulator: ab8500 - fix the logic to remove already
 registered regulators in error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sundar R Iyer <sundar.iyer@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 Aug 2010 21:44:04 +0800
Message-ID: <1281793444.2974.5.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, ab8500_regulator_info[0].regulator is not
unregistered if the error happen at i > 0.

This patch fixes the resource leak and also improves the readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I think this change is better ( in readability ) than simply change "while (i > 0)" to "while (i >= 0)".

 drivers/regulator/ab8500.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index dc3f1a4..775688e 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -368,11 +368,9 @@ static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev, "failed to register regulator %s\n",
 					info->desc.name);
 			/* when we fail, un-register all earlier regulators */
-			i--;
-			while (i > 0) {
+			while (--i >= 0) {
 				info = &ab8500_regulator_info[i];
 				regulator_unregister(info->regulator);
-				i--;
 			}
 			return err;
 		}
-- 
1.7.0.4



