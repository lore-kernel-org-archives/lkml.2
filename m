Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab0IPLY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 07:24:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:40133 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab0IPLYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 07:24:25 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, oleg@redhat.com
Cc: dmitry.torokhov@gmail.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] workqueue: implement alloc_ordered_workqueue()
Date: Thu, 16 Sep 2010 13:24:04 +0200
Message-Id: <1284636247-4734-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284636247-4734-1-git-send-email-tj@kernel.org>
References: <1284636247-4734-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Sep 2010 11:24:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_ordered_workqueue() creates a workqueue which processes each
work itemp one by one in the queued order.  This will be used to
replace create_freezeable_workqueue() and
create_singlethread_workqueue().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 25e02c9..07c4892 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -306,6 +306,24 @@ __alloc_workqueue_key(const char *name, unsigned int flags, int max_active,
 	__alloc_workqueue_key((name), (flags), (max_active), NULL, NULL)
 #endif
 
+/**
+ * alloc_ordered_workqueue - allocate an ordered workqueue
+ * @name: name of the workqueue
+ * @flags: WQ_* flags (only WQ_FREEZEABLE and WQ_RESCUER are meaningful)
+ *
+ * Allocate an ordered workqueue.  An ordered workqueue executes at
+ * most one work item at any given time in the queued order.  They are
+ * implemented as unbound workqueues with @max_active of one.
+ *
+ * RETURNS:
+ * Pointer to the allocated workqueue on success, %NULL on failure.
+ */
+static inline struct workqueue_struct *
+alloc_ordered_workqueue(const char *name, unsigned int flags)
+{
+	return alloc_workqueue(name, WQ_UNBOUND | flags, 1);
+}
+
 #define create_workqueue(name)					\
 	alloc_workqueue((name), WQ_RESCUER, 1)
 #define create_freezeable_workqueue(name)			\
-- 
1.7.1

