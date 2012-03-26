Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab2CZB5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 21:57:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61137 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab2CZB5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 21:57:15 -0400
Message-ID: <1332727028.7078.4.camel@phoenix>
Subject: [PATCH RESEND] misc: Fix irq leak in max8997_muic_probe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Donggeun Kim <dg77.kim@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>
Date: Mon, 26 Mar 2012 09:57:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code does not properly free allocated irqs if request_threaded_irq
returns error, fix it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
This patch was sent on LKML:https://lkml.org/lkml/2011/12/17/114
This resend re-generate the patch because it does not apply due to
the change in commit 71e5878 "misc: Remove max8997-muic sysfs attributes".

 drivers/misc/max8997-muic.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/max8997-muic.c b/drivers/misc/max8997-muic.c
index 19591ea..2e7df9c 100644
--- a/drivers/misc/max8997-muic.c
+++ b/drivers/misc/max8997-muic.c
@@ -440,10 +440,6 @@ static int __devinit max8997_muic_probe(struct platform_device *pdev)
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
@@ -457,6 +453,8 @@ static int __devinit max8997_muic_probe(struct platform_device *pdev)
 	return ret;
 
 err_irq:
+	while (--i >= 0)
+		free_irq(pdata->irq_base + muic_irqs[i].irq, info);
 err_pdata:
 	kfree(info);
 err_kfree:
-- 
1.7.5.4



