Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab1D2S6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:58:12 -0400
Received: from kroah.org ([198.145.64.141]:50151 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760864Ab1D2S6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:05 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:52 2011
Message-Id: <20110429185652.775598443@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Amit Kumar Salecha <amit.salecha@qlogic.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [02/55] netxen: limit skb frags for non tso packet
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: amit salecha <amit.salecha@qlogic.com>

commit c968bdf6912cad6d0fc63d7037cc1c870604a808 upstream.

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
 drivers/net/netxen/netxen_nic.h      |    4 ++--
 drivers/net/netxen/netxen_nic_main.c |   17 +++++++++++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

--- a/drivers/net/netxen/netxen_nic.h
+++ b/drivers/net/netxen/netxen_nic.h
@@ -174,7 +174,7 @@
 
 #define	MAX_NUM_CARDS		4
 
-#define MAX_BUFFERS_PER_CMD	32
+#define NETXEN_MAX_FRAGS_PER_TX	14
 #define MAX_TSO_HEADER_DESC	2
 #define MGMT_CMD_DESC_RESV	4
 #define TX_STOP_THRESH		((MAX_SKB_FRAGS >> 2) + MAX_TSO_HEADER_DESC \
@@ -558,7 +558,7 @@ struct netxen_recv_crb {
  */
 struct netxen_cmd_buffer {
 	struct sk_buff *skb;
-	struct netxen_skb_frag frag_array[MAX_BUFFERS_PER_CMD + 1];
+	struct netxen_skb_frag frag_array[MAX_SKB_FRAGS + 1];
 	u32 frag_count;
 };
 
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -1841,6 +1841,8 @@ netxen_nic_xmit_frame(struct sk_buff *sk
 	struct cmd_desc_type0 *hwdesc, *first_desc;
 	struct pci_dev *pdev;
 	int i, k;
+	int delta = 0;
+	struct skb_frag_struct *frag;
 
 	u32 producer;
 	int frag_count, no_of_desc;
@@ -1848,6 +1850,21 @@ netxen_nic_xmit_frame(struct sk_buff *sk
 
 	frag_count = skb_shinfo(skb)->nr_frags + 1;
 
+	/* 14 frags supported for normal packet and
+	 * 32 frags supported for TSO packet
+	 */
+	if (!skb_is_gso(skb) && frag_count > NETXEN_MAX_FRAGS_PER_TX) {
+
+		for (i = 0; i < (frag_count - NETXEN_MAX_FRAGS_PER_TX); i++) {
+			frag = &skb_shinfo(skb)->frags[i];
+			delta += frag->size;
+		}
+
+		if (!__pskb_pull_tail(skb, delta))
+			goto drop_packet;
+
+		frag_count = 1 + skb_shinfo(skb)->nr_frags;
+	}
 	/* 4 fragments per cmd des */
 	no_of_desc = (frag_count + 3) >> 2;
 


