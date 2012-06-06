Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2FFNKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:10:20 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49143 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab2FFNKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:10:18 -0400
Subject: Re: [PATCH] virtio-net: fix a race on 32bit arches
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stephen Hemminger <shemminger@vyatta.com>
In-Reply-To: <20120606111357.GA15070@redhat.com>
References: <1338971724.2760.3913.camel@edumazet-glaptop>
	 <1338972341.2760.3944.camel@edumazet-glaptop>
	 <20120606111357.GA15070@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jun 2012 15:10:10 +0200
Message-ID: <1338988210.2760.4485.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 14:13 +0300, Michael S. Tsirkin wrote:

> We currently do all stats either on napi callback or from
> start_xmit callback.
> This makes them safe, yes?

Hmm, then _bh() variant is needed in virtnet_stats(), as explained in
include/linux/u64_stats_sync.h section 6)

 * 6) If counter might be written by an interrupt, readers should block interrupts.
 *    (On UP, there is no seqcount_t protection, a reader allowing interrupts could
 *     read partial values)

Yes, its tricky...

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 5214b1e..705aaa7 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -703,12 +703,12 @@ static struct rtnl_link_stats64 *virtnet_stats(struct net_device *dev,
 		u64 tpackets, tbytes, rpackets, rbytes;
 
 		do {
-			start = u64_stats_fetch_begin(&stats->syncp);
+			start = u64_stats_fetch_begin_bh(&stats->syncp);
 			tpackets = stats->tx_packets;
 			tbytes   = stats->tx_bytes;
 			rpackets = stats->rx_packets;
 			rbytes   = stats->rx_bytes;
-		} while (u64_stats_fetch_retry(&stats->syncp, start));
+		} while (u64_stats_fetch_retry_bh(&stats->syncp, start));
 
 		tot->rx_packets += rpackets;
 		tot->tx_packets += tpackets;


