Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab2FMVKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:10:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46973 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab2FMVKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:10:46 -0400
MIME-Version: 1.0
Date: Wed, 13 Jun 2012 16:10:45 -0500
Message-ID: <CAL5oW025M1rtmf82gMGqi2t39N0Q9taiZt+-bzgw2R2JbsyOkg@mail.gmail.com>
Subject: [PATCH] acpi_pad: fix hang while removing power_saving threads
From: Stuart Hayes <stuart.w.hayes@gmail.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The acpi_pad driver can get stuck in destroy_power_saving_task()
waiting for kthread_stop() to stop a power_saving thread.  The problem
is that the isolated_cpus_lock mutex is owned when
destroy_power_saving_task() calls kthread_stop(), which waits for a
power_saving thread to end, and the power_saving thread tries to
acquire the isolated_cpus_lock when it calls round_robin_cpu().  This
patch fixes the issue by making round_robin_cpu() use its own mutex.

Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
---

--- linux-3.5-rc2/drivers/acpi/acpi_pad.c	2012-06-08 21:40:09.000000000 -0400
+++ linux-3.5-rc2stu/drivers/acpi/acpi_pad.c	2012-06-13 20:14:17.154830840 -0400
@@ -36,6 +36,7 @@
 #define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
 #define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
 static DEFINE_MUTEX(isolated_cpus_lock);
+static DEFINE_MUTEX(round_robin_lock);

 static unsigned long power_saving_mwait_eax;

@@ -107,7 +108,7 @@ static void round_robin_cpu(unsigned int
 	if (!alloc_cpumask_var(&tmp, GFP_KERNEL))
 		return;

-	mutex_lock(&isolated_cpus_lock);
+	mutex_lock(&round_robin_lock);
 	cpumask_clear(tmp);
 	for_each_cpu(cpu, pad_busy_cpus)
 		cpumask_or(tmp, tmp, topology_thread_cpumask(cpu));
@@ -116,7 +117,7 @@ static void round_robin_cpu(unsigned int
 	if (cpumask_empty(tmp))
 		cpumask_andnot(tmp, cpu_online_mask, pad_busy_cpus);
 	if (cpumask_empty(tmp)) {
-		mutex_unlock(&isolated_cpus_lock);
+		mutex_unlock(&round_robin_lock);
 		return;
 	}
 	for_each_cpu(cpu, tmp) {
@@ -131,7 +132,7 @@ static void round_robin_cpu(unsigned int
 	tsk_in_cpu[tsk_index] = preferred_cpu;
 	cpumask_set_cpu(preferred_cpu, pad_busy_cpus);
 	cpu_weight[preferred_cpu]++;
-	mutex_unlock(&isolated_cpus_lock);
+	mutex_unlock(&round_robin_lock);

 	set_cpus_allowed_ptr(current, cpumask_of(preferred_cpu));
 }
