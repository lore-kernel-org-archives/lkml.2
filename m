Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab1GNCKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 22:10:03 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53413 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab1GNCKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 22:10:00 -0400
Subject: [PATCH] Input: pmic8xxx-keypad - fix a leak of the IRQ during init
 failure
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Trilok Soni <tsoni@codeaurora.org>,
        Anirudh Ghayal <aghayal@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 10:09:51 +0800
Message-ID: <1310609391.14393.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we are passing the same cookie in all calls to
request_any_context_irq() and free_irq().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/keyboard/pmic8xxx-keypad.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/input/keyboard/pmic8xxx-keypad.c b/drivers/input/keyboard/pmic8xxx-keypad.c
index 6229c3e..e7cc51d 100644
--- a/drivers/input/keyboard/pmic8xxx-keypad.c
+++ b/drivers/input/keyboard/pmic8xxx-keypad.c
@@ -700,9 +700,9 @@ static int __devinit pmic8xxx_kp_probe(struct platform_device *pdev)
 	return 0;
 
 err_pmic_reg_read:
-	free_irq(kp->key_stuck_irq, NULL);
+	free_irq(kp->key_stuck_irq, kp);
 err_req_stuck_irq:
-	free_irq(kp->key_sense_irq, NULL);
+	free_irq(kp->key_sense_irq, kp);
 err_gpio_config:
 err_get_irq:
 	input_free_device(kp->input);
@@ -717,8 +717,8 @@ static int __devexit pmic8xxx_kp_remove(struct platform_device *pdev)
 	struct pmic8xxx_kp *kp = platform_get_drvdata(pdev);
 
 	device_init_wakeup(&pdev->dev, 0);
-	free_irq(kp->key_stuck_irq, NULL);
-	free_irq(kp->key_sense_irq, NULL);
+	free_irq(kp->key_stuck_irq, kp);
+	free_irq(kp->key_sense_irq, kp);
 	input_unregister_device(kp->input);
 	kfree(kp);
 
-- 
1.7.4.1



