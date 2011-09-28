Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401Ab1I1WtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:49:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933322Ab1I1WtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:49:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:45 2011
Message-Id: <20110928220145.386358937@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [190/244] bridge: fix a possible use after free
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 22df13319d1fec30b8f9bcaadc295829647109bb ]

br_multicast_ipv6_rcv() can call pskb_trim_rcsum() and therefore skb
head can be reallocated.

Cache icmp6_type field instead of dereferencing twice the struct
icmp6hdr pointer.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bridge/br_multicast.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1456,7 +1456,7 @@ static int br_multicast_ipv6_rcv(struct
 {
 	struct sk_buff *skb2;
 	const struct ipv6hdr *ip6h;
-	struct icmp6hdr *icmp6h;
+	u8 icmp6_type;
 	u8 nexthdr;
 	unsigned len;
 	int offset;
@@ -1502,9 +1502,9 @@ static int br_multicast_ipv6_rcv(struct
 	__skb_pull(skb2, offset);
 	skb_reset_transport_header(skb2);
 
-	icmp6h = icmp6_hdr(skb2);
+	icmp6_type = icmp6_hdr(skb2)->icmp6_type;
 
-	switch (icmp6h->icmp6_type) {
+	switch (icmp6_type) {
 	case ICMPV6_MGM_QUERY:
 	case ICMPV6_MGM_REPORT:
 	case ICMPV6_MGM_REDUCTION:
@@ -1544,7 +1544,7 @@ static int br_multicast_ipv6_rcv(struct
 
 	BR_INPUT_SKB_CB(skb)->igmp = 1;
 
-	switch (icmp6h->icmp6_type) {
+	switch (icmp6_type) {
 	case ICMPV6_MGM_REPORT:
 	    {
 		struct mld_msg *mld;


