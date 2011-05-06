Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab1EFBDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 21:03:17 -0400
Received: from kroah.org ([198.145.64.141]:36575 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312Ab1EFAYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:18 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:06 2011
Message-Id: <20110506002206.651062766@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: [016/143] udp: Fix bogus UFO packet generation
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 26cde9f7e2747b6d254b704594eed87ab959afa5 upstream.

It has been reported that the new UFO software fallback path
fails under certain conditions with NFS.  I tracked the problem
down to the generation of UFO packets that are smaller than the
MTU.  The software fallback path simply discards these packets.

This patch fixes the problem by not generating such packets on
the UFO path.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/ip_output.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -867,8 +867,10 @@ int ip_append_data(struct sock *sk,
 	    !exthdrlen)
 		csummode = CHECKSUM_PARTIAL;
 
+	skb = skb_peek_tail(&sk->sk_write_queue);
+
 	inet->cork.length += length;
-	if (((length> mtu) || !skb_queue_empty(&sk->sk_write_queue)) &&
+	if (((length > mtu) || (skb && skb_is_gso(skb))) &&
 	    (sk->sk_protocol == IPPROTO_UDP) &&
 	    (rt->u.dst.dev->features & NETIF_F_UFO)) {
 		err = ip_ufo_append_data(sk, getfrag, from, length, hh_len,
@@ -886,7 +888,7 @@ int ip_append_data(struct sock *sk,
 	 * adding appropriate IP header.
 	 */
 
-	if ((skb = skb_peek_tail(&sk->sk_write_queue)) == NULL)
+	if (!skb)
 		goto alloc_new_skb;
 
 	while (length > 0) {
@@ -1115,7 +1117,8 @@ ssize_t	ip_append_page(struct sock *sk,
 		return -EINVAL;
 
 	inet->cork.length += size;
-	if ((sk->sk_protocol == IPPROTO_UDP) &&
+	if ((size + skb->len > mtu) &&
+	    (sk->sk_protocol == IPPROTO_UDP) &&
 	    (rt->u.dst.dev->features & NETIF_F_UFO)) {
 		skb_shinfo(skb)->gso_size = mtu - fragheaderlen;
 		skb_shinfo(skb)->gso_type = SKB_GSO_UDP;


