Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946360Ab2CPXkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:40:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45118 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946344Ab2CPXkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:40:43 -0400
Message-Id: <20120316233812.585875871@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Francois Romieu <romieu@fr.zoreil.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 22/41] r8169: corrupted IP fragments fix for large mtu.
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: françois romieu <romieu@fr.zoreil.com>

[ Upstream commit 9c5028e9da1255dd2b99762d8627b88b29f68cce ]

Noticed with the 8168d (-vb-gr, aka RTL_GIGA_MAC_VER_26).

ConfigX registers should only be written while the Config9346 lock
is held.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Reported-by: Nick Bowler <nbowler@elliptictech.com>
Cc: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -3781,12 +3781,20 @@ static void rtl8169_init_ring_indexes(st
 
 static void rtl_hw_jumbo_enable(struct rtl8169_private *tp)
 {
+	void __iomem *ioaddr = tp->mmio_addr;
+
+	RTL_W8(Cfg9346, Cfg9346_Unlock);
 	rtl_generic_op(tp, tp->jumbo_ops.enable);
+	RTL_W8(Cfg9346, Cfg9346_Lock);
 }
 
 static void rtl_hw_jumbo_disable(struct rtl8169_private *tp)
 {
+	void __iomem *ioaddr = tp->mmio_addr;
+
+	RTL_W8(Cfg9346, Cfg9346_Unlock);
 	rtl_generic_op(tp, tp->jumbo_ops.disable);
+	RTL_W8(Cfg9346, Cfg9346_Lock);
 }
 
 static void r8168c_hw_jumbo_enable(struct rtl8169_private *tp)


