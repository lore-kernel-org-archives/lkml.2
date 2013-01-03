Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab3ACGae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 01:30:34 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38693 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab3ACGac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 01:30:32 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "cbou@mail.ru" <cbou@mail.ru>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] lp8788-charger: fix a parent device in kernel messages
Thread-Topic: [PATCH 2/2] lp8788-charger: fix a parent device in kernel
 messages
Thread-Index: Ac3pe8wmzBQujsEySbS7lJqI0ZLSzw==
Date: Thu, 3 Jan 2013 06:30:18 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E10FF0@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Use 'platform_device' in kernel messages rather than i2c client
 device node.
 lp8788_update_charger_params() needs additional argument, 'pdev'.
 Then, remove unnecessary lp8788 private data in lp8788_irq_register().

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8788-charger.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/power/lp8788-charger.c b/drivers/power/lp8788-charger.c
index 126a83a..e33d6b2 100644
--- a/drivers/power/lp8788-charger.c
+++ b/drivers/power/lp8788-charger.c
@@ -367,7 +367,8 @@ static inline bool lp8788_is_valid_charger_register(u8 addr)
 	return addr >= LP8788_CHG_START && addr <= LP8788_CHG_END;
 }
 
-static int lp8788_update_charger_params(struct lp8788_charger *pchg)
+static int lp8788_update_charger_params(struct platform_device *pdev,
+					struct lp8788_charger *pchg)
 {
 	struct lp8788 *lp = pchg->lp;
 	struct lp8788_charger_platform_data *pdata = pchg->pdata;
@@ -376,7 +377,7 @@ static int lp8788_update_charger_params(struct lp8788_charger *pchg)
 	int ret;
 
 	if (!pdata || !pdata->chg_params) {
-		dev_info(lp->dev, "skip updating charger parameters\n");
+		dev_info(&pdev->dev, "skip updating charger parameters\n");
 		return 0;
 	}
 
@@ -537,7 +538,6 @@ err_free_irq:
 static int lp8788_irq_register(struct platform_device *pdev,
 				struct lp8788_charger *pchg)
 {
-	struct lp8788 *lp = pchg->lp;
 	const char *name[] = {
 		LP8788_CHG_IRQ, LP8788_PRSW_IRQ, LP8788_BATT_IRQ
 	};
@@ -550,13 +550,13 @@ static int lp8788_irq_register(struct platform_device *pdev,
 	for (i = 0; i < ARRAY_SIZE(name); i++) {
 		ret = lp8788_set_irqs(pdev, pchg, name[i]);
 		if (ret) {
-			dev_warn(lp->dev, "irq setup failed: %s\n", name[i]);
+			dev_warn(&pdev->dev, "irq setup failed: %s\n", name[i]);
 			return ret;
 		}
 	}
 
 	if (pchg->num_irqs > LP8788_MAX_CHG_IRQS) {
-		dev_err(lp->dev, "invalid total number of irqs: %d\n",
+		dev_err(&pdev->dev, "invalid total number of irqs: %d\n",
 			pchg->num_irqs);
 		return -EINVAL;
 	}
@@ -701,7 +701,7 @@ static int lp8788_charger_probe(struct platform_device *pdev)
 	pchg->pdata = lp->pdata ? lp->pdata->chg_pdata : NULL;
 	platform_set_drvdata(pdev, pchg);
 
-	ret = lp8788_update_charger_params(pchg);
+	ret = lp8788_update_charger_params(pdev, pchg);
 	if (ret)
 		return ret;
 
-- 
1.7.9.5


Best Regards,
Milo


