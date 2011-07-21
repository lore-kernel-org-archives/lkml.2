Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab1GUHi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 03:38:28 -0400
Received: from ozlabs.org ([203.10.76.45]:39530 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab1GUHiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 03:38:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jonathan Cameron <jic23@cam.ac.uk>, Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: Boiler plate functions for ida / idr allocation?
In-Reply-To: <4E1DA232.30408@cam.ac.uk>
References: <4E1D6900.6040500@cam.ac.uk> <20110713133139.GO2872@htj.dyndns.org> <4E1DA232.30408@cam.ac.uk>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 21 Jul 2011 17:07:36 +0930
Message-ID: <878vrs2if3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 14:48:34 +0100, Jonathan Cameron <jic23@cam.ac.uk> wrote:
> > Here's an interface that I think should work,
> > 
> > 	int ida_get(struct ida *ida, int begin, int end, gfp_t gfp);
> > 
> > It uses an internal spinlock, returns the allocated ID and @end <= 0
> > indicates no limit.
> Cool.
> 
> Rusty, are you pursuing this?  Approach looks sensible to me.

Yep, here's my latest version.  Feel free to run with it, or not.

Thanks!
Rusty.

From: Rusty Russell <rusty@rustcorp.com.au>
Subject: ida: Simplified functions for id allocation.

The current hyper-optimized functions are overkill if you simply want
to allocate an id for a device.  Create versions which use an internal
lock.

Thanks to Tejun for feedback.  Feel free to delete the #ifdef TEST
code.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/idr.h |    4 +
 lib/idr.c           |  116 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 120 insertions(+)

diff --git a/include/linux/idr.h b/include/linux/idr.h
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -146,6 +146,10 @@ void ida_remove(struct ida *ida, int id)
 void ida_destroy(struct ida *ida);
 void ida_init(struct ida *ida);
 
+int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
+		   gfp_t gfp_mask);
+void ida_simple_remove(struct ida *ida, unsigned int id);
+
 void __init idr_init_cache(void);
 
 #endif /* __IDR_H__ */
diff --git a/lib/idr.c b/lib/idr.c
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -34,8 +34,10 @@
 #include <linux/err.h>
 #include <linux/string.h>
 #include <linux/idr.h>
+#include <linux/spinlock.h>
 
 static struct kmem_cache *idr_layer_cache;
+static DEFINE_SPINLOCK(simple_ida);
 
 static struct idr_layer *get_from_free_list(struct idr *idp)
 {
@@ -926,6 +928,120 @@ void ida_destroy(struct ida *ida)
 EXPORT_SYMBOL(ida_destroy);
 
 /**
+ * ida_simple_get - get a new id.
+ * @ida: the (initialized) ida.
+ * @start: the minimum id (inclusive, < 0x8000000)
+ * @end: the maximum id (exclusive, < 0x8000000 or 0)
+ * @gfp_mask: memory allocation flags
+ *
+ * Allocates an id in the range start <= id < end, or returns -ENOSPC.
+ * On memory allocation failure, returns -ENOMEM.
+ *
+ * Use ida_simple_remove() to get rid of an id.
+ */
+int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
+		   gfp_t gfp_mask)
+{
+	int ret, id;
+	unsigned int max;
+
+	BUG_ON((int)start < 0);
+	BUG_ON((int)end < 0);
+
+	if (end == 0)
+		max = 0x80000000;
+	else {
+		BUG_ON(end < start);
+		max = end - 1;
+	}
+
+again:
+	if (!ida_pre_get(ida, gfp_mask))
+		return -ENOMEM;
+
+	spin_lock(&simple_ida);
+	ret = ida_get_new_above(ida, start, &id);
+	if (!ret) {
+		if (id > max) {
+			ida_remove(ida, id);
+			ret = -ENOSPC;
+		} else {
+			ret = id;
+		}
+	}
+	spin_unlock(&simple_ida);
+
+	if (unlikely(ret == -EAGAIN))
+		goto again;
+
+	return ret;
+}
+EXPORT_SYMBOL(ida_simple_get);
+
+/**
+ * ida_simple_remove - remove an allocated id.
+ * @ida: the (initialized) ida.
+ * @id: the id returned by ida_simple_get.
+ */
+void ida_simple_remove(struct ida *ida, unsigned int id)
+{
+	BUG_ON((int)id < 0);
+	spin_lock(&simple_ida);
+	ida_remove(ida, id);
+	spin_unlock(&simple_ida);
+}
+EXPORT_SYMBOL(ida_simple_remove);
+
+#ifdef TEST
+static int test_ida_simple(void)
+{
+	int i;
+	DEFINE_IDA(ida);
+
+	/* Simple range 0..0. */
+	i = ida_simple_get(&ida, 0, 1, GFP_KERNEL);
+	BUG_ON(i != 0);
+	i = ida_simple_get(&ida, 0, 1, GFP_KERNEL);
+	BUG_ON(i != -ENOSPC);
+	ida_simple_remove(&ida, 0);
+	i = ida_simple_get(&ida, 0, 1, GFP_KERNEL);
+	BUG_ON(i != 0);
+
+	/* Empty range. */
+	i = ida_simple_get(&ida, 0x7FFFFFFE, 0x7FFFFFFE, GFP_KERNEL);
+	BUG_ON(i != -ENOSPC);
+
+	/* Top of range. */
+	i = ida_simple_get(&ida, 0x7FFFFFFE, 0x7FFFFFFF, GFP_KERNEL);
+	BUG_ON(i != 0x7FFFFFFE);
+	i = ida_simple_get(&ida, 0x7FFFFFFE, 0x7FFFFFFF, GFP_KERNEL);
+	BUG_ON(i != -ENOSPC);
+	ida_simple_remove(&ida, 0x7FFFFFFE);
+
+	/* End of range testing. */
+	i = ida_simple_get(&ida, 0x7FFFFFFE, 0, GFP_KERNEL);
+	BUG_ON(i != 0x7FFFFFFE);
+
+	i = ida_simple_get(&ida, 0x7FFFFFFE, 0, GFP_KERNEL);
+	BUG_ON(i != 0x7FFFFFFF);
+
+	i = ida_simple_get(&ida, 0x7FFFFFFE, 0, GFP_KERNEL);
+	BUG_ON(i != -ENOSPC);
+
+	/* Remove works. */
+	i = ida_simple_get(&ida, 0x7FFFFFFD, 0, GFP_KERNEL);
+	BUG_ON(i != 0x7FFFFFFD);
+
+	ida_simple_remove(&ida, 0x7FFFFFFE);
+	i = ida_simple_get(&ida, 0x7FFFFFFD, 0, GFP_KERNEL);
+	BUG_ON(i != 0x7FFFFFFE);
+
+	ida_destroy(&ida);
+	return 0;
+}
+#endif
+
+/**
  * ida_init - initialize ida handle
  * @ida:	ida handle
  *
