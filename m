Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab1JCHfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 03:35:21 -0400
Received: from mail.byterg.ru ([62.205.171.178]:42504 "EHLO mail.byterg.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab1JCHfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 03:35:17 -0400
X-Greylist: delayed 2261 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Oct 2011 03:35:17 EDT
Message-ID: <4E895CDC.7020200@mail.byterg.ru>
Date: Mon, 03 Oct 2011 10:57:32 +0400
From: Brilliantov Kirill Vladimirovich <brilliantovkv@mail.byterg.ru>
Reply-To: brilliantovkv@mail.byterg.ru
Organization: LLC Byterg
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110822 Icedove/3.1.12
MIME-Version: 1.0
To: mlindner@syskonnect.de
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] disable 1000Mb/s autonegotiation Marvell PHY for DM365/8
 processors
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!
Davinci DM365/8 processors have only 100Mb/s EMAC, I need disable 
1000Mb/s autonegotiation.
Tested on linux-2.6.18_pro500, Marvell 88E1111, TexasInstruments Davinci 
DM368ZCEF and TexasInstruments TMS320DM365ZCE30 processors.

Thank you and excuse me for my bad english.

Signed-off-by: Brilliantov Kirill Vladimirovich 
<brilliantovkv@mail.byterg.ru>
---
linux/drivers/net/phy/marvell.c |   25 ++++++++++++-------------
  1 files changed, 12 insertions(+), 13 deletions(-)
diff --git a/linux/drivers/net/phy/marvell.c 
b/linux/drivers/net/phy/marvell.c
index 0ad2532..b8cf47d 100644
--- a/linux/drivers/net/phy/marvell.c
+++ b/linux/drivers/net/phy/marvell.c
@@ -64,7 +64,7 @@ static int marvell_config_intr(struct phy_device *phydev)
  {
         int err;

-       if(phydev->interrupts == PHY_INTERRUPT_ENABLED)
+       if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
                 err = phy_write(phydev, MII_M1011_IMASK, 
MII_M1011_IMASK_INIT);
         else
                 err = phy_write(phydev, MII_M1011_IMASK, 
MII_M1011_IMASK_CLEAR);
@@ -104,24 +104,35 @@ static int marvell_config_aneg(struct phy_device 
*phydev)
         if (err < 0)
                 return err;

-
+#if defined(CONFIG_ARCH_DAVINCI_DM365)
+       err = phy_read(phydev, MII_CTRL1000);
+       if (err < 0)
+               return err;
+       //disable autonegotiation 1000Mb/s
+       err = phy_write(phydev, MII_CTRL1000,
+                       err & (~(ADVERTISE_1000FULL | ADVERTISE_1000HALF)));
+       if (err < 0)
+               return err;
+       err = phy_read(phydev, MII_CTRL1000);
+       if (err < 0)
+               return err;
+#endif
         err = genphy_config_aneg(phydev);

         return err;
  }

-
  static struct phy_driver m88e1101_driver = {
-       .phy_id         = 0x01410c00,
-       .phy_id_mask    = 0xffffff00,
-       .name           = "Marvell 88E1101",
-       .features       = PHY_GBIT_FEATURES,
-       .flags          = PHY_HAS_INTERRUPT,
-       .config_aneg    = &marvell_config_aneg,
-       .read_status    = &genphy_read_status,
-       .ack_interrupt  = &marvell_ack_interrupt,
-       .config_intr    = &marvell_config_intr,
-       .driver         = { .owner = THIS_MODULE,},
+       .phy_id = 0x01410c00,
+       .phy_id_mask = 0xffffff00,
+       .name = "Marvell 88E1101",
+       .features = PHY_GBIT_FEATURES,
+       .flags = PHY_HAS_INTERRUPT,
+       .config_aneg = &marvell_config_aneg,
+       .read_status = &genphy_read_status,
+       .ack_interrupt = &marvell_ack_interrupt,
+       .config_intr = &marvell_config_intr,
+       .driver = {.owner = THIS_MODULE,},
  };

  static int __init marvell_init(void)


-- 
С уважением,
Бриллиантов Кирилл Владимирович
…………………………………………………………………
программист, технический отдел
ООО «БайтЭрг»
Видеокамеры МВК – Эффективность разумных решений
…………………………………………………………………
+7(495)221-66-22
http://www.byterg.ru    http://www.bestdvr.ru
