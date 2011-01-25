Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab1AYWSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:18:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61112 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab1AYWSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:18:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 17/20] tracing: don't trace the BKL
Date: Tue, 25 Jan 2011 23:17:31 +0100
Message-Id: <1295993854-4971-18-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295993854-4971-1-git-send-email-arnd@arndb.de>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:xcEXSpRXa8FbTpsLPnl8Kg2+Ca8/BPQ3D8gsjorcTr7
 eIf0uAaROHTBwnuQOcYbbEBI7iHWn/k+DFokkOGTG4CuCa86W9
 kj6+LonOFxFQLlQN4BvPk/xxri5GuAEW3ZY62M40BHR/CgtwmU
 iqraHaqiwz+NK7l6ejRcofqYyhYit8KFEpBAGuGRQ3wAPIkvQz
 LMQc5UiUhrinf+aBKyuYg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No reason to trace it when the last user is gone.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/events/bkl.h |   61 --------------------------------------------
 lib/kernel_lock.c          |    7 -----
 2 files changed, 0 insertions(+), 68 deletions(-)
 delete mode 100644 include/trace/events/bkl.h

diff --git a/include/trace/events/bkl.h b/include/trace/events/bkl.h
deleted file mode 100644
index 1af72dc..0000000
--- a/include/trace/events/bkl.h
+++ /dev/null
@@ -1,61 +0,0 @@
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM bkl
-
-#if !defined(_TRACE_BKL_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_BKL_H
-
-#include <linux/tracepoint.h>
-
-TRACE_EVENT(lock_kernel,
-
-	TP_PROTO(const char *func, const char *file, int line),
-
-	TP_ARGS(func, file, line),
-
-	TP_STRUCT__entry(
-		__field(	int,		depth			)
-		__field_ext(	const char *,	func, FILTER_PTR_STRING	)
-		__field_ext(	const char *,	file, FILTER_PTR_STRING	)
-		__field(	int,		line			)
-	),
-
-	TP_fast_assign(
-		/* We want to record the lock_depth after lock is acquired */
-		__entry->depth = current->lock_depth + 1;
-		__entry->func = func;
-		__entry->file = file;
-		__entry->line = line;
-	),
-
-	TP_printk("depth=%d file:line=%s:%d func=%s()", __entry->depth,
-		  __entry->file, __entry->line, __entry->func)
-);
-
-TRACE_EVENT(unlock_kernel,
-
-	TP_PROTO(const char *func, const char *file, int line),
-
-	TP_ARGS(func, file, line),
-
-	TP_STRUCT__entry(
-		__field(int,		depth		)
-		__field(const char *,	func		)
-		__field(const char *,	file		)
-		__field(int,		line		)
-	),
-
-	TP_fast_assign(
-		__entry->depth = current->lock_depth;
-		__entry->func = func;
-		__entry->file = file;
-		__entry->line = line;
-	),
-
-	TP_printk("depth=%d file:line=%s:%d func=%s()", __entry->depth,
-		  __entry->file, __entry->line, __entry->func)
-);
-
-#endif /* _TRACE_BKL_H */
-
-/* This part must be outside protection */
-#include <trace/define_trace.h>
diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
index b135d04..d80e122 100644
--- a/lib/kernel_lock.c
+++ b/lib/kernel_lock.c
@@ -10,9 +10,6 @@
 #include <linux/semaphore.h>
 #include <linux/smp_lock.h>
 
-#define CREATE_TRACE_POINTS
-#include <trace/events/bkl.h>
-
 /*
  * The 'big kernel lock'
  *
@@ -120,8 +117,6 @@ void __lockfunc _lock_kernel(const char *func, const char *file, int line)
 {
 	int depth = current->lock_depth + 1;
 
-	trace_lock_kernel(func, file, line);
-
 	if (likely(!depth)) {
 		might_sleep();
 		__lock_kernel();
@@ -134,8 +129,6 @@ void __lockfunc _unlock_kernel(const char *func, const char *file, int line)
 	BUG_ON(current->lock_depth < 0);
 	if (likely(--current->lock_depth < 0))
 		__unlock_kernel();
-
-	trace_unlock_kernel(func, file, line);
 }
 
 EXPORT_SYMBOL(_lock_kernel);
-- 
1.7.1

