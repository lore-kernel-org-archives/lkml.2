Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab2J2Pwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:52:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760027Ab2J2Pwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:52:33 -0400
Date: Mon, 29 Oct 2012 17:49:46 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/8] tun: report orphan frags errors to zero copy
 callback
Message-ID: <8802a5f3d1556574df1e62279d2788462d23430d.1351524501.git.mst@redhat.com>
References: <cover.1351524501.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1351524501.git.mst@redhat.com>
X-Mutt-Fcc: =sent
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When tun transmits a zero copy skb, it orphans the frags
which might need to allocate extra memory, in atomic context.
If that fails, notify ubufs callback before freeing the skb
as a hint that device should disable zerocopy mode.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/tun.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3157519..613f826 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -433,6 +433,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 
 drop:
 	dev->stats.tx_dropped++;
+	skb_tx_error(skb, -ENOMEM);
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
-- 
MST

