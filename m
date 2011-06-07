Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab1FGP7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:59:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab1FGP7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:59:40 -0400
Date: Tue, 7 Jun 2011 18:59:15 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: Re: [PATCHv2 RFC 3/4] virtio_net: limit xmit polling
Message-ID: <20110607155915.GA17581@redhat.com>
References: <cover.1307029008.git.mst@redhat.com>
 <a80199422de16ae355e56ee1b2abc9b2bf91a7f6.1307029009.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a80199422de16ae355e56ee1b2abc9b2bf91a7f6.1307029009.git.mst@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 06:43:17PM +0300, Michael S. Tsirkin wrote:
> Current code might introduce a lot of latency variation
> if there are many pending bufs at the time we
> attempt to transmit a new one. This is bad for
> real-time applications and can't be good for TCP either.
> 
> Free up just enough to both clean up all buffers
> eventually and to be able to xmit the next packet.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>


I've been testing this patch and it seems to work fine
so far. The following fixups are needed to make it
build though:


diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b25db1c..77cdf34 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -529,11 +529,8 @@ static bool free_old_xmit_skb(struct virtnet_info *vi)
  * virtqueue_add_buf will succeed. */
 static bool free_xmit_capacity(struct virtnet_info *vi)
 {
-	struct sk_buff *skb;
-	unsigned int len;
-
 	while (virtqueue_min_capacity(vi->svq) < MAX_SKB_FRAGS + 2)
-		if (unlikely(!free_old_xmit_skb))
+		if (unlikely(!free_old_xmit_skb(vi)))
 			return false;
 	return true;
 }
@@ -628,7 +625,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * Doing this after kick means there's a chance we'll free
 	 * the skb we have just sent, which is hot in cache. */
 	for (i = 0; i < 2; i++)
-		free_old_xmit_skb(v);
+		free_old_xmit_skb(vi);
 
 	if (likely(free_xmit_capacity(vi)))
 		return NETDEV_TX_OK;
