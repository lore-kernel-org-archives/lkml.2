Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab2BTUzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 15:55:23 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26484 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab2BTUzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 15:55:22 -0500
Date: Mon, 20 Feb 2012 21:56:20 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-rdma@vger.kernel.org, Hal Rosenstock <hal.rosenstock@gmail.com>,
        Sean Hefty <sean.hefty@intel.com>, Roland Dreier <roland@kernel.org>,
        Faisal Latif <faisal.latif@intel.com>
Subject: [PATCH] IB: Fix potential mem leak in schedule_nes_timer()
Message-ID: <alpine.LNX.2.00.1202202153230.20998@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/infiniband/hw/nes/nes_cm.c::schedule_nes_timer(), if we do
not take the true branch of either the
  (type == NES_TIMER_TYPE_SEND)
or
  (type == NES_TIMER_TYPE_SEND)
'if' statements (which it looks like we potentially could since that
enum can have other values), then we'll leak the memory allocated to
'new_send'.

This (admittedly, rather clumsy) patch addresses that issue by turning
the two 'if's into 'if' 'else if' and then adding a 'else' branch
where we note that we need to free the mem and then later, when we are
done with it, does a conditional kfree() based on the bool we set in
the 'else' branch.

I also removed a redundant variable ('was_timer_set').

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/infiniband/hw/nes/nes_cm.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

 Compile tested only.

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index a4972ab..434a25b 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -663,8 +663,8 @@ int schedule_nes_timer(struct nes_cm_node *cm_node, struct sk_buff *skb,
 	unsigned long flags;
 	struct nes_cm_core *cm_core = cm_node->cm_core;
 	struct nes_timer_entry *new_send;
+	bool free_new_send = false;
 	int ret = 0;
-	u32 was_timer_set;
 
 	new_send = kzalloc(sizeof(*new_send), GFP_ATOMIC);
 	if (!new_send)
@@ -688,9 +688,7 @@ int schedule_nes_timer(struct nes_cm_node *cm_node, struct sk_buff *skb,
 			return -EINVAL;
 		}
 		cm_node->recv_entry = new_send;
-	}
-
-	if (type == NES_TIMER_TYPE_SEND) {
+	} else if (type == NES_TIMER_TYPE_SEND) {
 		new_send->seq_num = ntohl(tcp_hdr(skb)->seq);
 		atomic_inc(&new_send->skb->users);
 		spin_lock_irqsave(&cm_node->retrans_list_lock, flags);
@@ -714,15 +712,18 @@ int schedule_nes_timer(struct nes_cm_node *cm_node, struct sk_buff *skb,
 				return ret;
 			}
 		}
+	} else {
+		free_new_send = true;
 	}
 
-	was_timer_set = timer_pending(&cm_core->tcp_timer);
-
-	if (!was_timer_set) {
+	if (!timer_pending(&cm_core->tcp_timer)) {
 		cm_core->tcp_timer.expires = new_send->timetosend;
 		add_timer(&cm_core->tcp_timer);
 	}
 
+	if (free_new_send)
+		kfree(new_send);
+
 	return ret;
 }
 
-- 
1.7.9.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

