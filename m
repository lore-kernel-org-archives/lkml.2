Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab1LRCDd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 21:03:33 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38510 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1LRCDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 21:03:31 -0500
Message-ID: <1324173796.6958.1.camel@phoenix>
Subject: [PATCH] misc: Fix irq leak in max8997_muic_probe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Donggeun Kim <dg77.kim@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>
Date: Sun, 18 Dec 2011 10:03:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code does not properly free allocated irqs if request_threaded_irq
returns error, fix it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/misc/max8997-muic.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/max8997-muic.c b/drivers/misc/max8997-muic.c
index 74a9448..409b7fc 100644
--- a/drivers/misc/max8997-muic.c
+++ b/drivers/misc/max8997-muic.c
@@ -566,10 +566,6 @@ static int __devinit max8997_muic_probe(struct platform_device *pdev)
 				"failed: irq request (IRQ: %d,"
 				" error :%d)\n",
 				muic_irq->irq, ret);
-
-			for (i = i - 1; i >= 0; i--)
-				free_irq(muic_irq->irq, info);
-
 			goto err_irq;
 		}
 	}
@@ -583,6 +579,8 @@ static int __devinit max8997_muic_probe(struct platform_device *pdev)
 	return ret;
 
 err_irq:
+	while (--i >= 0)
+		free_irq(pdata->irq_base + muic_irqs[i].irq, info);
 	sysfs_remove_group(&pdev->dev.kobj, &max8997_muic_group);
 err_sysfs:
 err_pdata:
-- 
1.7.5.4



