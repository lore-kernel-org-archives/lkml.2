Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964923Ab2JKCPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:15:38 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41636 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964898Ab2JKCPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:15:31 -0400
X-Sasl-enc: EbBEQ8AaZUmpRnwS6E3ryQn9QlybZQYcLYWyhjgTC+ST 1349921730
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Su Kang Yin <cantona@cantona.no-ip.org>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: =?UTF-8?q?=5B=2067/84=5D=20r8169=3A=20fix=20Config2=20MSIEnable=20bit=20setting=2E?=
Date: Thu, 11 Oct 2012 11:03:51 +0900
Message-Id: <20121011015429.133338101@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: françois romieu <romieu@fr.zoreil.com>

commit 2ca6cf06d988fea21e812a86be79353352677c9c upstream.

The MSIEnable bit is only available for the 8169.

Avoid Config2 writes for the post-8169 8168 and 810x.

Reported-by: Su Kang Yin <cantona@cantona.net>
Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/r8169.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -448,7 +448,6 @@ enum rtl_register_content {
 	/* Config1 register p.24 */
 	LEDS1		= (1 << 7),
 	LEDS0		= (1 << 6),
-	MSIEnable	= (1 << 5),	/* Enable Message Signaled Interrupt */
 	Speed_down	= (1 << 4),
 	MEMMAP		= (1 << 3),
 	IOMAP		= (1 << 2),
@@ -456,6 +455,7 @@ enum rtl_register_content {
 	PMEnable	= (1 << 0),	/* Power Management Enable */
 
 	/* Config2 register p. 25 */
+	MSIEnable	= (1 << 5),	/* 8169 only. Reserved in the 8168. */
 	PCI_Clock_66MHz = 0x01,
 	PCI_Clock_33MHz = 0x00,
 
@@ -3003,22 +3003,24 @@ static const struct rtl_cfg_info {
 };
 
 /* Cfg9346_Unlock assumed. */
-static unsigned rtl_try_msi(struct pci_dev *pdev, void __iomem *ioaddr,
+static unsigned rtl_try_msi(struct rtl8169_private *tp,
 			    const struct rtl_cfg_info *cfg)
 {
+	void __iomem *ioaddr = tp->mmio_addr;
 	unsigned msi = 0;
 	u8 cfg2;
 
 	cfg2 = RTL_R8(Config2) & ~MSIEnable;
 	if (cfg->features & RTL_FEATURE_MSI) {
-		if (pci_enable_msi(pdev)) {
-			dev_info(&pdev->dev, "no MSI. Back to INTx.\n");
+		if (pci_enable_msi(tp->pci_dev)) {
+			netif_info(tp, hw, tp->dev, "no MSI. Back to INTx.\n");
 		} else {
 			cfg2 |= MSIEnable;
 			msi = RTL_FEATURE_MSI;
 		}
 	}
-	RTL_W8(Config2, cfg2);
+	if (tp->mac_version <= RTL_GIGA_MAC_VER_06)
+		RTL_W8(Config2, cfg2);
 	return msi;
 }
 
@@ -3588,7 +3590,7 @@ rtl8169_init_one(struct pci_dev *pdev, c
 		tp->features |= RTL_FEATURE_WOL;
 	if ((RTL_R8(Config5) & (UWF | BWF | MWF)) != 0)
 		tp->features |= RTL_FEATURE_WOL;
-	tp->features |= rtl_try_msi(pdev, ioaddr, cfg);
+	tp->features |= rtl_try_msi(tp, cfg);
 	RTL_W8(Cfg9346, Cfg9346_Lock);
 
 	if ((tp->mac_version <= RTL_GIGA_MAC_VER_06) &&


