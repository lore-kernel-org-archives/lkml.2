Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab0EJX31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:29:27 -0400
Received: from kroah.org ([198.145.64.141]:33362 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522Ab0EJWwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:50 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:25 2010
Message-Id: <20100510223325.783438681@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:33:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Herbert Xu <herbert@gondor.hengli.com.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [093/117] tun: orphan an skb on tx
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 0110d6f22f392f976e84ab49da1b42f85b64a3c5 ]

The following situation was observed in the field:
tap1 sends packets, tap2 does not consume them, as a result
tap1 can not be closed. This happens because
tun/tap devices can hang on to skbs undefinitely.

As noted by Herbert, possible solutions include a timeout followed by a
copy/change of ownership of the skb, or always copying/changing
ownership if we're going into a hostile device.

This patch implements the second approach.

Note: one issue still remaining is that since skbs
keep reference to tun socket and tun socket has a
reference to tun device, we won't flush backlog,
instead simply waiting for all skbs to get transmitted.
At least this is not user-triggerable, and
this was not reported in practice, my assumption is
other devices besides tap complete an skb
within finite time after it has been queued.

A possible solution for the second issue
would not to have socket reference the device,
instead, implement dev->destructor for tun, and
wait for all skbs to complete there, but this
needs some thought, probably too risky for 2.6.34.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Yan Vugenfirer <yvugenfi@redhat.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/tun.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -380,6 +380,10 @@ static netdev_tx_t tun_net_xmit(struct s
 		}
 	}
 
+	/* Orphan the skb - required as we might hang on to it
+	 * for indefinite time. */
+	skb_orphan(skb);
+
 	/* Enqueue packet */
 	skb_queue_tail(&tun->socket.sk->sk_receive_queue, skb);
 	dev->trans_start = jiffies;


