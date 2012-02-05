Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab2BEW3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:29:08 -0500
Received: from 1wt.eu ([62.212.114.60]:62172 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab2BEW3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:29:05 -0500
Message-Id: <20120205220952.918036511@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:11:10 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 81/91] af_packet: prevent information leak
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 2 files changed, 4 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/include/linux/if_packet.h
===================================================================
--- longterm-2.6.27.orig/include/linux/if_packet.h	2012-02-05 22:34:32.515915059 +0100
+++ longterm-2.6.27/include/linux/if_packet.h	2012-02-05 22:34:46.429914864 +0100
@@ -61,6 +61,7 @@
 	__u16		tp_mac;
 	__u16		tp_net;
 	__u16		tp_vlan_tci;
+	__u16		tp_padding;
 };
 
 struct tpacket_hdr
@@ -93,6 +94,7 @@
 	__u32		tp_sec;
 	__u32		tp_nsec;
 	__u16		tp_vlan_tci;
+	__u16		tp_padding;
 };
 
 #define TPACKET2_HDRLEN		(TPACKET_ALIGN(sizeof(struct tpacket2_hdr)) + sizeof(struct sockaddr_ll))
Index: longterm-2.6.27/net/packet/af_packet.c
===================================================================
--- longterm-2.6.27.orig/net/packet/af_packet.c	2012-02-05 22:34:32.520914890 +0100
+++ longterm-2.6.27/net/packet/af_packet.c	2012-02-05 22:34:46.438916430 +0100
@@ -708,6 +708,7 @@
 		h.h2->tp_sec = ts.tv_sec;
 		h.h2->tp_nsec = ts.tv_nsec;
 		h.h2->tp_vlan_tci = skb->vlan_tci;
+		h.h2->tp_padding = 0;
 		hdrlen = sizeof(*h.h2);
 		break;
 	default:
@@ -1181,6 +1182,7 @@
 		aux.tp_net = skb_network_offset(skb);
 		aux.tp_vlan_tci = skb->vlan_tci;
 
+		aux.tp_padding = 0;
 		put_cmsg(msg, SOL_PACKET, PACKET_AUXDATA, sizeof(aux), &aux);
 	}
 


