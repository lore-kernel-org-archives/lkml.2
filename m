Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab2KTFaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 00:30:15 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65000 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2KTF3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 00:29:06 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 4/7] extcon: max8997: Fix incorrect error check and return value
Date: Tue, 20 Nov 2012 10:52:40 +0530
Message-Id: <1353388963-23761-5-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353388963-23761-1-git-send-email-sachin.kamat@linaro.org>
References: <1353388963-23761-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_create_mapping() returns 0 if it fails to provide a valid irq number.
'ret' needs to be updated with a negative error code before returning from
probe to signal probe failure. While at it, also corrected the 'virq' type to
unsigned from signed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-max8997.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index af8a5bc..ffdbe8c 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -450,11 +450,13 @@ static int __devinit max8997_muic_probe(struct platform_device *pdev)
 
 	for (i = 0; i < ARRAY_SIZE(muic_irqs); i++) {
 		struct max8997_muic_irq *muic_irq = &muic_irqs[i];
-		int virq = 0;
+		unsigned int virq = 0;
 
 		virq = irq_create_mapping(max8997->irq_domain, muic_irq->irq);
-		if (!virq)
+		if (!virq) {
+			ret = -EINVAL;
 			goto err_irq;
+		}
 		muic_irq->virq = virq;
 
 		ret = request_threaded_irq(virq, NULL, max8997_muic_irq_handler,
-- 
1.7.4.1

