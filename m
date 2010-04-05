Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab0DEKib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 06:38:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65250 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab0DEKi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 06:38:26 -0400
Message-ID: <4BB9BD86.4030802@cn.fujitsu.com>
Date: Mon, 05 Apr 2010 18:37:58 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, Gautham R Shenoy <ego@in.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nathan Fontenot <nfont@austin.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
       Sachin Sant <sachinp@in.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Shane Wang <shane.wang@intel.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] cpuhotplug: do not need cpu_hotplug_begin() when CONFIG_HOTPLUG_CPU=n
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since when CONFIG_HOTPLUG_CPU=n, get_online_cpus() do nothing,
so we don't need cpu_hotplug_begin() either.

This patch moves cpu_hotplug_begin()/cpu_hotplug_done()
into the code block of CONFIG_HOTPLUG_CPU=y.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 8d340fa..bc1e3d5 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -19,6 +19,20 @@
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
 static DEFINE_MUTEX(cpu_add_remove_lock);
 
+/*
+ * The following two API's must be used when attempting
+ * to serialize the updates to cpu_online_mask, cpu_present_mask.
+ */
+void cpu_maps_update_begin(void)
+{
+	mutex_lock(&cpu_add_remove_lock);
+}
+
+void cpu_maps_update_done(void)
+{
+	mutex_unlock(&cpu_add_remove_lock);
+}
+
 static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
 
 /* If set, cpu_up and cpu_down will return -EBUSY and do nothing.
@@ -26,6 +40,8 @@ static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
  */
 static int cpu_hotplug_disabled;
 
+#ifdef CONFIG_HOTPLUG_CPU
+
 static struct {
 	struct task_struct *active_writer;
 	struct mutex lock; /* Synchronizes accesses to refcount, */
@@ -40,8 +56,6 @@ static struct {
 	.refcount = 0,
 };
 
-#ifdef CONFIG_HOTPLUG_CPU
-
 void get_online_cpus(void)
 {
 	might_sleep();
@@ -66,22 +80,6 @@ void put_online_cpus(void)
 }
 EXPORT_SYMBOL_GPL(put_online_cpus);
 
-#endif	/* CONFIG_HOTPLUG_CPU */
-
-/*
- * The following two API's must be used when attempting
- * to serialize the updates to cpu_online_mask, cpu_present_mask.
- */
-void cpu_maps_update_begin(void)
-{
-	mutex_lock(&cpu_add_remove_lock);
-}
-
-void cpu_maps_update_done(void)
-{
-	mutex_unlock(&cpu_add_remove_lock);
-}
-
 /*
  * This ensures that the hotplug operation can begin only when the
  * refcount goes to zero.
@@ -123,6 +121,12 @@ static void cpu_hotplug_done(void)
 	cpu_hotplug.active_writer = NULL;
 	mutex_unlock(&cpu_hotplug.lock);
 }
+
+#else /* #if CONFIG_HOTPLUG_CPU */
+static void cpu_hotplug_begin(void) {}
+static void cpu_hotplug_done(void) {}
+#endif	/* #esle #if CONFIG_HOTPLUG_CPU */
+
 /* Need to know about CPUs going up/down? */
 int __ref register_cpu_notifier(struct notifier_block *nb)
 {

