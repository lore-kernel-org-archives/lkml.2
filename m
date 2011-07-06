Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab1GFH6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 03:58:52 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:45958 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1GFH6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 03:58:49 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.11 with qID p667wiYc003443
From: Hayes Wang <hayeswang@realtek.com>
To: <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v2 4/7] r8169: add ERI functions
Date: Wed, 6 Jul 2011 15:58:05 +0800
X-BOX-Message-Id: p667wiYc003443
Message-ID: <1309939088-31994-4-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1309939088-31994-1-git-send-email-hayeswang@realtek.com>
References: <1309939088-31994-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the ERI functions which would be used by the new chips.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/r8169.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 50bf897..f83e9fa 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1043,6 +1043,49 @@ static u32 rtl_csi_read(void __iomem *ioaddr, int addr)
 	return value;
 }
 
+static
+void rtl_eri_write(void __iomem *ioaddr, int addr, u32 mask, u32 val, int type)
+{
+	unsigned int i;
+
+	BUG_ON((addr & 3) || (mask == 0));
+	RTL_W32(ERIDR, val);
+	RTL_W32(ERIAR, ERIAR_WRITE_CMD | type | mask | addr);
+
+	for (i = 0; i < 100; i++) {
+		if (!(RTL_R32(ERIAR) & ERIAR_FLAG))
+			break;
+		udelay(100);
+	}
+}
+
+static  u32 rtl_eri_read(void __iomem *ioaddr, int addr, int type)
+{
+	unsigned int i;
+	u32 value = ~0x00;
+
+	RTL_W32(ERIAR, ERIAR_READ_CMD | type | ERIAR_MASK_1111 | addr);
+
+	for (i = 0; i < 100; i++) {
+		if (RTL_R32(ERIAR) & ERIAR_FLAG) {
+			value = RTL_R32(ERIDR);
+			break;
+		}
+		udelay(100);
+	}
+
+	return value;
+}
+
+static void
+rtl_eri_write_w0w1(void __iomem *ioaddr, int addr, u32 mask, u32 m, u32 p, int type)
+{
+	u32 val;
+
+	val = rtl_eri_read(ioaddr, addr, type);
+	rtl_eri_write(ioaddr, addr, mask, (val & ~m) | p, type);
+}
+
 static u8 rtl8168d_efuse_read(void __iomem *ioaddr, int reg_addr)
 {
 	u8 value = 0xff;
-- 
1.7.3.2

