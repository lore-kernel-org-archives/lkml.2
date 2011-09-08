Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab1IHGBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 02:01:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:48915 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758020Ab1IHGA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 02:00:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,349,1312182000"; 
   d="scan'208";a="50364523"
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH -mm -v2 2/5] llist, Define macro to check NMI safe cmpxchg
Date: Thu,  8 Sep 2011 14:00:43 +0800
Message-Id: <1315461646-1379-3-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
References: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make code cleaner and reduce code duplication.  Thanks Peter
Zijlstra for reminding.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/llist.h |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -70,6 +70,12 @@ struct llist_node {
 #define LLIST_HEAD_INIT(name)	{ NULL }
 #define LLIST_HEAD(name)	struct llist_head name = LLIST_HEAD_INIT(name)
 
+#ifdef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+#define CHECK_NMI_SAFE_CMPXCHG()
+#else
+#define CHECK_NMI_SAFE_CMPXCHG()	BUG_ON(in_nmi())
+#endif
+
 /**
  * init_llist_head - initialize lock-less list head
  * @head:	the head for your lock-less list
@@ -147,9 +153,7 @@ static inline void llist_add(struct llis
 {
 	struct llist_node *entry, *old_entry;
 
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
+	CHECK_NMI_SAFE_CMPXCHG();
 
 	entry = head->first;
 	do {
@@ -171,9 +175,7 @@ static inline void llist_add_batch(struc
 {
 	struct llist_node *entry, *old_entry;
 
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
+	CHECK_NMI_SAFE_CMPXCHG();
 
 	entry = head->first;
 	do {
@@ -201,9 +203,7 @@ static inline struct llist_node *llist_d
 {
 	struct llist_node *entry, *old_entry, *next;
 
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
+	CHECK_NMI_SAFE_CMPXCHG();
 
 	entry = head->first;
 	do {
@@ -227,9 +227,7 @@ static inline struct llist_node *llist_d
  */
 static inline struct llist_node *llist_del_all(struct llist_head *head)
 {
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
+	CHECK_NMI_SAFE_CMPXCHG();
 
 	return xchg(&head->first, NULL);
 }
