Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab1IHGBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 02:01:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:48915 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758021Ab1IHGBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 02:01:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,349,1312182000"; 
   d="scan'208";a="50364537"
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH -mm -v2 4/5] llist, Return whether list is empty before adding in llist_add
Date: Thu,  8 Sep 2011 14:00:45 +0800
Message-Id: <1315461646-1379-5-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
References: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed by irq_work.  And because list_add_xxx functions are
inline, this can be optimized out if not needed by callers.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/llist.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -148,8 +148,10 @@ static inline bool llist_empty(const str
  * llist_add - add a new entry
  * @new:	new entry to be added
  * @head:	the head for your lock-less list
+ *
+ * Return whether list is empty before adding.
  */
-static inline void llist_add(struct llist_node *new, struct llist_head *head)
+static inline bool llist_add(struct llist_node *new, struct llist_head *head)
 {
 	struct llist_node *entry, *old_entry;
 
@@ -164,6 +166,8 @@ static inline void llist_add(struct llis
 			break;
 		cpu_relax();
 	}
+
+	return old_entry == NULL;
 }
 
 /**
@@ -171,8 +175,10 @@ static inline void llist_add(struct llis
  * @new_first:	first entry in batch to be added
  * @new_last:	last entry in batch to be added
  * @head:	the head for your lock-less list
+ *
+ * Return whether list is empty before adding.
  */
-static inline void llist_add_batch(struct llist_node *new_first,
+static inline bool llist_add_batch(struct llist_node *new_first,
 				   struct llist_node *new_last,
 				   struct llist_head *head)
 {
@@ -189,6 +195,8 @@ static inline void llist_add_batch(struc
 			break;
 		cpu_relax();
 	}
+
+	return old_entry == NULL;
 }
 
 /**
