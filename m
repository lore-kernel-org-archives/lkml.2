Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032882Ab2I1Ub1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:31:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55300 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964810Ab2I1UbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:31:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 182/218] r8169: RxConfig hack for the 8168evl.
Date: Fri, 28 Sep 2012 13:16:39 -0700
Message-Id: <20120928201522.388058526@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

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

---
 drivers/net/ethernet/realtek/r8169.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -3737,6 +3737,7 @@ static void rtl_init_rxcfg(struct rtl816
 	case RTL_GIGA_MAC_VER_22:
 	case RTL_GIGA_MAC_VER_23:
 	case RTL_GIGA_MAC_VER_24:
+	case RTL_GIGA_MAC_VER_34:
 		RTL_W32(RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST);
 		break;
 	default:


