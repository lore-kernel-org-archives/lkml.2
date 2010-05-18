Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab0ERXga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 19:36:30 -0400
Received: from mga06.intel.com ([134.134.136.21]:58244 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752881Ab0ERXgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 19:36:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,258,1272870000"; 
   d="scan'208";a="519135844"
Subject: [PATCH 1/2] tmpfs: Quick token library to allow scalable retrieval
 of tokens from token jar
From: tim <tim.c.chen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 16:34:28 -0700
Message-ID: <1274225668.31973.8950.camel@mudge.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates a quick token (qtoken) library to maintain local
caches of tokens. This avoids lock contention when a token is
retrieved or returned to the token jar, and allows better scaling
on system with many cpus.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
 include/linux/qtoken.h |   40 ++++++++
 lib/Makefile           |    2 +-
 lib/qtoken.c           |  235 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 276 insertions(+), 1 deletions(-)

diff --git a/include/linux/qtoken.h b/include/linux/qtoken.h
new file mode 100644
index 0000000..a09bba9
--- /dev/null
+++ b/include/linux/qtoken.h
@@ -0,0 +1,40 @@
+/*
+ * qtoken.h: Structure and function prototypes to implement quick token
+ * retrieval from a jar of tokens with per cpu cache.
+ *
+ * Copyright (C) 2010 Intel Corporation
+ * Author: Tim Chen <tim.c.chen@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ *
+ */
+
+#ifndef _QTOKEN_H
+#define _QTOKEN_H
+
+#define QTOKEN_CACHE_HIGHMARK 2
+#define QTOKEN_POOL_HIGHMARK (2 * QTOKEN_CACHE_HIGHMARK)
+
+struct qtoken {
+	long		pool;	/* pool of free tokens */
+	long		total;  /* total num of tokens */
+#ifdef CONFIG_SMP
+	long		init_cache_sz; /* initial cache size */
+	spinlock_t	lock;	/* lock on token jar */
+	atomic_long_t __percpu *cache; /* per cpu cache of tokens */
+#endif
+};
+
+extern void qtoken_return(struct qtoken *token_jar, long tokens);
+extern int qtoken_get(struct qtoken *token_jar, long tkn, long reserve);
+extern int qtoken_init(struct qtoken *token_jar, long total_tokens,
+			long init_cache_sz);
+extern void qtoken_put(struct qtoken *token_jar);
+extern long qtoken_avail(struct qtoken *token_jar);
+extern int qtoken_resize(struct qtoken *token_jar, long new_total_tokens);
+extern long qtoken_total(struct qtoken *token_jar);
+
+#endif /* _QTOKEN_H */
diff --git a/lib/Makefile b/lib/Makefile
index 0d40152..1fa8945 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o flex_array.o
+	 is_single_threaded.o plist.o decompress.o flex_array.o qtoken.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff --git a/lib/qtoken.c b/lib/qtoken.c
new file mode 100644
index 0000000..9ab34f2
--- /dev/null
+++ b/lib/qtoken.c
@@ -0,0 +1,235 @@
+/*
+ * qtoken.c: Library of functions to implement quick token
+ * retrieval from a jar of tokens with per cpu cache.
+ *
+ * Copyright (C) 2010 Intel Corporation
+ * Author: Tim Chen <tim.c.chen@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/cpumask.h>
+#include <linux/qtoken.h>
+
+void qtoken_return(struct qtoken *token_jar, long tokens)
+{
+#ifdef CONFIG_SMP
+	long	cnt;
+	int	cpu;
+	atomic_long_t	*cache;
+
+	cpu = get_cpu();
+	cache = per_cpu_ptr(token_jar->cache, cpu);
+	cnt = atomic_long_read(cache);
+	if (cnt >= 0) {
+		if (likely((cnt+tokens) <=
+			QTOKEN_CACHE_HIGHMARK*token_jar->init_cache_sz)) {
+			/* Add freed tokens to local cache unless cache was
+			* reaped and disabled, return tokens to pool
+			* for that case
+			*/
+			if (!atomic_long_add_unless(
+			     cache, tokens, -1)) {
+				spin_lock(&token_jar->lock);
+				token_jar->pool += tokens;
+				spin_unlock(&token_jar->lock);
+			}
+		} else {
+			spin_lock(&token_jar->lock);
+			/* If cache has not been reaped and set to -1,
+			 * set cache to init cache size
+			 */
+			if (atomic_long_add_unless(
+				cache, token_jar->init_cache_sz-cnt, -1)) {
+				long excess = cnt + tokens -
+						token_jar->init_cache_sz;
+
+				token_jar->pool += excess;
+			} else
+				token_jar->pool += tokens;
+			spin_unlock(&token_jar->lock);
+		}
+	} else {
+		/* local cache reaped and disabled, */
+		/* return pages to global pool */
+		spin_lock(&token_jar->lock);
+		token_jar->pool += tokens;
+		spin_unlock(&token_jar->lock);
+	}
+	put_cpu();
+#else
+	token_jar->pool += tokens;
+#endif
+}
+EXPORT_SYMBOL(qtoken_return);
+
+#ifdef CONFIG_SMP
+static void qtoken_reap_cache(struct qtoken *token_jar)
+{
+	long	cnt;
+	int	i;
+
+	/* Need to have already acquired lock before here */
+	/* Reap cache into pool and disable local cache */
+	for_each_possible_cpu(i) {
+		atomic_long_t	*cache;
+
+		cache = per_cpu_ptr(token_jar->cache, i);
+		cnt = atomic_long_xchg(cache, -1);
+		if (cnt > 0)
+			token_jar->pool += cnt;
+	}
+}
+#endif
+
+static int qtoken_from_pool(struct qtoken *token_jar, unsigned tkn,
+				unsigned reserve)
+{
+	int	allocated = 0;
+
+#ifdef CONFIG_SMP
+	/* Need to have acquired lock of token pool before coming here */
+	if (token_jar->pool < (reserve+tkn))
+		qtoken_reap_cache(token_jar);
+#endif
+	if (token_jar->pool >= (reserve+tkn)) {
+		token_jar->pool -= tkn;
+		allocated = 1;
+	}
+	return allocated;
+}
+
+int qtoken_get(struct qtoken *token_jar, long tkn, long reserve)
+{
+	int	allocated = 0;
+#ifdef CONFIG_SMP
+	int	cpu;
+	long	cnt;
+	atomic_long_t	*cache;
+
+	if (tkn <= 0)
+		return 0;
+	cpu = get_cpu();
+	cache = per_cpu_ptr(token_jar->cache, cpu);
+	cnt = atomic_long_read(cache);
+	/* Need to reserve tokens after allocation */
+	if ((cnt > reserve) && (cnt >= tkn)) {
+		if (atomic_long_add_unless(cache, -tkn, -1))
+			allocated = 1;
+		else {
+			/* cache has been reaped, get token from pool */
+			spin_lock(&token_jar->lock);
+			allocated = qtoken_from_pool(token_jar, tkn, reserve);
+			spin_unlock(&token_jar->lock);
+		}
+	} else {
+		/* cache low, allocate from pool */
+		spin_lock(&token_jar->lock);
+		if ((token_jar->pool - tkn) > (QTOKEN_POOL_HIGHMARK *
+			token_jar->init_cache_sz * num_possible_cpus())) {
+			/* abundant tokens in pool */
+			/* allocate token and replenish cache */
+			token_jar->pool -= tkn;
+			allocated = tkn;
+			token_jar->pool -= token_jar->init_cache_sz;
+			cnt = atomic_long_read(cache);
+			if (cnt < 0)
+				cnt = token_jar->init_cache_sz;
+			else
+				cnt += token_jar->init_cache_sz;
+			atomic_long_set(cache, cnt);
+		} else
+			allocated = qtoken_from_pool(token_jar, tkn, reserve);
+		spin_unlock(&token_jar->lock);
+	}
+	put_cpu();
+#else
+	allocated = qtoken_from_pool(token_jar, tkn, reserve);
+#endif
+	return allocated;
+}
+EXPORT_SYMBOL(qtoken_get);
+
+int qtoken_init(struct qtoken *token_jar, long total_tokens, long cache_size)
+{
+#ifdef CONFIG_SMP
+	int	i;
+
+	token_jar->cache = alloc_percpu(atomic_long_t);
+	if (!token_jar->cache)
+		return 0;
+	spin_lock_init(&token_jar->lock);
+	for_each_possible_cpu(i) {
+		atomic_long_t	*cache;
+
+		cache = per_cpu_ptr(token_jar->cache, i);
+		atomic_long_set(cache, -1);
+	}
+	token_jar->init_cache_sz = cache_size;
+#endif
+	token_jar->total = token_jar->pool = total_tokens;
+	return 1;
+}
+EXPORT_SYMBOL(qtoken_init);
+
+void qtoken_put(struct qtoken *token_jar)
+{
+#ifdef CONFIG_SMP
+	if (token_jar->cache)
+		free_percpu(token_jar->cache);
+#endif
+	token_jar->pool = 0;
+	token_jar->total = 0;
+}
+EXPORT_SYMBOL(qtoken_put);
+
+/* This function should be called sparingly, it is
+ * expensive to get a total count of free tokens.
+ */
+long qtoken_avail(struct qtoken *token_jar)
+{
+	long	cnt;
+
+#ifdef CONFIG_SMP
+	spin_lock(&token_jar->lock);
+	qtoken_reap_cache(token_jar);
+	cnt = token_jar->pool;
+	spin_unlock(&token_jar->lock);
+#else
+	cnt = token_jar->pool;
+#endif
+	return cnt;
+}
+EXPORT_SYMBOL(qtoken_avail);
+
+int qtoken_resize(struct qtoken *token_jar, long new_total_tokens)
+{
+	long	in_use;
+
+#ifdef CONFIG_SMP
+	spin_lock(&token_jar->lock);
+	qtoken_reap_cache(token_jar);
+#endif
+	in_use = token_jar->total - token_jar->pool;
+	if (in_use > new_total_tokens)
+		return 0;
+	token_jar->total = new_total_tokens - in_use;
+#ifdef CONFIG_SMP
+	spin_unlock(&token_jar->lock);
+#endif
+	return 1;
+}
+EXPORT_SYMBOL(qtoken_resize);
+
+long qtoken_total(struct qtoken *token_jar)
+{
+	return token_jar->total;
+}
+EXPORT_SYMBOL(qtoken_total);


