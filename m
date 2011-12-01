Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab1LAK0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 05:26:37 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:59254 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab1LAK0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 05:26:35 -0500
Date: Thu, 1 Dec 2011 11:20:00 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: booster@wolke7.net
Cc: hayeswang <hayeswang@realtek.com>,
        "'Jonathan Nieder'" <jrnieder@gmail.com>,
        "'Eric Dumazet'" <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        "'nic_swsd'" <nic_swsd@realtek.com>, linux-kernel@vger.kernel.org,
        "'Armin Kazmi'" <armin.kazmi@tu-dortmund.de>
Subject: Re: [bug?] r8169: hangs under heavy load
Message-ID: <20111201102000.GA14013@electric-eye.fr.zoreil.com>
References: <20111125222211.GA13719@electric-eye.fr.zoreil.com> <1322262357.2550.12.camel@edumazet-laptop> <20111126004447.GA14744@electric-eye.fr.zoreil.com> <1322280423.10212.3.camel@edumazet-laptop> <20111127092808.GE21635@elie.hsd1.il.comcast.net> <4ED2A573.1020807@wolke7.net> <20111127231147.GA1784@electric-eye.fr.zoreil.com> <D95C09DB1A7E493E89FE5A0B3879CEB0@realtek.com.tw> <20111129105440.GA2410@electric-eye.fr.zoreil.com> <4ED538EC.4010509@wolke7.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED538EC.4010509@wolke7.net>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

booster@wolke7.net <booster@wolke7.net> :
[...]
> Any more ideas ?

Give me a brain.

Fixed patch below.

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 6f06aa1..e776bf2 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -4885,8 +4894,7 @@ static void rtl_hw_start_8168(struct net_device *dev)
 	RTL_W16(IntrMitigate, 0x5151);
 
 	/* Work around for RxFIFO overflow. */
-	if (tp->mac_version == RTL_GIGA_MAC_VER_11 ||
-	    tp->mac_version == RTL_GIGA_MAC_VER_22) {
+	if (tp->mac_version == RTL_GIGA_MAC_VER_11) {
 		tp->intr_event |= RxFIFOOver | PCSTimeout;
 		tp->intr_event &= ~RxOverflow;
 	}
@@ -5804,6 +5812,10 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 	 */
 	status = RTL_R16(IntrStatus);
 	while (status && status != 0xffff) {
+		status &= tp->intr_event;
+		if (!status)
+			break;
+
 		handled = 1;
 
 		/* Handle all of the error cases first. These will reset
@@ -5818,7 +5830,6 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 			switch (tp->mac_version) {
 			/* Work around for rx fifo overflow */
 			case RTL_GIGA_MAC_VER_11:
-			case RTL_GIGA_MAC_VER_22:
 			case RTL_GIGA_MAC_VER_26:
 				netif_stop_queue(dev);
 				rtl8169_tx_timeout(dev);
@@ -5828,6 +5839,7 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 			case RTL_GIGA_MAC_VER_19:
 			case RTL_GIGA_MAC_VER_20:
 			case RTL_GIGA_MAC_VER_21:
+			case RTL_GIGA_MAC_VER_22:
 			case RTL_GIGA_MAC_VER_23:
 			case RTL_GIGA_MAC_VER_24:
 			case RTL_GIGA_MAC_VER_27:
