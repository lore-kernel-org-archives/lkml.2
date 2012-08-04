Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab2HDRK7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 13:10:59 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:54326 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753728Ab2HDRK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 13:10:56 -0400
X-IronPort-AV: E=Sophos;i="4.77,713,1336341600"; 
   d="scan'208";a="169080479"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "Jean Delvare" <khali@linux-fr.org>
Cc: kernel-janitors@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/i2c/i2c-smbus.c: convert kzalloc to devm_kzalloc
Date: Sat,  4 Aug 2012 19:10:48 +0200
Message-Id: <1344100248-16238-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Converting kzalloc to devm_kzalloc simplifies the code and ensures that the
result, alert, is freed after the irq allocated by the subsequent
devm_request_irq.  This in turn ensures that when an interrupt can be
triggered, the alert structure is still available.

The problem of a free after a devm_request_irq was found using the
following semantic match (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression e1,e2,x,a,b,c,d;
identifier free;
position p1,p2;
@@

  devm_request_irq@p1(e1,e2,...,x)
  ... when any
      when != e2 = a
      when != x = b
  if (...) {
    ... when != e2 = c
        when != x = d
    free@p2(...,x,...);
    ...
    return ...;
  }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/i2c/i2c-smbus.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/i2c-smbus.c b/drivers/i2c/i2c-smbus.c
index df3e0bf..50a36cf 100644
--- a/drivers/i2c/i2c-smbus.c
+++ b/drivers/i2c/i2c-smbus.c
@@ -142,7 +142,8 @@ static int smbalert_probe(struct i2c_client *ara,
 	struct i2c_adapter *adapter = ara->adapter;
 	int res;
 
-	alert = kzalloc(sizeof(struct i2c_smbus_alert), GFP_KERNEL);
+	alert = devm_kzalloc(&ara->dev, sizeof(struct i2c_smbus_alert),
+			     GFP_KERNEL);
 	if (!alert)
 		return -ENOMEM;
 
@@ -154,10 +155,8 @@ static int smbalert_probe(struct i2c_client *ara,
 	if (setup->irq > 0) {
 		res = devm_request_irq(&ara->dev, setup->irq, smbalert_irq,
 				       0, "smbus_alert", alert);
-		if (res) {
-			kfree(alert);
+		if (res)
 			return res;
-		}
 	}
 
 	i2c_set_clientdata(ara, alert);
@@ -167,14 +166,12 @@ static int smbalert_probe(struct i2c_client *ara,
 	return 0;
 }
 
-/* IRQ resource is managed so it is freed automatically */
+/* IRQ resource and alert are managed so they are freed automatically */
 static int smbalert_remove(struct i2c_client *ara)
 {
 	struct i2c_smbus_alert *alert = i2c_get_clientdata(ara);
 
 	cancel_work_sync(&alert->alert);
-
-	kfree(alert);
 	return 0;
 }
 

