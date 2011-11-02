Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab1KCBeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:34:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50444 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932635Ab1KCBeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:34:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:50 2011
Message-Id: <20111102221450.806045624@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:13:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sridhar Samudrala <sri@us.ibm.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Faidon Liambotis <paravoid@debian.org>
Subject: [008/107] net: Fix IPv6 GSO type checks in Intel ethernet drivers
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Sridhar Samudrala <sri@us.ibm.com>

commit 8e1e8a4779cb23c1d9f51e9223795e07ec54d77a upstream.

Found this problem when testing IPv6 from a KVM guest to a remote
host via e1000e device on the host.
The following patch fixes the check for IPv6 GSO packet in Intel
ethernet drivers to use skb_is_gso_v6(). SKB_GSO_DODGY is also set
when packets are forwarded from a guest.

Signed-off-by: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Faidon Liambotis <paravoid@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/net/e1000e/netdev.c    |    2 +-
 drivers/net/igb/igb_main.c     |    2 +-
 drivers/net/igbvf/netdev.c     |    2 +-
 drivers/net/ixgbe/ixgbe_main.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -3807,7 +3807,7 @@ static int e1000_tso(struct e1000_adapte
 								 0);
 			cmd_length = E1000_TXD_CMD_IP;
 			ipcse = skb_transport_offset(skb) - 1;
-		} else if (skb_shinfo(skb)->gso_type == SKB_GSO_TCPV6) {
+		} else if (skb_is_gso_v6(skb)) {
 			ipv6_hdr(skb)->payload_len = 0;
 			tcp_hdr(skb)->check =
 				~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -3032,7 +3032,7 @@ static inline int igb_tso_adv(struct igb
 							 iph->daddr, 0,
 							 IPPROTO_TCP,
 							 0);
-	} else if (skb_shinfo(skb)->gso_type == SKB_GSO_TCPV6) {
+	} else if (skb_is_gso_v6(skb)) {
 		ipv6_hdr(skb)->payload_len = 0;
 		tcp_hdr(skb)->check = ~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
 						       &ipv6_hdr(skb)->daddr,
--- a/drivers/net/igbvf/netdev.c
+++ b/drivers/net/igbvf/netdev.c
@@ -1953,7 +1953,7 @@ static int igbvf_tso(struct igbvf_adapte
 		                                         iph->daddr, 0,
 		                                         IPPROTO_TCP,
 		                                         0);
-	} else if (skb_shinfo(skb)->gso_type == SKB_GSO_TCPV6) {
+	} else if (skb_is_gso_v6(skb)) {
 		ipv6_hdr(skb)->payload_len = 0;
 		tcp_hdr(skb)->check = ~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
 		                                       &ipv6_hdr(skb)->daddr,
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -4881,7 +4881,7 @@ static int ixgbe_tso(struct ixgbe_adapte
 			                                         IPPROTO_TCP,
 			                                         0);
 			adapter->hw_tso_ctxt++;
-		} else if (skb_shinfo(skb)->gso_type == SKB_GSO_TCPV6) {
+		} else if (skb_is_gso_v6(skb)) {
 			ipv6_hdr(skb)->payload_len = 0;
 			tcp_hdr(skb)->check =
 			    ~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,


