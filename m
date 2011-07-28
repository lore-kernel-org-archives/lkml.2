Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab1G1BzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 21:55:15 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:51667 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab1G1By7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 21:54:59 -0400
Subject: [STABLE][PATCH] IGMP snooping: set mrouters_only flag for IPv6
 traffic properly
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
To: Andi Kleen <andi@firstfloor.org>
Cc: pablo@netfilter.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
In-Reply-To: <1311818010.2707.7.camel@nausicaa>
References: <20110727247.325703029@firstfloor.org>
	 <20110727214858.5FECE2403FF@tassilo.jf.intel.com>
	 <1311817873.2707.5.camel@nausicaa>  <1311818010.2707.7.camel@nausicaa>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 10:54:56 +0900
Message-ID: <1311818096.2707.9.camel@nausicaa>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>

commit fc2af6c73fc9449cd5894a36bb76b8f8c0e49fd8 upstream.

Upon reception of a MGM report packet the kernel sets the mrouters_only flag
in a skb that is a clone of the original skb, which means that the bridge
loses track of MGM packets (cb buffers are tied to a specific skb and not
shared) and it ends up forwading join requests to the bridge interface.

This can cause unexpected membership timeouts and intermitent/permanent loss
of connectivity as described in RFC 4541 [2.1.1. IGMP Forwarding Rules]:

    A snooping switch should forward IGMP Membership Reports only to
    those ports where multicast routers are attached.
    [...]
    Sending membership reports to other hosts can result, for IGMPv1
    and IGMPv2, in unintentionally preventing a host from joining a
    specific multicast group.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: David S. Miller <davem@conan.davemloft.net>
---

diff -urNp linux-2.6.35.13-orig/net/bridge/br_multicast.c linux-2.6.35.13/net/bridge/br_multicast.c
--- linux-2.6.35.13-orig/net/bridge/br_multicast.c	2011-07-28 10:29:17.818721561 +0900
+++ linux-2.6.35.13/net/bridge/br_multicast.c	2011-07-28 10:35:14.959083129 +0900
@@ -1517,7 +1517,7 @@ static int br_multicast_ipv6_rcv(struct
 	case ICMPV6_MGM_REPORT:
 	    {
 		struct mld_msg *mld = (struct mld_msg *)icmp6h;
-		BR_INPUT_SKB_CB(skb2)->mrouters_only = 1;
+		BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
 		err = br_ip6_multicast_add_group(br, port, &mld->mld_mca);
 		break;
 	    }


