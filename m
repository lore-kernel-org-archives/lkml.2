Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2HaJXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:23:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43863 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab2HaJXM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:23:12 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/22] lp8727_charger: cleanup _probe() and _remove()
Thread-Topic: [PATCH 02/22] lp8727_charger: cleanup _probe() and _remove()
Thread-Index: Ac2HWjagRYZTGdg8QhSJdmElJN9Kew==
Date: Fri, 31 Aug 2012 09:23:03 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1E6C@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: BZf3 BbBN Btur Cvhq FsNZ Gb/T GzKA HKiG Lnwm LxRE M24/
 NEER NrRw Qqdv R4Ut
 VM76;3;YQBuAHQAbwBuAC4AdgBvAHIAbwBuAHQAcwBvAHYAQABsAGkAbgBhAHIAbwAuAG8AcgBnADsAZAB3AG0AdwAyAEAAaQBuAGYAcgBhAGQAZQBhAGQALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{B0A9867A-BC8E-4069-B870-72C32ACA61AF};bQBpAGwAbwAuAGsAaQBtAEAAdABpAC4AYwBvAG0A;Fri,
 31 Aug 2012 09:22:59
 GMT;WwBQAEEAVABDAEgAIAAwADIALwAyADIAXQAgAGwAcAA4ADcAMgA3AF8AYwBoAGEAcgBnAGUAcgA6ACAAYwBsAGUAYQBuAHUAcAAgAF8AcAByAG8AYgBlACgAKQAgAGEAbgBkACAAXwByAGUAbQBvAHYAZQAoACkA
x-cr-puzzleid: {B0A9867A-BC8E-4069-B870-72C32ACA61AF}
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 If the lp8727_register_psy() gets failed, registered interrupt handler
 should be freed, but this is not complete solution.
 It has still problem.
 Assume that the IRQ occurs while unregistering power supply devices.
 Then the ISR will access to freed IRQ.

 From Anton's opinion, it can be resolved if re-ordering the call sequence.

 Register power supplies first, then create interrupt handler.
 Then no need to free the IRQ in _probe().
 Additionally goto statements can be removed because those can be replaced with
 return statements.

 The _remove() should be changed the sequence - in reverse order of _probe()

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 0d3cb1d..b2df114 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -442,35 +442,33 @@ static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	ret = lp8727_init_device(pchg);
 	if (ret) {
 		dev_err(pchg->dev, "i2c communication err: %d", ret);
-		goto error;
+		return ret;
 	}
 
-	ret = lp8727_intr_config(pchg);
+	ret = lp8727_register_psy(pchg);
 	if (ret) {
-		dev_err(pchg->dev, "irq handler err: %d", ret);
-		goto error;
+		dev_err(pchg->dev, "power supplies register err: %d", ret);
+		return ret;
 	}
 
-	ret = lp8727_register_psy(pchg);
+	ret = lp8727_intr_config(pchg);
 	if (ret) {
-		dev_err(pchg->dev, "power supplies register err: %d", ret);
-		goto error;
+		dev_err(pchg->dev, "irq handler err: %d", ret);
+		lp8727_unregister_psy(pchg);
+		return ret;
 	}
 
 	return 0;
-
-error:
-	return ret;
 }
 
 static int __devexit lp8727_remove(struct i2c_client *cl)
 {
 	struct lp8727_chg *pchg = i2c_get_clientdata(cl);
 
-	lp8727_unregister_psy(pchg);
 	free_irq(pchg->client->irq, pchg);
 	flush_workqueue(pchg->irqthread);
 	destroy_workqueue(pchg->irqthread);
+	lp8727_unregister_psy(pchg);
 	return 0;
 }
 
-- 
1.7.9.5


Best Regards,
Milo


