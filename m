Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab0FUKX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 06:23:56 -0400
Received: from ozlabs.org ([203.10.76.45]:34712 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232Ab0FUKXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 06:23:52 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH for-2.6.35] virtio_net: fix oom handling on tx
Date: Mon, 21 Jun 2010 19:53:43 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       Sridhar Samudrala <sri@us.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Jiri Pirko <jpirko@redhat.com>, Shirley Ma <xma@us.ibm.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100610152041.GA3480@redhat.com> <201006211213.49600.rusty@rustcorp.com.au> <20100621083315.GA8665@redhat.com>
In-Reply-To: <20100621083315.GA8665@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006211953.44724.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010 06:03:16 pm Michael S. Tsirkin wrote:
> On Mon, Jun 21, 2010 at 12:13:49PM +0930, Rusty Russell wrote:
> > -		return NETDEV_TX_BUSY;
> > +		kfree_skb(skb);
> > +		return NETDEV_TX_OK;
> 
> If we do so, let's increment the dropped counter and/or error counter?

Yep, here's the extra change:

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -571,14 +571,16 @@ static netdev_tx_t start_xmit(struct sk_
 	/* This can happen with OOM and indirect buffers. */
 	if (unlikely(capacity < 0)) {
 		if (net_ratelimit()) {
-			if (likely(capacity == -ENOMEM))
+			if (likely(capacity == -ENOMEM)) {
 				dev_warn(&dev->dev,
 					 "TX queue failure: out of memory\n");
-			else
+			} else {
+				dev->stats.tx_fifo_errors++;
 				dev_warn(&dev->dev,
 					 "Unexpected TX queue failure: %d\n",
 					 capacity);
 		}
+		dev->stats.tx_dropped++;
 		kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
