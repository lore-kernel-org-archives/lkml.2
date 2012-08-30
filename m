Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab2H3Lib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 07:38:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57453 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab2H3Li1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 07:38:27 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Devendra Naga <develkernel412222@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: [PATCH 2/8] lp8727_charger: cleanup _probe() and _remove()
Thread-Topic: [PATCH 2/8] lp8727_charger: cleanup _probe() and _remove()
Thread-Index: Ac2Go+8nmkb7hXVVThi/QNLBzK1h6Q==
Date: Thu, 30 Aug 2012 11:38:20 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1C87@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: pp0= BTyi I/FD JNWR R7cl UTyE YM3G aciY roqq sd6y tKa3
 tg+k tpJD 4Ohf 49hB
 6I0D;5;YQBuAHQAbwBuAC4AdgBvAHIAbwBuAHQAcwBvAHYAQABsAGkAbgBhAHIAbwAuAG8AcgBnADsAYwBiAG8AdQBhAHQAbQBhAGkAbAByAHUAQABnAG0AYQBpAGwALgBjAG8AbQA7AGQAZQB2AGUAbABrAGUAcgBuAGUAbAA0ADEAMgAyADIAMgBAAGcAbQBhAGkAbAAuAGMAbwBtADsAZAB3AG0AdwAyAEAAaQBuAGYAcgBhAGQAZQBhAGQALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{8B14015F-BA91-4347-B48C-132AEB45E49F};bQBpAGwAbwAuAGsAaQBtAEAAdABpAC4AYwBvAG0A;Thu,
 30 Aug 2012 11:38:11
 GMT;WwBQAEEAVABDAEgAIAAyAC8AOABdACAAbABwADgANwAyADcAXwBjAGgAYQByAGcAZQByADoAIABjAGwAZQBhAG4AdQBwACAAXwBwAHIAbwBiAGUAKAApACAAYQBuAGQAIABfAHIAZQBtAG8AdgBlACgAKQA=
x-cr-puzzleid: {8B14015F-BA91-4347-B48C-132AEB45E49F}
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(a) register the power supply prior to creating irq handler
    After reordering the sequence, the interrupt issue can be gone
    when the power supply registration gets failed
(b) remove unnecessary goto statements
(c) unregister the power supply after releasing irq resources
    in reverse order of _probe()

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index fb3d7ac..4d51909 100644
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


