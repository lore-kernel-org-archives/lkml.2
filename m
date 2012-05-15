Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965797Ab2EOCuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:50:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:49672 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965136Ab2EOCRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 101/179] af_packet: prevent information leak
Date: Mon, 14 May 2012 22:13:17 -0400
Message-ID: <1337048075-6132-102-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 13fcb7bd322164c67926ffe272846d4860196dc6 upstream.

In 2.6.27, commit 393e52e33c6c2 (packet: deliver VLAN TCI to userspace)
added a small information leak.

Add padding field and make sure its zeroed before copy to user.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/if_packet.h |    2 ++
 net/packet/af_packet.c    |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/if_packet.h b/include/linux/if_packet.h
index aa57a5f..9b8dc3a 100644
--- a/include/linux/if_packet.h
+++ b/include/linux/if_packet.h
@@ -60,6 +60,7 @@ struct tpacket_auxdata {
 	__u16		tp_mac;
 	__u16		tp_net;
 	__u16		tp_vlan_tci;
+	__u16		tp_padding;
 };
 
 /* Rx ring - header status */
@@ -98,6 +99,7 @@ struct tpacket2_hdr {
 	__u32		tp_sec;
 	__u32		tp_nsec;
 	__u16		tp_vlan_tci;
+	__u16		tp_padding;
 };
 
 #define TPACKET2_HDRLEN		(TPACKET_ALIGN(sizeof(struct tpacket2_hdr)) + sizeof(struct sockaddr_ll))
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index b1bc2d2..4096a66 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -751,6 +751,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 		h.h2->tp_sec = ts.tv_sec;
 		h.h2->tp_nsec = ts.tv_nsec;
 		h.h2->tp_vlan_tci = vlan_tx_tag_get(skb);
+		h.h2->tp_padding = 0;
 		hdrlen = sizeof(*h.h2);
 		break;
 	default:
@@ -1617,6 +1618,7 @@ static int packet_recvmsg(struct kiocb *iocb, struct socket *sock,
 		aux.tp_net = skb_network_offset(skb);
 		aux.tp_vlan_tci = vlan_tx_tag_get(skb);
 
+		aux.tp_padding = 0;
 		put_cmsg(msg, SOL_PACKET, PACKET_AUXDATA, sizeof(aux), &aux);
 	}
 
-- 
1.7.9.6

