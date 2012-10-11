Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780Ab2JKBjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:39:03 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33615 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933369Ab2JKBOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:14:01 -0400
X-Sasl-enc: TXHeifawf+c2HArJBJVpV0ca28AzWg+Qawr9DlKtSmAl 1349918039
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Hayes Wang <hayeswang@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 098/120] r8169: Config1 is read-only on 8168c and later.
Date: Thu, 11 Oct 2012 10:00:50 +0900
Message-Id: <20121011005844.955965076@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

commit 851e60221926a53344b4227879858bef841b0477 upstream.

Suggested by Hayes.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Hayes Wang <hayeswang@realtek.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -1400,7 +1400,6 @@ static void __rtl8169_set_wol(struct rtl
 		u16 reg;
 		u8  mask;
 	} cfg[] = {
-		{ WAKE_ANY,   Config1, PMEnable },
 		{ WAKE_PHY,   Config3, LinkUp },
 		{ WAKE_MAGIC, Config3, MagicPacket },
 		{ WAKE_UCAST, Config5, UWF },
@@ -1408,16 +1407,28 @@ static void __rtl8169_set_wol(struct rtl
 		{ WAKE_MCAST, Config5, MWF },
 		{ WAKE_ANY,   Config5, LanWake }
 	};
+	u8 options;
 
 	RTL_W8(Cfg9346, Cfg9346_Unlock);
 
 	for (i = 0; i < ARRAY_SIZE(cfg); i++) {
-		u8 options = RTL_R8(cfg[i].reg) & ~cfg[i].mask;
+		options = RTL_R8(cfg[i].reg) & ~cfg[i].mask;
 		if (wolopts & cfg[i].opt)
 			options |= cfg[i].mask;
 		RTL_W8(cfg[i].reg, options);
 	}
 
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_01 ... RTL_GIGA_MAC_VER_17:
+		options = RTL_R8(Config1) & ~PMEnable;
+		if (wolopts)
+			options |= PMEnable;
+		RTL_W8(Config1, options);
+		break;
+	default:
+		break;
+	}
+
 	RTL_W8(Cfg9346, Cfg9346_Lock);
 }
 


