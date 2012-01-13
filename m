Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab2AMP40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:56:26 -0500
Received: from mga14.intel.com ([143.182.124.37]:1497 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675Ab2AMPzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:55:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95530539"
From: Alex Shi <alex.shi@intel.com>
To: linux-kernel@vger.kernel.org, cl@gentwo.org, eric.dumazet@gmail.com,
        tglx@linutronix.de, avi@redhat.com, akpm@linux-foundation.org,
        davem@davemloft.net, kaber@trash.net, a.p.zijlstra@chello.nl,
        ying.huang@intel.com, konrad.wilk@oracle.com, hpa@zytor.com,
        jeremy@goop.org
Subject: [PATCH v2 4/5] x86: change percpu_read_stable to this_cpu_read_stable
Date: Fri, 13 Jan 2012 23:53:37 +0800
Message-Id: <1326470018-22342-5-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1326470018-22342-4-git-send-email-alex.shi@intel.com>
References: <1326470018-22342-1-git-send-email-alex.shi@intel.com>
 <1326470018-22342-2-git-send-email-alex.shi@intel.com>
 <1326470018-22342-3-git-send-email-alex.shi@intel.com>
 <1326470018-22342-4-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has no function change. It's a preparation for percpu_xxx serial
function change.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Acked-by: Christoph Lameter <cl@gentwo.org>
Acked-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/current.h     |    2 +-
 arch/x86/include/asm/percpu.h      |    6 +++---
 arch/x86/include/asm/thread_info.h |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/current.h b/arch/x86/include/asm/current.h
index 4d447b7..9476c04 100644
--- a/arch/x86/include/asm/current.h
+++ b/arch/x86/include/asm/current.h
@@ -11,7 +11,7 @@ DECLARE_PER_CPU(struct task_struct *, current_task);
 
 static __always_inline struct task_struct *get_current(void)
 {
-	return percpu_read_stable(current_task);
+	return this_cpu_read_stable(current_task);
 }
 
 #define current get_current()
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 276bbc0..8d256ad 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -352,15 +352,15 @@ do {									\
 
 /*
  * percpu_read() makes gcc load the percpu variable every time it is
- * accessed while percpu_read_stable() allows the value to be cached.
- * percpu_read_stable() is more efficient and can be used if its value
+ * accessed while this_cpu_read_stable() allows the value to be cached.
+ * this_cpu_read_stable() is more efficient and can be used if its value
  * is guaranteed to be valid across cpus.  The current users include
  * get_current() and get_thread_info() both of which are actually
  * per-thread variables implemented as per-cpu variables and thus
  * stable for the duration of the respective task.
  */
 #define percpu_read(var)		percpu_from_op("mov", var, "m" (var))
-#define percpu_read_stable(var)		percpu_from_op("mov", var, "p" (&(var)))
+#define this_cpu_read_stable(var)	percpu_from_op("mov", var, "p" (&(var)))
 #define percpu_write(var, val)		percpu_to_op("mov", var, val)
 #define percpu_add(var, val)		percpu_add_op(var, val)
 #define percpu_sub(var, val)		percpu_add_op(var, -(val))
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index bc817cd..3544992 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -218,7 +218,7 @@ DECLARE_PER_CPU(unsigned long, kernel_stack);
 static inline struct thread_info *current_thread_info(void)
 {
 	struct thread_info *ti;
-	ti = (void *)(percpu_read_stable(kernel_stack) +
+	ti = (void *)(this_cpu_read_stable(kernel_stack) +
 		      KERNEL_STACK_OFFSET - THREAD_SIZE);
 	return ti;
 }
-- 
1.6.3.3

