Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab2DJNwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:52:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35880 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab2DJNwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:52:17 -0400
Subject: Re: [PATCH] net: orphan queued skbs if device tx can stall
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <hadi@cyberus.ca>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jason Wang <jasowang@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        Jiri Pirko <jpirko@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
In-Reply-To: <20120410124151.GA29808@redhat.com>
References: <20120408171323.GA16012@redhat.com>
	 <1334044558.3126.5.camel@edumazet-glaptop>
	 <20120410084151.GA27193@redhat.com>
	 <1334048100.3126.21.camel@edumazet-glaptop>
	 <20120410093140.GA27651@redhat.com>
	 <1334052259.3126.68.camel@edumazet-glaptop>
	 <20120410112459.GA28825@redhat.com>
	 <1334058300.3126.99.camel@edumazet-glaptop>
	 <20120410124151.GA29808@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Apr 2012 15:52:09 +0200
Message-ID: <1334065929.5300.40.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-10 at 15:41 +0300, Michael S. Tsirkin wrote:

> I think it's a bad interface too but it's in a userspace ABI
> now so I suspect we are stuck with it for now. We can try deprecating
> but we can't just drop it.
> 

By the way, skb orphaning should already be done in skb_orphan_try(),
not sure why its done again in tun_net_xmit(). Note we perform orphaning
right before giving skb to device on premise it'll be sent (and freed)
in a reasonable amount of time.


With following patch, no more qdisc on top of tun device, yet user can
change the limit (I would be curious to know if anybody changes tun
txqueuelen and why)




diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index bb8c72c..c4a00cf 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -379,6 +379,7 @@ static int tun_net_close(struct net_device *dev)
 static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct tun_struct *tun = netdev_priv(dev);
+	int limit;
 
 	tun_debug(KERN_INFO, tun, "tun_net_xmit %d\n", skb->len);
 
@@ -396,7 +397,8 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	    sk_filter(tun->socket.sk, skb))
 		goto drop;
 
-	if (skb_queue_len(&tun->socket.sk->sk_receive_queue) >= dev->tx_queue_len) {
+	limit = dev->tx_queue_len ? : TUN_READQ_SIZE;
+	if (skb_queue_len(&tun->socket.sk->sk_receive_queue) >= limit) {
 		if (!(tun->flags & TUN_ONE_QUEUE)) {
 			/* Normal queueing mode. */
 			/* Packet scheduler handles dropping of further packets. */
@@ -521,7 +523,7 @@ static void tun_net_init(struct net_device *dev)
 		/* Zero header length */
 		dev->type = ARPHRD_NONE;
 		dev->flags = IFF_POINTOPOINT | IFF_NOARP | IFF_MULTICAST;
-		dev->tx_queue_len = TUN_READQ_SIZE;  /* We prefer our own queue length */
+		dev->tx_queue_len = 0;
 		break;
 
 	case TUN_TAP_DEV:
@@ -532,7 +534,7 @@ static void tun_net_init(struct net_device *dev)
 
 		eth_hw_addr_random(dev);
 
-		dev->tx_queue_len = TUN_READQ_SIZE;  /* We prefer our own queue length */
+		dev->tx_queue_len = 0;
 		break;
 	}
 }


