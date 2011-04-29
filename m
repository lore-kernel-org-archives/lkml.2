Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755Ab1D2TJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:09:40 -0400
Received: from kroah.org ([198.145.64.141]:50179 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932645Ab1D2S6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:53 2011
Message-Id: <20110429185653.169236556@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Amit Kumar Salecha <amit.salecha@qlogic.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [06/55] qlcnic: limit skb frags for non tso packet
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Amit Kumar Salecha <amit.salecha@qlogic.com>

commit 91a403caf0f26c71ce4407fd235b2d6fb225fba9 upstream.

Machines are getting deadlock in four node cluster environment.
All nodes are accessing (find /gfs2 -depth -print|cpio -ocv > /dev/null)
200 GB storage on a GFS2 filesystem.
This result in memory fragmentation and driver receives 18 frags for
1448 byte packets.
For non tso packet, fw drops the tx request, if it has >14 frags.

Fixing it by pulling extra frags.

Signed-off-by: Amit Kumar Salecha <amit.salecha@qlogic.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/qlcnic/qlcnic.h      |    1 +
 drivers/net/qlcnic/qlcnic_main.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+)

--- a/drivers/net/qlcnic/qlcnic.h
+++ b/drivers/net/qlcnic/qlcnic.h
@@ -99,6 +99,7 @@
 #define TX_UDPV6_PKT	0x0c
 
 /* Tx defines */
+#define QLCNIC_MAX_FRAGS_PER_TX	14
 #define MAX_TSO_HEADER_DESC	2
 #define MGMT_CMD_DESC_RESV	4
 #define TX_STOP_THRESH		((MAX_SKB_FRAGS >> 2) + MAX_TSO_HEADER_DESC \
--- a/drivers/net/qlcnic/qlcnic_main.c
+++ b/drivers/net/qlcnic/qlcnic_main.c
@@ -2099,6 +2099,7 @@ qlcnic_xmit_frame(struct sk_buff *skb, s
 	struct cmd_desc_type0 *hwdesc, *first_desc;
 	struct pci_dev *pdev;
 	struct ethhdr *phdr;
+	int delta = 0;
 	int i, k;
 
 	u32 producer;
@@ -2118,6 +2119,19 @@ qlcnic_xmit_frame(struct sk_buff *skb, s
 	}
 
 	frag_count = skb_shinfo(skb)->nr_frags + 1;
+	/* 14 frags supported for normal packet and
+	 * 32 frags supported for TSO packet
+	 */
+	if (!skb_is_gso(skb) && frag_count > QLCNIC_MAX_FRAGS_PER_TX) {
+
+		for (i = 0; i < (frag_count - QLCNIC_MAX_FRAGS_PER_TX); i++)
+			delta += skb_shinfo(skb)->frags[i].size;
+
+		if (!__pskb_pull_tail(skb, delta))
+			goto drop_packet;
+
+		frag_count = 1 + skb_shinfo(skb)->nr_frags;
+	}
 
 	/* 4 fragments per cmd des */
 	no_of_desc = (frag_count + 3) >> 2;


