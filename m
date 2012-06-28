Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab2F1XnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 19:43:17 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:54008 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab2F1XnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 19:43:15 -0400
X-Greylist: delayed 660 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jun 2012 19:43:15 EDT
X-RZG-AUTH: :OmsBZ2C7d7IBoB6EHwegNiRqgfQXlaD5PlBebH2tU4xZA+McnU+S
X-RZG-CLASS-ID: mo05
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: 3.4.x regression: rtl8169: frequent resets
Date: Fri, 29 Jun 2012 01:31:42 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-4.slh.2-aptosid-686; KDE/4.8.4; i686; ; )
Cc: Nix <nix@esperi.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <87y5n7qup0.fsf@spindle.srvr.nix> <20120628193026.GA31627@electric-eye.fr.zoreil.com>
In-Reply-To: <20120628193026.GA31627@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_klO7P/Yfmu6z9Ay"
Message-Id: <201206290131.49150.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_klO7P/Yfmu6z9Ay
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi

On Thursday 28 June 2012, Francois Romieu wrote:
> Nix <nix@esperi.org.uk> :
> > I recently upgraded from 3.3.x to 3.4.4, and am now experiencing
> > networking problems with my desktop box's r8169 card. The symptoms are
> > that all traffic ceases for five to ten seconds, then the card appears
> > to reset and everything is back to normal -- until it happens again. It
> > can happen quite a lot:
> 
> Can you try and revert 036dafa28da1e2565a8529de2ae663c37b7a0060 ?
> 
> I would welcome a complete dmesg including the XID line from the
> r8169 driver.

I received the same oops from a 3.4.4 user with these onboard network 
cards:

r8169 0000:04:00.0: eth0: RTL8168d/8111d at 0xffffc90000c72000, 00:24:1d:72:7c:75, XID 081000c0 IRQ 44
r8169 0000:05:00.0: eth1: RTL8168d/8111d at 0xffffc90000c70000, 00:24:1d:72:7c:77, XID 081000c0 IRQ 45

Reverting 036dafa28da1e2565a8529de2ae663c37b7a0060 (Nix, trivial 
backport to 3.4.4 attached) did improve the situation, no oops in 21
hours uptime so far (while it usually shows up within about an hour).
Unfortunately his oops report was cut brief, so I've asked him to try 
reproducing it with an unpatched kernel again, to collect a full dmesg
(the test is still going on, past the one hour mark, but the oops 
hasn't triggered yet). I'll report back, as soon as I get confirmation 
and a full dmesg.

Regards
	Stefan Lippers-Hollmann

--Boundary-00=_klO7P/Yfmu6z9Ay
Content-Type: text/x-patch;
  charset="UTF-8";
  name="revert-r8169-add-byte-queue-limit-support.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="revert-r8169-add-byte-queue-limit-support.patch"

revert r8169: add byte queue limit support.

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5000,7 +5000,6 @@ static void rtl8169_tx_clear(struct rtl8
 {
 	rtl8169_tx_clear_range(tp, tp->dirty_tx, NUM_TX_DESC);
 	tp->cur_tx = tp->dirty_tx = 0;
-	netdev_reset_queue(tp->dev);
 }
 
 static void rtl_reset_work(struct rtl8169_private *tp)
@@ -5155,8 +5154,6 @@ static netdev_tx_t rtl8169_start_xmit(st
 
 	txd->opts2 = cpu_to_le32(opts[1]);
 
-	netdev_sent_queue(dev, skb->len);
-
 	skb_tx_timestamp(skb);
 
 	wmb();
@@ -5253,16 +5250,9 @@ static void rtl8169_pcierr_interrupt(str
 	rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_PENDING);
 }
 
-struct rtl_txc {
-	int packets;
-	int bytes;
-};
-
 static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp)
 {
-	struct rtl8169_stats *tx_stats = &tp->tx_stats;
 	unsigned int dirty_tx, tx_left;
-	struct rtl_txc txc = { 0, 0 };
 
 	dirty_tx = tp->dirty_tx;
 	smp_rmb();
@@ -5281,24 +5271,17 @@ static void rtl_tx(struct net_device *de
 		rtl8169_unmap_tx_skb(&tp->pci_dev->dev, tx_skb,
 				     tp->TxDescArray + entry);
 		if (status & LastFrag) {
-			struct sk_buff *skb = tx_skb->skb;
-
-			txc.packets++;
-			txc.bytes += skb->len;
-			dev_kfree_skb(skb);
+			u64_stats_update_begin(&tp->tx_stats.syncp);
+			tp->tx_stats.packets++;
+			tp->tx_stats.bytes += tx_skb->skb->len;
+			u64_stats_update_end(&tp->tx_stats.syncp);
+			dev_kfree_skb(tx_skb->skb);
 			tx_skb->skb = NULL;
 		}
 		dirty_tx++;
 		tx_left--;
 	}
 
-	u64_stats_update_begin(&tx_stats->syncp);
-	tx_stats->packets += txc.packets;
-	tx_stats->bytes += txc.bytes;
-	u64_stats_update_end(&tx_stats->syncp);
-
-	netdev_completed_queue(dev, txc.packets, txc.bytes);
-
 	if (tp->dirty_tx != dirty_tx) {
 		tp->dirty_tx = dirty_tx;
 		/* Sync with rtl8169_start_xmit:

--Boundary-00=_klO7P/Yfmu6z9Ay--
