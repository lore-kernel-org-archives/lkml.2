Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab1GHFUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:20:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063Ab1GHFAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:00:45 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:54 2011
Message-Id: <20110708001653.932502215@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [012/107] af_packet: prevent information leak
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 13fcb7bd322164c67926ffe272846d4860196dc6 ]

In 2.6.27, commit 393e52e33c6c2 (packet: deliver VLAN TCI to userspace)
added a small information leak.

Add padding field and make sure its zeroed before copy to user.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/if_packet.h |    2 ++
 net/packet/af_packet.c    |    2 ++
 2 files changed, 4 insertions(+)

--- a/include/linux/if_packet.h
+++ b/include/linux/if_packet.h
@@ -62,6 +62,7 @@ struct tpacket_auxdata {
 	__u16		tp_mac;
 	__u16		tp_net;
 	__u16		tp_vlan_tci;
+	__u16		tp_padding;
 };
 
 /* Rx ring - header status */
@@ -100,6 +101,7 @@ struct tpacket2_hdr {
 	__u32		tp_sec;
 	__u32		tp_nsec;
 	__u16		tp_vlan_tci;
+	__u16		tp_padding;
 };
 
 #define TPACKET2_HDRLEN		(TPACKET_ALIGN(sizeof(struct tpacket2_hdr)) + sizeof(struct sockaddr_ll))
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -799,6 +799,7 @@ static int tpacket_rcv(struct sk_buff *s
 		h.h2->tp_sec = ts.tv_sec;
 		h.h2->tp_nsec = ts.tv_nsec;
 		h.h2->tp_vlan_tci = vlan_tx_tag_get(skb);
+		h.h2->tp_padding = 0;
 		hdrlen = sizeof(*h.h2);
 		break;
 	default:
@@ -1727,6 +1728,7 @@ static int packet_recvmsg(struct kiocb *
 		aux.tp_net = skb_network_offset(skb);
 		aux.tp_vlan_tci = vlan_tx_tag_get(skb);
 
+		aux.tp_padding = 0;
 		put_cmsg(msg, SOL_PACKET, PACKET_AUXDATA, sizeof(aux), &aux);
 	}
 


