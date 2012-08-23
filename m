Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab2HWCUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:20:41 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64367 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2HWCUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:20:39 -0400
Date: Wed, 22 Aug 2012 19:18:11 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Cc: Devendra Naga <develkernel412222@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] lp8727_charger: unregister power supply at error
 path of lp8727_register_psy
Message-ID: <20120823021811.GC24471@lizard>
References: <1343584015-30344-1-git-send-email-develkernel412222@gmail.com>
 <D854C92F57B1B347B57E531E78D05EAD1C5372@BGSMSX102.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <D854C92F57B1B347B57E531E78D05EAD1C5372@BGSMSX102.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 04:47:44AM +0000, Pallala, Ramakrishna wrote:
> >  	if (power_supply_register(pchg->dev, &psy->usb))
> > -		goto err_psy;
> > +		goto err_psy_ac;
> 
> "err_psy_ac" label name is confusing. Why can't you use err_psy_usb
> 
> >  	if (power_supply_register(pchg->dev, &psy->batt))
> > -		goto err_psy;
> > +		goto err_psy_usb;
> 
> Same here, why don't you use err_psy_batt

Thanks, folks! It was easy to change so I applied the following:

commit 6297b5e54b5511d4e72e8d5fc3b139650adc74d8
Author: Devendra Naga <develkernel412222@gmail.com>
Date:   Sun Jul 29 23:31:55 2012 +0545

    lp8727_charger: Unregister power supply at error path of lp8727_register_psy
    
    if usb power supply registration fails,
    	we wont unregister the ac power supply
    if battery power supply registration fails,
    	we wont unregister the usb, and ac supply,
    
    take care of those things and also no need of goto -err_mem: at the fail case of
    kzalloc simply can have return -ENOMEM
    
    Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
    Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 6a364f4..4e37b26 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -362,7 +362,7 @@ static int lp8727_register_psy(struct lp8727_chg *pchg)
 
 	psy = kzalloc(sizeof(*psy), GFP_KERNEL);
 	if (!psy)
-		goto err_mem;
+		return -ENOMEM;
 
 	pchg->psy = psy;
 
@@ -375,7 +375,7 @@ static int lp8727_register_psy(struct lp8727_chg *pchg)
 	psy->ac.num_supplicants = ARRAY_SIZE(battery_supplied_to);
 
 	if (power_supply_register(pchg->dev, &psy->ac))
-		goto err_psy;
+		goto err_psy_ac;
 
 	psy->usb.name = "usb";
 	psy->usb.type = POWER_SUPPLY_TYPE_USB;
@@ -386,7 +386,7 @@ static int lp8727_register_psy(struct lp8727_chg *pchg)
 	psy->usb.num_supplicants = ARRAY_SIZE(battery_supplied_to);
 
 	if (power_supply_register(pchg->dev, &psy->usb))
-		goto err_psy;
+		goto err_psy_usb;
 
 	psy->batt.name = "main_batt";
 	psy->batt.type = POWER_SUPPLY_TYPE_BATTERY;
@@ -396,13 +396,15 @@ static int lp8727_register_psy(struct lp8727_chg *pchg)
 	psy->batt.external_power_changed = lp8727_charger_changed;
 
 	if (power_supply_register(pchg->dev, &psy->batt))
-		goto err_psy;
+		goto err_psy_batt;
 
 	return 0;
 
-err_mem:
-	return -ENOMEM;
-err_psy:
+err_psy_batt:
+	power_supply_unregister(&psy->usb);
+err_psy_usb:
+	power_supply_unregister(&psy->ac);
+err_psy_ac:
 	kfree(psy);
 	return -EPERM;
 }
