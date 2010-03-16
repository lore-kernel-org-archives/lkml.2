Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965911Ab0CPAd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 20:33:29 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46253 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932779Ab0CPAd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 20:33:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UkOk3p/VYplIk5n+Osjy+s/OAtvcMh/zMV/3ZgTUuh1JNJw4FGOu8KN/m6N/2nPy+h
         kU8q0CaStje5wxCdYUpVfUVWmtv4duFRe48iCUGJTOwmbNHPrdrcx2IsV9AtuUYIg2v3
         33+vUuOofE247OdSk5RJvFFb/Br6SLQI/z2KU=
Subject: [PATCH] r8169: Fix rtl8169_rx_interrupt()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>,
       Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, netdev@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1268686865.2824.4.camel@edumazet-laptop>
References: <20100307192305.GA598@elte.hu>
	 <20100308125122.GA11242@redhat.com>
	 <1268686865.2824.4.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 01:33:22 +0100
Message-ID: <1268699602.2824.14.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 15 mars 2010 à 22:01 +0100, Eric Dumazet a écrit :

> Yes, this is wrong. In this context (process context, not softirq), we
> should use netif_rx() or just drop frames if we are in reset phase.
> 

Sergey,

Here is a compiled but untested patch (I dont have the hardware), could
you please test it ?

Thanks

[PATCH] r8169: Fix rtl8169_rx_interrupt()

In case a reset is performed, rtl8169_rx_interrupt() is called from
process context instead of softirq context. Special care must be taken
to call appropriate network core services (netif_rx() instead of
netif_receive_skb()). VLAN handling also corrected.

Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Diagnosed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 9d3ebf3..d873639 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1038,14 +1038,14 @@ static void rtl8169_vlan_rx_register(struct net_device *dev,
 }
 
 static int rtl8169_rx_vlan_skb(struct rtl8169_private *tp, struct RxDesc *desc,
-			       struct sk_buff *skb)
+			       struct sk_buff *skb, int polling)
 {
 	u32 opts2 = le32_to_cpu(desc->opts2);
 	struct vlan_group *vlgrp = tp->vlgrp;
 	int ret;
 
 	if (vlgrp && (opts2 & RxVlanTag)) {
-		vlan_hwaccel_receive_skb(skb, vlgrp, swab16(opts2 & 0xffff));
+		__vlan_hwaccel_rx(skb, vlgrp, swab16(opts2 & 0xffff), polling);
 		ret = 0;
 	} else
 		ret = -1;
@@ -1062,7 +1062,7 @@ static inline u32 rtl8169_tx_vlan_tag(struct rtl8169_private *tp,
 }
 
 static int rtl8169_rx_vlan_skb(struct rtl8169_private *tp, struct RxDesc *desc,
-			       struct sk_buff *skb)
+			       struct sk_buff *skb, int polling)
 {
 	return -1;
 }
@@ -4429,12 +4429,20 @@ out:
 	return done;
 }
 
+/*
+ * Warning : rtl8169_rx_interrupt() might be called :
+ * 1) from NAPI (softirq) context
+ *	(polling = 1 : we should call netif_receive_skb())
+ * 2) from process context (rtl8169_reset_task())
+ *	(polling = 0 : we must call netif_rx() instead)
+ */		
 static int rtl8169_rx_interrupt(struct net_device *dev,
 				struct rtl8169_private *tp,
 				void __iomem *ioaddr, u32 budget)
 {
 	unsigned int cur_rx, rx_left;
 	unsigned int delta, count;
+	int polling = (budget != ~(u32)0) ? 1 : 0;
 
 	cur_rx = tp->cur_rx;
 	rx_left = NUM_RX_DESC + tp->dirty_rx - cur_rx;
@@ -4496,8 +4504,12 @@ static int rtl8169_rx_interrupt(struct net_device *dev,
 			skb_put(skb, pkt_size);
 			skb->protocol = eth_type_trans(skb, dev);
 
-			if (rtl8169_rx_vlan_skb(tp, desc, skb) < 0)
-				netif_receive_skb(skb);
+			if (rtl8169_rx_vlan_skb(tp, desc, skb, polling) < 0) {
+				if (likely(polling))
+					netif_receive_skb(skb);
+				else
+					netif_rx(skb);
+			}
 
 			dev->stats.rx_bytes += pkt_size;
 			dev->stats.rx_packets++;


