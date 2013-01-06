Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150Ab3AFHW4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 02:22:56 -0500
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:41675
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974Ab3AFHWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 02:22:53 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1155h)
From: Jason Liu <r64343@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <mgorman@suse.de>, <akpm@linux-foundation.org>, <riel@redhat.com>,
        <minchan@kernel.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <linux-mm@kvack.org>
Subject: [PATCH] mm: compaction: fix echo 1 > compact_memory return error issue
Date: Sun, 6 Jan 2013 15:44:33 +0800
Message-ID: <1357458273-28558-1-git-send-email-r64343@freescale.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when run the folloing command under shell, it will return error
sh/$ echo 1 > /proc/sys/vm/compact_memory
sh/$ sh: write error: Bad address

After strace, I found the following log:
...
write(1, "1\n", 2)               = 3
write(1, "", 4294967295)         = -1 EFAULT (Bad address)
write(2, "echo: write error: Bad address\n", 31echo: write error: Bad address
) = 31

This tells system return 3(COMPACT_COMPLETE) after write data to compact_memory.

The fix is to make the system just return 0 instead 3(COMPACT_COMPLETE) from
sysctl_compaction_handler after compaction_nodes finished.

Suggested-by:David Rientjes <rientjes@google.com>
Cc:Mel Gorman <mgorman@suse.de>
Cc:Andrew Morton <akpm@linux-foundation.org>
Cc:Rik van Riel <riel@redhat.com>
Cc:Minchan Kim <minchan@kernel.org>
Cc:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Jason Liu <r64343@freescale.com>
---
 mm/compaction.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 6b807e4..f8f5c11 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1210,7 +1210,7 @@ static int compact_node(int nid)
 }
 
 /* Compact all nodes in the system */
-static int compact_nodes(void)
+static void compact_nodes(void)
 {
 	int nid;
 
@@ -1219,8 +1219,6 @@ static int compact_nodes(void)
 
 	for_each_online_node(nid)
 		compact_node(nid);
-
-	return COMPACT_COMPLETE;
 }
 
 /* The written value is actually unused, all memory is compacted */
@@ -1231,7 +1229,7 @@ int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos)
 {
 	if (write)
-		return compact_nodes();
+		compact_nodes();
 
 	return 0;
 }
-- 
1.7.5.4


