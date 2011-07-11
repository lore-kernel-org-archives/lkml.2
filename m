Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845Ab1GKOQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:16:34 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51078 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757735Ab1GKOPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:15:21 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Subject: [PATCH 2/7] cgroups: New resource counter inheritance API
Date: Mon, 11 Jul 2011 16:15:01 +0200
Message-Id: <1310393706-321-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310393706-321-1-git-send-email-fweisbec@gmail.com>
References: <1310393706-321-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an API to inherit a counter value from a parent.
This can be useful to implement cgroup.clone_children on
a resource counter.

Still the resources of the children are limited by those
of the parent, so this is only to provide a default setting
behaviour when clone_children is set.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
---
 include/linux/res_counter.h |    2 ++
 kernel/res_counter.c        |   25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index 1b3fe05..109d118 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -84,6 +84,8 @@ int res_counter_write(struct res_counter *counter, int member,
 
 void res_counter_write_u64(struct res_counter *counter, int member, u64 val);
 
+void res_counter_inherit(struct res_counter *counter, int member);
+
 /*
  * the field descriptors. one for each member of res_counter
  */
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 806d041..8cb0362 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -198,3 +198,28 @@ int res_counter_write(struct res_counter *counter, int member,
 
 	return 0;
 }
+
+void res_counter_inherit(struct res_counter *counter, int member)
+{
+	struct res_counter *parent;
+	unsigned long long *pval, val;
+	unsigned long flags;
+
+	parent = counter->parent;
+	if (!parent)
+		return;
+
+	local_irq_save(flags);
+
+	spin_lock(&counter->lock);
+	pval = res_counter_member(counter, member);
+	val = *pval;
+	spin_unlock(&counter->lock);
+
+	spin_lock(&parent->lock);
+	pval = res_counter_member(parent, member);
+	*pval = val;
+	spin_unlock(&parent->lock);
+
+	local_irq_restore(flags);
+}
-- 
1.7.5.4

