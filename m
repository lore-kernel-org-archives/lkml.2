Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab2G3K0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 06:26:04 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49721 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab2G3K0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 06:26:01 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        ramakrishna.pallala@intel.com, linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH V2 2/2] lp8727_charger: unregister power supply at error path of lp8727_register_psy
Date: Mon, 30 Jul 2012 16:10:46 +0545
Message-Id: <1343643946-12815-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if usb power supply registration fails,
        we wont unregister the ac power supply
if battery power supply registration fails,
        we wont unregister the usb, and ac supply,

take care of those things and also no need of goto -err_mem: at the fail case of
kzalloc simply can have return -ENOMEM

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
Changes since V2:
 * fix the comments from the Ramakrishna (ramakrishna.pallala@intel.com)
quoting his comments:

>       if (power_supply_register(pchg->dev, &psy->usb))
> -             goto err_psy;
> +             goto err_psy_ac;

"err_psy_ac" label name is confusing. Why can't you use err_psy_usb

>       if (power_supply_register(pchg->dev, &psy->batt))
> -             goto err_psy;
> +             goto err_psy_usb;

Same here, why don't you use err_psy_batt

 drivers/power/lp8727_charger.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 6c0e0f9..8fb1c0f 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -362,7 +362,7 @@ static int lp8727_register_psy(struct lp8727_chg *pchg)
 
 	psy = kzalloc(sizeof(*psy), GFP_KERNEL);
 	if (!psy)
-		goto err_mem;
+		return -ENOMEM;
 
 	pchg->psy = psy;
 
@@ -386,7 +386,7 @@ static int lp8727_register_psy(struct lp8727_chg *pchg)
 	psy->usb.num_supplicants = ARRAY_SIZE(battery_supplied_to);
 
 	if (power_supply_register(pchg->dev, &psy->usb))
-		goto err_psy;
+		goto err_psy_usb;
 
 	psy->batt.name = "main_batt";
 	psy->batt.type = POWER_SUPPLY_TYPE_BATTERY;
@@ -396,12 +396,14 @@ static int lp8727_register_psy(struct lp8727_chg *pchg)
 	psy->batt.external_power_changed = lp8727_charger_changed;
 
 	if (power_supply_register(pchg->dev, &psy->batt))
-		goto err_psy;
+		goto err_psy_batt;
 
 	return 0;
 
-err_mem:
-	return -ENOMEM;
+err_psy_batt:
+	power_supply_unregister(&psy->usb);
+err_psy_usb:
+	power_supply_unregister(&psy->ac);
 err_psy:
 	kfree(psy);
 	return -EPERM;
-- 
1.7.9.5

