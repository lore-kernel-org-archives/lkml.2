Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2HFMcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:32:15 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33417 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab2HFMcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:32:14 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] Input: ab8500-ponkey: Make the distinction between DT and non-DT boots
Date: Mon,  6 Aug 2012 13:32:03 +0100
Message-Id: <1344256323-10484-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we're booting with Device Tree enabled, we want the IRQ numbers to
be taken and translated from the Device Tree binary. If not, they
should be taken from the resource allocation defined in the AB8500 MFD
core driver.

Tested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/input/misc/ab8500-ponkey.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/input/misc/ab8500-ponkey.c b/drivers/input/misc/ab8500-ponkey.c
index 1a1d974..afcd87f 100644
--- a/drivers/input/misc/ab8500-ponkey.c
+++ b/drivers/input/misc/ab8500-ponkey.c
@@ -47,6 +47,7 @@ static irqreturn_t ab8500_ponkey_handler(int irq, void *data)
 static int __devinit ab8500_ponkey_probe(struct platform_device *pdev)
 {
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
+	struct device_node *np = pdev->dev.of_node;
 	struct ab8500_ponkey *ponkey;
 	struct input_dev *input;
 	int irq_dbf, irq_dbr;
@@ -73,8 +74,9 @@ static int __devinit ab8500_ponkey_probe(struct platform_device *pdev)
 
 	ponkey->idev = input;
 	ponkey->ab8500 = ab8500;
-	ponkey->irq_dbf = ab8500_irq_get_virq(ab8500, irq_dbf);
-	ponkey->irq_dbr = ab8500_irq_get_virq(ab8500, irq_dbr);
+
+	ponkey->irq_dbf = (np) ? ab8500_irq_get_virq(ab8500, irq_dbf) : irq_dbf;
+	ponkey->irq_dbr = (np) ? ab8500_irq_get_virq(ab8500, irq_dbr) : irq_dbr;
 
 	input->name = "AB8500 POn(PowerOn) Key";
 	input->dev.parent = &pdev->dev;
-- 
1.7.9.5

