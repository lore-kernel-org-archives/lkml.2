Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab1CRDOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 23:14:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61480 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932120Ab1CRDOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 23:14:02 -0400
Message-ID: <4D82CE63.4030006@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 11:15:47 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
CC: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH V5 1/1] rcu: introduce kfree_rcu()
References: <4D7F356C.8020903@cn.fujitsu.com> <201103151302.09381.arnd@arndb.de> <20110315121941.GD2167@linux.vnet.ibm.com> <201103151407.24800.arnd@arndb.de> <20110316040203.GB2273@linux.vnet.ibm.com>
In-Reply-To: <20110316040203.GB2273@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:12:39,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:12:39,
	Serialize complete at 2011-03-18 11:12:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kfree_rcu() which was original proposed by Lai 2.5 years ago is one of
the most important RCU TODO list entries, Lai and Manfred have worked on
patches for this. This V4 patch is based on the Manfred's patch and
the V1 of Lai's patch. (These two patches are almost the same
in implementation, and this patch is mainly based on the Manfred's).

Lai's V1 patch: http://lkml.org/lkml/2008/9/18/1
Manfred's patch: http://lkml.org/lkml/2009/1/2/115
RCU TODO list: http://www.kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html

This new introduced API kfree_rcu() primitive kfree()s the specified memory
after a RCU grace period elapses.

It replaces many simple "call_rcu(head, simple_kfree_callback)";
These many simple_kfree_callback() instances just does

	kfree(containerof(head,struct whatever_struct,rcu_member));

These simple_kfree_callback() instances are just duplicate code, we need
a generic function for them.

And kfree_rcu() is also help for unloadable modules, kfree_rcu() does not
queue any function which belong to the module, so a rcu_barrier() can
be avoid when module exit. (If we queue any other function by call_rcu(),
rcu_barrier() is still needed.)

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 7d62909..e45ed82 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -777,4 +777,58 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 }
 #endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
+static __always_inline bool __is_kfree_rcu_offset(unsigned long offset)
+{
+	return offset < 4096;
+}
+
+static __always_inline
+void __kfree_rcu(struct rcu_head *head, unsigned long offset)
+{
+	typedef void (*rcu_callback)(struct rcu_head *);
+
+	BUILD_BUG_ON(!__builtin_constant_p(offset));
+
+	/* See the comments of kfree_rcu(), the "Note:" section. */
+	BUILD_BUG_ON(!__is_kfree_rcu_offset(offset));
+
+	call_rcu(head, (rcu_callback)offset);
+}
+
+extern void kfree(const void *);
+
+static inline void __rcu_reclaim(struct rcu_head *head)
+{
+	unsigned long offset = (unsigned long)head->func;
+
+	if (__is_kfree_rcu_offset(offset))
+		kfree((void *)head - offset);
+	else
+		head->func(head);
+}
+
+/**
+ * kfree_rcu() - kfree an object after a grace period.
+ * @ptr:	pointer to kfree
+ * @rcu_head:	the name of the struct rcu_head within the type of @ptr.
+ *
+ * Many rcu callbacks just call kfree() on the base structure. This helper
+ * function calls kfree internally. The rcu_head structure must be embedded
+ * in the to be freed structure.
+ *
+ * It is different from call_rcu(), kfree_rcu() does not require nor create
+ * any local RCU callback functions belong to its module. So the caller
+ * does not need to wait the callback to complete when the caller want to
+ * unload the module.
+ *
+ * Note: if the offset of the struct rcu_head within the type of @ptr
+ * is larger than 4096, it will trigger a BUILD_BUG_ON() compile-time
+ * error in __kfree_rcu(), the user of kfree_rcu() should rerange the
+ * fields of the type of @ptr to make the offset smaller or use call_rcu()
+ * instead or require the RCU maintainer changing the limit
+ * in this situation.
+ */
+#define kfree_rcu(ptr, rcu_head)					\
+	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
+
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 0c343b9..4d60fbc 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -167,7 +167,7 @@ static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 		prefetch(next);
 		debug_rcu_head_unqueue(list);
 		local_bh_disable();
-		list->func(list);
+		__rcu_reclaim(list);
 		local_bh_enable();
 		list = next;
 		RCU_TRACE(cb_count++);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index dd4aea8..b3c1aed 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1143,7 +1143,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 		next = list->next;
 		prefetch(next);
 		debug_rcu_head_unqueue(list);
-		list->func(list);
+		__rcu_reclaim(list);
 		list = next;
 		if (++count >= rdp->blimit)
 			break;
