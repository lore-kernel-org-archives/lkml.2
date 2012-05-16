Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642Ab2EPWIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 18:08:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406Ab2EPWIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 18:08:44 -0400
Date: Thu, 17 May 2012 00:16:16 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, davem@davemloft.net
Subject: [PATCHv2-RFC 5/6] net: orphan frags on receive
Message-ID: <d0ef01eeb9030a329da44df2cf642898f2f6a3ac.1337202879.git.mst@redhat.com>
References: <cover.1337202879.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1337202879.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zero copy packets are normally sent to the outside
network, but bridging, tun etc might loop them
back to host networking stack. If this happens
destructors will never be called, so orphan
the frags immediately on receive.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/core/dev.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 66cae6e..cd7d421 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1628,6 +1628,8 @@ static inline int deliver_skb(struct sk_buff *skb,
 			      struct packet_type *pt_prev,
 			      struct net_device *orig_dev)
 {
+	if (unlikely(skb_orphan_frags(skb, GFP_ATOMIC)))
+		return -ENOMEM;
 	atomic_inc(&skb->users);
 	return pt_prev->func(skb, skb->dev, pt_prev, orig_dev);
 }
-- 
MST

