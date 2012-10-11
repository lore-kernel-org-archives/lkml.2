Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934377Ab2JKC0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:26:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57877 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933397Ab2JKC0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:26:30 -0400
X-Sasl-enc: 34THFXbZIxOruW9cDL7qfrMy+Fq1CP6S2CiQq5FUbHlB 1349922389
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Francois Romieu <romieu@fr.zoreil.com>,
        Hayes Wang <hayeswang@realtek.com>,
        Jonathan Nieder <jrnieder@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 70/84] r8169: Config1 is read-only on 8168c and later.
Date: Thu, 11 Oct 2012 11:03:54 +0900
Message-Id: <20121011015429.673716923@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

commit 851e60221926a53344b4227879858bef841b0477 upstream.

Suggested by Hayes.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Hayes Wang <hayeswang@realtek.com>
Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/r8169.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1223,7 +1223,6 @@ static void __rtl8169_set_wol(struct rtl
 		u16 reg;
 		u8  mask;
 	} cfg[] = {
-		{ WAKE_ANY,   Config1, PMEnable },
 		{ WAKE_PHY,   Config3, LinkUp },
 		{ WAKE_MAGIC, Config3, MagicPacket },
 		{ WAKE_UCAST, Config5, UWF },
@@ -1231,16 +1230,28 @@ static void __rtl8169_set_wol(struct rtl
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
 


