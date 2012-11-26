Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab2KZREE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:04:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47342 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab2KZRD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:03:59 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>, Cong Wang <amwang@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 068/270] pktgen: fix crash when generating IPv6 packets
Date: Mon, 26 Nov 2012 14:55:58 -0200
Message-Id: <1353949160-26803-69-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/core/pktgen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index cce9e53..aa278cd 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2927,7 +2927,7 @@ static struct sk_buff *fill_packet_ipv6(struct net_device *odev,
 		  sizeof(struct ipv6hdr) - sizeof(struct udphdr) -
 		  pkt_dev->pkt_overhead;
 
-	if (datalen < sizeof(struct pktgen_hdr)) {
+	if (datalen < 0 || datalen < sizeof(struct pktgen_hdr)) {
 		datalen = sizeof(struct pktgen_hdr);
 		net_info_ratelimited("increased datalen to %d\n", datalen);
 	}
-- 
1.7.9.5

