Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183Ab2DXXLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:11:50 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:41714 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428Ab2DXXLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:11:46 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 1/2] res_counter: Merge res_counter_charge and res_counter_charge_nofail
Date: Wed, 25 Apr 2012 01:11:35 +0200
Message-Id: <1335309096-12886-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335309096-12886-1-git-send-email-fweisbec@gmail.com>
References: <1335309096-12886-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two functions do almost the same thing and duplicate some code.
Merge their implementation into a single common function.
res_counter_charge_locked() takes one more parameter but it doesn't seem
to be used outside res_counter.c yet anyway.

There is no (intended) change in the behaviour.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
---
 Documentation/cgroups/resource_counter.txt |    4 +-
 include/linux/res_counter.h                |    2 +-
 kernel/res_counter.c                       |   73 +++++++++++++---------------
 3 files changed, 37 insertions(+), 42 deletions(-)

diff --git a/Documentation/cgroups/resource_counter.txt b/Documentation/cgroups/resource_counter.txt
index 95b24d7..f3c4ec3 100644
--- a/Documentation/cgroups/resource_counter.txt
+++ b/Documentation/cgroups/resource_counter.txt
@@ -77,11 +77,11 @@ to work with it.
 	where the charging failed.
 
  d. int res_counter_charge_locked
-			(struct res_counter *rc, unsigned long val)
+			(struct res_counter *rc, unsigned long val, bool force)
 
 	The same as res_counter_charge(), but it must not acquire/release the
 	res_counter->lock internally (it must be called with res_counter->lock
-	held).
+	held). The force parameter indicates whether we can bypass the limit.
 
  e. void res_counter_uncharge[_locked]
 			(struct res_counter *rc, unsigned long val)
diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index da81af0..fb20189 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -116,7 +116,7 @@ void res_counter_init(struct res_counter *counter, struct res_counter *parent);
  */
 
 int __must_check res_counter_charge_locked(struct res_counter *counter,
-		unsigned long val);
+					   unsigned long val, bool force);
 int __must_check res_counter_charge(struct res_counter *counter,
 		unsigned long val, struct res_counter **limit_fail_at);
 int __must_check res_counter_charge_nofail(struct res_counter *counter,
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index d508363..07a2992 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -22,75 +22,70 @@ void res_counter_init(struct res_counter *counter, struct res_counter *parent)
 	counter->parent = parent;
 }
 
-int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
+int res_counter_charge_locked(struct res_counter *counter, unsigned long val,
+			      bool force)
 {
+	int ret = 0;
+
 	if (counter->usage + val > counter->limit) {
 		counter->failcnt++;
-		return -ENOMEM;
+		ret = -ENOMEM;
+		if (!force)
+			return ret;
 	}
 
 	counter->usage += val;
-	if (counter->usage > counter->max_usage)
+	if (!force && counter->usage > counter->max_usage)
 		counter->max_usage = counter->usage;
-	return 0;
+	return ret;
 }
 
-int res_counter_charge(struct res_counter *counter, unsigned long val,
-			struct res_counter **limit_fail_at)
+static int __res_counter_charge(struct res_counter *counter, unsigned long val,
+				struct res_counter **limit_fail_at, bool force)
 {
-	int ret;
+	int ret, r;
 	unsigned long flags;
 	struct res_counter *c, *u;
 
+	r = ret = 0;
 	*limit_fail_at = NULL;
 	local_irq_save(flags);
 	for (c = counter; c != NULL; c = c->parent) {
 		spin_lock(&c->lock);
-		ret = res_counter_charge_locked(c, val);
+		r = res_counter_charge_locked(c, val, force);
 		spin_unlock(&c->lock);
-		if (ret < 0) {
+		if (r < 0 && !ret) {
+			ret = r;
 			*limit_fail_at = c;
-			goto undo;
+			if (!force)
+				break;
 		}
 	}
-	ret = 0;
-	goto done;
-undo:
-	for (u = counter; u != c; u = u->parent) {
-		spin_lock(&u->lock);
-		res_counter_uncharge_locked(u, val);
-		spin_unlock(&u->lock);
+
+	if (ret < 0 && !force) {
+		for (u = counter; u != c; u = u->parent) {
+			spin_lock(&u->lock);
+			res_counter_uncharge_locked(u, val);
+			spin_unlock(&u->lock);
+		}
 	}
-done:
 	local_irq_restore(flags);
+
 	return ret;
 }
 
+int res_counter_charge(struct res_counter *counter, unsigned long val,
+			struct res_counter **limit_fail_at)
+{
+	return __res_counter_charge(counter, val, limit_fail_at, false);
+}
+
 int res_counter_charge_nofail(struct res_counter *counter, unsigned long val,
 			      struct res_counter **limit_fail_at)
 {
-	int ret, r;
-	unsigned long flags;
-	struct res_counter *c;
-
-	r = ret = 0;
-	*limit_fail_at = NULL;
-	local_irq_save(flags);
-	for (c = counter; c != NULL; c = c->parent) {
-		spin_lock(&c->lock);
-		r = res_counter_charge_locked(c, val);
-		if (r)
-			c->usage += val;
-		spin_unlock(&c->lock);
-		if (r < 0 && ret == 0) {
-			*limit_fail_at = c;
-			ret = r;
-		}
-	}
-	local_irq_restore(flags);
-
-	return ret;
+	return __res_counter_charge(counter, val, limit_fail_at, true);
 }
+
 void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val)
 {
 	if (WARN_ON(counter->usage < val))
-- 
1.7.5.4

