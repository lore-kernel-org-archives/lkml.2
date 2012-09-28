Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030362Ab2I1Xwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:52:33 -0400
Received: from imr4.ericy.com ([198.24.6.9]:39330 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964876Ab2I1Xwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:52:31 -0400
X-Greylist: delayed 697 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2012 19:52:31 EDT
From: Ramesh Nagappa <ramesh.nagappa@ericsson.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "michel@digirati.com.br" <michel@digirati.com.br>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Date: Fri, 28 Sep 2012 19:40:39 -0400
Subject: [PATCH] net: fix neigh_resolve_output can cause skb_under_panic
Thread-Topic: [PATCH] net: fix neigh_resolve_output can cause skb_under_panic
Thread-Index: Ac2d0qp2SdMgjwgYRBa2SxrMPMkOFw==
Message-ID: <CA3E5132752D1F49871ED0FC40D56BBA43ECE2E72D@EUSAACMS0701.eamcs.ericsson.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fd023edd911ef12aca38a72b40241661c202684f Mon Sep 17 00:00:00 2001
From: Ramesh Nagappa <ramesh.nagappa@ericsson.com>
Date: Thu, 27 Sep 2012 10:20:58 -0700
Subject: [PATCH] net: fix neigh_resolve_output can cause skb_under_panic

The retry loop in the neigh_resolve_output() and neigh_connected_output() can add
a hard_header without resetting the skb to network header. This causes the
skb_push() in dev_hard_header() to fail.
Signed-off-by: Ramesh Nagappa <ramesh.nagappa@ericsson.com>
Signed-off-by: Shawn Lu <shawn.lu@ericsson.com>
Reviewed-by: Billie Alsup <billie.alsup@ericsson.com>
Reviewed-by: Robert Coulson <robert.coulson@ericsson.com>
---
 net/core/neighbour.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 96bb0a3..5a3dfec5 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1327,6 +1327,7 @@ int neigh_resolve_output(struct sk_buff *skb)
 
 		do {
 			seq = read_seqbegin(&neigh->ha_lock);
+			__skb_pull(skb, skb_network_offset(skb));
 			err = dev_hard_header(skb, dev, ntohs(skb->protocol),
 					      neigh->ha, NULL, skb->len);
 		} while (read_seqretry(&neigh->ha_lock, seq));
@@ -1358,10 +1359,10 @@ int neigh_connected_output(struct sk_buff *skb)
 	struct net_device *dev = neigh->dev;
 	unsigned int seq;
 
-	__skb_pull(skb, skb_network_offset(skb));
 
 	do {
 		seq = read_seqbegin(&neigh->ha_lock);
+		__skb_pull(skb, skb_network_offset(skb));
 		err = dev_hard_header(skb, dev, ntohs(skb->protocol),
 				      neigh->ha, NULL, skb->len);
 	} while (read_seqretry(&neigh->ha_lock, seq));
-- 
1.7.3.1
