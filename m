Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab1FSXvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 19:51:51 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59730 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab1FSXv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 19:51:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=G6AXTtTjsFT4iFwx7avfoS8I6id7rNl2Fy46umqN+gWqIqthIOab95HHTwm5dDk9ed
         vn7YkX6D2tyhyRdpleviHyiSCYVtjnWdjWT3WJUrC5lvsWoWo1Hr/EhVh5EOuBKMU/Nz
         l+kFkzhX+r1GkX5rjN6AY2gnEe1Z5VXSg7lTY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 3/4] cgroups: New resource counter inheritance API
Date: Mon, 20 Jun 2011 01:51:13 +0200
Message-Id: <1308527474-20704-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
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
Cc: Andrew Morton <akpm@linux-foundation.org>
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

