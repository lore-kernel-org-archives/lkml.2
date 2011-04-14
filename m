Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965003Ab1DNSNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:13:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:41941 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964930Ab1DNR6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:16 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Changli Gao <xiaosuo@gmail.com>,
        Jamal Hadi Salim <hadi@cyberus.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 150/209] ifb: goto resched directly if error happens and dp->tq isn't empty
Date: Thu, 14 Apr 2011 13:55:08 -0400
Message-Id: <1302803767-9715-37-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Changli Gao <xiaosuo@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 75c1c82566f23dd539fb7ccbf57a1caa7ba82628 upstream

If we break the loop when there are still skbs in tq and no skb in
rq, the skbs will be left in txq until new skbs are enqueued into rq.
In rare cases, no new skb is queued, then these skbs will stay in rq
forever.

After this patch, if tq isn't empty when we break the loop, we goto
resched directly.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/ifb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index f4081c0..7f8276e 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -104,6 +104,8 @@ static void ri_tasklet(unsigned long dev)
 			rcu_read_unlock();
 			dev_kfree_skb(skb);
 			stats->tx_dropped++;
+			if (skb_queue_len(&dp->tq) != 0)
+				goto resched;
 			break;
 		}
 		rcu_read_unlock();
-- 
1.7.4.4

