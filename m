Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab0CRJHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:07:33 -0400
Received: from mail-yw0-f201.google.com ([209.85.211.201]:59673 "EHLO
	mail-yw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab0CRJHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:07:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KjDBWgvwiVDLHvkrdBmEeIgQEixRkWIPSZztBxSUXVEeaSMMfEFKhIeAonT2iAuarl
         yEvxf24byihKnLJhRAN76RlGwy2qvOsdWG24ucAT6qKywyRrPuBpvMc650qW+c8oOizb
         SZ3egd3najrDNRgosFF+cOb9xg4R+D/v016E0=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 01/12] cpu-hotplug: introduce cpu_notify(), __cpu_notify(), cpu_notify_nofail()
Date: Thu, 18 Mar 2010 18:05:13 +0900
Message-Id: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change.
These are just wrappers of raw_cpu_notifier_call_chain.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/cpu.c |   55 ++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index f8cced2..bc9c301 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -133,6 +133,26 @@ int __ref register_cpu_notifier(struct notifier_block *nb)
 	return ret;
 }
 
+static int __cpu_notify(unsigned long val, void *v, int nr_to_call,
+			int *nr_calls)
+{
+	return __raw_notifier_call_chain(&cpu_chain, val, v, nr_to_call,
+					nr_calls);
+}
+
+static int cpu_notify(unsigned long val, void *v)
+{
+	return __cpu_notify(val, v, -1, NULL);
+}
+
+static void cpu_notify_nofail(unsigned long val, void *v)
+{
+	int err;
+
+	err = cpu_notify(val, v);
+	BUG_ON(err == NOTIFY_BAD);
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 
 EXPORT_SYMBOL(register_cpu_notifier);
@@ -178,8 +198,7 @@ static int __ref take_cpu_down(void *_param)
 	if (err < 0)
 		return err;
 
-	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
-				param->hcpu);
+	cpu_notify(CPU_DYING | param->mod, param->hcpu);
 
 	/* Force idle task to run as soon as we yield: it should
 	   immediately notice cpu is offline and die quickly. */
@@ -210,14 +229,12 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 
 	cpu_hotplug_begin();
 	set_cpu_active(cpu, false);
-	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
-					hcpu, -1, &nr_calls);
+	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (err == NOTIFY_BAD) {
 		set_cpu_active(cpu, true);
 
 		nr_calls--;
-		__raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
-					  hcpu, nr_calls, NULL);
+		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
 		printk("%s: attempt to take down CPU %u failed\n",
 				__func__, cpu);
 		err = -EINVAL;
@@ -232,9 +249,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	if (err) {
 		set_cpu_active(cpu, true);
 		/* CPU didn't die: tell everyone.  Can't complain. */
-		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
-					    hcpu) == NOTIFY_BAD)
-			BUG();
+		cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
 
 		goto out_allowed;
 	}
@@ -248,9 +263,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	__cpu_die(cpu);
 
 	/* CPU is completely dead: tell everyone.  Too late to complain. */
-	if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD | mod,
-				    hcpu) == NOTIFY_BAD)
-		BUG();
+	cpu_notify_nofail(CPU_DEAD | mod, hcpu);
 
 	check_for_tasks(cpu);
 
@@ -258,11 +271,9 @@ out_allowed:
 	set_cpus_allowed_ptr(current, old_allowed);
 out_release:
 	cpu_hotplug_done();
-	if (!err) {
-		if (raw_notifier_call_chain(&cpu_chain, CPU_POST_DEAD | mod,
-					    hcpu) == NOTIFY_BAD)
-			BUG();
-	}
+	if (!err)
+		cpu_notify_nofail(CPU_POST_DEAD | mod, hcpu);
+
 	free_cpumask_var(old_allowed);
 	return err;
 }
@@ -302,8 +313,7 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 		return -EINVAL;
 
 	cpu_hotplug_begin();
-	ret = __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE | mod, hcpu,
-							-1, &nr_calls);
+	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (ret == NOTIFY_BAD) {
 		nr_calls--;
 		printk("%s: attempt to bring up CPU %u failed\n",
@@ -321,12 +331,11 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 	set_cpu_active(cpu, true);
 
 	/* Now call notifier in preparation. */
-	raw_notifier_call_chain(&cpu_chain, CPU_ONLINE | mod, hcpu);
+	cpu_notify(CPU_ONLINE | mod, hcpu);
 
 out_notify:
 	if (ret != 0)
-		__raw_notifier_call_chain(&cpu_chain,
-				CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
+		__cpu_notify(CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
 	cpu_hotplug_done();
 
 	return ret;
@@ -466,7 +475,7 @@ void __cpuinit notify_cpu_starting(unsigned int cpu)
 	if (frozen_cpus != NULL && cpumask_test_cpu(cpu, frozen_cpus))
 		val = CPU_STARTING_FROZEN;
 #endif /* CONFIG_PM_SLEEP_SMP */
-	raw_notifier_call_chain(&cpu_chain, val, (void *)(long)cpu);
+	cpu_notify(val, (void *)(long)cpu);
 }
 
 #endif /* CONFIG_SMP */
-- 
1.6.0.6

