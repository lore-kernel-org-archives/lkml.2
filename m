Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab2I0N7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:59:18 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:49519 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2I0N7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:59:17 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 2/3] staging/sbe-2t3e3: Use netdev_ or dev_ or pr_ printks in module.c
Date: Thu, 27 Sep 2012 22:59:10 +0900
Message-Id: <1348754350-5022-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348754271-4987-1-git-send-email-yamanetoshi@gmail.com>
References: <1348754271-4987-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

and add pr_fmt.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/sbe-2t3e3/module.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/sbe-2t3e3/module.c b/drivers/staging/sbe-2t3e3/module.c
index cd778b3..4547137 100644
--- a/drivers/staging/sbe-2t3e3/module.c
+++ b/drivers/staging/sbe-2t3e3/module.c
@@ -10,6 +10,8 @@
  * This code is based on a driver written by SBE Inc.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
@@ -66,7 +68,7 @@ static int __devinit t3e3_init_channel(struct channel *channel, struct pci_dev *
 
 	dev = alloc_hdlcdev(channel);
 	if (!dev) {
-		printk(KERN_ERR "SBE 2T3E3" ": Out of memory\n");
+		pr_err("SBE 2T3E3" ": Out of memory\n");
 		goto free_regions;
 	}
 
@@ -93,7 +95,8 @@ static int __devinit t3e3_init_channel(struct channel *channel, struct pci_dev *
 	t3e3_init(channel);
 
 	if (request_irq(dev->irq, &t3e3_intr, IRQF_SHARED, dev->name, dev)) {
-		printk(KERN_WARNING "%s: could not get irq: %d\n", dev->name, dev->irq);
+		netdev_warn(channel->dev, "%s: could not get irq: %d\n",
+			    dev->name, dev->irq);
 		goto free_regions;
 	}
 
@@ -137,7 +140,8 @@ static int __devinit t3e3_init_card(struct pci_dev *pdev, const struct pci_devic
 				break; /* found the second channel */
 
 		if (!pdev1) {
-			printk(KERN_ERR "SBE 2T3E3" ": Can't find the second channel\n");
+			dev_err(&pdev->dev,
+				"SBE 2T3E3" ": Can't find the second channel\n");
 			return -EFAULT;
 		}
 		channels = 2;
@@ -146,7 +150,7 @@ static int __devinit t3e3_init_card(struct pci_dev *pdev, const struct pci_devic
 
 	card = kzalloc(sizeof(struct card) + channels * sizeof(struct channel), GFP_KERNEL);
 	if (!card) {
-		printk(KERN_ERR "SBE 2T3E3" ": Out of memory\n");
+		dev_err(&pdev->dev, "SBE 2T3E3" ": Out of memory\n");
 		return -ENOBUFS;
 	}
 
-- 
1.7.9.5

