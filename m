Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030433Ab2JSDQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:16:53 -0400
Received: from mail.kernel.org ([198.145.19.201]:51446 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757083Ab2JSCr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:47:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Cong Wang <amwang@redhat.com>, "David S. Miller" <davem@davemloft.net>
Subject: [ 33/62] pktgen: fix crash when generating IPv6 packets
Date: Thu, 18 Oct 2012 19:45:01 -0700
Message-Id: <20121019024301.334795540@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Cong Wang <amwang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/pktgen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2932,7 +2932,7 @@ static struct sk_buff *fill_packet_ipv6(
 		  sizeof(struct ipv6hdr) - sizeof(struct udphdr) -
 		  pkt_dev->pkt_overhead;
 
-	if (datalen < sizeof(struct pktgen_hdr)) {
+	if (datalen < 0 || datalen < sizeof(struct pktgen_hdr)) {
 		datalen = sizeof(struct pktgen_hdr);
 		if (net_ratelimit())
 			pr_info("increased datalen to %d\n", datalen);


