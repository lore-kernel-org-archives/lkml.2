Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933850Ab1FWRin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:38:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:35615 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933832Ab1FWRik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 227/247] udp: Fix bogus UFO packet generation
Date: Thu, 23 Jun 2011 13:34:55 -0400
Message-Id: <1308850515-15242-168-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv4/ip_output.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index e8a6860..d52fe4b 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -871,8 +871,10 @@ int ip_append_data(struct sock *sk,
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
@@ -890,7 +892,7 @@ int ip_append_data(struct sock *sk,
 	 * adding appropriate IP header.
 	 */
 
-	if ((skb = skb_peek_tail(&sk->sk_write_queue)) == NULL)
+	if (!skb)
 		goto alloc_new_skb;
 
 	while (length > 0) {
@@ -1119,7 +1121,8 @@ ssize_t	ip_append_page(struct sock *sk, struct page *page,
 		return -EINVAL;
 
 	inet->cork.length += size;
-	if ((sk->sk_protocol == IPPROTO_UDP) &&
+	if ((size + skb->len > mtu) &&
+	    (sk->sk_protocol == IPPROTO_UDP) &&
 	    (rt->u.dst.dev->features & NETIF_F_UFO)) {
 		skb_shinfo(skb)->gso_size = mtu - fragheaderlen;
 		skb_shinfo(skb)->gso_type = SKB_GSO_UDP;
-- 
1.7.4.4

