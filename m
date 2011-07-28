Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1G1Bxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 21:53:39 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:51608 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1G1Bxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 21:53:33 -0400
Subject: [STABLE] [PATCH] IGMP snooping: set mrouters_only flag for IPv4
 traffic properly
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
To: Andi Kleen <andi@firstfloor.org>
Cc: pablo@netfilter.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
In-Reply-To: <1311817873.2707.5.camel@nausicaa>
References: <20110727247.325703029@firstfloor.org>
	 <20110727214858.5FECE2403FF@tassilo.jf.intel.com>
	 <1311817873.2707.5.camel@nausicaa>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 10:53:30 +0900
Message-ID: <1311818010.2707.7.camel@nausicaa>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>

commit 62b2bcb49cca72f6d3f39f831127a6ab315a475d upstream.

Upon reception of a IGMP/IGMPv2 membership report the kernel sets the
mrouters_only flag in a skb that may be a clone of the original skb, which
means that sometimes the bridge loses track of membership report packets (cb
buffers are tied to a specific skb and not shared) and it ends up forwading
join requests to the bridge interface.
    
This can cause unexpected membership timeouts and intermitent/permanent loss
of connectivity as described in RFC 4541 [2.1.1. IGMP Forwarding Rules]:
    
    A snooping switch should forward IGMP Membership Reports only to
    those ports where multicast routers are attached.
    [...]
    Sending membership reports to other hosts can result, for IGMPv1
    and IGMPv2, in unintentionally preventing a host from joining a
    specific multicast group.
    
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Tested-by: Hayato Kakuta <kakuta.hayato@oss.ntt.co.jp>
Signed-off-by: David S. Miller <davem@conan.davemloft.net>
---

diff -urNp linux-2.6.35.13-orig/net/bridge/br_multicast.c linux-2.6.35.13/net/bridge/br_multicast.c
--- linux-2.6.35.13-orig/net/bridge/br_multicast.c	2011-04-29 00:21:24.000000000 +0900
+++ linux-2.6.35.13/net/bridge/br_multicast.c	2011-07-28 10:28:08.505872639 +0900
@@ -1403,7 +1403,7 @@ static int br_multicast_ipv4_rcv(struct
 	switch (ih->type) {
 	case IGMP_HOST_MEMBERSHIP_REPORT:
 	case IGMPV2_HOST_MEMBERSHIP_REPORT:
-		BR_INPUT_SKB_CB(skb2)->mrouters_only = 1;
+		BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
 		err = br_ip4_multicast_add_group(br, port, ih->group);
 		break;
 	case IGMPV3_HOST_MEMBERSHIP_REPORT:


