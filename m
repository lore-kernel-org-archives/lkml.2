Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965002Ab2JKCUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:20:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50797 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964901Ab2JKCP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:15:27 -0400
X-Sasl-enc: QQaihTZSjmwi0f0wm8N7fpTuWLnp4/Jt2fspBlKcCIwK 1349921726
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Francois Romieu <romieu@fr.zoreil.com>,
        hayeswang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 66/84] r8169: Rx FIFO overflow fixes.
Date: Thu, 11 Oct 2012 11:03:50 +0900
Message-Id: <20121011015428.948327309@linuxfoundation.org>
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

commit 811fd3010cf512f2e23e6c4c912aad54516dc706 upstream.

Realtek has specified that the post 8168c gigabit chips and the post
8105e fast ethernet chips recover automatically from a Rx FIFO overflow.
The driver does not need to clear the RxFIFOOver bit of IntrStatus and
it should rather avoid messing it.

The implementation deserves some explanation:
1. events outside of the intr_event bit mask are now ignored. It enforces
   a no-processing policy for the events that either should not be there
   or should be ignored.

2. RxFIFOOver was already ignored in rtl_cfg_infos[RTL_CFG_1] for the
   whole 8168 line of chips with two exceptions:
   - RTL_GIGA_MAC_VER_22 since b5ba6d12bdac21bc0620a5089e0f24e362645efd
     ("use RxFIFO overflow workaround for 8168c chipset.").
     This one should now be correctly handled.
   - RTL_GIGA_MAC_VER_11 (8168b) which requires a different Rx FIFO
     overflow processing.

   Though it does not conform to Realtek suggestion above, the updated
   driver includes no change for RTL_GIGA_MAC_VER_12 and RTL_GIGA_MAC_VER_17.
   Both are 8168b. RTL_GIGA_MAC_VER_12 is common and a bit old so I'd rather
   wait for experimental evidence that the change suggested by Realtek really
   helps or does not hurt in unexpected ways.

   Removed case statements in rtl8169_interrupt are only 8168 relevant.

3. RxFIFOOver is masked for post 8105e 810x chips, namely the sole 8105e
   (RTL_GIGA_MAC_VER_30) itself.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: hayeswang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/r8169.c |   54 +++++++++++++++++++++++-----------------------------
 1 file changed, 24 insertions(+), 30 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1088,17 +1088,21 @@ static u8 rtl8168d_efuse_read(void __iom
 	return value;
 }
 
-static void rtl8169_irq_mask_and_ack(void __iomem *ioaddr)
+static void rtl8169_irq_mask_and_ack(struct rtl8169_private *tp)
 {
-	RTL_W16(IntrMask, 0x0000);
+	void __iomem *ioaddr = tp->mmio_addr;
 
-	RTL_W16(IntrStatus, 0xffff);
+	RTL_W16(IntrMask, 0x0000);
+	RTL_W16(IntrStatus, tp->intr_event);
+	RTL_R8(ChipCmd);
 }
 
-static void rtl8169_asic_down(void __iomem *ioaddr)
+static void rtl8169_asic_down(struct rtl8169_private *tp)
 {
+	void __iomem *ioaddr = tp->mmio_addr;
+
 	RTL_W8(ChipCmd, 0x00);
-	rtl8169_irq_mask_and_ack(ioaddr);
+	rtl8169_irq_mask_and_ack(tp);
 	RTL_R16(CPlusCmd);
 }
 
@@ -3817,7 +3821,7 @@ static void rtl8169_hw_reset(struct rtl8
 	void __iomem *ioaddr = tp->mmio_addr;
 
 	/* Disable interrupts */
-	rtl8169_irq_mask_and_ack(ioaddr);
+	rtl8169_irq_mask_and_ack(tp);
 
 	if (tp->mac_version == RTL_GIGA_MAC_VER_27 ||
 	    tp->mac_version == RTL_GIGA_MAC_VER_28 ||
@@ -4284,8 +4288,7 @@ static void rtl_hw_start_8168(struct net
 	RTL_W16(IntrMitigate, 0x5151);
 
 	/* Work around for RxFIFO overflow. */
-	if (tp->mac_version == RTL_GIGA_MAC_VER_11 ||
-	    tp->mac_version == RTL_GIGA_MAC_VER_22) {
+	if (tp->mac_version == RTL_GIGA_MAC_VER_11) {
 		tp->intr_event |= RxFIFOOver | PCSTimeout;
 		tp->intr_event &= ~RxOverflow;
 	}
@@ -4467,6 +4470,11 @@ static void rtl_hw_start_8101(struct net
 	void __iomem *ioaddr = tp->mmio_addr;
 	struct pci_dev *pdev = tp->pci_dev;
 
+	if (tp->mac_version >= RTL_GIGA_MAC_VER_30) {
+		tp->intr_event &= ~RxFIFOOver;
+		tp->napi_event &= ~RxFIFOOver;
+	}
+
 	if (tp->mac_version == RTL_GIGA_MAC_VER_13 ||
 	    tp->mac_version == RTL_GIGA_MAC_VER_16) {
 		int cap = tp->pcie_cap;
@@ -4738,7 +4746,7 @@ static void rtl8169_wait_for_quiescence(
 	/* Wait for any pending NAPI task to complete */
 	napi_disable(&tp->napi);
 
-	rtl8169_irq_mask_and_ack(ioaddr);
+	rtl8169_irq_mask_and_ack(tp);
 
 	tp->intr_mask = 0xffff;
 	RTL_W16(IntrMask, tp->intr_event);
@@ -5200,13 +5208,17 @@ static irqreturn_t rtl8169_interrupt(int
 	 */
 	status = RTL_R16(IntrStatus);
 	while (status && status != 0xffff) {
+		status &= tp->intr_event;
+		if (!status)
+			break;
+
 		handled = 1;
 
 		/* Handle all of the error cases first. These will reset
 		 * the chip, so just exit the loop.
 		 */
 		if (unlikely(!netif_running(dev))) {
-			rtl8169_asic_down(ioaddr);
+			rtl8169_asic_down(tp);
 			break;
 		}
 
@@ -5214,27 +5226,9 @@ static irqreturn_t rtl8169_interrupt(int
 			switch (tp->mac_version) {
 			/* Work around for rx fifo overflow */
 			case RTL_GIGA_MAC_VER_11:
-			case RTL_GIGA_MAC_VER_22:
-			case RTL_GIGA_MAC_VER_26:
 				netif_stop_queue(dev);
 				rtl8169_tx_timeout(dev);
 				goto done;
-			/* Testers needed. */
-			case RTL_GIGA_MAC_VER_17:
-			case RTL_GIGA_MAC_VER_19:
-			case RTL_GIGA_MAC_VER_20:
-			case RTL_GIGA_MAC_VER_21:
-			case RTL_GIGA_MAC_VER_23:
-			case RTL_GIGA_MAC_VER_24:
-			case RTL_GIGA_MAC_VER_27:
-			case RTL_GIGA_MAC_VER_28:
-			case RTL_GIGA_MAC_VER_31:
-			/* Experimental science. Pktgen proof. */
-			case RTL_GIGA_MAC_VER_12:
-			case RTL_GIGA_MAC_VER_25:
-				if (status == RxFIFOOver)
-					goto done;
-				break;
 			default:
 				break;
 			}
@@ -5329,7 +5323,7 @@ static void rtl8169_down(struct net_devi
 
 	spin_lock_irq(&tp->lock);
 
-	rtl8169_asic_down(ioaddr);
+	rtl8169_asic_down(tp);
 	/*
 	 * At this point device interrupts can not be enabled in any function,
 	 * as netif_running is not true (rtl8169_interrupt, rtl8169_reset_task,
@@ -5583,7 +5577,7 @@ static void rtl_shutdown(struct pci_dev
 
 	spin_lock_irq(&tp->lock);
 
-	rtl8169_asic_down(ioaddr);
+	rtl8169_asic_down(tp);
 
 	spin_unlock_irq(&tp->lock);
 


