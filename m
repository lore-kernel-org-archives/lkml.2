Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab2LJRZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 12:25:17 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:51305 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2LJRZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:25:15 -0500
X-IronPort-AV: E=Sophos;i="4.84,252,1355097600"; 
   d="scan'208";a="40446"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>, Huang Ying <ying.huang@intel.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH v2 2/3] llist: add a safe version of llist_for_each_entry
Date: Mon, 10 Dec 2012 18:24:49 +0100
Message-ID: <1355160290-22180-2-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1355160290-22180-1-git-send-email-roger.pau@citrix.com>
References: <1355160290-22180-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
---
 include/linux/llist.h |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/include/linux/llist.h b/include/linux/llist.h
index a5199f6..f611cd8 100644
--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -125,6 +125,33 @@ static inline void init_llist_head(struct llist_head *list)
 	     (pos) = llist_entry((pos)->member.next, typeof(*(pos)), member))
 
 /**
+ * llist_for_each_entry_safe - safely iterate over some deleted entries of
+ *                             lock-less list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		the &struct llist_node to use as a temporary loop cursor
+ * @node:	the fist entry of deleted list entries.
+ * @member:	the name of the llist_node with the struct.
+ *
+ * In general, some entries of the lock-less list can be traversed
+ * safely only after being removed from list, so start with an entry
+ * instead of list head.
+ *
+ * If being used on entries deleted from lock-less list directly, the
+ * traverse order is from the newest to the oldest added entry.  If
+ * you want to traverse from the oldest to the newest, you must
+ * reverse the order by yourself before traversing.
+ *
+ * n is used to store a reference to the next item llist_node, so
+ * pos can be freed while iterating.
+ */
+#define llist_for_each_entry_safe(pos, n, node, member)		\
+	for ((pos) = llist_entry((node), typeof(*(pos)), member),	\
+	     (n) = (pos)->member.next;					\
+	     &(pos)->member != NULL;					\
+	     (pos) = llist_entry(n, typeof(*(pos)), member),		\
+	     (n) = (&(pos)->member != NULL) ? (pos)->member.next : NULL)
+
+/**
  * llist_empty - tests whether a lock-less list is empty
  * @head:	the list to test
  *
-- 
1.7.7.5 (Apple Git-26)

