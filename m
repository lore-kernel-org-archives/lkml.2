Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab2FAJLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:11:11 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:43309 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab2FAJLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:11:08 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 01/27] smpboot: Provide a generic method to boot secondary
 processors
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com
Cc: rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Date: Fri, 01 Jun 2012 14:40:18 +0530
Message-ID: <20120601091008.31979.93586.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12060109-2000-0000-0000-000007C51631
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>

The smp booting and cpu hotplug related code is heavily duplicated in various
architectures. To solve that problem, provide a generic framework to boot
secondary CPUs which can then be used by the architecture code.

For now, there is no functional change in the smp boot or hotplug sequence.
Just plain consolidation of common code from various architectures.

Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/smpboot.h |   10 ++++++
 kernel/smpboot.c        |   78 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/smpboot.h        |    4 +-
 3 files changed, 90 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/smpboot.h

diff --git a/include/linux/smpboot.h b/include/linux/smpboot.h
new file mode 100644
index 0000000..63bbedd
--- /dev/null
+++ b/include/linux/smpboot.h
@@ -0,0 +1,10 @@
+/*
+ * Generic SMP CPU booting framework
+ */
+
+#ifndef SMPBOOT_H
+#define SMPBOOT_H
+
+extern void smpboot_start_secondary(void *arg);
+
+#endif
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index 98f60c5..6c26133 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -6,6 +6,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/percpu.h>
+#include <linux/cpu.h>
 
 #include "smpboot.h"
 
@@ -65,3 +66,80 @@ void __init idle_threads_init(void)
 	}
 }
 #endif
+
+
+/* Implement the following functions in your architecture, as appropriate. */
+
+/**
+ * __cpu_pre_starting()
+ *
+ * Implement whatever you need to do before the CPU_STARTING notifiers are
+ * invoked. Note that the CPU_STARTING callbacks run *on* the cpu that is
+ * coming up. So that cpu better be prepared! IOW, implement all the early
+ * boot/init code for the cpu here. And do NOT enable interrupts.
+ */
+#ifndef __cpu_pre_starting
+void __weak __cpu_pre_starting(void *arg) {}
+#endif
+
+/**
+ *  __cpu_pre_online()
+ *
+ * Implement whatever you need to do before the upcoming CPU is set in the
+ * cpu_online_mask. (Setting the cpu in the cpu_online_mask is like an
+ * announcement that the cpu has come up, because it would be publicly
+ * visible now). Again, don't enable interrupts.
+ */
+#ifndef __cpu_pre_online
+void __weak __cpu_pre_online(void *arg) {}
+#endif
+
+/**
+ * __cpu_post_online()
+ *
+ * Implement whatever you need to do after the CPU has been set in the
+ * cpu_online_mask, and before enabling interrupts and calling cpu_idle().
+ * Ideally, it is preferable if you don't have anything to do here.
+ * We want to move to a model where setting cpu_online_mask is pretty
+ * much the final step. Again, don't enable interrupts.
+ */
+#ifndef __cpu_post_online
+void __weak __cpu_post_online(void *arg) {}
+#endif
+
+
+/**
+ * smpboot_start_secondary - Generic way to boot secondary processors
+ */
+void __cpuinit smpboot_start_secondary(void *arg)
+{
+	unsigned int cpu;
+
+	/*
+	 * SMP booting is extremely fragile in some architectures. So run
+	 * the cpu initialization code first before anything else.
+	 */
+	__cpu_pre_starting(arg);
+
+	preempt_disable();
+	cpu = smp_processor_id();
+
+	/* Invoke the CPU_STARTING notifier callbacks */
+	notify_cpu_starting(cpu);
+
+	__cpu_pre_online(arg);
+
+	/* Set the CPU in the cpu_online_mask */
+	set_cpu_online(cpu, true);
+
+	__cpu_post_online(arg);
+
+	/* Enable local interrupts now */
+	local_irq_enable();
+
+	wmb();
+	cpu_idle();
+
+	/* We should never reach here! */
+	BUG();
+}
diff --git a/kernel/smpboot.h b/kernel/smpboot.h
index 80c0acf..9753cc0 100644
--- a/kernel/smpboot.h
+++ b/kernel/smpboot.h
@@ -1,5 +1,5 @@
-#ifndef SMPBOOT_H
-#define SMPBOOT_H
+#ifndef __SMPBOOT_H
+#define __SMPBOOT_H
 
 struct task_struct;
 

