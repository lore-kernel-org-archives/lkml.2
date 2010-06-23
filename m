Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab0FWCvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 22:51:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41103 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab0FWCvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 22:51:20 -0400
Date: Wed, 23 Jun 2010 12:51:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Herbert Xu <herbert@gondor.hengli.com.au>,
       Changli Gao <xiaosuo@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>
Subject: linux-next: manual merge of the net tree with the net-current tree
Message-Id: <20100623125116.1370bdd4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
net/ipv4/ip_output.c between commit
26cde9f7e2747b6d254b704594eed87ab959afa5 ("udp: Fix bogus UFO packet
generation") from the net-current tree and commit
d8d1f30b95a635dbd610dcc5eb641aca8f4768cf ("net-next: remove useless union
keyword") from the net tree.

Just context changes. I fixed it up (see below) and can carry the fix as
necessary.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/ipv4/ip_output.c
index 041d41d,6cbeb2e..0000000
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@@ -873,12 -873,10 +873,12 @@@ int ip_append_data(struct sock *sk
  	    !exthdrlen)
  		csummode = CHECKSUM_PARTIAL;
  
 +	skb = skb_peek_tail(&sk->sk_write_queue);
 +
  	inet->cork.length += length;
 -	if (((length> mtu) || !skb_queue_empty(&sk->sk_write_queue)) &&
 +	if (((length > mtu) || (skb && skb_is_gso(skb))) &&
  	    (sk->sk_protocol == IPPROTO_UDP) &&
- 	    (rt->u.dst.dev->features & NETIF_F_UFO)) {
+ 	    (rt->dst.dev->features & NETIF_F_UFO)) {
  		err = ip_ufo_append_data(sk, getfrag, from, length, hh_len,
  					 fragheaderlen, transhdrlen, mtu,
  					 flags);
@@@ -1123,9 -1121,8 +1123,9 @@@ ssize_t	ip_append_page(struct sock *sk
  		return -EINVAL;
  
  	inet->cork.length += size;
 -	if ((sk->sk_protocol == IPPROTO_UDP) &&
 +	if ((size + skb->len > mtu) &&
 +	    (sk->sk_protocol == IPPROTO_UDP) &&
- 	    (rt->u.dst.dev->features & NETIF_F_UFO)) {
+ 	    (rt->dst.dev->features & NETIF_F_UFO)) {
  		skb_shinfo(skb)->gso_size = mtu - fragheaderlen;
  		skb_shinfo(skb)->gso_type = SKB_GSO_UDP;
  	}
