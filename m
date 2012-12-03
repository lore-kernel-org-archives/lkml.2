Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2LCOiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:38:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44002 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932476Ab2LCOhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:37:06 -0500
Message-Id: <20121203143151.297978374@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:13 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tom Herbert <therbert@google.com>, Eric Dumazet <edumazet@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 27/89] net-rps: Fix brokeness causing OOO packets
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Herbert <therbert@google.com>

[ Upstream commit baefa31db2f2b13a05d1b81bdf2d20d487f58b0a ]

In commit c445477d74ab3779 which adds aRFS to the kernel, the CPU
selected for RFS is not set correctly when CPU is changing.
This is causing OOO packets and probably other issues.

Signed-off-by: Tom Herbert <therbert@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 480be72..2aac4ec 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2829,8 +2829,10 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 		if (unlikely(tcpu != next_cpu) &&
 		    (tcpu == RPS_NO_CPU || !cpu_online(tcpu) ||
 		     ((int)(per_cpu(softnet_data, tcpu).input_queue_head -
-		      rflow->last_qtail)) >= 0))
+		      rflow->last_qtail)) >= 0)) {
+			tcpu = next_cpu;
 			rflow = set_rps_cpu(dev, skb, rflow, next_cpu);
+		}
 
 		if (tcpu != RPS_NO_CPU && cpu_online(tcpu)) {
 			*rflowp = rflow;


