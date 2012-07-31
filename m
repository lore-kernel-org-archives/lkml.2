Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab2GaEv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:51:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48883 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755752Ab2GaEvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:51:12 -0400
Message-Id: <20120731044314.995066122@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:33 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?fran=C3=A7ois=20romieu?= <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 23/73] r8169: RxConfig hack for the 8168evl.
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: françois romieu <romieu@fr.zoreil.com>

commit eb2dc35d99028b698cdedba4f5522bc43e576bd2 upstream.

The 8168evl (RTL_GIGA_MAC_VER_34) based Gigabyte GA-990FXA motherboards
are very prone to NETDEV watchdog problems without this change. See
https://bugzilla.kernel.org/show_bug.cgi?id=42899 for instance.

I don't know why it *works*. It's depressingly effective though.

For the record:
- the problem may go along IOMMU (AMD-Vi) errors but it really looks
  like a red herring.
- the patch sets the RX_MULTI_EN bit. If the 8168c doc is any guide,
  the chipset now fetches several Rx descriptors at a time.
- long ago the driver ignored the RX_MULTI_EN bit.
  e542a2269f232d61270ceddd42b73a4348dee2bb changed the RxConfig
  settings. Whatever the problem it's now labeled a regression.
- Realtek's own driver can identify two different 8168evl devices
  (CFG_METHOD_16 and CFG_METHOD_17) where the r8169 driver only
  sees one. It sucks.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/realtek/r8169.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 7260aa7..d7a04e0 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -3894,6 +3894,7 @@ static void rtl_init_rxcfg(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_22:
 	case RTL_GIGA_MAC_VER_23:
 	case RTL_GIGA_MAC_VER_24:
+	case RTL_GIGA_MAC_VER_34:
 		RTL_W32(RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST);
 		break;
 	default:


