Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817Ab0EXXJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:09:17 -0400
Received: from kroah.org ([198.145.64.141]:36356 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758798Ab0EXXJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:09:14 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:03:49 2010
Message-Id: <20100524230349.439835687@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 15:59:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [01/34] ipv4: udp: fix short packet and bad checksum logging
In-Reply-To: <20100524230418.GA12770@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit ccc2d97cb7c798e785c9f198de243e2b59f7073b upstream.

commit 2783ef23 moved the initialisation of saddr and daddr after
pskb_may_pull() to avoid a potential data corruption.  Unfortunately
also placing it after the short packet and bad checksum error paths,
where these variables are used for logging.  The result is bogus
output like

[92238.389505] UDP: short packet: From 2.0.0.0:65535 23715/178 to 0.0.0.0:65535

Moving the saddr and daddr initialisation above the error paths, while still
keeping it after the pskb_may_pull() to keep the fix from commit 2783ef23.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/udp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1292,6 +1292,9 @@ int __udp4_lib_rcv(struct sk_buff *skb,
 
 	uh   = udp_hdr(skb);
 	ulen = ntohs(uh->len);
+	saddr = ip_hdr(skb)->saddr;
+	daddr = ip_hdr(skb)->daddr;
+
 	if (ulen > skb->len)
 		goto short_packet;
 
@@ -1305,9 +1308,6 @@ int __udp4_lib_rcv(struct sk_buff *skb,
 	if (udp4_csum_init(skb, uh, proto))
 		goto csum_error;
 
-	saddr = ip_hdr(skb)->saddr;
-	daddr = ip_hdr(skb)->daddr;
-
 	if (rt->rt_flags & (RTCF_BROADCAST|RTCF_MULTICAST))
 		return __udp4_lib_mcast_deliver(net, skb, uh,
 				saddr, daddr, udptable);


