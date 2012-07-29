Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab2G2Rqu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 13:46:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53255 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab2G2Rqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 13:46:49 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH 1/2] lp8727_charger: free_irq when lp8727_register_psy fail
Date: Sun, 29 Jul 2012 23:31:39 +0545
Message-Id: <1343583999-30231-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

actually the driver does a request_threaded_irq and after this it calls
lp8727_register_psy, and if it fails it doesn't free the irqs that it
registered to

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/power/lp8727_charger.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index d8b7578..699f0ef 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -454,11 +454,13 @@ static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	ret = lp8727_register_psy(pchg);
 	if (ret) {
 		dev_err(pchg->dev, "power supplies register err: %d", ret);
-		goto error;
+		goto error_irq;
 	}
 
 	return 0;
 
+error_irq:
+	free_irq(pchg->client->irq, pchg);
 error:
 	kfree(pchg);
 	return ret;
-- 
1.7.9.5

