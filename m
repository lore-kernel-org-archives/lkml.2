Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab2JNOmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:42:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46160 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754278Ab2JNOmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:05 -0400
Message-Id: <20121014143552.169789826@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 136/147] netfilter: nf_ct_ipv4: packets with wrong ihl are  invalid
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

commit 07153c6ec074257ade76a461429b567cff2b3a1e upstream.

It was reported that the Linux kernel sometimes logs:

klogd: [2629147.402413] kernel BUG at net / netfilter /
nf_conntrack_proto_tcp.c: 447!
klogd: [1072212.887368] kernel BUG at net / netfilter /
nf_conntrack_proto_tcp.c: 392

ipv4_get_l4proto() in nf_conntrack_l3proto_ipv4.c and tcp_error() in
nf_conntrack_proto_tcp.c should catch malformed packets, so the errors
at the indicated lines - TCP options parsing - should not happen.
However, tcp_error() relies on the "dataoff" offset to the TCP header,
calculated by ipv4_get_l4proto().  But ipv4_get_l4proto() does not check
bogus ihl values in IPv4 packets, which then can slip through tcp_error()
and get caught at the TCP options parsing routines.

The patch fixes ipv4_get_l4proto() by invalidating packets with bogus
ihl value.

The patch closes netfilter bugzilla id 771.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 750b06a..cf73cc7 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -84,6 +84,14 @@ static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 	*dataoff = nhoff + (iph->ihl << 2);
 	*protonum = iph->protocol;
 
+	/* Check bogus IP headers */
+	if (*dataoff > skb->len) {
+		pr_debug("nf_conntrack_ipv4: bogus IPv4 packet: "
+			 "nhoff %u, ihl %u, skblen %u\n",
+			 nhoff, iph->ihl << 2, skb->len);
+		return -NF_ACCEPT;
+	}
+
 	return NF_ACCEPT;
 }
 


