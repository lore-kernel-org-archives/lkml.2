Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab2DWQoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:44:12 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56829 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2DWQnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:43:13 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        Jan Engelhardt <jengelh@medozas.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 5/6] rcu: Make __kfree_rcu() less dependent on compiler choices
Date: Mon, 23 Apr 2012 09:42:26 -0700
Message-Id: <1335199347-13926-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120423164159.GA13819@linux.vnet.ibm.com>
 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042316-6148-0000-0000-000005413E39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@medozas.de>

Currently, __kfree_rcu() is implemented as an inline function, and
contains a BUILD_BUG_ON() that malfunctions if __kfree_rcu() is compiled
as an out-of-line function.  Unfortunately, there are compiler settings
(e.g., -O0) that can result in __kfree_rcu() being compiled out of line,
resulting in annoying build breakage.  This commit therefore converts
both __kfree_rcu() and __is_kfree_rcu_offset() from inline functions to
macros to prevent such misbehavior on the part of the compiler.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/rcupdate.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 20fb776..d5dfb10 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -922,6 +922,21 @@ void __kfree_rcu(struct rcu_head *head, unsigned long offset)
 	kfree_call_rcu(head, (rcu_callback)offset);
 }
 
+/*
+ * Does the specified offset indicate that the corresponding rcu_head
+ * structure can be handled by kfree_rcu()?
+ */
+#define __is_kfree_rcu_offset(offset) ((offset) < 4096)
+
+/*
+ * Helper macro for kfree_rcu() to prevent argument-expansion eyestrain.
+ */
+#define __kfree_rcu(head, offset) \
+	do { \
+		BUILD_BUG_ON(!__is_kfree_rcu_offset(offset)); \
+		call_rcu(head, (void (*)(struct rcu_head *))(unsigned long)(offset)); \
+	} while (0)
+
 /**
  * kfree_rcu() - kfree an object after a grace period.
  * @ptr:	pointer to kfree
@@ -944,6 +959,9 @@ void __kfree_rcu(struct rcu_head *head, unsigned long offset)
  *
  * Note that the allowable offset might decrease in the future, for example,
  * to allow something like kmem_cache_free_rcu().
+ *
+ * The BUILD_BUG_ON check must not involve any function calls, hence the
+ * checks are done in macros here.
  */
 #define kfree_rcu(ptr, rcu_head)					\
 	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
-- 
1.7.8

