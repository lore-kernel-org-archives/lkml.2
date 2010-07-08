Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab0GHJUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 05:20:20 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46424 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab0GHJUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 05:20:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] reduce stack usage of node_read_meminfo()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100708181629.CD3C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  8 Jul 2010 18:20:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now, cmpilation node_read_meminfo() output following warning. Because
it has very large sprintf() argument.

	drivers/base/node.c: In function 'node_read_meminfo':
	drivers/base/node.c:139: warning: the frame size of 848 bytes is
	larger than 512 bytes

This patch fixes it by splitting sprintf() in three parts.
It doesn't have functional change.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 drivers/base/node.c |   46 +++++++++++++++++++++++-----------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 2bdd8a9..a0fb2ef 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -66,8 +66,7 @@ static ssize_t node_read_meminfo(struct sys_device * dev,
 	struct sysinfo i;
 
 	si_meminfo_node(&i, nid);
-
-	n = sprintf(buf, "\n"
+	n = sprintf(buf,
 		       "Node %d MemTotal:       %8lu kB\n"
 		       "Node %d MemFree:        %8lu kB\n"
 		       "Node %d MemUsed:        %8lu kB\n"
@@ -78,13 +77,33 @@ static ssize_t node_read_meminfo(struct sys_device * dev,
 		       "Node %d Active(file):   %8lu kB\n"
 		       "Node %d Inactive(file): %8lu kB\n"
 		       "Node %d Unevictable:    %8lu kB\n"
-		       "Node %d Mlocked:        %8lu kB\n"
+		       "Node %d Mlocked:        %8lu kB\n",
+		       nid, K(i.totalram),
+		       nid, K(i.freeram),
+		       nid, K(i.totalram - i.freeram),
+		       nid, K(node_page_state(nid, NR_ACTIVE_ANON) +
+				node_page_state(nid, NR_ACTIVE_FILE)),
+		       nid, K(node_page_state(nid, NR_INACTIVE_ANON) +
+				node_page_state(nid, NR_INACTIVE_FILE)),
+		       nid, K(node_page_state(nid, NR_ACTIVE_ANON)),
+		       nid, K(node_page_state(nid, NR_INACTIVE_ANON)),
+		       nid, K(node_page_state(nid, NR_ACTIVE_FILE)),
+		       nid, K(node_page_state(nid, NR_INACTIVE_FILE)),
+		       nid, K(node_page_state(nid, NR_UNEVICTABLE)),
+		       nid, K(node_page_state(nid, NR_MLOCK)));
+
 #ifdef CONFIG_HIGHMEM
+	n += sprintf(buf,
 		       "Node %d HighTotal:      %8lu kB\n"
 		       "Node %d HighFree:       %8lu kB\n"
 		       "Node %d LowTotal:       %8lu kB\n"
-		       "Node %d LowFree:        %8lu kB\n"
+		       "Node %d LowFree:        %8lu kB\n",
+		       nid, K(i.totalhigh),
+		       nid, K(i.freehigh),
+		       nid, K(i.totalram - i.totalhigh),
+		       nid, K(i.freeram - i.freehigh));
 #endif
+	n += sprintf(buf,
 		       "Node %d Dirty:          %8lu kB\n"
 		       "Node %d Writeback:      %8lu kB\n"
 		       "Node %d FilePages:      %8lu kB\n"
@@ -99,25 +118,6 @@ static ssize_t node_read_meminfo(struct sys_device * dev,
 		       "Node %d Slab:           %8lu kB\n"
 		       "Node %d SReclaimable:   %8lu kB\n"
 		       "Node %d SUnreclaim:     %8lu kB\n",
-		       nid, K(i.totalram),
-		       nid, K(i.freeram),
-		       nid, K(i.totalram - i.freeram),
-		       nid, K(node_page_state(nid, NR_ACTIVE_ANON) +
-				node_page_state(nid, NR_ACTIVE_FILE)),
-		       nid, K(node_page_state(nid, NR_INACTIVE_ANON) +
-				node_page_state(nid, NR_INACTIVE_FILE)),
-		       nid, K(node_page_state(nid, NR_ACTIVE_ANON)),
-		       nid, K(node_page_state(nid, NR_INACTIVE_ANON)),
-		       nid, K(node_page_state(nid, NR_ACTIVE_FILE)),
-		       nid, K(node_page_state(nid, NR_INACTIVE_FILE)),
-		       nid, K(node_page_state(nid, NR_UNEVICTABLE)),
-		       nid, K(node_page_state(nid, NR_MLOCK)),
-#ifdef CONFIG_HIGHMEM
-		       nid, K(i.totalhigh),
-		       nid, K(i.freehigh),
-		       nid, K(i.totalram - i.totalhigh),
-		       nid, K(i.freeram - i.freehigh),
-#endif
 		       nid, K(node_page_state(nid, NR_FILE_DIRTY)),
 		       nid, K(node_page_state(nid, NR_WRITEBACK)),
 		       nid, K(node_page_state(nid, NR_FILE_PAGES)),
-- 
1.6.5.2



