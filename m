Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab2JNPMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:12:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46177 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754302Ab2JNOmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:08 -0400
Message-Id: <20121014143551.619194043@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Francois Romieu <romieu@fr.zoreil.com>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [ 132/147] r8169: Config1 is read-only on 8168c and later.
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

commit 851e60221926a53344b4227879858bef841b0477 upstream.

Suggested by Hayes.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/realtek/r8169.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 71393ea..9b0b00b 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -1396,7 +1396,6 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 		u16 reg;
 		u8  mask;
 	} cfg[] = {
-		{ WAKE_ANY,   Config1, PMEnable },
 		{ WAKE_PHY,   Config3, LinkUp },
 		{ WAKE_MAGIC, Config3, MagicPacket },
 		{ WAKE_UCAST, Config5, UWF },
@@ -1404,16 +1403,28 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
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
 


