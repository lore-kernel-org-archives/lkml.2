Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab1G0Vtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:49:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:36412 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab1G0Vtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="35258481"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: eric.dumazet@gmail.com, ak@linux.intel.com, kaber@trash.net,
        davem@davemloft.net, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [91/99] af_packet: prevent information leak
Message-Id: <20110727214930.E83A22403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 13fcb7bd322164c67926ffe272846d4860196dc6 ]

In 2.6.27, commit 393e52e33c6c2 (packet: deliver VLAN TCI to userspace)
added a small information leak.

Add padding field and make sure its zeroed before copy to user.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
CC: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/if_packet.h |    2 ++
 net/packet/af_packet.c    |    2 ++
 2 files changed, 4 insertions(+)

Index: linux-2.6.35.y/include/linux/if_packet.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/if_packet.h
+++ linux-2.6.35.y/include/linux/if_packet.h
@@ -61,6 +61,7 @@ struct tpacket_auxdata {
 	__u16		tp_mac;
 	__u16		tp_net;
 	__u16		tp_vlan_tci;
+	__u16		tp_padding;
 };
 
 /* Rx ring - header status */
@@ -99,6 +100,7 @@ struct tpacket2_hdr {
 	__u32		tp_sec;
 	__u32		tp_nsec;
 	__u16		tp_vlan_tci;
+	__u16		tp_padding;
 };
 
 #define TPACKET2_HDRLEN		(TPACKET_ALIGN(sizeof(struct tpacket2_hdr)) + sizeof(struct sockaddr_ll))
Index: linux-2.6.35.y/net/packet/af_packet.c
===================================================================
--- linux-2.6.35.y.orig/net/packet/af_packet.c
+++ linux-2.6.35.y/net/packet/af_packet.c
@@ -757,6 +757,7 @@ static int tpacket_rcv(struct sk_buff *s
 		h.h2->tp_sec = ts.tv_sec;
 		h.h2->tp_nsec = ts.tv_nsec;
 		h.h2->tp_vlan_tci = vlan_tx_tag_get(skb);
+		h.h2->tp_padding = 0;
 		hdrlen = sizeof(*h.h2);
 		break;
 	default:
@@ -1678,6 +1679,7 @@ static int packet_recvmsg(struct kiocb *
 		aux.tp_net = skb_network_offset(skb);
 		aux.tp_vlan_tci = vlan_tx_tag_get(skb);
 
+		aux.tp_padding = 0;
 		put_cmsg(msg, SOL_PACKET, PACKET_AUXDATA, sizeof(aux), &aux);
 	}
 
