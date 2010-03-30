Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab0CaASa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:18:30 -0400
Received: from kroah.org ([198.145.64.141]:51717 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756741Ab0C3XRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:25 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:00 2010
Message-Id: <20100330225600.398306625@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:54:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       mcarlson@broadcom.com, Mike Pagano <mpagano@gentoo.org>,
       Michael Chan <mchan@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [007/116] tg3: Fix 5906 transmit hangs
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matt Carlson <mcarlson@broadcom.com>

This is a resubmit backport of commit 92c6b8d16a36df3f28b2537bed2a56491fb08f11
to kernel version 2.6.32. The gentoo bug report can be found at
https://bugs.gentoo.org/show_bug.cgi?id=301091. Thanks to Matt Carlson for his
assistance and working me to fix a regression caused by the initial patch.  The
original description is as follows:

The 5906 has trouble with fragments that are less than 8 bytes in size.  This
patch works around the problem by pivoting the 5906's transmit routine to
tg3_start_xmit_dma_bug() and introducing a new SHORT_DMA_BUG flag that enables
code to detect and react to the problematic condition.

Signed-off-by: Mike Pagano <mpagano@gentoo.org>
Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/tg3.c |   21 ++++++++++++++++-----
 drivers/net/tg3.h |    3 +++
 2 files changed, 19 insertions(+), 5 deletions(-)

--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -5392,7 +5392,7 @@ static netdev_tx_t tg3_start_xmit_dma_bu
 	mss = 0;
 	if ((mss = skb_shinfo(skb)->gso_size) != 0) {
 		struct iphdr *iph;
-		int tcp_opt_len, ip_tcp_len, hdr_len;
+		u32 tcp_opt_len, ip_tcp_len, hdr_len;
 
 		if (skb_header_cloned(skb) &&
 		    pskb_expand_head(skb, 0, 0, GFP_ATOMIC)) {
@@ -5423,8 +5423,10 @@ static netdev_tx_t tg3_start_xmit_dma_bu
 								 IPPROTO_TCP,
 								 0);
 
-		if ((tp->tg3_flags2 & TG3_FLG2_HW_TSO) ||
-		    (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5705)) {
+		if (tp->tg3_flags2 & TG3_FLG2_HW_TSO_2)
+			mss |= hdr_len << 9;
+		else if ((tp->tg3_flags2 & TG3_FLG2_HW_TSO_1) ||
+			GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5705) {
 			if (tcp_opt_len || iph->ihl > 5) {
 				int tsflags;
 
@@ -5459,6 +5461,9 @@ static netdev_tx_t tg3_start_xmit_dma_bu
 
 	would_hit_hwbug = 0;
 
+	if ((tp->tg3_flags3 & TG3_FLG3_SHORT_DMA_BUG) && len <= 8)
+		would_hit_hwbug = 1;
+
 	if (tp->tg3_flags3 & TG3_FLG3_5701_DMA_BUG)
 		would_hit_hwbug = 1;
 	else if (tg3_4g_overflow_test(mapping, len))
@@ -5482,6 +5487,10 @@ static netdev_tx_t tg3_start_xmit_dma_bu
 
 			tnapi->tx_buffers[entry].skb = NULL;
 
+			if ((tp->tg3_flags3 & TG3_FLG3_SHORT_DMA_BUG) &&
+				len <= 8)
+					would_hit_hwbug = 1;
+
 			if (tg3_4g_overflow_test(mapping, len))
 				would_hit_hwbug = 1;
 
@@ -12608,6 +12617,9 @@ static int __devinit tg3_get_invariants(
 		}
 	}
 
+	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5906)
+		tp->tg3_flags3 |= TG3_FLG3_SHORT_DMA_BUG;
+
 	tp->irq_max = 1;
 
 #ifdef TG3_NAPI
@@ -13975,8 +13987,7 @@ static int __devinit tg3_init_one(struct
 		goto err_out_iounmap;
 	}
 
-	if ((tp->tg3_flags3 & TG3_FLG3_5755_PLUS) ||
-	    GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5906)
+	if (tp->tg3_flags3 & TG3_FLG3_5755_PLUS)
 		dev->netdev_ops = &tg3_netdev_ops;
 	else
 		dev->netdev_ops = &tg3_netdev_ops_dma_bug;
--- a/drivers/net/tg3.h
+++ b/drivers/net/tg3.h
@@ -2759,6 +2759,9 @@ struct tg3 {
 #define TG3_FLG3_TOGGLE_10_100_L1PLLPD	0x00008000
 #define TG3_FLG3_PHY_IS_FET		0x00010000
 #define TG3_FLG3_ENABLE_RSS		0x00020000
+#define TG3_FLG3_4G_DMA_BNDRY_BUG      0x00080000
+#define TG3_FLG3_40BIT_DMA_LIMIT_BUG   0x00100000
+#define TG3_FLG3_SHORT_DMA_BUG  0x00200000
 
 	struct timer_list		timer;
 	u16				timer_counter;


