Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965875Ab2CAJYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 04:24:38 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49532 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964878Ab2CAJYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 04:24:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of santoshprasadnayak@gmail.com designates 10.68.197.35 as permitted sender) smtp.mail=santoshprasadnayak@gmail.com; dkim=pass header.i=santoshprasadnayak@gmail.com
From: santosh nayak <santoshprasadnayak@gmail.com>
To: bart.de.schuymer@pandora.be
Cc: pablo@netfilter.org, kaber@trash.net, shemminger@vyatta.com,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH 2/3] netfilter: potential null derefence.
Date: Thu,  1 Mar 2012 14:47:14 +0530
Message-Id: <1330593434-19275-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

I am getting following error.
" net/bridge/netfilter/ebtables.c:269 ebt_do_table()
  error: potential null derefence 'cs'"

    i = cs[sp].n;  // If cs == Null then this will cause problem.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 net/bridge/netfilter/ebtables.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index f3fcbd9..9c0f177 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -209,8 +209,10 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 	   smp_processor_id());
 	if (private->chainstack)
 		cs = private->chainstack[smp_processor_id()];
-	else
+	else {
 		cs = NULL;
+		goto out;
+	}
 	chaininfo = private->hook_entry[hook];
 	nentries = private->hook_entry[hook]->nentries;
 	point = (struct ebt_entry *)(private->hook_entry[hook]->data);
@@ -313,6 +315,7 @@ letscontinue:
 		read_unlock_bh(&table->lock);
 		return NF_ACCEPT;
 	}
+out:
 	read_unlock_bh(&table->lock);
 	return NF_DROP;
 }
-- 
1.7.4.4

