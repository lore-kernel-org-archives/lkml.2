Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab2J1X2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:28:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42175 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756979Ab2J1X2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:23 -0400
Message-Id: <20121028231549.148020010@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:15 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Amerigo Wang <amwang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 039/105] pktgen: fix crash when generating IPv6 packets
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amerigo Wang <amwang@redhat.com>

commit 5aa8b572007c4bca1e6d3dd4c4820f1ae49d6bb2 upstream.

For IPv6, sizeof(struct ipv6hdr) = 40, thus the following
expression will result negative:

        datalen = pkt_dev->cur_pkt_size - 14 -
                  sizeof(struct ipv6hdr) - sizeof(struct udphdr) -
                  pkt_dev->pkt_overhead;

And,  the check "if (datalen < sizeof(struct pktgen_hdr))" will be
passed as "datalen" is promoted to unsigned, therefore will cause
a crash later.

This is a quick fix by checking if "datalen" is negative. The following
patch will increase the default value of 'min_pkt_size' for IPv6.

This bug should exist for a long time, so Cc -stable too.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Cong Wang <amwang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/pktgen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2935,7 +2935,7 @@ static struct sk_buff *fill_packet_ipv6(
 		  sizeof(struct ipv6hdr) - sizeof(struct udphdr) -
 		  pkt_dev->pkt_overhead;
 
-	if (datalen < sizeof(struct pktgen_hdr)) {
+	if (datalen < 0 || datalen < sizeof(struct pktgen_hdr)) {
 		datalen = sizeof(struct pktgen_hdr);
 		if (net_ratelimit())
 			pr_info("increased datalen to %d\n", datalen);


