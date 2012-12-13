Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324Ab2LMOVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:21:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45060 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933321Ab2LMOOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:14:06 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tom Herbert <therbert@google.com>, "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 215/241] net-rps: Fix brokeness causing OOO packets
Date: Thu, 13 Dec 2012 11:59:40 -0200
Message-Id: <1355407206-17100-216-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Herbert <therbert@google.com>

commit baefa31db2f2b13a05d1b81bdf2d20d487f58b0a upstream.

In commit c445477d74ab3779 which adds aRFS to the kernel, the CPU
selected for RFS is not set correctly when CPU is changing.
This is causing OOO packets and probably other issues.

Signed-off-by: Tom Herbert <therbert@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/core/dev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 75845ba..3ad746b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2761,8 +2761,10 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
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
-- 
1.7.9.5

