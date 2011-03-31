Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965153Ab1CaTEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 15:04:53 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58680 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759142Ab1CaTEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 15:04:52 -0400
Date: Thu, 31 Mar 2011 12:04:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        James Morris <jmorris@namei.org>, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 31/36] security,rcu: convert
 call_rcu(user_update_rcu_disposal) to kfree_rcu()
Message-ID: <20110331190428.GI2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D82DB5B.9000302@cn.fujitsu.com>
 <16158.1301597440@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16158.1301597440@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 07:50:40PM +0100, David Howells wrote:
> Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
> > The rcu callback user_update_rcu_disposal() just calls a kfree(),
> > so we use kfree_rcu() instead of the call_rcu(user_update_rcu_disposal).
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Nice idea, but how do you handle the container_of()?

Hello, David,

This patch relies on an earlier patch from Lai shown below.

The short answer is that kfree_rcu() is a cpp macro that takes a pointer
to the struct rcu_head and the name of the rcu_head field within the
enclosing structure.  This macro then does the required offset_of().

							Thanx, Paul

------------------------------------------------------------------------

commit 316b740440ea0a54615a3516df536fbf9a4c11b8
Author: Lai Jiangshan <laijs@cn.fujitsu.com>
Date:   Fri Mar 18 11:15:47 2011 +0800

    rcu: introduce kfree_rcu()
    
    Many rcu callbacks functions just call kfree() on the base structure.
    These functions are trivial, but their size adds up, and furthermore
    when they are used in a kernel module, that module must invoke the
    high-latency rcu_barrier() function at module-unload time.
    
    The kfree_rcu() function introduced by this commit addresses this issue.
    Rather than encoding a function address in the embedded rcu_head
    structure, kfree_rcu() instead encodes the offset of the rcu_head
    structure within the base structure.  Because the functions are not
    allowed in the low-order 4096 bytes of kernel virtual memory, offsets
    up to 4095 bytes can be accommodated.  If the offset is larger than
    4095 bytes, a compile-time error will be generated in __kfree_rcu().
    If this error is triggered, you can either fall back to use of call_rcu()
    or rearrange the structure to position the rcu_head structure into the
    first 4096 bytes.
    
    Note that the allowable offset might decrease in the future, for example,
    to allow something like kmem_cache_free_rcu().
    
    The new kfree_rcu() function can replace code as follows:
    
    	call_rcu(&p->rcu, simple_kfree_callback);
    
    where "simple_kfree_callback()" might be defined as follows:
    
    	void simple_kfree_callback(struct rcu_head *p)
    	{
    		struct foo *q = container_of(p, struct foo, rcu);
    
    		kfree(q);
    	}
    
    with the following:
    
    	kfree_rcu(&p->rcu, rcu);
    
    Note that the "rcu" is the name of a field in the structure being
    freed.  The reason for using this rather than passing in a pointer
    to the base structure is that the above approach allows better type
    checking.
    
    This commit is based on earlier work by Lai Jiangshan and Manfred Spraul:
    
    Lai's V1 patch: http://lkml.org/lkml/2008/9/18/1
    Manfred's patch: http://lkml.org/lkml/2009/1/2/115
    
    Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
    Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index af56148..70c932f 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -777,4 +777,60 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
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
+	/* See the kfree_rcu() header comment. */
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
+ * Many rcu callbacks functions just call kfree() on the base structure.
+ * These functions are trivial, but their size adds up, and furthermore
+ * when they are used in a kernel module, that module must invoke the
+ * high-latency rcu_barrier() function at module-unload time.
+ *
+ * The kfree_rcu() function handles this issue.  Rather than encoding a
+ * function address in the embedded rcu_head structure, kfree_rcu() instead
+ * encodes the offset of the rcu_head structure within the base structure.
+ * Because the functions are not allowed in the low-order 4096 bytes of
+ * kernel virtual memory, offsets up to 4095 bytes can be accommodated.
+ * If the offset is larger than 4095 bytes, a compile-time error will
+ * be generated in __kfree_rcu().  If this error is triggered, you can
+ * either fall back to use of call_rcu() or rearrange the structure to
+ * position the rcu_head structure into the first 4096 bytes.
+ *
+ * Note that the allowable offset might decrease in the future, for example,
+ * to allow something like kmem_cache_free_rcu().
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
index 89e7dbb..4e1d925 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1161,7 +1161,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 		next = list->next;
 		prefetch(next);
 		debug_rcu_head_unqueue(list);
-		list->func(list);
+		__rcu_reclaim(list);
 		list = next;
 		if (++count >= rdp->blimit)
 			break;
