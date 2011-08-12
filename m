Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab1HNQIJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:08:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab1HNQIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:08:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:56 2011
Message-Id: <20110812210555.975621043@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bill Sommerfeld <wsommerfeld@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [44/90] ipv4: Constrain UFO fragment sizes to multiples of 8 bytes
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Bill Sommerfeld <wsommerfeld@google.com>

[ Upstream commit d9be4f7a6f5a8da3133b832eca41c3591420b1ca ]

Because the ip fragment offset field counts 8-byte chunks, ip
fragments other than the last must contain a multiple of 8 bytes of
payload.  ip_ufo_append_data wasn't respecting this constraint and,
depending on the MTU and ip option sizes, could create malformed
non-final fragments.

Google-Bug-Id: 5009328
Signed-off-by: Bill Sommerfeld <wsommerfeld@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/ip_output.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -734,7 +734,7 @@ static inline int ip_ufo_append_data(str
 			int getfrag(void *from, char *to, int offset, int len,
 			       int odd, struct sk_buff *skb),
 			void *from, int length, int hh_len, int fragheaderlen,
-			int transhdrlen, int mtu, unsigned int flags)
+			int transhdrlen, int maxfraglen, unsigned int flags)
 {
 	struct sk_buff *skb;
 	int err;
@@ -767,7 +767,7 @@ static inline int ip_ufo_append_data(str
 		skb->csum = 0;
 
 		/* specify the length of each IP datagram fragment */
-		skb_shinfo(skb)->gso_size = mtu - fragheaderlen;
+		skb_shinfo(skb)->gso_size = maxfraglen - fragheaderlen;
 		skb_shinfo(skb)->gso_type = SKB_GSO_UDP;
 		__skb_queue_tail(queue, skb);
 	}
@@ -831,7 +831,7 @@ static int __ip_append_data(struct sock
 	    (rt->dst.dev->features & NETIF_F_UFO) && !rt->dst.header_len) {
 		err = ip_ufo_append_data(sk, queue, getfrag, from, length,
 					 hh_len, fragheaderlen, transhdrlen,
-					 mtu, flags);
+					 maxfraglen, flags);
 		if (err)
 			goto error;
 		return 0;


