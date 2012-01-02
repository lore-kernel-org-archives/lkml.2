Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab2ABKZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 05:25:36 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55270 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2ABKZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 05:25:13 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Sasha Levin <levinsasha928@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Subject: [PATCH v5 1/8] smp: Introduce a generic on_each_cpu_mask function
Date: Mon,  2 Jan 2012 12:24:12 +0200
Message-Id: <1325499859-2262-2-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1325499859-2262-1-git-send-email-gilad@benyossef.com>
References: <1325499859-2262-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on_each_cpu_mask calls a function on processors specified my cpumask,
which may include the local processor.

All the limitation specified in smp_call_function_many apply.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
CC: Chris Metcalf <cmetcalf@tilera.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: linux-mm@kvack.org
CC: Pekka Enberg <penberg@kernel.org>
CC: Matt Mackall <mpm@selenic.com>
CC: Rik van Riel <riel@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: Sasha Levin <levinsasha928@gmail.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org
CC: Avi Kivity <avi@redhat.com>
---
 include/linux/smp.h |   16 ++++++++++++++++
 kernel/smp.c        |   20 ++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 8cc38d3..60628d7 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -102,6 +102,13 @@ static inline void call_function_init(void) { }
 int on_each_cpu(smp_call_func_t func, void *info, int wait);
 
 /*
+ * Call a function on processors specified by mask, which might include
+ * the local one.
+ */
+void on_each_cpu_mask(const struct cpumask *mask, void (*func)(void *),
+		void *info, bool wait);
+
+/*
  * Mark the boot cpu "online" so that it can call console drivers in
  * printk() and can access its per-cpu storage.
  */
@@ -132,6 +139,15 @@ static inline int up_smp_call_function(smp_call_func_t func, void *info)
 		local_irq_enable();		\
 		0;				\
 	})
+#define on_each_cpu_mask(mask, func, info, wait) \
+	do {						\
+		if (cpumask_test_cpu(0, (mask))) {	\
+			local_irq_disable();		\
+			(func)(info);			\
+			local_irq_enable();		\
+		}					\
+	} while (0)
+
 static inline void smp_send_reschedule(int cpu) { }
 #define num_booting_cpus()			1
 #define smp_prepare_boot_cpu()			do {} while (0)
diff --git a/kernel/smp.c b/kernel/smp.c
index db197d6..7c0cbd7 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -701,3 +701,23 @@ int on_each_cpu(void (*func) (void *info), void *info, int wait)
 	return ret;
 }
 EXPORT_SYMBOL(on_each_cpu);
+
+/*
+ * Call a function on processors specified by cpumask, which may include
+ * the local processor. All the limitation specified in smp_call_function_many
+ * apply.
+ */
+void on_each_cpu_mask(const struct cpumask *mask, void (*func)(void *),
+			void *info, bool wait)
+{
+	int cpu = get_cpu();
+
+	smp_call_function_many(mask, func, info, wait);
+	if (cpumask_test_cpu(cpu, mask)) {
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
+	}
+	put_cpu();
+}
+EXPORT_SYMBOL(on_each_cpu_mask);
-- 
1.7.0.4

