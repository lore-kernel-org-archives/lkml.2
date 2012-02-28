Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab2B1Bjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:39:46 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49705 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab2B1BG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:06:26 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.211.167 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010208.185613450@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:02:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Li Wei <lw@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 25/73] ipv4: Save nexthop address of LSRR/SSRR option to IPCB.
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Li Wei <lw@cn.fujitsu.com>

[ Upstream commit ac8a48106be49c422575ddc7531b776f8eb49610 ]

We can not update iph->daddr in ip_options_rcv_srr(), It is too early.
When some exception ocurred later (eg. in ip_forward() when goto
sr_failed) we need the ip header be identical to the original one as
ICMP need it.

Add a field 'nexthop' in struct ip_options to save nexthop of LSRR
or SSRR option.

Signed-off-by: Li Wei <lw@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/inet_sock.h |    2 ++
 net/ipv4/ip_forward.c   |    2 +-
 net/ipv4/ip_options.c   |    5 +++--
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -31,6 +31,7 @@
 /** struct ip_options - IP Options
  *
  * @faddr - Saved first hop address
+ * @nexthop - Saved nexthop address in LSRR and SSRR
  * @is_data - Options in __data, rather than skb
  * @is_strictroute - Strict source route
  * @srr_is_hit - Packet destination addr was our one
@@ -41,6 +42,7 @@
  */
 struct ip_options {
 	__be32		faddr;
+	__be32		nexthop;
 	unsigned char	optlen;
 	unsigned char	srr;
 	unsigned char	rr;
--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -84,7 +84,7 @@ int ip_forward(struct sk_buff *skb)
 
 	rt = skb_rtable(skb);
 
-	if (opt->is_strictroute && ip_hdr(skb)->daddr != rt->rt_gateway)
+	if (opt->is_strictroute && opt->nexthop != rt->rt_gateway)
 		goto sr_failed;
 
 	if (unlikely(skb->len > dst_mtu(&rt->dst) && !skb_is_gso(skb) &&
--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -568,12 +568,13 @@ void ip_forward_options(struct sk_buff *
 		     ) {
 			if (srrptr + 3 > srrspace)
 				break;
-			if (memcmp(&ip_hdr(skb)->daddr, &optptr[srrptr-1], 4) == 0)
+			if (memcmp(&opt->nexthop, &optptr[srrptr-1], 4) == 0)
 				break;
 		}
 		if (srrptr + 3 <= srrspace) {
 			opt->is_changed = 1;
 			ip_rt_get_source(&optptr[srrptr-1], skb, rt);
+			ip_hdr(skb)->daddr = opt->nexthop;
 			optptr[2] = srrptr+4;
 		} else if (net_ratelimit())
 			printk(KERN_CRIT "ip_forward(): Argh! Destination lost!\n");
@@ -640,7 +641,7 @@ int ip_options_rcv_srr(struct sk_buff *s
 	}
 	if (srrptr <= srrspace) {
 		opt->srr_is_hit = 1;
-		iph->daddr = nexthop;
+		opt->nexthop = nexthop;
 		opt->is_changed = 1;
 	}
 	return 0;


