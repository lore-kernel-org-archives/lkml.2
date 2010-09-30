Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab0I3T2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 15:28:01 -0400
Received: from 87-119-183-111.tll.elisa.ee ([87.119.183.111]:3955 "EHLO
	bazspaz.fatphil.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756305Ab0I3T16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 15:27:58 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: arjan@linux.intel.com, tglx@linutronix.de
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
        Artem.Bityutskiy@nokia.com
Subject: [PATCH 1/1] timer: permit statically-declared work with deferrable timers
Date: Thu, 30 Sep 2010 22:26:29 +0300
Message-Id: <1285874789-1481-2-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
In-Reply-To: <1285874789-1481-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1285874789-1481-1-git-send-email-ext-phil.2.carmody@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, you have to just define a delayed_work uninitialised, and then
initialise it before first use. That's a tad clumsy. At risk of playing
mind-games with the compiler, fooling it into doing pointer arithmetic
with compile-time-constants, this lets clients properly initialise delayed
work with deferrable timers statically.

This patch was inspired by the issues which lead Artem Bityutskiy
to commit 8eab945c5616fc984e97b922d6a2559be93f39a1.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 include/linux/timer.h     |   25 +++++++++++++++++++++++++
 include/linux/workqueue.h |    8 ++++++++
 kernel/timer.c            |   15 +--------------
 3 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 38cf093..2fb272c 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -48,6 +48,18 @@ extern struct tvec_base boot_tvec_bases;
 #define __TIMER_LOCKDEP_MAP_INITIALIZER(_kn)
 #endif
 
+/*
+ * Note that all tvec_bases are 2 byte aligned and lower bit of
+ * base in timer_list is guaranteed to be zero. Use the LSB to
+ * indicate whether the timer is deferrable.
+ *
+ * A deferrable timer will work normally when the system is busy, but
+ * will not cause a CPU to come out of idle just to service it; instead,
+ * the timer will be serviced when the CPU eventually wakes up with a
+ * subsequent non-deferrable timer.
+ */
+#define TBASE_DEFERRABLE_FLAG		(0x1)
+
 #define TIMER_INITIALIZER(_function, _expires, _data) {		\
 		.entry = { .prev = TIMER_ENTRY_STATIC },	\
 		.function = (_function),			\
@@ -58,6 +70,19 @@ extern struct tvec_base boot_tvec_bases;
 			__FILE__ ":" __stringify(__LINE__))	\
 	}
 
+#define TBASE_MAKE_DEFERRED(ptr) ((struct tvec_base *)		\
+		  ((unsigned char *)(ptr) + TBASE_DEFERRABLE_FLAG))
+
+#define TIMER_DEFERRED_INITIALIZER(_function, _expires, _data) {\
+		.entry = { .prev = TIMER_ENTRY_STATIC },	\
+		.function = (_function),			\
+		.expires = (_expires),				\
+		.data = (_data),				\
+		.base = TBASE_MAKE_DEFERRED(&boot_tvec_bases),	\
+		__TIMER_LOCKDEP_MAP_INITIALIZER(		\
+			__FILE__ ":" __stringify(__LINE__))	\
+	}
+
 #define DEFINE_TIMER(_name, _function, _expires, _data)		\
 	struct timer_list _name =				\
 		TIMER_INITIALIZER(_function, _expires, _data)
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 25e02c9..076d5a7 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -127,12 +127,20 @@ struct execute_work {
 	.timer = TIMER_INITIALIZER(NULL, 0, 0),			\
 	}
 
+#define __DEFERRED_WORK_INITIALIZER(n, f) {			\
+	.work = __WORK_INITIALIZER((n).work, (f)),		\
+	.timer = TIMER_DEFERRED_INITIALIZER(NULL, 0, 0),	\
+	}
+
 #define DECLARE_WORK(n, f)					\
 	struct work_struct n = __WORK_INITIALIZER(n, f)
 
 #define DECLARE_DELAYED_WORK(n, f)				\
 	struct delayed_work n = __DELAYED_WORK_INITIALIZER(n, f)
 
+#define DECLARE_DEFERRED_WORK(n, f)				\
+	struct delayed_work n = __DEFERRED_WORK_INITIALIZER(n, f)
+
 /*
  * initialize a work item's function pointer
  */
diff --git a/kernel/timer.c b/kernel/timer.c
index 97bf05b..72853b2 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -88,18 +88,6 @@ struct tvec_base boot_tvec_bases;
 EXPORT_SYMBOL(boot_tvec_bases);
 static DEFINE_PER_CPU(struct tvec_base *, tvec_bases) = &boot_tvec_bases;
 
-/*
- * Note that all tvec_bases are 2 byte aligned and lower bit of
- * base in timer_list is guaranteed to be zero. Use the LSB to
- * indicate whether the timer is deferrable.
- *
- * A deferrable timer will work normally when the system is busy, but
- * will not cause a CPU to come out of idle just to service it; instead,
- * the timer will be serviced when the CPU eventually wakes up with a
- * subsequent non-deferrable timer.
- */
-#define TBASE_DEFERRABLE_FLAG		(0x1)
-
 /* Functions below help us manage 'deferrable' flag */
 static inline unsigned int tbase_get_deferrable(struct tvec_base *base)
 {
@@ -113,8 +101,7 @@ static inline struct tvec_base *tbase_get_base(struct tvec_base *base)
 
 static inline void timer_set_deferrable(struct timer_list *timer)
 {
-	timer->base = ((struct tvec_base *)((unsigned long)(timer->base) |
-				       TBASE_DEFERRABLE_FLAG));
+	timer->base = TBASE_MAKE_DEFERRED(timer->base);
 }
 
 static inline void
-- 
1.7.2.rc1.37.gf8c40

