Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab2KVUoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:44:39 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:49902 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab2KVUog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:44:36 -0500
Message-ID: <1353541455.20173.10.camel@jlt4.sipsolutions.net>
Subject: [POC] recoverable fault injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Thu, 22 Nov 2012 00:44:15 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This idea has been floating around in my head for a long time now ... 

I was thinking: what if we could do fault injection during regular
testing, at least on those code paths that are not supposed to have side
effects when they fail? Now obviously this isn't all code paths, and
many probably erroneously *do* have side effects even if they're not
supposed to, but it does apply to a number of code paths.

So I decided to play with this, and the result it the patch below. It
adds a new knob "recoverable-only" to the slab and page_alloc fault
attributes. If enabled, then a single fault can be injected if the task
executing it is in a "recoverable section", this is implemented by some
new fields in struct task_struct and the (very ugly!) macro
FAULT_INJECT_CALL_RECOVERABLE_FUNCTION.

Now obviously this isn't polished at all, etc. However, it seems to work
for the single function (a wireless API call) that I annotated, it has
various memory allocations in the call chain, and when any one of them
fails it doesn't seem to leak memory or crash etc. which is the point of
the testing.

Does it make any sense at all to invest more work on this and try to put
it into mainline? Maybe somebody tried something like this before and
decided it wasn't worth it, or maybe it didn't really work at all? Is
the task_struct usage completely broken? Any other thoughts?

johannes


diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
index c6f996f..1820a4b 100644
--- a/include/linux/fault-inject.h
+++ b/include/linux/fault-inject.h
@@ -7,6 +7,12 @@
 #include <linux/debugfs.h>
 #include <linux/atomic.h>
 
+enum fault_attr_id {
+	FAULT_ATTR_UNKNOWN,
+	FAULT_ATTR_SLAB,
+	FAULT_ATTR_PAGE_ALLOC,
+};
+
 /*
  * For explanation of the elements of this struct, see
  * Documentation/fault-injection/fault-injection.txt
@@ -18,6 +24,7 @@ struct fault_attr {
 	atomic_t space;
 	unsigned long verbose;
 	u32 task_filter;
+	u32 recoverable_only;
 	unsigned long stacktrace_depth;
 	unsigned long require_start;
 	unsigned long require_end;
@@ -25,16 +32,20 @@ struct fault_attr {
 	unsigned long reject_end;
 
 	unsigned long count;
+	enum fault_attr_id id;
 };
 
-#define FAULT_ATTR_INITIALIZER {				\
+#define FAULT_ATTR_ID_INITIALIZER(_id) {			\
 		.interval = 1,					\
 		.times = ATOMIC_INIT(1),			\
 		.require_end = ULONG_MAX,			\
 		.stacktrace_depth = 32,				\
 		.verbose = 2,					\
+		.id = FAULT_ATTR_ ## _id,			\
 	}
 
+#define FAULT_ATTR_INITIALIZER FAULT_ATTR_ID_INITIALIZER(UNKNOWN)
+
 #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
 int setup_fault_attr(struct fault_attr *attr, char *str);
 bool should_fail(struct fault_attr *attr, ssize_t size);
@@ -54,6 +65,23 @@ static inline struct dentry *fault_create_debugfs_attr(const char *name,
 
 #endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
 
+#define FAULT_INJECT_CALL_RECOVERABLE_FUNCTION(ids, fn, args...)\
+	({							\
+		int ___fi_ret;					\
+		current->failed_need_recovery = false;		\
+		current->fail_recoverable = (ids);		\
+		___fi_ret = fn(args);				\
+		current->fail_recoverable = 0;			\
+		if (current->failed_need_recovery && ___fi_ret)	\
+			___fi_ret = fn(args);			\
+		___fi_ret;					\
+	});
+
+#else /* CONFIG_FAULT_INJECTION */
+
+#define FAULT_INJECT_CALL_RECOVERABLE_FUNCTION(ids, fn, args...)\
+	fn(args);
+
 #endif /* CONFIG_FAULT_INJECTION */
 
 #ifdef CONFIG_FAILSLAB
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0dd42a0..6ee0069 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1492,7 +1492,9 @@ struct task_struct {
 	struct task_delay_info *delays;
 #endif
 #ifdef CONFIG_FAULT_INJECTION
-	int make_it_fail;
+	u8 fail_recoverable;
+	bool make_it_fail;
+	bool failed_need_recovery;
 #endif
 	/*
 	 * when (nr_dirtied >= nr_dirtied_pause), it's time to call
diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index f7210ad..63cde14 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -108,6 +108,10 @@ bool should_fail(struct fault_attr *attr, ssize_t size)
 	if (attr->task_filter && !fail_task(attr, current))
 		return false;
 
+	if (attr->recoverable_only &&
+	    (in_interrupt() || !(current->fail_recoverable & BIT(attr->id))))
+			return false;
+
 	if (atomic_read(&attr->times) == 0)
 		return false;
 
@@ -130,6 +134,11 @@ bool should_fail(struct fault_attr *attr, ssize_t size)
 
 	fail_dump(attr);
 
+	if (attr->recoverable_only) {
+		current->fail_recoverable = 0;
+		current->failed_need_recovery = true;
+	}
+
 	if (atomic_read(&attr->times) != -1)
 		atomic_dec_not_zero(&attr->times);
 
@@ -225,6 +234,10 @@ struct dentry *fault_create_debugfs_attr(const char *name,
 		goto fail;
 	if (!debugfs_create_bool("task-filter", mode, dir, &attr->task_filter))
 		goto fail;
+	if (attr->id != FAULT_ATTR_UNKNOWN &&
+	    !debugfs_create_bool("recoverable-only", mode, dir,
+				 &attr->recoverable_only))
+		goto fail;
 
 #ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
 
diff --git a/mm/failslab.c b/mm/failslab.c
index fefaaba..9cdfe2f 100644
--- a/mm/failslab.c
+++ b/mm/failslab.c
@@ -6,7 +6,7 @@ static struct {
 	u32 ignore_gfp_wait;
 	int cache_filter;
 } failslab = {
-	.attr = FAULT_ATTR_INITIALIZER,
+	.attr = FAULT_ATTR_ID_INITIALIZER(SLAB),
 	.ignore_gfp_wait = 1,
 	.cache_filter = 0,
 };
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bb90971..f3568fe 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1536,7 +1536,7 @@ static struct {
 	u32 ignore_gfp_wait;
 	u32 min_order;
 } fail_page_alloc = {
-	.attr = FAULT_ATTR_INITIALIZER,
+	.attr = FAULT_ATTR_ID_INITIALIZER(PAGE_ALLOC),
 	.ignore_gfp_wait = 1,
 	.ignore_gfp_highmem = 1,
 	.min_order = 1,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f0aaf5c..d74c604 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -15,6 +15,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/netlink.h>
 #include <linux/etherdevice.h>
+#include <linux/fault-inject.h>
 #include <net/net_namespace.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
@@ -6129,8 +6130,8 @@ static int nl80211_tdls_oper(struct sk_buff *skb, struct genl_info *info)
 	return rdev_tdls_oper(rdev, dev, peer, operation);
 }
 
-static int nl80211_remain_on_channel(struct sk_buff *skb,
-				     struct genl_info *info)
+static int _nl80211_remain_on_channel(struct sk_buff *skb,
+				      struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct wireless_dev *wdev = info->user_ptr[1];
@@ -6195,6 +6196,14 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 	return err;
 }
 
+static int nl80211_remain_on_channel(struct sk_buff *skb,
+				     struct genl_info *info)
+{
+	return FAULT_INJECT_CALL_RECOVERABLE_FUNCTION(
+		BIT(FAULT_ATTR_SLAB) | BIT(FAULT_ATTR_PAGE_ALLOC),
+		_nl80211_remain_on_channel, skb, info);
+}
+
 static int nl80211_cancel_remain_on_channel(struct sk_buff *skb,
 					    struct genl_info *info)
 {


