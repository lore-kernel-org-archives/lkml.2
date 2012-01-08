Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab2AHQ2J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 11:28:09 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35281 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab2AHQ2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 11:28:06 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.org>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v6 4/8] smp: add func to IPI cpus based on parameter func
Date: Sun,  8 Jan 2012 18:27:02 +0200
Message-Id: <1326040026-7285-5-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the on_each_cpu_cond() function that wraps on_each_cpu_mask()
and calculates the cpumask of cpus to IPI by calling a function supplied
as a parameter in order to determine whether to IPI each specific cpu.

The function works around allocation failure of cpumask variable in
CONFIG_CPUMASK_OFFSTACK=y by itereating over cpus sending an IPI a
time via smp_call_function_single().

The function is useful since it allows to seperate the specific
code that decided in each case whether to IPI a specific cpu for
a specific request from the common boilerplate code of handling
creating the mask, handling failures etc.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Chris Metcalf <cmetcalf@tilera.com>
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: linux-mm@kvack.org
CC: Pekka Enberg <penberg@kernel.org>
CC: Matt Mackall <mpm@selenic.com>
CC: Sasha Levin <levinsasha928@gmail.com>
CC: Rik van Riel <riel@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org
CC: Avi Kivity <avi@redhat.com>
CC: Michal Nazarewicz <mina86@mina86.org>
CC: Kosaki Motohiro <kosaki.motohiro@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/smp.h |   16 ++++++++++++++++
 kernel/smp.c        |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index a3a14d9..a37f388 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -109,6 +109,14 @@ void on_each_cpu_mask(const struct cpumask *mask, void (*func)(void *),
 		void *info, bool wait);
 
 /*
+ * Call a function on each processor for which the supplied function
+ * cond_func returns a positive value. This may include the local
+ * processor.
+ */
+void on_each_cpu_cond(int (*cond_func) (int cpu, void *info),
+		void (*func)(void *), void *info, bool wait);
+
+/*
  * Mark the boot cpu "online" so that it can call console drivers in
  * printk() and can access its per-cpu storage.
  */
@@ -153,6 +161,14 @@ static inline int up_smp_call_function(smp_call_func_t func, void *info)
 			local_irq_enable();		\
 		}					\
 	} while (0)
+#define on_each_cpu_cond(cond_func, func, info, wait) \
+	do {						\
+		if (cond_func(0, info)) {		\
+			local_irq_disable();		\
+			(func)(info);			\
+			local_irq_enable();		\
+		}					\
+	} while (0)
 
 static inline void smp_send_reschedule(int cpu) { }
 #define num_booting_cpus()			1
diff --git a/kernel/smp.c b/kernel/smp.c
index 7c0cbd7..bd8f4ad 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -721,3 +721,41 @@ void on_each_cpu_mask(const struct cpumask *mask, void (*func)(void *),
 	put_cpu();
 }
 EXPORT_SYMBOL(on_each_cpu_mask);
+
+/*
+ * Call a function on each processor for which the supplied function
+ * cond_func returns a positive value. This may include the local
+ * processor, optionally waiting for all the required CPUs to finish.
+ * All the limitations specified in smp_call_function_many apply.
+ */
+void on_each_cpu_cond(int (*cond_func) (int cpu, void *info),
+			void (*func)(void *), void *info, bool wait)
+{
+	cpumask_var_t cpus;
+	int cpu;
+
+	if (likely(zalloc_cpumask_var(&cpus, GFP_ATOMIC))) {
+		for_each_online_cpu(cpu)
+			if (cond_func(cpu, info))
+				cpumask_set_cpu(cpu, cpus);
+		on_each_cpu_mask(cpus, func, info, wait);
+		free_cpumask_var(cpus);
+	} else {
+		/*
+		 * No free cpumask, bother. No matter, we'll
+		 * just have to IPI them one by one.
+		 */
+		for_each_online_cpu(cpu)
+			if (cond_func(cpu, info))
+				/*
+				 * This call can fail if we ask it to IPI an
+				 * offline CPU, but this can be a valid
+				 * sceanrio here. Also, on_each_cpu_mask
+				 * ignores offlines CPUs. So, we ignore
+				 * the return value here.
+				 */
+				smp_call_function_single(cpu, func, info, wait);
+	}
+}
+EXPORT_SYMBOL(on_each_cpu_cond);
+
-- 
1.7.0.4

