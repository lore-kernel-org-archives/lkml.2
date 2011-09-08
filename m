Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab1IHGBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 02:01:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:48915 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758006Ab1IHGBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 02:01:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,349,1312182000"; 
   d="scan'208";a="50364532"
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH -mm -v2 3/5] llist, Move cpu_relax after cmpxchg
Date: Thu,  8 Sep 2011 14:00:44 +0800
Message-Id: <1315461646-1379-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
References: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the first cmpxchg calling succeeds, it is not necessary to use
cpu_relax before cmpxchg.  So cpu_relax in a busy loop involving
cmpxchg should go after cmpxchg instead of before that.  This patch
fixes this in llist.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/llist.h |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -156,11 +156,14 @@ static inline void llist_add(struct llis
 	CHECK_NMI_SAFE_CMPXCHG();
 
 	entry = head->first;
-	do {
+	for (;;) {
 		old_entry = entry;
 		new->next = entry;
+		entry = cmpxchg(&head->first, old_entry, new);
+		if (entry == old_entry)
+			break;
 		cpu_relax();
-	} while ((entry = cmpxchg(&head->first, old_entry, new)) != old_entry);
+	}
 }
 
 /**
@@ -178,11 +181,14 @@ static inline void llist_add_batch(struc
 	CHECK_NMI_SAFE_CMPXCHG();
 
 	entry = head->first;
-	do {
+	for (;;) {
 		old_entry = entry;
 		new_last->next = entry;
+		entry = cmpxchg(&head->first, old_entry, new_first);
+		if (entry == old_entry)
+			break;
 		cpu_relax();
-	} while ((entry = cmpxchg(&head->first, old_entry, new_first)) != old_entry);
+	}
 }
 
 /**
@@ -206,13 +212,16 @@ static inline struct llist_node *llist_d
 	CHECK_NMI_SAFE_CMPXCHG();
 
 	entry = head->first;
-	do {
+	for (;;) {
 		if (entry == NULL)
 			return NULL;
 		old_entry = entry;
 		next = entry->next;
+		entry = cmpxchg(&head->first, old_entry, next);
+		if (entry == old_entry)
+			break;
 		cpu_relax();
-	} while ((entry = cmpxchg(&head->first, old_entry, next)) != old_entry);
+	}
 
 	return entry;
 }
