Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab3AIIVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:21:48 -0500
Received: from fallback8.mail.ru ([94.100.176.136]:37371 "EHLO
	fallback8.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315Ab3AIIVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:21:44 -0500
From: =?UTF-8?B?S2lyaWxsIEthcHJhbm92?= <kapranoff@inbox.ru>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?W1BBVENIXSBFbGltaW5hdGUgdGhlIGZvcmNlZCBzcGVlZCByZWR1Y3Rpb24g?=
 =?UTF-8?B?YWxnb3JpdGht?=
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: [195.131.77.126]
Date: Wed, 09 Jan 2013 12:21:12 +0400
Reply-To: =?UTF-8?B?S2lyaWxsIEthcHJhbm92?= <kapranoff@inbox.ru>
X-Priority: 3 (Normal)
Message-ID: <1357719672.688670642@f210.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r098M0tc005143

NET/PHY: Eliminate the forced speed reduction algorithm.
In case of the fixed speed set up for NIC 
(e.g. ethtool -s eth0 autoneg off speed 100 duplex full)
with ethernet cable plugged off, mentioned algorithm
slows down NIC speed, so the further "hooking up" gives
no result. AFAIK, this behaviour is not RFCs' recommended.
Tested at 2.6.38.7, applicable up to for 3.0.4. 
Signed-off-by: Kirill Kapranov <kkk@nita.ru>,<kapranoff@inbox.ru>
--- linux/drivers/net/phy/phy.c.orig 2011-05-22 02:13:59.000000000 +0400
+++ linux/drivers/net/phy/phy.c 2012-04-28 12:49:37.000000000 +0400
@@ -457,34 +457,6 @@ void phy_stop_machine(struct phy_device
}

/**
- * phy_force_reduction - reduce PHY speed/duplex settings by one step
- * @phydev: target phy_device struct
- *
- * Description: Reduces the speed/duplex settings by one notch,
- * in this order--
- * 1000/FULL, 1000/HALF, 100/FULL, 100/HALF, 10/FULL, 10/HALF.
- * The function bottoms out at 10/HALF.
- */
-static void phy_force_reduction(struct phy_device *phydev)
-{
- int idx;
-
- idx = phy_find_setting(phydev->speed, phydev->duplex);
- 
- idx++;
-
- idx = phy_find_valid(idx, phydev->supported);
-
- phydev->speed = settings[idx].speed;
- phydev->duplex = settings[idx].duplex;
-
- pr_info("Trying %d/%s\n", phydev->speed,
- DUPLEX_FULL == phydev->duplex ?
- "FULL" : "HALF");
-}
-
-
-/**
* phy_error - enter HALTED state for this PHY device
* @phydev: target phy_device struct
*
@@ -814,30 +786,12 @@ void phy_state_machine(struct work_struc
phydev->adjust_link(phydev->attached_dev);

} else if (0 == phydev->link_timeout--) {
- int idx;

needs_aneg = 1;
/* If we have the magic_aneg bit,
* we try again */
if (phydev->drv->flags & PHY_HAS_MAGICANEG)
break;
-
- /* The timer expired, and we still
- * don't have a setting, so we try
- * forcing it until we find one that
- * works, starting from the fastest speed,
- * and working our way down */
- idx = phy_find_valid(0, phydev->supported);
-
- phydev->speed = settings[idx].speed;
- phydev->duplex = settings[idx].duplex;
-
- phydev->autoneg = AUTONEG_DISABLE;
-
- pr_info("Trying %d/%s\n", phydev->speed,
- DUPLEX_FULL ==
- phydev->duplex ?
- "FULL" : "HALF");
}
break;
case PHY_NOLINK:
@@ -863,7 +817,6 @@ void phy_state_machine(struct work_struc
netif_carrier_on(phydev->attached_dev);
} else {
if (0 == phydev->link_timeout--) {
- phy_force_reduction(phydev);
needs_aneg = 1;
}
}
 ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
