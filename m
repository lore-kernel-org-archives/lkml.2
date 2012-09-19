Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab2ISRgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:36:23 -0400
Received: from nm23-vm6.bullet.mail.ird.yahoo.com ([212.82.109.235]:45816 "HELO
	nm23-vm6.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932268Ab2ISRgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:36:21 -0400
X-Yahoo-Newman-Id: 422784.27468.bm@smtp120.mail.ird.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: BAE3huUVM1k_cUOB2EsF8wRJ9rXb9u9QNs3WvGB8UK.XsCg
 l4XIApTo.23Htl9X6KSlzbU6dN8AFODetK.DEBYsZqy0GpEkj_PvYjtZhTwV
 Jxezjq2CMZGs7PU7JXwUdw6l9c6iEGgip5hel3yci6cl2FoPP1dlDJbGfceR
 ADGjPK6snGZAF4JVMPnX3zeuaZd71LUAnT_laFV6E4Ot2TK77RLLhcQgIt2j
 SDW8gxOplbx0WRDwsjlxxYFyuCRyjmOtM3JHyZPl.QgvrvysBqtARpCZH_m.
 offAgpu9l2_nQiOAcJamptwou8QZppnBJDf1wRGGKMhiV4N3Y3rGc8RUgIQ1
 d.hvdIFlnXCDq.kK2iLWqoDBjkKpEyVP_GoYsRWdHChouFww9FVueWEBjlMX
 .jVQ0R7VWaxiGMR5hfObEkw--
X-Yahoo-SMTP: 5Vuzu2WswBCxMnJ0hjKohBcp6M6Es6bt5AQ-
Message-ID: <505A0293.4070708@yahoo.com>
Date: Wed, 19 Sep 2012 18:36:19 +0100
From: Paul Parsons <lost.distance@yahoo.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: cbou@mail.ru, dwmw2@infradead.org
CC: philipp.zabel@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] pda_power: ac_draw used before set
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I reboot my iPAQ hx4700 in its cradle, the battery will not begin
to charge even though the AC supply is connected. Charging will start
only after the PDA power driver is tickled by some other power event,
such as reseating the iPAQ in its cradle or connecting the USB cable.

The problem lies in pda_power_probe(), where ac_draw is used by the call
to update_charger() before being set by the call to regulator_get().

Moving the regulator_get() call to before the update_charger() call
fixes the problem.

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
---
  drivers/power/pda_power.c |   16 +++++++++-------
  1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index 7312f26..d3be834d 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -281,6 +281,14 @@ static int pda_power_probe(struct platform_device 
*pdev)
  			goto init_failed;
  	}

+	ac_draw = regulator_get(dev, "ac_draw");
+	if (IS_ERR(ac_draw)) {
+		dev_dbg(dev, "couldn't get ac_draw regulator\n");
+		ret = PTR_ERR(ac_draw);
+		ac_draw = NULL;
+		goto ac_draw_failed;
+	}
+
  	update_status();
  	update_charger();

@@ -309,13 +317,6 @@ static int pda_power_probe(struct platform_device 
*pdev)
  		pda_psy_usb.num_supplicants = pdata->num_supplicants;
  	}

-	ac_draw = regulator_get(dev, "ac_draw");
-	if (IS_ERR(ac_draw)) {
-		dev_dbg(dev, "couldn't get ac_draw regulator\n");
-		ac_draw = NULL;
-		ret = PTR_ERR(ac_draw);
-	}
-
  #ifdef CONFIG_USB_OTG_UTILS
  	transceiver = usb_get_phy(USB_PHY_TYPE_USB2);
  	if (!IS_ERR_OR_NULL(transceiver)) {
@@ -415,6 +416,7 @@ ac_supply_failed:
  		regulator_put(ac_draw);
  		ac_draw = NULL;
  	}
+ac_draw_failed:
  	if (pdata->exit)
  		pdata->exit(dev);
  init_failed:
-- 
1.7.8.6
