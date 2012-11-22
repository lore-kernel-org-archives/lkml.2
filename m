Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab2KVWmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:42:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:49018 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab2KVSdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tom Herbert <therbert@google.com>, Eric Dumazet <edumazet@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 035/171] net-rps: Fix brokeness causing OOO packets
Date: Wed, 21 Nov 2012 16:39:41 -0800
Message-Id: <20121122004036.896880033@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2763,8 +2763,10 @@ static int get_rps_cpu(struct net_device
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


